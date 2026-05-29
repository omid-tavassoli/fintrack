package com.fintrack.fintrack.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
public class BudgetStatusDTO {
    private String categoryName;
    private BigDecimal budgetAmount;
    private BigDecimal spentAmount;
    private double percentageUsed;
    private String status; // GREEN, AMBER, RED
}