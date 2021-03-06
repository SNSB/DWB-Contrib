<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="Templates/LabelTemplates.xslt"/>

  <!--Fonts-->
  <xsl:variable name="Font8">  font-size: 8pt; font-family: Arial</xsl:variable>
  <xsl:variable name="Font9">  font-size: 9pt; font-family: Arial</xsl:variable>
  <xsl:variable name="Font12">  font-size: 12pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="Font7">  font-size: 7pt; font-family: Arial</xsl:variable>
  <xsl:variable name="Font6">  font-size: 6pt; font-family: Arial</xsl:variable>


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
  <xsl:variable name="LabelWidth">150</xsl:variable>
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
	  <div align="center" style="width:160px; float:left; height:50px">
		  
	 <table cellspacing="0" cellpadding="0" width="{$LabelWidth}" height="50" border="0" style="{$Font7}; overflow:hidden; table-layout:fixed; white-space: nowrap">
		 <colgroup>
			 <col width="10"/>
			 <col width="106"/>
			 <col width="44"/>
		 </colgroup>
		 <!--<tr height ="3" valign="bottom">
			 <td align="center" colspan="2">
				 ............................
			 </td>
		 </tr>-->
		 <tr height ="9" valign="top">
			 <td align="left">+</td>
			 <td align="center" colspan="2">
			 </td>
		 </tr>
		 <tr height ="11" valign="bottom">
		<td align="left"></td>
        <td align="center" colspan="2">
          <b>Zoologische Staatssammlung</b>
        </td>
	</tr>
		 <tr height ="11" valign="bottom">
		 <td></td>
			<td align="center" colspan="2">
				<b>Munich, Germany (ZSM)</b>
			</td>
		 </tr>
		<tr height ="15" valign="center">
			<td></td>
			<td align="center" colspan="2">
				<b>Hymenoptera Section</b>
			</td>
		</tr>
		<tr height ="9">
			<td></td>
			<td align="left" colspan="1" valign="bottom">
				<xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
			</td>
			<td align="right" valign="bottom" colspan="1" rowspan="4">
				<img>
					<xsl:attribute name="src">
						<xsl:value-of select="./QRcode/ImagePath"/>
					</xsl:attribute>
					<xsl:attribute name="width">
						44
					</xsl:attribute>
					<xsl:attribute name="height">
						44
					</xsl:attribute>
				</img>
			</td>
		</tr>
		<tr height ="8" valign="bottom">
			<td></td>
			<td align="left" colspan="1">
				<span style="{$Font6}">Digit. Date: </span><xsl:value-of select="/LabelPrint/Report/Date"/>
			</td>
		</tr>
		<tr height ="11" valign="top" style="{$Font6}">
			<td></td>
			<td align="left" colspan="1">
				Content modified <span style="{$Font8}">&#9634;</span>
			</td>
		</tr>
		 <tr height ="4">
			 <td></td>
			 <td>
			 </td>
		 </tr>
	 </table>

	  </div>
	  <xsl:if test="./Counter mod 4 = 0">
		  <div align="center" style="{$FontPage}; clear:both"></div>
		  <br/>
		  <br/>
	  </xsl:if>
	  <xsl:if test="./Counter mod 36 = 0">
		  <div align="center" style="{$FontPage}; clear:both">
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