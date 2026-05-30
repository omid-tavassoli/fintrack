package com.fintrack.fintrack.dto;

import com.fintrack.fintrack.entity.TransactionType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParsedTransaction {
    private LocalDate date;
    private BigDecimal amount;
    private String description;
    private String counterpart;
}