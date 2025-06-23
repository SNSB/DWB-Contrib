<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="Templates/LabelTemplates.xslt"/>

  <!--Fonts-->
  <xsl:variable name="Font8">  font-size: 8pt; font-family: Arial</xsl:variable>
	<xsl:variable name="Font14">  font-size: 14pt; font-family: Arial</xsl:variable>
	<xsl:variable name="Font9">  font-size: 9pt; font-family: Arial</xsl:variable>
  <xsl:variable name="Font12">  font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="Font7">  font-size: 7pt; font-family: Times</xsl:variable>
  <xsl:variable name="Font6">  font-size: 6pt; font-family: Times</xsl:variable>
	<xsl:variable name="Font10">  font-size: 10pt; font-family: Arial</xsl:variable>
	<xsl:variable name="Font11">  font-size: 11pt; font-family: Arial</xsl:variable>
	<xsl:variable name="Font13">  font-size: 13pt; font-family: Arial</xsl:variable>
	<xsl:variable name="Font20">  font-size: 20pt; font-family: Arial</xsl:variable>
	<xsl:variable name="Font16">  font-size: 16pt; font-family: Arial</xsl:variable>


	<xsl:variable name="FontDefault">  font-size: 6pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontSmall">    font-size:  6pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTiny">     font-size:  1pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTitle">    font-size: 7pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontTaxonName">font-size: 7pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontType">     font-size: 7pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontBarcode">  font-size: 14pt; font-family: Code 39</xsl:variable>
  <xsl:variable name="FontCountry">  font-size:  6pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontPage">	   font-size: 10pt; font-family: Arial</xsl:variable>
  
  <!--Printing options-->
  <xsl:variable name="ReportHeader">Header of report</xsl:variable>
  <xsl:variable name="PrintReportHeader">0</xsl:variable>
  <xsl:variable name="PrintCollectionOwner">0</xsl:variable>
  <xsl:variable name="PrintReportTitle">1</xsl:variable>
  <xsl:variable name="PrintBarcode">0</xsl:variable>
  <xsl:variable name="AddSpaceAtButtom">1</xsl:variable>

  <!--Page format-->
  <xsl:variable name="LabelWidth">200</xsl:variable>
  <xsl:variable name="Space">
    <xsl:text> </xsl:text>
  </xsl:variable>

  <xsl:template match="/LabelPrint">
    <html>
      <body>
        <xsl:if test="$PrintCollectionOwner = 1">
          <table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$FontTitle}; overflow:hidden; table-layout:fixed; white-space: nowrap">
            <tr height ="0">
              <td>
                <xsl:value-of select="/LabelPrint/LabelList/Label/Collection/CollectionOwner"/>
              </td>
            </tr>
          </table>
        </xsl:if>
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
	  <div  align="center" style="float:left; margin: 2px; padding: 10px; width:{$LabelWidth}; border: thin solid #000000">
    <table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$Font16}; overflow:hidden; table-layout:fixed; white-space: nowrap">
		  <thead>
			  <tr>
				  <th width="130"></th>
				  <th></th>
			  </tr>
		  </thead>
      <tr height ="80" valign="middle">
        <td align="center" colspan="2" style="{$Font16}">
          <b>
			  <xsl:value-of select="./Units/MainUnit/Identifications/Identification/VernacularTerm"/>
			  <xsl:for-each select="./Units/AssociatedUnit">
				  <xsl:text>, </xsl:text>
				  <xsl:value-of select="./Identifications/Identification/VernacularTerm"/>
			  </xsl:for-each>
		  </b>
        </td>
      </tr>
		  <tr height ="60" valign="middle">
			  <td align="left" colspan="2" style="{$Font11}">
				  <xsl:value-of select="./CollectionEvent/LocalityDescription"/>
			  </td>
		  </tr>
		  <tr height ="110" valign="bottom">
			  <td align="left">
				  <img src="Schemas/img/MSM_Logo.png" alt="Logo"/>
			  </td>
			  <td align="left" style="{$Font10}">
					  <b>Museum</b>
					  <br/>
					  <b>Reich der Kristalle</b>
			  </td>
		  </tr>
	  </table>
</div>
	  <xsl:if test="./Counter mod 2 = 0">
		  <div align="center" style="{$FontTiny}; clear:both"></div>
	  </xsl:if>
	  <xsl:if test="./Counter mod 8 = 0">
		  <div align="center" style="{$FontTiny}; clear:both">
		  </div>
		  <h1 style="page-break-before:left"></h1>
	  </xsl:if>
  </xsl:template>
  
  <xsl:template name="Event">
    <span style= "{$FontCountry}">
      <xsl:if test="./CollectionEvent/CountryCache != ''">
          <xsl:value-of select="./CollectionEvent/CountryCache"/>.
      </xsl:if>
    </span> <xsl:value-of select="./CollectionEvent/LocalityDescription"/>
    <xsl:if test="./CollectionEvent/HabitatDescription != ''">
      <xsl:text> </xsl:text>
      <xsl:value-of select="./CollectionEvent/HabitatDescription"/>
    </xsl:if>

  </xsl:template>
  
  <xsl:template match="text"></xsl:template>

</xsl:stylesheet>