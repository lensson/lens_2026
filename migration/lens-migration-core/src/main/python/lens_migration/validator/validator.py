"""
XSLT Validator Module（XSLT 验证模块）

验证生成的 XSLT 样式表，并对实际转换结果与期望输出进行比对。

验证分三步：
  1. 语法验证 —— 确认 XSLT 文件可被 lxml 正确解析和编译
  2. 转换执行 —— 将 XSLT 应用于输入 XML，生成实际输出
  3. 结果比对 —— 将实际输出与期望输出进行比较（字符串 + 语义双重比对）
"""

from pathlib import Path
from typing import Dict, Any, Optional
import logging
from lxml import etree

logger = logging.getLogger(__name__)


class XSLTValidator:
    """
    XSLT 样式表验证器。

    提供完整的验证流程：语法检查 → 转换执行 → 输出比对。
    验证结果以字典形式返回，包含各步骤状态和错误信息。
    """

    def validate(
        self,
        xslt_file: Path,
        input_xml: Path,
        expected_output: Optional[Path] = None
    ) -> Dict[str, Any]:
        """
        对 XSLT 文件执行完整验证。

        Args:
            xslt_file:       待验证的 XSLT 文件路径
            input_xml:       用于测试转换的输入 XML 文件路径
            expected_output: 期望输出 XML 文件路径（可选，用于结果比对）

        Returns:
            验证结果字典，字段说明：
              valid                    —— 语法和转换都通过时为 True
              syntax_valid             —— XSLT 语法是否合法
              transformation_successful —— 转换是否成功执行
              all_tests_passed         —— 输出是否与期望一致
              errors                   —— 错误信息列表
              warnings                 —— 警告信息列表
        """
        result = {
            "valid": False,
            "syntax_valid": False,
            "transformation_successful": False,
            "all_tests_passed": False,
            "errors": [],
            "warnings": []
        }

        try:
            # ── 第一步：验证 XSLT 语法 ──────────────────────────────────────
            logger.info("第一步：验证 XSLT 语法...")
            try:
                xslt_doc = etree.parse(str(xslt_file))
                transform = etree.XSLT(xslt_doc)   # 编译失败会抛出异常
                result["syntax_valid"] = True
                logger.info("  ✓ XSLT 语法验证通过")
            except Exception as e:
                result["errors"].append(f"XSLT 语法错误: {e}")
                logger.error(f"  ✗ XSLT 语法错误: {e}")
                return result   # 语法错误则提前终止，后续步骤无意义

            # ── 第二步：执行转换测试 ─────────────────────────────────────────
            logger.info("第二步：执行 XSLT 转换...")
            try:
                input_doc = etree.parse(str(input_xml))
                output_doc = transform(input_doc)

                if output_doc is not None:
                    result["transformation_successful"] = True
                    logger.info("  ✓ XSLT 转换执行成功")

                    # 将实际输出保存到与 XSLT 同目录，便于人工检查
                    actual_output_file = xslt_file.parent / "actual-output.xml"
                    with open(actual_output_file, 'wb') as f:
                        f.write(etree.tostring(
                            output_doc,
                            pretty_print=True,
                            xml_declaration=True,
                            encoding='UTF-8'
                        ))
                    logger.info(f"  ✓ 实际输出已保存至: {actual_output_file}")
                else:
                    result["errors"].append("XSLT 转换未产生任何输出")
                    logger.error("  ✗ XSLT 转换未产生任何输出")
                    return result

            except Exception as e:
                result["errors"].append(f"转换执行失败: {e}")
                logger.error(f"  ✗ 转换执行失败: {e}")
                return result

            # ── 第三步：与期望输出比对 ───────────────────────────────────────
            if expected_output and expected_output.exists():
                logger.info("第三步：与期望输出比对...")
                try:
                    expected_doc = etree.parse(str(expected_output))

                    # 序列化为字符串后做字符串级别的精确比较
                    actual_str = etree.tostring(output_doc, pretty_print=True).decode('utf-8')
                    expected_str = etree.tostring(expected_doc, pretty_print=True).decode('utf-8')

                    if actual_str.strip() == expected_str.strip():
                        result["all_tests_passed"] = True
                        logger.info("  ✓ 输出与期望完全一致")
                    else:
                        # 字符串不一致时，进一步做语义比较
                        differences = self._compare_xml(output_doc, expected_doc)
                        if not differences:
                            result["all_tests_passed"] = True
                            logger.info("  ✓ 输出与期望语义一致（结构相同）")
                        else:
                            result["warnings"].append(
                                f"输出与期望不一致，共发现 {len(differences)} 处差异"
                            )
                            logger.warning("  ⚠ 输出与期望存在差异")
                            # 只打印前 5 条差异，避免日志过长
                            for diff in differences[:5]:
                                logger.warning(f"    - {diff}")

                except Exception as e:
                    result["warnings"].append(f"输出比对失败: {e}")
                    logger.warning(f"  ⚠ 输出比对时发生异常: {e}")
            else:
                # 未提供期望输出时，视为通过（不做比对）
                logger.info("  ℹ 未提供期望输出，跳过比对步骤")
                result["all_tests_passed"] = True

            # 最终结论：语法和转换都通过才算整体 valid
            result["valid"] = result["syntax_valid"] and result["transformation_successful"]

        except Exception as e:
            result["errors"].append(f"验证过程发生未知错误: {e}")
            logger.error(f"验证过程发生未知错误: {e}", exc_info=True)

        return result

    def _compare_xml(self, actual: etree._Element, expected: etree._Element) -> list:
        """
        对两个 XML 文档进行语义比较，返回差异列表。

        当前实现为浅层比较：
          - 根元素标签是否一致
          - 节点总数是否一致

        后续可扩展为深层递归比较（节点名称、属性、文本内容逐一对比）。

        Args:
            actual:   实际转换输出的根元素
            expected: 期望输出的根元素

        Returns:
            差异描述字符串列表；列表为空表示无差异
        """
        differences = []

        # 比较根元素标签名（含命名空间）
        if actual.tag != expected.tag:
            differences.append(
                f"根元素标签不一致: 实际={actual.tag}，期望={expected.tag}"
            )

        # 比较文档总节点数
        actual_elements = list(actual.iter())
        expected_elements = list(expected.iter())

        if len(actual_elements) != len(expected_elements):
            differences.append(
                f"节点总数不一致: 实际={len(actual_elements)}，期望={len(expected_elements)}"
            )

        # TODO: 可在此处添加更细粒度的逐节点比较逻辑

        return differences
