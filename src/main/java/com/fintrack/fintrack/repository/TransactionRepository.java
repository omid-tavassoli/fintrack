package com.fintrack.fintrack.repository;

import com.fintrack.fintrack.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    List<Transaction> findByUserIdOrderByTransactionDateDesc(Long userId);
    boolean existsByHash(String hash);
    List<Transaction> findByUserIdAndCategoryId(Long userId, Long categoryId);
}