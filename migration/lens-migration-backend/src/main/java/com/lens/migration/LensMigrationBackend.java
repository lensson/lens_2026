package com.lens.migration;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * YANG Migration Backend Service
 *
 * Main application class for the YANG data migration backend service.
 * This service provides RESTful APIs for managing YANG schema migrations,
 * generating XSLT transformations using AI, and testing migration results.
 *
 * @author Lens Team
 * @since 2026-02-28
 */
@SpringBootApplication
@EnableDiscoveryClient
@MapperScan("com.lens.migration.mapper")
public class LensMigrationBackend {

    public static void main(String[] args) {
        SpringApplication.run(LensMigrationBackend.class, args);
    }

}
