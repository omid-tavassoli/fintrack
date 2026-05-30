package com.fintrack.fintrack.repository;

import com.fintrack.fintrack.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    List<Transaction> findByUserIdOrderByTransactionDateDesc(Long userId);
    boolean existsByHash(String hash);
    List<Transaction> findByUserIdAndCategoryId(Long userId, Long categoryId);

    @Query("SELECT FUNCTION('TO_CHAR', t.transactionDate, 'YYYY-MM') as month, " +
            "SUM(t.amount) as total " +
            "FROM Transaction t " +
            "WHERE t.user.id = :userId AND t.amount < 0 " +
            "GROUP BY FUNCTION('TO_CHAR', t.transactionDate, 'YYYY-MM') " +
            "ORDER BY month DESC")
    List<Object[]> findMonthlySpending(@Param("userId") Long userId);

    @Query("SELECT c.name, SUM(t.amount) as total " +
            "FROM Transaction t JOIN t.category c " +
            "WHERE t.user.id = :userId " +
            "AND FUNCTION('TO_CHAR', t.transactionDate, 'YYYY-MM') = :month " +
            "AND t.amount < 0 " +
            "GROUP BY c.name " +
            "ORDER BY total ASC")
    List<Object[]> findSpendingByCategory(
            @Param("userId") Long userId,
            @Param("month") String month);

    @Query("SELECT t FROM Transaction t " +
            "WHERE t.user.id = :userId " +
            "AND t.transactionDate >= :from " +
            "AND t.transactionDate <= :to " +
            "ORDER BY t.transactionDate DESC")
    List<Transaction> findByUserIdAndDateRange(
            @Param("userId") Long userId,
            @Param("from") LocalDate from,
            @Param("to") LocalDate to);
}