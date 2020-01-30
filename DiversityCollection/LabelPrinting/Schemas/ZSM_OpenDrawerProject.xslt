<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="Templates/LabelTemplates.xslt"/>

  <!--Fonts-->
  <xsl:variable name="FontDefault">  font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontSmall">    font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTiny">    font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTitle">    font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTaxonName">font-size: 14pt; font-family: Arial; font-weight:bold;</xsl:variable>
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
  <xsl:variable name="LabelWidth">500</xsl:variable>
  <xsl:variable name="Space"> </xsl:variable>
  <xsl:variable name="LabelPerPage">3</xsl:variable>

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
      <tr height ="0">
        <th width="30"></th>
        <th width="600"></th>
        <th width="30"></th>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left">-</td>
        <td align ="left"></td>
        <td align ="right">-</td>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left"> </td>
      </tr>
	  <tr style="{$FontTiny}">
		  <td></td>
		  <td align ="center"   valign ="buttom">
			  <u>Zoologische Staatssammlung München – Arthropoda Varia</u>
		  </td>
		  <td></td>
	  </tr>

      <tr style="{$FontTiny}">
		  <td></td>
		  <td align ="center">
            <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
              <xsl:if test="position()=1">
				  <b>
				  <xsl:for-each select="./Taxon/TaxonPart">
                  <xsl:call-template name="TaxonPart"/>
                </xsl:for-each>
				  </b>
				  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/TaxonomicName"/>
			  </xsl:if>
            </xsl:for-each>
			<xsl:choose>
				<xsl:when test="./Units/MainUnit/Gender='male'">
					&#9794;
				</xsl:when>
				<xsl:when test="./Units/MainUnit/Gender='female'">
					&#9792;
				</xsl:when>
			</xsl:choose>
		</td>
		  <td></td>
	  </tr>
      <tr height ="15">
        <td></td>
		  <td></td>
		  <td></td>
      </tr>
      <xsl:for-each select="./Units/GrowingOnUnit/Identifications/Identification">
        <tr height ="40" style="{$FontTaxonName}">
          <td></td>
          <td>
            <xsl:for-each select="./Taxon/TaxonPart">
              <xsl:call-template name="TaxonPart"/>
            </xsl:for-each>
            <!--xsl:call-template name="TaxonomicName"/-->
          </td>
        </tr>
      </xsl:for-each>
      <!--<xsl:call-template name="UnitsInRows"/>-->
      <tr style="{$FontTiny}">
        <td></td>
        <td colspan ="1">
          <xsl:call-template name="Event"/>
        </td>
		  <td></td>
	  </tr>
		  <tr height ="40" style="{$FontTiny}">
			  <td></td>
			  <td colspan ="1" align ="left" valign ="top">
				  <b>Fundortcode: <xsl:value-of select="./CollectionEvent/CollectorsEventNumber"/></b>
			  </td>
			  <td></td>
		  </tr>
      <tr style="{$FontTiny}">
        <td></td>
        <td colspan ="1">
          <xsl:apply-templates select ="Collectors"/>, <xsl:call-template name="CollectionDate"/>
		</td>
			<td></td>
      </tr>
		  <tr style="{$FontTiny}">
			  <td></td>
			  <td align ="left">
				  <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
					  <xsl:if test="position()=1">
						  <xsl:value-of select="./ResponsibleName"/>						  
					  </xsl:if>
				  </xsl:for-each>
				  , <xsl:call-template name="IdentificationDate"/>
			  </td>
			  <td></td>
		  </tr>
		  <tr style="{$FontTiny}">
			  <td></td>
			  <td colspan ="1" align ="right">
				  <b>Reg.Nr.: <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/></b>
			  </td>
			  <td></td>
		  </tr>
		  <tr style="{$FontTiny}">
			  <td></td>
			  <td colspan ="1" align ="right">
				  70% Ethanol
			  </td>
			  <td></td>
		  </tr>





		  <xsl:if test="./Counter mod 3 = 0">
          <tr height ="40" >
            <td></td>
            <td>  </td>
            <td></td>
          </tr>
        </xsl:if>
   </table>

    <xsl:if test="./Counter mod 3 = 0">
      <div align="center" style="{$FontTiny}; clear:both">
        <xsl:value-of select="./Counter div 3"/>
      </div>
      <h1 style="page-break-before:always"></h1>
	  <h1 style="page-break-after:always"></h1>
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
    <xsl:text> </xsl:text><xsl:apply-templates select ="CollectorsNumber"/>
    <xsl:if test="position()!= last()"> , </xsl:if>
  </xsl:template>
  
  <xsl:template match="CollectorsNumber">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template name="Event">
	  <xsl:for-each select="./CollectionEventLocalisations/Localisation">
		  <xsl:if test="./LocalisationSystemName = 'Named area (DiversityGazetteer)'">
			  <xsl:value-of select="./Location1"/>
		  </xsl:if>
	  </xsl:for-each>

	  <!--<xsl:if test="$PrintCountryCache = 1">
      <xsl:if test="./CollectionEvent/CountryCache != ''">
      <span style= "{$FontCountry}">
      <xsl:value-of select="./CollectionEvent/CountryCache"/>.
      </span>
    </xsl:if>
    </xsl:if>-->
    : <xsl:value-of select="./CollectionEvent/LocalityDescription"/> 
    <xsl:if test="./CollectionEvent/HabitatDescription != ''">
      <xsl:text> </xsl:text>
      <xsl:value-of select="./CollectionEvent/HabitatDescription"/>
    </xsl:if>
	  <xsl:for-each select="./CollectionEventLocalisations/Localisation">
		  <xsl:if test="./LocalisationSystemName = 'Coordinates WGS84'">
			 Lat.: <xsl:value-of select="./Location2"/>°, Long.: <xsl:value-of select="./Location1"/>°
	  </xsl:if>
	  </xsl:for-each>
	  <xsl:for-each select="./CollectionEventLocalisations/Localisation">
		  <xsl:if test="./LocalisationSystemName = 'Altitude (mNN)'">
			  Höhe: <xsl:value-of select="./Location1"/> - <xsl:value-of select="./Location2"/> m
		  </xsl:if>
	  </xsl:for-each>
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