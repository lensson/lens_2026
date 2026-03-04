"""
lens_migration.analyzer —— Schema 分析子包

提供以下分析器（Phase 3 待完整实现）：
  - SchemaAnalyzer : 分析新旧 YANG Schema 差异，生成结构化变更列表
  - DiffEngine     : 节点树差异引擎
  - ChangeDetector : 高级变更模式识别（重命名、结构重组）
  - ImpactAnalyzer : 变更影响等级评估

主要公共类型：
  - SchemaChange : 单条 Schema 变更记录
  - ChangeType   : 变更类型枚举
  - ImpactLevel  : 影响等级枚举
"""

from lens_migration.analyzer.schema_analyzer import (
    SchemaAnalyzer,
    SchemaChange,
    ChangeType,
    ImpactLevel,
)

__all__ = [
    "SchemaAnalyzer",
    "SchemaChange",
    "ChangeType",
    "ImpactLevel",
]

