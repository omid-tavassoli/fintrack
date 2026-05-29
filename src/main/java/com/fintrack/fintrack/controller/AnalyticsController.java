package com.fintrack.fintrack.controller;

import com.fintrack.fintrack.dto.AnomalyDTO;
import com.fintrack.fintrack.dto.BudgetStatusDTO;
import com.fintrack.fintrack.dto.MonthlySpendingDTO;
import com.fintrack.fintrack.entity.Budget;
import com.fintrack.fintrack.service.AnalyticsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/analytics")
@RequiredArgsConstructor
public class AnalyticsController {

    private final AnalyticsService analyticsService;

    @GetMapping("/monthly")
    public ResponseEntity<List<MonthlySpendingDTO>> monthly(
            @AuthenticationPrincipal UserDetails userDetails){
        return ResponseEntity.ok(
                analyticsService.getMonthlySpending(userDetails.getUsername()));
    }

    @GetMapping("/categories")
    public ResponseEntity<Map<String, BigDecimal>>  categories(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam String month){
        return ResponseEntity.ok(
                analyticsService.getCategoryBreakdown(
                        userDetails.getUsername(), month
                )
        );
    }

    @GetMapping("/budget")
    public ResponseEntity<List<BudgetStatusDTO>> budgets(
            @AuthenticationPrincipal UserDetails userDetails){
        return ResponseEntity.ok(
                analyticsService.getBudgetStatus(userDetails.getUsername())
        );
    }

    @GetMapping("/anomalies")
    public ResponseEntity<List<AnomalyDTO>> anomalies(
            @AuthenticationPrincipal UserDetails userDetails){
        return ResponseEntity.ok(
                analyticsService.getAnomalies(userDetails.getUsername()));
    }


}