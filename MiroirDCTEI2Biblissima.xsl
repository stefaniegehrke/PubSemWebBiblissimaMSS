<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
        

<!-- Transformation des fichiers Miroir des Classiques par fichier "Text" -->
<xsl:template match="/">
    <!-- global output for all data goes here --><xsl:variable name="output_dir">./</xsl:variable> 
    <xsl:variable name="outputDate"><xsl:value-of select="current-date()"/></xsl:variable>
    <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"/>ExportBdC2_MiroirDC_Biblissima<xsl:value-of select="substring-before($outputDate,'+')"/>.xml</xsl:variable>
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
           
 
            <xsl:for-each select="document($textrecord)//tei:witness[parent::tei:listWit]">
                <xsl:variable name="idno"><xsl:value-of select="substring-after(./tei:ref/@target,'#')"/></xsl:variable>
                <xsl:variable name="idno_text"><xsl:value-of select="$idno"/><xsl:text>_</xsl:text><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:variable>
                <Book state="preserved"><xsl:attribute name="id"><xsl:value-of select="$idno"/></xsl:attribute>
                    <ObjectType></ObjectType>
                    <Shelfmark>
                        <Organisation><xsl:value-of select=".//tei:settlement"/><xsl:text>, </xsl:text><xsl:value-of select=".//tei:repository"/></Organisation>
                    <Identifier>
                        <Idno><xsl:value-of select=".//tei:msIdentifier/tei:idno"/></Idno>
                    </Identifier>
                    </Shelfmark>
                    <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]">
                        <xsl:choose>
                            <xsl:when test="count(.//tei:msContents/tei:msItem) != 1">
                                <xsl:for-each select=".//tei:msContents/tei:msItem">
                    <HasPart><PartType>unité textuelle</PartType>
                        <Pages><xsl:value-of select="./tei:locus/@from"/><xsl:text>-</xsl:text><xsl:value-of select="./tei:locus/@to"/></Pages>
                        <Text><xsl:attribute name="id"><xsl:value-of select="$idno_text"/></xsl:attribute>
                            <Title lang="lat"><xsl:value-of select="normalize-space(./tei:title)"/></Title>
                            <Title lang="fro"><xsl:value-of select="./tei:title/tei:title[@type='ancien']"/></Title>
                            <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                                <Title><xsl:value-of select="normalize-space(./tei:title/tei:title[@type='oeuvre'])"/></Title>
                                <Concept><xsl:value-of select="./tei:title/tei:title[@type='oeuvre']/@corresp"/></Concept>
                            </AssociatedWork>
                        <Language><xsl:attribute name="id"><xsl:value-of select="./tei:title/tei:lang/@xml:lang"/></xsl:attribute>
                            <xsl:value-of select="./tei:title/tei:lang[@n='lang_arrivée']"/></Language>
                       <xsl:choose>
                           <xsl:when test="contains(@xml:id,'$idno_text')">
                            <xsl:for-each select="/tei:TEI//tei:listBibl[tei:head='Editions']/tei:bibl">
                            <Edition><xsl:value-of select="."/></Edition>
                        </xsl:for-each>
                           </xsl:when>
                       </xsl:choose>
                        <Incipit></Incipit>
                        <Explicit></Explicit>
                            <xsl:for-each select="./tei:title/tei:persName">
                        <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                            <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                            <Name><xsl:value-of select="normalize-space(.)"/></Name>
                        </Participant>
                            </xsl:for-each>
                            <Note><xsl:value-of select="normalize-space(../tei:summary)"/></Note>
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
                     <xsl:otherwise>
                         <Text><xsl:attribute name="id"><xsl:value-of select="$idno_text"/></xsl:attribute>
                             <Title lang="lat"><xsl:value-of select="normalize-space(/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:title)"/></Title>
                             <Title lang="fro"><xsl:value-of select="normalize-space(/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:title/tei:title[@type='ancien'])"/></Title>
                             <AssociatedWork><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                                 <Title lang=""><xsl:value-of select="normalize-space(/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:title/tei:title[@type='oeuvre'])"/></Title>
                                 <Concept><xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:title/tei:title[@type='oeuvre']/@corresp"/></Concept>
                         </AssociatedWork>
                             <Language><xsl:attribute name="id"><xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:lang/@xml:lang"/></xsl:attribute>
                                 <xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:lang[@n='lang_arrivée']"/>
                             </Language>
                             <xsl:for-each select="/tei:TEI//tei:listBibl[tei:head='Editions']/tei:bibl">
                                 <Edition><xsl:value-of select="."/></Edition> 
                             </xsl:for-each>
                             <Incipit><xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:incipit"/></Incipit>
                             <Explicit><xsl:value-of select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:explicit"/></Explicit>
                             <xsl:for-each select="/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:msItem/tei:title/persName">
                             <Participant><xsl:attribute name="id"><xsl:value-of select="@ref"/></xsl:attribute>
                                 <xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute>
                                 <Name><xsl:value-of select="normalize-space(.)"/></Name>
                             </Participant>
                             </xsl:for-each>
                             <Note><xsl:value-of select="normalize-space(/tei:TEI//tei:item[@xml:id=$idno]//tei:msContents/tei:summary)"/></Note>
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
                        <Year><xsl:value-of select="./msDesc/history/tei:origin//origDate/@notAfter"/></Year>
                    </Date>
                        <Place>
                            <Name><xsl:value-of select="./tei:msDesc/tei:history/tei:origin//tei:origPlace"/></Name>
                        </Place>
                 <Participant id="" role="r70">
                     <Name><xsl:value-of select="/tei:TEI//tei:titleStmt/tei:title/tei:bibl/tei:author"/></Name>
                 </Participant>
                        <Format><xsl:value-of select="./tei:msDesc//tei:objectDesc/tei:extent/tei:dimensions/tei:height"/><xsl:text>x</xsl:text><xsl:value-of select="./tei:msDesc//tei:objectDesc/tei:extent/tei:dimensions/tei:width"/></Format>
                        <xsl:for-each select=".//tei:msContents/tei:msItem">    
                        <Note><xsl:value-of select="ancestor::tei:div/@xml:id"/></Note>
                        </xsl:for-each>
                        <xsl:for-each select=".//tei:term">
                        <Term><xsl:value-of select="normalize-space(.)"/></Term>
                        </xsl:for-each>
                </xsl:for-each>
            </Book>   
            </xsl:for-each>
        
        <!-- Liste of preserved manuscripts goes here -->
        
        <xsl:for-each select="document($textrecord)//tei:list[@type='deperdita']/tei:item">
            <Book state="dispersed">
                <ObjectType>manuscrit</ObjectType>
                <Text>
                    <Title></Title>
                    <AssociatedWork>
                        <xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                    </AssociatedWork>
                </Text>
            </Book>
        </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
 
    

    <!-- Transformation des fichiers "text" vers Recordlist/Work : tous dans un fichier -->  
    
    <xsl:template match="textList" mode="work">
        <!-- one loop over all text files -->
        <xsl:for-each select=".//Text">
            <xsl:variable name="textrecord"> <xsl:value-of select="."/></xsl:variable>     
            <Work><xsl:attribute name="id"><xsl:value-of select="/tei:TEI/@xml:id"/></xsl:attribute>
                <Title><xsl:value-of select="normalize-space(document($textrecord)//tei:titleStmt/tei:title/tei:bibl/tei:title)"/></Title>
                <Concept><xsl:value-of select="document($textrecord)//tei:titleStmt/tei:title/tei:bibl/@corresp"/></Concept>
                <Text>
                <Participant role="r70">
                    <Name><xsl:value-of select="document($textrecord)//tei:titleStmt/tei:title/tei:bibl/tei:author"/></Name>
                </Participant>
                </Text>
                <Note><xsl:value-of select="document($textrecord)//tei:text/tei:body/tei:div[@type='presentation']/tei:p"/></Note>
            </Work>
        </xsl:for-each>
    </xsl:template>
       
</xsl:transform>           

