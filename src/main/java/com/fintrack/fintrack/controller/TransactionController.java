package com.fintrack.fintrack.controller;

import com.fintrack.fintrack.dto.TransactionResponse;
import com.fintrack.fintrack.dto.UpdateCategoryRequest;
import com.fintrack.fintrack.service.TransactionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/transactions")
@RequiredArgsConstructor
public class TransactionController {

    private final TransactionService transactionService;

    @GetMapping
    public ResponseEntity<List<TransactionResponse>> getTransactions(
            @AuthenticationPrincipal UserDetails userDetails)
    {
        return ResponseEntity.ok(
                transactionService.getUserTransactions(
                        userDetails.getUsername()
                )
        );

    }

    @PatchMapping("/{id}/category")
    public ResponseEntity<TransactionResponse> updateCategory(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id,
            @RequestBody UpdateCategoryRequest request)
    {
        return ResponseEntity.ok(
                transactionService.updateCategory(
                        userDetails.getUsername(), id, request)
        );
    }
}