<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="Templates/LabelTemplates.xslt"/>

  <!--Fonts-->
  <xsl:variable name="FontDefault">  font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontSmall">    font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTitle">    font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTaxonName">font-size: 14pt; font-family: Arial; font-weight:bold;</xsl:variable>
  <xsl:variable name="FontTaxonNameAuthors">font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontType">     font-size: 12pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontBarcode">  font-size: 16pt; font-family: Code 39</xsl:variable>
  <xsl:variable name="FontCountry">  font-size: 12pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontTiny">    font-size: 10pt; font-family: Arial</xsl:variable>

	<!--Printing options-->
  <xsl:variable name="ReportHeader">Header of report</xsl:variable>
  <xsl:variable name="PrintReportHeader">0</xsl:variable>
  <xsl:variable name="PrintReportTitle">1</xsl:variable>
  <xsl:variable name="PrintCountryCache">0</xsl:variable>
  
  <!--Page format-->
  <xsl:variable name="LabelWidth">500</xsl:variable>
  <xsl:variable name="Space"> </xsl:variable>
  
  <xsl:template match="/LabelPrint">
    <html>
      <body>
        <!--xsl:call-template name="Header"/-->
        <xsl:if test="$PrintReportHeader = 1">
          <hr/>
          <span style="{$FontTitle}">
            <xsl:value-of select="$ReportHeader"/>
          </span>
        </xsl:if>
        <xsl:apply-templates select="LabelList/Label"/>
        <table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
          <tr height ="0">
            <th width="30"></th>
            <th width="140" ></th>
            <th width="300"></th>
            <th width="30"></th>
          </tr>
          <tr height ="0" valign="top">
            <td align ="left">-</td>
            <td align ="left"></td>
            <td align ="left"></td>
            <td align ="right">-</td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template name="Header">
    <table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
      <tr>
        <td align="center" style="{$FontTitle}">
          <b>Staatliches Museum für Naturkunde Karlsruhe</b>
        </td>
      </tr>
      <tr>
        <td align="center">
          (Herbarium KR)
        </td>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="Label">
	  <div  align="center" style="width:230px; float:left; height:165px">
		  <table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
      <tr height ="0">
        <th width="30"></th>
        <th width="200" ></th>
        <th width="240" ></th>
        <th width="30"></th>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left">-</td>
        <td align ="left"></td>
        <td></td>
        <td align ="right">-</td>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left"> </td>
      </tr>
      <tr>
        <td></td>
        <td colspan ="2" align="center" style="{$FontTitle}">
          <b>
            Staatliches Museum für Naturkunde Karlsruhe
          </b>
        </td>
      </tr>
      <!--tr>
        <td></td>
        <td colspan ="2" align="center">
          Herbarium KR (M)
        </td>
      </tr-->
      <!--tr height ="0">
        <th width="{$LabelWidth}/2" ></th>
        <th width="{$LabelWidth}/2"></th>
      </tr-->
      <!--tr>
      <td></td>
      <td align ="left" style="{$FontTitle}"  valign ="bottom">
        Herbarium KR (M)
        </td>
      <td  align ="right"  style="{$FontTiny}" valign ="bottom">
      </td>
    </tr-->
      <tr>
        <td></td>
        <td align ="left" style="{$FontTitle}"  valign ="bottom">
          <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
        </td>
        <td  align ="right"  style="{$FontTiny}" valign ="bottom">
          <xsl:value-of select="./Units/MainUnit/Notes"/>
        </td>
      </tr>
      <!--/table>
    <table cellspacing="1" cellpadding="1" width="480" border="0" style="{$FontDefault}">
      <tr height ="0">
        <th width="200" ></th>
        <th width="240"></th>
      </tr-->
      <tr height ="40" style="{$FontTaxonName}">
        <td></td>
        <td style="border-top:1px solid black" colspan ="2">
            <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
              <!--xsl:call-template name="TaxonomicName"/-->
                <xsl:if test="position()=1">
					<xsl:choose>
						<xsl:when test="./DiversityTaxonNames">
							<xsl:choose>
								<xsl:when test="./DiversityTaxonNames/mycobanknr_">
									<i>
										<xsl:value-of select="concat(./DiversityTaxonNames/name, ' ')"/>
									</i>
									<xsl:value-of select="concat(./DiversityTaxonNames/authorsabbrev_, ' ')"/>
								</xsl:when>
								<xsl:otherwise>
									<i>
										<xsl:value-of select="concat(./DiversityTaxonNames/Genus,' ')"/>
										<xsl:value-of select="concat(./DiversityTaxonNames/Species_epithet, ' ')"/>
									</i>
									<xsl:value-of select="concat(./DiversityTaxonNames/Authors, ' ')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="./Taxon/TaxonPart">
							  <xsl:call-template name="TaxonPart"/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
              </xsl:if>
            </xsl:for-each>
        </td>
      </tr>
      <xsl:for-each select="./Units/GrowingOnUnit/Identifications/Identification">
        <xsl:if test="position()=1">
          <tr height ="40" style="{$FontTaxonName}">
            <td></td>
            <td colspan ="2">
              <xsl:for-each select="./Taxon/TaxonPart">
                <xsl:call-template name="TaxonPart"/>
              </xsl:for-each>
              <!--xsl:call-template name="TaxonomicName"/-->
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
      <xsl:call-template name="UnitsInRows"/>
      <tr style="{$FontSmall}">
        <td></td>
        <td colspan ="2">
          <xsl:call-template name="SubstrateUnit_KR"/>
        </td>
      </tr>
      <!--xsl:call-template name="SubstrateUnit_KR"/-->
      <tr style="{$FontSmall}">
        <td></td>
        <td colspan ="2">
          <xsl:call-template name="Event"/>
        </td>
      </tr>
      <xsl:if test="./CollectionSpecimen/AdditionalNotes != ''">
        <tr style="{$FontSmall}" height ="10">
          <td></td>
          <td colspan ="2">
            Ann.: <xsl:value-of select="./CollectionSpecimen/AdditionalNotes"/>
          </td>
        </tr>
      </xsl:if>
      <tr style="{$FontSmall}" height ="10">
        <td></td>
        <td colspan ="2">
        </td>
      </tr>
      <tr style="{$FontSmall}">
        <td></td>
        <td colspan ="1" align ="left" valign ="top">
          <xsl:call-template name="CollectionDate"/>
          <xsl:if test="./CollectionEvent/CollectionDateSupplement != ''">
              - <xsl:value-of select="./CollectionEvent/CollectionDateSupplement"/>
          </xsl:if>
        </td>
        <td colspan ="1" align ="right">
			<xsl:value-of select="./Collectors/Collector/CollectorsName"/>
			<!--xsl:apply-templates select ="Collectors"/-->
        </td>
      </tr>
      <!--xsl:if test="./Units/MainUnit/Identifications/Identification/ResponsibleName != ''">
        <tr style="{$FontSmall}">
          <td></td>
          <td colspan ="2" align ="right" style="padding-bottom:20px; border-bottom:1px dashed #CCCCCC" >
          <td colspan ="2" align ="right">
            det. <xsl:value-of select="./Units/MainUnit/Identifications/Identification/ResponsibleName"/>    
            <xsl:if test="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation != ''">
              <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/SecondName"/>
        </td>
        </tr>
      </xsl:if-->
    </table>
		  <!--xsl:if test="./Counter mod 6 = 0">
		  <h1 style="page-break-before:left"></h1>
	  </xsl:if-->


	  </div>
	  <xsl:if test="./Counter mod 2 = 0">
		  <div align="center" style="{$FontSmall}; clear:both"></div>
		  <br/>
		  <br/>
	  </xsl:if>
	  <xsl:if test="./Counter mod 10 = 0">
		  <div align="center" style="{$FontSmall}; clear:both">
			  <xsl:value-of select="./Counter div 10"/>
		  </div>
		  <h1 style="page-break-before:left"></h1>
	  </xsl:if>

  </xsl:template>

