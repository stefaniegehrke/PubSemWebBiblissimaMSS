<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
<!-- Transformation de fichiers texte de Miroir des Classiques (ENC) en TEI-P5 vers XML pivot Biblissima - Stefanie Gehrke - Septembre/Novembre 2016 pour Biblissima -->
<xsl:template match="/">
    <xsl:variable name="output_dir">./</xsl:variable> 
    <xsl:variable name="outputDate"><xsl:value-of select="current-date()"/></xsl:variable>
    <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"/>ExportBdC2_MiroirDC_Biblissima<xsl:value-of select="substring-before($outputDate,'+')"/>.xml</xsl:variable>
    <xsl:result-document href="{$outputFile}" method="xml"  encoding="UTF-8" indent="yes" >
        <RecordList>   
            <DataBase uri="http://elec.enc.sorbonne.fr/miroir/">Miroir des Classiques</DataBase>
        <xsl:apply-templates select="*" mode="book"/> 
        <xsl:apply-templates select="*" mode="participant"/>
        <xsl:apply-templates select="*" mode="place"/>
        <xsl:apply-templates select="*" mode="work"/>
        <xsl:apply-templates select="*" mode="organisation"/>
        <xsl:apply-templates select="*" mode="collection"/>
        </RecordList>
    </xsl:result-document>
