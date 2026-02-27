package com.lens.platform.system.config.doc;


import io.swagger.v3.oas.annotations.OpenAPIDefinition;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.*;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * @Author zhenac
 * @Created 5/19/25 2:41 PM
 */

@OpenAPIDefinition
@Configuration
public class OpenAPIConfig {

//    @Bean
//    public OpenAPI customOpenAPI(
//            @Value("${openapi.service.title}") String serviceTitle,
//            @Value("${openapi.service.version}") String serviceVersion,
//            @Value("${openapi.service.url}") String url) {
//        return new OpenAPI()
//                .servers(List.of(new Server().url(url)))
//                .info(new Info().title(serviceTitle).version(serviceVersion));
//    }

    @Value("${keycloak.url}")
    String authServerUrl;
    @Value("${keycloak.realm}")
    String realm;

    private static final String OAUTH_SCHEME_NAME = "keycloak_oAuth_security_schema";

    @Bean
    public OpenAPI openAPI(
            @Value("${openapi.service.title}") String serviceTitle,
            @Value("${openapi.service.version}") String serviceVersion,
            @Value("${openapi.service.url}") String url) {
        return new OpenAPI().
                components(new Components()
                        // Only OAuth2 scheme - removed bearer_auth
                        .addSecuritySchemes(OAUTH_SCHEME_NAME, createOAuthScheme()))
                // Only OAuth2 required
                .addSecurityItem(new SecurityRequirement().addList(OAUTH_SCHEME_NAME))
                .servers(List.of(new Server().url(url)))
                .info(new Info().title(serviceTitle)
                        .description("Lens System Platform API\n\n" +
                                "## Authentication:\n" +
                                "OAuth2 Authorization Code flow with Keycloak\n" +
                                "- Click 'Authorize' button\n" +
                                "- Login with your Keycloak credentials\n" +
                                "- Client credentials are pre-configured")
                        .version(serviceVersion));
    }


    private SecurityScheme createOAuthScheme() {
        OAuthFlows flows = createOAuthFlows();
        return new SecurityScheme().type(SecurityScheme.Type.OAUTH2)
                .flows(flows);
    }

    private OAuthFlows createOAuthFlows() {
        OAuthFlow flow = createAuthorizationCodeFlow();
        // Use authorizationCode flow (not implicit) for proper Keycloak redirect
        return new OAuthFlows().authorizationCode(flow);
    }

    private OAuthFlow createAuthorizationCodeFlow() {
        return new OAuthFlow()
                .authorizationUrl(authServerUrl + "/realms/" + realm + "/protocol/openid-connect/auth")
                .tokenUrl(authServerUrl + "/realms/" + realm + "/protocol/openid-connect/token")
                .scopes(new Scopes()
                        .addString("openid", "OpenID Connect scope")
                        .addString("profile", "Profile information")
                        .addString("email", "Email address"));
    }
}
