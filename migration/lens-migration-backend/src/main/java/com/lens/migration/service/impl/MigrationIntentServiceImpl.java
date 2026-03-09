package com.lens.migration.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.lens.migration.common.BusinessException;
import com.lens.migration.domain.MigrationIntent;
import com.lens.migration.dto.MigrationIntentDTO;
import com.lens.migration.mapper.MigrationIntentMapper;
import com.lens.migration.service.MigrationIntentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class MigrationIntentServiceImpl implements MigrationIntentService {

    private final MigrationIntentMapper intentMapper;

    @Override
    @Transactional
    public MigrationIntentDTO.Response upload(MigrationIntentDTO.CreateRequest req) {
        // 计算下一个版本号
        MigrationIntent latest = intentMapper.selectLatestByProjectId(req.getProjectId());
        int nextVersion = (latest == null) ? 1 : latest.getVersion() + 1;

        // 将该项目所有旧版本设为非激活
        intentMapper.update(null, new LambdaUpdateWrapper<MigrationIntent>()
                .eq(MigrationIntent::getProjectId, req.getProjectId())
                .set(MigrationIntent::getIsActive, false));

        MigrationIntent intent = MigrationIntent.builder()
                .projectId(req.getProjectId())
                .version(nextVersion)
                .fileName(req.getFileName())
                .storagePath(req.getStoragePath() != null ? req.getStoragePath()
                        : "/intent/" + req.getProjectId() + "/v" + nextVersion + "/" + req.getFileName())
                .content(req.getContent())
                .isActive(true)
                .remark(req.getRemark())
                .build();
        intentMapper.insert(intent);
        log.info("意图文档已上传: projectId={}, version={}", req.getProjectId(), nextVersion);
        return toResponse(intent);
    }

    @Override
    public List<MigrationIntentDTO.Response> listByProject(Long projectId) {
        return intentMapper.selectByProjectIdOrderByVersionDesc(projectId).stream()
                .map(this::toResponse).toList();
    }

    @Override
    public MigrationIntentDTO.Response getActive(Long projectId) {
        MigrationIntent intent = intentMapper.selectActiveByProjectId(projectId);
        if (intent == null) throw new BusinessException(404, "项目 " + projectId + " 无激活意图文档");
        return toResponse(intent);
    }

    @Override
    public MigrationIntentDTO.Response getLatest(Long projectId) {
        MigrationIntent intent = intentMapper.selectLatestByProjectId(projectId);
        if (intent == null) throw new BusinessException(404, "项目 " + projectId + " 无意图文档");
        return toResponse(intent);
    }

    @Override
    public MigrationIntentDTO.Response getById(Long id) {
        MigrationIntent intent = intentMapper.selectById(id);
        if (intent == null) throw BusinessException.notFound("MigrationIntent", id);
        return toResponse(intent);
    }

    @Override
    @Transactional
    public void activate(Long id) {
        MigrationIntent intent = intentMapper.selectById(id);
        if (intent == null) throw BusinessException.notFound("MigrationIntent", id);
        // 取消同项目其他版本
        intentMapper.update(null, new LambdaUpdateWrapper<MigrationIntent>()
                .eq(MigrationIntent::getProjectId, intent.getProjectId())
                .set(MigrationIntent::getIsActive, false));
        intent.setIsActive(true);
        intentMapper.updateById(intent);
        log.info("意图文档已激活: id={}, version={}", id, intent.getVersion());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (intentMapper.selectById(id) == null) throw BusinessException.notFound("MigrationIntent", id);
        intentMapper.deleteById(id);
    }

    private MigrationIntentDTO.Response toResponse(MigrationIntent i) {
        MigrationIntentDTO.Response r = new MigrationIntentDTO.Response();
        r.setId(i.getId());
        r.setProjectId(i.getProjectId());
        r.setVersion(i.getVersion());
        r.setFileName(i.getFileName());
        r.setStoragePath(i.getStoragePath());
        r.setContent(i.getContent());
        r.setParsedRules(i.getParsedRules());
        r.setRulesCount(i.getRulesCount());
        r.setIsActive(i.getIsActive());
        r.setRemark(i.getRemark());
        r.setCreatedAt(i.getCreatedAt());
        r.setUpdatedAt(i.getUpdatedAt());
        return r;
    }
}

