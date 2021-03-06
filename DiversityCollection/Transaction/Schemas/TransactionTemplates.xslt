<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-16"/>

  <!--Fonts-->
  <xsl:variable name="FontDefault">  font-size: 10pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontUppercase">  font-size:  6pt; font-family: Arial; text-transform:uppercase</xsl:variable>
  <xsl:variable name="FontHeader">    font-size: 14pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontBig">    font-size: 12pt; font-family: Arial</xsl:variable>
  <xsl:variable name="FontSmall">    font-size: 8pt; font-family: Arial</xsl:variable>

  <!--Page format-->
  <xsl:param name="CurrentLine">0</xsl:param>
  <xsl:variable name="PageWidth">630</xsl:variable>
  <xsl:variable name="PageBreak">60</xsl:variable>

  <xsl:template name="Header">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontBig}">
		<tr valign="bottom">
        <td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
          <b>
			  <xsl:choose>
				  <xsl:when test="./From/CollectionOwner/Name">
					<xsl:value-of select="./From/CollectionOwner/Name"/>
				  </xsl:when>
				  <xsl:when test="./Administration/CollectionOwner/Name">
					  <xsl:value-of select="./Administration/CollectionOwner/Name"/>
				  </xsl:when>
				  <xsl:when test="./Administration/CollectionAdministrativeContact/Address/AgentName">
					  <xsl:value-of select="./Administration/CollectionAdministrativeContact/Address/AgentName"/>
				  </xsl:when>
			  </xsl:choose>
          </b>
        </td>
        <td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
          <b>
			  <xsl:choose>
				  <xsl:when test="./From/CollectionOwner/Acronym">
					<xsl:value-of select="./From/CollectionOwner/Acronym"/>
				  </xsl:when>
				  <xsl:when test="./Administration/CollectionOwner/Acronym">
					  <xsl:value-of select="./Administration/CollectionOwner/Acronym"/>
				  </xsl:when>
			  </xsl:choose>
          </b>
        </td>
      </tr>
    </table>
  </xsl:template>

	<xsl:template name="HeaderTPN">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontBig}">
			<tr valign="bottom">
				<td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:choose>
							<xsl:when test="./From/CollectionOwner/Name">
								<xsl:value-of select="./From/CollectionOwner/Name"/>
							</xsl:when>
							<xsl:when test="./FromTransactionPartnerName">
								<xsl:value-of select="./FromTransactionPartnerName"/>
							</xsl:when>
							<xsl:when test="./FromTransactionPartnerAddress/AgentName">
								<xsl:value-of select="./FromTransactionPartnerAddress/AgentName"/>
							</xsl:when>
						</xsl:choose>
					</b>
				</td>
				<td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:choose>
							<xsl:when test="./FromTransactionPartnerAddress/Abbreviation">
								<xsl:value-of select="./FromTransactionPartnerAddress/Abbreviation"/>
							</xsl:when>
							<xsl:when test="./Administration/CollectionOwner/Acronym">
								<xsl:value-of select="./Administration/CollectionOwner/Acronym"/>
							</xsl:when>
						</xsl:choose>
					</b>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="HeaderSpecimenList">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontBig}">
			<tr valign="bottom">
				<td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:choose>
							<xsl:when test="/TransactionList/Transaction/From/CollectionOwner/Name">
								<xsl:value-of select="/TransactionList/Transaction/From/CollectionOwner/Name"/>
							</xsl:when>
							<xsl:when test="/TransactionList/Transaction/Administration/CollectionOwner/Name">
								<xsl:value-of select="/TransactionList/Transaction/Administration/CollectionOwner/Name"/>
							</xsl:when>
							<xsl:when test="/TransactionList/Transaction/Administration/CollectionAdministrativeContact/Address/AgentName">
								<xsl:value-of select="/TransactionList/Transaction/Administration/CollectionAdministrativeContact/Address/AgentName"/>
							</xsl:when>
						</xsl:choose>
					</b>
				</td>
				<td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:choose>
							<xsl:when test="/TransactionList/Transaction/From/CollectionOwner/Acronym">
								<xsl:value-of select="/TransactionList/Transaction/From/CollectionOwner/Acronym"/>
							</xsl:when>
							<xsl:when test="/TransactionList/Transaction/Administration/CollectionOwner/Acronym">
								<xsl:value-of select="/TransactionList/Transaction/Administration/CollectionOwner/Acronym"/>
							</xsl:when>
						</xsl:choose>
					</b>
				</td>
			</tr>
			<tr height ="30" valign="center">
				<td style="{$FontDefault}">
					<b>Loan no. <xsl:value-of select="/TransactionList/Transaction/From/FromTransactionNumber"/></b>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template name="HeaderParent">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
			<tr>
				<td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:value-of select="./Transaction/From/CollectionOwner/Name"/>
					</b>
				</td>
				<td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:value-of select="./Transaction/From/CollectionOwner/Acronym"/>
					</b>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="HeaderTo">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
			<tr>
				<td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:value-of select="./To/CollectionOwner/Name"/>
					</b>
				</td>
				<td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:value-of select="./To/CollectionOwner/Acronym"/>
					</b>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="HeaderAdmin">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
			<tr>
				<td align="left" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:value-of select="./Administration/CollectionOwner/Name"/>
					</b>
				</td>
				<td align="right" style="padding-bottom:10px; border-bottom:1px solid #000000">
					<b>
						<xsl:value-of select="./Administration/CollectionOwner/Acronym"/>
					</b>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="HeaderAddress">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
      <tr height="20" valign="bottom">
        <td align="left" style="{$FontSmall}">
          <xsl:value-of select="./From/Address/Streetaddress"/>
			<xsl:text> </xsl:text>
          <xsl:value-of select="./From/Address/PostalCode"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="./From/Address/City"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="./From/Address/Country"/>
        </td>
        <td align="right" style="{$FontSmall}">
          <xsl:if test="./From/Address/Telephone != ''">
            Phone: <xsl:value-of select="./From/Address/Telephone"/>
          </xsl:if>
        </td>
      </tr>
      <xsl:if test="./From/Address/Telefax != ''">
        <tr>
          <td>
          </td>
          <td align="right" style="{$FontSmall}">
            FAX: <xsl:value-of select="./From/Address/Telefax"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="./From/Address/Email != ''">
        <tr>
          <td>
          </td>
          <td align="right" style="{$FontSmall}">
            E-mail: <xsl:value-of select="./From/Address/Email"/>
          </td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>

	<xsl:template name="HeaderParentAddress">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
			<tr>
				<td align="left" style="{$FontSmall}">
					<xsl:value-of select="./Transaction/From/Address/Streetaddress"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Transaction/From/Address/PostalCode"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Transaction/From/Address/City"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Transaction/From/Address/Country"/>
				</td>
				<td align="right" style="{$FontSmall}">
					<xsl:if test="./Transaction/From/Address/Telephone != ''">
						Phone: <xsl:value-of select="./Transaction/From/Address/Telephone"/>
					</xsl:if>
				</td>
			</tr>
			<xsl:if test="./Transaction/From/Address/Telefax != ''">
				<tr>
					<td>
					</td>
					<td align="right" style="{$FontSmall}">
						FAX: <xsl:value-of select="./Transaction/From/Address/Telefax"/>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="./Transaction/From/Address/Email != ''">
				<tr>
					<td>
					</td>
					<td align="right" style="{$FontSmall}">
						E-mail: <xsl:value-of select="./Transaction/From/Address/Email"/>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>

	<xsl:template name="HeaderAddressTo">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
			<tr>
				<td align="left" style="{$FontSmall}">
					<xsl:value-of select="./To/Address/Streetaddress"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./To/Address/PostalCode"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./To/Address/City"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./To/Address/Country"/>
				</td>
				<td align="right" style="{$FontSmall}">
					<xsl:if test="./To/Address/Telephone != ''">
						Phone: <xsl:value-of select="./To/Address/Telephone"/>
					</xsl:if>
				</td>
			</tr>
			<xsl:if test="./To/Address/Telefax != ''">
				<tr>
					<td>
					</td>
					<td align="right" style="{$FontSmall}">
						FAX: <xsl:value-of select="./To/Address/Telefax"/>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="./To/Address/Email != ''">
				<tr>
					<td>
					</td>
					<td align="right" style="{$FontSmall}">
						E-mail: <xsl:value-of select="./To/Address/Email"/>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>

	<xsl:template name="HeaderAddressAdmin">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontHeader}">
			<tr>
				<td align="left" style="{$FontSmall}">
					<xsl:value-of select="./Administration/CollectionOwner/Address/Streetaddress"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Administration/CollectionOwner/Address/PostalCode"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Administration/CollectionOwner/Address/City"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Administration/CollectionOwner/Address/Country"/>
				</td>
				<td align="right" style="{$FontSmall}">
					<xsl:if test="./Administration/CollectionOwner/Address/Telephone != ''">
						Phone: <xsl:value-of select="./Administration/CollectionOwner/Address/Telephone"/>
					</xsl:if>
				</td>
			</tr>
			<xsl:if test="./Administration/CollectionOwner/Address/Telefax != ''">
				<tr>
					<td>
					</td>
					<td align="right" style="{$FontSmall}">
						FAX: <xsl:value-of select="./Administration/CollectionOwner/Address/Telefax"/>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="./Administration/CollectionOwner/Address/Email != ''">
				<tr>
					<td>
					</td>
					<td align="right" style="{$FontSmall}">
						E-mail: <xsl:value-of select="./Administration/CollectionOwner/Address/Email"/>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>

	<xsl:template name="ReturnAddress">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontSmall}">
      <tr height="60" valign="bottom">
        <td align="left">
			<xsl:choose>
				<xsl:when test="./From/CollectionOwner/Name">
				  <xsl:value-of select="./From/CollectionOwner/Name"/>
				</xsl:when>
				<xsl:when test="./From/Address/AgentName">
					<xsl:value-of select="./From/Address/AgentName"/>
				</xsl:when>
			</xsl:choose>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="./From/Address/Streetaddress"/>
        </td>
      </tr>
      <tr height="30" valign="top">
        <td align="left">
          <xsl:value-of select="./From/Address/PostalCode"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="./From/Address/City"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="./From/Address/Country"/>
        </td>
      </tr>
    </table>
  </xsl:template>

	<xsl:template name="ReturnParentAddress">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontSmall}">
			<tr height="60" valign="bottom">
				<td align="left">
					<xsl:value-of select="./Transaction/From/Address/AgentName"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="./Transaction/From/Address/Streetaddress"/>
				</td>
			</tr>
			<tr height="30" valign="top">
				<td align="left">
					<xsl:value-of select="./Transaction/From/Address/PostalCode"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Transaction/From/Address/City"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./Transaction/From/Address/Country"/>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="ReturnAddressTo">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontSmall}">
			<tr height="60" valign="bottom">
				<td align="left">
					<xsl:value-of select="./To/CollectionOwner/Name"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="./To/Address/Streetaddress"/>
				</td>
			</tr>
			<tr height="30" valign="top">
				<td align="left">
					<xsl:value-of select="./To/Address/PostalCode"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./To/Address/City"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./To/Address/Country"/>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="Address">
	  <xsl:param name="eingabe" select="."/>
	  <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
		  <!--<xsl:if test="./To/ToRecipient != ''">
			  <tr  height="20" valign="bottom">
				  <td>
					  <xsl:value-of select="./To/ToRecipient"/>
				  </td>
			  </tr>
		  </xsl:if>-->
		  <xsl:choose>
			  <xsl:when test="./To/Address/Address != ''">
				  <xsl:if test="./To/ToRecipient != ''">
					  <tr valign="bottom">
						  <td align="left">
							  <xsl:value-of select="./To/ToRecipient"/>
						  </td>
					  </tr>
				  </xsl:if>
				  <tr>
					  <td align="left" valign="top">
						  <xsl:call-template name="Umbruch">
							  <xsl:with-param name="eingabe" select="./To/Address/Address"/>
						  </xsl:call-template>
					  </td>
				  </tr>
			  </xsl:when>
			  <xsl:otherwise>
				  <xsl:if test="./To/ToRecipient != ''">
					  <tr valign="bottom">
						  <td>
							  <xsl:value-of select="./To/ToRecipient"/>
						  </td>
					  </tr>
				  </xsl:if>
				  <xsl:choose>
					  <xsl:when test="./To/Address/AgentName">
						  <tr>
							  <td align="left">
								  <xsl:value-of select="./To/Address/PersonName"/>
							  </td>
						  </tr>
						  <xsl:for-each select="./To/Address/SuperiorAgents/SuperiorAgent">
							  <tr>
								  <td align="left">
									  <xsl:value-of select="./AgentName"/>
								  </td>
							  </tr>
						  </xsl:for-each>
						  <tr>
							  <td align="left">
								  <xsl:call-template name="Umbruch">
									  <xsl:with-param name="eingabe" select="./To/Address/Streetaddress"/>
								  </xsl:call-template>
							  </td>
						  </tr>
						  <tr height="30" valign="bottom">
							  <td align="left">
								  <xsl:if test="./To/Address/Country = 'GERMANY'">
									  D -
								  </xsl:if>
								  <xsl:value-of select="./To/Address/PostalCode"/>
								  <xsl:text> </xsl:text>
								  <xsl:value-of select="./To/Address/City"/>
							  </td>
						  </tr>
						  <xsl:if test="./To/Address/Country != 'GERMANY'">
							  <tr>
								  <td align="left">
									  <xsl:value-of select="./To/Address/Country"/>
								  </td>
							  </tr>
						  </xsl:if>

					  </xsl:when>
					  <xsl:when test = "./To/CollectionOwner/CollectionName != ''">
						  <tr>
							  <td align="left">
								  <xsl:value-of select="./To/CollectionOwner/CollectionName"/>
							  </td>
						  </tr>
					  </xsl:when>
					  <xsl:otherwise>
					  </xsl:otherwise>
				  </xsl:choose>
			  </xsl:otherwise>
		  </xsl:choose>

		  <!--xsl:if test="./To/Address/Address != ''">
        <tr>
          <td align="left">
            <xsl:call-template name="Umbruch">
              <xsl:with-param name="eingabe" select="./To/Address/Address"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:if>
		<xsl:choose>
			<xsl:when test="./To/Address/AgentName">
				
				<tr>
					<td align="left">
						<xsl:value-of select="./To/Address/PersonName"/>
					</td>
				</tr>
				<xsl:for-each select="./To/Address/SuperiorAgents/SuperiorAgent">
					<tr>
						<td align="left">
							<xsl:value-of select="./AgentName"/>
						</td>
					</tr>
				</xsl:for-each>
				<tr>
					<td align="left">
						<xsl:call-template name="Umbruch">
							<xsl:with-param name="eingabe" select="./To/Address/Streetaddress"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr height="30" valign="bottom">
					<td align="left">
						<xsl:if test="./To/Address/Country = 'GERMANY'">
							D -
						</xsl:if>
						<xsl:value-of select="./To/Address/PostalCode"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="./To/Address/City"/>
					</td>
				</tr>
				<xsl:if test="./To/Address/Country != 'GERMANY'">
					<tr>
						<td align="left">
							<xsl:value-of select="./To/Address/Country"/>
						</td>
					</tr>
				</xsl:if>
				
			</xsl:when>
			<xsl:when test = "./To/CollectionOwner/CollectionName != ''">
				<tr>
					<td align="left">
						<xsl:value-of select="./To/CollectionOwner/CollectionName"/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose-->

	</table>
  </xsl:template>

	<xsl:template name="AddressFrom">
		<xsl:param name="eingabe" select="."/>
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<xsl:if test="./From/Address/Address != ''">
				<tr>
					<td align="left">
						<xsl:value-of select="./From/Address/PersonName"/>
					</td>
				</tr>
				<tr>
					<td align="left">
						<xsl:call-template name="Umbruch">
							<xsl:with-param name="eingabe" select="./From/Address/Address"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="./From/Address/Address">
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td align="left">
							<xsl:value-of select="./From/Address/PersonName"/>
						</td>
					</tr>
					<xsl:for-each select="./From/Address/SuperiorAgents/SuperiorAgent">
						<tr>
							<td align="left">
								<xsl:value-of select="./AgentName"/>
							</td>
						</tr>
					</xsl:for-each>
					<tr>
						<td align="left">
							<xsl:call-template name="Umbruch">
								<xsl:with-param name="eingabe" select="./To/Address/Streetaddress"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr height="30" valign="bottom">
						<td align="left">
							<xsl:if test="./From/Address/Country = 'GERMANY'">
								D -
							</xsl:if>
							<xsl:value-of select="./From/Address/PostalCode"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="./From/Address/City"/>
						</td>
					</tr>
					<xsl:if test="./From/Address/Country != 'GERMANY'">
						<tr>
							<td align="left">
								<xsl:value-of select="./From/Address/Country"/>
							</td>
						</tr>
					</xsl:if>

				</xsl:otherwise>
			</xsl:choose>

		</table>
	</xsl:template>

	<xsl:template name="AddressToParent">
		<xsl:param name="eingabe" select="."/>
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<!--xsl:if test="./Transaction/To/Address/Address != ''">
				<tr>
					<td align="left">
						<xsl:value-of select="./Transaction/To/Address/PersonName"/>
					</td>
				</tr>
				<tr>
					<td align="left">
						<xsl:call-template name="Umbruch">
							<xsl:with-param name="eingabe" select="./Transaction/To/Address/Address"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if-->
			<xsl:choose>
				<xsl:when test="./Transaction/To/Address/Address">
					<tr>
						<td align="left">
							<xsl:value-of select="./Transaction/To/ToRecipient"/>
						</td>
					</tr>
					<tr>
						<td align="left">
							<xsl:call-template name="Umbruch">
								<xsl:with-param name="eingabe" select="./Transaction/To/Address/Address"/>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td align="left">
							<xsl:value-of select="./Transaction/To/ToRecipient"/>
						</td>
					</tr>
					<xsl:for-each select="./Transaction/To/Address/SuperiorAgents/SuperiorAgent">
						<tr>
							<td align="left">
								<xsl:value-of select="./AgentName"/>
							</td>
						</tr>
					</xsl:for-each>
					<tr>
						<td align="left">
							<xsl:call-template name="Umbruch">
								<xsl:with-param name="eingabe" select="./Transaction/To/Address/Streetaddress"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr height="30" valign="bottom">
						<td align="left">
							<xsl:if test="./Transaction/To/Address/Country = 'GERMANY'">
								D -
							</xsl:if>
							<xsl:value-of select="./From/Address/PostalCode"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="./Transaction/To/Address/City"/>
						</td>
					</tr>
					<xsl:if test="./Transaction/To/Address/Country != 'GERMANY'">
						<tr>
							<td align="left">
								<xsl:value-of select="./Transaction/To/Address/Country"/>
							</td>
						</tr>
					</xsl:if>

				</xsl:otherwise>
			</xsl:choose>

		</table>
	</xsl:template>

	<xsl:template name="Address_2">
    <xsl:param name="eingabe" select="."/>
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <xsl:if test="./To/Address/Address != ''">
        <tr>
          <td align="left">
            <xsl:value-of select="./To/Address/PersonName"/>
          </td>
        </tr>
        <tr>
          <td align="left">
            <xsl:call-template name="Umbruch">
              <xsl:with-param name="eingabe" select="./To/Address/Address"/>
            </xsl:call-template>
          </td>
        </tr>
        <xsl:if test="./To/Address/Country != 'GERMANY'">
          <tr>
            <td align="left">
              <xsl:value-of select="./To/Address/Country"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="./To/Address/Address">

        </xsl:when>
        <xsl:otherwise>
          <tr>
            <td align="left">
              <xsl:value-of select="./To/Address/PersonName"/>
            </td>
          </tr>
          <xsl:for-each select="./To/Address/SuperiorAgents/SuperiorAgent">
            <tr>
              <td align="left">
                <xsl:value-of select="./AgentName"/>
              </td>
            </tr>
          </xsl:for-each>
          <tr>
            <td align="left">
              <xsl:call-template name="Umbruch">
                <xsl:with-param name="eingabe" select="./To/Address/Streetaddress"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr height="30" valign="bottom">
            <td align="left">
              <xsl:if test="./To/Address/Country = 'GERMANY'">
                D -
              </xsl:if>
              <xsl:value-of select="./To/Address/PostalCode"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="./To/Address/City"/>
            </td>
          </tr>
          <xsl:if test="./To/Address/Country != 'GERMANY'">
            <tr>
              <td align="left">
                <xsl:value-of select="./To/Address/Country"/>
              </td>
            </tr>
          </xsl:if>

        </xsl:otherwise>
      </xsl:choose>

    </table>
  </xsl:template>

  <xsl:template name="AddressInstitution">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <xsl:if test="./To/ToTransactionPartnerAddress/Address != ''">
        <tr>
          <td align="left">
            <xsl:value-of select="./To/ToTransactionPartnerAddress/Address"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="./To/ToTransactionPartnerAddress/Address = ''">
        <tr>
          <td align="left">
            <xsl:value-of select="./To/ToTransactionPartnerName"/>
          </td>
        </tr>
        <!--xsl:for-each select="./To/ToTransactionPartnerAddress/SuperiorAgents/SuperiorAgent">
          <tr>
            <td align="left">
              <xsl:value-of select="./AgentName"/>
            </td>
          </tr>
        </xsl:for-each-->
        <tr>
          <td align="left">
            <xsl:value-of select="./To/Address/Streetaddress"/>
          </td>
        </tr>
        <tr height="30" valign="bottom">
          <td align="left">
            <xsl:if test="./To/Address/Country = 'GERMANY'">
              D -
            </xsl:if>
            <xsl:value-of select="./To/Address/PostalCode"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="./To/Address/City"/>
          </td>
        </tr>
        <xsl:if test="./To/Address/Country != 'GERMANY'">
          <tr>
            <td align="left">
              <xsl:value-of select="./To/Address/Country"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
    </table>
  </xsl:template>

  <xsl:template name="AddressToInstitution">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <xsl:if test="./To/Address/AgentName != ''">
        <tr>
          <td align="left">
            <xsl:value-of select="./To/Address/AgentName"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="./To/Address/Address = ''">
        <tr>
          <td align="left">
            <xsl:value-of select="./To/ToTransactionPartnerName"/>
          </td>
        </tr>
        <!--xsl:for-each select="./To/ToTransactionPartnerAddress/SuperiorAgents/SuperiorAgent">
          <tr>
            <td align="left">
              <xsl:value-of select="./AgentName"/>
            </td>
          </tr>
        </xsl:for-each-->
        <tr>
          <td align="left">
            <xsl:value-of select="./To/Address/Streetaddress"/>
          </td>
        </tr>
        <tr height="30" valign="bottom">
          <td align="left">
            <xsl:if test="./To/Address/Country = 'GERMANY'">
              D -
            </xsl:if>
            <xsl:value-of select="./To/Address/PostalCode"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="./To/Address/City"/>
          </td>
        </tr>
        <xsl:if test="./To/Address/Country != 'GERMANY'">
          <tr>
            <td align="left">
              <xsl:value-of select="./To/Address/Country"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
    </table>
  </xsl:template>

	<xsl:template name="Umbruch">
		<xsl:param name="eingabe" select="."/>
		<xsl:choose>
			<xsl:when test="contains($eingabe, '&#xA;')">
				<xsl:value-of select="substring-before($eingabe, '&#xA;')"/>
				<br/>
				<xsl:call-template name="Umbruch">
					<xsl:with-param name="eingabe" select="substring-after($eingabe,'&#xA;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$eingabe"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="SpecimenList">
		<!--<table cellspacing="0" cellpadding="0" width="{$PageWidth}" border="0" style="{$FontDefault}">-->
			<xsl:for-each select="./SpecimenParts/MaterialCategories/MaterialCategory">
				<!--tr>
          <td height="40" valign="bottom">
            <b>
              <xsl:value-of select="./Material"/>
            </b>
          </td>
        </tr-->
		<xsl:for-each select="./Specimens/Specimen">
			<table cellspacing="0" cellpadding="0" width="{$PageWidth}" border="0" style="{$FontDefault}">
				<xsl:choose>
					<xsl:when test="./TypeIdentification">
						<tr>
							<td width ="130">
								<xsl:value-of select="./AccessionNumber"/>
							</td>
							<td>
								<xsl:value-of select="./Identification"/>
							</td>
						</tr>
						<tr>
							<td width ="130">
							</td>
							<td>
								<xsl:value-of select="./TypeIdentification"/>, <b><xsl:value-of select="./TypeStatus"/></b>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td width ="130">
								<xsl:value-of select="./AccessionNumber"/>
							</td>
							<td>
								<xsl:value-of select="./Identification"/>
								<xsl:if test="./TypeStatus">, <b><xsl:value-of select="./TypeStatus"/></b>
								</xsl:if>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</table>
			<xsl:if test="./Counter mod $PageBreak = 0">
				<div align="center" style="{$FontSmall}">
					<br/>
					<xsl:value-of select="./Counter div $PageBreak + 1"/>
				</div>
				<h1 style="page-break-before:left"></h1>
				<xsl:call-template name="HeaderSpecimenList"/>
			</xsl:if>
			<xsl:if test="position()=last()">
				<!--<xsl:variable name="Abstand">
					<xsl:value-of select="($PageBreak - (./Counter mod $PageBreak)) * 10"/></xsl:variable>
				$Abstand
				<xsl:value-of select="$Abstand"/>-->
				<br/>
				<table align="center" style="{$FontSmall}" height="($PageBreak - (./Counter mod $PageBreak)) * 10">
					<tr valign="bottom" height="($PageBreak - (./Counter mod $PageBreak)) * 10">
						<td align ="center">
							<xsl:value-of select="ceiling(./Counter div $PageBreak) + 1"/>
						</td>
					</tr>
					<!--<tr valign="bottom">
						<td align ="center">
							<xsl:value-of select="($PageBreak - (./Counter mod $PageBreak)) * 10"/>
						</td>
					</tr>-->
				</table>
				<!--<table align="center" style="{$FontSmall}" height="(./Counter mod $PageBreak) * 10">
					<tr valign="bottom">
						<td align ="center">
							<xsl:value-of select="ceiling(./Counter div $PageBreak) + 1"/>
						</td>
					</tr>
				</table>-->
			</xsl:if>
		</xsl:for-each>
      </xsl:for-each>
    <!--</table>-->
    <!--<xsl:if test="./Specimens/Specimen/Counter mod $PageBreak = 0">
      <div align="center" style="{$FontDefault}">
        <xsl:value-of select="./Counter div $PageBreak + 1"/>
      </div>
      <h1 style="page-break-before:left"></h1>
      <xsl:call-template name="Header"/>
    </xsl:if>-->
  </xsl:template>

	<xsl:template name="SpecimenListTaxa">
		<xsl:for-each select="./SpecimenParts/MaterialCategories/MaterialCategory">
			<p style="{$FontDefault}"><xsl:value-of select="./Material"/></p>
			<xsl:for-each select="./Specimens/Specimen">
				<table cellspacing="0" cellpadding="2" width="{$PageWidth}" border="0" style="{$FontDefault}">
					<xsl:choose>
						<xsl:when test="./TypeIdentification">
							<tr>
								<td width ="230">
									<xsl:value-of select="./AccessionNumber"/>
								</td>
								<td valign="top">
									<xsl:value-of select="./Identification"/>
								</td>
								<td valign="top" align="right">
									<xsl:value-of select="./Number"/>
								</td>
							</tr>
							<tr>
								<td width ="230">
								</td>
								<td>
									<xsl:value-of select="./TypeIdentification"/>, <b>
										<xsl:value-of select="./TypeStatus"/>
									</b>
								</td>
								<td></td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td width ="230">
									<xsl:value-of select="./AccessionNumber"/>
								</td>
								<td valign="top">
									<xsl:value-of select="./Identification"/>
									<xsl:if test="./TypeStatus">
										, <b>
											<xsl:value-of select="./TypeStatus"/>
										</b>
									</xsl:if>
								</td>
								<td valign="top" align="right">
									<xsl:value-of select="./Number"/>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</table>
				<xsl:if test="./Counter mod $PageBreak = 0">
					<h1 style="page-break-before:left"></h1>
					<xsl:call-template name="HeaderSpecimenList"/>
				</xsl:if>
				
				<!--<xsl:if test="./Counter mod $PageBreak = 0">
					<div align="center" style="{$FontSmall}">
						<br/>
						<xsl:value-of select="./Counter div $PageBreak + 1"/>
					</div>
					<h1 style="page-break-before:left"></h1>
					<xsl:call-template name="HeaderSpecimenList"/>
				</xsl:if>
				<xsl:if test="position()=last()">
					<br/>
					<table align="center" style="{$FontSmall}" height="($PageBreak - (./Counter mod $PageBreak)) * 10">
						<tr valign="bottom" height="($PageBreak - (./Counter mod $PageBreak)) * 10">
							<td align ="center">
								<xsl:value-of select="ceiling(./Counter div $PageBreak) + 1"/>
							</td>
						</tr>
					</table>
				</xsl:if>-->
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="SpecimenListInventory">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<xsl:for-each select="./SpecimenParts/MaterialCategories/MaterialCategory">
				<xsl:for-each select="./Specimens/Specimen">
					<tr>
						<td>
							<xsl:value-of select="./AccessionNumber"/>
						</td>
						<td>
							<xsl:if test="./TransactionAccessionNumber">
								[<xsl:value-of select="./TransactionAccessionNumber"/>]
							</xsl:if>
						</td>
						<td>
							<xsl:value-of select="./Identification"/>
						</td>
					</tr>
					<xsl:if test="./TypeOf != ''">
						<tr>
							<td align="center" colspan ="3">
								<xsl:value-of select="./TypeOf"/>
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</table>
		<xsl:if test="./Counter mod $PageBreak = 0">
			<div align="center" style="{$FontDefault}">
				<xsl:value-of select="./Counter div $PageBreak + 1"/>
			</div>
			<h1 style="page-break-before:left"></h1>
			<xsl:call-template name="Header"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="SpecimenListParent">
		<table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
			<xsl:for-each select="./Transaction/SpecimenParts/MaterialCategories/MaterialCategory">
				<xsl:for-each select="./Specimens/Specimen">
					<tr>
						<td>
							<xsl:value-of select="./AccessionNumber"/>
						</td>
						<td>
							<xsl:value-of select="./Identification"/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
		</table>
		<xsl:if test="./Counter mod $PageBreak = 0">
			<div align="center" style="{$FontDefault}">
				<xsl:value-of select="./Counter div $PageBreak + 1"/>
			</div>
			<h1 style="page-break-before:left"></h1>
			<xsl:call-template name="HeaderParent"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="SpecimenNameList">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="40">
        <td> </td>
      </tr>
      <xsl:for-each select="./SpecimenParts/MaterialCategories/MaterialCategory/Specimens/Specimen">
        <tr>
            <td>
              <xsl:value-of select="./Identification"/>
            </td>
            <td>
              <xsl:value-of select="./AccessionNumber"/>
            </td>
          </tr>
          <xsl:if test="./Counter mod $PageBreak = 0">
            <!--div align="center" style="{$FontDefault}">
              <xsl:value-of select="./Counter div $PageBreak + 1"/>
            </div-->
            <h1 style="page-break-before:left"></h1>
            <!--xsl:call-template name="Header"/-->
          </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="SpecimenNameListWithType">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="40">
        <td> </td>
      </tr>
      <xsl:for-each select="./SpecimenParts/MaterialCategories/MaterialCategory/Specimens/Specimen">
        <tr>
          <td>
            <xsl:value-of select="./Identification"/>
          </td>
          <td>
            <xsl:value-of select="./AccessionNumber"/>
          </td>
        </tr>
        <xsl:if test="./TypeOf != ''">
          <tr>
            <td align="center">
              <xsl:value-of select="./TypeOf"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./Counter mod $PageBreak = 0">
          <!--div align="center" style="{$FontDefault}">
              <xsl:value-of select="./Counter div $PageBreak + 1"/>
            </div-->
          <h1 style="page-break-before:left"></h1>
          <!--xsl:call-template name="Header"/-->
        </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="SpecimenNameListWithLocality">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontDefault}">
      <tr height="40">
        <td> </td>
      </tr>
      <xsl:for-each select="./SpecimenParts/MaterialCategories/MaterialCategory/Specimens/Specimen">
        <tr>
          <td>
            <xsl:value-of select="./AccessionNumber"/>
            <!--xsl:value-of select="./Counter"/-->
          </td>
          <td>
            <xsl:value-of select="./Identification"/>
            <xsl:if test="./LocalityDescription != ''">
              <xsl:text>, </xsl:text>
                  <xsl:value-of select="./LocalityDescription"/>
            </xsl:if>
          </td>
        </tr>
        <xsl:if test="./Counter mod $PageBreak = 0">
          <!--div align="center" style="{$FontDefault}">
              <xsl:value-of select="./Counter div $PageBreak + 1"/>
            </div-->
          <h1 style="page-break-before:left"></h1>
          <!--xsl:call-template name="Header"/-->
        </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="Balance">
      <xsl:for-each select="./TaxonomicGroups/TaxonomicGroup">
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
  </xsl:template>

	<xsl:template name="BalanceParent">
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
	</xsl:template>

	<xsl:template name="TaxonomicGroups">
    <xsl:for-each select="./TaxonomicGroups/TaxonomicGroup">
      <xsl:if test="position() = last() and position() != 1">
        <xsl:text> and </xsl:text>
      </xsl:if>
      <xsl:if test="position() != last() and position() != 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
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
  </xsl:template>

  <xsl:template name="Balance_DE">
    <xsl:for-each select="./TaxonomicGroups/TaxonomicGroup">
      <xsl:if test="position() = last() and position() != 1">
        <xsl:text> und </xsl:text>
      </xsl:if>
      <xsl:if test="position() != last() and position() != 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="./NumberOfSpecimen"/>
      <xsl:text> </xsl:text>
      <xsl:choose>
        <xsl:when test="./Group = 'plant'">
          <xsl:if test="./NumberOfSpecimen = 1">
            Pflanze
          </xsl:if>
          <xsl:if test="./NumberOfSpecimen != 1">
            Pflanzen
          </xsl:if>
        </xsl:when>
        <xsl:when test="./Group = 'fungus'">
          <xsl:if test="./NumberOfSpecimen = 1">
            Pilz
          </xsl:if>
          <xsl:if test="./NumberOfSpecimen != 1">
            Pilze
          </xsl:if>
        </xsl:when>
        <xsl:when test="./Group = 'lichen'">
          <xsl:if test="./NumberOfSpecimen = 1">
            Flechte
          </xsl:if>
          <xsl:if test="./NumberOfSpecimen != 1">
            Flechten
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="./NumberOfSpecimen = 1">
            <xsl:value-of select="./Group"/>
          </xsl:if>
          <xsl:if test="./NumberOfSpecimen != 1">
            <xsl:value-of select="./Group"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="TransactionType_DE">
    <xsl:if test="./TransactionType != ''">
      <xsl:if test="./TransactionType = 'gift'">Geschenk</xsl:if>
      <xsl:if test="./TransactionType = 'exchange'">Tausch</xsl:if>
      <xsl:if test="./TransactionType = 'purchase'">Kauf</xsl:if>
      <xsl:if test="./TransactionType = 'loan'">Leihe</xsl:if>
      <xsl:if test="./TransactionType = 'inventory'">Inventarliste</xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Footer">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontSmall}">
      <tr height="50" valign="bottom">
        <td align="left" colspan="2">
          Re: Determinavit labels, written in permanent ink or typed and signed, should be added to each collection return.
        </td>
      </tr>
      <tr>
        <td align="left" style="padding-bottom:10px; border-bottom:1px dotted #000000" colspan="2">
          Any information which might be of value to future researchers should be provided.
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
	<!--tr height="150" valign="bottom">
        <td align="center" style="{$FontDefault}" colspan="2">
          1
        </td>
      </tr-->
    </table>
  </xsl:template>

  <xsl:template name="Footer_DE">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontSmall}">
      <tr height="50" valign="bottom">
        <td align="left" colspan="2">
          Re: Determinavit Label, geschrieben mit permanter Tinte oder Maschine und unterschrieben, sollten jeder zurückgeschickten Sammlung beigelegt werden.
        </td>
      </tr>
      <tr>
        <td align="left" style="padding-bottom:10px; border-bottom:1px dotted #000000" colspan="2">
          Jegliche Information, die zukünftigen Forschern nützlich sein kann sollte hinzugefügt werden.
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
          Unterschrift ...............................
        </td>
        <td align="right" style="{$FontDefault}">
          Datum .................................
        </td>
      </tr>
	  <!--tr height="150" valign="bottom">
        <td align="center" style="{$FontDefault}" colspan="2">
          1
        </td>
      </tr-->
    </table>
  </xsl:template>


	<xsl:template match="text"></xsl:template>

</xsl:stylesheet>