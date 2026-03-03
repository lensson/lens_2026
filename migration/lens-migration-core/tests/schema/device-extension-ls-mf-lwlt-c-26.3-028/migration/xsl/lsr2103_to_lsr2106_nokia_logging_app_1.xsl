<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:nokiaLog="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

 <xsl:variable name="critical">1</xsl:variable>
 <xsl:variable name="error">2</xsl:variable>
 <xsl:variable name="warning">3</xsl:variable>
 <xsl:variable name="info">4</xsl:variable>
 <xsl:variable name="debug">5</xsl:variable>
 <xsl:variable name="vars" select="document('')/*/xsl:variable"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

<!--  Modify the loggers configuration for certmanager_hwa and certmanager_logic -->
  <xsl:template match="/tailf:config/nokiaLog:loggers/nokiaLog:enable-logging-for">
     <xsl:choose><!-- choose 1-->
         <xsl:when test="./nokiaLog:app-name[text()='certmanager_logic_app']">
            <enable-logging-for xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app">
              <app-name>certmanager_app</app-name>
                <!-- save certlogic log level to variable level1 -->
                <xsl:variable name="level1">
                  <xsl:choose>
                  <xsl:when test="./nokiaLog:modules/nokiaLog:mod-name[text()='certmgrsyslog']">
                    <xsl:value-of select="./nokiaLog:modules/nokiaLog:mod-name[text()='certmgrsyslog']/following-sibling::nokiaLog:level/text()"/>
                  </xsl:when>
                  <!-- if this value does not exist in configuration then save default warning in level2 -->
                  <xsl:otherwise>
                    <xsl:text>warning</xsl:text>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <!-- save certhwa certmgr_hwa_syslog log level to variable level2 -->
                <xsl:variable name="level2">
                  <xsl:choose>
                  <xsl:when test="./ancestor::nokiaLog:loggers/nokiaLog:enable-logging-for/nokiaLog:app-name[text()='certmanager_hwa_app']/following-sibling::nokiaLog:modules/nokiaLog:mod-name[text()='certmgr_hwa_syslog']">
                    <xsl:value-of select="./ancestor::nokiaLog:loggers/nokiaLog:enable-logging-for/nokiaLog:app-name[text()='certmanager_hwa_app']/following-sibling::nokiaLog:modules/nokiaLog:mod-name[text()='certmgr_hwa_syslog']/following-sibling::nokiaLog:level/text()"/>
                  </xsl:when>
                  <!-- if this value does not exist in configuration then save default warning in level2 -->
                  <xsl:otherwise>
                    <xsl:text>warning</xsl:text>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>

                <xsl:choose><!-- choose 2-->
                  <!-- get numeric value equivalent to level1 from $vars and compare to numeric value for level2,level3 -->
                  <xsl:when test="$vars[@name = $level1] &gt;= $vars[@name = $level2]">
                    <modules>
                      <mod-name>certmanager</mod-name>
                      <level><xsl:value-of select="$level1"/></level>
                    </modules>
                  </xsl:when>
                <xsl:otherwise>
                  <xsl:choose><!-- choose 3-->
                    <!-- get numeric value equivalent to level2 from $vars and compare to numeric value for level1,level3 -->
                    <xsl:when test="$vars[@name = $level2] &gt;= $vars[@name = $level1]">
                      <modules>
                        <mod-name>certmanager</mod-name>
                        <level><xsl:value-of select="$level2"/></level>
                      </modules>
                    </xsl:when>
                  </xsl:choose><!-- /choose 3-->

                </xsl:otherwise>
                </xsl:choose><!-- /choose 2-->

            </enable-logging-for>
         </xsl:when>
         <!-- if certmanager_hwa_app is the only one configured -->
         <xsl:when test="./nokiaLog:app-name[text()='certmanager_hwa_app'] and not(./ancestor::nokiaLog:loggers/nokiaLog:enable-logging-for/nokiaLog:app-name[text()='certmanager_logic_app'])">
            <enable-logging-for xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app">
              <app-name>certmanager_app</app-name>
                <!-- save certmgr_hwa_syslog log level to variable hwaSyslevel1 -->
                <xsl:variable name="hwaSyslevel1">
                  <xsl:choose>
                  <xsl:when test="./nokiaLog:modules/nokiaLog:mod-name[text()='certmgr_hwa_syslog']">
                    <xsl:value-of select="./nokiaLog:modules/nokiaLog:mod-name[text()='certmgr_hwa_syslog']/following-sibling::nokiaLog:level/text()"/>
                  </xsl:when>
                  <!-- if this value does not exist in configuration then save default warning in appLevel2 -->
                  <xsl:otherwise>
                    <xsl:text>warning</xsl:text>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <modules>
                  <mod-name>certmanager</mod-name>
                  <level><xsl:value-of select="$hwaSyslevel1"/></level>
                </modules>

            </enable-logging-for>
         </xsl:when>
         <!-- remove certmanager_hwa app -->
         <xsl:when test="./nokiaLog:app-name[text()='certmanager_hwa_app']">
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose><!-- /choose 1-->
  </xsl:template>

  <!--  Modify the applications configuration for certmanager_hwa and certmanager_logic -->
  <xsl:template match="/tailf:config/nokiaLog:applications/nokiaLog:enable-logging-for">
     <xsl:choose><!-- choose 1-->
         <xsl:when test="./nokiaLog:app-name[text()='certmanager_logic_app']">
            <enable-logging-for xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app">
              <app-name>certmanager_app</app-name>
                <xsl:copy-of select="./nokiaLog:modules/nokiaLog:mod-name[text()!='certmanager']/parent::node()"/>

                <!-- save certlogic log level to variable appLevel1 -->
                <xsl:variable name="appLevel1">
                  <xsl:choose>
                  <xsl:when test="./nokiaLog:modules/nokiaLog:mod-name[text()='certmanager']">
                    <xsl:value-of select="./nokiaLog:modules/nokiaLog:mod-name[text()='certmanager']/following-sibling::nokiaLog:level/text()"/>
                  </xsl:when>
                  <!-- if this value does not exist in configuration then save default warning in appLevel1 -->
                  <xsl:otherwise>
                    <xsl:text>warning</xsl:text>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <!-- save certhwa certmanager_hwa log level to variable appLevel2 -->
                <xsl:variable name="appLevel2">
                  <xsl:choose>
                  <xsl:when test="./ancestor::nokiaLog:applications/nokiaLog:enable-logging-for/nokiaLog:app-name[text()='certmanager_hwa_app']/following-sibling::nokiaLog:modules/nokiaLog:mod-name[text()='certmanager_hwa']">
                    <xsl:value-of select="./ancestor::nokiaLog:applications/nokiaLog:enable-logging-for/nokiaLog:app-name[text()='certmanager_hwa_app']/following-sibling::nokiaLog:modules/nokiaLog:mod-name[text()='certmanager_hwa']/following-sibling::nokiaLog:level/text()"/>
                  </xsl:when>
                  <!-- if this value does not exist in configuration then save default warning in appLevel2 -->
                  <xsl:otherwise>
                    <xsl:text>warning</xsl:text>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <!-- save certhwa alarmItf log level to variable appLevel3 -->
                <xsl:variable name="appLevel3">
                  <xsl:choose>
                  <xsl:when test="./ancestor::nokiaLog:applications/nokiaLog:enable-logging-for/nokiaLog:app-name[text()='certmanager_hwa_app']/following-sibling::nokiaLog:modules/nokiaLog:mod-name[text()='alarmItf']">
                    <xsl:value-of select="./ancestor::nokiaLog:applications/nokiaLog:enable-logging-for/nokiaLog:app-name[text()='certmanager_hwa_app']/following-sibling::nokiaLog:modules/nokiaLog:mod-name[text()='alarmItf']/following-sibling::nokiaLog:level/text()"/>
                  </xsl:when>
                  <!-- if this value does not exist in configuration then save default warning in appLevel3 -->
                  <xsl:otherwise>
                    <xsl:text>warning</xsl:text>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:choose><!-- choose 2-->
                  <!-- get numeric value equivalent to appLevel1 from $vars and compare to numeric value for appLevel2 -->
                  <xsl:when test="$vars[@name = $appLevel1] &gt;= $vars[@name = $appLevel2]">
                      <modules>
                        <mod-name>certmgr</mod-name>
                        <level><xsl:value-of select="$appLevel1"/></level>
                      </modules>
                  </xsl:when>

                  <xsl:otherwise>
                    <xsl:choose><!-- choose 3-->
                      <!-- get numeric value equivalent to appLevel2 from $vars and compare to numeric value for appLevel1 -->
                      <xsl:when test="$vars[@name = $appLevel2] &gt;= $vars[@name = $appLevel1]">
                          <modules>
                            <mod-name>certmgr</mod-name>
                            <level><xsl:value-of select="$appLevel2"/></level>
                          </modules>
                      </xsl:when>
                    </xsl:choose><!-- /choose 3-->

                  </xsl:otherwise>
                </xsl:choose><!-- /choose 2-->
                <!-- add alarmItf value to configuration -->
                <modules>
                  <mod-name>alarmItf</mod-name>
                  <level><xsl:value-of select="$appLevel3"/></level>
                </modules>

            </enable-logging-for>
         </xsl:when>
         <!-- if certmanager_hwa_app is the only one configured -->
         <xsl:when test="./nokiaLog:app-name[text()='certmanager_hwa_app'] and not(./ancestor::nokiaLog:applications/nokiaLog:enable-logging-for/nokiaLog:app-name[text()='certmanager_logic_app'])">
            <enable-logging-for xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app">
              <app-name>certmanager_app</app-name>
                <xsl:copy-of select="./nokiaLog:modules/nokiaLog:mod-name[text()!='certmanager_hwa' and text()!='hwa']/parent::node()"/>

                <!-- save certhwa log level to variable hwaLevel1 -->
                <xsl:variable name="hwaLevel1">
                  <xsl:choose>
                  <xsl:when test="./nokiaLog:modules/nokiaLog:mod-name[text()='certmanager_hwa']">
                    <xsl:value-of select="./nokiaLog:modules/nokiaLog:mod-name[text()='certmanager_hwa']/following-sibling::nokiaLog:level/text()"/>
                  </xsl:when>
                  <!-- if this value does not exist in configuration then save default warning in hwaLevel1 -->
                  <xsl:otherwise>
                    <xsl:text>warning</xsl:text>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <modules>
                  <mod-name>certmgr</mod-name>
                  <level><xsl:value-of select="$hwaLevel1"/></level>
                </modules>

            </enable-logging-for>
         </xsl:when>
         <!-- remove certmanager_hwa app -->
         <xsl:when test="./nokiaLog:app-name[text()='certmanager_hwa_app']">
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose><!-- /choose 1-->
  </xsl:template>


</xsl:stylesheet>
