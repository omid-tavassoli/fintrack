package com.fintrack.fintrack.repository;

import com.fintrack.fintrack.dto.CategoryResponse;
import com.fintrack.fintrack.entity.Category;
import com.fintrack.fintrack.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<CategoryResponse> findByUserId(Long userId);
    Optional<Category> findByIdAndUserId(Long id, Long userId);
    Optional<Category> findByNameAndUserId(String name, Long userId);
//    Optional<CategoryResponse> save(CategoryResponse categoryRequest);
}