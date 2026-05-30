package com.fintrack.fintrack.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@AllArgsConstructor
public class NlQueryResponse {
    private String question;
    private String answer;
    private List<Map<String, Object>> data;
}