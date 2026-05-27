package com.fintrack.fintrack.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class IngestionSummary {
    private int imported;
    private int skipped;
    private int categorized;
    private int uncategorized;
    private int geminiCalls;
}