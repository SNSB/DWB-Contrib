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
          <xsl:call-template name="Footer_DE"/>
          <h1 style="page-break-before:left"></h1>
          <xsl:call-template name="Header"/>
          <xsl:call-template name="LoanBalance"/>
          <xsl:call-template name="SpecimenList"/>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="Text">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
		<tr height="50" valign="bottom">
			<td align="right" style="{$FontDefault}">
				<xsl:value-of select="./From/Address/City"/>,
				<xsl:choose>
					<xsl:when test="./BeginDate">
						<xsl:value-of select="./BeginDate"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="./Date"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr height="100" valign="bottom">
        <td align="left" style="{$FontDefault}">
          Wir haben Ihnen vor kurzem das auf Seite 2 spezifizierte Material zugesandt. Zu dieser Sendung fehlt uns bisher eine Empfangsbestätigung.
          Sollten Sie die Sendung erhalten haben, so bitten wir Sie um baldige Zusendung der Empfangsbestätigung. Sollte die Sendung Sie nicht erreicht haben,
          so bitten wir Sie um eine entsprechende Benachrichtigung.
        </td>
      </tr>
      <xsl:if test="./FromTransactionNumber != ''">
        <tr height="50" valign="bottom">
          <td align="left">
            Leihnr.: <xsl:value-of select="./FromTransactionNumber"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="./Investigator != ''">
        <tr height="50" valign="bottom">
          <td align="left">
            Besteller: <xsl:value-of select="./Investigator"/>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td align="left">
          Anzahl der gesandten Belege: <xsl:value-of select="./NumberOfSpecimenInitial"/>
        </td>
      </tr>
      <tr height="50" valign="bottom">
        <td align="left">
          Mit freundlichen Grüßen
        </td>
      </tr>
      <tr height="50" valign="bottom">
        <td align="left">
          Der Kurator
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--xsl:template name="Footer">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontSmall}">
      <tr height="50" valign="bottom">
        <td align="left" colspan="2">
          Re: Determinavit labels, written in permantne ink or typed and signed, should be added to each collection return.
        </td>
      </tr>
      <tr>
        <td align="left" style="padding-bottom:10px; border-bottom:1px dotted #000000" colspan="2">
          Any information which might be of value to furture researchers should be provided.
        </td>
      </tr>
      <tr>
        <td align="left" style="{$FontDefault}" colspan="2">
          Please verify the contents and acknowledge receipt by duplicate form.
        </td>
      </tr>
      <tr>
        <td align="left" style="{$FontDefault}" colspan="2">
          Received the above specimens in good order.
        </td>
      </tr>
      <tr height="50" valign="bottom">
        <td align="left" style="{$FontDefault}">
          Signed ...............................
        </td>
        <td align="right" style="{$FontDefault}">
          Date .................................
        </td>
      </tr>
      <tr height="150" valign="bottom">
        <td align="center" style="{$FontDefault}" colspan="2">
          1
        </td>
      </tr>
    </table>
  </xsl:template-->

  <xsl:template name="LoanBalance">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr>
        <td height="40" valign="bottom" colspan="2">
          <b>
            Leihnr. <xsl:value-of select="./LoanNumber"/>: <xsl:value-of select="./InitialNumberOfSpecimen"/> Beleg(e) [
            <xsl:text> </xsl:text>
            <xsl:call-template name="Balance_DE"/> ]
          </b>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>