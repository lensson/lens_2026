<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/aaa/1.1" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

 <xsl:param name="aaaNS" select="'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa'"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


<!-- Always homedir == /isam/logs/syslog -->
  <xsl:template match="*[name() = 'homedir']">
     <xsl:choose>
         <xsl:when test="namespace-uri() = $aaaNS">
            <xsl:element name="homedir" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">/isam/logs/syslog</xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

<!-- Add public key for techsupport -->
  <xsl:template match="*[name() = 'authentication']">
     <xsl:choose>
         <xsl:when test="namespace-uri() = $aaaNS and ./preceding-sibling::*[name()='name' and text()='techsupport']">
           <xsl:if test="count(./child::*[name()='authorized-key']) = 0">
           <xsl:copy>
              <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
              <xsl:element name="authorized-key" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">
                <xsl:element name="algorithm" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">ssh-rsa</xsl:element>
                <xsl:element name="public-key" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">AAAAB3NzaC1yc2EAAAADAQABAAABAQDA1DP9iOE20Au/9ptt5NLt9+FGhGiOwYta0N3f5gSOEVSrsiNnkiS0b9b/CmXH0lU86bn/gFoG3+Atp2bWxC/MYllpbvNrB74ENN2M+PwwaqaTl0txoDk+MA8kVQPSWXiPD/X+d+xt/uY6DYp6UNChxoeMe8NTo6rgTszYqO/W2VAwomR7RmV3V2qFSyb44HhAdbAgMlsQAOOdIKauYuAIQBCYYVJ672/dxi0pSSmjssK4LbgRxlbTtw5Uqz6IAPgUOaJO6xQKRLHzM/4QsVpQNYfnX70lvw75XvWpQLt+kGJMyof20x02j319f3KiSu3lfW9pJnIBJY3vD4p37yid</xsl:element>
              </xsl:element>
           </xsl:copy>
           </xsl:if>
           <xsl:if test="count(./child::*[name()='authorized-key']) = 1">
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
           </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

  <xsl:template match="*[name() = 'authorized-key']">
     <xsl:choose>
         <xsl:when test="namespace-uri() = $aaaNS and ../preceding-sibling::*[name()='name' and text()='techsupport']">
           <xsl:if test="count(./child::*[name()='public-key']) = 0">
           <xsl:copy>
              <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                <xsl:element name="algorithm" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">ssh-rsa</xsl:element>
                <xsl:element name="public-key" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">AAAAB3NzaC1yc2EAAAADAQABAAABAQDA1DP9iOE20Au/9ptt5NLt9+FGhGiOwYta0N3f5gSOEVSrsiNnkiS0b9b/CmXH0lU86bn/gFoG3+Atp2bWxC/MYllpbvNrB74ENN2M+PwwaqaTl0txoDk+MA8kVQPSWXiPD/X+d+xt/uY6DYp6UNChxoeMe8NTo6rgTszYqO/W2VAwomR7RmV3V2qFSyb44HhAdbAgMlsQAOOdIKauYuAIQBCYYVJ672/dxi0pSSmjssK4LbgRxlbTtw5Uqz6IAPgUOaJO6xQKRLHzM/4QsVpQNYfnX70lvw75XvWpQLt+kGJMyof20x02j319f3KiSu3lfW9pJnIBJY3vD4p37yid</xsl:element>
           </xsl:copy>
           </xsl:if>
           <xsl:if test="count(./child::*[name()='public-key']) = 1">
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
           </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

  <xsl:template match="*[name() = 'public-key']">
     <xsl:choose>
         <xsl:when test="namespace-uri() = $aaaNS and ../../preceding-sibling::*[name()='name' and text()='techsupport']">
                <xsl:element name="public-key" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">AAAAB3NzaC1yc2EAAAADAQABAAABAQDA1DP9iOE20Au/9ptt5NLt9+FGhGiOwYta0N3f5gSOEVSrsiNnkiS0b9b/CmXH0lU86bn/gFoG3+Atp2bWxC/MYllpbvNrB74ENN2M+PwwaqaTl0txoDk+MA8kVQPSWXiPD/X+d+xt/uY6DYp6UNChxoeMe8NTo6rgTszYqO/W2VAwomR7RmV3V2qFSyb44HhAdbAgMlsQAOOdIKauYuAIQBCYYVJ672/dxi0pSSmjssK4LbgRxlbTtw5Uqz6IAPgUOaJO6xQKRLHzM/4QsVpQNYfnX70lvw75XvWpQLt+kGJMyof20x02j319f3KiSu3lfW9pJnIBJY3vD4p37yid</xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

  <xsl:template match="*[name() = 'algorithm']">
     <xsl:choose>
         <xsl:when test="namespace-uri() = $aaaNS and ../../preceding-sibling::*[name()='name' and text()='techsupport']">
             <xsl:element name="algorithm" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">ssh-rsa</xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
