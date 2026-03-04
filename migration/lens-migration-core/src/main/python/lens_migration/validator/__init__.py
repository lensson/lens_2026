"""
lens_migration.validator —— 验证子包

提供以下验证器：
  - XSLTValidator : 验证 XSLT 语法并比对转换结果与期望输出

典型用法：
    from lens_migration.validator import XSLTValidator
    result = XSLTValidator().validate(xslt_file, input_xml, expected_output)
"""

from lens_migration.validator.validator import XSLTValidator

__all__ = ["XSLTValidator"]

