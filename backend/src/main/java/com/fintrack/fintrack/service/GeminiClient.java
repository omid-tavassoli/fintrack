package com.fintrack.fintrack.service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.Duration;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Supplier;

@Service
@Slf4j
public class GeminiClient {

    private final WebClient webClient;
    private final Gson gson;

    @Value("${gemini.api-key}")
    private String apiKey;

    @Value("${gemini.model}")
    private String model;

    private static final String GEMINI_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent";

    public GeminiClient(WebClient webClient) {
        this.webClient = webClient;
        this.gson = new Gson();
    }

    public String generateContent(String prompt) {
        Map<String, Object> requestBody = Map.of(
                "contents", List.of(
                        Map.of("parts", List.of(
                                Map.of("text", prompt)
                        ))
                )
        );

        return executeWithRetry(() -> {
            String response = webClient.post()
                    .uri(GEMINI_URL, model)
                    .header("x-goog-api-key", apiKey)
                    .header("content-type", "application/json")
                    .bodyValue(requestBody)
                    .retrieve()
                    .bodyToMono(String.class)
                    .timeout(Duration.ofSeconds(30))
                    .block();

            return extractText(response);
        });
    }

    public String generateContentWithPdf(String prompt, byte[] pdfBytes) {
        String base64Pdf = Base64.getEncoder().encodeToString(pdfBytes);

        Map<String, Object> requestBody = Map.of(
                "contents", List.of(
                        Map.of("parts", List.of(
                                Map.of(
                                        "inline_data", Map.of(
                                                "mime_type", "application/pdf",
                                                "data", base64Pdf
                                        )
                                ),
                                Map.of("text", prompt)
                        ))
                )
        );

        return executeWithRetry( ()-> {
            String response = webClient.post()
                    .uri(GEMINI_URL, model)
                    .header("x-goog-api-key", apiKey)
                    .header("Content-Type", "application/json")
                    .bodyValue(requestBody)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            return extractText(response);
        });
    }

    private String extractText(String rawResponse) {
        try {
            JsonObject root = gson.fromJson(rawResponse, JsonObject.class);
            return root
                    .getAsJsonArray("candidates")
                    .get(0).getAsJsonObject()
                    .getAsJsonObject("content")
                    .getAsJsonArray("parts")
                    .get(0).getAsJsonObject()
                    .get("text").getAsString();
        } catch (Exception e) {
            log.error("Failed to parse Gemini response: {}", rawResponse);
            throw new RuntimeException("Gemini response parsing failed");
        }
    }

    private String executeWithRetry(Supplier<String> apiCall) {
        int maxRetries = 3;
        for (int attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                return apiCall.get();
            } catch (Exception e) {
                if (attempt == maxRetries) throw e;
                try {
                    Thread.sleep(2000L * attempt);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    throw new RuntimeException("Interrupted during retry");
                }
                log.warn("Gemini attempt {} failed, retrying...", attempt, e.getMessage());
            }
        }
        throw new RuntimeException("Gemini unavailable after retries");
    }

}