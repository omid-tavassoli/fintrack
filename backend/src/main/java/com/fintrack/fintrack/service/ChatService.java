package com.fintrack.fintrack.service;

import com.fintrack.fintrack.dto.ChatMessage;
import com.fintrack.fintrack.dto.ChatRequest;
import com.fintrack.fintrack.dto.ChatResponse;
import com.fintrack.fintrack.dto.NlQueryResponse;
import com.fintrack.fintrack.entity.User;
import com.fintrack.fintrack.repository.UserRepository;
import com.fintrack.fintrack.service.GeminiClient;
import com.fintrack.fintrack.service.NlQueryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatService {

    private final GeminiClient geminiClient;
    private final NlQueryService nlQueryService;
    private final UserRepository userRepo;

    public ChatResponse chat(String email, ChatRequest request) {
        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // build conversation history for context
        StringBuilder historyContext = new StringBuilder();
        if (request.getHistory() != null && !request.getHistory().isEmpty()) {
            for (ChatMessage msg : request.getHistory()) {
                historyContext.append(msg.getRole())
                        .append(": ")
                        .append(msg.getContent())
                        .append("\n");
            }
        }

        // decide if this needs a data query or just conversation
        String routingPrompt = String.format("""
            You are a personal finance assistant.
            
            Conversation so far:
            %s
            
            New message: "%s"
            
            Does this message require querying financial data to answer?
            Reply with exactly "QUERY" or "CHAT", nothing else.
            """, historyContext, request.getMessage());

        String routing = geminiClient.generateContent(routingPrompt).trim();

        if (routing.equals("QUERY")) {
            // use NL query engine for data questions
            try {
                NlQueryResponse queryResult = nlQueryService.query(
                        email, request.getMessage());
                return new ChatResponse(queryResult.getAnswer(),
                        queryResult.getData());
            } catch (Exception e) {
                log.warn("Query failed, falling back to chat: {}", e.getMessage());
            }
        }

        // pure conversation — recommendations, advice, general questions
        String chatPrompt = String.format("""
            You are a helpful personal finance assistant for a German user.
            You help users understand their spending and make better
            financial decisions.
            
            Conversation so far:
            %s
            
            User: %s
            
            Give a helpful, concise response in the same language
            the user is writing in. If they write in German, respond
            in German. Keep responses under 3 sentences unless more
            detail is needed.
            """, historyContext, request.getMessage());

        String response = geminiClient.generateContent(chatPrompt).trim();
        return new ChatResponse(response, null);
    }
}