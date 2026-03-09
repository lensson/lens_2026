package com.lens.migration.service.impl;

import com.lens.migration.common.BusinessException;
import com.lens.migration.domain.MigrationExample;
import com.lens.migration.dto.MigrationExampleDTO;
import com.lens.migration.mapper.MigrationExampleMapper;
import com.lens.migration.service.MigrationExampleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class MigrationExampleServiceImpl implements MigrationExampleService {

    private final MigrationExampleMapper exampleMapper;

    @Override
    @Transactional
    public MigrationExampleDTO.Response add(MigrationExampleDTO.CreateRequest req) {
        MigrationExample example = MigrationExample.builder()
                .projectId(req.getProjectId())
                .sampleName(req.getSampleName())
                .operationType(req.getOperationType())
                .inputFileName(req.getInputFileName())
                .inputStoragePath(req.getInputStoragePath())
                .expectedFileName(req.getExpectedFileName())
                .expectedStoragePath(req.getExpectedStoragePath())
                .rootXpath(req.getRootXpath())
                .namespaceMap(req.getNamespaceMap())
                .remark(req.getRemark())
                .build();
        exampleMapper.insert(example);
        log.info("样本对已添加: projectId={}, sample={}", req.getProjectId(), req.getSampleName());
        return toResponse(example);
    }

    @Override
    public List<MigrationExampleDTO.Response> listByProject(Long projectId) {
        return exampleMapper.selectByProjectId(projectId).stream()
                .map(this::toResponse).toList();
    }

    @Override
    public List<MigrationExampleDTO.Response> listByProjectAndOperation(Long projectId, String operationType) {
        return exampleMapper.selectByProjectIdAndOperation(projectId, operationType).stream()
                .map(this::toResponse).toList();
    }

    @Override
    public MigrationExampleDTO.Response getById(Long id) {
        MigrationExample e = exampleMapper.selectById(id);
        if (e == null) throw BusinessException.notFound("MigrationExample", id);
        return toResponse(e);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (exampleMapper.selectById(id) == null) throw BusinessException.notFound("MigrationExample", id);
        exampleMapper.deleteById(id);
    }

    private MigrationExampleDTO.Response toResponse(MigrationExample e) {
        MigrationExampleDTO.Response r = new MigrationExampleDTO.Response();
        r.setId(e.getId());
        r.setProjectId(e.getProjectId());
        r.setSampleName(e.getSampleName());
        r.setOperationType(e.getOperationType());
        r.setInputFileName(e.getInputFileName());
        r.setInputStoragePath(e.getInputStoragePath());
        r.setExpectedFileName(e.getExpectedFileName());
        r.setExpectedStoragePath(e.getExpectedStoragePath());
        r.setRootXpath(e.getRootXpath());
        r.setNamespaceMap(e.getNamespaceMap());
        r.setRemark(e.getRemark());
        r.setCreatedAt(e.getCreatedAt());
        return r;
    }
}

