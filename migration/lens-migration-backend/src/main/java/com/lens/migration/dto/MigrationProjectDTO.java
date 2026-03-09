package com.lens.migration.dto;

import com.lens.migration.domain.enums.AiProvider;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 迁移项目 DTO
 */
public class MigrationProjectDTO {

    /** 创建项目请求 */
    @Data
    public static class CreateRequest {

        @NotBlank(message = "项目名称不能为空")
        private String name;

        private String description;

        @NotBlank(message = "设备型号不能为空")
        private String deviceModel;

        private String boardType;

        @NotBlank(message = "源版本不能为空")
        private String sourceVersion;

        @NotBlank(message = "目标版本不能为空")
        private String targetVersion;

        @NotNull(message = "迁移类型不能为空")
        private MigrationType migrationType;

        private AiProvider aiProvider = AiProvider.NONE;
        private String aiModel;
    }

    /** 更新项目请求 */
    @Data
    public static class UpdateRequest {
        private String name;
        private String description;
        private AiProvider aiProvider;
        private String aiModel;
        private MigrationStatus status;
        private String errorMessage;
    }

    /** 项目响应 */
    @Data
    public static class Response {
        private Long id;
        private String name;
        private String description;
        private String deviceModel;
        private String boardType;
        private String sourceVersion;
        private String targetVersion;
        private MigrationType migrationType;
        private MigrationStatus status;
        private AiProvider aiProvider;
        private String aiModel;
        private Integer aiRoundsUsed;
        private String createdBy;
        private String errorMessage;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }

    /** 列表项（精简版） */
    @Data
    public static class ListItem {
        private Long id;
        private String name;
        private String deviceModel;
        private String sourceVersion;
        private String targetVersion;
        private MigrationType migrationType;
        private MigrationStatus status;
        private AiProvider aiProvider;
        private String createdBy;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }
}

