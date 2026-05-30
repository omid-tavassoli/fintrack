package com.fintrack.fintrack.repository;

import com.fintrack.fintrack.entity.UserCategoryRule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserCategoryRuleRepository
        extends JpaRepository<UserCategoryRule, Long> {
    Optional<UserCategoryRule> findByUserIdAndKeyword(Long userId, String keyword);
    List<UserCategoryRule> findByUserId(Long userId);
}