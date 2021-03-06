<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="Templates/LabelTemplates.xslt"/>

  <!--Fonts-->
  <xsl:variable name="FontDefault">  font-size: 7pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontSmall">    font-size:  7pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTiny">     font-size:  1pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTitle">    font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTaxonName">font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontType">     font-size: 8pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontBarcode">  font-size: 15pt; font-family: Code 39</xsl:variable>
  <xsl:variable name="FontCountry">  font-size:  9pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontPage">	   font-size: 5pt; font-family: Arial</xsl:variable>

  <!--Printing options-->
  <xsl:variable name="ReportHeader">Header of report</xsl:variable>
  <xsl:variable name="PrintReportHeader">0</xsl:variable>
  <xsl:variable name="PrintCollectionOwner">0</xsl:variable>
  <xsl:variable name="PrintReportTitle">1</xsl:variable>
  <xsl:variable name="PrintBarcode">0</xsl:variable>
  <xsl:variable name="AddSpaceAtButtom">1</xsl:variable>

  <!--Page format-->
  <xsl:variable name="LabelWidth">580</xsl:variable>
  <xsl:variable name="Space">
    <xsl:text> </xsl:text>
  </xsl:variable>

  <xsl:template match="/LabelPrint">
    <html>
      <body>
        <xsl:if test="$PrintCollectionOwner = 1">
          <table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$FontTitle}">
            <tr height ="0">
              <td>
                <u><xsl:value-of select="/LabelPrint/LabelList/Label/Collection/CollectionOwner"/></u>
              </td>
            </tr>
          </table>
        </xsl:if>
        <xsl:text>Cover label for type specimen</xsl:text>
        <hr/>
        <xsl:if test="$PrintReportHeader = 1">
          <span style="{$FontTitle}">
            <xsl:value-of select="$ReportHeader"/>
          </span>
        </xsl:if>
        <xsl:apply-templates select="LabelList/Label"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Label">
    <table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$FontDefault}">
      <tr height ="0">
        <th width="20"></th>
        <th width="460" ></th>
        <th width="20"></th>
        <th width="80"></th>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left">-</td>
        <td align ="left"></td>
        <td align ="right">-</td>
      </tr>
      <tr style="{$FontTitle}" height ="46">
        <td></td>
        <td align ="center">
          <u><xsl:value-of select="/LabelPrint/LabelList/Label/Collection/CollectionOwner"/></u>
        </td>
        <td></td>
        <td style="{$FontSmall}" align="right">
          <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
        </td>
      </tr>

      <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
        <xsl:if test="position()=1">
          <xsl:for-each select="./Taxon/TaxonPart">
            <tr height ="20" style="{$FontTaxonName}">
              <td colspan ="3" align="center">
                <xsl:call-template name="TaxonPartGenus"/>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>

      <!--tr height ="20" style="{$FontTaxonName}">
        <td colspan ="3" align="center">
          <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
            <xsl:if test="position()=1">
              <xsl:call-template name="TaxonomicNameLine1"/>
            </xsl:if>
          </xsl:for-each>
        </td>
      </tr>
      <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
        <xsl:if test="position()=1">
          <xsl:if test="./Taxon/Rank != 'sp.'">
            <tr height ="20" style="{$FontTaxonName}">
              <td colspan ="3" align="center">
                <xsl:call-template name="TaxonomicNameLine2"/>
              </td>
            </tr>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
      <tr height ="20" style="{$FontTaxonName}">
        <td colspan ="3" align="center">
          <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
            <xsl:if test="position()=1">
              <xsl:if test="./Taxon/Rank != 'sp.'">
                <xsl:call-template name="TaxonomicNameLine2"/>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </td>
      </tr-->

      <!--tr style="{$FontTaxonName}" height ="70">
        <td></td>
        <td align ="center" valign="top">
          <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
            <xsl:if test="position()=1">
              <b><xsl:call-template name="TaxonomicName"/></b>
            </xsl:if>
          </xsl:for-each>
        </td>
      </tr-->
      <tr height ="0">
        <td></td>
      </tr>
    </table>
    <xsl:if test="./Counter mod 9 = 0">
      <div align="right" style="{$FontPage}">
        <xsl:value-of select="./Counter div 9"/>
      </div>
      <h1 style="page-break-before:left"></h1>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Event">
    <span style= "{$FontCountry}">
      <xsl:if test="./CollectionEvent/CountryCache != ''">
        <xsl:value-of select="./CollectionEvent/CountryCache"/>.
      </xsl:if>
    </span>
    <xsl:value-of select="./CollectionEvent/LocalityDescription"/>
    <xsl:if test="./CollectionEvent/HabitatDescription != ''">
      <xsl:text> </xsl:text>
      <xsl:value-of select="./CollectionEvent/HabitatDescription"/>
    </xsl:if>

  </xsl:template>

  <xsl:template match="text"></xsl:template>

</xsl:stylesheet>