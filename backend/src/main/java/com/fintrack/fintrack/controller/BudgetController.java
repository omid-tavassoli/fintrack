package com.fintrack.fintrack.controller;

import com.fintrack.fintrack.dto.CreateBudgetRequest;
import com.fintrack.fintrack.entity.Budget;
import com.fintrack.fintrack.entity.Category;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.repository.BudgetRepository;
import com.fintrack.fintrack.repository.CategoryRepository;
import com.fintrack.fintrack.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/budgets")
@RequiredArgsConstructor
public class BudgetController {

    private final BudgetRepository budgetRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    @PostMapping
    public ResponseEntity<?> createBudget(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody CreateBudgetRequest request) {

        User user = userRepository.findByEmail(userDetails.getUsername())
                .orElseThrow(()->new RuntimeException("User not found"));

        Category category = categoryRepository
                .findByNameIgnoreCaseAndUserId(request.getCategoryName(), user.getId())
                .orElseThrow(()->new RuntimeException("Category not found"));

        String[] parts = request.getMonth().split("-");
        int year = Integer.parseInt(parts[0]);
        int month = Integer.parseInt(parts[1]);

        Budget budget = Budget.builder()
                .user(user)
                .category(category)
                .amount(request.getAmount())
                .month(month)
                .year(year)
                .build();

        return ResponseEntity.ok(budgetRepository.save(budget));

    }
}