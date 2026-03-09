package com.lens.migration.dto;

import com.lens.migration.domain.enums.AiProvider;
import com.lens.migration.domain.enums.ArtifactType;
import com.lens.migration.domain.enums.TestStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * XSLT 生成 & 测试 DTO
 */
public class MigrationGenerateDTO {

    /** 触发 XSLT 生成请求 */
    @Data
    public static class GenerateRequest {

        @NotNull(message = "项目ID不能为空")
        private Long projectId;

        private AiProvider aiProvider;
        private String aiModel;

        /** 最大生成轮次（默认3轮） */
        private Integer maxRounds = 3;
    }

    /** 生成结果响应 */
    @Data
    public static class ArtifactResponse {
        private Long id;
        private Long projectId;
        private Long intentId;
        private ArtifactType artifactType;
        private String fileName;
        private String storagePath;
        private String content;
        private Long generationTimeMs;
        private Integer tokensUsed;
        private Integer version;
        private Boolean isActive;
        private LocalDateTime createdAt;
    }

    /** 触发测试请求 */
    @Data
    public static class RunTestRequest {
        @NotNull(message = "项目ID不能为空")
        private Long projectId;
        /** 指定 artifact ID，不传则取当前激活版本 */
        private Long artifactId;
    }

    /** 测试执行汇总响应 */
    @Data
    public static class TestRunResponse {
        private Long id;
        private Long projectId;
        private Long artifactId;
        private TestStatus status;
        private Integer totalCases;
        private Integer passedCases;
        private Integer failedCases;
        private Integer errorCases;
        private Long durationMs;
        private String errorMessage;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }

    /** 单条用例结果响应 */
    @Data
    public static class CaseResultResponse {
        private Long id;
        private Long testRunId;
        private Long exampleId;
        private String caseName;
        private TestStatus status;
        private String actualOutputPath;
        private String diffDetail;
        private String errorMessage;
        private Long durationMs;
        private LocalDateTime createdAt;
    }

    /** 测试执行详情（含用例明细） */
    @Data
    public static class TestRunDetail {
        private TestRunResponse summary;
        private List<CaseResultResponse> cases;
    }
}

