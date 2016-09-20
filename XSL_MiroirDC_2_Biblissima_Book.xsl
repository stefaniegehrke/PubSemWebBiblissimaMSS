<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
        

<!-- Transformation des fichiers Miroir des Classiques par fichier "Text" -->
<xsl:template match="/">
    <!-- global output for all data goes here --><xsl:variable name="output_dir">./</xsl:variable> 
    <xsl:variable name="outputDate"><xsl:value-of select="current-date()"/></xsl:variable>
    <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"/>ExportBdC2_MiroirDC_Test_Biblissima<xsl:value-of select="substring-before($outputDate,'+')"/>.xml</xsl:variable>
    <xsl:result-document href="{$outputFile}" method="xml"  encoding="UTF-8" indent="yes" >
        <!-- create data set here -->
        <RecordList>   
            <DataBase>Miroir des Classiques</DataBase>
            
        <xsl:apply-templates select="*" mode="book"/> 
        <xsl:apply-templates select="*" mode="work"/>
            
        </RecordList>
    </xsl:result-document>
    
</xsl:template>


    <xsl:template match="textList" mode="book">
        <!-- global output for all books goes here -->
        
        <!-- one loop over all text files -->
        <xsl:for-each select=".//Text">
            <xsl:variable name="textrecord"><xsl:value-of select="."/></xsl:variable>
           
 
            <xsl:for-each select="document($textrecord)//tei:item[parent::tei:list[@type='listMs']]">
                <xsl:variable name="idno"><xsl:value-of select="./tei:msDesc/tei:msIdentifier/tei:idno"/></xsl:variable>
                
                <Book><xsl:attribute name="id"><xsl:value-of select="./@xml:id"/></xsl:attribute>
                    <ObjectType><xsl:value-of select="../../@type"/></ObjectType>
                <Shelfmark>
                    <Organisation><xsl:value-of select="./tei:msDesc/tei:msIdentifier/tei:repository"/></Organisation>
                    <Identifier>
                        <Idno><xsl:value-of select="./tei:msDesc/tei:msIdentifier/tei:idno"/></Idno>
                    </Identifier>
                </Shelfmark>
                <Text id="">
                    <Title><xsl:attribute name="lang"><xsl:value-of select="../../../@subtype"/></xsl:attribute><xsl:value-of select="../../../@subtype"/></Title>
                    <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                        <Title lang=""><xsl:value-of select="normalize-space(/tei:TEI//tei:titleStmt/tei:title/tei:bibl/tei:title)"/></Title>
                        <Concept><xsl:value-of select="/tei:TEI//tei:titleStmt/tei:title/tei:bibl/@corresp"/></Concept>
                    </AssociatedWork>
                    <Language id="">français/occitan</Language>
                </Text>
                    <Date><Century><xsl:value-of select="./tei:msDesc/tei:history/tei:origin/tei:p/tei:origDate"/></Century><Year><xsl:value-of select="./tei:msDesc/tei:history/tei:origDate/@notbefore"/></Year><Year><xsl:value-of select="./tei:msDesc/tei:history/tei:origDate/@notafter"/><Year><xsl:value-of select="./msDesc/history/origDate/@when"/></Year></Year><Note></Note></Date>
                 <Participant id="">
                        <Name><xsl:value-of select="/tei:TEI//tei:titleStmt/tei:title/tei:bibl/tei:author"/></Name>
                 </Participant>
                 <Note></Note>
               
                    <Extent unit=""><xsl:value-of select="./tei:msDesc/tei:physDesc/tei:objectDesc/tei:p"/></Extent>
                    <BibliographicReference id="[internal ID from database]"></BibliographicReference> 
                    <HasPart id="[internal ID from database]">
                    <PartType id="[internal ID from database]">unité textuelle</PartType>
                    <Text id="">
                        <Title><xsl:attribute name="lang"><xsl:value-of select="../../../@subtype"/></xsl:attribute><xsl:value-of select="../../../@subtype"/></Title>
                        <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                            <Title lang=""><xsl:value-of select="normalize-space(/tei:TEI//tei:titleStmt/tei:title/tei:bibl/tei:title)"/></Title>
                            <Concept><xsl:value-of select="/tei:TEI//tei:titleStmt/tei:title/tei:bibl/@corresp"/></Concept>
                            <Participant role="r70"><xsl:value-of select="/tei:TEI//tei:titleStmt/tei:title/tei:bibl/tei:author"/></Participant>
                        </AssociatedWork>
                        <Language id="">français/occitan</Language>
                    </Text>
                    <Pages><xsl:value-of select="../../../../tei:div[@type='incipit' and .//tei:idno=$idno]/tei:msContents/tei:msItem/tei:div[@type='incipit']/tei:locus[1]"/>-<xsl:value-of select="../../../../div[@type='incipit' and .//idno=$idno]/tei:msContents/tei:msItem/tei:div[@type='incipit']/tei:locus[2]"/></Pages>
                    <Incipit><xsl:value-of select="../../../../tei:div[@type='incipit' and .//tei:idno=$idno]/tei:msContents/tei:msItem/tei:div[@type='incipit']/tei:locus[1]"/></Incipit>
                    <Explicit></Explicit>
                </HasPart>
            </Book>   
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
 
    

    <!-- Transformation des fichiers "text" vers Recordlist/Work : tous dans un fichier -->  
    
    <xsl:template match="textList" mode="work">
        <!-- one loop over all text files -->
        <xsl:for-each select=".//Text">
            <xsl:variable name="textrecord"> <xsl:value-of select="."/></xsl:variable>     
            <Work>
                <Title><xsl:value-of select="normalize-space(document($textrecord)//tei:titleStmt/tei:title/tei:bibl/tei:title)"/></Title>
                <Concept><xsl:value-of select="document($textrecord)//tei:titleStmt/tei:title/tei:bibl/@corresp"/></Concept>
                <Participant role="r70"><xsl:value-of select="document($textrecord)//tei:titleStmt/tei:title/tei:bibl/tei:author"/></Participant>
                <Note><xsl:value-of select="document($textrecord)//tei:text/tei:body/tei:div[tei:head = 'Diffusion latine']/tei:p"/></Note>
            </Work>
        </xsl:for-each>
    </xsl:template>
  

        
</xsl:transform>           

