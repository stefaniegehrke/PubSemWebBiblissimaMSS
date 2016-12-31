<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    version="2.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mdg="http://catalogue.bnf.fr/namespaces/MandragoreX"> 
 
<!-- Transformation des fichiers export XML vers RecordList/Book et RecordList/Descriptor etc. - Stefanie Gehrke pour Biblissima avril-décembre 2016 -->
<xsl:template match="/">
    <xsl:variable name="output_dir">./</xsl:variable> 
    <xsl:variable name="outputDate"><xsl:value-of select="current-date()"/></xsl:variable>
    <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"/>Export_test_Mandragore_Biblissima_<xsl:value-of select="substring-before($outputDate,'+')"/>.xml</xsl:variable>
    <xsl:result-document href="{$outputFile}" method="xml"  encoding="UTF-8" indent="yes" >
        <RecordList>   
            <DataBase uri="http://mandragore.bnf.fr">Mandragore</DataBase>
        <xsl:apply-templates select="*" mode="Book"/>
        <xsl:apply-templates select="*" mode="Authorities"/>
        </RecordList>
    </xsl:result-document>
</xsl:template>
          <xsl:template match="RecordList" mode="Book">
              <xsl:for-each-group select="collection('out/?select=*.mdg.xml')//mdg:images/mdg:idmanuscrit" group-by="text()">
                  <xsl:variable name="msID"><xsl:value-of select="current-group()[1]"/></xsl:variable>
                <!-- Book -->
                 <Book state="preserved"><xsl:attribute name="id"><xsl:value-of select="current-group()[1]"/></xsl:attribute>
                        <ObjectType>manuscrit</ObjectType>
                        <Shelfmark> 
                            <Organisation><xsl:attribute name="id"><xsl:value-of select="../../mdg:fonds/mdg:division"/></xsl:attribute><xsl:value-of select="../../fonds/division"/></Organisation>
                            <Identifier>
                                <Idno><xsl:value-of select="../../mdg:fonds/mdg:libelle"/><xsl:text> </xsl:text><xsl:value-of select="../../mdg:manuscrits/mdg:coten"/><xsl:if test="../../mdg:manuscrits/mdg:cotenb !=0"><xsl:text>-</xsl:text><xsl:value-of select="../../mdg:manuscrits/mdg:cotenb"/></xsl:if></Idno>
                                <Subidentifier><xsl:value-of select="../../mdg:manuscrits/mdg:cotea"/></Subidentifier>
                                <Volume><xsl:value-of select="../../mdg:manuscrits/mdg:volume"/></Volume>
                            </Identifier>
                        </Shelfmark>
                     <xsl:for-each select="../../mdg:parts/mdg:titreusage"><Name lang="fr"><xsl:value-of select="."/></Name></xsl:for-each>
                     <xsl:variable name="DigitalSurrogate">
                         <xsl:text>http://gallica.bnf.fr/ark:/12148/btv1b</xsl:text><xsl:value-of select="../../mdg:imagesnum/mdg:lotnum"/>?</xsl:variable>
                     <DigitalSurrogate type="integral"><xsl:value-of select="$DigitalSurrogate"/></DigitalSurrogate>
                         <!--à exclure : 1/ Si Imagesnum.LOTNUM commence par 081 : numérisation intégrale Mandragore (seulement les enluminures)
                             2/ Si Imagesnum.LOTNUM commence par 020-026, 030-033, 078-080 : numérisation partielle Banque d'images -->
                         <Record root="http://mandragore.bnf.fr/jsp/AfficheNoticeManArk.jsp?id=">
                             <xsl:attribute name="id"><xsl:value-of select="../../mdg:manuscrits/mdg:id"/></xsl:attribute>
                             <xsl:text>http://mandragore.bnf.fr/jsp/AfficheNoticeManArk.jsp?id=</xsl:text><xsl:value-of select="../../mdg:manuscrits/mdg:id"/></Record>
                    
                     <xsl:choose><xsl:when test="../../mdg:manuscrits/mdg:cotead !=''">
                         <xsl:for-each-group select="collection('out//?select=*.mdg.xml')//mdg:record[mdg:images/mdg:idmanuscrit=$msID]/mdg:manuscrits/mdg:cotead" group-by="text()">
                         <HasPart>
                             <PartType>codicological unit</PartType>
                             <Pages></Pages>
                             <xsl:for-each-group select="collection('out//?select=*.mdg.xml')//mdg:record[mdg:images/mdg:idmanuscrit=$msID]/mdg:parts/mdg:auteurtitre" group-by="text()">
                          <HasPart>
                             <PartType>textual unit</PartType>
                             <Pages></Pages>
                             <Text>
                                 <Title><xsl:value-of select="current-group()[1]"/></Title>
                                 <AltTitle><xsl:value-of select="../mdg:titreusage"/></AltTitle>
                             </Text>
                              <xsl:for-each select="collection('out//?select=*.mdg.xml')//mdg:record[mdg:images/mdg:idmanuscrit=$msID]/mdg:images/mdg:folio">
                            <HasFeature>
                                <xsl:attribute name="id"><xsl:value-of select="/mdg:record/@id"/></xsl:attribute>
                                <FeatureType>illumination</FeatureType>
                                <Page><xsl:value-of select="."/></Page>
                                <Canvas><xsl:value-of select="$DigitalSurrogate"/><xsl:text>/canvas/f</xsl:text><xsl:value-of select="../../mdg:images/mdg:numnum"/></Canvas>
                                <Caption><xsl:value-of select="../mdg:legende"/></Caption>
                                <Rubric><xsl:value-of select="../mdg:rubrique"/></Rubric>
                                <Inscription><xsl:value-of select="../mdg:inscriptions"/></Inscription>
                                <Note><xsl:value-of select="../mdg:note"/></Note>
                                <xsl:for-each select="../../mdg:descrip/mdg:descrip">
                                <Descriptor><Name><xsl:value-of select="."/></Name></Descriptor>
                                </xsl:for-each>
                                <xsl:for-each select="../../mdg:parts/mdg:artiste">
                                <Participant role="r710"><Name><xsl:value-of select="."/></Name></Participant></xsl:for-each>
                                <Date><Century><xsl:value-of select="../../mdg:parts/mdg:siecle"/></Century><Year><xsl:attribute name="uri">http://data.bnf.fr/date/<xsl:value-of select="../../mdg:parts/mdg:dateexacte"/>/</xsl:attribute><xsl:value-of select="../../mdg:parts/mdg:dateexacte"/></Year></Date>
                                <Place><Name><xsl:value-of select="../../mdg:parts/mdg:origine"/></Name></Place>
                                <Record><xsl:text>http://mandragore.bnf.fr/ark:/12148/cgfbt</xsl:text><xsl:value-of select="/mdg:record/@id"/></Record>
                            </HasFeature>
                     </xsl:for-each>
                         </HasPart>
                     </xsl:for-each-group></HasPart>
                         </xsl:for-each-group></xsl:when>
                         <xsl:otherwise>
                             <xsl:for-each-group select="collection('out//?select=*.mdg.xml')//mdg:record[mdg:images/mdg:idmanuscrit=$msID]/mdg:parts/mdg:auteurtitre" group-by="text()">
                                 <HasPart>
                                     <PartType>textual unit</PartType>
                                     <Pages></Pages>
                                     <Text>
                                         <Title><xsl:value-of select="current-group()[1]"/></Title>
                                         <AltTitle><xsl:value-of select="../mdg:titreusage"/></AltTitle>
                                     </Text>
                                     <xsl:for-each select="collection('out//?select=*.mdg.xml')//mdg:record[mdg:images/mdg:idmanuscrit=$msID]/mdg:images/mdg:folio">
                                         <HasFeature>
                                             <xsl:attribute name="id"><xsl:value-of select="/mdg:record/@id"/></xsl:attribute>
                                             <FeatureType>illumination</FeatureType>
                                             <Page><xsl:value-of select="."/></Page>
                                             <Caption><xsl:value-of select="../mdg:legende"/></Caption>
                                             <Rubric><xsl:value-of select="../mdg:rubrique"/></Rubric>
                                             <Inscription><xsl:value-of select="../mdg:inscriptions"/></Inscription>
                                             <Note><xsl:value-of select="../mdg:note"/></Note>
                                             <xsl:for-each select="../../mdg:descrip/mdg:descrip">
                                                 <Descriptor><Name><xsl:value-of select="."/></Name></Descriptor>
                                             </xsl:for-each>
                                             <xsl:for-each select="../../mdg:parts/mdg:artiste">
                                                 <Participant role="r710"><Name><xsl:value-of select="."/></Name></Participant></xsl:for-each>
                                             <Date><Century><xsl:value-of select="../../mdg:parts/mdg:siecle"/></Century><Year><xsl:value-of select="../../mdg:parts/mdg:dateexacte"/></Year></Date>
                                             <Place><Name><xsl:value-of select="../../mdg:parts/mdg:origine"/></Name></Place>
                                             <Record><xsl:text>http://mandragore.bnf.fr/ark:/12148/cgfbt</xsl:text><xsl:value-of select="/mdg:record/@id"/></Record>
                                         </HasFeature>
                                     </xsl:for-each>
                                 </HasPart>
                             </xsl:for-each-group>
                         </xsl:otherwise>
                     </xsl:choose>
                    </Book> 
              </xsl:for-each-group>
              <Repository>
                  <Name>Bibliothèque nationale de France, Département des Manuscrits (occidentaux)</Name>
                  <Country geonames="3017382">France</Country>
                  <City geonames="2988507">Paris</City>
                  <Organisation id="Mss" id_bbma="e0659fc5d278f341884d0c3886f2c07afb434c96">Bibliothèque nationale de France, Département des Manuscrits</Organisation>
                  <Concept source="BnF">http://data.bnf.fr/ark:/12148/cb12511198k</Concept>
                  <Name_Bbma>Bibliothèque nationale de France. Département des manuscrits</Name_Bbma>
              </Repository>
              <Repository>
                  <Name>Bibliothèque nationale de France, Département des Manuscrits (orientaux)</Name>
                  <Country geonames="3017382">France</Country>
                  <City geonames="2988507">Paris</City>
                  <Organisation id="Mso" id_bbma="e0659fc5d278f341884d0c3886f2c07afb434c96">Bibliothèque nationale de France, Département des Manuscrits</Organisation>
                  <Concept source="BnF">http://data.bnf.fr/ark:/12148/cb12511198k</Concept>
                  <Name_Bbma>Bibliothèque nationale de France. Département des manuscrits</Name_Bbma>
              </Repository>
              <Repository>
                  <Name>Bibliothèque nationale de France, Bibliothèque de l'Arsenal</Name>
                  <Country geonames="3017382">France</Country>
                  <City geonames="2988507">Paris</City>
                  <Organisation id="Ars" id_bbma="10bbb01a92abfe7bac5b5898920b8f38fca6cfc9">BNF - Bibliothèque de l'Arsenal</Organisation>
                  <Concept source="BnF">http://data.bnf.fr/ark:/12148/cb11873586s</Concept>
                  <Name_Bbma>Bibliothèque de l'Arsenal. Paris (1994-)</Name_Bbma>
              </Repository>
          </xsl:template>
    
