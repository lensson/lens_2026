"""
Schema Analyzer Module（Schema 分析模块）

分析新旧两版本 YANG Schema 之间的差异，为 XSLT 生成提供结构化的变更信息。

当前为占位实现（Phase 3 待完整实现），提供了以下骨架：
  - DiffEngine      : 对比两棵 Schema 节点树，找出增/删/改
  - ChangeDetector  : 识别重命名、结构重组等高级模式
  - ImpactAnalyzer  : 评估变更影响等级，生成影响报告
  - SchemaAnalyzer  : 主分析器，编排以上组件完成完整分析
"""

from typing import List, Dict, Any, Optional
from enum import Enum
from dataclasses import dataclass
import logging

logger = logging.getLogger(__name__)


class ChangeType(Enum):
    """Schema 变更类型枚举。"""
    NODE_ADDED = "node_added"               # 新增节点
    NODE_REMOVED = "node_removed"           # 删除节点
    NODE_RENAMED = "node_renamed"           # 节点重命名
    TYPE_CHANGED = "type_changed"           # 数据类型变更
    DEFAULT_CHANGED = "default_changed"     # 默认值变更
    MANDATORY_CHANGED = "mandatory_changed" # 必填属性变更
    CONSTRAINT_CHANGED = "constraint_changed"   # 约束条件变更
    DESCRIPTION_CHANGED = "description_changed" # 描述信息变更（影响较低）


class ImpactLevel(Enum):
    """变更的影响等级。"""
    LOW = "low"           # 低影响（如描述变更）
    MEDIUM = "medium"     # 中等影响（如默认值变更）
    HIGH = "high"         # 高影响（如类型变更、删除节点）
    CRITICAL = "critical" # 严重影响（如删除必填节点）


@dataclass
class SchemaChange:
    """
    单条 Schema 变更记录。

    描述从旧版本到新版本的一次具体变更，包含：
    - 变更类型（增/删/改/重命名等）
    - 变更节点的 XPath 路径
    - 旧值和新值（类型、默认值等）
    - 影响等级
    - 是否需要数据转换（即是否需要生成对应 XSLT 规则）
    """
    change_type: ChangeType
    path: str                           # 变更节点的 XPath 路径
    old_value: Optional[Any] = None     # 旧值（删除/修改时有值）
    new_value: Optional[Any] = None     # 新值（新增/修改时有值）
    impact: ImpactLevel = ImpactLevel.MEDIUM
    conversion_needed: bool = False     # True 表示需要生成 XSLT 规则
    notes: str = ""                     # 补充说明（如人工备注）

    def to_dict(self) -> Dict[str, Any]:
        """将变更记录序列化为字典，用于 JSON 输出或日志记录。"""
        return {
            "type": self.change_type.value,
            "path": self.path,
            "old_value": self.old_value,
            "new_value": self.new_value,
            "impact": self.impact.value,
            "conversion_needed": self.conversion_needed,
            "notes": self.notes
        }


