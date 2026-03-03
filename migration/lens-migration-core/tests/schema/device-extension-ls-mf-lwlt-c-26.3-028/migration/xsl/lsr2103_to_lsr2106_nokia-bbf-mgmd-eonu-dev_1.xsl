<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
				xmlns:mgmdNs="urn:bbf:yang:bbf-mgmd-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
    </xsl:template>


    <!-- remove 'group-membership-interval' in 'interfaces-to-hosts-data' -->
	<xsl:template match="mgmdNs:multicast-snoop-transparent-profile/mgmdNs:interfaces-to-hosts-data/mgmdNs:group-membership-interval"/>

    <!-- remove 'last-member-query-interval' in 'interfaces-to-hosts-data' -->
	<xsl:template match="mgmdNs:multicast-snoop-transparent-profile/mgmdNs:interfaces-to-hosts-data/mgmdNs:last-member-query-interval"/>

    <!-- remove 'last-member-query-count' in 'interfaces-to-hosts-data' -->
	<xsl:template match="mgmdNs:multicast-snoop-transparent-profile/mgmdNs:interfaces-to-hosts-data/mgmdNs:last-member-query-count"/>
						   
    <!-- remove 'network-interface-for-unmatched-reports' in 'multicast-vpn' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:network-interface-for-unmatched-reports"/>
	
    <!-- remove 'data-path-vlan-sub-interface' in 'multicast-interface-to-host' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:multicast-interface-to-host/mgmdNs:data-path-vlan-sub-interface"/>

    <!-- remove 'ip-layer' in 'multicast-network-interface' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:multicast-interface-to-host/mgmdNs:ip-layer"/>

    <!-- remove 'interface-to-host' in 'multicast-channel' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:multicast-channel/mgmdNs:interface-to-host"/>

    <!-- remove 'is-preview' in 'multicast-package' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:multicast-package/mgmdNs:is-preview"/>

    <!-- remove 'preview-repeat-time' in 'multicast-package' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:multicast-package/mgmdNs:preview-repeat-time"/>

    <!-- remove 'preview-repeat-count' in 'multicast-package' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:multicast-package/mgmdNs:preview-repeat-count"/>

    <!-- remove 'preview-reset-time' in 'multicast-package' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:multicast-package/mgmdNs:preview-reset-time"/>

    <!-- remove 'preview-length' in 'multicast-package' -->
	<xsl:template match="mgmdNs:multicast-vpn/mgmdNs:multicast-package/mgmdNs:preview-length"/>

</xsl:stylesheet>