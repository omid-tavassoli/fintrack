package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.CategorizationResult;
import com.fintrack.fintrack.entity.Category;
import com.fintrack.fintrack.entity.GlobalCategoryRule;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.entity.UserCategoryRule;
import com.fintrack.fintrack.repository.CategoryRepository;
import com.fintrack.fintrack.repository.GlobalCategoryRuleRepository;
import com.fintrack.fintrack.repository.UserCategoryRuleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CategorizationService {

    private final UserCategoryRuleRepository userRuleRepo;
    private final GlobalCategoryRuleRepository globalRuleRepo;
    private final CategoryRepository categoryRepo;
    private final GeminiClient geminiClient;
    private final TextNormalizer normalizer;

    public CategorizationResult categorize(User user, String rawDescription) {
        String normalized = normalizer.normalize(rawDescription);

        // 1. user rule
        for (UserCategoryRule rule : userRuleRepo.findByUserId(user.getId())) {
            if (normalized.contains(rule.getKeyword())) {
                return new CategorizationResult(rule.getCategory(), false);
            }
        }
        // 2. global rules
        for (GlobalCategoryRule rule : globalRuleRepo.findAll()) {
            if (normalized.contains(rule.getKeyword())) {
                Optional<Category> category = categoryRepo
                        .findByNameAndUserId(rule.getCategoryName(), user.getId());
                if (category.isPresent()) {
                    return new CategorizationResult(category.get(), false);
                }
            }
        }

        // 3. Gemini fallback
        return new CategorizationResult(
                categorizeWithGemini(user, rawDescription, normalized), true);

    }

    private Category categorizeWithGemini(User user,
                                                    String raw,
                                                    String normalized) {
        List<String> names = categoryRepo.findByUserId(user.getId())
                .stream().map(Category::getName).collect(Collectors.toList());

        String prompt = String.format(
                "Categorize this German bank transaction into exactly one of: %s\n" +
                        "Transaction: %s\n" +
                        "Respond with ONLY the category name, nothing else.",
                names, raw);

        try {
            String response = geminiClient.generateContent(prompt).trim();
            return categoryRepo.findByNameIgnoreCaseAndUserId(
                    response.trim(), user.getId()).orElse(null);
        } catch (Exception e) {
            log.warn("Gemini categorization failed: {}", e.getMessage());
            return null;
        }
    }
}