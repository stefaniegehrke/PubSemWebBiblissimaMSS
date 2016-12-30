<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rel="http://bibnum.bnf.fr/ns/reliure" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
 
    <!-- Transformation des fichiers TEI-P5 et schema reliures.bnf.fr vers RecordList/Book et RecordList/Participant - Stefanie Gehrke pour Biblissima avril-décembre 2016 -->
<xsl:template match="/">
    <xsl:variable name="output_dir">./</xsl:variable> 
    <xsl:variable name="outputDate"><xsl:value-of select="current-date()"/></xsl:variable>
    <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"/>Export_test_Reliures_Biblissima_<xsl:value-of select="substring-before($outputDate,'+')"/>.xml</xsl:variable>
    <xsl:result-document href="{$outputFile}" method="xml"  encoding="UTF-8" indent="yes" >
        <RecordList>   
            <DataBase uri="http://reliures.bnf.fr">Reliures</DataBase>
        <xsl:apply-templates select="*" mode="Book"/>
        <xsl:apply-templates select="*" mode="Authorities"/>
        </RecordList>
    </xsl:result-document>
</xsl:template>
          <xsl:template match="RecordList" mode="Book">
              <!-- boucle a revoir -->
              <xsl:for-each select="collection('out/?select=*.xml')//tei:TEI">
                  <xsl:variable name="bookID"><xsl:value-of select="@id"/></xsl:variable>
                <!-- Book -->
                 <Book state="preserved"><xsl:attribute name="id"><xsl:value-of select="$bookID"/></xsl:attribute>
                     <ObjectType><xsl:value-of select=".//rel:bookDescription/@type"/></ObjectType>
                        <Shelfmark> 
                            <Organisation><xsl:value-of select=".//tei:repository"/></Organisation>
                            <Identifier>
                                <Idno><xsl:value-of select=".//rel:bookIdentifier/tei:idno"/></Idno>
                                <!-- <Volume><xsl:value-of select=""/></Volume> -->
                            </Identifier>
                        </Shelfmark>
                     <xsl:for-each select=".//persName[@role='4010' or '4140']">
                         <Participant><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute><Name><xsl:value-of select="."/></Name></Participant>
                     </xsl:for-each> <xsl:for-each select=".//orgName[@role='4010' or '4140']">
                         <Participant><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute><Name><xsl:value-of select="."/></Name></Participant>
                     </xsl:for-each>
                     <xsl:variable name="DigitalSurrogate"><xsl:text>http://gallica.bnf.fr/</xsl:text><xsl:value-of select=".//tei:facsimile//tei:graphic/@url"/>?</xsl:variable>
                     <DigitalSurrogate type="integral"><xsl:value-of select="$DigitalSurrogate"/></DigitalSurrogate>
                     <Record root="http://reliures.bnf.fr/ark:/12148"><xsl:text>http://reliures.bnf.fr/</xsl:text><xsl:value-of select=".//tei:idno[@type='ARK_reliuresBNF']"/></Record>
                     <BibliographicReference><xsl:value-of select=".//tei:listBibl/tei:ref"/></BibliographicReference>
                     <Binding><xsl:value-of select=".//rel:globalDescription"/>
                         <Date><Year><xsl:attribute name="uri">http://data.bnf.fr/date/<xsl:value-of select=".//origin/@notBefore"/></xsl:attribute><xsl:value-of select=".//origin/@notBefore"/></Year><Year><xsl:attribute name="uri">http://data.bnf.fr/date/<xsl:value-of select=".//origin/@notAfter"/></xsl:attribute><xsl:value-of select=".//origin/@notAfter"/></Year></Date></Binding>
                    </Book> 
                  <Mainfestation>
                      <Date><Year><xsl:value-of select=".//tei:div[@type='description']//tei:publicationStmt/tei:date/@when"/></Year></Date>
                      <Place><xsl:value-of select=".//tei:div[@type='description']//tei:publicationStmt/tei:pubPlace"/></Place>
                      <Participant><Name><xsl:value-of select=".//tei:div[@type='description']//tei:publicationStmt/tei:publisher"/></Name></Participant>
                      <xsl:for-each select=".//rel:bookItem">
                          <HasPart>
                              <PartType>textual unit</PartType>
                              <Text>
                                  <Title><xsl:value-of select="./tei:title[@type='main']"/></Title>
                                  <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="tei:idno[@type='ARK']"/></xsl:attribute>
                                      <Concept><xsl:value-of select="tei:idno[@type='ARK']"/></Concept>
                                  </AssociatedWork>
                                  <Language><xsl:value-of select=".//tei:textLang"/></Language>
                              </Text>
                          </HasPart>
                          <Book><xsl:attribute name="id"><xsl:value-of select="$bookID"/></xsl:attribute></Book>
                      </xsl:for-each>
                  </Mainfestation>
              </xsl:for-each>
              <Repository>
                  <Name>Bibliothèque nationale de France</Name>
                  <Country geonames="3017382">France</Country>
                  <City geonames="2988507">Paris</City>
                  <Organisation>Bibliothèque nationale de France</Organisation>
                  <Concept source="BnF"></Concept>
                  <Name_Bbma>Bibliothèque nationale de France</Name_Bbma>
              </Repository>
          </xsl:template>
    
<!-- Groupes autorités (personnes, collectivités, oeuvres, lieux) -->
        
    <xsl:template match="RecordList" mode="Authorities">
        <xsl:for-each-group select="collection('out//?select=*.xml')//tei:persName" group-by="text()">
            <Participant><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                <Name><xsl:value-of select="current-group()[1]"/></Name>
            </Participant>
        </xsl:for-each-group>
        <xsl:for-each-group select="collection('out//?select=*.xml')//tei:orgName" group-by="text()">
            <Participant><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                <Name><xsl:value-of select="current-group()[1]"/></Name>
            </Participant>
        </xsl:for-each-group>
        
        <xsl:for-each-group select="collection('out//?select=*.xml')//tei:index[@indexName='production_place']/tei:term" group-by="text()">
        <Place>
            <Name><xsl:value-of select="current-group()[1]"/></Name>
        </Place>
        </xsl:for-each-group>
        <xsl:for-each-group select="collection('out//?select=*.xml')//rel:bookItem/tei:idno" group-by="text()">
            <Work><xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
                <Concept><xsl:value-of select="."/></Concept>
                <Participant role="r70">
                    <Name><xsl:value-of select="../tei:author/tei:persName"/></Name>
                </Participant>
            </Work>
        </xsl:for-each-group>
        <xsl:for-each-group select="collection('out//?select=*.xml')//tei:persName[@role='4010']" group-by="text()">
            <xsl:variable name="formerOwner"><xsl:value-of select="current-group()[1]"/></xsl:variable>
            <Collection>
                <Participant role="r4010"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <Name><xsl:value-of select="current-group()[1]"/></Name></Participant>
                <xsl:for-each select="collection('out//?select=*.xml')//tei:provenance[tei:persName[@role='4010']=$formerOwner]">
                <Book><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute></Book>
                </xsl:for-each>
            </Collection>
        </xsl:for-each-group>
        <xsl:for-each-group select="collection('out//?select=*.xml')//tei:orgName[@role='4010']" group-by="text()">
            <Participant><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                <Name><xsl:value-of select="current-group()[1]"/></Name>
            </Participant>
        </xsl:for-each-group>
    </xsl:template>
</xsl:transform>     