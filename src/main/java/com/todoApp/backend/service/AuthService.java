package com.todoApp.backend.service;

import com.todoApp.backend.dto.*;
import com.todoApp.backend.entity.User;
import com.todoApp.backend.repository.UserRepository;
import com.todoApp.backend.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import javax.sql.DataSource;
import java.sql.*;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;
    private final DataSource dataSource;

    public String register(RegisterDto dto) {
        if (userRepository.findByEmail(dto.getEmail()).isPresent())
            throw new IllegalArgumentException("Email already exists");

        // Create unique schema name
        String schemaName = "user_" + UUID.randomUUID()
                .toString().replace("-", "").substring(0, 10);

        // Create schema + tasks table in PostgreSQL
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement()) {

            stmt.execute("CREATE SCHEMA IF NOT EXISTS " + schemaName);
            stmt.execute("""
                CREATE TABLE IF NOT EXISTS %s.tasks (
                    id BIGSERIAL PRIMARY KEY,
                    task VARCHAR(255) UNIQUE,
                    is_completed BOOLEAN DEFAULT FALSE,
                    due_date DATE,
                    description VARCHAR(500)
                )
            """.formatted(schemaName));

        } catch (SQLException e) {
            throw new RuntimeException("Schema creation failed: " + e.getMessage());
        }

        User user = new User();
        user.setEmail(dto.getEmail());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setSchemaName(schemaName);
        userRepository.save(user);

        return jwtUtil.generateToken(dto.getEmail(), schemaName);
    }

    public String login(LoginDto dto) {
        User user = userRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));

        if (!passwordEncoder.matches(dto.getPassword(), user.getPassword()))
            throw new IllegalArgumentException("Invalid credentials");

        return jwtUtil.generateToken(dto.getEmail(), user.getSchemaName());
    }
}