class DiffEngine:
    """
    Schema 树差异引擎。

    对比新旧两棵 Schema 节点树，逐路径检测：
      - 新增的节点（仅存在于新 Schema）
      - 删除的节点（仅存在于旧 Schema）
      - 修改的节点（两者共有，但属性不同）
    """

    def __init__(self):
        self.changes: List[SchemaChange] = []   # 本次比对的变更结果列表

    def compare(self, old_schema: Any, new_schema: Any) -> List[SchemaChange]:
        """
        对比两个 Schema 树，返回所有变更记录。

        Args:
            old_schema: 旧版本 Schema 树对象（需实现 get_all_paths / get_node 接口）
            new_schema: 新版本 Schema 树对象

        Returns:
            SchemaChange 列表，每条对应一处变更
        """
        logger.info("开始对比 Schema 差异...")

        self.changes = []

        # 获取新旧 Schema 的全部节点路径集合
        old_paths = set(old_schema.get_all_paths())
        new_paths = set(new_schema.get_all_paths())

        # ── 新增节点：只在新 Schema 中存在 ──────────────────────────────────
        added_paths = new_paths - old_paths
        for path in added_paths:
            self.changes.append(SchemaChange(
                change_type=ChangeType.NODE_ADDED,
                path=path,
                new_value=new_schema.get_node(path),
                impact=self._assess_add_impact(path)
                # 新增节点通常不需要迁移，但可能需要补充默认值
            ))

        # ── 删除节点：只在旧 Schema 中存在 ──────────────────────────────────
        removed_paths = old_paths - new_paths
        for path in removed_paths:
            self.changes.append(SchemaChange(
                change_type=ChangeType.NODE_REMOVED,
                path=path,
                old_value=old_schema.get_node(path),
                impact=ImpactLevel.HIGH,    # 删除节点影响通常较高
                conversion_needed=True      # 需要在 XSLT 中删除该节点
            ))

        # ── 修改节点：新旧 Schema 共有，但节点属性不同 ──────────────────────
        common_paths = old_paths & new_paths
        for path in common_paths:
            node_changes = self._compare_nodes(
                path,
                old_schema.get_node(path),
                new_schema.get_node(path)
            )
            self.changes.extend(node_changes)

        logger.info(f"Schema 差异分析完成：共发现 {len(self.changes)} 处变更")
        return self.changes

    def _compare_nodes(
        self,
        path: str,
        old_node: Dict[str, Any],
        new_node: Dict[str, Any]
    ) -> List[SchemaChange]:
        """
        对同一路径下的新旧节点进行属性级别比较。

        当前检查项：
          - 数据类型（type）
          - 默认值（default）
          - 必填属性（mandatory）

        Args:
            path:     节点的 XPath 路径
            old_node: 旧节点属性字典
            new_node: 新节点属性字典

        Returns:
            该节点的所有属性变更列表
        """
        changes = []

        # 检查数据类型变更（通常需要数据转换）
        if old_node.get("type") != new_node.get("type"):
            changes.append(SchemaChange(
                change_type=ChangeType.TYPE_CHANGED,
                path=path,
                old_value=old_node.get("type"),
                new_value=new_node.get("type"),
                impact=ImpactLevel.HIGH,
                conversion_needed=True      # 类型变更几乎必然需要 XSLT 处理
            ))

        # 检查默认值变更（中等影响，可能影响省略节点的行为）
        if old_node.get("default") != new_node.get("default"):
            changes.append(SchemaChange(
                change_type=ChangeType.DEFAULT_CHANGED,
                path=path,
                old_value=old_node.get("default"),
                new_value=new_node.get("default"),
                impact=ImpactLevel.MEDIUM
            ))

        # 检查必填属性变更（从可选变为必填影响较高）
        if old_node.get("mandatory") != new_node.get("mandatory"):
            changes.append(SchemaChange(
                change_type=ChangeType.MANDATORY_CHANGED,
                path=path,
                old_value=old_node.get("mandatory"),
                new_value=new_node.get("mandatory"),
                impact=ImpactLevel.HIGH
            ))

        return changes

    def _assess_add_impact(self, path: str) -> ImpactLevel:
        """
        评估新增节点的影响等级。

        目前简单返回 LOW；后续可根据节点深度、是否为必填等规则细化。
        """
        # TODO: 实现更智能的影响评估（如判断是否为叶节点、是否有默认值等）
        return ImpactLevel.LOW


class ChangeDetector:
    """
    高级变更模式检测器。

    在 DiffEngine 的原始变更列表基础上，识别更高层次的模式，如：
      - 重命名（一个节点被删除 + 一个新节点被添加，内容相似）
      - 结构重组（子树整体移动到新路径）
    """

    def detect_renames(self, changes: List[SchemaChange]) -> List[SchemaChange]:
        """
        从增/删变更对中识别节点重命名操作。

        算法思路：
          - 找出所有 NODE_REMOVED 和 NODE_ADDED
          - 按内容相似度匹配，将配对的增删合并为 NODE_RENAMED

        Returns:
            识别到的重命名变更列表
        """
        # TODO: 实现重命名检测算法（内容相似度 + 路径前缀匹配）
        pass

    def detect_restructuring(self, changes: List[SchemaChange]) -> List[SchemaChange]:
        """
        识别 Schema 结构重组（子树路径迁移）。

        Returns:
            识别到的结构重组变更列表
        """
        # TODO: 实现结构重组检测（路径前缀匹配 + 子节点集合比较）
        pass