<xsl:template name="SubstrateUnit_KR">
	<xsl:for-each select="./Units/SubstrateUnit">
		<xsl:if test="position() = 1">
			<xsl:if test="./SubstrateRelationType != ''">
				<xsl:value-of select="./SubstrateRelationType"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="./SubstrateRelationType = '' or count(./SubstrateRelationType) = 0">
				<xsl:text> Substr. </xsl:text>
			</xsl:if>
			<xsl:if test="./ColonisedSubstratePart != ''">
				<xsl:value-of select="./ColonisedSubstratePart"/> of
			</xsl:if>
			<xsl:if test="./ColonisedSubstratePart = '' and ./SubstrateRelationType = ''">
				<xsl:text> Substr. </xsl:text>
			</xsl:if>
			<xsl:call-template name="Unit"/>
			<xsl:text> </xsl:text>
			<!--xsl:text>. </xsl:text-->
		</xsl:if>
	</xsl:for-each>
</xsl:template>



	<xsl:template match="Collectors">
    leg. <xsl:apply-templates select ="Collector"/>
  </xsl:template>
  
  <xsl:template match="Collector">
    <xsl:if test="./Agent/FirstNameAbbreviation != ''">
      <xsl:value-of select="./Agent/FirstNameAbbreviation"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="./Agent/SecondName"/>
    <xsl:text> </xsl:text><xsl:apply-templates select ="CollectorsNumber"/>
    <xsl:if test="position()!= last()"> , </xsl:if>
  </xsl:template>
  
  <xsl:template match="CollectorsNumber">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template name="EventSeparateLines">
    <!--xsl:if test="$PrintCountryCache = 1">
      <xsl:if test="./CollectionEvent/CountryCache != ''">
        <span style= "{$FontCountry}">
          <xsl:value-of select="./CollectionEvent/CountryCache"/>.
        </span>
      </xsl:if>
    </xsl:if-->
      <td colspan ="2">
        <xsl:call-template name="NamedPlace"/>
      </td>
    <tr>
      <td></td>
      <td colspan ="2">
        <xsl:value-of select="./CollectionEvent/LocalityDescription"/>
      </td>
    </tr>
    <xsl:if test="./CollectionEvent/HabitatDescription != ''">
      <tr>
        <td></td>
        <td colspan ="2">
          <xsl:value-of select="./CollectionEvent/HabitatDescription"/>
        </td>
      </tr>
    </xsl:if>
	<xsl:if test="./CollectionEvent/Verbatim != ''">
      <tr>
        <td></td>
        <td colspan ="2">
          <xsl:value-of select="./CollectionEvent/Verbatim"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Event">
    <xsl:if test="$PrintCountryCache = 1">
      <xsl:if test="./CollectionEvent/CountryCache != ''">
      <span style= "{$FontCountry}">
      <xsl:value-of select="./CollectionEvent/CountryCache"/>.
      </span> 
    </xsl:if>
    </xsl:if>
	  
    <!--
	<xsl:call-template name="NamedPlace"/>
	-->

	  <xsl:for-each select="./CollectionEventLocalisations/Localisation">
		  <xsl:if test="./ParsingMethod = 'Gazetteer'">
			  <xsl:if test="./Location1 != ''">
				  <xsl:value-of select="./Location1"/>
				  <xsl:text></xsl:text>
				  <br/>
			  </xsl:if>
		  </xsl:if>
	  </xsl:for-each>


	  <xsl:if test="./CollectionEvent/LocalityDescription != ''">
	  <!--
      <xsl:text></xsl:text><br/>
	  -->
      <xsl:value-of select="./CollectionEvent/LocalityDescription"/>
    </xsl:if>
	<xsl:if test="./CollectionEvent/LocalityVerbatim != ''">
      <xsl:text></xsl:text><br/>
      <xsl:value-of select="./CollectionEvent/LocalityVerbatim"/>
    </xsl:if>
	<xsl:if test="./CollectionEvent/HabitatDescription != ''">
      <xsl:text></xsl:text><br/>
      <xsl:value-of select="./CollectionEvent/HabitatDescription"/>
    </xsl:if>
  </xsl:template>
  
  <!--xsl:template name="CollectionDate">
    <xsl:if test="./CollectionEvent/CollectionYear != '' or ./CollectionEvent/CollectionMonth != '' or ./CollectionEvent/CollectionDay != ''">
      <xsl:value-of select="./CollectionEvent/CollectionDay"/>
      <xsl:text> </xsl:text>
      <xsl:call-template name="CollectionMonth"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./CollectionEvent/CollectionYear"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="IdentificationDate">
    <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationYear != '' or ./Units/MainUnit/Identifications/Identification/IdentificationMonth != '' or ./Units/MainUnit/Identifications/Identification/IdentificationDay != ''">
      (<xsl:value-of select="./Units/MainUnit/Identifications/Identification/IdentificationDay"/>
      <xsl:text> </xsl:text>
      <xsl:call-template name="IdentificationMonth"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./Units/MainUnit/Identifications/Identification/IdentificationYear"/>)   
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="Altitude">
    <xsl:if test="./Geography/Altitude/from != ''">
      Alt. <xsl:value-of select="./Geography/Altitude/from"/>
    </xsl:if>
    <xsl:if test="./Geography/Altitude/to != ''">
      - <xsl:value-of select="./Geography/Altitude/to"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="UnitHierarchy">
    <xsl:call-template name="SubstrateUnit"/>
    <xsl:call-template name="GrowingOnUnits"/>
    <xsl:call-template name="AssociatedUnits"/>
    <xsl:call-template name="Units"/>
  </xsl:template>
  
  <xsl:template name="SubstrateUnit">
    <xsl:for-each select="./Units/SubstrateUnit">
      <xsl:if test="position() = 1">
        <xsl:if test="./SubstrateRelationType != ''">
          <xsl:value-of select="./SubstrateRelationType"/>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="./SubstrateRelationType = '' or count(./SubstrateRelationType) = 0">
          <xsl:text> On </xsl:text>
        </xsl:if>
        <xsl:if test="./ColonisedSubstratePart != ''">
          <xsl:value-of select="./ColonisedSubstratePart"/> of
        </xsl:if>
        <xsl:if test="./ColonisedSubstratePart = '' and ./SubstrateRelationType = ''">
          <xsl:text> On </xsl:text>
        </xsl:if>
        <xsl:call-template name="Unit"/>
        <xsl:text>. </xsl:text>
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

  <xsl:template name="IdentificationMonth">
    <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth != ''">
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 1">Januar</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 2">Februar</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 3">March</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 4">April</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 5">May</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 6">June</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 7">July</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 8">August</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 9">September</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 10">October</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 11">November</xsl:if>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/IdentificationMonth = 12">December</xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="CollectionMonth">
    <xsl:if test="./CollectionEvent/CollectionMonth != ''">
      <xsl:if test="./CollectionEvent/CollectionMonth = 1">Januar</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 2">Februar</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 3">March</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 4">April</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 5">May</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 6">June</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 7">July</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 8">August</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 9">September</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 10">October</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 11">November</xsl:if>
      <xsl:if test="./CollectionEvent/CollectionMonth = 12">December</xsl:if>
    </xsl:if>
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
  </xsl:template-->

  <xsl:template name="UnitsInRows">
    <xsl:for-each select="./Units/Unit">
      <tr style="{$FontTaxonName}" height ="30" valign="top">
        <td colspan ="2">
          <xsl:call-template name="Unit"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <!--xsl:template name="Unit">
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
  </xsl:template>
  
  <xsl:template name="Type">
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
       <b><xsl:value-of select="concat(./Taxon/Genus, ' ' , ./Taxon/SpeciesEpithet)"/></b>
     </i>
    
    <xsl:if test="./Taxon/Rank!='sp.'">
      <xsl:if test="./Taxon/SpeciesEpithet    = ./Taxon/IntraSpecificEpithet">
        <b><xsl:value-of select="concat(' ' , ./Taxon/Authors)"/>
        </b>
      </xsl:if>
        <xsl:value-of select="concat(' ' ,./Taxon/Rank)"/>
        <i>
          <b><xsl:value-of select="concat(' ' , ./Taxon/IntraSpecificEpithet)"/>
          </b>
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
  </xsl:template>
  
  <xsl:template name="ReportTitle">
    <xsl:if test="./Report/Title != ''">
      <tr height ="40" valign ="middle" style="{$FontTitle}">
        <td colspan ="2" align ="center">
          <b>
            <xsl:value-of select="./Report/Title"/>
          </b>
        </td>
      </tr>
    </xsl:if>
  </xsl:template-->
  
  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>