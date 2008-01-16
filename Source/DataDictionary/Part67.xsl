<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
  Program: GDCM (Grass Root DICOM). A DICOM library
  Module:  $URL$

  Copyright (c) 2006-2008 Mathieu Malaterre
  All rights reserved.
  See Copyright.txt or http://gdcm.sourceforge.net/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.
-->
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<!--
  MAIN template
-->
  <xsl:template match="/">
    <xsl:comment>
  Program: GDCM (Grass Root DICOM). A DICOM library
  Module:  $URL$

  Copyright (c) 2006-2008 Mathieu Malaterre
  All rights reserved.
  See Copyright.txt or http://gdcm.sourceforge.net/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.
</xsl:comment>
    <dicts edition="2007">
      <xsl:apply-templates select="article/sect1/informaltable"/>
      <xsl:apply-templates select="article/sect1/sect2/informaltable"/>
    </dicts>
  </xsl:template>
  <xsl:template match="article/sect1/sect2/informaltable">
    <!--xsl:message>coucou</xsl:message-->
        <xsl:if test="tgroup/tbody/row/entry[1]/para = 'Message Field'">
          <xsl:apply-templates select="." mode="data-elements">
            <xsl:with-param name="title" select="preceding::title[1]"/>
<!-- Get the table name -->
          </xsl:apply-templates>
        </xsl:if>
  </xsl:template>
  <xsl:template match="article/sect1/informaltable">
      <!--xsl:for-each select="article/sect1/informaltable"-->
        <xsl:if test="tgroup/tbody/row/entry[1]/para = 'Tag'">
<!-- Does the table header contains ... -->
          <xsl:apply-templates select="." mode="data-elements">
            <xsl:with-param name="title" select="preceding::title[1]"/>
<!-- Get the table name -->
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="tgroup/tbody/row/entry[1]/para = 'UID Value'">
<!-- Does the table header contains ... -->
          <xsl:apply-templates select="." mode="uid">
            <xsl:with-param name="title" select="preceding::para[1]"/>
<!-- Get the table name -->
          </xsl:apply-templates>
        </xsl:if>
      <!--/xsl:for-each-->
  </xsl:template>
<!--

template for a row in data-elements mode. Should be:

  Tag | Name | VR | VM | (RET)?

-->
  <xsl:template match="row" mode="data-elements-part7">
    <xsl:param name="retired" select="0"/>
    <xsl:if test="entry[1]/para != 'Message Field'">
          <xsl:variable name="tag_value" select="translate(entry[2]/para,'ABCDEF','abcdef')"/>
          <xsl:variable name="group_value" select="substring-after(substring-before($tag_value,','), '(')"/>
          <xsl:variable name="element_value" select="substring-after(substring-before($tag_value,')'), ',')"/>
<xsl:variable name="vr">
        <xsl:call-template name="process-vr">
          <xsl:with-param name="text" select="normalize-space(entry[3]/para)"/>
        </xsl:call-template>
</xsl:variable>
          <xsl:variable name="vm" select="normalize-space(entry[4]/para)"/>
          <xsl:variable name="name" select="normalize-space(entry[1]/para)"/>
            <entry group="{$group_value}" element="{$element_value}" vr="{$vr}" vm="{$vm}" name="{$name}">
              <xsl:if test="$retired = 1">
              <xsl:attribute name="retired">true</xsl:attribute>
</xsl:if>
            </entry>
    </xsl:if>
  </xsl:template>

  <xsl:template match="row" mode="data-elements">
    <xsl:if test="entry[1]/para != 'Tag'">
<!-- skip the table header -->
          <xsl:variable name="tag_value" select="translate(entry[1]/para,'ABCDEF','abcdef')"/>
          <xsl:variable name="group_value" select="substring-after(substring-before($tag_value,','), '(')"/>
          <xsl:variable name="element_value" select="substring-after(substring-before($tag_value,')'), ',')"/>
          <!--xsl:sort select="concat(@group_value,',',@element_value)"/-->
<xsl:variable name="vr">
        <xsl:call-template name="process-vr">
          <xsl:with-param name="text" select="normalize-space(entry[3]/para)"/>
        </xsl:call-template>
