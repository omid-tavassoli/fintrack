package com.fintrack.fintrack.controller;

import com.fintrack.fintrack.service.GeminiClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/health")
@RequiredArgsConstructor
public class HealthController {

    private final GeminiClient geminiClient;

    @GetMapping("/gemini")
    public ResponseEntity<Map<String, String>> getGemini() {
        try{
            String response = geminiClient.generateContent(
                    "reply with exacly : ok");
            boolean working = response.trim().contains("ok");
            return ResponseEntity.ok(Map.of(
                    "status", working ? "up" : "degraded",
                    "model", "gemini-2.5.flash",
                    "response", response.trim()
            ));
        }catch (Exception e){
            return ResponseEntity.status(503).body(Map.of(
                    "status", "Down",
                    "error", e.getMessage()));
        }
    }
}