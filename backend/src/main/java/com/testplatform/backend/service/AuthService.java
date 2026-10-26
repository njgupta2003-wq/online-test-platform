package com.testplatform.backend.service;

import com.testplatform.backend.dto.LoginRequest;
import com.testplatform.backend.dto.RegisterRequest;
import com.testplatform.backend.dto.UserResponse;
import com.testplatform.backend.entity.Role;
import com.testplatform.backend.entity.User;
import com.testplatform.backend.exception.EmailAlreadyExistsException;
import com.testplatform.backend.exception.InvalidCredentialsException;
import com.testplatform.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserResponse register(RegisterRequest req) {
        if (req.role() == Role.ADMIN) {
            throw new IllegalArgumentException("Cannot self-register as ADMIN");
        }
        if (userRepository.existsByEmail(req.email())) {
            throw new EmailAlreadyExistsException("Email already registered");
        }

        User user = new User();
        user.setName(req.name());
        user.setEmail(req.email());
        user.setPasswordHash(passwordEncoder.encode(req.password()));
        user.setRole(req.role());

        return toResponse(userRepository.save(user));
    }

    public UserResponse login(LoginRequest req) {
        User user = userRepository.findByEmail(req.email())
                .orElseThrow(() -> new InvalidCredentialsException("Invalid email or password"));

        if (!passwordEncoder.matches(req.password(), user.getPasswordHash())) {
            throw new InvalidCredentialsException("Invalid email or password");
        }
        return toResponse(user);
    }

    private UserResponse toResponse(User u) {
        return new UserResponse(u.getId(), u.getName(), u.getEmail(), u.getRole());
    }
}