<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:template match="/">
    <dict edition="2007">
      <xsl:for-each select="article/sect1/informaltable">
        <xsl:if test="tgroup/tbody/row/entry[1]/para = 'UID Value'">
        <!--xsl:variable name="table_name_raw" select="preceding::para[1]"/-->
          <xsl:apply-templates select="." mode="uid">
          <xsl:with-param name="name" select="preceding::para[1]"/>
</xsl:apply-templates>
        </xsl:if>
      </xsl:for-each>
    </dict>
  </xsl:template>

  <xsl:template match="row" mode="uid">
    <xsl:if test="entry[1]/para != 'UID Value'" > <!-- skip the table header -->
    <uid value="{entry[1]/para}" name="{entry[2]/para}" type="{entry[3]/para}" part="{entry[4]/para}" />
</xsl:if>
  </xsl:template>

  <xsl:template match="row" mode="frameref">
    <xsl:if test="entry[1]/para != 'UID Value'" > <!-- skip the table header -->
    <uid value="{entry[1]/para}" name="{entry[2]/para}" normative-reference="{entry[3]/para}" />
</xsl:if>
  </xsl:template>

  <xsl:template match="informaltable" mode="uid">
    <xsl:param name="name"/>
<table name="{$name}">
        <xsl:if test="tgroup/tbody/row/entry[3]/para = 'Normative Reference'">
          <xsl:apply-templates select="tgroup/tbody/row" mode="frameref"/>
        </xsl:if>
        <xsl:if test="tgroup/tbody/row/entry[3]/para = 'UID TYPE'">
          <xsl:apply-templates select="tgroup/tbody/row" mode="uid"/>
        </xsl:if>
</table>
  </xsl:template>


</xsl:stylesheet>
