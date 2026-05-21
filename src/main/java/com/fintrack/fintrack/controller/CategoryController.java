package com.fintrack.fintrack.controller;

import com.fintrack.fintrack.dto.CategoryRequest;
import com.fintrack.fintrack.dto.CategoryResponse;
import com.fintrack.fintrack.entity.Category;
import com.fintrack.fintrack.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    public ResponseEntity<List<CategoryResponse>> getAllCategories(
            @AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(
                categoryService.getUserCategories(userDetails.getUsername())
        );
    }

    @PostMapping
    public ResponseEntity<CategoryResponse> createCategories(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody CategoryRequest categoryRequest) {
        return ResponseEntity.ok(
                categoryService.createCategory(
                        userDetails.getUsername(), categoryRequest)
        );
    }
}