package com.lens.migration.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * XML 样本对 DTO
 */
public class MigrationExampleDTO {

    @Data
    public static class CreateRequest {

        @NotNull(message = "项目ID不能为空")
        private Long projectId;

        @NotBlank(message = "样本名称不能为空")
        private String sampleName;

        private String operationType = "edit-config";

        @NotBlank(message = "输入文件名不能为空")
        private String inputFileName;

        @NotBlank(message = "输入存储路径不能为空")
        private String inputStoragePath;

        /** 输入 XML 内容（直接上传小文件时使用） */
        private String inputContent;

        @NotBlank(message = "期望输出文件名不能为空")
        private String expectedFileName;

        @NotBlank(message = "期望输出存储路径不能为空")
        private String expectedStoragePath;

        /** 期望输出 XML 内容 */
        private String expectedContent;

        private String rootXpath;
        private String namespaceMap;
        private String remark;
    }

    @Data
    public static class Response {
        private Long id;
        private Long projectId;
        private String sampleName;
        private String operationType;
        private String inputFileName;
        private String inputStoragePath;
        private String expectedFileName;
        private String expectedStoragePath;
        private String rootXpath;
        private String namespaceMap;
        private String remark;
        private LocalDateTime createdAt;
    }
}

