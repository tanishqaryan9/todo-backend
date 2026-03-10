package com.todoApp.backend.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class RegisterDto {
    private String email;
    private String password;
}