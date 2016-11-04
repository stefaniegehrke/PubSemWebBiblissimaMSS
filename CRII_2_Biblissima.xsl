<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    version="2.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:marc21="http://www.loc.gov/MARC21/slim"
    xmlns:marcxchange="info:lc/xmlns/marcxchange-v1"
    xmlns:pma="http://www.phpmyadmin.net/some_doc_url/"> 
 
<!-- Transformation des fichiers "édition + incunables" vers Recordlist/Book : un fichier xml par édition - Stefanie Gehrke pour Biblissima avril-octobre 2016 -->
<xsl:template match="/">
    <xsl:variable name="output_dir">./</xsl:variable> 
    <xsl:variable name="outputDate"><xsl:value-of select="current-date()"/></xsl:variable>
    <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"/>export_test_crii_Biblissima_<xsl:value-of select="substring-before($outputDate,'+')"/>.xml</xsl:variable>
    <xsl:result-document href="{$outputFile}" method="xml"  encoding="UTF-8" indent="yes" >
        <RecordList>   
            <DataBase>CRII</DataBase>
        <xsl:apply-templates select="*" mode="manifestation"/>
        <xsl:call-template name="auth_header"/>
        </RecordList>
    </xsl:result-document>
</xsl:template>
          <xsl:template match="editionList" mode="manifestation">
            <xsl:for-each select="./edition">
                <xsl:variable name="editionrecord"><xsl:value-of select="."/></xsl:variable>
                <xsl:variable name="editionNumber"><xsl:for-each select="document($editionrecord)/marcxchange:collection//marcxchange:datafield[@tag='801']">
                    <xsl:if test="contains(./marcxchange:subfield[@code='b'],'informa')">
                        <xsl:value-of select="./marcxchange:subfield[@code='h']"/>
                    </xsl:if>
                </xsl:for-each></xsl:variable>
                <!-- Manifestation -->
                <Manifestation><xsl:attribute name="id"><xsl:value-of select="$editionNumber"/>
                  </xsl:attribute>
                    <Date><Year><xsl:value-of select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='210']/marc21:subfield[@code='d']"/></Year></Date>
                    <Place>
                        <Name><xsl:value-of select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='210']/marc21:subfield[@code='a']"/></Name>
                    </Place>
                        <xsl:if test="count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200'])=1"> 
                            <xsl:if test="count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='a'])=0 or count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='a'])=1">
                           
                                <xsl:if test="count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='i'])=0 or count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='i'])=1"> 
                             <Text><Title><xsl:if test="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='f']!=''"><xsl:value-of select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='f']"/><xsl:text>: </xsl:text></xsl:if>
                                <xsl:if test="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='a' or 'g' or 'i' or 'c']!=''">
                                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code!='f']"><xsl:value-of select="."/><xsl:text> </xsl:text></xsl:for-each>
                                </xsl:if></Title>
                                 <xsl:choose>
                                 <xsl:when test="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='1' or @ind1='2']">
                                 <Language type="non_original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='a']"/></Language>
                                 <Language type="intermediary"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='b']"/></Language>
                                 <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='c']"/></Language>
                                 </xsl:when>
                                 <xsl:otherwise>
                                 <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='0']/marc21:subfield[@code='a']"/></Language>
                                 </xsl:otherwise>
                                 </xsl:choose>
                             </Text>
                                </xsl:if>
                                <xsl:if test="count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='i'])&gt;1"> 
                                    <xsl:choose>
                                        <xsl:when test="count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='a'])=0 or count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='a'])=1">
                                            <Text>
                                                <Title><xsl:value-of select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='i']"/></Title>
                                                <xsl:choose>
                                                    <xsl:when test="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='1' or @ind1='2']">
                                                        <Language type="non_original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='a']"/></Language>
                                                        <Language type="intermediary"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='b']"/></Language>
                                                        <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='c']"/></Language>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='0']/marc21:subfield[@code='a']"/></Language>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </Text>
                                           <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='i']">
                                                <HasPart>
                                                    <PartType>textual unit</PartType>
                                                    <Text>
                                                        <Title><xsl:value-of select="."/></Title>
                                                        <xsl:choose>
                                                            <xsl:when test="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='1' or @ind1='2']">
                                                                <Language type="non_original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='a']"/></Language>
                                                                <Language type="intermediary"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='b']"/></Language>
                                                                <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='c']"/></Language>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='0']/marc21:subfield[@code='a']"/></Language>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </Text>  
                                                    <xsl:for-each select="../marc21:subfield[@code='g']">
                                                        <xsl:variable name="Name"><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></xsl:variable>
                                                    <Participant>
                                                        <xsl:attribute name="id"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:attribute>
                                                        <xsl:attribute name="role"><xsl:value-of select="substring-before(.,'.')"/></xsl:attribute>
                                                        <Name><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></Name>
                                                        <Note><xsl:value-of select="."/></Note>
                                                    </Participant></xsl:for-each>
                                                </HasPart>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each-group select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/*" group-starting-with="marc21:subfield[@code='a']">
                                                <xsl:for-each select="current-group()">
                                                    <HasPart>
                                                    <PartType>textual unit</PartType>
                                                    <Text>
                                                        <Title><xsl:value-of select="."/></Title>
                                                        <xsl:choose>
                                                            <xsl:when test="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='1' or @ind1='2']">
                                                                <Language type="non_original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='a']"/></Language>
                                                                <Language type="intermediary"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='b']"/></Language>
                                                                <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='c']"/></Language>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='0']/marc21:subfield[@code='a']"/></Language>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </Text>  
                                                        <xsl:for-each select="../marc21:subfield[@code='g']">
                                                            <xsl:variable name="Name"><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></xsl:variable>
                                                            <Participant>
                                                                <xsl:attribute name="id"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:attribute>
                                                                <xsl:attribute name="role"><xsl:value-of select="substring-before(.,'.')"/></xsl:attribute>
                                                                <Name><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></Name>
                                                                <Note><xsl:value-of select="."/></Note>
                                                            </Participant></xsl:for-each>
                                                </HasPart></xsl:for-each>
                                            </xsl:for-each-group>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if></xsl:if></xsl:if>
                    
                   <xsl:if test="count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200'])&gt;1"> 
                       <xsl:if test="count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='i'])=0 or count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='i'])=1"> 
                        <xsl:choose>
                            <xsl:when test="count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='a'])=0 or count(document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']/marc21:subfield[@code='a'])=1">
                        <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']">
                            <HasPart>
                                <PartType>textual unit</PartType>
                                <Text>
                                    <Title><xsl:value-of select="(.)"/></Title>
                                    <xsl:choose>
                                        <xsl:when test="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='1' or @ind1='2']">
                                            <Language type="non_original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='a']"/></Language>
                                            <Language type="intermediary"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='b']"/></Language>
                                            <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='c']"/></Language>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='0']/marc21:subfield[@code='a']"/></Language>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Text> 
                                <xsl:for-each select="../marc21:subfield[@code='g']">
                                    <xsl:variable name="Name"><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></xsl:variable>
                                    <Participant>
                                        <xsl:attribute name="id"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:attribute>
                                        <xsl:attribute name="role"><xsl:value-of select="substring-before(.,'.')"/></xsl:attribute>
                                        <Name><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></Name>
                                        <Note><xsl:value-of select="."/></Note>
                                    </Participant></xsl:for-each>
                            </HasPart>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']">
                            <xsl:choose>
                                <xsl:when test="count(./marc21:subfield['a'])&gt;1">
                                    <xsl:for-each-group select="./*" group-starting-with="marc21:subfield[@code='a']">
                                    <HasPart>
                                        <PartType>textual unit</PartType>
                                        <Text>
                                            <Title><xsl:for-each select="current-group()"> <xsl:value-of select="."/></xsl:for-each></Title>
                                            <xsl:choose>
                                                <xsl:when test="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='1' or @ind1='2']">
                                                    <Language type="non_original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='a']"/></Language>
                                                    <Language type="intermediary"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='b']"/></Language>
                                                    <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='c']"/></Language>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='0']/marc21:subfield[@code='a']"/></Language>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </Text>  
                                        <xsl:for-each select="../marc21:subfield[@code='g']">
                                            <xsl:variable name="Name"><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></xsl:variable>
                                            <Participant>
                                                <xsl:attribute name="id"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:attribute>
                                                <xsl:attribute name="role"><xsl:value-of select="substring-before(.,'.')"/></xsl:attribute>
                                                <Name><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></Name>
                                                <Note><xsl:value-of select="."/></Note>
                                            </Participant></xsl:for-each>
                                    </HasPart>
                                </xsl:for-each-group>
                             </xsl:when>
                             <xsl:otherwise>
                                 <HasPart>
                                     <PartType>textual unit</PartType>
                                     <Text>
                                         <Title><xsl:value-of select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='200']"/></Title>
                                         <xsl:choose>
                                             <xsl:when test="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='1' or @ind1='2']">
                                                 <Language type="non_original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='a']"/></Language>
                                                 <Language type="intermediary"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='b']"/></Language>
                                                 <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101']/marc21:subfield[@code='c']"/></Language>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                 <Language type="original"><xsl:value-of select="document($editionrecord)//marcxchange:collection//marcxchange:datafield[@tag='101'][@ind1='0']/marc21:subfield[@code='a']"/></Language>
                                             </xsl:otherwise>
                                         </xsl:choose>
                                     </Text>  
                                     <xsl:for-each select="../marc21:subfield[@code='g']">
                                         <xsl:variable name="Name"><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></xsl:variable>
                                         <Participant>
                                             <xsl:attribute name="id"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:attribute>
                                             <xsl:attribute name="role"><xsl:value-of select="substring-before(.,'.')"/></xsl:attribute>
                                             <Name><xsl:value-of select="substring-before(substring-after(.,'. '),'.')"/></Name>
                                             <Note><xsl:value-of select="."/></Note>
                                         </Participant></xsl:for-each>
                                 </HasPart>
                             </xsl:otherwise>
                         </xsl:choose>
                        </xsl:for-each>
                    </xsl:otherwise>
                    </xsl:choose>
                    </xsl:if>
                   </xsl:if>
              <!-- Auteur 1 -->
                     <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='700'][marc21:subfield[@code='4']='070']">
                         <xsl:variable name="Name"><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                         <xsl:variable name="FirstName"><xsl:value-of select="./marc21:subfield[@code='b']"/></xsl:variable>
                         <xsl:variable name="SurName"><xsl:value-of select="./marc21:subfield[@code='a']"/></xsl:variable>
                         <Participant role="r70"><xsl:attribute name="id">
                             <xsl:choose><xsl:when test="document('auth_header.xml')//marc21:record/marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:when>
                                 <xsl:otherwise><xsl:for-each select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/contains(marc21:subfield[@code='b'],$FirstName)]"><xsl:if test="./marc21:datafield[@tag='100']/contains(marc21:subfield[@code='a'],$SurName)"><xsl:value-of select="./marc21:controlfield[@tag='001']"/></xsl:if></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
                             <Name><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="./marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='a']"/>
                                <xsl:if test="./marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marc21:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='f']"/>)</xsl:if></Name>
                        <xsl:if test="./marc21:subfield[@code='3'] !=''">
                        <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                        </xsl:if>
                    </Participant>
                    </xsl:for-each>
              <!-- Auteur 2 -->
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='02']">
                        <xsl:variable name="Name"><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                        <xsl:variable name="FirstName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/></xsl:variable>
                        <xsl:variable name="SurName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                        <Participant role="r70"><xsl:attribute name="id">
                            <xsl:choose><xsl:when test="document('auth_header.xml')//marc21:record/marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:when>
                                <xsl:otherwise><xsl:for-each select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/contains(marc21:subfield[@code='b'],$FirstName)]"><xsl:if test="./marc21:datafield[@tag='100']/contains(marc21:subfield[@code='a'],$SurName)"><xsl:value-of select="./marc21:controlfield[@tag='001']"/></xsl:if></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
                            <Name><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="./marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='a']"/>
                                <xsl:if test="./marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marc21:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='f']"/>)</xsl:if></Name>
                            <xsl:if test="./marc21:subfield[@code='3'] !=''">
                            <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                            </xsl:if>
                            </Participant>
                    </xsl:for-each>
              <!-- Auteur 3 -->
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='701'][marc21:subfield[@code='4']='070']">
                        <xsl:variable name="Name"><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                        <xsl:variable name="FirstName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/></xsl:variable>
                        <xsl:variable name="SurName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                        <Participant role="r70"><xsl:attribute name="id">
                            <xsl:choose><xsl:when test="document('auth_header.xml')//marc21:record/marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:when>
                                <xsl:otherwise><xsl:for-each select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/contains(marc21:subfield[@code='b'],$FirstName)]"><xsl:if test="./marc21:datafield[@tag='100']/contains(marc21:subfield[@code='a'],$SurName)"><xsl:value-of select="./marc21:controlfield[@tag='001']"/></xsl:if></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
                            <Name><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="./marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='a']"/>
                                <xsl:if test="./marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marc21:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='f']"/>)</xsl:if></Name>
                            <xsl:if test="./marc21:subfield[@code='3'] !=''">
                                <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                            </xsl:if>
                        </Participant>
                    </xsl:for-each>
              <!-- Traducteur -->
              <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='701'][marc21:subfield[@code='4']='730']">
                  <xsl:variable name="Name"><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <xsl:variable name="FirstName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/></xsl:variable>
                  <xsl:variable name="SurName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <Participant role="r680"><xsl:attribute name="id">
                      <xsl:choose><xsl:when test="document('auth_header.xml')//marc21:record/marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:when>
                          <xsl:otherwise><xsl:for-each select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/contains(marc21:subfield[@code='b'],$FirstName)]"><xsl:if test="./marc21:datafield[@tag='100']/contains(marc21:subfield[@code='a'],$SurName)"><xsl:value-of select="./marc21:controlfield[@tag='001']"/></xsl:if></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
                      <Name><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="./marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='a']"/>
                          <xsl:if test="./marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marc21:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='f']"/>)</xsl:if></Name>
                      <xsl:if test="./marc21:subfield[@code='3'] !=''">
                          <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                      </xsl:if>
                  </Participant>
              </xsl:for-each>
              <!-- Commentateur 1 -->
              <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='701'][marc21:subfield[@code='4']='212']">
                  <xsl:variable name="Name"><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <xsl:variable name="FirstName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/></xsl:variable>
                  <xsl:variable name="SurName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <Participant role="r120"><xsl:attribute name="id">
                      <xsl:choose><xsl:when test="document('auth_header.xml')//marc21:record/marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:when>
                          <xsl:otherwise><xsl:for-each select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/contains(marc21:subfield[@code='b'],$FirstName)]"><xsl:if test="./marc21:datafield[@tag='100']/contains(marc21:subfield[@code='a'],$SurName)"><xsl:value-of select="./marc21:controlfield[@tag='001']"/></xsl:if></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
                      <Name><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="./marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='a']"/>
                          <xsl:if test="./marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marc21:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='f']"/>)</xsl:if></Name>
                      <xsl:if test="./marc21:subfield[@code='3'] !=''">
                          <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                      </xsl:if>
                  </Participant>
              </xsl:for-each>
              <!-- Editeur scientifique -->
              <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='702'][marc21:subfield[@code='4']='340']">
                  <xsl:variable name="Name"><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <xsl:variable name="FirstName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/></xsl:variable>
                  <xsl:variable name="SurName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <Participant role="r360"><xsl:attribute name="id">
                      <xsl:choose><xsl:when test="document('auth_header.xml')//marc21:record/marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:when>
                          <xsl:otherwise><xsl:for-each select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/contains(marc21:subfield[@code='b'],$FirstName)]"><xsl:if test="./marc21:datafield[@tag='100']/contains(marc21:subfield[@code='a'],$SurName)"><xsl:value-of select="./marc21:controlfield[@tag='001']"/></xsl:if></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
                      <Name><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="./marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='a']"/>
                                <xsl:if test="./marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marc21:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='f']"/>)</xsl:if></Name>
                            <Note><xsl:value-of select="./marc21:subfield[@code='c']"/></Note>
                            <xsl:if test="./marc21:subfield[@code='3'] !=''">
                                <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                            </xsl:if>
                        </Participant>
                    </xsl:for-each> 
              <!-- Imprimeur -->
              <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='702'][marc21:subfield[@code='4']='610']">
                  <xsl:variable name="Name"><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <xsl:variable name="FirstName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/></xsl:variable>
                  <xsl:variable name="SurName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <Participant role="r3260"><xsl:attribute name="id">
                      <xsl:choose><xsl:when test="document('auth_header.xml')//marc21:record/marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:when>
                          <xsl:otherwise><xsl:for-each select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/contains(marc21:subfield[@code='b'],$FirstName)]"><xsl:if test="./marc21:datafield[@tag='100']/contains(marc21:subfield[@code='a'],$SurName)"><xsl:value-of select="./marc21:controlfield[@tag='001']"/></xsl:if></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
                      <Name><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="./marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='a']"/>
                            <xsl:if test="./marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marc21:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='f']"/>)</xsl:if></Name>
                        <Note><xsl:value-of select="./marc21:subfield[@code='c']"/></Note>
                      <xsl:if test="./marc21:subfield[@code='3'] !=''">
                          <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                      </xsl:if>
                    </Participant>
            </xsl:for-each> 
              <!-- Commentateur 2 -->
              <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='702'][marc21:subfield[@code='4']='212']">
                  <xsl:variable name="Name"><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <xsl:variable name="FirstName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='b'])"/></xsl:variable>
                  <xsl:variable name="SurName"><xsl:value-of select="normalize-space(./marc21:subfield[@code='a'])"/></xsl:variable>
                  <Participant role="r120"><xsl:attribute name="id">
                      <xsl:choose><xsl:when test="document('auth_header.xml')//marc21:record/marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name"><xsl:value-of select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/marc21:subfield[@code='a']=$Name]/marc21:controlfield[@tag='001']"/></xsl:when>
                          <xsl:otherwise><xsl:for-each select="document('auth_header.xml')//marc21:record[marc21:datafield[@tag='100']/contains(marc21:subfield[@code='b'],$FirstName)]"><xsl:if test="./marc21:datafield[@tag='100']/contains(marc21:subfield[@code='a'],$SurName)"><xsl:value-of select="./marc21:controlfield[@tag='001']"/></xsl:if></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
                      <Name><xsl:if test="./marc21:subfield[@code='b'] !=''"><xsl:value-of select="./marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='a']"/>
                          <xsl:if test="./marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marc21:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marc21:subfield[@code='f']"/>)</xsl:if></Name>
                      <Note><xsl:value-of select="./marc21:subfield[@code='c']"/></Note>
                      <xsl:if test="./marc21:subfield[@code='3'] !=''">
                          <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                      </xsl:if>
                  </Participant>
              </xsl:for-each>
                    <Format><xsl:value-of select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='215']/marc21:subfield[@code='d']"/></Format>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='304']">
                        <Note><xsl:value-of select="./marc21:subfield[@code='a']"/></Note> 
                    </xsl:for-each>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='305']">
                        <Note><xsl:value-of select="./marc21:subfield[@code='a']"/></Note>
                    </xsl:for-each>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='306']">
                        <Note><xsl:value-of select="./marc21:subfield[@code='a']"/></Note>
                    </xsl:for-each>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='307']">
                        <Note><xsl:value-of select="./marc21:subfield[@code='a']"/></Note>
                    </xsl:for-each>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='309']">
                        <Note><xsl:value-of select="./marc21:subfield[@code='a']"/></Note>
                    </xsl:for-each>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='314']">
                        <Note><xsl:value-of select="./marc21:subfield[@code='a']"/></Note> 
                    </xsl:for-each>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marc21:datafield[@tag='327']">
                        <Note><xsl:value-of select="./marc21:subfield[@code='a']"/></Note>
                    </xsl:for-each>
                  <xsl:for-each select="document($editionrecord)/marcxchange:collection//marcxchange:datafield[@tag='321']">
                     <BibliographicReference><xsl:if test="./marc21:subfield[@code='a'] !=''"><xsl:value-of select="./marc21:subfield[@code='a']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marc21:subfield[@code='c']"/></BibliographicReference>
                    </xsl:for-each>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marcxchange:datafield[@tag='321'][marc21:subfield[@code='u']]">
                        <xsl:if test="not(starts-with(./marc21:subfield[@code='u'],'http'))"><BibliographicReference><xsl:value-of select="./marc21:subfield[@code='u']"/></BibliographicReference></xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="document($editionrecord)/marcxchange:collection//marcxchange:datafield[@tag='930']">
                        <xsl:if test="./marcxchange:subfield[@code='5'] !='' and not(contains(./marcxchange:subfield[@code='5'],'COTE'))">
                        <Book><xsl:attribute name="id"><xsl:value-of select="./marcxchange:subfield[@code='5']"/></xsl:attribute></Book>
                        </xsl:if>
                        <xsl:if test="./marcxchange:subfield[@code='5'] !='' and contains(./marcxchange:subfield[@code='5'],'COTE') or contains(./marcxchange:subfield[@code='5'],'imperfect') ">
                            <Book state="preserved"><xsl:attribute name="id"><xsl:value-of select="./marcxchange:subfield[@code='5']"/></xsl:attribute>
                            <ObjectType>Livre attesté</ObjectType>
                            </Book>
                        </xsl:if>
                    </xsl:for-each>
                </Manifestation>
                
                <!-- Book -->
                <!-- preserved -->
                    <xsl:for-each-group select="document($editionrecord)/marcxchange:collection//marcxchange:datafield" group-starting-with=".[@tag='930']">   
                        <xsl:choose>
                        <xsl:when test="not(contains(current-group()[1]/marcxchange:subfield[@code='5'],'COTE')) and not(contains(current-group()[1]/marcxchange:subfield[@code='5'],'imperfect'))">
                        <Book state="preserved"><xsl:attribute name="id"><xsl:value-of select="current-group()[1]/marcxchange:subfield[@code='5']"/></xsl:attribute>
                        <ObjectType uri="http://data.biblissima.fr/thesaurus/resource/ark:/43093/d15ea98a-5360-4b3f-9a74-b077d82cae65">preserved incunabula</ObjectType>
                        <Shelfmark> 
                            <Organisation><xsl:attribute name="id"><xsl:value-of select="substring-before(substring-after(current-group()[1]/marcxchange:subfield[@code='5'],'FR-'), ':')"/></xsl:attribute><xsl:value-of select="./marcxchange:subfield[@code='b']"/></Organisation>
                            <Identifier>
                                <Idno><xsl:value-of select="current-group()[1]/marcxchange:subfield[@code='a']"/></Idno>
                            </Identifier>
                        </Shelfmark>
                        
                        <xsl:for-each select="current-group()">
                            <xsl:choose>
                                <xsl:when test=".[@tag='702']">
                                    <Participant role="r4010">
                                        <Name><xsl:if test="./marcxchange:subfield[@code='b'] !=''"><xsl:value-of select="./marcxchange:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marcxchange:subfield[@code='a']"/>
                                            <xsl:if test="./marcxchange:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marcxchange:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marcxchange:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marcxchange:subfield[@code='f']"/>)</xsl:if></Name>
                                        <Note><xsl:value-of select="./marcxchange:subfield[@code='c']"/></Note>
                                        <xsl:choose>
                                            <xsl:when test="not(contains(./marcxchange:subfield[@code='f'],'J.-C.'))">
                                        <Birth><Date><xsl:value-of select="substring-before(./marcxchange:subfield[@code='f'],'-')"/></Date></Birth>
                                        <Death><Date><xsl:value-of select="substring-after(./marcxchange:subfield[@code='f'],'-')"/></Date></Death>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <Note><xsl:value-of select="./marcxchange:subfield[@code='f']"/></Note>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </Participant> 
                                </xsl:when>
                                <xsl:when test=".[@tag='712']">
                                    <Participant role="r4010">
                                        <Name><xsl:if test="./marcxchange:subfield[@code='b'] !=''"><xsl:value-of select="./marcxchange:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:if test="./marcxchange:subfield[@code='a'] !=''"><xsl:value-of select="./marcxchange:subfield[@code='a']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marcxchange:subfield[@code='c']"/>
                                            <xsl:if test="./marcxchange:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marcxchange:subfield[@code='d']"/>)</xsl:if><xsl:if test="./marcxchange:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="./marcxchange:subfield[@code='f']"/>)</xsl:if></Name>
                                <xsl:choose>
                                            <xsl:when test="contains(./marcxchange:subfield[@code='f'],'-')">
                                        <Birth><Date><xsl:value-of select="substring-before(./marcxchange:subfield[@code='f'],'-')"/></Date></Birth>
                                        <Death><Date><xsl:value-of select="substring-after(./marcxchange:subfield[@code='f'],'-')"/></Date></Death>
                                            </xsl:when>
                                        <xsl:otherwise>
                                        <Note><xsl:value-of select="./marcxchange:subfield[@code='f']"/></Note>
                                        </xsl:otherwise>
                                        </xsl:choose>
                                    </Participant>
                                    
                                </xsl:when>
                                <xsl:when test=".[@tag='722']">
                                    <Participant role="r4010">
                                        <Name><xsl:if test="marcxchange:subfield[@code='b'] !=''"><xsl:value-of select="marcxchange:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:if test="marcxchange:subfield[@code='a'] !=''"><xsl:value-of select="marcxchange:subfield[@code='a']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="marcxchange:subfield[@code='c']"/>
                                            <xsl:if test="marc21:subfield[@code='d'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="marc21:subfield[@code='d']"/>)</xsl:if><xsl:if test="marcxchange:subfield[@code='f'] !=''"><xsl:text> (</xsl:text><xsl:value-of select="marcxchange:subfield[@code='f']"/>)</xsl:if></Name>
                                        <xsl:choose>
                                            <xsl:when test="contains(./marcxchange:subfield[@code='f'],'-')">
                                                <Birth><Date><xsl:value-of select="substring-before(./marcxchange:subfield[@code='f'],'-')"/></Date></Birth>
                                                <Death><Date><xsl:value-of select="substring-after(./marcxchange:subfield[@code='f'],'-')"/></Date></Death>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <Note><xsl:value-of select="./marcxchange:subfield[@code='f']"/></Note>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </Participant>
                                    
                                </xsl:when>
                                
                                  <!-- notes exemplaires -->
                                <xsl:when test=".[@tag='317' and marcxchange:subfield[@code='a'] !='']">
                                    <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                </xsl:when>
                                <xsl:when test=".[@tag='390' and marcxchange:subfield[@code='a'] !='']">
                                    <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note><!-- note exemplaire sur le support -->
                                </xsl:when>
                                <xsl:when test=".[@tag='391' and marcxchange:subfield[@code='a'] !='']"> 
                                    <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                </xsl:when>
                                <xsl:when test=".[@tag='392']">
                                    <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                </xsl:when>
                                <xsl:when test=".[@tag='393']">
                                    <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                </xsl:when>
                                <xsl:when test=".[@tag='394']">
                                    <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                </xsl:when>
                                <xsl:when test=".[@tag='395']">
                                    <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                </xsl:when>                 
                                <xsl:when test=".[@tag='396']">
                                    <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                </xsl:when>
                                <xsl:when test=".[@tag='309']">
                                    <DigitalSurrogate type="integral"><xsl:value-of select="marcxchange:subfield[@code='u']"/></DigitalSurrogate> 
                                </xsl:when>
                                <xsl:when test=".[@tag='456']">
                                    <DigitalSurrogate type="integral"><xsl:value-of select="marcxchange:subfield[@code='u']"/></DigitalSurrogate>  
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>  
                    <RelatedManifestation>
                        <xsl:attribute name="id"><xsl:value-of select="$editionNumber"/></xsl:attribute>
                    </RelatedManifestation>
                    </Book>  
                        </xsl:when>
                        
              <!-- attested -->
                            <xsl:when test="contains(current-group()[1]/marcxchange:subfield[@code='5'],'cote') or contains(current-group()[1]/marcxchange:subfield[@code='5'],'imperfect')">
                            <Book state="attested"><xsl:attribute name="id"><xsl:value-of select="current-group()[1]/marcxchange:subfield[@code='5']"/></xsl:attribute>
                                <ObjectType uri="http://data.biblissima.fr/thesaurus/resource/ark:/43093/d15ea98a-5360-4b3f-9a74-b077d82cae65">attested incunabula</ObjectType>
                                <xsl:for-each select="current-group()">
                                    <xsl:choose>
                                        <xsl:when test=".[@tag='702']">
                                            <Participant><xsl:attribute name="role"><xsl:value-of select="r4010"/></xsl:attribute>
                                                <Name><xsl:if test="./marcxchange:subfield[@code='b'] !=''"><xsl:value-of select="./marcxchange:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marcxchange:subfield[@code='a']"/></Name>
                                                <Note><xsl:value-of select="./marcxchange:subfield[@code='c']"/></Note>
                                                <xsl:choose>
                                                    <xsl:when test="not(contains(./marcxchange:subfield[@code='f'],'J.-C.'))">
                                                        <Birth><Date><xsl:value-of select="substring-before(./marcxchange:subfield[@code='f'],'-')"/></Date></Birth>
                                                        <Death><Date><xsl:value-of select="substring-after(./marcxchange:subfield[@code='f'],'-')"/></Date></Death>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <Note><xsl:value-of select="./marcxchange:subfield[@code='f']"/></Note>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </Participant> 
                                        </xsl:when>
                                        <xsl:when test=".[@tag='712']">
                                            <Participant><xsl:attribute name="role"><xsl:value-of select="r4010"/></xsl:attribute>
                                                <Name><xsl:if test="./marcxchange:subfield[@code='b'] !=''"><xsl:value-of select="./marcxchange:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:if test="./marcxchange:subfield[@code='a'] !=''"><xsl:value-of select="./marcxchange:subfield[@code='a']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="./marcxchange:subfield[@code='c']"/></Name>
                                                
                                                <xsl:choose>
                                                    <xsl:when test="contains(./marcxchange:subfield[@code='f'],'-')">
                                                        <Birth><Date><xsl:value-of select="substring-before(./marcxchange:subfield[@code='f'],'-')"/></Date></Birth>
                                                        <Death><Date><xsl:value-of select="substring-after(./marcxchange:subfield[@code='f'],'-')"/></Date></Death>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <Note><xsl:value-of select="./marcxchange:subfield[@code='f']"/></Note>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </Participant>
                                        </xsl:when>
                                        
                                        <!-- notes exemplaires -->
                                        <xsl:when test=".[@tag='317' and marcxchange:subfield[@code='a'] !='']">
                                            <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                        </xsl:when>
                                        <xsl:when test=".[@tag='390' and marcxchange:subfield[@code='a'] !='']">
                                            <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                        </xsl:when>
                                        <xsl:when test=".[@tag='391' and marcxchange:subfield[@code='a'] !='']"> 
                                            <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                        </xsl:when>
                                        <xsl:when test=".[@tag='392']">
                                            <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                        </xsl:when>
                                        <xsl:when test=".[@tag='393']">
                                            <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                        </xsl:when>
                                        <xsl:when test=".[@tag='394']">
                                            <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                        </xsl:when>
                                        <xsl:when test=".[@tag='395']">
                                            <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                        </xsl:when>                 
                                        <xsl:when test=".[@tag='396']">
                                            <Note><xsl:value-of select="marcxchange:subfield[@code='a']"/></Note>
                                        </xsl:when>
                                        <xsl:when test=".[@tag='309']">
                                            <DigitalSurrogate type="integral"><xsl:value-of select="marcxchange:subfield[@code='u']"/></DigitalSurrogate> 
                                        </xsl:when>
                                        <xsl:when test=".[@tag='456']">
                                            <DigitalSurrogate type="integral"><xsl:value-of select="marcxchange:subfield[@code='u']"/></DigitalSurrogate>  
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:for-each>  
                                <RelatedManifestation>
                                    <xsl:attribute name="id"><xsl:value-of select="$editionNumber"/></xsl:attribute>
                                </RelatedManifestation>
                            </Book>  
                        </xsl:when>
                        </xsl:choose>
                    </xsl:for-each-group>
            </xsl:for-each>
        </xsl:template>

    
<!-- Transformation des fichier "auth_header" vers Recordlist/Participant et Recordlist/Collection : tous dans un fichier -->
        
    <xsl:template name="auth_header">
        <xsl:variable name="AuthHeader">auth_header.xml</xsl:variable>
        <!-- one loop over all edition files -->
        <xsl:for-each select="document($AuthHeader)/pma_xml_export//marc21:record">
            <xsl:choose>
                <xsl:when test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'], 'PERSO_NAME')">
                    <Participant><xsl:attribute name="id"><xsl:value-of select=".//marc21:controlfield[@tag='001']"/></xsl:attribute>
                        <xsl:for-each select=".//marc21:datafield[@tag='100']">
                            <xsl:if test="./marc21:subfield[@code='3'] !=''">
                                <Concept><xsl:value-of select="./marc21:subfield[@code='3']"/></Concept>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select=".//marc21:datafield[@tag='033']">
                            <xsl:if test="./marc21:subfield[@code='a'] !=''">
                        <Concept><xsl:value-of select="./marc21:subfield[@code='a']"/></Concept>
                            </xsl:if>
                        </xsl:for-each>
                        <Name><xsl:value-of select=".//marc21:datafield[@tag='130']/marc21:subfield[@code='']"/></Name>
                        <Name><xsl:if test=".//marc21:datafield[@tag='100']/marc21:subfield[@code='b'] !=''"><xsl:value-of select=".//marc21:datafield[@tag='100']/marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select=".//marc21:datafield[@tag='100']/marc21:subfield[@code='a']"/></Name>
                        <AltName><xsl:value-of select=".//marc21:datafield[@tag='400']/marc21:subfield[@code='a']"/></AltName>
                        <Gender>homme/femme</Gender>
                        <xsl:choose>
                            <xsl:when test="not(contains(./marcxchange:subfield[@code='f'],'J.-C.'))">
                        <Birth>
                            <Date><xsl:value-of select="substring-before(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Birth>
                        <Death>
                            <Date><xsl:value-of select="substring-after(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Death>
                            </xsl:when>
                            <xsl:otherwise><Note><xsl:value-of select="./marc21:subfield[@code='f']"/></Note></xsl:otherwise>
                        </xsl:choose>
                            <Occupation><xsl:value-of select=".//marc21:datafield[@tag='100']/marc21:subfield[@code='c']"/></Occupation>
                        <xsl:if test=".//marc21:datafield[@tag='663']/marc21:subfield[@code='a'] !=''">
                        <Record><xsl:value-of select=".//marc21:datafield[@tag='663']/marc21:subfield[@code='a']"/></Record>
                        </xsl:if>
                    </Participant> 
                </xsl:when>
                <xsl:when test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'], 'POSS')">
            <xsl:choose>
                <xsl:when test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'], 'PERSO')">
                    <Participant><xsl:attribute name="id"><xsl:value-of select=".//marc21:controlfield[@tag='001']"/></xsl:attribute><xsl:attribute name="role"><xsl:if test="./marc21:datafield[@tag='200' or @tag='210' or @tag='215' or @tag='220']/marc21:subfield[@code='a'] != ''">r4010</xsl:if></xsl:attribute>
                        <Name><xsl:if test=".//marc21:datafield[@tag='200']/marc21:subfield[@code='b'] !=''"><xsl:value-of select=".//marc21:datafield[@tag='200']/marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select=".//marc21:datafield[@tag='200']/marc21:subfield[@code='a']"/></Name>
                        <xsl:for-each select=".//marc21:datafield[@tag='033']">
                            <xsl:if test="./marc21:subfield[@code='a'] !=''">
                        <Concept><xsl:value-of select="./marc21:subfield[@code='a']"/></Concept>
                            </xsl:if>
                        </xsl:for-each>
                        <Gender>homme/femme</Gender>
                        <Note><xsl:value-of select=".//marc21:datafield[@tag='340']/marc21:subfield[@code='a']"/></Note>
                        <Note><xsl:value-of select=".//marc21:datafield[@tag='200']/marc21:subfield[@code='f']"/></Note>
                        <xsl:choose>
                            <xsl:when test="not(contains(./marcxchange:subfield[@code='f'],'J.-C.'))">
                        <Birth>
                            <Date><xsl:value-of select="substring-before(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Birth>
                        <Death>
                            <Date><xsl:value-of select="substring-after(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Death>
                            </xsl:when>
                            <xsl:otherwise>
                                <Note><xsl:value-of select="./marc21:subfield[@code='f']"/></Note>
                            </xsl:otherwise>
                        </xsl:choose>
                        <Occupation><xsl:value-of select=".//marc21:datafield[@tag='100']/marc21:subfield[@code='c']"/></Occupation>
                        <Note></Note>
                        <Record><xsl:value-of select=".//marc21:datafield[@tag='663']/marc21:subfield[@code='a']"/></Record>
                    </Participant> 
                </xsl:when>
                <xsl:when test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'], 'CORPO')">
                    <Participant><xsl:attribute name="id"><xsl:value-of select=".//marc21:controlfield[@tag='001']"/></xsl:attribute><xsl:attribute name="role"><xsl:if test="./marc21:datafield[@tag='200' or @tag='210' or @tag='215' or @tag='220']/marc21:subfield[@code='a'] != ''">r4010</xsl:if></xsl:attribute>
                        <Name><xsl:value-of select=".//marc21:datafield[@tag='210']/marc21:subfield[@code='a']"/><xsl:text> </xsl:text><xsl:if test=".//marc21:datafield[@tag='210']/marc21:subfield[@code='b'] !=''"><xsl:text> </xsl:text><xsl:value-of select=".//marc21:datafield[@tag='210']/marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select=".//marc21:datafield[@tag='210']/marc21:subfield[@code='c']"/></Name>
                        <xsl:for-each select=".//marc21:datafield[@tag='033']">
                            <xsl:if test="./marc21:subfield[@code='a'] !=''">
                        <Concept><xsl:value-of select="./marc21:subfield[@code='a']"/></Concept>
                        </xsl:if></xsl:for-each>
                        <Gender>Organisation</Gender>
                        <xsl:choose>
                            <xsl:when test="not(contains(./marcxchange:subfield[@code='f'],'J.-C.'))">
                        <Birth>
                            <Date><xsl:value-of select="substring-before(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Birth>
                        <Death>
                            <Date><xsl:value-of select="substring-after(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Death>
                            </xsl:when>
                            <xsl:otherwise>
                                <Note><xsl:value-of select="./marc21:subfield[@code='f']"/></Note>
                            </xsl:otherwise>
                        </xsl:choose>
                        <Occupation><xsl:value-of select=".//marc21:datafield[@tag='100']/marc21:subfield[@code='c']"/></Occupation>
                        <Note></Note>
                        <Record><xsl:value-of select=".//marc21:datafield[@tag='663']/marc21:subfield[@code='a']"/></Record>
                    </Participant>
                </xsl:when>
                
                <xsl:when test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'], 'FAM')">
                    <Participant><xsl:attribute name="id"><xsl:value-of select=".//marc21:controlfield[@tag='001']"/></xsl:attribute><xsl:attribute name="role"><xsl:if test="./marc21:datafield[@tag='200' or @tag='210' or @tag='215' or @tag='220']/marc21:subfield[@code='a'] != ''">r4010</xsl:if></xsl:attribute>
                        <Name><xsl:value-of select=".//marc21:datafield[@tag='220']/marc21:subfield[@code='a']"/></Name>
                        <Concept><xsl:value-of select=".//marc21:datafield[@tag='033']/marc21:subfield[@code='a']"/></Concept>
                        <Gender>Organisation</Gender>
                        <Birth>
                            <Date><xsl:value-of select="substring-before(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Birth>
                        <Death>
                            <Date><xsl:value-of select="substring-after(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Death>
                        <Occupation><xsl:value-of select=".//marc21:datafield[@tag='100']/marc21:subfield[@code='c']"/></Occupation>
                      <Record><xsl:value-of select=".//marc21:datafield[@tag='663']/marc21:subfield[@code='a']"/></Record>
                    </Participant>
                </xsl:when>
            </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <Participant><xsl:attribute name="id"><xsl:value-of select=".//marc21:controlfield[@tag='001']"/></xsl:attribute><xsl:attribute name="role"><xsl:if test="./marc21:datafield[@tag='200' or @tag='210' or @tag='215' or @tag='220']/marc21:subfield[@code='a'] != ''">r4010</xsl:if></xsl:attribute>
                        <Name><xsl:if test=".//marc21:datafield[@tag='200']/marc21:subfield[@code='b'] !=''"><xsl:value-of select=".//marc21:datafield[@tag='200']/marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select=".//marc21:datafield[@tag='200']/marc21:subfield[@code='a']"/></Name>
                        <Concept><xsl:value-of select=".//marc21:datafield[@tag='033']/marc21:subfield[@code='a']"/></Concept>
                        <Gender>homme/femme</Gender>
                        <Note><xsl:value-of select=".//marc21:datafield[@tag='340']/marc21:subfield[@code='a']"/></Note>
                        <Note><xsl:value-of select=".//marc21:datafield[@tag='200']/marc21:subfield[@code='f']"/></Note>
                        <Birth>
                            <Date><xsl:value-of select="substring-before(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Birth>
                        <Death>
                            <Date><xsl:value-of select="substring-after(.//marc21:datafield[@tag='100']/marc21:subfield[@code='f'],'-')"/></Date>
                        </Death>
                        <Occupation><xsl:value-of select=".//marc21:datafield[@tag='100']/marc21:subfield[@code='c']"/></Occupation>
                        <Record><xsl:value-of select=".//marc21:datafield[@tag='663']/marc21:subfield[@code='a']"/></Record>
                    </Participant>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each> -->
        
        <!-- Transformation des fichiers "auth-header" vers Recordlist/Collection : tous dans un fichier -->    
        
          <xsl:for-each select="document($AuthHeader)/pma_xml_export//marc21:record"> 
            <xsl:if test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'],'POSS')">
                <Collection>
                    <xsl:choose>
                        <xsl:when test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'], 'PERSO')">
                    <Participant><xsl:attribute name="id"><xsl:value-of select=".//marc21:controlfield[@tag='001']"/></xsl:attribute><xsl:attribute name="role"><xsl:if test="./marc21:datafield[@tag='200' or @tag='210' or @tag='215' or @tag='220']/marc21:subfield[@code='a'] != ''">r4010</xsl:if></xsl:attribute>
                        <Name><xsl:if test=".//marc21:datafield[@tag='200']/marc21:subfield[@code='b'] !=''"><xsl:value-of select=".//marc21:datafield[@tag='200']/marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select=".//marc21:datafield[@tag='200']/marc21:subfield[@code='a']"/></Name>
                    </Participant> 
                        </xsl:when>
                        <xsl:when test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'], 'CORPO')">
                            <Participant><xsl:attribute name="id"><xsl:value-of select=".//marc21:controlfield[@tag='001']"/></xsl:attribute><xsl:attribute name="role"><xsl:if test="./marc21:datafield[@tag='200' or @tag='210' or @tag='215' or @tag='220']/marc21:subfield[@code='a'] != ''">r4010</xsl:if></xsl:attribute>
                                <Name><xsl:value-of select=".//marc21:datafield[@tag='210']/marc21:subfield[@code='a']"/><xsl:text> </xsl:text><xsl:if test=".//marc21:datafield[@tag='210']/marc21:subfield[@code='b'] !=''"><xsl:text> </xsl:text><xsl:value-of select=".//marc21:datafield[@tag='210']/marc21:subfield[@code='b']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select=".//marc21:datafield[@tag='210']/marc21:subfield[@code='c']"/></Name>
                            </Participant> 
                        </xsl:when>
                        <xsl:when test="contains(.//marc21:datafield[@tag='942']/marc21:subfield[@code='a'], 'FAM')">
                            <Participant><xsl:attribute name="id"><xsl:value-of select=".//marc21:controlfield[@tag='001']"/></xsl:attribute><xsl:attribute name="role"><xsl:if test="./marc21:datafield[@tag='200' or @tag='210' or @tag='215' or @tag='220']/marc21:subfield[@code='a'] != ''">r4010</xsl:if></xsl:attribute>
                                <Name><xsl:value-of select=".//marc21:datafield[@tag='220']/marc21:subfield[@code='a']"/></Name>
                            </Participant> 
                        </xsl:when>
                    </xsl:choose>
                    <xsl:for-each select="./marc21:datafield[@tag='810']">
                        <xsl:if test="not(contains(./marc21:subfield[@code='a'], 'http'))">
                        <BibliographicReference><xsl:value-of select="./marc21:subfield[@code='a']"/></BibliographicReference>
                    </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="./marc21:datafield[@tag='900']">
                    <Book>
                        <xsl:attribute name="id"><xsl:value-of select="./marc21:subfield[@code='0']"/><xsl:value-of select="./marc21:subfield[@code='1']"/><xsl:text>:</xsl:text><xsl:value-of select="./marc21:subfield[@code='2']"/></xsl:attribute>
                    </Book>
                    </xsl:for-each>
                </Collection>
          </xsl:if>
   </xsl:for-each>
    </xsl:template>
</xsl:transform>           

