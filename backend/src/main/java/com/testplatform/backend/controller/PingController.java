package com.testplatform.backend.controller;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class PingController {

    @GetMapping("/api/me")
    public Map<String, String> me(Authentication authentication) {
        return Map.of(
                "email", authentication.getName(),
                "authorities", authentication.getAuthorities().toString());
    }

    @GetMapping("/api/student/ping")
    public Map<String, String> studentPing() {
        return Map.of("message", "student area");
    }

    @GetMapping("/api/host/ping")
    public Map<String, String> hostPing() {
        return Map.of("message", "host area");
    }

    @GetMapping("/api/admin/ping")
    public Map<String, String> adminPing() {
        return Map.of("message", "admin area");
    }
}