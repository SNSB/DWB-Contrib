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
			<xsl:choose>
				<xsl:when test="./TransactionType = 'gift'">
					<xsl:call-template name="HeaderTo"/>
					<xsl:call-template name="HeaderAddressTo"/>
					<!--xsl:call-template name="ReturnAddress"/-->
					<xsl:call-template name="AddressFrom"/>
					<xsl:call-template name="TextGift"/>
				</xsl:when>
				<xsl:when test="./TransactionType = 'purchase'">
					<xsl:call-template name="HeaderTo"/>
					<xsl:call-template name="HeaderAddressTo"/>
					<!--xsl:call-template name="ReturnAddress"/-->
					<xsl:call-template name="AddressFrom"/>
					<xsl:call-template name="TextPurchase"/>
				</xsl:when>
				<xsl:when test="./TransactionType = 'exchange'">
					<xsl:call-template name="Header"/>
					<xsl:call-template name="HeaderAddress"/>
					<xsl:call-template name="ReturnAddress"/>
					<xsl:call-template name="Address"/>
					<xsl:call-template name="TextExchange"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="Header"/>
					<xsl:call-template name="HeaderAddress"/>
					<xsl:call-template name="ReturnAddress"/>
					<xsl:call-template name="Address"/>
					<xsl:call-template name="Text"/>
					<xsl:call-template name="Footer"/>
					<h1 style="page-break-before:left"></h1>
					<xsl:call-template name="Header"/>
					<xsl:call-template name="LoanBalance"/>
					<xsl:call-template name="SpecimenList"/>
				</xsl:otherwise>
			</xsl:choose>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="Text">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="50" valign="bottom">
        <td align="right" style="{$FontDefault}">
          <xsl:value-of select="./From/CollectionOwner/Address/City"/>, <xsl:value-of select="./Date"/>
        </td>
      </tr>
		<tr height="110" valign="center">
			<td align="left" style="{$FontDefault}">
				<b>Request for confirmation</b>
			</td>
		</tr>
		<tr height="50" valign="bottom">
        <td align="left" style="{$FontDefault}">
          The <xsl:value-of select="./From/CollectionOwner/Name"/> sent you as a loan
          the herbarium specimen(s) specified in the list attached.
        </td>
      </tr>
      <xsl:if test="./From/FromTransactionNumber != ''">
        <tr height="50" valign="bottom">
          <td align="left">
            Loan no. <xsl:value-of select="./From/FromTransactionNumber"/>
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
          Number of specimens: <xsl:value-of select="./NumberOfSpecimenInitial"/>
        </td>
      </tr>
      <tr>
        <td align="left">
          Loan granted for <xsl:value-of select="./DurationInMonths"/> months.
          Return of material expected by  <xsl:value-of select="./AgreedEndDate"/>.
        </td>
      </tr>
      <tr>
        <td align="left">
          <xsl:value-of select="./LoanComment"/>
        </td>
      </tr>
		<tr>
			<td align="left">
				Please acknowledge receipt by signing below.
			</td>
		</tr>
		<tr height="50" valign="bottom">
        <td align="left">
          Yours sincerely,
        </td>
      </tr>
      <tr height="70" valign="bottom">
        <td align="left">
			Secretarial office
		</td>
      </tr>
    </table>
  </xsl:template>

	<xsl:template name="TextGift">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<tr height="50" valign="bottom">
				<td align="right" style="{$FontDefault}">
					<xsl:value-of select="./To/Address/City"/>, <xsl:value-of select="./Date"/>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					Dear 
					<xsl:choose>
						<xsl:when test="./To/ToRecipient">
							<xsl:value-of select="./To/ToRecipient"/>,
						</xsl:when>
						<xsl:otherwise>
							Madame/Sir,
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					herewith we acknowledge the receipt of <xsl:value-of select="./NumberOfUnits"/> specimens delivered from you as a gift for the
				<xsl:value-of select="./To/Address/AgentName"/>.
					<xsl:call-template name="Umbruch">
						<xsl:with-param name="eingabe" select="./TransactionComment"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					Thank you yery much.
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left">
					Yours sincerely,
				</td>
			</tr>
			<tr height="70" valign="bottom">
				<td align="left">
					Secretarial office
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="TextPurchase">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<tr height="50" valign="bottom">
				<td align="right" style="{$FontDefault}">
					<xsl:value-of select="./To/Address/City"/>, <xsl:value-of select="./Date"/>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					Dear
					<xsl:choose>
						<xsl:when test="./To/ToRecipient">
							<xsl:value-of select="./To/ToRecipient"/>,
						</xsl:when>
						<xsl:otherwise>
							Madame/Sir,
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					herewith we acknowledge the receipt of <xsl:value-of select="./NumberOfUnits"/> specimens purchased by the
				<xsl:value-of select="./To/Address/AgentName"/> from you.
					<xsl:call-template name="Umbruch">
						<xsl:with-param name="eingabe" select="./TransactionComment"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					Thank you yery much.
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left">
					Yours sincerely,
				</td>
			</tr>
			<tr height="70" valign="bottom">
				<td align="left">
					Secretarial office
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="TextExchange">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<tr height="50" valign="bottom">
				<td align="right" style="{$FontDefault}">
					<xsl:choose>
						<xsl:when test="./Administration/CollectionAdministrativeContact/Address/City">
							<xsl:value-of select="./Administration/CollectionAdministrativeContact/Address/City"/>,
						</xsl:when>
						<xsl:when test="./Administration/CollectionOwner/Address/City">
							<xsl:value-of select="./Administration/CollectionOwner/Address/City"/>, 
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="./Date"/>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					Dear
					<xsl:choose>
						<xsl:when test="./To/ToRecipient">
							<xsl:value-of select="./To/ToRecipient"/>,
						</xsl:when>
						<xsl:otherwise>
							Madame/Sir,
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					herewith we acknowledge the receipt of <xsl:value-of select="./NumberOfUnits"/> specimens by the
					<xsl:value-of select="./To/Address/AgentName"/> from you.
					<xsl:call-template name="Umbruch">
						<xsl:with-param name="eingabe" select="./TransactionComment"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					Thank you yery much.
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left">
					Yours sincerely,
				</td>
			</tr>
			<tr height="70" valign="bottom">
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
            Loan no. <xsl:value-of select="./From/FromTransactionNumber"/>: <xsl:value-of select="./NumberOfSpecimenInitial"/> specimen(s) [
            <xsl:text> </xsl:text>
            <xsl:call-template name="Balance"/> ]
          </b>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>