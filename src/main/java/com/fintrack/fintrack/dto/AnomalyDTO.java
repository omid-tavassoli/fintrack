package com.fintrack.fintrack.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@AllArgsConstructor
public class AnomalyDTO {
    private Long transactionId;
    private String description;
    private String counterpart;
    private BigDecimal amount;
    private LocalDate date;
    private String categoryName;
    private String reason;
}