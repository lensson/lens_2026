# YANG Data Migration Tool - Architecture Design

## 系统架构概述

本文档描述YANG数据迁移工具的整体架构设计，包括核心模块、数据流和AI集成策略。

## 迁移场景说明

⚠️ **重要**: 并非所有数据迁移都基于 YANG Schema 的变化。

### 三种主要迁移场景

1. **Schema 驱动迁移** (Schema-Driven)
   - YANG 模型发生变化（节点重命名、类型改变等）
   - 需要解析新旧 YANG，分析差异
   - 工具辅助生成 XSLT

2. **意图驱动迁移** (Intent-Driven) ⭐ **当前重点**
   - Schema 可能没有变化，但数据需要重新组织
   - 业务逻辑调整（如优化配置结构）
   - 完全基于用户提供的迁移意图文档
   - **simple-classifier-test 属于此类**

3. **混合迁移** (Hybrid)
   - Schema 有变化，同时有额外的业务逻辑调整
   - 结合 Schema 分析和意图文档

### 核心设计原则

**工具应支持所有三种场景**：
- YANG Parser 是可选模块（意图驱动时不需要）
- 迁移意图文档是核心输入
- AI 基于意图和示例生成 XSLT，而非必须依赖 Schema 差异

## 技术栈选型

本项目采用 **Java + Python 混合架构**：

- **Java (Spring Boot)**: 后端服务、REST API、数据库、认证授权
- **Python**: YANG 解析、Schema 分析、XSLT 生成、AI 集成

**为什么使用 Python 作为核心引擎？**

主要原因：
1. ⭐ **成熟的 YANG 生态**: pyang (IETF 官方)、yangson
2. ⭐ **强大的 XML/XSLT**: lxml (基于 libxml2)
3. ⭐ **AI/LLM 首选语言**: OpenAI、Anthropic、Langchain
4. ⭐ **开发效率高**: 代码简洁，快速迭代
5. ⭐ **科学计算丰富**: pandas、numpy (数据分析)

详细的技术选型说明和对比分析，请参考：
📖 [WHY_PYTHON_FOR_CORE.md](./WHY_PYTHON_FOR_CORE.md)

## 1. 架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                        User Interface                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  CLI Tool    │  │  Web UI      │  │  API Server  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Core Processing Layer                        │
│                                                                   │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │  YANG Parser    │  │ Schema Analyzer │  │  AI Processor   │ │
│  │  - pyang        │  │  - Diff Engine  │  │  - LLM Client   │ │
│  │  - yangson      │  │  - Change       │  │  - Prompt Mgr   │ │
│  │  - Deviation    │  │    Detection    │  │  - Response     │ │
│  └─────────────────┘  └─────────────────┘  │    Parser       │ │
│           │                    │            └─────────────────┘ │
│           └────────────────────┼────────────────────┘           │
│                                ▼                                 │
│                    ┌─────────────────────┐                      │
│                    │  Intent Processor   │                      │
│                    │  - NLP Analysis     │                      │
│                    │  - Rule Extraction  │                      │
│                    │  - IR Generation    │                      │
│                    └─────────────────────┘                      │
│                                │                                 │
│                                ▼                                 │
│                    ┌─────────────────────┐                      │
│                    │  XSLT Generator     │                      │
│                    │  - Template Engine  │                      │
│                    │  - Code Optimizer   │                      │
│                    │  - Validator        │                      │
│                    └─────────────────────┘                      │
└─────────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Test & Validation Layer                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ Test Generator  │  │  XML Validator  │  │ Test Framework  │ │
│  │  - Case Gen     │  │  - Schema Valid │  │  - Test Runner  │ │
│  │  - Data Gen     │  │  - XSLT Valid   │  │  - Reporter     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Data Storage Layer                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ YANG Store   │  │  XML Store   │  │  XSLT Cache  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

## 2. 核心模块详细设计

### 2.1 YANG Parser Module

**职责**: 解析和理解YANG模型

**组件**:
- **YangLoader**: 加载YANG文件和依赖
- **DeviationProcessor**: 处理Deviation YANG
- **SchemaBuilder**: 构建Schema树结构
- **TypeResolver**: 解析YANG类型定义

**输入**:
- YANG模块文件(.yang)
- Deviation文件
- Import/Include依赖

**输出**:
- Schema树对象
- 类型映射表
- 元数据信息

