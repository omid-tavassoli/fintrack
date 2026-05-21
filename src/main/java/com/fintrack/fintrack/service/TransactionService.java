package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.TransactionResponse;
import com.fintrack.fintrack.dto.UpdateCategoryRequest;
import com.fintrack.fintrack.entity.Category;
import com.fintrack.fintrack.entity.Transaction;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.entity.UserCategoryRule;
import com.fintrack.fintrack.repository.CategoryRepository;
import com.fintrack.fintrack.repository.TransactionRepository;
import com.fintrack.fintrack.repository.UserCategoryRuleRepository;
import com.fintrack.fintrack.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collector;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final UserCategoryRuleRepository userCategoryRuleRepository;

    public List<TransactionResponse> getUserTransactions(String email) {
        User user =  userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return transactionRepository
                .findByUserIdOrderByTransactionDateDesc(user.getId())
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public TransactionResponse updateCategory(String email,
                                              Long transactionId,
                                              UpdateCategoryRequest request) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Transaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new RuntimeException("Transaction not found"));

        if(!transaction.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("unauthorized request");
        }

        Category category = categoryRepository
                .findByIdAndUserId(request.getCategoryId(), user.getId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        transaction.setCategory(category);
        transactionRepository.save(transaction);

        String keyword = transaction.getDescription() != null
                ?transaction.getDescription().toLowerCase().trim()
                : "";

        if (!keyword.isBlank()) {
            userCategoryRuleRepository
                    .findByUserIdAndKeyword(user.getId(), keyword)
                    .ifPresentOrElse(
                            existing -> {
                                existing.setCategory(category);
                                userCategoryRuleRepository.save(existing);
                            },
                            () -> userCategoryRuleRepository.save(
                                    UserCategoryRule.builder()
                                            .user(user)
                                            .category(category)
                                            .keyword(keyword)
                                            .build())
                    );
        }

        return toResponse(transaction);
    }

    private TransactionResponse toResponse(Transaction transaction) {
        return TransactionResponse.builder()
                .id(transaction.getId())
                .description(transaction.getDescription())
                .counterpart(transaction.getCounterpart())
                .amount(transaction.getAmount())
                .type(transaction.getType().name())
                .transactionDate(transaction.getTransactionDate())
                .categoryName(transaction.getCategory() != null
                    ? transaction.getCategory().getName() :null)
                .categoryId(transaction.getCategory() != null
                    ? transaction.getCategory().getId() : null)
                .isAnomaly(transaction.isAnomaly())
                .geminiUsed(transaction.isGeminiUsed())
                .build();
    }
}