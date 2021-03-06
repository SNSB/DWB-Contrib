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
			<!--<xsl:call-template name="Header"/>>
			<xsl:call-template name="HeaderParent"/-->
			
			<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
				<tr>
					<td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
						<b>
							<xsl:value-of select="./Transaction/Administration/CollectionOwner/Name"/>
						</b>
					</td>
					<td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
						<b>
							<xsl:value-of select="./Transaction/Administration/CollectionOwner/Acronym"/>
						</b>
					</td>
				</tr>
			</table>

			<!--xsl:call-template name="HeaderReturn"/-->
          <xsl:call-template name="HeaderParentAddress"/>
		  <xsl:call-template name="ReturnParentAddress"/>
			<br/>
          <xsl:call-template name="Address"/>
          <xsl:call-template name="Text"/>
			<!--xsl:call-template name="Footer"/>
			<div align="center" style="{$FontSmall}">
				<br/>
				1
			</div-->
			<h1 style="page-break-before:left"></h1>
			<xsl:call-template name="HeaderSpecimenList"/>
			<xsl:call-template name="SpecimenList"/>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

	<!--xsl:template name="HeaderReturn">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
			<tr>
				<td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:choose>
							<xsl:when test="./From/CollectionOwner/Name != ''">
								<xsl:value-of select="./From/CollectionOwner/Name"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="./Administration/CollectionOwner/Name"/>
							</xsl:otherwise>
						</xsl:choose>
					</b>
				</td>
				<td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:choose>
							<xsl:when test="./From/CollectionOwner/Acronym != ''">
								<xsl:value-of select="./From/CollectionOwner/Acronym"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="./Administration/CollectionOwner/Acronym"/>
							</xsl:otherwise>
						</xsl:choose>
					</b>
				</td>
			</tr>
		</table>
	</xsl:template-->

	<xsl:template name="Text">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height ="0">
        <th width="130" ></th>
        <th width="500"></th>
      </tr>
		<!--tr height="50" valign="bottom">
        <td align="right" style="{$FontDefault}" colspan="2">
          <xsl:value-of select="./From/Collection/CollectionAddress/City"/>, <xsl:value-of select="./Date"/>
        </td>
      </tr-->
		<tr height="50" valign="bottom">
			<td align="right" colspan="2" style="{$FontDefault}">
				<xsl:value-of select="./Transaction/From/Address/City"/>,
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

		<tr height="110" valign="center">
			<td align="left" style="{$FontDefault}" colspan="2">
				<b>Acknowledgement for <xsl:choose>
					<xsl:when test="./Transaction/NumberOfSpecimenOnLoan > 0">
						partial
					</xsl:when>
					<xsl:otherwise>
						complete
					</xsl:otherwise>
				</xsl:choose> return</b>
			</td>
		</tr>
		<tr height="70" valign="bottom">
        <td align="left" style="{$FontDefault}" colspan="2">
			The
			<xsl:choose>
				<xsl:when test="./Transaction/From/Collection/CollectionOwner != ''">
					<xsl:value-of select="./Transaction/From/Collection/CollectionOwner"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./Transaction/Administration/CollectionOwner/Name"/>
				</xsl:otherwise>
			</xsl:choose>
			is acknowledging herewith the return 
			<xsl:choose>
				<xsl:when test="./Transaction/NumberOfSpecimenOnLoan > 0">
					(partial
				</xsl:when>
				<xsl:otherwise>
					(complete
				</xsl:otherwise>
			</xsl:choose>
			 return)
			of the herbarium specimen(s) (
			<xsl:for-each select="./Transaction/TaxonomicGroups/TaxonomicGroup">
            <xsl:if test="position() = last() and position() != 1">
              <xsl:text> and </xsl:text>
            </xsl:if>
            <xsl:if test="position() != last() and position() != 1">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="./NumberOfSpecimen"/>
				<xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="./Group = 'plant'">
                <xsl:if test="./NumberOfSpecimen = 1">
                  vascular plant
                </xsl:if>
                <xsl:if test="./NumberOfSpecimen != 1">
                  vascular plants
                </xsl:if>
              </xsl:when>
              <xsl:when test="./Group = 'fungus'">
                <xsl:if test="./NumberOfSpecimen = 1">
                  fungus
                </xsl:if>
                <xsl:if test="./NumberOfSpecimen != 1">
                  fungi
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="./NumberOfSpecimen = 1">
                  <xsl:value-of select="./Group"/>
                </xsl:if>
                <xsl:if test="./NumberOfSpecimen != 1">
                  <xsl:value-of select="./Group"/>s
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          ) sent on loan to your institution.
        </td>
      </tr>
      <xsl:if test="./Transaction/From/FromTransactionNumber != ''">
        <tr height="50" valign="bottom" colspan="2">
          <td align="left">
            Loan no. <xsl:value-of select="./Transaction/From/FromTransactionNumber"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="./Transaction/Investigator != ''">
        <tr height="50" valign="bottom">
          <td align="left" colspan="2">
            For study by: <xsl:value-of select="./Transaction/Investigator"/>
          </td>
        </tr>
      </xsl:if>
      <tr height="30">
        <td align="left" colspan="2">
          Number of specimens returned:
        </td>
      </tr>
      <tr>
        <td></td>
        <td align="left">
          <xsl:value-of select="./Transaction/NumberOfSpecimenReturned"/> as a total
        </td>
      </tr>
      <tr>
        <td></td>
        <td align="left">
          <xsl:value-of select="./NumberOfSpecimenReturnedNow"/> by latest partial shipment
        </td>
      </tr>
		<xsl:if test="./Transaction/NumberOfSpecimenOnLoan > 0">
		<tr height="30" valign="bottom">
			<td align="left" colspan="2">
				Number of still outstanding specimens: <xsl:value-of select="./Transaction/NumberOfSpecimenOnLoan"/>
			</td>
		</tr>
		</xsl:if>
		<tr>
        <td align="left" colspan="2">
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
      <tr height="70" valign="bottom">
        <td align="left">
			The Curator
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

  <xsl:template name="ReturnBalance">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr>
        <td height="40" valign="bottom" colspan="2">
          <b>
            Loan no. <xsl:value-of select="./Transaction/From/FromTransactionNumber"/>: <xsl:value-of select="./NumberOfSpecimenReturnedNow"/> specimen(s) [
            <xsl:text> </xsl:text>
            <xsl:call-template name="Balance"/> ]
          </b>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>