**关键算法**:
```python
class YangParser:
    def parse(self, yang_file: str, deviations: List[str]) -> SchemaTree:
        # 1. 加载主YANG文件
        module = self.load_module(yang_file)
        
        # 2. 解析依赖
        dependencies = self.resolve_dependencies(module)
        
        # 3. 应用Deviation
        modified_schema = self.apply_deviations(module, deviations)
        
        # 4. 构建Schema树
        schema_tree = self.build_tree(modified_schema)
        
        return schema_tree
```

### 2.2 Schema Analyzer Module

**职责**: 分析新旧Schema的差异

**组件**:
- **DiffEngine**: 对比两个Schema树
- **ChangeDetector**: 识别变化类型
- **ImpactAnalyzer**: 评估变化影响

**变化类型分类**:
```python
class ChangeType(Enum):
    NODE_ADDED = "node_added"           # 新增节点
    NODE_REMOVED = "node_removed"       # 删除节点
    NODE_RENAMED = "node_renamed"       # 重命名节点
    TYPE_CHANGED = "type_changed"       # 类型变化
    DEFAULT_CHANGED = "default_changed" # 默认值变化
    MANDATORY_CHANGED = "mandatory_changed"  # 必填属性变化
    CONSTRAINT_CHANGED = "constraint_changed" # 约束变化
```

**输出格式**:
```json
{
  "changes": [
    {
      "type": "node_renamed",
      "path": "/interfaces/interface/name",
      "old_name": "interface-name",
      "new_name": "if-name",
      "impact": "high"
    },
    {
      "type": "type_changed",
      "path": "/system/port",
      "old_type": "string",
      "new_type": "uint16",
      "impact": "medium",
      "conversion_needed": true
    }
  ]
}
```

### 2.3 AI Intent Processor Module

**职责**: 理解自然语言迁移意图并生成中间表示

**组件**:
- **IntentParser**: 解析自然语言文档
- **RuleExtractor**: 提取迁移规则
- **IRGenerator**: 生成中间表示

**处理流程**:
```
Natural Language Intent
    ↓
[Tokenization & NLP]
    ↓
Structured Intent
    ↓
[Rule Extraction]
    ↓
Migration Rules
    ↓
[IR Generation]
    ↓
Intermediate Representation (IR)
```

**IR格式示例**:
```json
{
  "rules": [
    {
      "id": "rule_001",
      "type": "rename",
      "source": {
        "xpath": "//old-interface-name",
        "yang_path": "/interfaces/interface/old-interface-name"
      },
      "target": {
        "xpath": "//new-interface-name",
        "yang_path": "/interfaces/interface/new-interface-name"
      },
      "preserve_children": true,
      "preserve_attributes": true
    },
    {
      "id": "rule_002",
      "type": "transform",
      "source": {
        "xpath": "//port-number",
        "yang_path": "/system/port-number",
        "old_type": "string"
      },
      "target": {
        "yang_path": "/system/port-number",
        "new_type": "uint16"
      },
      "transformation": {
        "function": "string_to_uint16",
        "parameters": {
          "min": 1,
          "max": 65535,
          "default": 8080
        }
      }
    }
  ]
}
```

### 2.4 XSLT Generator Module

**职责**: 基于IR和Schema差异生成XSLT

**组件**:
- **TemplateEngine**: XSLT模板生成
- **CodeOptimizer**: XSLT代码优化
- **Validator**: XSLT验证

**生成策略**:
1. **默认复制策略**: 未变化的节点直接复制
2. **规则驱动生成**: 基于IR生成特定转换规则
3. **类型转换注入**: 自动添加类型转换逻辑
4. **错误处理**: 添加默认值和错误处理

**XSLT模板结构**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- Identity template: copy unchanged nodes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Generated migration rules -->
  <!-- Rule 001: Rename node -->
  <xsl:template match="old-interface-name">
    <new-interface-name>
      <xsl:apply-templates select="@*|node()"/>
    </new-interface-name>
  </xsl:template>
  
  <!-- Rule 002: Type conversion -->
  <xsl:template match="port-number">
    <port-number>
      <xsl:call-template name="string-to-uint16">
        <xsl:with-param name="value" select="."/>
        <xsl:with-param name="default" select="8080"/>
      </xsl:call-template>
    </port-number>
  </xsl:template>
  
  <!-- Utility templates -->
  <xsl:template name="string-to-uint16">
    <!-- ... conversion logic ... -->
  </xsl:template>
  
