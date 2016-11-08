<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:http="http://www.w3.org/1999/xhtml">
    <!--  Stefanie Gehrke pour Biblissima avril 2015 et octobre 2016 -->
    <xsl:template match="/">
        <xsl:variable name="output_dir">./</xsl:variable>
        <xsl:variable name="outputDate">
            <xsl:value-of select="current-date()"/>
        </xsl:variable>
        <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"
                />ExportBdC2_BVMM<xsl:value-of select="substring-before($outputDate, '+')"
            />.xml</xsl:variable>
        <xsl:result-document href="{$outputFile}" method="xml" encoding="UTF-8" indent="yes">
            <xsl:for-each select=".//input">
                <xsl:variable name="firstLink">
                    <xsl:value-of select="@value"/>
                </xsl:variable>

                <xsl:variable name="manifest">
                    <xsl:value-of select="unparsed-text($firstLink)"/>
                </xsl:variable>
                <xsl:variable name="shelfmark">
                    <xsl:value-of
                        select="substring-before(substring-after($manifest, 'Cote&quot;,&quot;value&quot;:&quot;'), '&quot;')"
                    />
                </xsl:variable>
                <xsl:variable name="dimensions">
                    <xsl:value-of
                        select="substring-before(substring-after($manifest, 'Dimensions (mm)&quot;,&quot;value&quot;:&quot;'), '&quot;')"/>
                    <xsl:text> mm</xsl:text>
                </xsl:variable>
                <xsl:variable name="foliotation">
                    <xsl:value-of
                        select="substring-before(substring-after($manifest, 'Foliotation&quot;,&quot;value&quot;:&quot;'), '&quot;')"/>
                </xsl:variable>
                <xsl:variable name="URL_digitalSurrogates">
                    <xsl:value-of
                        select="substring-before(substring-after($manifest, 'Source images&quot;,&quot;value&quot;:&quot;'), '&quot;')"
                    />
                </xsl:variable>
                <xsl:variable name="thumbnail">
                    <xsl:value-of
                        select="substring-before(substring-after($manifest, 'thumbnail&quot;:{&quot;@id&quot;:&quot;'), '&quot;,&quot;service&quot;')"
                    />
                </xsl:variable>
                <xsl:variable name="URL_Record_Medium">
                    <xsl:value-of
                        select="substring-before(substring-after($manifest, 'Source métadonnées&quot;,&quot;value&quot;:&quot;'), '&quot;}],&quot;license&quot;')"
                    />
                </xsl:variable>
                <RecordList>
                    <DataBase uri="http://bvmm.irht.cnrs.fr/">BVMM</DataBase>
                    <Book>
                        <xsl:attribute name="id">
                            <xsl:value-of select="$URL_Record_Medium"/>
                        </xsl:attribute>
                        <Shelfmark>
                            <xsl:value-of select="$shelfmark"/>
                        </Shelfmark>
                        <Concept>
                            <xsl:value-of select="$URL_Record_Medium"/>
                        </Concept>
                        <DigitalSurrogate>
                            <xsl:value-of select="$URL_digitalSurrogates"/>
                        </DigitalSurrogate>
                        <Manifest>
                            <xsl:value-of select="$firstLink"/>
                        </Manifest>
                        <Thumbnail>
                            <xsl:value-of select="$thumbnail"/>
                        </Thumbnail>
                        <Dimensions>
                            <xsl:value-of select="$dimensions"/>
                        </Dimensions>
                        <Extent><xsl:value-of select="$foliotation"/></Extent>
                        <Record>
                            <xsl:value-of select="$URL_Record_Medium"/>
                        </Record>
                    </Book>
                </RecordList>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
