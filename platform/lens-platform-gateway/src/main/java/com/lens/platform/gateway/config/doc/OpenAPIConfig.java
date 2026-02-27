package com.lens.platform.gateway.config.doc;

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

    @Value("${keycloak.url:http://172.28.0.1:28080}")
    String authServerUrl;
    @Value("${keycloak.realm:lens}")
    String realm;

    private static final String OAUTH_SCHEME_NAME = "keycloak_oAuth_security_schema";

    @Bean
    public OpenAPI customOpenAPI(
            @Value("${openapi.service.title:Lens Platform Gateway API}") String serviceTitle,
            @Value("${openapi.service.version:2.0.0}") String serviceVersion,
            @Value("${openapi.service.url:http://localhost:8050}") String url) {
        return new OpenAPI()
                .components(new Components()
                        .addSecuritySchemes(OAUTH_SCHEME_NAME, createOAuthScheme()))
                .addSecurityItem(new SecurityRequirement().addList(OAUTH_SCHEME_NAME))
                .servers(List.of(new Server().url(url)))
                .info(new Info().title(serviceTitle)
                        .description("Lens Platform Gateway API\n\n" +
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
