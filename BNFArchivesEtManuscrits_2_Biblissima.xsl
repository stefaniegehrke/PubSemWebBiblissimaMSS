<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:ead="http://www.loc.gov/ead/2002/schema050823" version="2.0">

    <!-- Transformation de fichiers EAD de BnF Archives et Manuscrits vers XML pivot Biblissima en se basant sur le XSL créé dans le cadre de Europeana Regia (https://sourceforge.net/projects/eregia2eseedm/) - Stefanie Gehrke 2014 et Septembre - Novembre 2016 pour Biblissima -->

    <xsl:template match="/">
        <xsl:variable name="output_dir">./</xsl:variable>
        <xsl:variable name="outputDate">
            <xsl:value-of select="current-date()"/>
        </xsl:variable>
        <xsl:variable name="outputFile"><xsl:value-of select="$output_dir"
                />ExportBdC2_BAM_Test_Biblissima<xsl:value-of
                select="substring-before($outputDate, '+')"/>.xml</xsl:variable>
        <xsl:result-document href="{$outputFile}" method="xml" encoding="UTF-8" indent="yes">
            <RecordList>
                <DataBase uri="http://bnf.archivesetmanuscrits.fr">BnF Archives et
                    Manuscrits</DataBase>
                <xsl:for-each select="//Identifier[@type = 'canonical']">
                    <xsl:variable name="find">
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:variable>
                    <xsl:for-each select="collection('./Europeana_BAM_files/?select=*.xml')">
                        <xsl:if
                            test=".//did/unitid[@type = 'cote'][normalize-space(.) = $find]">
                            <xsl:choose>
                                <xsl:when test="count(/ead//dsc/c/did/unitid[@type = 'cote']) = 0">
                                    <xsl:for-each select=".//did/unitid[@type = 'cote']">
                                    <Book state="preserved">
                                        <xsl:attribute name="id">
                                            <xsl:value-of
                                                select="substring-after(/ead/eadheader/eadid, 'FRBNFEAD0000')"
                                            />
                                        </xsl:attribute>
                                        <ObjectType>manuscrit</ObjectType>
                                        <Concept>
                                            <xsl:text>http://data.bnf.fr/ark:/12148/cc</xsl:text>
                                            <xsl:value-of
                                                select="substring-after(/ead/eadheader/eadid, 'FRBNFEAD0000')"/>
                                            <xsl:text>?</xsl:text>
                                        </Concept>
                                        <Shelfmark>
                                            <Organisation>
                                                <xsl:attribute name="id">
                                                  <xsl:choose>
                                                      <xsl:when
                                                          test="/ead//repository/corpname/@authfilenumber = '751021006' or /ead//repository/corpname/@authfilenumber = '751041006'">
                                                  <xsl:text>e0659fc5d278f341884d0c3886f2c07afb434c96</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                      test="/ead//repository/corpname/@authfilenumber = '751041002' or /ead//repository/corpname/@authfilenumber = '751021002'">
                                                  <xsl:text>4d1c6da9f8b2366ec3984a5d5f53cac989961ab2</xsl:text>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:value-of select="../repository/corpname"/>
                                            </Organisation>
                                            <Identifier type="canonical">
                                                <xsl:value-of select="."/>
                                            </Identifier>
                                        </Shelfmark>
                                        <xsl:for-each select="../unitid[@type = 'ancienne cote']">
                                            <FormerShelfmark>
                                                <xsl:value-of select="."/>
                                            </FormerShelfmark>
                                        </xsl:for-each>
                                        <Name>
                                            <xsl:value-of select="../unittitle"/>
                                        </Name>
                                        <xsl:for-each select="../unittitle">
                                            <xsl:for-each select="./title">
                                            <HasPart>
                                                <PartType>textual unit</PartType>
                                                <Text>
                                                  <Title>
                                                  <xsl:value-of select="."/>
                                                  </Title>
                                                  <AssociatedWork>
                                                  <Title>
                                                  <xsl:value-of select="./@normal"/>
                                                  </Title>
                                                      <Concept><xsl:if test="contains(./@authfilenumber, 'ark')">
                                                  <xsl:text>http://data.bnf.fr/</xsl:text>
                                                      <xsl:value-of select="./@authfilenumber"/></xsl:if>
                                                          <xsl:if test="contains(./@authfilenumber, 'FRBNF')">
                                                              <xsl:text>http://data.bnf.fr/ark:/12148/</xsl:text>
                                                              <xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/></xsl:if>
                                                  </Concept>
                                                  </AssociatedWork>
                                                  <xsl:for-each
                                                  select="../..//langmaterial/language">
                                                  <Language>
                                                  <xsl:value-of select="."/>
                                                  </Language>
                                                  </xsl:for-each>
                                                  <xsl:for-each select=".//persname">
                                                  <Participant>
                                                      <xsl:attribute name="id">
                                                          <xsl:value-of select="./@authfilenumber"/>
                                                      </xsl:attribute>
                                                  <xsl:attribute name="role">
                                                  <xsl:value-of select="./@role"/>
                                                  </xsl:attribute>
                                                  <Name>
                                                  <xsl:value-of select="./@normal"/>
                                                  </Name>
                                                  <AltName>
                                                  <xsl:value-of select="."/>
                                                  </AltName>
                                                      <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                          <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                      </xsl:if>
                                                          <xsl:if test="contains(./title/@authfilenumber,'FRBNF')">
                                                              <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                          </xsl:if></Concept>
                                                  </Participant>
                                                  </xsl:for-each>
                                                    <xsl:for-each select=".//corpname[not(parent::repository)]">
                                                        <Participant>
                                                            <xsl:attribute name="id">
                                                                <xsl:value-of select="./@authfilenumber"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="role">
                                                                <xsl:value-of select="./@role"/>
                                                            </xsl:attribute>
                                                            <Name>
                                                                <xsl:value-of select="./@normal"/>
                                                            </Name>
                                                            <AltName>
                                                                <xsl:value-of select="."/>
                                                            </AltName>
                                                            <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                                <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                            </xsl:if>
                                                                <xsl:if test="contains(./title/@authfilenumber,'FRBNF')">
                                                                    <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                                </xsl:if></Concept>
                                                        </Participant>
                                                    </xsl:for-each>
                                                </Text>
                                            </HasPart>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                            <xsl:for-each select="../../scopecontent/p[starts-with(text()[1],'f.') and title]">
                                                <xsl:for-each select="./title">
                                            <HasPart>
                                                <PartType>textual unit</PartType>
                                                <Pages>
                                                  <xsl:value-of select="../num"/>
                                                </Pages>
                                                <Text>
                                                  <Title>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  </Title>
                                                  <AssociatedWork>
                                                  <Title>
                                                  <xsl:value-of select="./@normal"/>
                                                  </Title>
                                                      <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                  <xsl:text>http://data.bnf.fr/</xsl:text>
                                                  <xsl:value-of select="./@authfilenumber"/>
                                                      </xsl:if>
                                                          <xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                          <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                      </xsl:if>
                                                  </Concept>
                                                  </AssociatedWork>
                                                  <xsl:for-each
                                                  select="../../..//langmaterial/language">
                                                  <Language>
                                                  <xsl:value-of select="."/>
                                                  </Language>
                                                  </xsl:for-each>
                                                  <xsl:for-each select="..//persname">
                                                      <Participant><xsl:attribute name="id">
                                                          <xsl:value-of select="./@authfilenumber"/>
                                                      </xsl:attribute>
                                                  <xsl:attribute name="role">
                                                  <xsl:value-of select="./@role"/>
                                                  </xsl:attribute>
                                                  <Name>
                                                  <xsl:value-of select="./@normal"/>
                                                  </Name>
                                                  <AltName>
                                                  <xsl:value-of select="."/>
                                                  </AltName>
                                                      <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                          <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                      </xsl:if>
                                                          <xsl:if test="contains(./@authfilenumber, 'ark')">
                                                              <xsl:text>http://data.bnf.fr/</xsl:text>
                                                              <xsl:value-of select="./@authfilenumber"/></xsl:if>
                                                  </Concept>
                                                  </Participant>
                                                  </xsl:for-each>
                                                    <xsl:for-each select="..//corpname[not(parent::repository)]">
                                                        <Participant>
                                                            <xsl:attribute name="id">
                                                                <xsl:value-of select="./@authfilenumber"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="role">
                                                                <xsl:value-of select="./@role"/>
                                                            </xsl:attribute>
                                                            <Name>
                                                                <xsl:value-of select="./@normal"/>
                                                            </Name>
                                                            <AltName>
                                                                <xsl:value-of select="."/>
                                                            </AltName>
                                                            <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                                <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                            </xsl:if>
                                                                <xsl:if test="contains(./title/@authfilenumber,'FRBNF')">
                                                                    <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                                </xsl:if></Concept>
                                                        </Participant>
                                                    </xsl:for-each>
                                                </Text>
                                            </HasPart>
                                        </xsl:for-each>
                                            </xsl:for-each>
                                        <xsl:for-each select=".//c[not(@type = 'cote')]">
                                            <HasPart>
                                                <xsl:attribute name="id">
                                                  <xsl:value-of select="@id"/>
                                                </xsl:attribute>
                                                <PartType>codicologial unit</PartType>
                                                <Pages>
                                                  <xsl:value-of
                                                  select="./unitid[@type = 'foliotation']"/>
                                                </Pages>
                                                <Text>
                                                  <Title>
                                                  <xsl:value-of select="./unittitle/title"/>
                                                  </Title>
                                                  <AssociatedWork>
                                                  <Title>
                                                  <xsl:value-of select="./unittitle/title/@normal"/>
                                                  </Title>
                                                      <Concept><xsl:if test="contains(./unittitle/title/@authfilenumber,'ark')">
                                                  <xsl:text>http://data.bnf.fr/</xsl:text>
                                                  <xsl:value-of
                                                  select="./unittitle/title/@authfilenumber"/></xsl:if>
                                                          <xsl:if test="contains(./unittitle/title/@authfilenumber,'FRBNF')">
                                                              <xsl:text>http://data.bnf.fr/</xsl:text>
                                                              <xsl:value-of
                                                                  select="substring-after(./unittitle/title/@authfilenumber,'FRBNF')"/></xsl:if>
                                                  </Concept>
                                                  </AssociatedWork>
                                                    <xsl:for-each select="../..//langmaterial/language">
                                                  <Language>
                                                  <xsl:value-of
                                                  select="."/>
                                                  </Language>
                                                    </xsl:for-each>
                                                  <xsl:for-each select="./unittitle//persname">
                                                      <Participant><xsl:attribute name="id">
                                                          <xsl:value-of select="./@authfilenumber"/>
                                                      </xsl:attribute>
                                                  <xsl:attribute name="role">
                                                  <xsl:value-of select="./@role"/>
                                                  </xsl:attribute>
                                                  <Name>
                                                  <xsl:value-of select="./@normal"/>
                                                  </Name>
                                                  <AltName>
                                                  <xsl:value-of select="."/>
                                                  </AltName>
                                                      <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                          <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                      </xsl:if>
                                                          <xsl:if test="contains(./@authfilenumber,'ark')">
                                                              <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                          </xsl:if>
                                                  </Concept>
                                                  </Participant>
                                                  </xsl:for-each>
                                                    <xsl:for-each select="./unittitle//corpname[not(parent::repository)]">
                                                        <Participant>
                                                            <xsl:attribute name="id">
                                                                <xsl:value-of select="./@authfilenumber"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="role">
                                                                <xsl:value-of select="./@role"/>
                                                            </xsl:attribute>
                                                            <Name>
                                                                <xsl:value-of select="./@normal"/>
                                                            </Name>
                                                            <AltName>
                                                                <xsl:value-of select="."/>
                                                            </AltName>
                                                            <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                                <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                            </xsl:if>
                                                                <xsl:if test="contains(./title/@authfilenumber,'FRBNF')">
                                                                    <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                                </xsl:if></Concept>
                                                        </Participant>
                                                    </xsl:for-each>
                                                </Text>
                                            </HasPart>
                                        </xsl:for-each>

                                        <xsl:for-each select="../..//persname">
                                            <Participant><xsl:attribute name="id">
                                                <xsl:value-of select="./@authfilenumber"/>
                                            </xsl:attribute>
                                                <xsl:attribute name="role">
                                                  <xsl:value-of select="@role"/>
                                                </xsl:attribute>
                                                <Name lang="fr">
                                                  <xsl:value-of select="."/>
                                                </Name>
                                                <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                    <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                </xsl:if>
                                                    <xsl:if test="contains(./@authfilenumber,'ark')">
                                                        <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                    </xsl:if>
                                                </Concept>
                                            </Participant>
                                        </xsl:for-each>
                                        <xsl:for-each select="../..//corpname[not(parent::repository)]">
                                            <Participant><xsl:attribute name="id">
                                                <xsl:value-of select="./@authfilenumber"/>
                                            </xsl:attribute>
                                                <xsl:attribute name="role">
                                                  <xsl:value-of select="@role"/>
                                                </xsl:attribute>
                                                <Name lang="fr">
                                                  <xsl:value-of select="."/>
                                                </Name>
                                                <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                    <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                </xsl:if>
                                                    <xsl:if test="contains(./@authfilenumber,'ark')">
                                                        <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                    </xsl:if>
                                                </Concept>
                                            </Participant>
                                        </xsl:for-each>
                                        <xsl:for-each select="../..//controlaccess[contains(name[2],'Possesseur')]">
                                            <Participant role="r4010"><xsl:attribute name="id">
                                                <xsl:value-of select="./@authfilenumber"/>
                                            </xsl:attribute>
                                                <Name lang="fr">
                                                    <xsl:value-of select="./name[1]"/>
                                                </Name>
                                                <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                    <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                </xsl:if>
                                                    <xsl:if test="contains(./@authfilenumber,'ark')">
                                                        <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                    </xsl:if>
                                                </Concept>
                                            </Participant>
                                        </xsl:for-each>
                                        <xsl:choose>
                                            <xsl:when
                                                test="../odd[@type = 'set OAI' or not(@type)]/p = 'gallica:corpus:RegiaCharlesV'">
                                                <Participant role="r4010">
                                                  <Name>Charles V et sa famille</Name>
                                                  <Gender>Organisation</Gender>
                                                </Participant>
                                            </xsl:when>
                                            <xsl:when
                                                test="../odd[@type = 'set OAI' or not(@type)]/p = 'gallica:corpus:RegiaAragon'">
                                                <Participant role="r4010">
                                                  <Name>rois Aragonais à Naples</Name>
                                                  <Gender>Organisation</Gender>
                                                </Participant>
                                            </xsl:when>
                                            <xsl:when
                                                test="../odd[@type = 'set OAI' or not(@type)]/p = 'gallica:corpus:RegiaCaro'">
                                                <Participant>
                                                  <Name>Empire carolingien</Name>
                                                </Participant>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:for-each select="../unitdate">
                                        <Date>
                                            <Century>
                                                <xsl:value-of select="."/>
                                            </Century>
                                            <Year>
                                                <xsl:value-of select="./@normal"/>
                                            </Year>
                                            <Note/>
                                        </Date>
                                        </xsl:for-each>
                                        <xsl:for-each select="../..//geogname[@role = '5020']">
                                        <Place>
                                            <Name lang="fr">
                                                <xsl:value-of
                                                  select="."/>
                                            </Name>
                                        </Place>
                                        </xsl:for-each>
                                        <xsl:for-each select="../..//dao/@href">
                                            <DigitalSurrogate type="integral">
                                                <xsl:value-of select="."/>
                                            </DigitalSurrogate>
                                            <Manifest>
                                                <xsl:text>http://gallica.bnf.fr/iiif/</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(., 'http://gallica.bnf.fr/')"/>
                                                <xsl:text>/manifest.json</xsl:text>
                                            </Manifest>
                                        </xsl:for-each>
                                        <Record>
                                            <xsl:text>http://archivesetmanuscrits.bnf.fr/ead.html?id=</xsl:text>
                                            <xsl:value-of select="/ead/eadheader/eadid"/>
                                        </Record>
                                        <Record><xsl:text>http://archivesetmanuscrits.bnf.fr/ark:/12148/</xsl:text><xsl:value-of
                                            select="substring-after(/ead/eadheader/eadid, 'FRBNFEAD0000')"/>
                                            <xsl:text>?</xsl:text></Record>
                                        <Extent>
                                            <xsl:value-of select="../..//extent"/>
                                        </Extent>
                                        <Format unit="mm">
                                            <xsl:value-of select="../..//dimensions"/>
                                        </Format>
                                        <xsl:for-each select="../..//bibliography/bibref[not(@linktype='simple')]">
                                        <BibliographicReference><xsl:value-of select="."/></BibliographicReference>
                                        </xsl:for-each>
                                        <xsl:for-each select="../..//physfacet[@type = 'écriture' and ancestor::physfacet]">
                                        <Term context="script">
                                            <xsl:value-of
                                                select="substring-before(., '.') or substring-before(.,';')"
                                            />
                                        </Term>
                                        </xsl:for-each>
                                        <xsl:for-each select="../..//physfacet[@type = 'matériau' or @type='support']">
                                        <Term context="support">
                                            <xsl:value-of
                                                select="."
                                            />
                                        </Term>
                                        </xsl:for-each>
                                        <xsl:for-each select="../..//physdesc/physfacet[@type='technique']">
                                        <Note><xsl:value-of select="."/></Note>
                                        </xsl:for-each>
                                        <xsl:for-each select="../..//physdesc/physfacet[@type='décoration' or @type='illustration']">
                                        <Note><xsl:value-of select="."/></Note>
                                        </xsl:for-each>
                                       <!-- <HasFeature id="[internal ID from database]">
                                        <FeatureType id="[internal ID from database]">[illumination
                                            or provenance mark or annotation goes
                                            here]</FeatureType>
                                        <Page unit="[f or p or NP]">[folio goes here]</Page>
                                        <Participant id="[internal ID from database]"
                                            role="[marc role or definition]">
                                            <Name lang="[internal language ID database]"/>
                                        </Participant>
                                        <Note/>
                                        <Rubric/>
                                        <Inscription/>
                                    </HasFeature> -->
                                    </Book>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each
                                        select="/ead//dsc/c[descendant::unitid[@type = 'cote']]">
                                        <Book state="preserved">
                                            <xsl:attribute name="id">
                                                <xsl:value-of
                                                  select="substring-after(/ead/eadheader/eadid, 'FRBNFEAD0000')"
                                                /><xsl:text>?/c</xsl:text><xsl:value-of select="@id"/>
                                            </xsl:attribute>
                                            <ObjectType>manuscrit</ObjectType>
                                            <Concept>
                                                <xsl:text>http://data.bnf.fr/ark:/12148/cc</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(/ead/eadheader/eadid, 'FRBNFEAD0000')"/>
                                                <xsl:text>?/c</xsl:text>
                                                <xsl:value-of select="@id"/>
                                            </Concept>
                                            <Shelfmark>
                                                <Organisation>
                                                        <xsl:attribute name="id">
                                                            <xsl:choose>
                                                                <xsl:when
                                                                    test="/ead//repository/corpname/@authfilenumber = '751021006' or /ead//repository/corpname/@authfilenumber = '751041006'">
                                                                    <xsl:text>e0659fc5d278f341884d0c3886f2c07afb434c96</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when
                                                                    test="/ead//repository/corpname/@authfilenumber = '751041002' or /ead//repository/corpname/@authfilenumber = '751021002'">
                                                                    <xsl:text>4d1c6da9f8b2366ec3984a5d5f53cac989961ab2</xsl:text>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </xsl:attribute>
                                                  <xsl:value-of select="/ead//repository/corpname"/>
                                                </Organisation>
                                                <Identifier type="canonical">
                                                  <xsl:value-of
                                                  select="./did/unitid[@type = 'cote']"/>
                                                </Identifier>
                                            </Shelfmark>
                                            <xsl:for-each
                                                select="./did/unitid[@type = 'ancienne cote']">
                                                <FormerShelfmark>
                                                  <xsl:value-of select="."/>
                                                </FormerShelfmark>
                                            </xsl:for-each>
                                            <Name>
                                                <xsl:value-of select="./did/unittitle"/>
                                            </Name>
                                            <xsl:for-each select="./did//dao/@href">
                                                <DigitalSurrogate type="integral">
                                                  <xsl:value-of select="."/>
                                                </DigitalSurrogate>
                                                <Manifest>
                                                  <xsl:text>http://gallica.bnf.fr/iiif/</xsl:text>
                                                  <xsl:value-of
                                                  select="substring-after(., 'http://gallica.bnf.fr/')"/>
                                                  <xsl:text>/manifest.json</xsl:text>
                                                </Manifest>
                                            </xsl:for-each>
                                        </Book>
                                    </xsl:for-each>
                                        <Groupbook>
                                            <Concept>
                                                <xsl:text>http://data.bnf.fr/ark:/12148/cc</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(/ead/eadheader/eadid, 'FRBNFEAD0000')"/>
                                                <xsl:text>?</xsl:text>
                                            </Concept>
                                            <Shelfmark>
                                                <Organisation>
                                                  <xsl:attribute name="id">
                                                  <xsl:choose>
                                                      <xsl:when
                                                          test="/ead//repository/corpname/@authfilenumber = '751021006' or /ead//repository/corpname/@authfilenumber = '751041006'">
                                                          <xsl:text>e0659fc5d278f341884d0c3886f2c07afb434c96</xsl:text>
                                                      </xsl:when>
                                                  <xsl:when
                                                      test="/ead//repository/corpname/@authfilenumber = '751041002' or /ead//repository/corpname/@authfilenumber = '751021002'">
                                                  <xsl:text>4d1c6da9f8b2366ec3984a5d5f53cac989961ab2</xsl:text>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="/ead//repository/corpname"/>
                                                </Organisation>
                                                <Identifier type="canonical">
                                                  <xsl:value-of
                                                  select="/ead/archdesc/did/unitid[@type = 'cote']"/>
                                                </Identifier>
                                            </Shelfmark>
                                            <Text>
                                                <Title>
                                                  <xsl:value-of
                                                  select="/ead/archdesc[@level = 'item' or @otherlevel = 'recueil']/did/unittitle"
                                                  />
                                                </Title>
                                                <AssociatedWork>
                                                  <Title>
                                                  <xsl:value-of
                                                  select="/ead/archdesc[@level = 'item' or @otherlevel = 'recueil']/did/unittitle/title/@normal"
                                                  />
                                                  </Title>
                                                  <Concept>
                                                  <xsl:text>http://data.bnf.fr/ark:/12148/cd</xsl:text>
                                                  <xsl:value-of
                                                  select="/ead/archdesc[@level = 'item' or @otherlevel = 'recueil']/did/unittitle/title/@authfilenumber"
                                                  />
                                                  </Concept>
                                                </AssociatedWork>
                                                <xsl:for-each select="../..//langmaterial/language">
                                                  <Language>
                                                  <xsl:value-of select="."/>
                                                  </Language>
                                                </xsl:for-each>
                                            </Text>
                                            <xsl:for-each select="../unittitle">
                                                <xsl:for-each select="./title">
                                                    <HasPart>
                                                        <PartType>textual unit</PartType>
                                                        <Text>
                                                            <Title>
                                                                <xsl:value-of select="."/>
                                                            </Title>
                                                            <AssociatedWork>
                                                                <Title>
                                                                    <xsl:value-of select="./@normal"/>
                                                                </Title>
                                                                <Concept><xsl:if test="contains(./@authfilenumber, 'ark')">
                                                                    <xsl:text>http://data.bnf.fr/</xsl:text>
                                                                    <xsl:value-of select="./@authfilenumber"/></xsl:if>
                                                                    <xsl:if test="contains(./@authfilenumber, 'FRBNF')">
                                                                        <xsl:text>http://data.bnf.fr/ark:/12148/</xsl:text>
                                                                        <xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/></xsl:if>
                                                                </Concept>
                                                            </AssociatedWork>
                                                            <xsl:for-each
                                                                select="../..//langmaterial/language">
                                                                <Language>
                                                                    <xsl:value-of select="."/>
                                                                </Language>
                                                            </xsl:for-each>
                                                            <xsl:for-each select=".//persname">
                                                                <Participant>
                                                                    <xsl:attribute name="id">
                                                                        <xsl:value-of select="./@authfilenumber"/>
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="role">
                                                                        <xsl:value-of select="./@role"/>
                                                                    </xsl:attribute>
                                                                    <Name>
                                                                        <xsl:value-of select="./@normal"/>
                                                                    </Name>
                                                                    <AltName>
                                                                        <xsl:value-of select="."/>
                                                                    </AltName>
                                                                    <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                                        <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                                    </xsl:if>
                                                                        <xsl:if test="contains(./title/@authfilenumber,'FRBNF')">
                                                                            <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                                        </xsl:if></Concept>
                                                                </Participant>
                                                            </xsl:for-each>
                                                            <xsl:for-each select=".//corpname[not(parent::repository)]">
                                                                <Participant>
                                                                    <xsl:attribute name="id">
                                                                        <xsl:value-of select="./@authfilenumber"/>
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="role">
                                                                        <xsl:value-of select="./@role"/>
                                                                    </xsl:attribute>
                                                                    <Name>
                                                                        <xsl:value-of select="./@normal"/>
                                                                    </Name>
                                                                    <AltName>
                                                                        <xsl:value-of select="."/>
                                                                    </AltName>
                                                                    <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                                        <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                                    </xsl:if>
                                                                        <xsl:if test="contains(./title/@authfilenumber,'FRBNF')">
                                                                            <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                                        </xsl:if></Concept>
                                                                </Participant>
                                                            </xsl:for-each>
                                                        </Text>
                                                    </HasPart>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                            <xsl:for-each select="../../scopecontent/p[starts-with(text()[1],'f.') and title]">
                                                <xsl:for-each select="./title">
                                                    <HasPart>
                                                        <PartType>textual unit</PartType>
                                                        <Pages>
                                                            <xsl:value-of select="../num"/>
                                                        </Pages>
                                                        <Text>
                                                            <Title>
                                                                <xsl:value-of select="normalize-space(.)"/>
                                                            </Title>
                                                            <AssociatedWork>
                                                                <Title>
                                                                    <xsl:value-of select="./@normal"/>
                                                                </Title>
                                                                <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                                    <xsl:text>http://data.bnf.fr/</xsl:text>
                                                                    <xsl:value-of select="./@authfilenumber"/>
                                                                </xsl:if>
                                                                    <xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                                        <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                                    </xsl:if>
                                                                </Concept>
                                                            </AssociatedWork>
                                                            <xsl:for-each
                                                                select="../../..//langmaterial/language">
                                                                <Language>
                                                                    <xsl:value-of select="."/>
                                                                </Language>
                                                            </xsl:for-each>
                                                            <xsl:for-each select="..//persname">
                                                                <Participant><xsl:attribute name="id">
                                                                    <xsl:value-of select="./@authfilenumber"/>
                                                                </xsl:attribute>
                                                                    <xsl:attribute name="role">
                                                                        <xsl:value-of select="./@role"/>
                                                                    </xsl:attribute>
                                                                    <Name>
                                                                        <xsl:value-of select="./@normal"/>
                                                                    </Name>
                                                                    <AltName>
                                                                        <xsl:value-of select="."/>
                                                                    </AltName>
                                                                    <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                                        <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                                    </xsl:if>
                                                                        <xsl:if test="contains(./@authfilenumber, 'ark')">
                                                                            <xsl:text>http://data.bnf.fr/</xsl:text>
                                                                            <xsl:value-of select="./@authfilenumber"/></xsl:if>
                                                                    </Concept>
                                                                </Participant>
                                                            </xsl:for-each>
                                                            <xsl:for-each select="..//corpname[not(parent::repository)]">
                                                                <Participant>
                                                                    <xsl:attribute name="id">
                                                                        <xsl:value-of select="./@authfilenumber"/>
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="role">
                                                                        <xsl:value-of select="./@role"/>
                                                                    </xsl:attribute>
                                                                    <Name>
                                                                        <xsl:value-of select="./@normal"/>
                                                                    </Name>
                                                                    <AltName>
                                                                        <xsl:value-of select="."/>
                                                                    </AltName>
                                                                    <Concept><xsl:if test="contains(./@authfilenumber,'ark')">
                                                                        <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                                    </xsl:if>
                                                                        <xsl:if test="contains(./title/@authfilenumber,'FRBNF')">
                                                                            <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                                        </xsl:if></Concept>
                                                                </Participant>
                                                            </xsl:for-each>
                                                        </Text>
                                                    </HasPart>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                            <xsl:for-each
                                                select="/ead/archdesc[@level = 'item' or @otherlevel = 'recueil']/did//persname">
                                                <Participant><xsl:attribute name="id">
                                                    <xsl:value-of select="./@authfilenumber"/>
                                                </xsl:attribute>
                                                  <xsl:attribute name="role">
                                                  <xsl:value-of select="./@role"/>
                                                  </xsl:attribute>
                                                  <Name>
                                                  <xsl:value-of select="./@normal"/>
                                                  </Name>
                                                  <AltName>
                                                  <xsl:value-of select="."/>
                                                  </AltName>
                                                    <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                  <xsl:text>http://data.bnf.fr/ark:/12148/</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                    </xsl:if>
                                                        <xsl:if test="contains(./@authfilenumber,'ark')">
                                                            <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                        </xsl:if>
                                                  </Concept>
                                                </Participant>
                                            </xsl:for-each>
                                            <xsl:for-each
                                                select="/ead/archdesc[@level = 'item' or @otherlevel = 'recueil']/did//corpname[not(parent::repository)]">
                                                <Participant><xsl:attribute name="id">
                                                    <xsl:value-of select="./@authfilenumber"/>
                                                </xsl:attribute>
                                                    <xsl:attribute name="role">
                                                        <xsl:value-of select="./@role"/>
                                                    </xsl:attribute>
                                                    <Name>
                                                        <xsl:value-of select="./@normal"/>
                                                    </Name>
                                                    <AltName>
                                                        <xsl:value-of select="."/>
                                                    </AltName>
                                                    <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                        <xsl:text>http://data.bnf.fr/ark:/12148/</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                    </xsl:if>
                                                        <xsl:if test="contains(./@authfilenumber,'ark')">
                                                            <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                        </xsl:if>
                                                    </Concept>
                                                </Participant>
                                            </xsl:for-each>
                                            <xsl:for-each select="/ead//controlaccess[contains(name[2],'Possesseur')]">
                                                <Participant role="r4010"><xsl:attribute name="id">
                                                    <xsl:value-of select="./@authfilenumber"/>
                                                </xsl:attribute>
                                                    <Name lang="fr">
                                                        <xsl:value-of select="./name[1]"/>
                                                    </Name>
                                                    <Concept><xsl:if test="contains(./@authfilenumber,'FRBNF')">
                                                        <xsl:text>http://data.bnf.fr/ark:/12148/cb</xsl:text><xsl:value-of select="substring-after(./@authfilenumber,'FRBNF')"/><xsl:text>?</xsl:text>
                                                    </xsl:if>
                                                        <xsl:if test="contains(./@authfilenumber,'ark')">
                                                            <xsl:text>http://data.bnf.fr/</xsl:text><xsl:value-of select="./@authfilenumber"/>
                                                        </xsl:if>
                                                    </Concept>
                                                </Participant>
                                            </xsl:for-each>
                                            <xsl:for-each select="/ead/archdesc[@level = 'item' or @otherlevel = 'recueil']/did/unitdate">
                                            <Date>
                                                <Century>
                                                  <xsl:value-of
                                                  select="."
                                                  /></Century>
                                                    <Year><xsl:value-of select="./@normal"/>
                                                </Year>
                                            </Date>
                                            </xsl:for-each>
                                            <xsl:for-each select="/ead/archdesc[@level = 'item' or @otherlevel = 'recueil']/did//geogname[@role = '5020']">
                                            <Place>
                                                <Name lang="fr">
                                                  <xsl:value-of
                                                  select="."
                                                  />
                                                </Name>
                                            </Place>
                                            </xsl:for-each>
                                            <Record>
                                                <xsl:text>http://archivesetmanuscrits.bnf.fr/ark:/12148/</xsl:text>
                                                <xsl:value-of
                                                    select="substring-after(/ead/eadheader/eadid, 'FRBNFEAD0000')"/>
                                                <xsl:text>?</xsl:text>
                                            </Record>
                                            <xsl:for-each select="../..//bibliography/bibref[not(@linktype='simple')]">
                                            <BibliographicReference><xsl:value-of select="."/></BibliographicReference>
                                            </xsl:for-each>
                                            <xsl:for-each select="../..//physfacet[@type = 'écriture' and ancestor::physfacet]">
                                            <Term context="script">
                                                <xsl:value-of
                                                    select="."
                                                />
                                            </Term>
                                            </xsl:for-each>
                                            <xsl:for-each select="../..//physfacet[@type = 'matériau' or @type='support']">
                                            <Term context="support">
                                                <xsl:value-of
                                                    select="."
                                                />
                                            </Term>
                                            </xsl:for-each>
                                            <xsl:for-each select="../..//physdesc/physfacet[@type='technique']">
                                            <Note><xsl:value-of select="."/></Note>
                                            </xsl:for-each>
                                            <xsl:for-each select="../..//physdesc/physfacet[@type='décoration' or @type='illustration']">
                                            <Note><xsl:value-of select="."/></Note>
                                            </xsl:for-each>
                                            <HasPart>
                                                <xsl:for-each select="/ead//c[@level = 'item']">
                                                  <Book state="preserved">
                                                      <xsl:attribute name="id">
                                                          <xsl:value-of
                                                          select="substring-after(/ead/eadheader/eadid, 'FRBNFEAD0000')"
                                                      /><xsl:text>?/c</xsl:text><xsl:value-of select="@id"/>
                                                  </xsl:attribute>
                                                  </Book>
                                                </xsl:for-each>
                                            </HasPart>
                                        </Groupbook>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>

                <Repository>
                    <Country geonames="3017382">France</Country>
                    <City geonames="2988507">Paris</City>
                    <Organisation id="" id_bbma="e0659fc5d278f341884d0c3886f2c07afb434c96"
                        >Bibliothèque nationale de France, Département des manuscrits</Organisation>
                    <Concept source="BnF">http://data.bnf.fr/ark:/12148/cb12511198k</Concept>
                    <Name_Bbma>Paris. Bibliothèque nationale de France, Département des
                        manuscrits</Name_Bbma>
                </Repository>
                <Repository>
                    <Country geonames="3017382">France</Country>
                    <City geonames="2988507">Paris</City>
                    <Organisation id="" id_bbma="4d1c6da9f8b2366ec3984a5d5f53cac989961ab2">BNF -
                        Bibliothèque de l'Arsenal</Organisation>
                    <Concept source="BnF">http://data.bnf.fr/ark:/12148/cb11873586s</Concept>
                    <Name_Bbma>Paris. Bibliothèque de l'Arsenal</Name_Bbma>
                </Repository>
            </RecordList>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
