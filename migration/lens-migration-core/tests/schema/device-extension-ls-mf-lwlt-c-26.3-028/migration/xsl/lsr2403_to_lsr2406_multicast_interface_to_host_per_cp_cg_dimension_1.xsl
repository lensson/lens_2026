<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:netconf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:bbf-mgmd="urn:bbf:yang:bbf-mgmd"
                xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
                xmlns:bbf-subif="urn:bbf:yang:bbf-sub-interfaces"
                xmlns:bbf-xponvani="urn:bbf:yang:bbf-xponvani"
                xmlns:bbf-xpon="urn:bbf:yang:bbf-xpon"
                version="1.0">
	<xsl:strip-space elements="*"/>
	<xsl:output method="xml"
	            indent="yes"/>
	<xsl:variable name="interface_info_map"
	              select="map:merge(for $b in /netconf:config/if:interfaces/if:interface return map{$b/if:name : $b})"/>
							
	<xsl:variable name="multicast-interface-to-host_cache">
		<xsl:element name="multicast-interface-to-host_cache">
			<xsl:for-each select="/netconf:config/bbf-mgmd:multicast/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn/bbf-mgmd:multicast-interface-to-host">
				<xsl:sort select="bbf-mgmd:name"
				          order="descending"/>
				<xsl:copy>
					<xsl:copy-of select="./bbf-mgmd:name"/>
					<xsl:copy-of select="./bbf-mgmd:vlan-sub-interface"/>
					<xsl:variable name="host_vsi"
					              select="./bbf-mgmd:vlan-sub-interface"/>
					<xsl:variable name="host_venet"
					              select="$interface_info_map($host_vsi)/bbf-subif:subif-lower-layer/bbf-subif:interface"/>
					<xsl:variable name="host_vani"
					              select="$interface_info_map($host_venet)/bbf-xponvani:olt-v-enet/bbf-xponvani:lower-layer-interface"/>
					<xsl:variable name="host_channelpair"
					              select="$interface_info_map($host_vani)/bbf-xponvani:v-ani/bbf-xponvani:preferred-channel-pair"/>
					<xsl:variable name="host_channel-group"
					              select="$interface_info_map($host_channelpair)/bbf-xpon:channel-pair/bbf-xpon:channel-group-ref"/>
					<xsl:element name="host_venet">
						<xsl:value-of select="$host_venet"/>
					</xsl:element>
					<xsl:element name="host_vani">
						<xsl:value-of select="$host_vani"/>
					</xsl:element>
					<xsl:element name="host_channelpair">
						<xsl:value-of select="$host_channelpair"/>
					</xsl:element>
					<xsl:element name="host_channel-group">
						<xsl:value-of select="$host_channel-group"/>
					</xsl:element>
				</xsl:copy>
			</xsl:for-each>
		</xsl:element>
	</xsl:variable>

	<xsl:variable name="multicast_host_channelpair_cache">
		<xsl:element name="multicast_host_channelpair_cache">
			<xsl:for-each-group select="$multicast-interface-to-host_cache/multicast-interface-to-host_cache/bbf-mgmd:multicast-interface-to-host"
			                    group-by="host_channelpair">
				<xsl:sort select="host_channelpair"
				          order="ascending"/>
				<xsl:variable name="current_channel-pair"
				              select="current-grouping-key()"/>
				<xsl:variable name="current_count"
				              select="count(current-group()/host_channelpair)"/>
				<xsl:element name="wrong-configuration-detected">
					<xsl:if test="count(current-group()/host_channelpair)                  &gt;640                 ">
							Multicast host per channel pair(<xsl:value-of select="$current_channel-pair"/>) exceed max dimension value 640, current count is (<xsl:value-of select="$current_count"/>).
					</xsl:if>
				</xsl:element> 
			</xsl:for-each-group>
		</xsl:element>
	</xsl:variable>

	<xsl:variable name="multicast_host_channelgroup_cache">
		<xsl:element name="multicast_host_channelgroup_cache">
			<xsl:for-each-group select="$multicast-interface-to-host_cache/multicast-interface-to-host_cache/bbf-mgmd:multicast-interface-to-host"
			                    group-by="host_channel-group">
				<xsl:sort select="host_channel-group"
				          order="ascending"/>
				<xsl:variable name="current_channel-group"
				              select="current-grouping-key()"/>
				<xsl:variable name="current_count"
				              select="count(current-group()/host_channel-group)"/>
				<xsl:element name="wrong-configuration-detected">
					<xsl:if test="count(current-group()/host_channel-group)                  &gt;640                 ">
							Multicast host per channel group(<xsl:value-of select="$current_channel-group"/>) exceed max dimension value 640, current count is (<xsl:value-of select="$current_count"/>).
					</xsl:if>
				</xsl:element> 
			</xsl:for-each-group>
		</xsl:element>
	</xsl:variable>

	<xsl:template match="/netconf:config/bbf-mgmd:multicast">
      <xsl:copy-of select="."/>
			<xsl:if test="$multicast_host_channelpair_cache/multicast_host_channelpair_cache/wrong-configuration-detected != ''">
				<xsl:copy-of select="$multicast_host_channelpair_cache/multicast_host_channelpair_cache/wrong-configuration-detected"/>
			</xsl:if>
			<xsl:if test="$multicast_host_channelgroup_cache/multicast_host_channelgroup_cache/wrong-configuration-detected != ''">
				<xsl:copy-of select="$multicast_host_channelgroup_cache/multicast_host_channelgroup_cache/wrong-configuration-detected"/>
			</xsl:if>
	</xsl:template>
</xsl:stylesheet>
