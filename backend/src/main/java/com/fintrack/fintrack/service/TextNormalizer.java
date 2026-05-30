package com.fintrack.fintrack.service;

import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class TextNormalizer {
    private static final List<String> BOILERPLATE = List.of(
            "kartenzahlung", "verwendungszweck", "kundenreferenz",
            "sepa", "lastschrifteinzug", "echtzeitüberweisung",
            "überweisung", "wiederholungslastschrift", "rcur",
            "folgenr", "kartennr", "verfalld", "ratenplan",
            "gläubiger-id", "mand-id", "notprovided",
            "von", "an", "ihr", "einkauf", "bei"
    );

    private static final List<String> PATTERNS = List.of(
            "\\d{2}\\.\\d{2}\\.\\d{4}",
            "T\\d{2}:\\d{2}:\\d{2}",
            "[A-Z]{2}\\d{2}[A-Z0-9]{10,}",
            "[A-Z]{6}[A-Z0-9]{2,}",
            "\\d{8,}",
            "//[A-Z]{2}"
    );

    public String normalize(String raw) {
        if (raw == null || raw.isBlank()) return "";
        String result = raw.toLowerCase();
        for (String pattern : PATTERNS) {
            result = result.replaceAll(pattern, " ");
        }
        for (String word : BOILERPLATE) {
            result = result.replace(word, " ");
        }
        result = result.replaceAll("[^a-züöäß\\s]", " ");
        return result.replaceAll("\\s+", " ").trim();
    }
}