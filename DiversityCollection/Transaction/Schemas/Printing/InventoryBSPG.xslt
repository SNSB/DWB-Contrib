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
          <xsl:call-template name="InventoryHeader"/>
          <!--xsl:call-template name="FrontLabel"/>
          <h1 style="page-break-before:left"></h1-->
          <xsl:call-template name="Text"/>
          <h1 style="page-break-before:left"></h1>
          <xsl:call-template name="InventoryListHeader"/>
          <xsl:call-template name="SpecimenNameListWithLocality"/>
          <h1 style="page-break-before:left"></h1>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="InventoryHeader">
    <table cellspacing="0" cellpadding="1" width="630" border="0" style="{$FontDefault}">
      <!--tr>
        <th  width="$PageWidth/4" ></th>
        <th  width="$PageWidth/2" ></th>
        <th  width="$PageWidth/4" ></th>
      </tr-->
      <tr height="30" valign="bottom" rowspan="2">
        <td align="center" style="{$FontBig}" width="40%">
          <b>
            <span style="color:gray"><xsl:value-of select="./To/ToTransactionPartnerAddress/AgentName"/></span>
          </b>
        </td>
        <td width="40%"></td>
        <td align="center" style="{$FontBig}; border-bottom:1px dotted black" width="30%">
            <xsl:value-of select="./To/ToTransactionNumber"/>
        </td>
      </tr>
      <tr height="30" valign="bottom">
        <td></td>
        <td></td>
        <td align="center" style="color:gray">
          zugeteilte Inventar-Nummer"</td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="Text">
    <table cellspacing="0" cellpadding="1" width="630" border="0" style="{$FontBig}">
      <tr>
        <th  width="20%" ></th>
        <th  width="30%" ></th>
        <th  width="50%" ></th>
      </tr>
      <tr height="30" valign="bottom">
        <td align="center" style="color:gray;{$FontBig}" colspan="3">
          <b>
            Vorblatt für Erwerbungen
          </b>
        </td>
      </tr>
      <tr height="30" valign="bottom">
        <td align="left" style="color:gray;{$FontDefault}" colspan="3">
          <b>
            Bezeichnung der Erwerbung
          </b>
        </td>
      </tr>
      <tr >
        <td align="left" style="color:gray;{$FontSmall}" colspan="3">
          Bei  E i n z e l s t ü c k e n  (1 bis etwa 10): Zahl, Name, Körperteil, Schicht, Ort.  - 
          Bei  S a m m l u n g e n  (zahlreiche Stücke): Inhaltsübersicht; Umfang; Angabe ab Bestimmungen die alsbaldige Inventarisierung ermöglichen.
        </td>
      </tr>
      <tr height="30">
        <td></td>
      </tr>
      <tr valign="bottom">
        <td align="left" colspan="3">
            <xsl:value-of select="./MaterialDescription"/>
        </td>
      </tr>
      <tr height="30">
        <td></td>
      </tr>
      <tr valign="bottom">
        <td align="left" colspan="3">
          <xsl:value-of select="./TransactionComment"/>
        </td>
      </tr>
      <tr height="30" valign="bottom">
        <td align="left" style="color:gray;{$FontDefault}" colspan="3">
          <b>
            Art der Erwerbung
          </b>
        </td>
      </tr>
      <tr >
        <td align="left" style="color:gray;{$FontSmall}" colspan="3">
          Dienstliche Aufsammlung von (Name, Vorname, Dienstbezeichung).  - Geschenk ...
          
        </td>
      </tr>
      <tr height="30">
        <td></td>
      </tr>
      <tr >
        <td align="left" style="{$FontBig}" colspan="3">
          <xsl:value-of select="./MaterialCollectors"/>
        </td>
      </tr>
      <tr height="30">
        <td></td>
      </tr>
      <xsl:if test="./BeginDate != ''">
        <tr height="30" valign="bottom">
          <td align="left" style="color:gray;{$FontDefault}">
            Tag der Erwerbung: 
          </td>
          <td align="center" style="{$FontBig}; border-bottom:1px dotted black">
            <xsl:value-of select="./BeginDate"/>
          </td>
        </tr>
        <tr height="30">
          <td></td>
        </tr>
      </xsl:if>
      <tr >
        <td align="left" style="color:gray;{$FontDefault}"  colspan="3">
          <b>Briefwechsel zur Erwerbung</b> <span style="{$FontSmall}">(siehe unter (Name, Vorname)</span>
        </td>
      </tr>
      <tr height="30">
        <td></td>
      </tr>
      <tr >
        <td colspan="2">
        </td>
        <td align="left" style="{$FontDefault}">
          <xsl:value-of select="./Date"/>
        </td>
      </tr>
      <tr >
        <td  colspan="2">
        </td>
        <td align="center" style="color:gray;{$FontDefault}; border-top:1px dotted black"  colspan="3">
          Tag, Unterschrift, Dienstbezeichnung
        </td>
      </tr>
      <tr height="30">
        <td></td>
      </tr>
      <tr >
        <td align="left" style="color:gray;{$FontDefault}; border-top:1px solid gray"  colspan="3">
          <b>Anmerkungen </b>
          <span style="{$FontSmall}"> Kennwort, Aufbewahrungsart, Verluste</span>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="InventoryListHeader">
    <table cellspacing="0" cellpadding="1" width="{$PageWidth}" border="0" style="{$FontBig}">
      <tr height="30" valign="bottom" rowspan="2">
        <td align="center" style="{$FontBig}">
          <b>
          <xsl:value-of select="./To/ToTransactionNumber"/>
          </b>
        </td>
      </tr>
      <tr height="40" valign="bottom">
        <td align="left">
          <xsl:value-of select="./NumberOfSpecimenInitial"/>
          <xsl:text> </xsl:text>Belege
          <xsl:if test="./MaterialDescription != ''">
            -<xsl:text> </xsl:text>
            <xsl:value-of select="./MaterialDescription"/>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="text"></xsl:template>
</xsl:stylesheet>