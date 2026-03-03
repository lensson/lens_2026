<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:classfileNs="urn:bbf:yang:bbf-qos-classifiers-mounted"
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
    xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted"
>

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- default rule -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="qosNs:policy[preceding-sibling::qosNs:policy[@name = current()/@name] and ancestor::*[name() = 'onu'] and parent::*[name() = 'policies']]"/>
    <xsl:template match="qosNs:policy-profile[preceding-sibling::qosNs:policy-profile[@name = current()/@name] and ancestor::*[name() = 'onu'] and parent::*[name() = 'qos-policy-profiles']   ]"/>
    <xsl:template match="classfileNs:classifier-entry[preceding-sibling::classfileNs:classifier-entry[@name = current()/@name]  and ancestor::*[name() = 'onu'] and parent::*[name() = 'classifiers']  ]"/>
</xsl:stylesheet>
