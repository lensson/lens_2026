package com.lens.migration.mapper;

import com.baomidou.mybatisplus.test.autoconfigure.MybatisPlusTest;
import com.lens.migration.config.MybatisPlusConfig;
import org.junit.jupiter.api.AfterEach;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;

/**
 * Mapper 层单元测试基类
 *
 * - @MybatisPlusTest：仅加载 MyBatis-Plus 相关上下文（Mapper、DataSource）
 * - @Import(MybatisPlusConfig.class)：确保 MetaObjectHandler 自动填充生效
 * - @AutoConfigureTestDatabase(replace = NONE)：使用真实 MariaDB
 * - @ActiveProfiles("test")：激活 application-test.yml 配置
 */
@MybatisPlusTest
@Import(MybatisPlusConfig.class)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@ActiveProfiles("test")
@TestPropertySource(locations = "classpath:application-test.yml")
public abstract class BaseMapperTest {

    @AfterEach
    void tearDown() {
        cleanTestData();
    }

    protected void cleanTestData() {
        // 默认空实现，子类按需覆写
    }
}

