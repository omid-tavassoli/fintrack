package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.AnomalyDTO;
import com.fintrack.fintrack.dto.BudgetStatusDTO;
import com.fintrack.fintrack.dto.MonthlySpendingDTO;
import com.fintrack.fintrack.entity.Budget;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.repository.BudgetRepository;
import com.fintrack.fintrack.repository.CategoryRepository;
import com.fintrack.fintrack.repository.TransactionRepository;
import com.fintrack.fintrack.repository.UserRepository;
import com.fintrack.fintrack.service.AnomalyDetectionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AnalyticsService {

    private final TransactionRepository transactionRepository;
    private final BudgetRepository budgetRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final AnomalyDetectionService anomalyDetectionService;

    public List<MonthlySpendingDTO> getMonthlySpending(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<Object[]> rows = transactionRepository.findMonthlySpending(user.getId());
        List<MonthlySpendingDTO> monthlySpendingDTOs = new ArrayList<>();

        for (Object[] row : rows) {
            String month = (String) row[0];
            BigDecimal amount = (BigDecimal) row[1];

            List<Object[]> catRows = transactionRepository
                    .findSpendingByCategory(user.getId(), month);

            Map<String, BigDecimal> byCategory = new LinkedHashMap<>();
            for (Object[] catRow : catRows) {
                byCategory.put((String) catRow[0], (BigDecimal) catRow[1]);
            }

            monthlySpendingDTOs.add(new MonthlySpendingDTO(month, amount, byCategory));
        }

        return monthlySpendingDTOs;
    }

    public List<BudgetStatusDTO> getBudgetStatus(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear();

        List<Budget> budgets = budgetRepository
                .findByUserIdAndMonthAndYear(user.getId(), month, year);

        List<BudgetStatusDTO> budgetStatusDTOs = new ArrayList<>();
        for (Budget budget : budgets) {
            List<Object[]> spending = transactionRepository.findSpendingByCategory(
                    user.getId(),String.format("%d-%02d", month, year));

            BigDecimal spent = spending.stream()
                    .filter(r -> r[0].equals(budget.getCategory().getName()))
                    .map(r -> ((BigDecimal) r[1]).abs())
                    .findFirst()
                    .orElse(BigDecimal.ZERO);

            double pct = spent.divide(budget.getAmount(),
                    4, RoundingMode.HALF_UP)
                    .multiply(BigDecimal.valueOf(100))
                    .doubleValue();

            String status = pct < 75 ? "GREEN" : pct < 100 ? "AMber" : "RED";

            budgetStatusDTOs.add(new BudgetStatusDTO(
                    budget.getCategory().getName(),
                    budget.getAmount(),
                    spent,
                    pct,
                    status
            ));
        }

        return budgetStatusDTOs;
    }

    public List<AnomalyDTO> getAnomalies(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return anomalyDetectionService.detectAnomalies(user);
    }

    public Map<String, BigDecimal> getCategoryBreakdown(
            String email, String month) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<Object[]> rows = transactionRepository
                .findSpendingByCategory(user.getId(), month);

        Map<String, BigDecimal> result = new LinkedHashMap<>();
        for (Object[] row : rows) {
            result.put((String) row[0], ((BigDecimal) row[1]).abs());
        }
        return result;
    }
}