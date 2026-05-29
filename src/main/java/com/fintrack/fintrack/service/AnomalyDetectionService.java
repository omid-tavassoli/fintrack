package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.AnomalyDTO;
import com.fintrack.fintrack.entity.Transaction;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class AnomalyDetectionService {

    private final TransactionRepository transactionRepo;

    public List<AnomalyDTO> detectAnomalies(User user) {
        List<Transaction> transactions = transactionRepo
                .findByUserIdOrderByTransactionDateDesc(user.getId());

        // group amounts by category
        Map<String, List<Double>> categoryAmounts = new HashMap<>();
        for (Transaction t : transactions) {
            if (t.getCategory() == null || t.getAmount().compareTo(BigDecimal.ZERO) >= 0)
                continue;
            String cat = t.getCategory().getName();
            categoryAmounts.computeIfAbsent(cat, k -> new ArrayList<>())
                    .add(t.getAmount().abs().doubleValue());
        }

        // compute mean and std dev per category
        Map<String, double[]> stats = new HashMap<>();
        categoryAmounts.forEach((cat, amounts) -> {
            if (amounts.size() < 3) return; // need at least 3 data points
            double mean = amounts.stream()
                    .mapToDouble(Double::doubleValue).average().orElse(0);
            double variance = amounts.stream()
                    .mapToDouble(a -> Math.pow(a - mean, 2))
                    .average().orElse(0);
            double stdDev = Math.sqrt(variance);
            stats.put(cat, new double[]{mean, stdDev});
        });

        // flag transactions with z-score > 2.5
        List<AnomalyDTO> anomalies = new ArrayList<>();
        for (Transaction t : transactions) {
            if (t.getCategory() == null || t.getAmount().compareTo(BigDecimal.ZERO) >= 0)
                continue;

            String cat = t.getCategory().getName();
            if (!stats.containsKey(cat)) continue;

            double[] s = stats.get(cat);
            double mean = s[0], stdDev = s[1];
            if (stdDev == 0) continue;

            double zScore = (t.getAmount().abs().doubleValue() - mean) / stdDev;

            if (zScore > 2.5) {
                String reason = String.format(
                        "%.2fx above average for %s (avg: €%.2f)",
                        t.getAmount().abs().doubleValue() / mean, cat, mean);

                anomalies.add(new AnomalyDTO(
                        t.getId(),
                        t.getDescription(),
                        t.getCounterpart(),
                        t.getAmount(),
                        t.getTransactionDate(),
                        cat,
                        reason
                ));

                // mark in DB
                t.setAnomaly(true);
                transactionRepo.save(t);
            }
        }

        return anomalies;
    }
}