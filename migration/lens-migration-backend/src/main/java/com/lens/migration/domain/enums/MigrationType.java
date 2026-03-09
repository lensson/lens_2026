package com.lens.migration.domain.enums;

/**
 * 迁移场景类型枚举
 *
 * 对应 request.md 中定义的三种迁移场景
 */
public enum MigrationType {

    /** 意图驱动：Yang Schema 无结构变化，仅配置语义调整 */
    INTENT_DRIVEN,

    /** Schema 驱动：Yang 模型发生结构变化（新增/删除/重命名节点） */
    SCHEMA_DRIVEN,

    /** 混合：既有 Schema 变化，又有语义调整 */
    HYBRID
}

