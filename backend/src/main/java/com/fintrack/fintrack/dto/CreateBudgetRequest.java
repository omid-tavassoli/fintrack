package com.fintrack.fintrack.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CreateBudgetRequest {
    private String categoryName;
    private BigDecimal amount;
    private String month;
}