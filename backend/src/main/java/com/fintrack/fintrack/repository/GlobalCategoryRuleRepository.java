package com.fintrack.fintrack.repository;

import com.fintrack.fintrack.entity.GlobalCategoryRule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GlobalCategoryRuleRepository
        extends JpaRepository<GlobalCategoryRule, Long> {
    Optional<GlobalCategoryRule> findByKeyword(String keyword);
    List<GlobalCategoryRule> findAll();
}