<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
        
<!-- Transformation d'export RegeCart en TEI-P5 vers Biblissima XML - Stefanie Gehrke pour Biblissima, September 2016 -->
<xsl:template match="/">
    <!-- global output for all data goes here -->
    <xsl:variable name="output_dir">./</xsl:variable> 
    <xsl:variable name="outputDate"><xsl:value-of select="current-date()"/></xsl:variable>
    <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"/>ExportBdC2_RegeCart_Test_Biblissima<xsl:value-of select="substring-before($outputDate,'+')"/>.xml</xsl:variable>
    <xsl:result-document href="{$outputFile}" method="xml"  encoding="UTF-8" indent="yes" >
        <!-- create data set here -->
        <RecordList>   
            <DataBase uri="http://regecart.irht.cnrs.fr">RegeCart - regestes de cartulaires</DataBase>  

        <!-- global output for all books goes here -->
        <xsl:for-each select=".//tei:msDesc">
            <xsl:variable name="ID_CR"><xsl:value-of select="@xml:id"/></xsl:variable>
                <Book><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <ObjectType>manuscrit</ObjectType>
                    <Shelfmark>
                    <Organisation><xsl:value-of select="./tei:msIdentifier/tei:settlement"/><xsl:text>, </xsl:text><xsl:value-of select="./tei:msIdentifier/tei:institution"/></Organisation>
                    <Identifier>
                        <Idno><xsl:value-of select="./tei:msIdentifier/tei:idno"/></Idno>
                    </Identifier>
                    </Shelfmark>
                        <HasPart>
                                <PartType>unité textuelle</PartType>
                                <Text><Title><xsl:value-of select="./tei:msIdentifier/tei:msName"/></Title></Text>
                                <Pages><xsl:value-of select="./tei:msContents/tei:msItem/tei:locus"/></Pages>
                        </HasPart>
                    <xsl:for-each select="./tei:additional/tei:listBibl/tei:bibl[@type='entite_cartulR']/tei:ptr">
                        <xsl:variable name="URL_Telma"><xsl:value-of select="./@target"/></xsl:variable>
                        <xsl:variable name="Producteur_Telma"><xsl:value-of select="unparsed-text($URL_Telma)"/></xsl:variable>
                   <Date><Year>
                       <xsl:value-of select="substring-before(substring-after($Producteur_Telma,'&lt;p id=&quot;datation&quot;&gt;'),'&lt;/p&gt;')"/>
                   </Year></Date>
                    </xsl:for-each>
                    <Place><Name>
                        <xsl:value-of select="./tei:history/tei:origin//tei:placeName"/><xsl:text> (</xsl:text><xsl:value-of select="./tei:history/tei:origin//tei:region"/><xsl:text>)</xsl:text>
                    </Name></Place>
                    <xsl:for-each select="./tei:additional/tei:listBibl/tei:bibl[@type='prod_cartulR']/tei:ptr">
                    <Participant role="r70">
                        <xsl:variable name="URL_Telma"><xsl:value-of select="../../tei:bibl[@type='entite_cartulR']/tei:ptr[1]/@target"/></xsl:variable>
                        <xsl:variable name="Producteur_Telma"><xsl:value-of select="unparsed-text($URL_Telma)"/></xsl:variable>
                        <xsl:attribute name="id"><xsl:value-of select="./@target"/></xsl:attribute>
                        <Name><xsl:value-of select="../../../../tei:history/tei:origin//tei:orgName"/></Name>
                        <Name><xsl:value-of select="substring-before(substring-after($Producteur_Telma,'&lt;span property=&quot;dcterms:creator&quot;&gt;'),'&lt;/span&gt;')"/></Name>
                 </Participant>
                    </xsl:for-each>
                 <xsl:for-each select="./tei:additional/tei:listBibl/tei:bibl[@type='images_regeste' or @type='images_notice' or @type='images_auteurs' or @type='images_chronologique' or @type='images_index' or @type='images_divers' or @type='images_concordance' or @type='images_transcriptions']">
                        <Record><xsl:text>http://regecart.irht.cnrs.fr/dossier-</xsl:text><xsl:value-of select="substring-before(./tei:ref/@facs,'_')"/><xsl:text>/ms-</xsl:text><xsl:value-of select="$ID_CR"/></Record>
                    </xsl:for-each>
                <Record><xsl:value-of select="./tei:additional/tei:listBibl/tei:bibl[@type='medium']/tei:ref/@target"/></Record>
                    <xsl:for-each select="./tei:additional/tei:listBibl/tei:bibl[@type='entite_cartulR']/tei:ptr">
                <Record><xsl:value-of select="./@target"/></Record>
                    </xsl:for-each>
            </Book>   
        </xsl:for-each>

    <!-- Transformation vers /RecordList/Participant -->     
        <xsl:for-each select=".//tei:additional//tei:bibl[@type='prod_cartulR']/tei:ptr">
            <xsl:variable name="URL_Telma"><xsl:value-of select="../../tei:bibl[@type='entite_cartulR']/tei:ptr[1]/@target"/></xsl:variable>
        <xsl:variable name="Producteur_Telma"><xsl:value-of select="unparsed-text($URL_Telma)"/></xsl:variable>
            <Participant><xsl:attribute name="id"><xsl:value-of select="./@target"/></xsl:attribute>
                <Name><xsl:value-of select="../../../../tei:history/tei:origin//tei:orgName"/></Name>
                <Name><xsl:value-of select="substring-before(substring-after($Producteur_Telma,'&lt;span property=&quot;dcterms:creator&quot;&gt;'),'&lt;/span&gt;')"/></Name>
                <Note><xsl:value-of select="substring-before(substring-after($Producteur_Telma,'&lt;h3&gt;Note&lt;/h3&gt;'),'&lt;/p&gt;')"/></Note>
                <Record><xsl:value-of select="./@target"/></Record>
            </Participant>
    </xsl:for-each>
                
    <!-- Transformation vers /RecordList/Repository -->    
    <xsl:for-each-group select=".//tei:msIdentifier/tei:settlement" group-by="text()">
        <xsl:for-each-group select="../tei:institution" group-by="text()">
            <Repository>
                <Country><xsl:value-of select="../tei:country[1]"/></Country>
                <City><xsl:value-of select="../tei:settlement[1]"/></City>
                <Organisation><xsl:value-of select="../tei:settlement[1]"/><xsl:text>, </xsl:text><xsl:value-of select="../tei:institution[1]"/></Organisation>
            </Repository>
        </xsl:for-each-group>
    </xsl:for-each-group>    
        </RecordList>
    </xsl:result-document>
</xsl:template>
        
</xsl:transform>           
