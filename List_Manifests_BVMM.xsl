<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:http="http://www.w3.org/1999/xhtml">
  <!--  Stefanie Gehrke pour Biblissima avril 2015 et octobre 2016 -->
    <xsl:template match="/">
        <xsl:variable name="output_dir">./</xsl:variable> 
        <xsl:variable name="outputDate"><xsl:value-of select="current-date()"/></xsl:variable>
        <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"/>Manifests_Prototype_BVMM<xsl:value-of select="substring-before($outputDate,'+')"/>.csv</xsl:variable>
        <xsl:result-document href="{$outputFile}" method="text" encoding="UTF-8" indent="no">
<xsl:text>shelfmark1@shelfmark2@manifest@thumbnail@dimensions@URL_digitalSurrogates@URL_Record_Medium
</xsl:text>
        <xsl:for-each select=".//input">
            <xsl:variable name="firstLink"><xsl:value-of select="@value"/></xsl:variable>
             
            <xsl:variable name="manifest"><xsl:value-of select="unparsed-text($firstLink)"/></xsl:variable>
            <xsl:variable name="shelfmark1">
                <xsl:value-of select="substring-before(substring-after($manifest,'Cote&quot;,&quot;value&quot;:&quot;'),'&quot;')"/>
            </xsl:variable>
            <xsl:variable name="shelfmark2">
                <xsl:value-of select="substring-before(substring-after($manifest,'Cote&quot;,&quot;value&quot;:&quot;'),'&quot;')"/>
            </xsl:variable>
            <xsl:variable name="dimensions">
                <xsl:value-of select="substring-before(substring-after($manifest,'Dimensions (mm)&quot;,&quot;value&quot;:&quot;'),'&quot;')"/><xsl:text> mm</xsl:text>
            </xsl:variable>
            <xsl:variable name="URL_digitalSurrogates">
                <xsl:value-of select="substring-before(substring-after($manifest,'Source images&quot;,&quot;value&quot;:&quot;'),'&quot;')"/>
            </xsl:variable>
            <xsl:variable name="thumbnail">
                <xsl:value-of select="substring-before(substring-after($manifest,'thumbnail&quot;:{&quot;@id&quot;:&quot;'),'&quot;,&quot;service&quot;')"/>
            </xsl:variable>
            <xsl:variable name="URL_Record_Medium">
                <xsl:value-of select="substring-before(substring-after($manifest,'Source métadonnées&quot;,&quot;value&quot;:&quot;'),'&quot;}],&quot;license&quot;')"/>
            </xsl:variable>
            <xsl:value-of select="$shelfmark1"/>@<xsl:value-of select="$shelfmark2"/>@<xsl:value-of select="$firstLink"/>@<xsl:value-of select="$thumbnail"></xsl:value-of>@<xsl:value-of select="$dimensions"/>@<xsl:value-of select="$URL_digitalSurrogates"/>@<xsl:value-of select="$URL_Record_Medium"/><xsl:text>
</xsl:text></xsl:for-each>
        </xsl:result-document>  
    </xsl:template>
    
</xsl:stylesheet>