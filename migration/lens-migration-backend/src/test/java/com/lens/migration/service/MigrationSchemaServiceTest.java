package com.lens.migration.service;

import com.lens.migration.common.BusinessException;
import com.lens.migration.domain.MigrationSchema;
import com.lens.migration.dto.MigrationSchemaDTO;
import com.lens.migration.mapper.MigrationSchemaMapper;
import com.lens.migration.service.impl.MigrationSchemaServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("MigrationSchemaService 单元测试")
class MigrationSchemaServiceTest {

    @Mock
    private MigrationSchemaMapper schemaMapper;

    @InjectMocks
    private MigrationSchemaServiceImpl schemaService;

    private MigrationSchema sampleSchema;

    @BeforeEach
    void setUp() {
        sampleSchema = MigrationSchema.builder()
                .projectId(1L)
                .fileName("ietf-interfaces@2018-02-20.yang")
                .moduleName("ietf-interfaces")
                .schemaVersion("source")
                .isDeviation(false)
                .storagePath("/schemas/1/source/ietf-interfaces.yang")
                .fileSize(4096L)
                .checksum("abc123")
                .build();
        sampleSchema.setId(10L);
        sampleSchema.setCreatedAt(LocalDateTime.now());
    }

    @Test
    @DisplayName("添加 Schema：成功插入返回 Response")
    void add_shouldInsertAndReturnResponse() {
        doAnswer(inv -> {
            MigrationSchema s = inv.getArgument(0);
            s.setId(10L);
            s.setCreatedAt(LocalDateTime.now());
            return 1;
        }).when(schemaMapper).insert(any(MigrationSchema.class));

        MigrationSchemaDTO.CreateRequest req = new MigrationSchemaDTO.CreateRequest();
        req.setProjectId(1L);
        req.setFileName("ietf-interfaces@2018-02-20.yang");
        req.setModuleName("ietf-interfaces");
        req.setSchemaVersion("source");
        req.setStoragePath("/schemas/1/source/ietf-interfaces.yang");

        MigrationSchemaDTO.Response resp = schemaService.add(req);

        assertThat(resp.getId()).isEqualTo(10L);
        assertThat(resp.getProjectId()).isEqualTo(1L);
        assertThat(resp.getFileName()).isEqualTo("ietf-interfaces@2018-02-20.yang");
        assertThat(resp.getSchemaVersion()).isEqualTo("source");
        verify(schemaMapper).insert(any(MigrationSchema.class));
    }

    @Test
    @DisplayName("按项目查询：返回对应列表")
    void listByProject_returnsCorrectList() {
        when(schemaMapper.selectByProjectId(1L)).thenReturn(List.of(sampleSchema));

        List<MigrationSchemaDTO.Response> result = schemaService.listByProject(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getModuleName()).isEqualTo("ietf-interfaces");
    }

    @Test
    @DisplayName("按项目和版本查询：正确过滤")
    void listByProjectAndVersion_filtersCorrectly() {
        when(schemaMapper.selectByProjectIdAndVersion(1L, "source"))
                .thenReturn(List.of(sampleSchema));

        List<MigrationSchemaDTO.Response> result =
                schemaService.listByProjectAndVersion(1L, "source");

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getSchemaVersion()).isEqualTo("source");
    }

    @Test
    @DisplayName("按 ID 查询：不存在时抛出 BusinessException(404)")
    void getById_notFound_throwsException() {
        when(schemaMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> schemaService.getById(99L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    @Test
    @DisplayName("删除 Schema：成功调用 deleteById")
    void delete_shouldCallDeleteById() {
        when(schemaMapper.selectById(10L)).thenReturn(sampleSchema);

        schemaService.delete(10L);

        verify(schemaMapper).deleteById(10L);
    }

    @Test
    @DisplayName("删除 Schema：不存在时抛出异常")
    void delete_notFound_throwsException() {
        when(schemaMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> schemaService.delete(99L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }
}

