<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="../TransactionTemplates.xslt"/>

  <xsl:template match="/Transaction">
    <style type="text/css">
      body { margin-left:70px; }
    </style>
    <html>
      <body style="{$FontDefault}">
        <b>Statistics for <xsl:value-of select="./TransactionAgent"/></b>
		  <br/>
		  <xsl:value-of select="./From"/> - <xsl:value-of select="./Until"/>
		  <br/>
		  Number of loans: <xsl:value-of select="./NumberOfLoans"/>
		  <br/>
        <xsl:call-template name="Statistics"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="Text">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="50" valign="bottom">
        <td align="right" style="{$FontDefault}">
          <xsl:value-of select="./From/Collection/CollectionAddress/City"/>, <xsl:value-of select="./Date"/>
        </td>
      </tr>
    </table>
    <br/>
    <br/>
  </xsl:template>

  <xsl:template name="Statistics">
    <table cellspacing="0" cellpadding="0" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="20" valign ="bottom">
        <td style="border-bottom:1px solid black">category</td>
        <td style="border-bottom:1px solid black">Type</td>
        <td style="border-bottom:1px solid black">No type</td>
      </tr>
      <xsl:for-each select="./Groups/Group">
        <tr>
          <td >
            <xsl:value-of select="./ReportingCategory"/>
          </td>
          <td>
            <xsl:value-of select="./Type"/>
          </td>
          <td >
            <xsl:value-of select="./NoType"/>
          </td>
        </tr>
      </xsl:for-each>
      <tr>
        <td style="border-top:1px solid black" >
          <b>total balance</b>
        </td>
        <td style="border-top:1px solid black">
          <b><xsl:value-of select="./Total/Type"/></b>
        </td>
		  <td style="border-top:1px solid black">
			  <b>
				  <xsl:value-of select="./Total/NoType"/>
			  </b>
		  </td>
	  </tr>
    </table>
  </xsl:template>

  <xsl:template name="BalanceDetails">
    <table cellspacing="0" cellpadding="0" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height ="20" valign ="bottom">
        <td  style="border-bottom:1px solid black">received/sent</td>
        <td style="border-bottom:1px solid black">category</td>
        <td style="border-bottom:1px solid black">date</td>
        <td style="border-bottom:1px solid black">specimen</td>
        <td style="border-bottom:1px solid black">inv-no</td>
        <td style="border-bottom:1px solid black">description</td>
      </tr>
      <xsl:for-each select="./Details/Detail">
        <tr>
          <td >
            <xsl:value-of select="./Direction"/>
          </td>
          <td >
            <xsl:value-of select="./ReportingCategory"/>
          </td>
          <td>
            <xsl:value-of select="./BeginDate"/>
          </td>
          <td >
            <xsl:value-of select="./NumberOfUnits"/>
          </td>
          <td>
              <xsl:value-of select="./ToTransactionNumber"/>
          </td>
          <td>
            <xsl:value-of select="./MaterialDescription "/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>


  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>