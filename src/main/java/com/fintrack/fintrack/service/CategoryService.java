package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.CategoryRequest;
import com.fintrack.fintrack.dto.CategoryResponse;
import com.fintrack.fintrack.entity.Category;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.repository.CategoryRepository;
import com.fintrack.fintrack.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    public CategoryResponse createCategory(String email, CategoryRequest request) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Category saved = categoryRepository.save(
                Category.builder()
                        .name(request.getName())
                        .user(user)
                        .build()
        );

        return toResponse(saved);
    }

    public List<CategoryResponse> getUserCategories(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return categoryRepository.findByUserId(user.getId());
    }

    private CategoryResponse toResponse(Category category) {
        return CategoryResponse.builder()
                .id(category.getId())
                .name(category.getName())
                .build();
    }
}