<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xpongemtcont-qos="urn:bbf:yang:bbf-xpongemtcont-qos-mounted"
    xmlns:xpongemtcont="urn:bbf:yang:bbf-xpongemtcont-mounted"
    xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- <xsl:output method="xml" encoding="utf-8" indent="yes"/> -->


    <!-- This is the identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>



    <!-- /onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont/bbf-xpongemtcont-mounted:tconts/bbf-xpongemtcont-mounted:tcont/bbf-xpongemtcont-qos-mounted:tm-root/bbf-xpongemtcont-qos-mounted:queue/bbf-xpongemtcont-qos-mounted:pre-emption  -->
    <xsl:template match="*[name() = 'pre-emption' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-qos-mounted']"/>

    <!-- /onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont/bbf-xpongemtcont-mounted:tconts/bbf-xpongemtcont-mounted:tcont/bbf-xpongemtcont-qos-mounted:tm-root/bbf-xpongemtcont-qos-mounted:queue/bbf-xpongemtcont-qos-mounted:dual-rate-scheduling -->
    <!-- /onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont/bbf-xpongemtcont-mounted:tconts/bbf-xpongemtcont-mounted:tcont/bbf-xpongemtcont-qos-mounted:tm-root/bbf-xpongemtcont-qos-mounted:queue/bbf-xpongemtcont-qos-mounted:dual-rate-scheduling/bbf-xpongemtcont-qos-mounted:cir-traffic/bbf-xpongemtcont-qos-mounted:extended-weight  -->
    <!-- /onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont/bbf-xpongemtcont-mounted:tconts/bbf-xpongemtcont-mounted:tcont/bbf-xpongemtcont-qos-mounted:tm-root/bbf-xpongemtcont-qos-mounted:queue/bbf-xpongemtcont-qos-mounted:dual-rate-scheduling/bbf-xpongemtcont-qos-mounted:eir-traffic/bbf-xpongemtcont-qos-mounted:extended-weight  -->
    <xsl:template match="*[name() = 'dual-rate-scheduling' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-qos-mounted']"/>

    <!-- /onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont/bbf-xpongemtcont-mounted:tconts/bbf-xpongemtcont-mounted:tcont/bbf-xpongemtcont-qos-mounted:tm-root/bbf-xpongemtcont-qos-mounted:queue/bbf-xpongemtcont-qos-mounted:extended-weight -->
    <xsl:template match="*[name() = 'extended-weigh' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-qos-mounted']"/>


    <!-- /onu:onus/onu:onu/onu:root/if-mounted:interfaces/if-mounted:interface/bbf-qos-tm-mounted:tm-root/bbf-qos-tm-mounted:queue/bbf-qos-tm-mounted:pre-emption  -->
    <xsl:template match="*[name() = 'pre-emption' and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt-mounted']"/>

    <!-- /onu:onus/onu:onu/onu:root/if-mounted:interfaces/if-mounted:interface/bbf-qos-tm-mounted:tm-root/bbf-qos-tm-mounted:queue/bbf-qos-tm-mounted:dual-rate-scheduling -->
    <!-- /onu:onus/onu:onu/onu:root/if-mounted:interfaces/if-mounted:interface/bbf-qos-tm-mounted:tm-root/bbf-qos-tm-mounted:queue/bbf-qos-tm-mounted:dual-rate-scheduling/bbf-qos-tm-mounted:eir-traffic/bbf-qos-tm-mounted:extended-weight -->
    <!-- /onu:onus/onu:onu/onu:root/if-mounted:interfaces/if-mounted:interface/bbf-qos-tm-mounted:tm-root/bbf-qos-tm-mounted:queue/bbf-qos-tm-mounted:dual-rate-scheduling/bbf-qos-tm-mounted:cir-traffic/bbf-qos-tm-mounted:extended-weight  -->
    <xsl:template match="*[name() = 'dual-rate-scheduling' and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt-mounted']"/>

    
    <!-- /onu:onus/onu:onu/onu:root/if-mounted:interfaces/if-mounted:interface/bbf-qos-tm-mounted:tm-root/bbf-qos-tm-mounted:queue/bbf-qos-tm-mounted:extended-weight  -->
    <xsl:template match="*[name() = 'extended-weigh' and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt-mounted']"/>





</xsl:stylesheet>