</xsl:variable>
          <xsl:if test="$group_value != '' and $element_value != ''">
            <xsl:variable name="name">
              <xsl:variable name="desc_value" select="normalize-space(entry[2]/para)"/>
              <xsl:if test="$desc_value != ''">
                <description>
                  <!-- some funny quote is in the way, replace it: -->
                  <xsl:variable name="single_quote1">’</xsl:variable>
                  <xsl:variable name="single_quote2">'</xsl:variable>
                  <xsl:value-of select="translate($desc_value,$single_quote1,$single_quote2)"/>
                </description>
              </xsl:if>
            </xsl:variable>
            <entry group="{ $group_value }" element="{ $element_value }" vr="{ $vr }" vm="{normalize-space(entry[4]/para)}" retired="{ entry[5]/para = 'RET' }" name="{$name}">
<!--
              <xsl:if test="entry[3]/para != '' and entry[4]/para != ''">
                <representations>
                  <representation vr="{ entry[3]/para }" vm="{ entry[4]/para }"/>
                </representations>
              </xsl:if>
-->
            </entry>
              </xsl:if>


    </xsl:if>
  </xsl:template>

<!--
template for a row in UID mode. Should be:

  UID Value |  UID NAME |  UID TYPE | Part

-->
  <xsl:template match="row" mode="uid">
    <xsl:if test="entry[1]/para != 'UID Value'">
<!-- skip the table header -->
      <xsl:choose>
        <xsl:when test="contains(entry[2]/para,'(Retired)')">
          <xsl:variable name="name">
            <xsl:value-of select="normalize-space(substring-before(entry[2]/para,'(Retired)'))"/>
          </xsl:variable>
          <uid value="{entry[1]/para}" name="{$name}" type="{entry[3]/para}" part="{entry[4]/para}" retired="true"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="name">
            <xsl:value-of select="entry[2]/para"/>
          </xsl:variable>
          <uid value="{entry[1]/para}" name="{$name}" type="{entry[3]/para}" part="{entry[4]/para}" retired="false"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
<!--
template for a row in Frame of Reference mode. Should be:

  UID Value |  UID NAME |  Normative Reference

-->
  <xsl:template match="row" mode="frameref">
    <xsl:if test="entry[1]/para != 'UID Value'">
<!-- skip the table header -->
      <uid value="{entry[1]/para}" name="{entry[2]/para}" normative-reference="{entry[3]/para}"/>
    </xsl:if>
  </xsl:template>
<!--
template to split table into two cases: UIDs or Normative Reference:
-->
  <xsl:template match="informaltable" mode="data-elements">
    <xsl:param name="title"/>
    <dict name="{$title}">
      <xsl:choose>
      <xsl:when test="tgroup/tbody/row/entry[3]/para = 'VR'">
        <xsl:choose>
        <xsl:when test="tgroup/tbody/row/entry[1]/para = 'Message Field'">
          <xsl:variable name="retval" select="contains($title,'Retired')"/>
          <xsl:apply-templates select="tgroup/tbody/row" mode="data-elements-part7">
            <xsl:with-param name="retired" select="$retval"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="tgroup/tbody/row" mode="data-elements"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      </xsl:choose>
    </dict>
  </xsl:template>

  <xsl:template match="informaltable" mode="uid">
    <xsl:param name="title"/>
    <table name="{$title}">
      <xsl:choose>
      <xsl:when test="tgroup/tbody/row/entry[3]/para = 'Normative Reference'">
        <xsl:apply-templates select="tgroup/tbody/row" mode="frameref"/>
      </xsl:when>
      <xsl:when test="tgroup/tbody/row/entry[3]/para = 'UID TYPE'">
        <xsl:apply-templates select="tgroup/tbody/row" mode="uid"/>
      </xsl:when>
        <xsl:otherwise>
          <xsl:message>Unhandled <xsl:value-of select="$title"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
<!--
  template to process VR from PDF representation into GDCM representation
-->
<xsl:template name="process-vr">
  <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="$text='US or SSor OW'">
        <xsl:value-of select="'US_SS_OW'"/>
      </xsl:when>
      <xsl:when test="$text='US or SS'">
        <xsl:value-of select="'US_SS'"/>
      </xsl:when>
      <xsl:when test="$text='OW or OB'">
        <xsl:value-of select="'OB_OW'"/>
      </xsl:when>
      <xsl:when test="$text='OB or OW'">
        <xsl:value-of select="'OB_OW'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>