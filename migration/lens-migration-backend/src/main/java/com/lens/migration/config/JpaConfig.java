package com.lens.migration.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * JPA 配置类
 *
 * 启用 JPA Auditing 自动填充 BaseEntity 中的 createdAt / updatedAt 字段。
 * 启用 JPA Repositories 扫描范围。
 */
@Configuration
@EnableJpaAuditing
@EnableJpaRepositories(basePackages = "com.lens.migration.repository")
public class JpaConfig {
}

