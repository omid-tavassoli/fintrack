package com.fintrack.fintrack.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Map;

@Data
@AllArgsConstructor
public class MonthlySpendingDTO {
    private String month;
    private BigDecimal total;
    private Map<String, BigDecimal> byCategory;
}