<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
    xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
    xmlns:math="http://www.w3.org/1998/Math/MathML"
    xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
    xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
    xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer"
    xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events"
    xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:rpt="http://openoffice.org/2005/report"
    xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:grddl="http://www.w3.org/2003/g/data-view#"
    xmlns:tableooo="http://openoffice.org/2009/table"
    xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0"
    office:version="1.2">
    
    <!-- Stefanie Gehrke, Biblissima, 2014-10-22 / 2015-05-13 -->
    <!-- convert data from Open Document Format Spreadsheet (“content.xml”) to csv using a webservice called “pagination” racine : http://gallica.bnf.fr/services/Pagination?ark=  -->
    
    
    <xsl:output encoding="UTF-8" method="text" indent="yes"></xsl:output>
    <xsl:param name="rowOfHeader">1</xsl:param>    
    <xsl:param name="columnOfARKGallica">
        <xsl:for-each select="//table:table-row[position() = $rowOfHeader]/table:table-cell">
            <xsl:if test="text:p = 'ARK_Gallica'">
                <!-- get the repeated entries minus their occurance, that is the column offset you need to add -->
                <xsl:variable name="offset">
                    <xsl:value-of select="sum(preceding-sibling::table:table-cell[@table:number-columns-repeated]/@table:number-columns-repeated)-count(preceding-sibling::table:table-cell[@table:number-columns-repeated]/@table:number-columns-repeated)"/>                    
                </xsl:variable>
                <xsl:value-of select="position()+$offset"/></xsl:if>
        </xsl:for-each>
    </xsl:param>
    
    <xsl:param name="columnOfFolioEnluminure">
        <xsl:for-each select="//table:table-row[position() = $rowOfHeader]/table:table-cell">
            <xsl:if test="text:p = 'folio_enluminure'">                
                <!-- get the repeated entries minus their occurance, that is the column offset you need to add -->
                <xsl:variable name="offset">
                    <xsl:value-of select="sum(preceding-sibling::table:table-cell[@table:number-columns-repeated]/@table:number-columns-repeated)-count(preceding-sibling::table:table-cell[@table:number-columns-repeated]/@table:number-columns-repeated)"/>                    
                </xsl:variable>
                <xsl:value-of select="position()+$offset"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:param>
    
    <xsl:template match="/">
        
        <xsl:for-each select="//table:table-row">
            <xsl:if test="position() &gt; $rowOfHeader and .//text:p">
                
                <xsl:variable name="thisColumnOfARKGallica">
                    <xsl:for-each select="table:table-cell">
                        <!-- get the repeated entries minus their occurance, that is the column offset you need to add -->
                        <xsl:variable name="offset">
                            <xsl:value-of select="sum(preceding-sibling::table:table-cell[@table:number-columns-repeated]/@table:number-columns-repeated)-count(preceding-sibling::table:table-cell[@table:number-columns-repeated]/@table:number-columns-repeated)"/>                    
                        </xsl:variable>
                        <xsl:if test="position()+$offset = $columnOfARKGallica">
                            <xsl:value-of select="position()"/>
                        </xsl:if>                           
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="thisARKGallica"><xsl:value-of select="table:table-cell[position() = $thisColumnOfARKGallica]/text:p"/></xsl:variable>
                
                <xsl:variable name="thisColumnOfFolioEnluminure">
                    <xsl:for-each select="table:table-cell">
                        <!-- get the repeated entries minus their occurance, that is the column offset you need to add -->
                        <xsl:variable name="offset">
                            <xsl:value-of select="sum(preceding-sibling::table:table-cell[@table:number-columns-repeated]/@table:number-columns-repeated)-count(preceding-sibling::table:table-cell[@table:number-columns-repeated]/@table:number-columns-repeated)"/>                    
                        </xsl:variable>
                        <xsl:if test="position()+$offset = $columnOfFolioEnluminure">
                            <xsl:value-of select="position()"/>
                        </xsl:if>                           
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="thisFolioEnluminure"><xsl:value-of select="table:table-cell[position() = $thisColumnOfFolioEnluminure]/text:p"/></xsl:variable>
                
                <!-- Split In-Number Gallica from URI -->
                <xsl:variable name="Substring_ARK_Gallica">
                    <xsl:value-of select="substring-after($thisARKGallica,'http://gallica.bnf.fr/ark:/12148/')"/>    
                </xsl:variable>
                
                <!-- Add r to folio recto -->
                <xsl:variable name="FolioPagination">
                    <xsl:value-of select="$thisFolioEnluminure"/><xsl:if test="not(contains($thisFolioEnluminure,'v'))"><xsl:text>r</xsl:text></xsl:if>
                </xsl:variable>
                
                <!-- Création d'une liste (fichier csv) : troisième colonne = ARK image; deuxième colonne = Folio Enluminure, première colonne = ARKGallica -->   
                <xsl:variable name="URL_Pagination">http://gallica.bnf.fr/services/Pagination?ark={<xsl:value-of select="$Substring_ARK_Gallica"/>}</xsl:variable>
                <xsl:variable name="NumberEnluminure">
                    <xsl:choose>
                        <xsl:when test="document($URL_Pagination)/livre/pages/page[./numero=$FolioPagination]/ordre != 0">/f<xsl:value-of select="document($URL_Pagination)/livre/pages/page[./numero=$FolioPagination]/ordre"/>.item</xsl:when>
                        <xsl:when test="document($URL_Pagination)/livre/pages/page[./numero=substring-after($FolioPagination,'-')]/ordre != 0">/f<xsl:value-of select="document($URL_Pagination)/livre/pages/page[./numero=substring-after($FolioPagination,'-')]/ordre"/>.item</xsl:when>
                        <xsl:when test="document($URL_Pagination)/livre/pages/page[./numero=substring-before($FolioPagination,'-')]/ordre != 0">/f<xsl:value-of select="document($URL_Pagination)/livre/pages/page[./numero=substring-before($FolioPagination,'-')]/ordre"/>.item</xsl:when>
                        <xsl:otherwise><xsl:value-of></xsl:value-of></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="not(starts-with($Substring_ARK_Gallica,'btv1b90'))">
                        <xsl:value-of select="$thisARKGallica"/>, <xsl:value-of select="$thisFolioEnluminure"/>, <xsl:value-of select="$thisARKGallica"/><xsl:text>/f</xsl:text><xsl:value-of select="$NumberEnluminure"/><xsl:text>.item
</xsl:text></xsl:when>    
                    <xsl:otherwise><xsl:value-of select="$thisARKGallica"/>, <xsl:value-of select="$thisFolioEnluminure"/>, <xsl:value-of select="$thisARKGallica"/><xsl:text>
</xsl:text></xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
