<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8"/>

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
        <xsl:apply-templates select="Label"/>
        <table cellspacing="1" cellpadding="1" width="{$LabelWidth}" border="0" style="{$FontDefault}">
          <tr height ="0">
            <th width="30"></th>
            <th width="140"></th>
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
        <th width="140" ></th>
        <th width="300"></th>
        <th width="30"></th>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left">-</td>
        <td align ="left"></td>
        <td align ="left"></td>
        <td align ="right">-</td>
      </tr>
      <tr height ="10" valign="top">
        <td align ="left"> </td>
      </tr>
		  <tr height ="30" valign="top">
			  <td></td>
			  <td colspan ="2" align="center" style="{$FontTiny}">
				  <b>
					  <xsl:value-of select="../Report/Title"/>
				  </b>
			  </td>
		  </tr>
		  <tr height ="30" valign="top">
          <td></td>
          <td colspan ="2" align="center" style="{$FontTiny}">
            <b>
              <xsl:value-of select="./TopCollection/CollectionOwner"/>
            </b>
          </td>
      </tr>
		  <tr height ="30" valign="top">
			  <td></td>
			  <td colspan ="2" align="center" style="{$FontTitle}">
				  <b>
					  <xsl:value-of select="./CollectionName"/>
				  </b>
			  </td>
		  </tr>

		  <tr height ="9" valign="bottom" style="{$FontTiny}">
			  <td align="left" colspan="1" width="100">
			  </td>
			  <td align="right" valign="bottom" colspan="2" width="50">
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


		  <!--<xsl:choose>
          <xsl:when test="./OriginOfDuplicate/AccessionNumber!=''">
          <tr style="{$FontTiny}">
            <td></td>
            <td colspan ="2" align ="left"  style="border-bottom:1px solid black" valign ="buttom">
              Duplicate of <xsl:value-of select="./OriginOfDuplicate/AccessionNumber"/>
            </td>
          </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr style="{$FontTiny}">
              <td></td>
            <td colspan ="2" align ="right"  style="border-bottom:1px solid black" valign ="buttom">
              <xsl:value-of select="./CollectionSpecimen/AccessionNumber"/>
            </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      <tr height ="15">
        <td></td>
        <td></td>
      </tr>
      <tr height ="40" style="{$FontTaxonName}">
        <td></td>
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
      <tr height ="15">
        <td></td>
        <td></td>
      </tr>
      <xsl:for-each select="./Units/GrowingOnUnit/Identifications/Identification">
        <tr height ="40" style="{$FontTaxonName}">
          <td></td>
          <td colspan ="2">
            <xsl:for-each select="./Taxon/TaxonPart">
              <xsl:call-template name="TaxonPart"/>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:for-each>
      <tr style="{$FontSmall}" height ="10">
        <td></td>
        <td colspan ="2">
        </td>
      </tr>
      <tr style="{$FontSmall}">
        <td></td>
        <td colspan ="1" align ="left" valign ="top">
          <xsl:call-template name="CollectionDate"/>
        </td>
        <td colspan ="1" align ="right">
          <xsl:apply-templates select ="Collectors"/>
        </td>
      </tr>
      <xsl:if test="./Units/MainUnit/Identifications/Identification/ResponsibleName != ''">
        <tr style="{$FontSmall}">
          <td></td>
          <td colspan ="2" align ="right" >
            det.     
            <xsl:if test="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation != ''">
              <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/FirstNameAbbreviation"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="./Units/MainUnit/Identifications/Identification/Agent/SecondName"/>
        </td>
        </tr>
      </xsl:if>
      <xsl:if test="./CollectionSpecimen/OriginalNotes != ''">
        <tr style="{$FontTiny}">
          <td></td>
          <td colspan ="2" align ="left">
            <xsl:value-of select="./CollectionSpecimen/OriginalNotes"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="./CollectionSpecimen/AdditionalNotes != ''">
        <tr style="{$FontTiny}">
          <td></td>
          <td colspan ="2" align ="left">
            <xsl:value-of select="./CollectionSpecimen/AdditionalNotes"/>
          </td>
        </tr>
      </xsl:if>
      <tr height ="4" >
        <td></td>
        <td>  </td>
        <td></td>
      </tr>-->
      <!--tr height ="1" >
        <td></td>
        <td valign ="bottom" colspan ="2" align ="right" style="padding-bottom:0px; border-top:1px dashed #CCCCCC" color="#000000">
            <span style="COLOR: white">.</span>
        </td>
        <td></td>
      </tr-->
    </table>

    <xsl:if test="./Counter mod $LabelPerPage = 0">
      <div align="center" style="{$FontTiny}; clear:both">
        <xsl:value-of select="./Counter div $LabelPerPage"/>
      </div>
      <h1 style="page-break-before:left"></h1>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>