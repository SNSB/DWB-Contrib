<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-16"/>

	<xsl:include href="Templates/LabelTemplates.xslt"/>

	<!--Fonts-->
	<xsl:variable name="FontTiny">    font-size: 12pt; font-family: Arial</xsl:variable>
	<xsl:variable name="FontSmall">    font-size: 13pt; font-family: Arial</xsl:variable>
	<xsl:variable name="FontDefault">  font-size: 14pt; font-family: Arial</xsl:variable>
	<xsl:variable name="FontTaxonName">font-size: 15pt; font-family: Arial; font-weight:bold;</xsl:variable>
	
	<xsl:variable name="FontTitle">    font-size: 12pt; font-family: Arial</xsl:variable>
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
	<xsl:variable name="LabelWidth">355</xsl:variable>
	<xsl:variable name="Space"> </xsl:variable>
	<xsl:variable name="LabelPerPage">6</xsl:variable>

	<!--Templates-->
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
					<tr height ="1">
						<th width="30"></th>
						<th width="300"></th>
						<th width="30"></th>
					</tr>
					<tr height ="1" valign="top">
						<td align ="left">-</td>
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

	<xsl:template match="Label">
		<table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
			<tr height ="1">
				<th width="30"></th>
				<th width="300"></th>
				<th width="30"></th>
			</tr>
			<tr height ="1" valign="top">
				<td align ="left">-</td>
				<td align ="left"></td>
				<td align ="right">-</td>
			</tr>
			<!--1 - AccNr-->
			<tr style="{$FontDefault}">
				<td></td>
				<td  align="left">
					<xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
				</td>
			</tr>
			<!--2 - LastIdentification-->
			<tr style="{$FontTaxonName}">
				<td></td>
				<td align="left">
					<xsl:for-each select="./Units/MainUnit/Identifications/Identification">
						<xsl:if test="position()=1">
							<xsl:for-each select="./Taxon/TaxonPart">
								<xsl:call-template name="TaxonPartSinAuthors"/>
							</xsl:for-each>
							<!--xsl:call-template name="TaxonomicName"/-->
						</xsl:if>
					</xsl:for-each>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Units/MainUnit/UnitIdentifier"/>
				</td>
			</tr>
			<!--3 - Vern. term-->
			<tr style="{$FontSmall}">
				<td></td>
				<td align="left">
					<xsl:for-each select="./Units/MainUnit/Identifications/Identification">
						<xsl:if test="position()=1">
							<xsl:value-of select="./VernacularTerm"/>
						</xsl:if>
					</xsl:for-each>
					<span style="{$FontDefault}">
						<xsl:choose>
							<xsl:when test="./Units/MainUnit/Gender='male'">
								&#9794;
							</xsl:when>
							<xsl:when test="./Units/MainUnit/Gender='female'">
								&#9792;
							</xsl:when>
						</xsl:choose>
					</span>
					<xsl:value-of select="./Units/MainUnit/Lifestage"/>
				</td>
			</tr>
			<!--4 - Family-->
			<tr style="{$FontTiny}">
				<td></td>
				<td align="left">
					<xsl:value-of select="./Units/MainUnit/FamilyCache"/>
				</td>
			</tr>
		</table>

		<xsl:if test="./Counter mod $LabelPerPage = 0">
			<div align="center" style="{$FontTiny}; clear:both">
				<xsl:value-of select="./Counter div $LabelPerPage"/>
			</div>
			<h1 style="page-break-before:left"></h1>
		</xsl:if>
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