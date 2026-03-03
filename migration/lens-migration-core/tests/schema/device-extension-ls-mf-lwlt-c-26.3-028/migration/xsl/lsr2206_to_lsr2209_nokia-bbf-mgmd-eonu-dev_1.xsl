<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                  xmlns:mgmdNs="urn:bbf:yang:bbf-mgmd-mounted">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
       <xsl:copy>
         <xsl:copy-of select="@*"/>
           <xsl:apply-templates/>
       </xsl:copy>
    </xsl:template>


    <!-- remove 'multicast-snoop-with-proxy-reporting-profile' -->
    <xsl:template match="mgmdNs:multicast-snoop-with-proxy-reporting-profile"/>

    <!-- remove 'multicast-proxy-profile' -->
    <xsl:template match="mgmdNs:multicast-proxy-profile"/>

    <!-- remove 'ip-to-host' in 'multicast-vpn' -->
    <xsl:template match="mgmdNs:multicast-vpn/mgmdNs:ip-to-host"/>

 </xsl:stylesheet>