</xsl:template>

    <xsl:template match="textList" mode="book">
        <xsl:for-each select=".//Text">
            <xsl:variable name="textrecord"><xsl:value-of select="."/></xsl:variable>
            <xsl:for-each select="document($textrecord)//tei:witness[parent::tei:listWit]">
                <xsl:variable name="idno"><xsl:value-of select="substring-after(./tei:ref/@target,'#')"/></xsl:variable>
                <xsl:variable name="idno_text"><xsl:value-of select="$idno"/><xsl:text>_</xsl:text><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:variable>
                <Book state="preserved"><xsl:attribute name="id"><xsl:value-of select="$idno"/></xsl:attribute>
                    <ObjectType>manuscrit</ObjectType>
                    <Shelfmark>
                        <Organisation><xsl:value-of select=".//tei:settlement"/><xsl:text>, </xsl:text><xsl:value-of select=".//tei:repository"/></Organisation>
                    <Identifier><xsl:value-of select=".//tei:msIdentifier/tei:idno"/></Identifier>
                    </Shelfmark>
                    <Concept><xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]/tei:ref/@corresp"/></Concept>
                    <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]">
                        <xsl:choose>
                            <xsl:when test="count(.//tei:msContents/tei:msItem) != 1 and count(.//tei:msContents/tei:msItem) != 0">
                                <xsl:for-each select=".//tei:msContents/tei:msItem">
                    <HasPart>
                        <PartType>textual unit</PartType>
                        <Pages><xsl:value-of select="./tei:locus/@from"/><xsl:text>-</xsl:text><xsl:value-of select="./tei:locus/@to"/></Pages>
                        <Text><xsl:attribute name="id"><xsl:value-of select="$idno_text"/></xsl:attribute>
                            <Title><xsl:attribute name="lang"><xsl:value-of select="./tei:title/@xml:lang"/></xsl:attribute>
                                <xsl:value-of select="normalize-space(./tei:title)"/></Title>
                            <Title><xsl:value-of select="substring-before(./tei:incipit,'lb/')"/></Title>
                            <xsl:for-each select=".//tei:title[@type='ancien']">
                            <Title lang="fro"><xsl:value-of select="."/></Title>
                            </xsl:for-each>
                            <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                                <Title><xsl:value-of select="normalize-space(.//tei:title[@type='oeuvre'])"/></Title>
                                <Concept><xsl:value-of select=".//tei:title[@type='oeuvre']/@corresp"/></Concept>
                            </AssociatedWork>
                        <Language><xsl:attribute name="id"><xsl:value-of select="./tei:title/tei:lang/@xml:lang"/></xsl:attribute>
                            <xsl:value-of select="./tei:title/tei:lang[@n='lang_arrivée']"/></Language>
                            <Language>français</Language>
                       <xsl:choose>
                           <xsl:when test="contains(@xml:id,'$idno_text')">
                            <xsl:for-each select="/tei:TEI//tei:listBibl[tei:head='Editions']/tei:bibl">
                            <Edition><xsl:value-of select="."/></Edition>
                        </xsl:for-each>
                           </xsl:when>
                       </xsl:choose>
                            <xsl:for-each select="./tei:title/tei:persName">
                        <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                            <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                            <Name><xsl:value-of select="normalize-space(.)"/></Name>
                        </Participant>
                            </xsl:for-each>
                            <Note><xsl:value-of select="normalize-space(../tei:summary)"/></Note>
                            <Note><xsl:value-of select="normalize-space(../tei:p)"/></Note>
                            <xsl:for-each select=".">    
                                <Note><xsl:value-of select="ancestor::tei:div[@type='expression']/@xml:id"/>
                                    <xsl:text> </xsl:text><xsl:value-of select="ancestor::tei:div[@type='expression']/@n"/>
                                </Note>
                                <Note><xsl:value-of select="ancestor::tei:div[@type='soustraduction']/@xml:id"/>
                                    <xsl:text> </xsl:text><xsl:value-of select="ancestor::tei:div[@type='soustraduction']/@n"/>
                                </Note>
                        </xsl:for-each>
                    </Text>
                    </HasPart>
                            </xsl:for-each>
                     </xsl:when>
                            <xsl:when test="count(.//tei:msContents/tei:msItem/tei:msItem) != 1 and count(.//tei:msContents/tei:msItem/tei:msItem) != 0">
                                <xsl:for-each select=".//tei:msContents/tei:msItem">
                                <HasPart>
                                    <PartType>textual unit</PartType>
                                    <Pages><xsl:value-of select="./tei:locus/@from"/><xsl:text>-</xsl:text><xsl:value-of select="./tei:locus/@to"/></Pages>
                                    <Text><xsl:attribute name="id"><xsl:value-of select="./@xml:id"/></xsl:attribute>
                                        <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                                            <Title><xsl:value-of select="normalize-space(./tei:title[@type='oeuvre'])"/></Title>
                                            <Concept><xsl:value-of select="./tei:title[@type='oeuvre']/@corresp"/></Concept>
                                        </AssociatedWork>
                                        <Language><xsl:attribute name="id"><xsl:value-of select="./tei:title/tei:lang/@xml:lang"/></xsl:attribute>
                                            <xsl:value-of select="./tei:title/tei:lang[@n='lang_arrivée']"/></Language>
                                        <Language>français</Language>
                                    </Text>
                                <xsl:for-each select=".//tei:msContents/tei:msItem/tei:msItem">
                                    <HasPart>
                                        <PartType>textual unit</PartType>
                                        <Pages><xsl:value-of select="./tei:locus/@from"/><xsl:text>-</xsl:text><xsl:value-of select="./tei:locus/@to"/></Pages>
                                        <Text><xsl:attribute name="id"><xsl:value-of select="$idno_text"/></xsl:attribute>
                                            <Title><xsl:attribute name="lang"><xsl:value-of select="./tei:title/@xml:lang"/></xsl:attribute>
                                                <xsl:value-of select="normalize-space(./tei:title)"/></Title>
                                            <Title><xsl:value-of select="substring-before(./tei:incipit,'lb/')"/></Title>
                                            <xsl:for-each select=".//tei:title[@type='ancien']">
                                                <Title lang="fro"><xsl:value-of select="."/></Title>
                                            </xsl:for-each>
                                        </Text>
                                    </HasPart>
                                </xsl:for-each>
                                            <xsl:choose>
                                                <xsl:when test="contains(@xml:id,'$idno_text')">
                                                    <xsl:for-each select="/tei:TEI//tei:listBibl[tei:head='Editions']/tei:bibl">
                                                        <Edition><xsl:value-of select="."/></Edition>
                                                    </xsl:for-each>
                                                </xsl:when>
                                            </xsl:choose>
                                            <xsl:for-each select="./tei:title/tei:persName">
                                                <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                                    <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                                    <Name><xsl:value-of select="normalize-space(.)"/></Name>
                                                </Participant>
                                            </xsl:for-each>
                                            <Note><xsl:value-of select="normalize-space(../tei:summary)"/></Note>
                                            <Note><xsl:value-of select="normalize-space(../tei:p)"/></Note>
                                            <xsl:for-each select=".">    
                                                <Note><xsl:value-of select="ancestor::tei:div[@type='expression']/@xml:id"/>
                                                    <xsl:text> </xsl:text><xsl:value-of select="ancestor::tei:div[@type='expression']/@n"/>
                                                </Note>
                                                <Note><xsl:value-of select="ancestor::tei:div[@type='soustraduction']/@xml:id"/>
                                                    <xsl:text> </xsl:text><xsl:value-of select="ancestor::tei:div[@type='soustraduction']/@n"/>
                                                </Note>
                                            </xsl:for-each>
                                    </HasPart>
                                </xsl:for-each>
                            </xsl:when>
                     <xsl:otherwise>
                         <Text><xsl:attribute name="id"><xsl:value-of select="$idno_text"/></xsl:attribute>
                             <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents//tei:title">
                             <Title>
                                 <xsl:attribute name="lang"><xsl:value-of select="./@xml:lang"/></xsl:attribute>
                                 <xsl:value-of select="normalize-space(.)"/></Title>
                             </xsl:for-each>
                             <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents//tei:title[@type='ancien']">
                             <Title lang="fro"><xsl:value-of select="normalize-space(.)"/></Title>
                             </xsl:for-each>
                             <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                                 <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents//tei:title[@type='oeuvre']">
                                 <Title lang=""><xsl:value-of select="normalize-space(.)"/></Title></xsl:for-each>
                                 <Concept><xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents//tei:title[@type='oeuvre']/@corresp"/></Concept>
                         </AssociatedWork>
                             <Language><xsl:attribute name="id"><xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:lang/@xml:lang"/></xsl:attribute>
                                 <xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:lang[@n='lang_arrivée']"/>
                             </Language>
                             <Language>français</Language>
                             <xsl:for-each select="/tei:TEI//tei:listBibl[tei:head='Editions']/tei:bibl">
                                 <Edition><xsl:value-of select="."/></Edition> 
                             </xsl:for-each>
                             <Incipit><xsl:value-of select="substring-before(/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:incipit,'lb/')"/></Incipit>
                             <Explicit><xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents//tei:explicit"/></Explicit>
                             <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents//tei:persName">
                             <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                 <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                 <Name><xsl:value-of select="normalize-space(.)"/></Name>
                             </Participant>
                             </xsl:for-each>
                             <Note><xsl:value-of select="normalize-space(/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:summary)"/></Note>
                             <Note><xsl:value-of select="normalize-space(/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:p)"/></Note>
                             <Note>
                                 <xsl:value-of select="/tei:TEI//tei:div[@type='expression' and descendant::tei:item[@xml:id=$idno]]/@subtype"/>
                                 <xsl:text> </xsl:text><xsl:value-of select="/tei:TEI//tei:div[@type='expression' and descendant::tei:item[@xml:id=$idno]]/@xml:id"/>
                             </Note>
                             <Note><xsl:value-of select="/tei:TEI//tei:div[@type='soustraduction' and descendant::tei:item[@xml:id=$idno]]/@xml:id"/>
                                 <xsl:text> </xsl:text><xsl:value-of select="/tei:TEI//tei:div[@type='soustraduction' and descendant::tei:item[@xml:id=$idno]]/@n"/>
                             </Note>
                        </Text>
                            </xsl:otherwise>
                        </xsl:choose>
                    <Date>
                        <Century><xsl:value-of select="./tei:msDesc/tei:history/tei:origin//tei:origDate"/></Century>
                        <Year><xsl:value-of select="./tei:msDesc/tei:history/tei:origin//tei:origDate/@notBefore"/></Year>
                        <Year><xsl:value-of select="./tei:msDesc/tei:history/tei:origin//tei:origDate/@notAfter"/></Year>
                    </Date>
                        <Place>
                            <Name><xsl:value-of select="./tei:msDesc/tei:history/tei:origin//tei:origPlace"/></Name>
                        </Place>
                        <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]//tei:physDesc//tei:persName">
                            <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                <Name><xsl:value-of select="normalize-space(.)"/></Name>
                            </Participant>
                        </xsl:for-each>
                        <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]//tei:history//tei:persName">
                            <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                <Name><xsl:value-of select="normalize-space(.)"/></Name>
                            </Participant>
                        </xsl:for-each>
                        <Format><xsl:value-of select="./tei:msDesc//tei:objectDesc/tei:extent/tei:dimensions/tei:height"/><xsl:text>x</xsl:text><xsl:value-of select="./tei:msDesc//tei:objectDesc/tei:extent/tei:dimensions/tei:width"/></Format>
                        <xsl:for-each select=".//tei:msContents/tei:msItem">    
                        <Note><xsl:value-of select="ancestor::tei:div/@xml:id"/></Note>
                        </xsl:for-each>
                        <xsl:for-each select=".//tei:term">
                        <Term context="script"><xsl:value-of select="normalize-space(.)"/></Term>
                        </xsl:for-each>
                </xsl:for-each>
            </Book>   
                <!-- List of lost manuscripts goes here -->
                
                <xsl:for-each select="document($textrecord)//div[@type='deperdita']/tei:list[@type='deperdita']/tei:item">
                    <xsl:variable name="id"><xsl:value-of select="@xml:id"/></xsl:variable>
                    <Book state="attested"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                        <ObjectType>manuscrit attesté</ObjectType>
                        <Shelfmark>
                            <Organisation><xsl:value-of select="./tei:msDesc//settlement"/><xsl:text>, </xsl:text><xsl:value-of select="./tei:msDesc//tei:repository"/></Organisation>
                            <Identifier><xsl:value-of select="./tei:msDesc//tei:identifier"/></Identifier>
                        </Shelfmark>
                        <Text>
                            <Title><xsl:value-of select=".//tei:msContents//tei:title"/></Title>
                            <AssociatedWork>
                                <xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                            </AssociatedWork>
                        </Text>
                        <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$id]//tei:physDesc//tei:persName">
                            <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                <Name><xsl:value-of select="normalize-space(.)"/></Name>
                            </Participant>
                        </xsl:for-each>
                        <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$id]//tei:history//tei:persName">
                            <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                <Name><xsl:value-of select="normalize-space(.)"/></Name>
                            </Participant>
                        </xsl:for-each>
                    </Book>
                </xsl:for-each>
            </xsl:for-each>
            
            <!-- List of incunabulas and éditions (?) goes here -->
            
            <xsl:for-each select="document($textrecord)//tei:item[ancestor::tei:div[@type='imprime']]">
                <xsl:variable name="ID"><xsl:value-of select="@xml:id"/></xsl:variable>
                <Manifestation><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <Text>
                        <Title><xsl:value-of select=".//tei:bibl/tei:title[not(@type)]"/></Title>
                        <xsl:for-each select="./tei:bibl//tei:title[@type='ancien']">
                            <Title><xsl:value-of select="."/></Title>
                        </xsl:for-each>
                        <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute></AssociatedWork>
                    </Text>
                    <Place>
                        <Name><xsl:value-of select=".//tei:bibl/tei:title[not(@type)]"/></Name>
                    </Place>
                    <Date><Year><xsl:value-of select=".//tei:bibl//tei:date/@notBefore"/>-<xsl:value-of select=".//tei:bibl//tei:date/@notAfter"/></Year></Date>
                    <!-- <xsl:for-each select="">
                        <Book><xsl:attribute name="id"><xsl:value-of select=""/></xsl:attribute></Book>
                    </xsl:for-each> -->
                </Manifestation>
                <xsl:for-each select=".//note[starts-with(.,'Exemplaire consulté&#160;:')]">
                    <Book>
                        <Shelfmark><xsl:value-of select="substring-after(.,'&#160;:')"/>
                            <Organisation></Organisation>
                            <Identifier></Identifier>
                        </Shelfmark>
                        <xsl:for-each select=".//tei:physDesc//tei:persName">
                            <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                <Name><xsl:value-of select="normalize-space(.)"/></Name>
                            </Participant>
                        </xsl:for-each>
                        <xsl:for-each select=".//tei:history//tei:persName">
                            <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                <Name><xsl:value-of select="normalize-space(.)"/></Name>
                            </Participant>
                        </xsl:for-each>
                        <RelatedManifestation><xsl:attribute name="id"><xsl:value-of select="$ID"/></xsl:attribute></RelatedManifestation>
                    </Book>
                </xsl:for-each>
                <xsl:for-each select="./tei:ab">
                    <Book><xsl:attribute name="id"><xsl:value-of select="tei:item/@xml:id"/></xsl:attribute>
                        <Shelfmark><xsl:value-of select="substring-after(.,'&#160;:')"/>
                            <Organisation></Organisation>
                            <Identifier></Identifier>
                        </Shelfmark>
                        <xsl:for-each select=".//tei:physDesc//tei:persName">
                            <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                <Name><xsl:value-of select="normalize-space(.)"/></Name>
                            </Participant>
                        </xsl:for-each>
                        <xsl:for-each select=".//tei:history//tei:persName">
                            <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                <Name><xsl:value-of select="normalize-space(.)"/></Name>
                            </Participant>
                        </xsl:for-each>
                        <RelatedManifestation><xsl:attribute name="id"><xsl:value-of select="$ID"/></xsl:attribute></RelatedManifestation>
                    </Book>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Transformation to Recordlist/Participant -->  
    
    <xsl:template match="textList" mode="participant">
        <!-- one loop over all text files -->
        <xsl:for-each select=".//Text">
            <xsl:variable name="textrecord"><xsl:value-of select="."/></xsl:variable>
            
            <xsl:for-each select="document($textrecord)//tei:persName[@role='r70' or @role='traducteur' or @role='copiste' or @role='enlumineur' or @role='possesseur' or @role='imprimeur-libraire']">
           <Participant>
               <Name><xsl:value-of select="."/></Name>
               <Gender>homme/femme</Gender>
           </Participant>
            </xsl:for-each> <xsl:for-each select="document($textrecord)//tei:orgName[@role='r70' or @role='traducteur' or @role='copiste' or @role='illustrateur' or @role='possesseur' or @role='imprimeur-libraire']">
                <Participant>
                    <Name><xsl:value-of select="."/></Name>
                    <Gender>organisation</Gender>
                </Participant>
            </xsl:for-each>
            </xsl:for-each>
    </xsl:template>
    
    <!-- Transformation to Recordlist/Place -->  
    
    <xsl:template match="textList" mode="place">
        <!-- one loop over all text files -->
        <xsl:for-each select=".//Text">
            <xsl:variable name="textrecord"><xsl:value-of select="."/></xsl:variable>
            
            <xsl:for-each select="document($textrecord)//tei:placeName">
                <Place>
                    <Name><xsl:value-of select="."/></Name>
                </Place>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Transformation to Recordlist/Work -->  
    
    <xsl:template match="textList" mode="work">
        <!-- one loop over all text files -->
        <xsl:for-each select=".//Text">
            <xsl:variable name="textrecord"> <xsl:value-of select="."/></xsl:variable>     
            
            <Work>
                <xsl:variable name="Name"><xsl:value-of select="normalize-space(document($textrecord)//tei:titleStmt/tei:title/tei:bibl/tei:title)"/></xsl:variable>
                <xsl:attribute name="id"><xsl:value-of select="document($textrecord)/tei:TEI/@xml:id"/></xsl:attribute>
                <Title><xsl:value-of select="normalize-space(document($textrecord)//tei:titleStmt/tei:title/tei:bibl/tei:title)"/></Title>
                <Record><xsl:value-of select="document('Records_MiroirDC.xml')//Work[contains(Title,$Name)]/@href"/></Record>
                <Concept><xsl:value-of select="document($textrecord)//tei:titleStmt/tei:title/tei:bibl/@corresp"/></Concept>
                <Text>
                    <Title><xsl:value-of select="normalize-space(document($textrecord)//tei:titleStmt/tei:title/tei:bibl/tei:title)"/><xsl:text> [latin]</xsl:text></Title>
                    <Language>latin</Language>
                    <Participant role="r70">
                        <Name><xsl:value-of select="document($textrecord)//tei:titleStmt/tei:title/tei:bibl/tei:author"/></Name>
                    </Participant>
                    <Note><xsl:value-of select="document($textrecord)//tei:text/tei:body/tei:div[@type='presentation' and tei:head='Diffusion latine']/tei:p"/></Note>
                </Text>
                <xsl:for-each select="document($textrecord)//tei:div[@type='expression' and @subtype='traduction']">
                <Text>
                    <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <Title><xsl:value-of select="//tei:titleStmt/tei:title/tei:bibl/tei:title"></xsl:value-of><xsl:text> [français]</xsl:text></Title>
                    <Record><xsl:value-of select="document('Records_MiroirDC.xml')//Work[contains(Title,$Name)]/@href"/><xsl:text>traduction/para=</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>.html</xsl:text></Record>
                    <Language>français</Language>
                    <Participant role="r70">
                        <Name><xsl:value-of select=".//tei:titleStmt/tei:title/tei:bibl/tei:author"/></Name>
                    </Participant>
                    <Participant role="r680">
                        <Name><xsl:value-of select=".//tei:header/tei:persName[@role='traducteur']"/></Name>
                    </Participant>
                </Text>
                </xsl:for-each>
            </Work>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Transformation to Recordlist/Repository -->  
    
    <xsl:template match="textList" mode="organisation">
        <!-- one loop over all text files -->
        <xsl:for-each select=".//Text">
            <xsl:variable name="textrecord"> <xsl:value-of select="."/></xsl:variable> 
            <xsl:for-each select="document($textrecord)//tei:repository">
            <Repository>
                <Country><xsl:value-of select="../tei:country"/></Country>
               <City><xsl:value-of select="../tei:settlement"/></City>
               <Organisation><xsl:value-of select="."/></Organisation>
            </Repository></xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:transform>           
