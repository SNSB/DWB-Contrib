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
  <xsl:variable name="LabelWidth">200</xsl:variable>
  <xsl:variable name="Space"> </xsl:variable>
  <xsl:variable name="LabelPerPage">0</xsl:variable>

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
    <div  align="center" style="width:230px; float:left; height:50px">

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
        <tr height ="9" valign="bottom" style="{$FontTitle}">
          <td align="center" colspan="1" width="100">
          </td>
          <td align="center" valign="bottom" colspan="2" width="200">
            <b>
              <xsl:value-of select="./CollectionName"/>
            </b>

            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="./QRcode/ImagePath"/>
              </xsl:attribute>
              <xsl:attribute name="width">
                150
              </xsl:attribute>
              <xsl:attribute name="height">
                150
              </xsl:attribute>
            </img>
          </td>
        </tr>
        <tr height ="20" valign="top">
          <td></td>
          <td colspan ="2" align="center" style="{$FontTiny}">
              Contact: <xsl:value-of select="./AdministrativeContactName"/>
          </td>
        </tr>
        <tr height ="20" valign="top">
          <td></td>
          <td colspan ="2" align="center" style="{$FontTiny}">
              <xsl:value-of select="./Description"/>
          </td>
        </tr>
      </table>
    </div>

    <xsl:if test="./Counter mod 3 = 0">
      <div align="center" style="{$FontTiny}; clear:both"></div>
      <br/>
      <br/>
    </xsl:if>
    
    <xsl:if test="./Counter mod 15 = 0">
      <div align="center" style="{$FontTiny}; clear:both">
        <xsl:value-of select="./Counter div 15"/>
      </div>
      <h1 style="page-break-before:left"></h1>
    </xsl:if>


    <!--<xsl:if test="./Counter mod $LabelPerPage = 0">
      <div align="center" style="{$FontTiny}; clear:both">
        <xsl:value-of select="./Counter div $LabelPerPage"/>
      </div>
      <h1 style="page-break-before:left"></h1>
    </xsl:if>-->
    
  </xsl:template>
  
  
  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>