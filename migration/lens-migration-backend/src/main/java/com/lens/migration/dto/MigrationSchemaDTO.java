package com.lens.migration.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * Yang Schema DTO
 */
public class MigrationSchemaDTO {

    @Data
    public static class CreateRequest {

        @NotNull(message = "项目ID不能为空")
        private Long projectId;

        @NotBlank(message = "文件名不能为空")
        private String fileName;

        private String moduleName;

        @NotBlank(message = "schema版本不能为空，source或target")
        private String schemaVersion;

        private Boolean isDeviation = false;

        @NotBlank(message = "存储路径不能为空")
        private String storagePath;

        private Long fileSize;
        private String checksum;
        private String remark;
        /** 文件内容（Base64 或原文，可选，支持直接上传小文件） */
        private String content;
    }

    @Data
    public static class Response {
        private Long id;
        private Long projectId;
        private String fileName;
        private String moduleName;
        private String schemaVersion;
        private Boolean isDeviation;
        private String storagePath;
        private Long fileSize;
        private String checksum;
        private String remark;
        private LocalDateTime createdAt;
    }
}

