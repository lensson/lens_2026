package com.lens.platform.gateway.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.WebSession;
import reactor.core.publisher.Mono;

/**
 * Gateway Controller
 * - Provides utility endpoints for token inspection and session info
 *
 * @Author zhenac
 * @Created 5/27/25 11:59 AM
 */

@RestController
@Slf4j
public class GateController {

    /**
     * Get JWT token information from authenticated request
     * Requires valid JWT token in Authorization header
     *
     * @param jwt The JWT token from the authenticated request
     * @return Token details including value, claims, and expiration
     */
    @GetMapping(value = "/token")
    public Mono<TokenInfo> getTokenInfo(@AuthenticationPrincipal Jwt jwt) {
        if (jwt == null) {
            return Mono.just(new TokenInfo(
                false,
                null,
                "No JWT token found. Please authenticate first.",
                null,
                null
            ));
        }

        return Mono.just(new TokenInfo(
            true,
            jwt.getTokenValue(),
            "Token retrieved successfully",
            jwt.getClaims(),
            jwt.getExpiresAt()
        ));
    }

    /**
     * Get raw JWT token value
     * Useful for copying token for testing in other tools
     *
     * @param jwt The JWT token from the authenticated request
     * @return Raw JWT token string
     */
    @GetMapping(value = "/token/raw")
    public Mono<String> getRawToken(@AuthenticationPrincipal Jwt jwt) {
        if (jwt == null) {
            return Mono.just("No token. Please authenticate with valid JWT token in Authorization header.");
        }
        return Mono.just(jwt.getTokenValue());
    }

    /**
     * Get current session ID
     *
     * @param session Current web session
     * @return Session ID
     */
    @GetMapping("/")
    public Mono<String> index(WebSession session) {
        return Mono.just("Gateway Session ID: " + session.getId());
    }

    /**
     * Health check endpoint
     *
     * @return Health status
     */
    @GetMapping("/health")
    public Mono<String> health() {
        return Mono.just("Gateway is running");
    }

    /**
     * Token information response
     */
    public record TokenInfo(
        boolean authenticated,
        String token,
        String message,
        Object claims,
        Object expiresAt
    ) {}
}
