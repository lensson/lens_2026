package com.lens.platform.gateway.config.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.oauth2.jwt.NimbusReactiveJwtDecoder;
import org.springframework.security.oauth2.jwt.ReactiveJwtDecoder;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.http.HttpStatus;
import org.springframework.security.web.server.authentication.HttpStatusServerEntryPoint;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

/**
 * Gateway Security Configuration
 * - OAuth2 Resource Server with JWT
 * - TokenRelay filter for downstream services
 *
 * @Author zhenac
 * @Created 5/26/25 11:21 AM
 */

@Configuration
@EnableWebFluxSecurity
public class SecurityConfig {

    @Value("${spring.security.oauth2.resourceserver.jwt.jwk-set-uri}")
    private String jwkSetUri;

    @Bean
    public SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http){
        http
            .authorizeExchange(auth -> auth
                // Public endpoints - proxied swagger UI for platform services
                .pathMatchers("/v2/lens/platform/*/swagger-ui.html", "/v2/lens/platform/*/swagger-ui/**", "/v2/lens/platform/*/v3/api-docs/**").permitAll()
                // Public endpoints - proxied swagger UI for migration service
                .pathMatchers("/v2/lens/migration/swagger-ui.html", "/v2/lens/migration/swagger-ui/**", "/v2/lens/migration/v3/api-docs/**").permitAll()
                // Public endpoints - gateway's own Swagger UI (must be accessible without login)
                .pathMatchers("/actuator/**", "/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/webjars/**").permitAll()
                // Login and OAuth2 endpoints
                .pathMatchers("/login/**", "/oauth2/**", "/logout").permitAll()
                // API paths should require authentication
                .pathMatchers("/v2/**").authenticated()
                // All other requests require authentication
                .anyExchange().authenticated()
            )
            // Enable OAuth2 Login so the gateway can handle the authorization code callback
            // This will allow the gateway to exchange the authorization code for tokens and
            // establish a session cookie for browser clients.
            .oauth2Login();

        // OAuth2 Resource Server - for JWT token validation from Swagger UI and APIs
        http.oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt.jwtDecoder(jwtDecoder()))
        );

        // Return 401 Unauthorized for unauthenticated API/XHR requests instead of redirecting
        // the client to the authorization endpoint (which causes browsers to follow redirects
        // inside XHR and fail due to CORS). This ensures XHR clients receive 401 and the
        // browser-based SPA can perform a full top-level navigation to the Keycloak authorize
        // endpoint when appropriate.
        http.exceptionHandling(ex -> ex.authenticationEntryPoint(new HttpStatusServerEntryPoint(HttpStatus.UNAUTHORIZED)));

        // Disable CSRF (for simplicity in this gateway setup)
        http.csrf(ServerHttpSecurity.CsrfSpec::disable);

        return http.build();
    }

    @Bean
    public ReactiveJwtDecoder jwtDecoder() {
        // Use JWK Set URI directly to avoid startup connection to Keycloak
        return NimbusReactiveJwtDecoder.withJwkSetUri(jwkSetUri).build();
    }

    @Bean
    public CorsWebFilter corsWebFilter() {
        final CorsConfiguration corsConfig = new CorsConfiguration();

        String [] allowedList = {
                "http://172.28.0.1:8848",
                "http://172.28.0.1:28080",
                "http://localhost:28080",
                "http://localhost:8840",
                "http://localhost",
                "http://localhost:8849"};
        corsConfig.setAllowedOrigins(Arrays.asList(allowedList));
        corsConfig.setAllowedMethods(Arrays.asList("GET", "POST", "OPTIONS", "HEAD", "PUT", "DELETE"));
        corsConfig.setAllowCredentials(true);
        corsConfig.addAllowedHeader("*");

        final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfig);

        return new CorsWebFilter(source);
    }

}
