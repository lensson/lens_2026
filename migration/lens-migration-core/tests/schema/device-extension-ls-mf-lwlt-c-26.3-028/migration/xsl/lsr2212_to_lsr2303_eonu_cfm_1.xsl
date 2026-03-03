<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:dot1q-cfm="urn:bbf:yang:dot1q-cfm-mounted"
                xmlns:cfm-bridge="urn:bbf:yang:cfm-bridge-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>


<!-- remove unsupported nodes -->
<xsl:template match="*[name() = 'fault-alarm-transmission'
        and parent::*[name() = 'maintenance-domain']
        and ancestor::*[name() = 'cfm']
        and ancestor::*[name() = 'onu']
        and ancestor::*[name() = 'onus']
    ]">
</xsl:template>
<xsl:template match="*[name() = 'fault-alarm-transmission'
        and parent::*[name() = 'maintenance-association']
        and ancestor::*[name() = 'maintenance-domain']
        and ancestor::*[name() = 'cfm']
        and ancestor::*[name() = 'onu']
        and ancestor::*[name() = 'onus']
    ]">
</xsl:template>
<xsl:template match="*[(name() = 'mac-address' or name() = 'inactive-remote-mep' or name() = 'mep-db' or name() = 'stats' or name() = 'transmit-loopback' or name() = 'transmit-linktrace' or name() = 'linktrace-reply')
        and parent::*[name() = 'mep']
        and ancestor::*[name() = 'maintenance-group']
        and ancestor::*[name() = 'cfm']
        and ancestor::*[name() = 'onu']
        and ancestor::*[name() = 'onus']
    ]">
</xsl:template>
<xsl:template match="*[(name() = 'fault-alarm-transmission' or name() = 'fng-state' or name() = 'highest-priority-defect' or name() = 'defects' or name() = 'error-ccm-last-failure' or name() = 'xcon-ccm-last-failure')
        and parent::*[name() = 'continuity-check']
        and ancestor::*[name() = 'mep']
        and ancestor::*[name() = 'maintenance-group']
        and ancestor::*[name() = 'cfm']
        and ancestor::*[name() = 'onu']
        and ancestor::*[name() = 'onus']
    ]">
</xsl:template>
<xsl:template match="*[name() = 'mip'
        and parent::*[name() = 'maintenance-group']
        and ancestor::*[name() = 'cfm']
        and ancestor::*[name() = 'onu']
        and ancestor::*[name() = 'onus']
    ]">
</xsl:template>

</xsl:stylesheet>