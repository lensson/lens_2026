"""
lens_migration.generator —— 生成子包

提供以下生成器：
  - XSLTGenerator : 根据 MigrationIntent 生成 XSLT 转换样式表

典型用法：
    from lens_migration.generator import XSLTGenerator
    xslt = XSLTGenerator().generate(intent, input_xml_str)
"""

from lens_migration.generator.xslt_generator import XSLTGenerator

__all__ = ["XSLTGenerator"]

