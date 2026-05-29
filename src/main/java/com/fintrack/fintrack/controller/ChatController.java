package com.fintrack.fintrack.controller;

import com.fintrack.fintrack.dto.ChatRequest;
import com.fintrack.fintrack.dto.ChatResponse;
import com.fintrack.fintrack.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    @PostMapping
    public ResponseEntity<ChatResponse> chat(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody ChatRequest chatRequest) {
        return ResponseEntity.ok(
                chatService.chat(
                        userDetails.getUsername(), chatRequest));
    }
}