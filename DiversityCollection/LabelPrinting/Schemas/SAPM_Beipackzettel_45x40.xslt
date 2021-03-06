<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-16"/>

	<xsl:include href="Templates/LabelTemplates.xslt"/>

	<!--Fonts-->
	<xsl:variable name="FontDefault">  font-size: 6pt; font-family: Arial</xsl:variable>
	<xsl:variable name="FontSmall">    font-size: 8pt; font-family: Arial</xsl:variable>
	<xsl:variable name="FontTiny">    font-size: 5pt; font-family: Arial</xsl:variable>
	<xsl:variable name="FontTitle">    font-size: 11pt; font-family: Arial</xsl:variable>
	<xsl:variable name="FontTaxonName">font-size: 13pt; font-family: Arial; font-weight:bold;</xsl:variable>
	<xsl:variable name="FontTaxonNameAuthors">font-size: 13pt; font-family: Arial font-weight:bold;</xsl:variable>
	<xsl:variable name="FontType">     font-size: 11pt; font-family: Arial; text-transform:uppercase</xsl:variable>
	<xsl:variable name="FontBarcode">  font-size: 15pt; font-family: Code 39</xsl:variable>
	<xsl:variable name="FontCountry">  font-size: 11pt; font-family: Arial; text-transform:uppercase</xsl:variable>

	<!--Printing options-->
	<xsl:variable name="ReportHeader">Header of report</xsl:variable>
	<xsl:variable name="PrintReportHeader">0</xsl:variable>
	<xsl:variable name="PrintReportTitle">1</xsl:variable>
	<xsl:variable name="PrintCountryCache">0</xsl:variable>

	<!--Page format-->
	<xsl:variable name="LabelWidth">265</xsl:variable>
	<xsl:variable name="DefaultHeight">25</xsl:variable>
	<xsl:variable name="Space"> </xsl:variable>
	<xsl:variable name="LabelPerPage">4</xsl:variable>

	<!--Templates-->
	<xsl:template match="/LabelPrint">
		<html>
			<head>
				<!--<style> @media print { h1 {page-break-before:always;} } </style>-->
			</head>
			<body>
			<!--xsl:call-template name="Header"/-->
				<xsl:if test="$PrintReportHeader = 1">
					<hr/>
					<span style="{$FontTitle}">
						<xsl:value-of select="$ReportHeader"/>
					</span>
				</xsl:if>
				<xsl:apply-templates select="LabelList/Label"/>
				<!--<table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
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
				</table>-->
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Header">
		<table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
			<tr>
				<td align="center" style="{$FontTitle}">
					<b>
						<xsl:value-of select="./ProjectTitle"/>
					</b>
				</td>
			</tr>
			<tr>
				<td align="center">
					(<xsl:value-of select="./Title"/>)
				</td>
			</tr>
		</table>
	</xsl:template>

	<!--position:absolute; top:((Counter-1)*350)px; left:350px;-->

	<xsl:template match="Label">
		<div  align="center" style="width:170; float:left; height:150px">
			<table cellspacing="1" cellpadding="0" width="160" border="0" style="{$FontDefault}; overflow:hidden; table-layout:fixed; white-space: nowrap; border-style: solid; border-width: 1px; border-color: lightgray;">
			<tr height ="0">
				<th width="100" ></th>
				<th width="60"></th>
			</tr>
			<!--<tr height ="10" valign="top">
				<td align ="left">-</td>
				<td align ="left"></td>
				<td align ="left"></td>
				<td align ="right">-</td>
			</tr>
			<tr height ="10" valign="top">
				<td align ="left"> </td>
			</tr>-->

			<!--0 - Überschrift-->
			<!--<tr style="{$FontTiny}" valign="top" height="10">
				<td  align="center" colspan="2">
					<u><b>SAPM - ABTEILUNG PALÄOANATOMIE</b></u>
				</td>
			</tr>-->

			<!--1 - AccNr-->
			<tr style="{$FontDefault}" height="{$FontDefault}">
				<td  align="left" colspan="2">
					
					<xsl:choose>
						<xsl:when test="./CollectionSpecimen/AccessionNumberSpecimen != ./CollectionSpecimen/AccessionNumberPart">
							<xsl:value-of select="./CollectionSpecimen/AccessionNumberPart"/> (<xsl:value-of select="./CollectionSpecimen/AccessionNumberSpecimen"/>)
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./CollectionSpecimen/AccessionNumberSpecimen"/>
						</xsl:otherwise>
					</xsl:choose>
					<!--<xsl:if test="./CollectionSpecimen/AccessionNumberSpecimen != ./CollectionSpecimen/AccessionNumberPart">
						<span> (<xsl:value-of select="./CollectionSpecimen/AccessionNumberSpecimen"/>)</span>
					</xsl:if>-->
				</td>
			</tr>
			
			<!--1 - LastIdentification-->
			<!--<tr style="{$FontTaxonName}">
				<td></td>
				<td colspan ="2">
					<xsl:for-each select="./Units/MainUnit/Identifications/Identification">
						<xsl:if test="position()=1">
							<xsl:for-each select="./Taxon/TaxonPart">
								<xsl:call-template name="TaxonPart"/>
							</xsl:for-each>
							--><!--xsl:call-template name="TaxonomicName"/--><!--
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>-->

			<tr style="{$FontDefault}" height="{$FontDefault}">
				<td colspan ="2">
					<xsl:for-each select="./Units/MainUnit/Identifications/Identification">
						<xsl:if test="position()=1">
							<xsl:for-each select="./Taxon/TaxonPart">
								<i>
									<b><xsl:call-template name="TaxonPartSinAuthors"/></b>
								</i>
							</xsl:for-each>
							<!--xsl:call-template name="TaxonomicName"/-->
						</xsl:if>
					</xsl:for-each>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Units/MainUnit/UnitIdentifier"/>
				</td>
			</tr>
			<!--<tr style="{$FontTaxonNameAuthors}">
				<td colspan ="2">
					<xsl:for-each select="./Units/MainUnit/Identifications/Identification">
						<xsl:if test="position()=1">
							<xsl:for-each select="./Taxon/TaxonPart">
								<b><xsl:call-template name="TaxonPartAuthors"/></b>
							</xsl:for-each>
							--><!--xsl:call-template name="TaxonomicName"/--><!--
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>-->


			<!--2 - StorageLocation-->
			<!--<tr style="{$FontDefault}" height="{$FontDefault}">
				<td colspan ="2">
					<xsl:value-of select="./CollectionSpecimen/StorageLocation"/>
				</td>
			</tr>-->

			<!--3 - Vern. term-->
			<tr style="{$FontDefault}">
				<td align="left">
					<xsl:for-each select="./Units/MainUnit/Identifications/Identification">
						<xsl:if test="position()=1">
							<xsl:value-of select="./VernacularTerm"/>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>

			<!--3 - Family-->
			<tr style="{$FontDefault}" height="{$FontDefault}">
				<td colspan ="2">
					<xsl:value-of select="./Units/MainUnit/FamilyCache"/>
				</td>
			</tr>
			
			<!--7 - Locality-->
			<tr style="{$FontDefault}" height="15" valign="top">
				<td colspan ="2">
					<xsl:value-of select="./CollectionEvent/LocalityDescription"/>
				</td>
			</tr>
			
			<!--8 - UnitNote (Verbreitung)-->
			<tr style="{$FontDefault}" height="15" valign="top">
				<td colspan ="2">
					<xsl:value-of select="./Units/MainUnit/Notes"/>
				</td>
			</tr>
			
			<!--4 - Datum-->
			<tr style="{$FontDefault}; overflow:hidden" height="{$FontDefault}">
				<td colspan ="2" style="overflow:hidden">
					<xsl:call-template name="CollectionDate"/>; 
					<xsl:for-each select="./Collectors/Collector">
						<xsl:if test="position()!=1">
							, 
						</xsl:if>
						<xsl:value-of select="./CollectorsName"/>
					</xsl:for-each>
				</td>
			</tr>
			
			<!--5 - Collector-->
			<!--<tr style="{$FontDefault}">
				<td></td>
				<td colspan ="2">
				</td>
			</tr>-->
			
			<!--6 - Country-->
			<!--<tr style="{$FontDefault}">
				<td></td>
				<td colspan ="2">
					<xsl:value-of select="./CollectionEvent/CountryCache"/>
				</td>
			</tr>-->

			<!--8 - Sex-->
			<tr style="{$FontDefault}" height="{$FontDefault}">
				<td>Geschlecht: 
					<xsl:choose>
						<xsl:when test="./Units/MainUnit/Gender='male'">
							&#9794;
						</xsl:when>
						<xsl:when test="./Units/MainUnit/Gender='female'">
							&#9792;
						</xsl:when>
						<xsl:otherwise>?</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:value-of select="./Units/MainUnit/Lifestage"/>
				</td>
			</tr>

			<!--9 - Analysis-->
			<tr style="{$FontDefault}" height="{$FontDefault}">
				<td colspan ="2">
					<xsl:for-each select="./Units/MainUnit/UnitAnalysis/Analysis">
						<xsl:if test="(./AnalysisName = 'SL') or (./AnalysisName = 'TL')">
							<xsl:if test="position()!=1">
								<xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:value-of select="./AnalysisName"/>: <xsl:value-of select="./AnalysisResult"/>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>

			<!--9 - Life stage-->
			<!--<tr style="{$FontDefault}">
				<td></td>
				<td colspan ="2">
					<xsl:value-of select="./Units/MainUnit/LifeStage"/>
				</td>
			</tr>-->

			<!--10 - Protokoll-->
			<tr style="{$FontDefault}" height="10">
				<td colspan ="2">
					<xsl:for-each select="./Processings/Processing">
						<xsl:if test="position()=1">
							<xsl:if test="./Protocoll">
								Maz.Nr.: <xsl:value-of select="./Protocoll"/>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>

		</table>
		</div>

		<xsl:if test="./Counter mod 2 = 0">
			<div align="center" style="{$FontSmall}; clear:both"></div>
		</xsl:if>
		<xsl:if test="./Counter mod 8 = 0">
			<div align="center" style="{$FontSmall}; clear:both">
				<!--<xsl:value-of select="./Counter div 15"/>-->
			</div>
			<h1 style="page-break-before:left"></h1>
		</xsl:if>


		<!--<xsl:if test="./Counter mod $LabelPerPage = 0">
			--><!--<div align="center" style="{$FontTiny}; clear:both">
				<xsl:value-of select="./Counter div $LabelPerPage"/>
			</div>--><!--
			<h1 style="page-break-before:left"> </h1>
		</xsl:if>-->
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
		<xsl:text> </xsl:text>
		<xsl:apply-templates select ="CollectorsNumber"/>
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
			<tr style="{$FontTaxonName}" height ="30" valign="top">
				<td colspan ="2">
					<xsl:call-template name="Unit"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="text"></xsl:template>
</xsl:stylesheet>