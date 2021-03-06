<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <xsl:include href="../TransactionTemplates.xslt"/>


  <xsl:template match="/TransactionList">
    <style type="text/css">
      body { margin-left:70px; }
    </style>
    <html>
      <body>
        <xsl:for-each select="./Transaction">
          <xsl:call-template name="Header"/>
          <xsl:call-template name="HeaderAddress"/>
          <xsl:call-template name="ReturnAddress"/>
          <xsl:call-template name="Address"/>
          <xsl:call-template name="Text"/>
          <xsl:call-template name="Footer"/>
          <!--h1 style="page-break-before:left"></h1>
          <xsl:call-template name="Header"/>
          <xsl:call-template name="LoanBalance"/>
          <xsl:call-template name="SpecimenList"/-->
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="Text">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
		<!-->tr height="50" valign="bottom">
			<td align="right" style="{$FontDefault}">
			  <xsl:value-of select="./From/Collection/CollectionAddress/City"/>, <xsl:value-of select="./Date"/>
			</td>
		</tr-->
		<tr height="50" valign="bottom">
			<td align="right" style="{$FontDefault}">
				<xsl:value-of select="./From/Address/City"/>,
				<xsl:value-of select="./Date"/>
				<!--xsl:choose>
					<xsl:when test="./BeginDate">
						<xsl:value-of select="./BeginDate"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="./Date"/>
					</xsl:otherwise>
				</xsl:choose-->
			</td>
		</tr>
		<tr height="50" valign="bottom">
			<td align="left" style="{$FontDefault}">
				<b>Outstanding loan</b>
			</td>
		</tr>
		<tr height="50" valign="bottom">
			<td align="left" style="{$FontDefault}">
				Dear
				<xsl:choose>
				<xsl:when test="./To/Address/PersonName != ''">
					<xsl:value-of select="./Address/To/PersonName"/>
				</xsl:when>
					<xsl:otherwise>
						Director
					</xsl:otherwise>
				</xsl:choose>,
			</td>
		</tr>
		<tr height="50" valign="bottom">
			<td align="left" style="{$FontDefault}">
				this is to kindly remind you, that the time granted for the
			</td>
		</tr>
		<!--tr height="50" valign="bottom">
        <td align="left" style="{$FontDefault}">
          The <xsl:value-of select="./From/Collection/CollectionOwner"/> sent you as a loan
          the herbarium specimen(s) specified in the list attached.
        </td>
      </tr-->
      <xsl:if test="./From/FromTransactionNumber != ''">
        <tr height="50" valign="bottom">
          <td align="left">
            Loan no. <xsl:value-of select="./From/FromTransactionNumber"/> (<xsl:value-of select="./NumberOfSpecimenInitial"/>)
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="./Investigator != ''">
        <tr height="50" valign="bottom">
          <td align="left">
            For study by: <xsl:value-of select="./Investigator"/>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td align="left">
          Number of specimens returned: <xsl:value-of select="./From/NumberOfSpecimenReturned"/>
        </td>
      </tr>
		<tr>
			<td align="left">
				Number of still outstanding specimens: <xsl:value-of select="./From/NumberOfSpecimenOnLoan"/>
			</td>
		</tr>
		<tr>
        <td align="left">
          Loan granted for <xsl:value-of select="./DurationInMonths"/> months.
		  <xsl:choose>
			  <xsl:when test="./ProlongationInMonths">
				  Prolongation granted for <xsl:value-of select="./ProlongationInMonths"/> months.
				  Return of material expected by  <xsl:value-of select="./ActualEndDate"/>.
			  </xsl:when>
			  <xsl:otherwise>
				  Return of material expected by  <xsl:value-of select="./AgreedEndDate"/>.
			  </xsl:otherwise>
		  </xsl:choose>
        </td>
      </tr>
      <tr>
        <td align="left">
			<td align="left">
				<xsl:call-template name="Umbruch">
					<xsl:with-param name="eingabe" select="./TransactionComment"/>
				</xsl:call-template>
			</td>
      </tr>
      <tr height="50" valign="bottom">
        <td align="left">
          Yours sincerely,
        </td>
      </tr>
      <tr height="50" valign="bottom">
        <td align="left">
			Secretarial office
		</td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="LoanBalance">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr>
      <td height="40" valign="bottom" colspan="2">
        <b>
          Loan no. <xsl:value-of select="./FromTransactionNumber"/>: <xsl:value-of select="./NumberOfSpecimenOnLoan"/> specimen(s) [
          <xsl:text> </xsl:text>
          <xsl:call-template name="Balance"/> ]
        </b>
      </td>
    </tr>
    </table>
  </xsl:template>

  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>