<!-- Groupes autorités (personnes, collectivités, oeuvres, lieux, descripteurs) -->
        
    <xsl:template match="RecordList" mode="Authorities">
        
        <xsl:for-each-group select="collection('out//?select=*.mdg.xml')//mdg:record//mdg:parts/mdg:artiste" group-by="text()">
            <Participant><xsl:attribute name="id"></xsl:attribute>
                <Name><xsl:value-of select="current-group()[1]"/></Name>
                <Concept></Concept>
            </Participant>
        </xsl:for-each-group>
        
        <xsl:for-each-group select="collection('out//?select=*.mdg.xml')//mdg:record//mdg:titreusage" group-by="text()">
            <Work><xsl:attribute name="id"></xsl:attribute>
                <Title></Title>
                <Concept></Concept>
                <Text>
                <Title><xsl:value-of select="current-group()[1]"/></Title>
                </Text>
            </Work>
        </xsl:for-each-group>
        
        <xsl:for-each-group select="collection('out//?select=*.mdg.xml')//mdg:record//mdg:parts/mdg:origine" group-by="text()">
            <Place><xsl:attribute name="id"></xsl:attribute>
                <Name><xsl:value-of select="current-group()[1]"/></Name>
                <Concept></Concept>
            </Place>
        </xsl:for-each-group>
        
        <xsl:for-each-group select="collection('out//?select=*.mdg.xml')//mdg:record/mdg:descrip/mdg:descrip/mdg:descripteur" group-by="text()">
        <Descriptor><xsl:attribute name="id"></xsl:attribute>
            <Concept></Concept>
            <Name><xsl:value-of select="current-group()[1]"/></Name>
            <AltName><xsl:value-of select="../mdg:d602a"/></AltName>
            <Note><xsl:value-of select="../mdg:d600a"/></Note>
            <Note><xsl:value-of select="../mdg:d175e"/></Note>
        </Descriptor>
        </xsl:for-each-group>
        
    </xsl:template>
</xsl:transform>     