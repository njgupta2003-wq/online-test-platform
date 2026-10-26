package com.testplatform.backend.dto;

import com.testplatform.backend.entity.Role;

public record UserResponse(Long id, String name, String email, Role role) {}