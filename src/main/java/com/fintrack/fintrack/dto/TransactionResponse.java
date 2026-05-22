package com.fintrack.fintrack.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TransactionResponse {
    private Long id;
    private String description;
    private String counterpart;
    private BigDecimal amount;
    private String type;
    private LocalDate transactionDate;
    private String categoryName;
    private Long categoryId;
    private boolean isAnomaly;
    private boolean geminiUsed;
}