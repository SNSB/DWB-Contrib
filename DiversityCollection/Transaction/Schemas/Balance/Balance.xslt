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
        <!--<xsl:call-template name="Header"/>-->
		  <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontBig}">
			  <tr valign="bottom">
				  <td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
					  <b>
						  <xsl:choose>
							  <xsl:when test="./From/CollectionAdministrativeContact/Address/AgentName">
								  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/AgentName"/>
							  </xsl:when>
							  <xsl:when test="./From/FromTransactionPartnerName">
								  <xsl:value-of select="./From/FromTransactionPartnerName"/>
							  </xsl:when>
							  <xsl:when test="./From/FromTransactionPartnerAddress/AgentName">
								  <xsl:value-of select="./From/FromTransactionPartnerAddress/AgentName"/>
							  </xsl:when>
						  </xsl:choose>
					  </b>
				  </td>
				  <td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
					  <b>
						  <xsl:choose>
							  <xsl:when test="./From/CollectionAdministrativeContact/Address/Abbreviation">
								  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/Abbreviation"/>
							  </xsl:when>
							  <xsl:when test="./From/Administration/CollectionOwner/Acronym">
								  <xsl:value-of select="./From/Administration/CollectionOwner/Acronym"/>
							  </xsl:when>
						  </xsl:choose>
					  </b>
				  </td>
			  </tr>
		  </table>


		<!--<xsl:call-template name="HeaderAddress"/>-->
		  <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
			  <tr height="20" valign="bottom">
				  <td align="left" style="{$FontSmall}">
					  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/Streetaddress"/>
					  <xsl:text> </xsl:text>
					  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/PostalCode"/>
					  <xsl:text> </xsl:text>
					  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/City"/>
					  <xsl:text> </xsl:text>
					  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/Country"/>
				  </td>
				  <td align="right" style="{$FontSmall}">
					  <xsl:if test="./From/CollectionAdministrativeContact/Address/Telephone != ''">
						  Phone: <xsl:value-of select="./From/CollectionAdministrativeContact/Address/Telephone"/>
					  </xsl:if>
				  </td>
			  </tr>
			  <xsl:if test="./From/CollectionAdministrativeContact/Address/Telefax != ''">
				  <tr>
					  <td>
					  </td>
					  <td align="right" style="{$FontSmall}">
						  FAX: <xsl:value-of select="./From/CollectionAdministrativeContact/Address/Telefax"/>
					  </td>
				  </tr>
			  </xsl:if>
			  <xsl:if test="./From/CollectionAdministrativeContact/Address/Email != ''">
				  <tr>
					  <td>
					  </td>
					  <td align="right" style="{$FontSmall}">
						  E-mail: <xsl:value-of select="./From/CollectionAdministrativeContact/Address/Email"/>
					  </td>
				  </tr>
			  </xsl:if>
		  </table>



		 <!--<xsl:call-template name="ReturnAddress"/>-->
		  <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontSmall}">
			  <tr height="60" valign="bottom">
				  <td align="left">
					  <xsl:choose>
						  <xsl:when test="./From/CollectionAdministrativeContact/CollectionOwner/Name">
							  <xsl:value-of select="./From/CollectionAdministrativeContact/CollectionOwner/Name"/>
						  </xsl:when>
						  <xsl:when test="./From/CollectionAdministrativeContact/Address/AgentName">
							  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/AgentName"/>
						  </xsl:when>
					  </xsl:choose>
					  <xsl:text>, </xsl:text>
					  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/Streetaddress"/>
				  </td>
			  </tr>
			  <tr height="30" valign="top">
				  <td align="left">
					  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/PostalCode"/>
					  <xsl:text> </xsl:text>
					  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/City"/>
					  <xsl:text> </xsl:text>
					  <xsl:value-of select="./From/CollectionAdministrativeContact/Address/Country"/>
				  </td>
			  </tr>
		  </table>



		  <b>exchange partner:</b>
        <xsl:call-template name="Address"/>
        <xsl:call-template name="Text"/>
        <b>exchange balance per category</b>
        <xsl:call-template name="BalanceSummary"/>
        <br/>
        <br/>
        <b>exchange details</b>
        <xsl:call-template name="BalanceDetails"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="Text">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="50" valign="bottom">
        <td align="right" style="{$FontDefault}">
          <xsl:value-of select="./From/CollectionAdministrativeContact/Address/City"/>, <xsl:value-of select="./Date"/>
        </td>
      </tr>
    </table>
    <br/>
    <br/>
  </xsl:template>

  <xsl:template name="BalanceSummary">
    <table cellspacing="0" cellpadding="0" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="20" valign ="bottom">
        <td style="border-bottom:1px solid black">category</td>
        <td style="border-bottom:1px solid black">received</td>
        <td style="border-bottom:1px solid black">sent</td>
        <td style="border-bottom:1px solid black">balance</td>
      </tr>
      <xsl:for-each select="./Balance/Detail">
        <tr>
          <td >
            <xsl:value-of select="./ReportingCategory"/>
          </td>
          <td>
            <xsl:value-of select="./Received"/>
          </td>
          <td >
            <xsl:value-of select="./Sent"/>
          </td>
          <td>
            <xsl:value-of select="./Balance"/>
          </td>
        </tr>
      </xsl:for-each>
      <tr>
        <td style="border-top:1px solid black" colspan="3">
          <b>total balance</b>
        </td>
        <td style="border-top:1px solid black">
          <b><xsl:value-of select="./TotalBalance"/></b>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="BalanceDetails">
    <table cellspacing="1" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height ="20" valign ="bottom">
        <td  style="border-bottom:1px solid black">received sent</td>
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
          <td align="center">
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