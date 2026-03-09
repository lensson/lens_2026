package com.lens.migration.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 迁移意图文档 DTO
 */
public class MigrationIntentDTO {

    @Data
    public static class CreateRequest {

        @NotNull(message = "项目ID不能为空")
        private Long projectId;

        @NotBlank(message = "文件名不能为空")
        private String fileName;

        private String storagePath;

        /** 意图文档 Markdown 内容（必填） */
        @NotBlank(message = "意图文档内容不能为空")
        private String content;

        private String remark;
    }

    @Data
    public static class Response {
        private Long id;
        private Long projectId;
        private Integer version;
        private String fileName;
        private String storagePath;
        private String content;
        private String parsedRules;
        private Integer rulesCount;
        private Boolean isActive;
        private String remark;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }
}

