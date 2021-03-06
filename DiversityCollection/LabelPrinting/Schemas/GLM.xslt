<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="Templates/LabelTemplates.xslt"/>

  <!--Fonts-->
  <xsl:variable name="FontCollection">font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontDefault">  font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontSmall">    font-size:  8pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTitle">    font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTaxonName">font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontType">     font-size: 12pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontBarcode">  font-size: 16pt; font-family: Code 39</xsl:variable>
  <xsl:variable name="FontCountry">  font-size:  8pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  
  <!--Printing options-->
  <xsl:variable name="ReportHeader">Header of report</xsl:variable>
  <xsl:variable name="PrintReportHeader">0</xsl:variable>
  <xsl:variable name="PrintReportTitle">1</xsl:variable>
  <xsl:variable name="PrintDetails">1</xsl:variable>
  <xsl:variable name="PrintCollectionOwner">0</xsl:variable>

  <!--Page format-->
  <xsl:variable name="LabelWidth">280</xsl:variable>
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
        <xsl:text>Revision label for type specimen</xsl:text>
        <hr/>
        <br/>
        <br/>
        <xsl:if test="$PrintReportHeader = 1">
          <span style="{$FontTitle}">
            <xsl:value-of select="$ReportHeader"/>
          </span>
        </xsl:if>
        <xsl:apply-templates select="LabelList/Label"/>
      </body>
    </html>
  </xsl:template>


  <!--xsl:template match="/CollectionSpecimens">
    <html>
      <body>
        <xsl:value-of select="/CollectionSpecimens/CollectionSpecimen/Storages/Storage/CollectionOwner"/>
        <xsl:if test="$PrintReportHeader = 1">
          <hr/>
          <span style="{$FontTitle}">
            <xsl:value-of select="$ReportHeader"/>
          </span>
        </xsl:if>
        <xsl:apply-templates select="CollectionSpecimen"/>
      </body>
    </html>
  </xsl:template-->
  
  <xsl:template match="Label">
    <!--hr/-->
    <div>
    <table cellspacing="1" cellpadding="1" width="400" border="0" style="{$FontDefault}">
      <tr height ="0">
        <th width="150" ></th>
        <th width="100"></th>
        <th width="150"></th>
      </tr>
      <xsl:if test="./LabelTitle != ''">
      <tr height ="20">
        <td align ="center" colspan ="3" style="border-bottom:1px solid #444444">
          <xsl:value-of select="./LabelTitle"/>
        </td>
      </tr>
        <tr height ="10">
          <td>
            <xsl:text> </xsl:text>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td align ="left" colspan ="2">
          <xsl:value-of select="./Collection/CollectionName"/>
        </td>
        <td align ="right">
          Nr.  <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
        </td>
      </tr>
      <tr height ="40" style="{$FontTaxonName}">
        <td colspan ="3">
          <b>
            <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
              <xsl:if test="position()=1">
                <xsl:for-each select="./Taxon/TaxonPart">
                  <xsl:call-template name="TaxonPart"/>
                </xsl:for-each>
              </xsl:if>
            </xsl:for-each>
          </b>
          <span style="{$FontDefault}">
            <xsl:text> </xsl:text>
            <xsl:value-of select="./Units/MainUnit/Identifications/Identification/IdentificationQualifier"/>
          </span>
        </td>
      </tr>
      <xsl:if test="./Units/MainUnit/LifeStage != ''">
        <tr style="{$FontSmall}" height="20" valign="top">
          <td colspan ="3">
            Stage: <xsl:value-of select="./Units/MainUnit/LifeStage"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:call-template name="Type"/>
      <tr style="{$FontSmall}">
        <td colspan ="3">
          <xsl:call-template name="Event"/>
        </td>
      </tr>
      <tr style="{$FontSmall}">
        <td colspan ="2">
          <xsl:call-template name="Potsdam"/>
        </td>
        <td align="right">
          <xsl:call-template name="Altitude"/>
        </td>
      </tr>
      <tr style="{$FontSmall}">
        <td colspan ="3">
          <xsl:call-template name="UnitHierarchy"/>
        </td>
      </tr>
      <tr style="{$FontSmall}">
        <td colspan ="3">
          <xsl:call-template name="Habitat"/>
        </td>
      </tr>
      <tr style="{$FontSmall}">
        <td colspan ="2" align ="left" valign ="top">
          <xsl:call-template name="CollectionDate"/>
        </td>
        <td colspan ="1" align ="right">
          <xsl:apply-templates select ="Collectors"/>
        </td>
      </tr>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/ResponsibleName != ''">
        <tr style="{$FontSmall}">
          <td > </td>
          <td > </td>
          <td colspan ="1" align ="right">
            det.: <xsl:value-of select="./Units/MainUnit/Identifications/Identification/ResponsibleName"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="./CollectionSpecimen/OriginalNotes != ''">
        <tr style="{$FontSmall}">
          <td colspan ="3">
            General information: <xsl:value-of select="./CollectionSpecimen/OriginalNotes"/>
          </td>
        </tr>
      </xsl:if>
      <tr height ="60" style="{$FontBarcode}">
        <td colspan ="3" align="center" valign ="bottom">
          *<xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>*
        </td>
      </tr>
      <tr height ="20" style="{$FontDefault}">
        <xsl:if test="./Counter mod 3 != 0">
          <td colspan ="3" align="center" valign ="top" style="padding-bottom:20px; border-bottom:1px dashed #CCCCCC">
            <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
          </td>
        </xsl:if>
        <xsl:if test="./Counter mod 3 = 0">
          <td colspan ="3" align="center" valign ="top">
            <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
          </td>
        </xsl:if>
        <!--td colspan ="3" align="center" valign ="top" style="padding-bottom:20px; border-bottom:1px dashed #CCCCCC">
          <xsl:value-of select="./AccessionNumber"/>
        </td-->
      </tr>
      <xsl:if test="./Counter mod 3 != 0">
        <tr height ="20" style="{$FontDefault}">
          <td colspan ="3">
            <xsl:text> </xsl:text>
          </td>
        </tr>
      </xsl:if>
    </table>
    </div>
    <!--hr/-->
    <xsl:if test="./Counter mod 3 = 0">
		  <h1 style="page-break-before:right"></h1>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="Collectors">
    leg.: <xsl:apply-templates select ="Collector"/>
  </xsl:template>
  
  <xsl:template match="Collector">
    <xsl:value-of select="./CollectorsName"/>
    <xsl:apply-templates select ="CollectorsNumber"/>
    <xsl:if test="position()!= last()"> , </xsl:if>
  </xsl:template>
  
  <xsl:template match="CollectorsNumber">
    (<xsl:value-of select="."/>)
  </xsl:template>
  
  <xsl:template name="Event">
    <span style= "{$FontCountry}">
      <xsl:value-of select="./CollectionEvent/CountryCache"/>.
    </span>
    <xsl:text> </xsl:text>
    <xsl:call-template name="NamedPlace"/>
    <xsl:value-of select="./Geography/MTB"/>.
    <xsl:text> </xsl:text>
    <xsl:value-of select="./CollectionEvent/LocalityDescription"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="./CollectionEvent/HabitatDescription"/>
  </xsl:template>
  
  <!--xsl:template name="CollectionDate">
    <xsl:if test="./CollectionEvent/CollectionYear != '' or ./CollectionEvent/CollectionMonth != '' or ./CollectionEvent/CollectionDay != ''">
      <xsl:value-of select="./CollectionEvent/CollectionYear"/>/ <xsl:value-of select="./CollectionEvent/CollectionMonth"/>/ <xsl:value-of select="./CollectionEvent/CollectionDay"/>
    </xsl:if>
  </xsl:template-->

  <!--xsl:template name="CollectionDate">
    <xsl:if test="./CollectionEvent/CollectionYear != '' or ./CollectionEvent/CollectionMonth != '' or ./CollectionEvent/CollectionDay != ''">
      <xsl:value-of select="./CollectionEvent/CollectionDay"/>
      <xsl:if test="./CollectionEvent/CollectionDay != ''">.</xsl:if>
      <xsl:text> </xsl:text>
      <xsl:call-template name="CollectionMonth"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./CollectionEvent/CollectionYear"/>
    </xsl:if>
  </xsl:template-->

  <!--xsl:template name="CollectionMonth">
    <xsl:if test="./CollectionEvent/CollectionMonth != ''">
      <xsl:if test="./CollectionEvent/CollectionMonth = 1">Januar</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 2">Februar</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 3">März</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 4">April</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 5">Mai</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 6">Juni</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 7">July</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 8">August</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 9">September</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 10">Oktober</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 11">November</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 12">Dezember</xsl:if>
    </xsl:if>
  </xsl:template-->

  <!--xsl:template name="IdentificationDate">
    <xsl:if test="./Units/Unit/Identifications/Identification/IdentificationYear != '' or ./Units/Unit/Identifications/Identification/IdentificationMonth != '' or ./Units/Unit/Identifications/Identification/IdentificationDay != ''">
      <xsl:value-of select="./Units/Unit/Identifications/Identification/IdentificationYear"/>/ <xsl:value-of select="./Units/Unit/Identifications/Identification/IdentificationMonth"/>/ <xsl:value-of select="./Units/Unit/Identifications/Identification/IdentificationDay"/>
    </xsl:if>
  </xsl:template-->
  
  <!--xsl:template name="Altitude">
    <xsl:if test="./Geography/Altitude/from != ''">
      Alt. <xsl:value-of select="./Geography/Altitude/from"/>
    </xsl:if>
    <xsl:if test="./Geography/Altitude/to != ''">
      - <xsl:value-of select="./Geography/Altitude/to"/>
    </xsl:if>
  </xsl:template-->

  <xsl:template name="Potsdam">
    <xsl:if test="./Geography/Potsdam/Latitude != ''">
      Lat.: <xsl:value-of select="./Geography/Potsdam/Latitude"/>;
      Long.: <xsl:value-of select="./Geography/Potsdam/Longitude"/>
    </xsl:if>
  </xsl:template>

  <!--xsl:template name="NamedPlace">
    <xsl:if test="./Geography/NamedPlace/Place != ''">
      <xsl:value-of select="./Geography/NamedPlace/Place"/>.
    </xsl:if>
  </xsl:template-->

  <xsl:template name="MTB">
    <xsl:if test="./Geography/MTB != ''">
      <xsl:value-of select="./Geography/MTB"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Habitat">
    <xsl:if test="./Habitats/Habitat/HabitatName != ''">
      Region: <xsl:value-of select="./Habitats/Habitat/HabitatName"/>
    </xsl:if>
  </xsl:template>

  <!--xsl:template name="UnitHierarchy">
    <xsl:call-template name="SubstrateUnit"/>
    <xsl:call-template name="GrowingOnUnits"/>
    <xsl:call-template name="AssociatedUnits"/>
    <xsl:call-template name="Units"/>
  </xsl:template>
  
  <xsl:template name="SubstrateUnit">
    <xsl:if test="./Units/MainUnit/SubstrateRelationType != '' or count(./Units/MainUnit/SubstrateRelationType) != 0">
      <xsl:value-of select="./Units/MainUnit/SubstrateRelationType"/> on           
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="./Units/MainUnit/SubstrateRelationType = '' or count(./Units/MainUnit/SubstrateRelationType) = 0">
      <xsl:if test="count(./Units/SubstrateUnit) != 0">
        On<xsl:text> </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:if test="./Units/MainUnit/ColonisedSubstratePart != '' or count(./Units/MainUnit/ColonisedSubstratePart) != 0">
      <xsl:value-of select="./Units/MainUnit/ColonisedSubstratePart"/> of           
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:for-each select="./Units/SubstrateUnit">
      <xsl:if test="position() = 1">
        <xsl:call-template name="Unit"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="GrowingOnUnits">
    <xsl:for-each select="./Units/GrowingOnUnit">
      <xsl:if test="position() = 1">
        <xsl:text>With </xsl:text>
      </xsl:if>
      <xsl:if test="position() > 1">
        <xsl:text> and </xsl:text>
      </xsl:if>
      <xsl:call-template name="Unit"/>
      <xsl:if test="./SubstrateRelationType != ''">
        <xsl:value-of select="./SubstrateRelationType"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="./ColonisedSubstratePart != ''">
        <xsl:value-of select="./ColonisedSubstratePart"/> of
      </xsl:if>
      <xsl:if test="position() = last()">
        <xsl:text>. </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="AssociatedUnits">
    <xsl:for-each select="./Units/AssociatedUnit">
      <xsl:if test="position() = 1">
        <xsl:text>Associated with </xsl:text>
      </xsl:if>
      <xsl:if test="position() > 1">
        <xsl:text> and </xsl:text>
      </xsl:if>
      <xsl:call-template name="Unit"/>
      <xsl:if test="./SubstrateRelationType != ''">
        <xsl:value-of select="./SubstrateRelationType"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="./ColonisedSubstratePart != ''">
        <xsl:value-of select="./ColonisedSubstratePart"/>
      </xsl:if>
      <xsl:if test="position() = last()">
        <xsl:text>. </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="Units">
    <xsl:for-each select="./Units/Unit">
      <xsl:if test="position() = 1">
        Further <xsl:value-of select="./TaxonomicGroup"/>s:
      </xsl:if>
      <xsl:if test="position() > 1">
        <xsl:text> and </xsl:text>
      </xsl:if>
      <xsl:call-template name="Unit"/>
      <xsl:if test="./Substrate != ''">
        <xsl:if test="./SubstrateRelationType != ''">
          <xsl:value-of select="./SubstrateRelationType"/>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="./ColonisedSubstratePart != ''">
          <xsl:value-of select="./ColonisedSubstratePart"/> of <xsl:value-of select="./Substrate"/>
        </xsl:if>
        <xsl:if test="position() = last()">
          <xsl:text>. </xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="Unit">
    <xsl:for-each select="./Identifications/Identification">
      <xsl:if test="position() = 1">
        <xsl:if test="count(./Taxon) > 0">
          <xsl:call-template name="TaxonomicName"/>
        </xsl:if>
        <xsl:if test="count(./Taxon) = 0">
          <xsl:if test="./TaxonomicName != ''">
            <xsl:value-of select="./TaxonomicName"></xsl:value-of>
          </xsl:if>
          <xsl:if test="./TaxonomicName = '' and ./VernacularTerm != ''">
            <xsl:value-of select="./VernacularTerm"></xsl:value-of>
          </xsl:if>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template-->
  
  <!--xsl:template name="Type">
    <xsl:if test="./Units/MainUnit/Identifications/Identification/TypeStatus != ''">
      <tr height ="40" valign ="middle" style="{$FontType}">
        <td colspan ="2" align ="center">
          <b>
            <xsl:value-of select="./Units/MainUnit/Identifications/Identification/TypeStatus"/>
          </b>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="TaxonomicName">
    <i>
      <xsl:value-of select="concat(./Taxon/Genus, ' ' , ./Taxon/SpeciesEpithet)"/>
    </i>
    <xsl:if test="./Taxon/Rank!='sp.'">
      <xsl:if test="./Taxon/SpeciesEpithet    = ./Taxon/IntraSpecificEpithet">
        <xsl:value-of select="concat(' ' , ./Taxon/Authors)"/>
      </xsl:if>
      <xsl:value-of select="concat(' ' ,./Taxon/Rank)"/>
      <i>
        <xsl:value-of select="concat(' ' , ./Taxon/IntraSpecificEpithet)"/>
      </i>
      <xsl:if test="./Taxon/SpeciesEpithet    != ./Taxon/IntraSpecificEpithet">
        <xsl:value-of select="concat(' ' , ./Taxon/Authors)"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="./Taxon/Rank='sp.'">
      <xsl:value-of select="concat(' ' , ./Taxon/Authors)"/>
    </xsl:if>
    <xsl:value-of select="concat(' ' , ./IdentificationQualifier)"/>
  </xsl:template>
  
  <xsl:template name="TaxonomicName2Lines">
    <xsl:choose>
      <xsl:when test="./Taxon/Rank!='sp.'">
        <tr height ="40">
          <td colspan ="2" valign="bottom">
            <span style="{$FontTaxonName}">
              <xsl:value-of select="concat(./Taxon/Genus, ' ' , ./Taxon/SpeciesEpithet)"/>
            </span>
          </td>
        </tr>
        <tr height ="40">
          <td>    </td>
          <td valign="top">
            <span style="{$FontTaxonName}">
              <xsl:value-of select="concat(./Taxon/Rank, ' ' , ./Taxon/IntraSpecificEpithet, ' ' , ./Taxon/Authors)"/>
              <xsl:value-of select="concat(' ' , ./IdentificationQualifier)"/>
            </span>
          </td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr height ="60">
          <td colspan ="2">
            <span style="font-size: 14pt; font-family: Verdana">
              <xsl:value-of select="./TaxonomicName"/>
            </span>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template-->
  
</xsl:stylesheet>