</xsl:stylesheet>
```

### 2.5 Test Generator Module

**职责**: 自动生成测试用例

**组件**:
- **CaseGenerator**: 生成测试场景
- **DataGenerator**: 生成测试数据
- **EdgeCaseDetector**: 识别边界情况

**测试用例类型**:
1. **正常场景**: 典型数据迁移
2. **边界情况**: 最大值、最小值、空值
3. **错误场景**: 无效数据、缺失字段
4. **兼容性测试**: N-1, N-2版本数据

**测试数据生成策略**:
```python
class TestGenerator:
    def generate_test_cases(self, schema: SchemaTree, rules: List[Rule]) -> List[TestCase]:
        cases = []
        
        # 1. 基于Schema生成基础测试数据
        base_cases = self.generate_from_schema(schema)
        
        # 2. 基于迁移规则生成特定测试
        rule_cases = self.generate_from_rules(rules)
        
        # 3. 生成边界测试
        edge_cases = self.generate_edge_cases(schema)
        
        # 4. 生成负面测试
        negative_cases = self.generate_negative_cases(schema)
        
        return cases + rule_cases + edge_cases + negative_cases
```

## 3. AI集成策略

### 3.1 LLM选择

**候选模型**:
- OpenAI GPT-4/GPT-4 Turbo
- Anthropic Claude 3
- Google Gemini Pro
- 本地开源模型 (Llama 2, Mistral)

**选择标准**:
- 代码生成能力
- 长文本理解能力
- API可用性和稳定性
- 成本考虑

### 3.2 Prompt工程

**Prompt组成**:
1. **系统角色定义**: 定义AI助手角色和专业领域
2. **任务描述**: 明确当前任务目标
3. **上下文信息**: 提供YANG Schema、示例等
4. **输出格式要求**: 指定输出格式和结构
5. **约束条件**: 列出限制和要求

**示例Prompt模板**:
```python
PROMPT_TEMPLATE = """
System: You are an expert in YANG data modeling and XSLT transformations. 
Your task is to generate XSLT code for data migration.

Context:
1. YANG Schema Changes:
{schema_changes}

2. Migration Intent (Natural Language):
{migration_intent}

3. Input XML Example:
{input_xml}

4. Expected Output XML:
{output_xml}

Task: Generate a complete XSLT stylesheet that transforms the input XML to match 
the expected output, considering all the schema changes and migration intents.

Requirements:
- Generate valid XSLT 2.0 code
- Handle all edge cases
- Add comments explaining the logic
- Include error handling with default values

Output Format:
```xml
<!-- Your XSLT code here -->
```

Additional Notes:
- Preserve all data that hasn't changed
- Apply type conversions where needed
- Ensure the output is valid against the new schema
"""
```

### 3.3 Response处理

**处理流程**:
```python
class AIResponseProcessor:
    def process_response(self, response: str) -> XSLTCode:
        # 1. 提取XSLT代码
        xslt_code = self.extract_code(response)
        
        # 2. 验证XSLT语法
        if not self.validate_xslt_syntax(xslt_code):
            return self.fallback_generation()
        
        # 3. 测试XSLT转换
        test_results = self.test_transformation(xslt_code)
        
        # 4. 如果测试失败，尝试修复
        if not test_results.passed:
            xslt_code = self.auto_fix(xslt_code, test_results.errors)
        
        # 5. 优化XSLT代码
        optimized_code = self.optimize(xslt_code)
        
        return optimized_code
```

## 4. 数据流设计

### 4.1 端到端流程

```
Input Files
    │
    ├─ Old YANG Schema ────┐
    ├─ New YANG Schema ────┼─→ [YANG Parser] → Schema Objects
    └─ Deviation YANG ─────┘           │
                                       ▼
                            [Schema Analyzer] → Diff Report
                                       │
    Migration Intent (MD) ─────┐      │
    Input XML Examples ─────────┼──────┴─→ [AI Processor] → IR
    Output XML Examples ────────┘              │
                                               ▼
                                    [XSLT Generator] → XSLT File
                                               │
                                               ├─→ [Validator]
                                               │
    Old Schema ──────────┐                    │
    Old Version XML ─────┼────────────────────┴─→ [Test Generator]
                         │                             │
                         └─────────────────────────────┼─→ Test Cases
                                                       │
                                                       ▼
                                            [Test Framework] → Report
