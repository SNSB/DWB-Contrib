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
			<!--Schreiben an urspruenglichen Halter der Ausleihe-->
            <xsl:call-template name="HeaderAdmin"/>
            <xsl:call-template name="HeaderAddressAdmin"/>
		    <xsl:call-template name="AddressToParent"/>
			<xsl:call-template name="TextLoan"/>
			
			<h1 style="page-break-before:left"></h1>
			
			<!--Schreiben an Empfaenger der Weitergeleiteten Teile-->
			<xsl:call-template name="HeaderAdmin"/>
			<xsl:call-template name="HeaderAddressAdmin"/>
            <xsl:call-template name="Address"/>
            <xsl:call-template name="TextForwarding"/>
			<xsl:call-template name="Footer"/>
			<h1 style="page-break-before:left"></h1>
			<xsl:call-template name="Header"/>
			<xsl:call-template name="LoanBalance"/>
			<xsl:call-template name="SpecimenList"/>
		</xsl:for-each>
      </body>
    </html>
  </xsl:template>

	<xsl:template name="TextLoan">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<tr height="50" valign="bottom">
				<td align="right" style="{$FontDefault}">
					<xsl:value-of select="./From/Address/City"/>, <xsl:value-of select="./Date"/>
				</td>
			</tr>
			<tr height="110" valign="center">
				<td align="left" style="{$FontDefault}">
					<b>Loan transfer</b>
				</td>
			</tr>

			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					The <xsl:value-of select="./Administration/CollectionAdministrativeContact/Address/AgentName"/> herewith agrees to transfer our Loan no. <xsl:value-of select="./Transaction/From/FromTransactionNumber"/> (originally <xsl:value-of select="./Transaction/NumberOfSpecimenInitial"/> specimens)
					sent to <xsl:value-of select="./Transaction/To/Address/AgentName"/>
					<xsl:if test="./Transaction/To/Address/Abbreviation">
						(<xsl:value-of select="./Transaction/To/Address/Abbreviation"/>)
					</xsl:if>
					<xsl:if test="./Transaction/Investigator">
						for study by <xsl:value-of select="./Transaction/Investigator"/>
					</xsl:if>
					to the <xsl:value-of select="./To/Address/AgentName"/>
					<xsl:if test="./To/Address/Abbreviation">
						(<xsl:value-of select="./To/Address/Abbreviation"/>)
					</xsl:if>
					<xsl:if test="./Investigator">
						for study by <xsl:value-of select="./Investigator"/>
					</xsl:if>
					(transfer of complete / partial loan).
				</td>
			</tr>
			<xsl:if test="./From/FromTransactionNumber != ''">
			</xsl:if>
			<xsl:if test="./Transaction/NumberOfSpecimenOnLoan > 0">
				<tr height="50" valign="bottom">
					<td align="left" style="{$FontDefault}">
						We expect that the remaining <xsl:value-of select="./Transaction/NumberOfSpecimenOnLoan"/> specimens of the loan
						are returned to the <xsl:value-of select="./Administration/CollectionOwner/Name"/> (<xsl:value-of select="./Administration/CollectionOwner/Acronym"/>) at <xsl:value-of select="./Transaction/AgreedEndDate"/>.
					</td>
				</tr>
				
			</xsl:if>
			<!--xsl:if test="./From/FromTransactionNumber != ''">
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
					Number of specimens: <xsl:value-of select="./NumberOfSpecimenOnLoan"/>
					(in <xsl:value-of select="./NumberOfStockOnLoan"/> parts)
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
					<xsl:value-of select="./TransactionComment"/>
				</td>
			</tr-->
			<tr height="50" valign="bottom">
				<td align="left">
					Yours sincerely,
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left">
					The Curator
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="TextForwarding">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<tr height="50" valign="bottom">
				<td align="right" style="{$FontDefault}">
					<xsl:value-of select="./From/Address/City"/>, <xsl:value-of select="./Date"/>
				</td>
			</tr>
			<tr height="110" valign="center">
				<td align="left" style="{$FontDefault}">
					<b>Loan transfer</b>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					The <xsl:value-of select="./Administration/CollectionAdministrativeContact/Address/AgentName"/> herewith agrees to transfer our Loan no. <xsl:value-of select="./Transaction/From/FromTransactionNumber"/> (originally <xsl:value-of select="./Transaction/NumberOfSpecimenInitial"/> specimens)
					sent to <xsl:value-of select="./Transaction/To/Address/AgentName"/>
					<xsl:if test="./Transaction/To/Address/Abbreviation">
						(<xsl:value-of select="./Transaction/To/Address/Abbreviation"/>)
					</xsl:if>
					<xsl:if test="./Transaction/Investigator">
						for study by <xsl:value-of select="./Transaction/Investigator"/>
					</xsl:if>
					 to the <xsl:value-of select="./To/Address/AgentName"/>
					<xsl:if test="./To/Address/Abbreviation">
						(<xsl:value-of select="./To/Address/Abbreviation"/>)
					</xsl:if>
					<xsl:if test="./Investigator">
						for study by <xsl:value-of select="./Investigator"/>
					</xsl:if>
					(transfer of complete / partial loan).
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
					(in <xsl:value-of select="./NumberOfStockInitial"/> parts)
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
					<xsl:value-of select="./TransactionComment"/>
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left">
					Yours sincerely,
				</td>
			</tr>
			<tr height="50" valign="bottom">
				<td align="left">
					The Curator
				</td>
			</tr>
		</table>
	</xsl:template>

  <xsl:template name="Text">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="50" valign="bottom">
        <td align="right" style="{$FontDefault}">
          <xsl:value-of select="./From/Address/City"/>, <xsl:value-of select="./Date"/>
        </td>
      </tr>
		<tr height="50" valign="bottom">
			<td align="left" style="{$FontDefault}">
				Dear Madame/Sir,
			</td>
		</tr>

		<tr height="50" valign="bottom">
        <td align="left" style="{$FontDefault}">
		  herewith we agree to transfer our Loan no. <xsl:value-of select="./Transaction/From/FromTransactionNumber"/> (originally <xsl:value-of select="./Transaction/NumberOfSpecimenInitial"/> specimens) 
		  sent to <xsl:value-of select="./Transaction/To/Address/AgentName"/> (<xsl:value-of select="./Transaction/To/Acronym"/> ) 
		  for study by <xsl:value-of select="./Transaction/Investigator"/> (transfer of complete/ partial loan).
        </td>
      </tr>
		<xsl:if test="./From/FromTransactionNumber != ''">
			<tr height="50" valign="bottom">
				<td align="left" style="{$FontDefault}">
					We expect that the remaining <xsl:value-of select="./Transaction/NumberOfSpecimenOnLoan"/> specimens of the loan 
					are returned to the <xsl:value-of select="./Administration/CollectionOwner/Name"/> (<xsl:value-of select="./Administration/CollectionOwner/Acronym"/>) at <xsl:value-of select="./Administration/CollectionOwner/AgreedEndDate"/>.
				</td>
			</tr>
		</xsl:if>
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
          Number of specimens: <xsl:value-of select="./NumberOfSpecimenOnLoan"/>
          (in <xsl:value-of select="./NumberOfStockOnLoan"/> parts)
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
          <xsl:value-of select="./TransactionComment"/>
        </td>
      </tr>
      <tr height="50" valign="bottom">
        <td align="left">
          Yours sincerely,
        </td>
      </tr>
      <tr height="50" valign="bottom">
        <td align="left">
          The Curator
        </td>
      </tr>
    </table>
  </xsl:template>

	<xsl:template name="LoanBalance">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr>
      <td height="40" valign="top" colspan="2">
        <b>
          Loan no. <xsl:value-of select="./From/FromTransactionNumber"/>: <xsl:value-of select="./NumberOfSpecimenOnLoan"/> specimen(s) [
          <xsl:text> </xsl:text>
          <xsl:call-template name="Balance"/> ]
        </b>
      </td>
    </tr>
    </table>
  </xsl:template>


	<xsl:template name="LoanBalanceParent">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<tr>
				<td height="40" valign="top" colspan="2">
					<b>
						Loan no. <xsl:value-of select="./Transaction/From/FromTransactionNumber"/>: <xsl:value-of select="./Transaction/NumberOfSpecimenOnLoan"/> specimen(s) [
						<xsl:text> </xsl:text>
						<xsl:call-template name="BalanceParent"/> ]
					</b>
				</td>
			</tr>
		</table>
	</xsl:template>


	<xsl:template match="text"></xsl:template>
</xsl:stylesheet>