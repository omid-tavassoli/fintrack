package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.CategorizationResult;
import com.fintrack.fintrack.dto.IngestionSummary;
import com.fintrack.fintrack.dto.ParsedTransaction;
import com.fintrack.fintrack.entity.Transaction;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.repository.CategoryRepository;
import com.fintrack.fintrack.repository.TransactionRepository;
import com.fintrack.fintrack.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class PdfIngestionService {

    private final GeminiPdfExtractor extractor;
    private final CategorizationService categorizationService;
    private final TransactionRepository transactionRepo;
    private final UserRepository userRepo;

    public IngestionSummary ingest(String email, MultipartFile file)throws IOException {

        User user = userRepo.findByEmail(email)
                .orElseThrow(()->new IllegalArgumentException("User not found"));

        List<ParsedTransaction> parsed = extractor.extract(file.getBytes());

        int     imported = 0,
                skipped = 0,
                categorized = 0,
                uncategorized = 0,
                geminiCalls = 0;

        for (ParsedTransaction pt : parsed) {
            String hash = generateHash(pt);

            if (transactionRepo.existsByHash(hash)) {
                skipped++;
                continue;
            }

            CategorizationResult result =
                    categorizationService.categorize(user, pt.getDescription());

            if(result.isGeminiUsed())   geminiCalls++;

            Transaction transaction = Transaction.builder()
                    .user(user)
                    .amount(pt.getAmount())
                    .description(pt.getDescription())
                    .counterpart(pt.getCounterpart())
                    .transactionDate(pt.getDate())
                    .hash(hash)
                    .category(result.getCategory())
                    .geminiUsed(result.isGeminiUsed())
                    .isAnomaly(false)
                    .build();

            transactionRepo.save(transaction);
            imported++;

            if(result.getCategory() != null) categorized++;
            else uncategorized++;
        }

        log.info("Ingestion complete: {} imported, {} skipped, " +
                        "{} categorized, {} gemini calls",
                imported, skipped, categorized, geminiCalls);

        return new IngestionSummary(
                imported, skipped, categorized, uncategorized, geminiCalls);

    }

    private String generateHash(ParsedTransaction pt) {
        String raw = pt.getDate() + "|" + pt.getAmount() + "|" +
                pt.getDescription();
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(
                    raw.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available");
        }
    }
}