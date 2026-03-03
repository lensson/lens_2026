<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters" xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters" xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies" xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers" xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing" xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext" xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension" xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension" xmlns="" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- clean unused policy -->
  <xsl:template match="*[     local-name() = 'policy' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies'     and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]" priority="9">

    <xsl:variable name="curName">
      <xsl:value-of select="child::*[local-name() = 'name']"/>
    </xsl:variable>

    <xsl:variable name="anyoneLabelDeleted" select="//*[       local-name() = 'policy'         and child::*[local-name() = 'name' and text() = $curName]         and child::*[local-name() = 'deleted']         and parent::*[local-name() = 'policies']         and ancestor::*[local-name() = 'current']         and ancestor::*[local-name() = 'migration-cache']     ]"/>

    <xsl:variable name="anyoneStillUsed" select="//*[         local-name() = 'policy'         and child::*[local-name() = 'name' and normalize-space(text()) = $curName]         and not(child::*[local-name() = 'deleted'])         and parent::*[local-name() = 'policies']         and ancestor::*[local-name() = 'current']         and ancestor::*[local-name() = 'migration-cache']     ]"/>

    <xsl:choose>
      <xsl:when test="$anyoneLabelDeleted and not($anyoneStillUsed)">
        <!-- delete labeled policy -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- clean current policy-profile if have new one -->
  <xsl:template match="*[     local-name() = 'policy-profile'     and parent::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     and boolean(child::*[local-name() = 'migration-cache']/child::*[local-name() = 'new']/child::*[local-name() = 'qos-policy-profiles']/child::*[local-name() = 'policy-profile']/child::*[local-name() = 'name'])   ]" priority="2">
  </xsl:template>

  <!-- clean policing-pre-handling-profiles is no entry in -->
  <xsl:template match="*[     local-name() = 'policing-pre-handling-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension'     and not(ancestor::*[local-name() = 'new'])     and not(child::*[local-name() = 'pre-handling-profile'])   ]" priority="2">
  </xsl:template>

  <!-- clean policing-action-profiles is no entry in -->
  <xsl:template match="*[     local-name() = 'policing-action-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension'     and not(ancestor::*[local-name() = 'new'])     and not(child::*[local-name() = 'action-profile'])   ]" priority="2">
  </xsl:template>

  <!-- BBN-122791 when policing pre-handling-profile have dual vlans tag, only keep the second one -->
  <xsl:template match="*[     local-name() = 'vlans' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension'     and parent::*[local-name() = 'match-params' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']     and ancestor::*[local-name() = 'pre-handling-entry' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']     and ancestor::*[local-name() = 'pre-handling-profile' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']     and ancestor::*[local-name() = 'policing-pre-handling-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']   ]" priority="2">
    <xsl:choose>
      <xsl:when test="count(child::*[local-name() = 'tag']) &gt; 1">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:for-each select="child::*[local-name() = 'tag']">
            <xsl:if test="position() = 2">
              <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:if>
          </xsl:for-each>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- To check whether all the new enhanced-filter filter-operation value with a correct namespace prefix -->
  <xsl:template match="*[     local-name() = 'filter-operation' and namespace-uri()= 'urn:bbf:yang:bbf-qos-enhanced-filters'     and parent::*[local-name() = 'enhanced-filter' and namespace-uri()= 'urn:bbf:yang:bbf-qos-enhanced-filters']     and ancestor::*[local-name() = 'filters' and namespace-uri()= 'urn:bbf:yang:bbf-qos-filters']     and not(ancestor::*[local-name() = 'new'])   ]">

    <xsl:variable name="clsNsPrefix">
      <xsl:value-of select="local-name(namespace::*[. = 'urn:bbf:yang:bbf-qos-classifiers'])"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:choose>
        <xsl:when test="$clsNsPrefix and string-length($clsNsPrefix)&gt;0 and not(starts-with(current(),$clsNsPrefix))">
          <xsl:value-of select="concat($clsNsPrefix,':',current())"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
