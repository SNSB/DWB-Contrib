<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="Templates/LabelTemplates.xslt"/>

  <!--Fonts-->
  <xsl:variable name="FontCollection">font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontDefault">  font-size: 8pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontSmall">    font-size:  6pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTitle">    font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTaxonName">font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontType">     font-size: 12pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontBarcode">  font-size: 14pt; font-family: Code 39</xsl:variable>
  <xsl:variable name="FontCountry">  font-size:  6pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  
  <!--Printing options-->
  <xsl:variable name="ReportHeader">Header of report</xsl:variable>
  <xsl:variable name="PrintReportHeader">0</xsl:variable>
  <xsl:variable name="PrintCollectionOwner">0</xsl:variable>
  <xsl:variable name="PrintReportTitle">1</xsl:variable>
  <xsl:variable name="PrintBarcode">0</xsl:variable>
  <xsl:variable name="PrintCollector">0</xsl:variable>
  <xsl:variable name="PrintDeterminator">0</xsl:variable>
  <xsl:variable name="PrintLocality">0</xsl:variable>
  <xsl:variable name="PrintUnitHierarchy">0</xsl:variable>
  <xsl:variable name="PrintCollection">0</xsl:variable>
  <xsl:variable name="PrintProjectTitle">0</xsl:variable>
  <xsl:variable name="PrintProjectParentTitle">1</xsl:variable>
  <xsl:variable name="PrintDate">1</xsl:variable>
  <xsl:variable name="PrintType">1</xsl:variable>
  <xsl:variable name="PrintLines">0</xsl:variable>
  <xsl:variable name="PrintUser">1</xsl:variable>

  <!--Page format-->
  <xsl:variable name="LabelWidth">320</xsl:variable>
  <!--xsl:variable name="LabelWidth">300</xsl:variable-->
  <xsl:variable name="Space">
    <xsl:text> </xsl:text>
  </xsl:variable>

  <xsl:template match="/LabelPrint">
    <html>
      <body>
        <xsl:if test="$PrintCollectionOwner = 1">
          <table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontCollection}">
            <tr height ="0">
              <td>
                <xsl:value-of select="/LabelPrint/LabelList/Label/Collection/CollectionOwner"/>
              </td>
            </tr>
          </table>
        </xsl:if>
        <xsl:text>Type label for type specimen</xsl:text>
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
    <xsl:if test="$PrintLines = 1">
      <hr/>
    </xsl:if>
    <table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
      <tr height ="0">
        <th width="20"></th>
        <th width="200" ></th>
        <th width="20"></th>
        <th width="80"></th>
      </tr>
      <tr height ="1" valign="bottom">
        <td align ="left">-</td>
        <td align ="left"></td>
        <td align ="right">-</td>
        <td></td>
      </tr>

      <tr height ="10" valign="top">
        <td align ="left"></td>
        <td align ="left"></td>
        <td align ="right"></td>
        <td align ="left">
          <xsl:if test="./CollectionSpecimen/AccessionNumber != ''">
            <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
          </xsl:if>
        </td>
      </tr>

      <tr height ="20" style="{$FontTaxonName}">
        <td colspan ="3" align="center">
          <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
            <xsl:if test="position()=1">
              <xsl:for-each select="./Taxon/TaxonPart">
                <xsl:call-template name="TaxonPartLine1"/>
                <xsl:if test="./Rank != 'sp.'">
                  <xsl:call-template name="TaxonPartLine2"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </td>
      </tr>

      <tr height ="20" style="{$FontTaxonName}">
        <td colspan ="3" align="center">
          <xsl:for-each select="./Units/MainUnit/Identifications/Identification[TypeStatus]">
            <xsl:if test="position()=last()">
              <xsl:for-each select="./Taxon/TaxonPart">
                                  
               type of: <xsl:call-template name="TaxonPartLine1"/>
                <xsl:if test="./Rank != 'sp.'">
                      <xsl:call-template name="TaxonPartLine2"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </td>
      </tr>


    </table>
    <xsl:if test="$PrintLines = 1">
      <hr/>
    </xsl:if>
  </xsl:template>
 
  <xsl:template name="Event">
    <span style= "{$FontCountry}">
      <xsl:value-of select="./CollectionEvent/CountryCache"/>.
    </span> <xsl:value-of select="./CollectionEvent/LocalityDescription"/>. <xsl:value-of select="./CollectionEvent/HabitatDescription"/>.
  </xsl:template>
  
  <xsl:template match="text"></xsl:template>

</xsl:stylesheet>