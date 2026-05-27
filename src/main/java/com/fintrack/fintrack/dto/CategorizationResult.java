package com.fintrack.fintrack.dto;

import com.fintrack.fintrack.entity.Category;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Optional;

@Data
@AllArgsConstructor
public class CategorizationResult {
    private Category category;
    private boolean geminiUsed;
}