</xsl:otherwise>
      </xsl:choose>
    </xsl:copy>

  </xsl:template>

  <!-- Delete migration-cache -->
  <xsl:template match="*[     local-name() = 'migration-cache'   ]" priority="1">
  </xsl:template>

  <!-- Delete policy migration cache-->
  <xsl:template match="*[     local-name() = 'policy-migration-cache'     and parent::*[local-name() = 'policy']     and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]" priority="1">
  </xsl:template>
  
  <!-- Delete policy migration cache-->
  <xsl:template match="*[     local-name() = 'newClassifiers'     and parent::*[local-name() = 'classifier-entry']     and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']   ]" priority="1">
  </xsl:template>
  
  <xsl:template match="*[     local-name() = 'newPolicy'     and parent::*[local-name() = 'policy']     and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]" priority="1">
  </xsl:template>
  
  <!-- Delete sequence info-->
  <xsl:template match="*[     local-name() = 'sequence'     and parent::*[local-name() = 'policy-list']     and ancestor::*[local-name() = 'policy-profile']     and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]" priority="1">
  </xsl:template>

  <!-- Following cases is post-processing the unused policy and classifier which doesn't obey the rule of new model -->
  <!-- https://confluence-app.ext.net.nokia.com/display/FIBERFWD2/migration+issue -->
  <!-- Issue 1.2, delete the action flow-color when filter include enhanced-filter or any-frame -->
  <xsl:template match="*[     local-name() = 'classifier-action-entry-cfg' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers'     and child::*[local-name() = 'flow-color' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']     and parent::*[local-name() = 'classifier-entry' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     and (../child::*[local-name() = 'enhanced-filter-name' and namespace-uri() = 'urn:bbf:yang:bbf-qos-enhanced-filters']     or ../child::*[local-name() = 'any-frame' and namespace-uri() = 'urn:bbf:yang:bbf-qos-enhanced-filters'])   ]">

  </xsl:template>

  <!-- Issue 2, post-processing the unmetered classifier -->
  <xsl:template match="*[     local-name() = 'classifier-entry' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers'     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     and child::*[local-name() = 'match-criteria']/child::*[local-name() = 'unmetered']   ]">
    <xsl:variable name="inlineTagNumber">
      <xsl:value-of select="count(child::*[local-name() = 'match-criteria']/node())"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$inlineTagNumber &gt; 1">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:for-each select="node()">
            <xsl:choose>
              <xsl:when test="local-name() = 'match-criteria'">
                <xsl:copy>
                  <xsl:copy-of select="@*"/>
<xsl:for-each select="node()">
                    <xsl:if test="local-name() != 'unmetered'">
                      <xsl:copy-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:copy>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:copy-of select="child::*[local-name() = 'name']"/>
          <xsl:copy-of select="child::*[local-name() = 'filter-operation']"/>
          <xsl:element name="metered-flow" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext"><xsl:value-of select="false()"/></xsl:element>
          <xsl:for-each select="node()">
            <xsl:choose>
              <xsl:when test="local-name() = 'name'"/>
              <xsl:when test="local-name() = 'filter-operation'"/>
              <xsl:when test="local-name() = 'match-criteria'"/>
              <xsl:otherwise>
                <xsl:copy-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Issue 3, delete bac-color action when both bac-color and schedule action exist in classifier -->
  <xsl:template match="*[     local-name() = 'classifier-action-entry-cfg' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers'     and child::*[local-name() = 'bac-color' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']     and not(ancestor::*[local-name() = 'new'])     and ../child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'scheduling-traffic-class']   ]">

  </xsl:template>

  <!-- BBN-133774 Migrate data store stage failed with errorMessage "Duplicate elements in node for policing-action-profiles" for LS-F-FGLT-B -->
  <xsl:template match="*[     local-name() = 'action-profile' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension'     and parent::*[local-name() = 'policing-action-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']   ]">
    <xsl:variable name="curActionProfileName">
      <xsl:value-of select="child::*[local-name() = 'name']"/>
    </xsl:variable>
    <xsl:variable name="curRealName">
      <xsl:value-of select="./nokia-sdan-qos-policing-extension:realName"/>
    </xsl:variable>
    <xsl:variable name="hasConflict" select="//*[         local-name() = 'action-profile'         and child::*[local-name() = 'name' and text() = $curActionProfileName]         and child::*[local-name() = 'realName' and text() != $curRealName]         and parent::*[local-name() = 'policing-action-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']     ]"/>

    <xsl:variable name="preActionProfileWithSameName" select="preceding-sibling::*[local-name() = 'action-profile' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension'       and child::*[local-name() = 'name'] = $curActionProfileName]"/>
    <xsl:choose>
      <xsl:when test="$preActionProfileWithSameName">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:copy-of select="child::*[local-name() = 'name']"/>
          <xsl:if test="boolean($hasConflict) and string-length(normalize-space($hasConflict))&gt;0">
              <wrong-configuration-detected>There is a conflict with the policing action profile,name(<xsl:value-of select="$curActionProfileName"/>).</wrong-configuration-detected>
          </xsl:if>
          <xsl:for-each select="child::*[local-name() = 'action']">
            <xsl:variable name="curFlowColor">
              <xsl:value-of select="child::*[local-name() = 'flow-color']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="preceding-sibling::*[               local-name() = 'action'               and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension'               and contains(child::*[local-name() = 'flow-color'],$curFlowColor)               ]">
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy>
                  <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[     local-name() = 'pre-handling-profile' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension'     and parent::*[local-name() = 'policing-pre-handling-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']   ]">
    <xsl:variable name="curPrehandlingProfileName">
      <xsl:value-of select="child::*[local-name() = 'name']"/>
    </xsl:variable>
    <xsl:variable name="prePrehandlingProfileWithSameName" select="preceding-sibling::*[local-name() = 'pre-handling-profile' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension'       and child::*[local-name() = 'name'] = $curPrehandlingProfileName]"/>
    <xsl:choose>
      <xsl:when test="$prePrehandlingProfileWithSameName">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:copy-of select="@* | node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
