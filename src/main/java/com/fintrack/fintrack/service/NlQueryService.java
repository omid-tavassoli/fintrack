package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.NlQueryRequest;
import com.fintrack.fintrack.dto.NlQueryResponse;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.repository.UserRepository;
import com.fintrack.fintrack.service.GeminiClient;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
@RequiredArgsConstructor
@Slf4j
public class NlQueryService {

    private final GeminiClient geminiClient;
    private final UserRepository userRepository;

    @PersistenceContext
    private EntityManager entityManager;

    private static final String SCHEMA_CONTEXT = """
            Database schema for a personal finance tracker:
            
            transactions(id, user_id, category_id, amount DECIMAL,
                         description VARCHAR, counterpart VARCHAR,
                         transaction_date DATE, hash VARCHAR,
                         is_anomaly BOOLEAN, gemini_used BOOLEAN)
            - amount is negative for money spent, positive for money received
    
            categories(id, user_id, name VARCHAR)
            - examples: Groceries, Restaurants, Transport, Subscriptions,
                        Health, Shopping, Rent & Utilities, Entertainment,
                        Donations, University, Transfers, Other
    
            budgets(id, user_id, category_id, amount DECIMAL, month INT, year INT)
            """;
    public NlQueryResponse query(String emil, String question){
        User user = userRepository.findByEmail(emil)
                .orElseThrow(()->new RuntimeException("User not found"));

        String sqlQuery = generateSql(question, user.getId());
        List<Map<String, Object>> data = executeSql(sqlQuery, user.getId());
        String answer = generateAnswer(question, data);

        return new NlQueryResponse(question, answer, data);
    }

    private String generateSql(String question, Long userId) {
        String prompt = String.format("""
            You are a SQL query generator for a personal finance app.
            
            %s
            
            User ID: %d
            
            Generate a PostgreSQL SELECT query to answer this question:
            "%s"
            
            Rules:
            - ALWAYS filter by user_id = %d for security
            - Only generate SELECT statements, never INSERT/UPDATE/DELETE
            - Use table aliases for readability
            - For amounts, remember negative = spent, positive = received
            - Return ONLY the SQL query, no explanation, no markdown
            - Limit results to 50 rows maximum
            """, SCHEMA_CONTEXT, userId, question, userId);

        String sql = geminiClient.generateContent(prompt).trim();

        if (sql.startsWith("```")) {
            sql = sql.replaceAll("```sql", "")
                    .replaceAll("```", "")
                    .trim();
        }

        if (!sql.toUpperCase().startsWith("SELECT")) {
            throw new RuntimeException("Only SELECT queries are allowed");
        }

        return sql;
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> executeSql(String sql, Long userId) {
        try {
            Query query = entityManager.createNativeQuery(sql);
            query.unwrap(org.hibernate.query.NativeQuery.class)
                    .setResultTransformer(
                            org.hibernate.transform.AliasToEntityMapResultTransformer.INSTANCE
                    );

            return (List<Map<String, Object>>) query.getResultList();
        }catch (Exception e){
            log.error("SQL execution failed: {}", e.getMessage());
            throw new RuntimeException("Query execution failed: " + e.getMessage());
        }
    }

    private String generateAnswer(
            String question,
            List<Map<String, Object>> data) {
        if(data.isEmpty()){
            return "No data found for your question.";
        }

        String prompt = String.format("""
            The user asked: "%s"
            
            The query returned this data: %s
            
            Write a natural, conversational answer in 1-2 sentences.
            Use euros (€) for amounts. Be specific with numbers.
            Respond in the same language the question was asked in.
            """, question, data);

        return geminiClient.generateContent(prompt).trim();
    }
}