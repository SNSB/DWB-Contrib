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
	<xsl:variable name="Font13">  font-size: 13pt; font-family: Arial</xsl:variable>


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
  <xsl:variable name="LabelWidth">220</xsl:variable>
<xsl:variable name="LineHeight">16</xsl:variable>
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
	  <div  align="center" style="float:left; margin: 2px; padding: 10px; width:230px; border: thin solid #000000">
    <table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$Font10}; overflow:scroll; table-layout:fixed; white-space: wrap">
		<thead>
			<th width="130"></th>
			<th width="130"></th>
		</thead>
		<tr height ="20" valign="top">
        <td align="right" colspan="2" style="{$Font12}">
			<b><xsl:value-of select="number(substring(./CollectionSpecimen/AccessionNumberSpecimen, 4))"/></b>
        </td>
      </tr>
		<tr height ="50">
		<td align="left" colspan="2" valign="top" style="{$Font12}">
			<xsl:value-of select="./Units/MainUnit/Identifications/Identification/VernacularTerm"/>
			<xsl:for-each select="./Units/AssociatedUnit">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="./Identifications/Identification/VernacularTerm"/>
			</xsl:for-each>
		</td>
		</tr>
		<tr valign="top" height ="40">
			<td align="left" colspan="2">
					<xsl:value-of select="./CollectionEvent/LocalityDescription"/>
			</td>
		</tr>
		<tr height ="{$LineHeight}" valign="top">
			<td align="left">
					<xsl:value-of select="./CollectionSpecimen/StorageLocation"/>
			</td>
			<td align="right">
			<xsl:for-each select="./Units/SubstrateUnit/UnitAnalysis/Analysis">
				<xsl:if test="./AnalysisName='Wiegt'">
					<xsl:text> </xsl:text><xsl:value-of select="./AnalysisResult"/>
							<xsl:value-of select="./MeasurementUnit"/>
				</xsl:if>
			</xsl:for-each>
			</td>
		</tr>
		<tr height ="4" valign="bottom">
			<td align="center" colspan ="2">
			</td>
		</tr>
		<tr height ="2" valign="bottom">
			<td align="center" colspan ="2" bgcolor="#000000">
			</td>
		</tr>
		<tr height ="22" valign="bottom">
			  <td align="center" colspan ="2">
				  Mineralogische Staatssammlung
			  </td>
		</tr>
	</table>
	  </div>
	  <xsl:if test="./Counter mod 2 = 0">
		  <div align="center" style="{$FontTiny}; clear:both"></div>
	  </xsl:if>
	  <xsl:if test="./Counter mod 10 = 0">
		  <div align="center" style="{$FontTiny}; clear:both">
		  </div>
		  <h1 style="page-break-before:left"></h1>
	  </xsl:if>

	  <!--<table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="overflow:hidden; table-layout:fixed; white-space: nowrap">
      <tr height ="14" valign="bottom">
        <td align="left" colspan="2" style="{$Font12}>" width="100">
          <b>
              <xsl:value-of select="./Units/MainUnit/Identifications/Identification/TypeStatus"/>
          </b>
        </td>
        <td align="left" width="5">
        </td>
        <td align="left" style="{$Font7}" colspan="3" width="190" valign="top">
            <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Taxon/TaxonPart/AuthorsSpecies"/>
        </td>
        <td align="left" width="55" valign="top"  style="{$Font8}" rowspan="2">
          <xsl:value-of select="./CollectionEvent/CountryCache"/>
        </td>
      </tr>-->
      <!--<tr height ="30" valign="bottom">
        <td align="left" style="{$Font14}>" width="20">
          drain.:
        </td>
        <td align="left" style="{$Font7}>" width="60">
          <xsl:for-each select="./CollectionEventLocalisations/Localisation">
            <xsl:if test="./ParsingMethod='Gazetteer'">
              <xsl:value-of select="./Location1"/>
            </xsl:if>
          </xsl:for-each>
        </td>
        <td align="right" style="{$Font7}>" width="20">
          GPS:
        </td>
        <td align="right" style="{$Font7}>">
          <xsl:for-each select="./CollectionEventLocalisations/Localisation">
            <xsl:if test="./ParsingMethod='Coordinates'">
              <xsl:value-of select="./AverageLatitudeCache"/>
            </xsl:if>
          </xsl:for-each>
        </td>
        <td align="right" style="{$Font7}>" width="5">
          /
        </td>
        <td align="left" style="{$Font7}>" width="50">
          <xsl:for-each select="./CollectionEventLocalisations/Localisation">
            <xsl:if test="./ParsingMethod='Coordinates'">
              <xsl:value-of select="./AverageLongitudeCache"/>
            </xsl:if>
          </xsl:for-each>
        </td>
        --><!--td width="55"></td--><!--
      </tr>
      --><!--<tr height ="9"  style="{$Font7}>" valign="bottom">
        <td align="left" colspan="6">
          <xsl:value-of select="./CollectionEvent/LocalityDescription"/>
        </td>
      </tr>--><!--
    </table>-->
    <!--<table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$Font7}; overflow:hidden; table-layout:fixed; white-space: nowrap">
      <tr height ="9" valign="top">
        <td>
          <u>leg.:</u>
        </td>
        <td  style="{$Font6}" align="left"><xsl:text> </xsl:text>
          <xsl:for-each select="./Collectors/Collector">
            <xsl:if test="position()!=1">,<xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="./CollectorsName"/>
          </xsl:for-each>
        </td>
        <td>
          <u>don.:</u>
        </td>
        <td align="left"  style="{$Font6}" width="70">
            <xsl:text> </xsl:text><xsl:value-of select="./CollectionSpecimen/DepositorsName"/>
        </td>
        <td align="left">
        </td>
        <td align="right" width="55">
          <xsl:text> </xsl:text><xsl:value-of select="./CollectionEvent/CollectionDay"/>.
          <xsl:text> </xsl:text><xsl:value-of select="./CollectionEvent/CollectionMonth"/>.
          <xsl:text> </xsl:text><xsl:value-of select="./CollectionEvent/CollectionYear"/>
        </td>
      </tr>
      <tr>
        <td align="left" colspan="6">
          <xsl:value-of select="./CollectionSpecimen/AdditionalNotes"/>
        </td>
      </tr>
    </table>-->
    <!--<table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$Font7}; overflow:hidden; table-layout:fixed; white-space: nowrap">
      <tr height ="9" valign="bottom">
        <td align="left">
          <b>DNATAX:</b>
        </td>
        <td align="left"  width="50">
          <xsl:for-each select="./SpecimenParts/SpecimenPart">
            <xsl:if test="position()=1">
              <xsl:value-of select="./AccessionNumber"/>
            </xsl:if>
          </xsl:for-each>
        </td>
        <td align="left">-
        </td>
        <td align="left"  width="50">
          <xsl:for-each select="./SpecimenParts/SpecimenPart">
            <xsl:if test="position()=last">
              <xsl:value-of select="./AccessionNumber"/>
            </xsl:if>
          </xsl:for-each>
        </td>
        <td align="left">
          Det.:<xsl:text> </xsl:text>
          <xsl:value-of select="./Units/MainUnit/Identifications/Identification/ResponsibleName"/>
        </td>
        <td align="left" width="50">
          Exempl:
        </td>
        <td align="left">
          <xsl:value-of select="./Units/MainUnit/NumberOfUnits"/>
        </td>
      </tr>
      <tr>
        <td align="left">
          <b>DNA Feld Nr:</b>
        </td>
        <td align="left" colspan="6">
          <xsl:for-each select="./SpecimenParts/SpecimenPart">
            <xsl:if test="./MaterialCategory='DNA sample'">
              <xsl:value-of select="./StorageLocation"/>
            </xsl:if>
          </xsl:for-each>
        </td>
      </tr>
    </table>-->
	  <!--<table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$Font14}; overflow:hidden; table-layout:fixed; white-space: nowrap">
		  <thead>
			  <tr>
				  <th width="140"></th>
				  <th></th>
			  </tr>
		  </thead>
		  <th></th>
		  <tr height ="110" valign="bottom">
			  <td align="left">
				  <img src="Schemas/img/MSM_Logo.png" alt="Logo"/>
			  </td>
			  <td align="left">
					  <b>Museum</b>
					  <br/>
					  <b>Reich der Kristalle</b>
			  </td>
		  </tr>
	  </table>-->

	  <!--table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$FontDefault}">
      <tr height ="0">
        <th width="{$LabelWidth}*3/4" ></th>
        <th width="{$LabelWidth}/4"></th>
        <th width="130" ></th>
        <th width="50"></th>
      </tr>
      <tr height ="6" valign="bottom">
        <td align ="left">
          <xsl:value-of select="./CollectionSpecimen/LabelTitle"/>
          <xsl:if test="./CollectionSpecimen/LabelTitle != ''">
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="./CollectionSpecimen/DepositorsAccessionNumber"/>
          <span style="color:white"><xsl:text> </xsl:text></span>
        </td>
        <td align ="right">
          <xsl:if test="./CollectionSpecimen/AccessionNumber != ''">
            <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
          </xsl:if>
        </td>
      </tr>
      <tr height ="1">
        <td style="border-top:1px solid black" colspan ="2">
          <font color="#ffffff"> .</font>
        </td>
      </tr>
    </table-->
      <!--table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$FontDefault}">
        <tr height ="0">
          <th width="20" ></th>
          <th width="160"></th>
        </tr>
        <tr style="{$FontTaxonName}">
        <td colspan ="2">
            <xsl:for-each select="./Units/MainUnit/Identifications/Identification">
              <xsl:if test="position()=1">
                <xsl:for-each select="./Taxon/TaxonPart">
                  <xsl:call-template name="TaxonPart"/>
                </xsl:for-each>
              </xsl:if>
            </xsl:for-each>
        </td>
      </tr>
      <xsl:call-template name="Type"/>
      <tr style="{$FontTaxonName}">
        <td colspan ="2">
          <xsl:call-template name="UnitHierarchy"/>
        </td>
      </tr>
        <tr height ="3">
          <td colspan ="2">
          </td>
        </tr>
        <tr style="{$FontSmall}">
        <td colspan ="2">
          <xsl:call-template name="Event"/>
          <xsl:call-template name="Altitude"/>
        </td>
      </tr>
        <tr height ="3">
          <td colspan ="2">
          </td>
        </tr>
        <tr style="{$FontSmall}">
        <td colspan ="1" align ="left" valign ="top">
          <xsl:call-template name="CollectionDate"/>
        </td>
          <xsl:if test="./Collectors/Collector/CollectorsName != ''">
            <td colspan ="1" align ="right">
            leg: <xsl:call-template name ="Collectors"/>
            </td>
        </xsl:if>
      </tr>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/ResponsibleName != ''">
        <tr style="{$FontSmall}">
          <td >
          </td>
          <td colspan ="1" align ="right">
            det.:<xsl:text> </xsl:text>
            <xsl:if test="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation != ''">
              <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/SecondName"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="$PrintBarcode = 1">
        <xsl:if test="./CollectionSpecimen/AccessionNumber != ''">
          <tr height ="30" style="{$FontBarcode}">
            <td colspan ="2" align="center" valign ="bottom">
              *<xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>*
            </td>
          </tr>
          <tr height ="10" style="{$FontDefault}">
            <td colspan ="2" align="center" valign ="top">
              <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
        <xsl:if test="$AddSpaceAtButtom = 1">
          <tr height ="50">
            <td colspan ="2" align="center" valign ="top">
            </td>
          </tr>
        </xsl:if>
        <tr style="{$FontSmall}" height ="0">
          <td colspan ="2" align ="right" style="padding-bottom:20px; border-bottom:1px dashed #CCCCCC" >
            <xsl:text>.</xsl:text>
          </td>
        </tr>
      </table-->
    <!--xsl:if test="./Collection/CollectionName='ZSM-DNA'">
      <table cellspacing="0" cellpadding="0" width="{$LabelWidth}" border="0" style="{$Font7}">
        <tr height ="9" valign="bottom">
          <td align="left">
            <b>DNATAX:</b>
          </td>
          <td align="left"  width="50">
            <xsl:text> </xsl:text><xsl:value-of select="./CollectionSpecimen/StorageLocation"/>
          </td>
          <td align="left">
            -
          </td>
          <td align="left"  width="50">
          </td>
          <td align="left">
            Det.:<xsl:text> </xsl:text>
            <xsl:value-of select="./Units/MainUnit/Identifications/Identification/ResponsibleName"/>
          </td>
          <td align="left" width="50">
            Exempl:
          </td>
          <td align="left">
            <xsl:value-of select="./Units/MainUnit/NumberOfUnits"/>
          </td>
        </tr>
        <tr>
          <td align="left">
            <b>DNA Feld Nr:</b>
          </td>
          <td align="left" colspan="6">
            <xsl:text> </xsl:text>
              <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
            </td>
        </tr>
      </table>
    </xsl:if-->
      <!--<xsl:if test="./Counter mod 7 = 0">
      <div align="center" style="{$FontPage}">
        <xsl:value-of select="./Counter div 7"/>
      </div>
		<h1 style="page-break-before:left"></h1>
      </xsl:if>-->
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