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
  <xsl:variable name="LabelWidth">420</xsl:variable>
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
        <th width="300" ></th>
        <th width="20"></th>
        <th width="80"></th>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left">-</td>
        <td align ="left"></td>
        <td align ="right">-</td>
        <td></td>
      </tr>
      <!--tr height ="0">
        <th width="{$LabelWidth}/6*4" ></th>
        <th width="{$LabelWidth}/6*2"></th>
      </tr-->
      <xsl:if test="$PrintType = 1">
        <tr height ="40" style="{$FontUppercase_12}" valign="bottom">
          <td colspan ="3" align="center">
            <b>
              <xsl:value-of select="./Units/MainUnit/Identifications/Identification/TypeStatus"/>
              <xsl:if test="./Units/MainUnit/Identifications/Identification/TypeNotes = '?'">
                <xsl:text> </xsl:text><xsl:value-of select="./Units/MainUnit/Identifications/Identification/TypeNotes"/>
              </xsl:if>
            </b>
          </td>
          <td style="{$FontSmall}" align="right" valign="top">
            <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
          </td>
        </tr>
        <!--xsl:call-template name="Type"/-->
      </xsl:if>
      <xsl:if test="$PrintCollection = 1">
        <tr>
        <td align ="left" style="{$FontCollection}">
          <u><xsl:value-of select="./Storages/Storage/Collection"/></u>
        </td>
      </tr>
      </xsl:if>

      <xsl:for-each select="./Units/MainUnit/Identifications/Identification[TypeStatus]">
        <xsl:if test="position()=1">
          <xsl:for-each select="./Taxon/TaxonPart">
            <tr height ="20" style="{$FontTaxonName}">
              <td colspan ="3" align="center">
                <xsl:call-template name="TaxonPartLine1"/>
              </td>
            </tr>
            <xsl:if test="./Rank != 'sp.'">
              <tr height ="20" style="{$FontTaxonName}">
                <td colspan ="3" align="center">
                  <xsl:call-template name="TaxonPartLine2"/>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>

      <!--tr height ="20" style="{$FontTaxonName}">
        <td colspan ="3" align="center">
          <xsl:for-each select="./Units/MainUnit/Identifications/Identification[TypeStatus]">
              <xsl:call-template name="TaxonomicNameLine1"/>
          </xsl:for-each>
        </td>
      </tr>
      <xsl:for-each select="./Units/MainUnit/Identifications/Identification[TypeStatus]">
          <xsl:if test="./Taxon/Rank != 'sp.'">
            <tr height ="20" style="{$FontTaxonName}">
              <td colspan ="3" align="center">
                <xsl:call-template name="TaxonomicNameLine2"/>
              </td>
            </tr>
          </xsl:if>
      </xsl:for-each>

      <tr height ="20" style="{$FontTaxonName}">
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
      </xsl:for-each-->
      <!--tr height ="20" style="{$FontTaxonName}">
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
      <!--tr height ="20" style="{$FontTaxonName}">
        <td colspan ="3" align="center">
          <b>
            <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
              <xsl:if test="position()=1">
                <xsl:call-template name="TaxonomicName"/>
              </xsl:if>
            </xsl:for-each>
          </b>
        </td>
      </tr-->
      <xsl:if test="$PrintLocality = 1">
        <tr style="{$FontSmall}">
        <td colspan ="2">
          <xsl:call-template name="Event"/>
          <xsl:call-template name="Altitude"/>
        </td>
      </tr>
      </xsl:if>
      <xsl:if test="$PrintUnitHierarchy = 1">
        <tr style="{$FontSmall}">
        <td colspan ="2">
          <xsl:call-template name="UnitHierarchy"/>
        </td>
      </tr>
      </xsl:if>
      <xsl:if test="$PrintCollector = 1">
        <tr style="{$FontSmall}">
        <td colspan ="1" align ="left" valign ="top">
          <xsl:call-template name="CollectionDate"/>
        </td>
        <td colspan ="1" align ="right">
          leg: <xsl:call-template name ="Collectors"/>
        </td>
      </tr>
      </xsl:if>
      <xsl:if test="$PrintDeterminator = 1">
        <xsl:if test="./Units/MainUnit/Identifications/Identification/ResponsibleName != ''">
        <tr style="{$FontSmall}">
          <td > </td>
          <td colspan ="1" align ="right">
            det.: <xsl:value-of select="./Units/MainUnit/Identifications/Identification/ResponsibleName"/>
          </td>
        </tr>
        </xsl:if>
      </xsl:if>
      <xsl:if test="$PrintBarcode = 1">
        <xsl:if test="./AccessionNumber != ''">
          <tr height ="30" style="{$FontBarcode}">
            <td colspan ="2" align="center" valign ="bottom">
              *<xsl:value-of select="./AccessionNumber"/>*
            </td>
          </tr>
          <tr height ="10" style="{$FontDefault}">
            <td colspan ="2" align="center" valign ="top">
              <xsl:value-of select="./AccessionNumber"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>

      <xsl:if test="./Units/MainUnit/Identifications/Identification/TypeNotes != '?'">
        <tr height ="10" style="{$FontDefault}" valign="bottom">
          <td colspan ="3">
              <xsl:value-of select="./Units/MainUnit/Identifications/Identification/TypeNotes"/>
          </td>
        </tr>
      </xsl:if>

      <xsl:if test="$PrintProjectParentTitle = 1">
        <tr height ="10" style="{$FontDefault}">
          <td colspan ="1" align="left">
            <xsl:value-of select="/CollectionSpecimens/Report/ProjectParentTitle"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="$PrintUser = 1">
        <tr>
          <td colspan ="2">
            <xsl:if test="/LabelPrint/Report/Title != ''">
              <xsl:value-of select="/LabelPrint/Report/Title"/> 
            </xsl:if>
            <!--(<xsl:value-of select="./UpdateUserAndDate/User/UserInvers"/>
            <xsl:if test="./UpdateUserAndDate/User/UserCity != ''">, <xsl:value-of select="./UpdateUserAndDate/User/UserCity"/>
            </xsl:if>
            <xsl:if test="/LabelPrint/Report/Title != ''">)
            </xsl:if-->
          </td>
          <xsl:if test="$PrintDate = 1">
            <td colspan ="1" align="right">
              <xsl:value-of select="./UpdateUserAndDate/Date/Day"/>.<xsl:value-of select="./UpdateUserAndDate/Date/Month"/>.<xsl:value-of select="./UpdateUserAndDate/Date/Year"/>
            </td>
            <!--td colspan ="1" align="right">
              <xsl:value-of select="/LabelPrint/Report/Date"/>
            </td-->
          </xsl:if>
        </tr>
        <!--tr>
          <td colspan ="2">
            <xsl:if test="/LabelPrint/Report/Title != ''">
              <xsl:value-of select="/LabelPrint/Report/Title"/>
            </xsl:if>
            (<xsl:value-of select="/LabelPrint/Report/User"/>)
          </td>
          <xsl:if test="$PrintDate = 1">
              <td colspan ="1" align="right">
                <xsl:value-of select="/LabelPrint/Report/Date"/>
              </td>
          </xsl:if>
        </tr-->
      </xsl:if>
      <tr>
        <td align ="left">
          <xsl:if test="./AccessionNumber != ''">
            <xsl:value-of select="./AccessionNumber"/>
          </xsl:if>
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