package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.ParsedTransaction;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class GeminiPdfExtractor {
    private final GeminiClient geminiClient;
    private final Gson gson =  new Gson();

    public List<ParsedTransaction> extract(byte[] pdfBytes) {
        String prompt = """
            Extract all transactions from this bank statement PDF.
            Return ONLY a JSON array, no markdown, no explanation.
            Each object must have exactly these fields:
            {
              "date": "YYYY-MM-DD",
              "amount": 12.50,
              "description": "raw transaction description",
              "counterpart": "merchant or sender name",
            }
            Rules:
            - amount is negative if money left the account, positive if money entered
            - date must be in YYYY-MM-DD format
            - description is the full raw transaction text
            - counterpart is the merchant, recipient, or sender name
            - if counterpart is not clear, use "Unknown"
            - return empty array [] if no transactions found
            """;

        String response = geminiClient.generateContentWithPdf(prompt, pdfBytes);
        return parseJsonResponse(response);
    }

    private List<ParsedTransaction> parseJsonResponse(String json) {
        try {
            String cleaned = json.trim();
            if(cleaned.startsWith("```")) {
                cleaned = cleaned
                        .replaceAll("```json", "")
                        .replaceAll("```", "")
                        .trim();
            }

            JsonArray Array = gson.fromJson(cleaned, JsonArray.class);
            List<ParsedTransaction> parsedTransactions = new ArrayList<>();

            for (JsonElement jsonElement : Array) {
                JsonObject obj = jsonElement.getAsJsonObject();
                try{
                    LocalDate date = LocalDate.parse(obj.get("date").getAsString());
                    BigDecimal amount = obj.get("amount").getAsBigDecimal();
                    String description = obj.get("description").getAsString();
                    String counterpart = obj.has("counterpart")
                            ? obj.get("counterpart").getAsString() : "";

                    parsedTransactions.add(ParsedTransaction
                            .builder()
                                    .date(date)
                                    .amount(amount)
                                    .description(description)
                                    .counterpart(counterpart)
                            .build());
                } catch (Exception e) {
                    log.warn("Skipping malformed transaction: {}", e.getMessage());
                }
            }
            return parsedTransactions;
        } catch (Exception e) {
            log.error("Failed to parse Gemini extraction response: {}", json);
            throw new RuntimeException("PDF extraction failed: " + e.getMessage());
        }
    }
}