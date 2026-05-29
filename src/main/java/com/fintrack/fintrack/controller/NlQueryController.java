package com.fintrack.fintrack.controller;

import com.fintrack.fintrack.dto.NlQueryRequest;
import com.fintrack.fintrack.dto.NlQueryResponse;
import com.fintrack.fintrack.service.NlQueryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/query")
@RequiredArgsConstructor
public class NlQueryController {

    private final NlQueryService nlQueryService;

    @PostMapping
    public ResponseEntity<NlQueryResponse> query(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody NlQueryRequest request) {
        return ResponseEntity.ok(
                nlQueryService.query(
                        userDetails.getUsername(),
                        request.getQuestion())
        );
    }
}