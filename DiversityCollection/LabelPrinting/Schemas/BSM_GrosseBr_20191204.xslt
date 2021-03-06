<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

	<xsl:include href="Templates/LabelTemplates.xslt"/>

	<!--Fonts-->
  <xsl:variable name="FontDefault">  font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontSmall">    font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTiny">    font-size: 9pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTitle">    font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTaxonName">font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTaxonNameAuthors">font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontType">     font-size: 12pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontBarcode">  font-size: 16pt; font-family: Code 39</xsl:variable>
  <xsl:variable name="FontCountry">  font-size: 12pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <!--Printing options-->
  <xsl:variable name="ReportHeader">Header of report</xsl:variable>
  <xsl:variable name="PrintReportHeader">0</xsl:variable>
  <xsl:variable name="PrintReportTitle">1</xsl:variable>
  <xsl:variable name="PrintCountryCache">0</xsl:variable>
  <!--Page format-->
  <xsl:variable name="LabelWidth">440</xsl:variable>
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
	  </body>
    </html>
  </xsl:template>
  
  <xsl:template name="Header">
    <table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
      <tr>
        <td align="center" style="{$FontTitle}">
          <b><xsl:value-of select="/LabelTitle"/></b>
        </td>
      </tr>
      <tr>
        <td align="center">
          <!--(<xsl:value-of select="/DepositorsName"/>)-->
        </td>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="Label">
    <table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
      <tr height ="50">
        <th width="30"></th>
        <th width="140" ></th>
        <th width="300"></th>
        <th width="30"></th>
      </tr>
      <tr height ="30" valign="top">
        <td align ="left">-</td>
        <td align ="left"></td>
        <td align ="left"></td>
        <td align ="right">-</td>
      </tr>
      <tr>
        <td> </td>
        <td colspan ="2" align="center" style="{$FontSmall}">
          <b>
            <xsl:value-of select="/LabelPrint/Report/Title"/>
          </b>
        </td>
      </tr>
      <tr>
        <td> </td>
        <td colspan ="2" align="center">
          <!--(<xsl:value-of select="./CollectionSpecimen/DepositorsName"/>)-->
        </td>
      </tr>

		<tr height ="30" valign="top">
			<xsl:choose>
				<xsl:when test="./OriginOfDuplicate/CollectionOwner!=''">
					<td align="right"> </td>
					<td colspan ="2" align="center" style="{$FontTiny}">
						ex <b>
							<xsl:value-of select="./OriginOfDuplicate/CollectionOwner"/>
						</b>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td></td>
					<td colspan ="2" align="center" style="{$FontTitle}">
						<b>
							<xsl:value-of select="./Collection/CollectionOwner"/>
						</b>
					</td>
				</xsl:otherwise>
			</xsl:choose>

		</tr>


		<tr style="{$FontTaxonName}">
        <td> </td>
        <td colspan ="2" align ="right"  style="border-bottom:1px solid black" valign ="buttom">
          <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
        </td>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left"> </td>
      </tr>
      <tr height ="30" style="{$FontTaxonName}">
        <td align="right"> </td>
        <td colspan ="2">
			<b>
            <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
              <xsl:if test="position()=1">
				        <xsl:for-each select="./Taxon/TaxonPart">
							<xsl:call-template name="TaxonPart"/>
						</xsl:for-each>
			        </xsl:if>
            </xsl:for-each>
			</b>
        </td>
      </tr>
		
		<xsl:for-each select="./Units/AssociatedUnit">
			<tr style="{$FontTaxonName}">
				<td align="right"> </td>
				<td colspan ="2">
					<xsl:text> and </xsl:text>
			<xsl:call-template name="Unit"/>
				</td>
			</tr>
		</xsl:for-each>

      <tr style="{$FontSmall}">
        <td></td>
        <td colspan ="2">
          <xsl:for-each select="./Units/Unit/Identifications/Identification">
            <xsl:if test="position()=1">
              <xsl:for-each select="./Taxon/TaxonPart">
                <xsl:call-template name="TaxonPart"/>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </td>
      </tr>


      <tr height ="10" valign="top">
			<td align ="left"> </td>
		</tr>
		<tr style="{$FontSmall}">
			<td></td>
			<td colspan ="2">
				<xsl:for-each select="./CollectionEventLocalisations/Localisation">
				<xsl:if test="./ParsingMethod = 'Gazetteer'">
					<xsl:for-each select="descendant-or-self::Gazetteer/Hierarchy">
						<xsl:sort select="position()" data-type="number" order="descending"/>
						<xsl:if test="@PlaceType != 'continents' and @PlaceType != 'continent'">
							<xsl:value-of select="@Name"/>
							<xsl:if test ="position() != last()">, </xsl:if>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
			</td>
		</tr><!---->
		<tr style="{$FontSmall}">
			<td></td>
			<td colspan ="2">
				<xsl:call-template name="Event"/>
			</td>
		</tr>
		<tr style="{$FontSmall}">
			<td></td>
			<td colspan ="2">
				<xsl:for-each select="./Units/SubstrateUnit/Identifications/Identification">
					<xsl:if test="position()=1">
						On <xsl:for-each select="./Taxon/TaxonPart">
							<xsl:call-template name="TaxonPart"/>
						</xsl:for-each>
					</xsl:if>
				</xsl:for-each>
			</td>
		</tr>
		<tr style="{$FontSmall}" height ="10">
        <td align="right"> </td>
        <td colspan ="2">
        </td>
      </tr>
      <tr style="{$FontSmall}">
        <td align="right"> </td>
        <td colspan ="1" align ="left" valign ="top">
          <xsl:call-template name="CollectionDate"/>
        </td>
        <td colspan ="1" align ="right">
          <xsl:apply-templates select ="Collectors"/>
        </td>
      </tr>
      <td align="right"> </td>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/ResponsibleName != ''">
        <tr style="{$FontSmall}">
          <td align="right"> </td>
          <td colspan ="2" align ="right">
			  <xsl:choose>
				  <xsl:when test="./Units/MainUnit/Identifications/Identification/IdentificationCategory = 'determination'">
					  det.
					  <xsl:if test="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation != ''">
						  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation"/>
						  <xsl:text> </xsl:text>
					  </xsl:if>
					  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/SecondName"/>
				  </xsl:when>
				  <xsl:when test="./Units/MainUnit/Identifications/Identification/IdentificationCategory = 'revision'">
					  rev.
					  <xsl:if test="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation != ''">
						  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation"/>
						  <xsl:text> </xsl:text>
					  </xsl:if>
					  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/SecondName"/>
				  </xsl:when>
				  <xsl:when test="./Units/MainUnit/Identifications/Identification/IdentificationCategory = 'correction'">
					  vid.
					  <xsl:if test="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation != ''">
						  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation"/>
						  <xsl:text> </xsl:text>
					  </xsl:if>
					  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/SecondName"/>
				  </xsl:when>
				  <xsl:when test="./Units/MainUnit/Identifications/Identification/IdentificationCategory = 'confirmation'">
					  conf.
					  <xsl:if test="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation != ''">
						  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation"/>
						  <xsl:text> </xsl:text>
					  </xsl:if>
					  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/SecondName"/>
				  </xsl:when>
				  <xsl:otherwise></xsl:otherwise>
			  </xsl:choose>
            <!--<xsl:if test="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation != ''">
              <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/SecondName"/>-->
            <xsl:text> </xsl:text>
            <xsl:call-template name="IdentificationDate"/>
        </td>
        </tr>
      </xsl:if>
    </table>
    
    <xsl:if test="./Counter mod 2 = 0">
      <h1 style="page-break-before:left"></h1>
    </xsl:if>

  </xsl:template>

	<xsl:template name="TaxonPartWithoutSP">
		<xsl:if test="self::node()[HybridSeparator]">
			<xsl:value-of select="concat(' ' , ./HybridSeparator, ' ')"/>
		</xsl:if>
		<xsl:if test="./QualifierLeading != ''">
			<xsl:value-of select="concat(./QualifierLeading, ' ')"/>
		</xsl:if>
    <xsl:if test="./Rank = 'gen.' and ../QualifierRank = 'gen.'">
      <xsl:value-of select="concat(../Qualifier, ' ')"/>
    </xsl:if>
    <b><i>
			<xsl:value-of select="concat(./Genus,' ')"/>
		</i></b>
		<xsl:if test="./QualifierGenus != ''">
			<xsl:value-of select="concat(./QualifierGenus, ' ')"/>
		</xsl:if>
		<!--xsl:if test="./AuthorsGenus != ''">
      <xsl:value-of select="concat(./AuthorsGenus, ' ')"/>
    </xsl:if-->
		<!--xsl:if test="./Rank = 'gen.'">
			sp. <xsl:value-of select="concat('sp. ', ' ')"/>
		</xsl:if-->
		<xsl:if test="./InfragenericEpithet != ''">
			<xsl:if test="./Rank = 'subgen.'">
				<xsl:value-of select="concat(./Rank, ' ')"/>
			</xsl:if>
      <b><i>
				<xsl:value-of select="concat(./InfragenericEpithet, ' ')"/>
			</i></b>
		</xsl:if>
		<xsl:if test="./AuthorsInfrageneric != ''">
			<xsl:value-of select="concat(./AuthorsInfrageneric, ' ')"/>
		</xsl:if>
		<xsl:if test="./QualifierSpecies != ''">
			<xsl:value-of select="concat(./QualifierSpecies, ' ')"/>
		</xsl:if>
    <b>
    <xsl:if test="../Qualifier != '' and ../QualifierRank = 'sp.'">
      <xsl:value-of select="concat(../Qualifier, ' ')"/>
    </xsl:if>
  </b>
  <b>
        <i>
          <xsl:value-of select="concat(./SpeciesEpithet, ' ')"/>
		</i>
		<xsl:if test="./AuthorsSpecies != ''">
			<xsl:value-of select="concat(./AuthorsSpecies, ' ')"/>
		</xsl:if>
		<xsl:if test="./Rank != 'sp.' and ./Rank != 'subgen.' and ./InfraspecificEpithet != ''">
			<xsl:value-of select="concat(./Rank, ' ')"/>
		</xsl:if></b>
		<xsl:if test="./InfraspecificEpithet != ''">
			<b><xsl:if test="./QualifierInfraspecific != ''">
				<xsl:value-of select="concat(./QualifierInfraspecific, ' ')"/>
			</xsl:if>
      <i>
				<xsl:value-of select="concat(./InfraspecificEpithet, ' ')"/>
			</i>
			<xsl:if test="./AuthorsInfraspecific != ''">
				<xsl:value-of select="concat(./AuthorsInfraspecific, ' ')"/>
			</xsl:if></b>
		</xsl:if>
    <b>
		<xsl:if test="./Undefined != ''">
			<xsl:value-of select="concat(./Undefined, ' ')"/>
		</xsl:if>
		<xsl:if test="./QualifierTerminatory != ''">
			<xsl:value-of select="concat(./QualifierTerminatory, ' ')"/>
		</xsl:if></b>
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
  
  <xsl:template name="Event">
    <xsl:if test="$PrintCountryCache = 1">
      <xsl:if test="./CollectionEvent/CountryCache != ''">
      <span style= "{$FontCountry}">
      <xsl:value-of select="./CollectionEvent/CountryCache"/>.
      </span> 
    </xsl:if>
    </xsl:if>
    <xsl:value-of select="./CollectionEvent/LocalityDescription"/> 
    <xsl:if test="./CollectionEvent/HabitatDescription != ''">
      <xsl:text> </xsl:text>
      <xsl:value-of select="./CollectionEvent/HabitatDescription"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="UnitsInRows">
    <xsl:for-each select="./Units/Unit">
      <tr style="{$FontTaxonName}" height ="20" valign="top">
        <td> </td>
        <td colspan ="2">
          <span style= "{$FontTiny}"><xsl:call-template name="Unit"/>
          </span>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="./Units/AssociatedUnit">
      <tr style="{$FontTaxonName}" height ="20" valign="top">
        <td> </td>
        <td colspan ="2">
          <span style= "{$FontTiny}">
			  and <xsl:call-template name="Unit"/>
          </span>
        </td>
      </tr>
    </xsl:for-each>
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
  
  
  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>