```

### 4.2 缓存策略

**缓存内容**:
- 解析后的YANG Schema
- Schema差异分析结果
- AI生成的XSLT片段
- 测试用例数据

**缓存更新策略**:
- Schema文件变化时清除相关缓存
- AI模型版本更新时清除XSLT缓存
- 测试失败时标记缓存为无效

## 5. 性能优化

### 5.1 并行处理

**并行化场景**:
- 多板卡Schema并行解析
- 多规则XSLT生成并行
- 测试用例并行执行

### 5.2 增量处理

**增量策略**:
- 仅处理变化的YANG模块
- 复用未变化的XSLT片段
- 增量测试用例生成

### 5.3 资源管理

**内存管理**:
- 流式处理大XML文件
- Schema树懒加载
- 及时释放AI响应内存

**AI API调用优化**:
- 批量处理多个规则
- 缓存常见转换模式
- 限流和重试机制

## 6. 错误处理和容错

### 6.1 错误分类

1. **解析错误**: YANG或XML解析失败
2. **Schema错误**: Schema不一致或无效
3. **AI错误**: AI生成失败或超时
4. **转换错误**: XSLT转换失败
5. **验证错误**: 输出不符合新Schema

### 6.2 容错机制

```python
class ErrorHandler:
    def handle_ai_failure(self, error: Exception) -> XSLTCode:
        # 1. 尝试重试
        if self.retry_count < MAX_RETRIES:
            return self.retry_with_backoff()
        
        # 2. 降级到规则引擎
        return self.rule_based_generation()
        
    def handle_xslt_error(self, error: XSLTError) -> XSLTCode:
        # 1. 分析错误原因
        root_cause = self.analyze_error(error)
        
        # 2. 自动修复
        if root_cause.fixable:
            return self.auto_fix(error)
        
        # 3. 提供修复建议
        suggestions = self.generate_suggestions(error)
        raise FixableError(suggestions)
```

## 7. 扩展性设计

### 7.1 插件架构

**插件类型**:
- **Parser插件**: 支持其他数据模型语言
- **Generator插件**: 支持其他转换语言
- **AI插件**: 支持不同AI模型
- **Validator插件**: 自定义验证逻辑

### 7.2 API设计

**RESTful API**:
```
POST /api/v1/migrations
    - 创建迁移任务
    
GET /api/v1/migrations/{id}
    - 获取迁移任务状态
    
POST /api/v1/migrations/{id}/generate
    - 生成XSLT
    
POST /api/v1/migrations/{id}/test
    - 运行测试

GET /api/v1/migrations/{id}/xslt
    - 下载生成的XSLT
```

## 8. 安全性考虑

### 8.1 输入验证

- YANG文件大小限制
- XML文件病毒扫描
- 防止XML外部实体注入

### 8.2 AI安全

- Prompt注入防护
- 输出内容过滤
- API密钥安全存储

### 8.3 访问控制

- 用户认证和授权
- 操作审计日志
- 敏感数据加密

## 9. 监控和日志

### 9.1 监控指标

- XSLT生成成功率
- 测试通过率
- AI API调用延迟
- 系统资源使用率

### 9.2 日志策略

```python
# 日志级别
DEBUG   - 详细调试信息
INFO    - 关键操作节点
WARNING - 可恢复的错误
ERROR   - 严重错误
CRITICAL - 系统故障
```

## 10. 部署架构

### 10.1 单机部署

```
┌─────────────────────┐
│   Application       │
│  ┌──────────────┐   │
│  │  Web UI      │   │
│  └──────────────┘   │
│  ┌──────────────┐   │
│  │  Core Engine │   │
│  └──────────────┘   │
│  ┌──────────────┐   │
│  │  Database    │   │
│  └──────────────┘   │
└─────────────────────┘
```

### 10.2 分布式部署

```
┌──────────┐    ┌──────────┐    ┌──────────┐
│  Web UI  │    │  API     │    │  Worker  │
│  Server  │◄──►│  Server  │◄──►│  Node 1  │
└──────────┘    └──────────┘    └──────────┘
                     │           ┌──────────┐
                     │           │  Worker  │
                     ├──────────►│  Node 2  │
                     │           └──────────┘
                     │           ┌──────────┐
                     │           │  Worker  │
                     └──────────►│  Node N  │
                                 └──────────┘
                                      ▲
                                      │
                                ┌──────────┐
                                │  Shared  │
                                │  Storage │
                                └──────────┘
```

---

**Last Updated**: 2026-02-28  
**Version**: 1.0  
**Author**: Architecture Team
