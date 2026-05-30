package com.fintrack.fintrack.dto;

import lombok.Data;

@Data
public class RegisterRequest {
    private String email;
    private String password;
}