class ImpactAnalyzer:
    """
    变更影响分析器。

    统计所有变更的影响等级分布，汇总需要数据转换的变更，
    生成供人工审查或 XSLT 生成器使用的影响报告。
    """

    def analyze_impact(self, changes: List[SchemaChange]) -> Dict[str, Any]:
        """
        分析变更列表的整体影响，生成影响报告。

        报告包含：
          total_changes      —— 变更总数
          by_type            —— 按变更类型分组的计数
          by_impact          —— 按影响等级分组的计数
          critical_changes   —— 严重影响变更的详细列表
          conversion_required —— 需要生成 XSLT 规则的变更列表

        Args:
            changes: DiffEngine 返回的变更列表

        Returns:
            影响报告字典
        """
        report = {
            "total_changes": len(changes),
            "by_type": {},
            "by_impact": {},
            "critical_changes": [],       # 严重影响变更，需优先处理
            "conversion_required": []     # 需要 XSLT 处理的变更
        }

        for change in changes:
            # 按类型统计
            change_type = change.change_type.value
            report["by_type"][change_type] = report["by_type"].get(change_type, 0) + 1

            # 按影响等级统计
            impact_level = change.impact.value
            report["by_impact"][impact_level] = report["by_impact"].get(impact_level, 0) + 1

            # 收集严重影响变更
            if change.impact == ImpactLevel.CRITICAL:
                report["critical_changes"].append(change.to_dict())

            # 收集需要 XSLT 处理的变更
            if change.conversion_needed:
                report["conversion_required"].append(change.to_dict())

        return report


class SchemaAnalyzer:
    """
    主分析器 —— 编排所有 Schema 分析组件。

    调用顺序：
      1. DiffEngine.compare()      —— 获取原始变更列表
      2. ChangeDetector            —— 识别高级变更模式（重命名/重组）
      3. ImpactAnalyzer            —— 生成影响报告
      4. 汇总为完整报告返回
    """

    def __init__(self):
        self.diff_engine = DiffEngine()
        self.change_detector = ChangeDetector()
        self.impact_analyzer = ImpactAnalyzer()

    def analyze(
        self,
        old_schema: Any,
        new_schema: Any
    ) -> Dict[str, Any]:
        """
        对两个 Schema 版本执行完整分析，返回分析报告。

        Args:
            old_schema: 旧版本 Schema 树
            new_schema: 新版本 Schema 树

        Returns:
            包含变更列表和影响分析的完整报告字典
        """
        logger.info("开始执行完整 Schema 分析...")

        # 第一步：获取原始差异变更列表
        changes = self.diff_engine.compare(old_schema, new_schema)

        # 第二步：高级模式识别（当前为 TODO，注释掉避免 None 返回值干扰）
        # renames = self.change_detector.detect_renames(changes)
        # restructuring = self.change_detector.detect_restructuring(changes)

        # 第三步：影响分析
        impact_report = self.impact_analyzer.analyze_impact(changes)

        # 第四步：汇总完整报告
        report = {
            "summary": {
                "old_schema": old_schema.root_module,   # 旧版本模块名
                "new_schema": new_schema.root_module,   # 新版本模块名
                "total_changes": len(changes)
            },
            "changes": [c.to_dict() for c in changes],  # 所有变更的序列化列表
            "impact_analysis": impact_report             # 影响分析报告
        }

        logger.info(f"Schema 分析完成：发现 {len(changes)} 处变更")
        return report


def analyze_schema_diff(old_schema: Any, new_schema: Any) -> Dict[str, Any]:
    """
    便捷函数：直接分析两个 Schema 之间的差异。

    等价于：SchemaAnalyzer().analyze(old_schema, new_schema)

    Args:
        old_schema: 旧版本 Schema 树
        new_schema: 新版本 Schema 树

    Returns:
        完整的分析报告字典
    """
    analyzer = SchemaAnalyzer()
    return analyzer.analyze(old_schema, new_schema)


if __name__ == "__main__":
    # 模块直接运行时的简单自检
    logging.basicConfig(level=logging.INFO)
    print("Schema Analyzer 模块已加载")
    print("用途：分析新旧 YANG Schema 之间的差异，为 XSLT 生成提供结构化变更信息")
