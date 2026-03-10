package com.lens.migration.service;

import com.lens.migration.common.BusinessException;
import com.lens.migration.domain.MigrationExample;
import com.lens.migration.dto.MigrationExampleDTO;
import com.lens.migration.mapper.MigrationExampleMapper;
import com.lens.migration.service.impl.MigrationExampleServiceImpl;
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
@DisplayName("MigrationExampleService 单元测试")
class MigrationExampleServiceTest {

    @Mock
    private MigrationExampleMapper exampleMapper;

    @InjectMocks
    private MigrationExampleServiceImpl exampleService;

    private MigrationExample sampleExample;

    @BeforeEach
    void setUp() {
        sampleExample = MigrationExample.builder()
                .projectId(1L)
                .sampleName("sample-01")
                .operationType("edit-config")
                .inputFileName("input-old.xml")
                .inputStoragePath("/examples/1/input-old.xml")
                .expectedFileName("expected-new.xml")
                .expectedStoragePath("/examples/1/expected-new.xml")
                .rootXpath("classifiers")
                .build();
        sampleExample.setId(20L);
        sampleExample.setCreatedAt(LocalDateTime.now());
    }

    @Test
    @DisplayName("添加样本对：成功插入返回 Response")
    void add_shouldInsertAndReturnResponse() {
        doAnswer(inv -> {
            MigrationExample e = inv.getArgument(0);
            e.setId(20L);
            e.setCreatedAt(LocalDateTime.now());
            return 1;
        }).when(exampleMapper).insert(any(MigrationExample.class));

        MigrationExampleDTO.CreateRequest req = new MigrationExampleDTO.CreateRequest();
        req.setProjectId(1L);
        req.setSampleName("sample-01");
        req.setInputFileName("input-old.xml");
        req.setInputStoragePath("/examples/1/input-old.xml");
        req.setExpectedFileName("expected-new.xml");
        req.setExpectedStoragePath("/examples/1/expected-new.xml");

        MigrationExampleDTO.Response resp = exampleService.add(req);

        assertThat(resp.getId()).isEqualTo(20L);
        assertThat(resp.getSampleName()).isEqualTo("sample-01");
        assertThat(resp.getProjectId()).isEqualTo(1L);
        verify(exampleMapper).insert(any(MigrationExample.class));
    }

    @Test
    @DisplayName("按项目查询：返回全部样本")
    void listByProject_returnsAll() {
        when(exampleMapper.selectByProjectId(1L)).thenReturn(List.of(sampleExample));

        List<MigrationExampleDTO.Response> result = exampleService.listByProject(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getSampleName()).isEqualTo("sample-01");
    }

    @Test
    @DisplayName("按操作类型过滤：只返回匹配项")
    void listByProjectAndOperation_filtersCorrectly() {
        when(exampleMapper.selectByProjectIdAndOperation(1L, "edit-config"))
                .thenReturn(List.of(sampleExample));

        List<MigrationExampleDTO.Response> result =
                exampleService.listByProjectAndOperation(1L, "edit-config");

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getOperationType()).isEqualTo("edit-config");
    }

    @Test
    @DisplayName("按 ID 查询：不存在时抛出 404")
    void getById_notFound_throwsException() {
        when(exampleMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> exampleService.getById(99L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    @Test
    @DisplayName("删除样本对：成功调用 deleteById")
    void delete_shouldCallDeleteById() {
        when(exampleMapper.selectById(20L)).thenReturn(sampleExample);

        exampleService.delete(20L);

        verify(exampleMapper).deleteById(20L);
    }

    @Test
    @DisplayName("删除样本对：不存在时抛出异常")
    void delete_notFound_throwsException() {
        when(exampleMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> exampleService.delete(99L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }
}

