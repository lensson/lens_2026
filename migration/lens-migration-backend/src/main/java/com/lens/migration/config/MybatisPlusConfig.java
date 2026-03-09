package com.lens.migration.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDateTime;

/**
 * MyBatis-Plus 全局配置
 *
 * 注册自动填充处理器（MetaObjectHandler）：
 * - INSERT 时自动填充 createdAt、updatedAt
 * - UPDATE 时自动填充 updatedAt
 */
@Configuration
@Slf4j
public class MybatisPlusConfig {

    /**
     * 自动填充处理器：自动写入 created_at / updated_at
     */
    @Bean
    public MetaObjectHandler metaObjectHandler() {
        return new MetaObjectHandler() {
            @Override
            public void insertFill(MetaObject metaObject) {
                LocalDateTime now = LocalDateTime.now();
                log.debug("自动填充 createdAt/updatedAt，时间: {}", now);
                this.strictInsertFill(metaObject, "createdAt", LocalDateTime.class, now);
                this.strictInsertFill(metaObject, "updatedAt", LocalDateTime.class, now);
            }

            @Override
            public void updateFill(MetaObject metaObject) {
                LocalDateTime now = LocalDateTime.now();
                log.debug("自动更新 updatedAt，时间: {}", now);
                this.strictUpdateFill(metaObject, "updatedAt", LocalDateTime.class, now);
            }
        };
    }
}
