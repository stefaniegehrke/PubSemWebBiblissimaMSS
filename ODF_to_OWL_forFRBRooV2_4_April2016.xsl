<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
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
    xmlns:textooo="http://openoffice.org/2013/office"
    xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0"
    office:version="1.2">
    
    <!-- Stefanie Gehrke, 2016-04-17 -->
    <!-- FRBRoo V2.4 ODT to OWL   	-->
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <xsl:param name="current_prefix"><xsl:text>http://erlangen-crm.org/current/</xsl:text></xsl:param>
    
    <xsl:param name="frbroo_prefix"><xsl:text>http://erlangen-crm.org/efrbroo/</xsl:text></xsl:param>  
    <xsl:template match="/">
        <xsl:result-document encoding="UTF-8" method="xml" indent="yes" href="owl_test.xml">
            <rdf:RDF>
                <xsl:comment>

	-- FRVRoo V2.4 Draft November 2015   - converted from http://www.cidoc-crm.org/docs/frbr_oo/frbr_docs/FRBRoo_V2.4.docx

        	</xsl:comment>
                <owl:Ontology>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="/owl:Ontology/@ontologyIRI"/></xsl:attribute>
                    <rdfs:label>
                        <xsl:attribute name="xml:lang"><xsl:value-of select="/owl:Ontology/owl:Annotation/owl:AnnotationProperty[@abbreviatedIRI = 'rdfs:label']/../owl:Literal/@xml:lang"/></xsl:attribute>
                        <xsl:value-of select="/owl:Ontology/owl:Annotation/owl:AnnotationProperty[@abbreviatedIRI = 'rdfs:label']/../owl:Literal"/>
                    </rdfs:label>
                    <owl:versionInfo rdf:datatype="xsd:string"></owl:versionInfo>
                    <xsl:for-each select="/owl:Ontology/owl:Annotation/owl:AnnotationProperty[@abbreviatedIRI = 'rdfs:comment']">
                        
                        <rdfs:comment>
                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                            <xsl:value-of select="../owl:Literal"/></rdfs:comment>
                    </xsl:for-each>
                </owl:Ontology>
                
                <xsl:comment>

	-- Annotation properties

        	</xsl:comment>
                
                <xsl:comment> http://www.w3.org/2004/02/skos/core#notation </xsl:comment>
                
                <owl:AnnotationProperty rdf:about="skos:notation"/>
                
                
                <xsl:comment>
         	 
	-- Classes

        	</xsl:comment>  
                
                <xsl:for-each-group select=".//office:text/*" group-starting-with="./text:h">
                    <xsl:variable name="nameText"><xsl:value-of select="current-group()[1]"/></xsl:variable>
                    <xsl:variable name="nameNormalized"><xsl:value-of select="normalize-space($nameText)"/></xsl:variable>
                    <xsl:variable name="nameID"><xsl:value-of select="replace($nameNormalized,' ','_')"/></xsl:variable>
                    <xsl:choose>
                        <!-- classes -->
                        <xsl:when test="starts-with($nameNormalized,'F') or starts-with($nameNormalized,'E')">
                            <xsl:comment><xsl:value-of select="$nameID"/></xsl:comment>
                            <owl:Class>
                                <xsl:attribute name="rdf:about">
                                    <xsl:choose><xsl:when test="starts-with($nameNormalized,'E')">
                                        <xsl:value-of select="$current_prefix"/>
                                    </xsl:when>
                                        <xsl:when test="starts-with($nameNormalized,'F')">
                                            <xsl:value-of select="$frbroo_prefix"/>
                                        </xsl:when></xsl:choose> <xsl:value-of select="$nameID"/></xsl:attribute>
                                <rdfs:label>
                                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                                    <xsl:value-of select="$nameNormalized"/>
                                </rdfs:label>
                                <xsl:variable name="textBlock">
                                    <xsl:for-each select="current-group()">
                                        <xsl:if test="position() &gt; 1">
                                            <xsl:value-of select="normalize-space(.)"/> ;@-
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:analyze-string select="normalize-space($textBlock)" regex="Subclass of:|Superclass of:|Scope [Nn]ote:|Examples:|Properties:|Equal to:">
                                    <xsl:non-matching-substring>
                                        <xsl:variable name="prev"><xsl:value-of select="position()-1"/></xsl:variable>
                                        <xsl:variable name="type">
                                            <xsl:analyze-string select="normalize-space($textBlock)" regex="Subclass of:|Superclass of:|Scope [Nn]ote:|Examples:|Properties:|Equal to:">
                                                <xsl:matching-substring>
                                                    <xsl:if test="position()=$prev">
                                                        <xsl:value-of select="."/>
                                                    </xsl:if>
                                                </xsl:matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="contains($type,'Subclass')">
                                                <xsl:for-each select="tokenize(.,';@-')">
                                                    <xsl:if test="normalize-space(.) != ''">
                                                        <rdfs:subClassOf>
                                                            <xsl:attribute name="rdf:resource"><xsl:choose><xsl:when test="starts-with(normalize-space(.),'E')">
                                                                <xsl:value-of select="$current_prefix"/></xsl:when><xsl:when test="starts-with(normalize-space(.),'F')">
                                                                    <xsl:value-of select="$frbroo_prefix"/></xsl:when></xsl:choose><xsl:value-of select="replace(normalize-space(.),' ','_')"/></xsl:attribute>
                                                        </rdfs:subClassOf>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="contains($type,'Superclass')">
                                                <xsl:for-each select="tokenize(.,';@-')">
                                                    <xsl:if test="normalize-space(.) != ''">
                                                        <rdfs:superClassOf>
                                                            <xsl:attribute name="rdf:resource"><xsl:choose><xsl:when test="starts-with(normalize-space(.),'E')">
                                                                <xsl:value-of select="$current_prefix"/></xsl:when><xsl:when test="starts-with(normalize-space(.),'F')">
                                                                    <xsl:value-of select="$frbroo_prefix"/></xsl:when></xsl:choose><xsl:value-of select="replace(normalize-space(.),' ','_')"/></xsl:attribute>
                                                        </rdfs:superClassOf>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="contains($type,'Equal')">
                                                <xsl:for-each select="tokenize(.,';@-')">
                                                    <xsl:if test="normalize-space(.) != ''">
                                                        <owl:equivalentClass>
                                                            <xsl:attribute name="rdf:resource"><xsl:choose><xsl:when test="starts-with(normalize-space(.),'E')">
                                                                <xsl:value-of select="$current_prefix"/></xsl:when><xsl:when test="starts-with(normalize-space(.),'F')">
                                                                    <xsl:value-of select="$frbroo_prefix"/></xsl:when></xsl:choose><xsl:value-of select="replace(normalize-space(.),' ','_')"/></xsl:attribute>
                                                        </owl:equivalentClass>
                                                        <rdfs:comment><xsl:value-of select="$type"/><xsl:text>&#xa;</xsl:text><xsl:for-each select="tokenize(.,';@-')"><xsl:value-of select="normalize-space(.)"/><xsl:text>&#xa;</xsl:text></xsl:for-each>
                                                        </rdfs:comment>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                            
                                            <xsl:when test="matches($type,'Scope|Example|Properties')">
                                                <rdfs:comment><xsl:value-of select="$type"/><xsl:text>&#xa;</xsl:text><xsl:for-each select="tokenize(.,';@-')"><xsl:value-of select="normalize-space(.)"/><xsl:text>&#xa;</xsl:text></xsl:for-each>
                                                </rdfs:comment>
                                            </xsl:when>
                                            
                                        </xsl:choose>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </owl:Class>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each-group>
                <xsl:comment>

	-- Properties

        	</xsl:comment>  
                
                <xsl:for-each-group select=".//office:text/*" group-starting-with="./text:h">
                    <xsl:variable name="nameText"><xsl:value-of select="current-group()[1]"/></xsl:variable>
                    <xsl:variable name="nameNormalized"><xsl:value-of select="normalize-space($nameText)"/></xsl:variable>
                    <xsl:variable name="nameID"><xsl:choose><xsl:when test="starts-with($nameNormalized,'P')">
                        <xsl:value-of select="$current_prefix"/></xsl:when><xsl:otherwise >
                            <xsl:value-of select="$frbroo_prefix"/></xsl:otherwise></xsl:choose><xsl:choose>
                                <xsl:when test="contains($nameNormalized,'(')"><xsl:value-of select="replace(normalize-space(substring-before($nameNormalized,'(')),' ','_')"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="replace(normalize-space($nameNormalized),' ','_')"/></xsl:otherwise>
                            </xsl:choose></xsl:variable>
                    
                    
                    <xsl:variable name="inverseNameID"><xsl:value-of select="substring-before($nameID,'_')"/><xsl:text>i_</xsl:text><xsl:value-of select="replace(normalize-space(substring-after(replace(normalize-space($nameNormalized),' ','_'),'(')),'\)','')"/></xsl:variable>
                    <xsl:choose>
                        <!-- properties -->
                        <xsl:when test="starts-with($nameNormalized,'R') or starts-with($nameNormalized,'P') or starts-with($nameNormalized,'CL')">
                            <xsl:comment><xsl:value-of select="$nameID"/></xsl:comment>
                            <owl:ObjectProperty>
                                <xsl:attribute name="rdf:about"><xsl:value-of select="$nameID"/></xsl:attribute>
                                <rdfs:label>
                                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="contains($nameNormalized,'(')">
                                            <xsl:value-of select="normalize-space(substring-before($nameNormalized,'('))"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space($nameNormalized)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </rdfs:label>
                                <!-- see if inverse exists -->
                                <xsl:if test="not(ends-with($inverseNameID,'_'))">
                                    <owl:inverseOf>
                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$inverseNameID"/></xsl:attribute>
                                    </owl:inverseOf>
                                </xsl:if>
                                <xsl:variable name="textBlock">
                                    <xsl:for-each select="current-group()">
                                        <xsl:if test="position() &gt; 1">
                                            <xsl:value-of select="normalize-space(.)"/> ;@-
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:analyze-string select="normalize-space($textBlock)" regex="Subproperty of:|Superproperty of:|Scope [Nn]ote:|Examples:|Domain:|Range:|Quantification:|Equal to:|Shortcut of:|Is covered by shortcut:">
                                    <xsl:non-matching-substring>
                                        <xsl:variable name="prev"><xsl:value-of select="position()-1"/></xsl:variable>
                                        <xsl:variable name="type">
                                            <xsl:analyze-string select="normalize-space($textBlock)" regex="Subproperty of:|Superproperty of:|Scope [Nn]ote:|Examples:|Domain:|Range:|Quantification:|Equal to:|Shortcut of:|Is covered by shortcut:">
                                                <xsl:matching-substring>
                                                    <xsl:if test="position()=$prev">
                                                        <xsl:value-of select="."/>
                                                    </xsl:if>
                                                </xsl:matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="contains($type,'Domain')">
                                                <xsl:for-each select="tokenize(.,';@-')">
                                                    <xsl:if test="normalize-space(.) != ''">
                                                        <rdfs:domain>
                                                            <xsl:attribute name="rdf:resource"><xsl:choose><xsl:when test="starts-with(normalize-space(.),'E')">
                                                                <xsl:value-of select="$current_prefix"/></xsl:when><xsl:otherwise >
                                                                    <xsl:value-of select="$frbroo_prefix"/></xsl:otherwise></xsl:choose><xsl:value-of select="replace(normalize-space(.),' ','_')"/></xsl:attribute>
                                                        </rdfs:domain>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="contains($type,'Range')">
                                                <xsl:for-each select="tokenize(.,';@-')">
                                                    <xsl:if test="normalize-space(.) != ''">
                                                        <rdfs:range>
                                                            <xsl:attribute name="rdf:resource"><xsl:choose><xsl:when test="starts-with(normalize-space(.),'E')">
                                                                <xsl:value-of select="$current_prefix"/></xsl:when><xsl:otherwise >
                                                                    <xsl:value-of select="$frbroo_prefix"/></xsl:otherwise></xsl:choose><xsl:value-of select="replace(normalize-space(.),' ','_')"/></xsl:attribute>
                                                        </rdfs:range>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="contains($type,'Subproperty')">
                                                <xsl:for-each select="tokenize(.,';@-')">
                                                    <xsl:if test="normalize-space(.) != '' and normalize-space(.) != 'Out of CRM Scope.' and normalize-space(.) != 'out of CRM Scope' ">
                                                        
                                                        <rdfs:subPropertyOf>
                                                            <xsl:attribute name="rdf:resource"><xsl:choose><xsl:when test="starts-with(normalize-space(.),'P')">
                                                                <xsl:value-of select="$current_prefix"/></xsl:when><xsl:otherwise >
                                                                    <xsl:value-of select="$frbroo_prefix"/></xsl:otherwise></xsl:choose><xsl:value-of select="replace(normalize-space(replace(substring-before(substring-after(normalize-space(.),'.'),':'),' \(.*','')),' ','_')"/></xsl:attribute>
                                                        </rdfs:subPropertyOf>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="contains($type,'Superproperty')">
                                                <xsl:for-each select="tokenize(.,';@-')">
                                                    <xsl:if test="normalize-space(.) != ''">
                                                        <rdfs:superPropertyOf>
                                                            <xsl:attribute name="rdf:resource"><xsl:choose><xsl:when test="starts-with(normalize-space(.),'P')">
                                                                <xsl:value-of select="$current_prefix"/></xsl:when><xsl:otherwise >
                                                                    <xsl:value-of select="$frbroo_prefix"/></xsl:otherwise></xsl:choose><xsl:value-of select="replace(normalize-space(replace(substring-before(substring-after(normalize-space(.),'.'),':'),' \(.*','')),' ','_')"/></xsl:attribute>
                                                        </rdfs:superPropertyOf>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <!-- owl:cardinality missing due to unclear translation from Quantification -->
                                            <xsl:when test="matches($type,'Scope|Example|Quantification|Shortcut')">
                                                <rdfs:comment><xsl:value-of select="$type"/><xsl:text>&#xa;</xsl:text><xsl:for-each select="tokenize(.,';@-')"><xsl:value-of select="normalize-space(.)"/></xsl:for-each></rdfs:comment>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </owl:ObjectProperty>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each-group>         	 
            </rdf:RDF>
        </xsl:result-document>
        
    </xsl:template>
    
</xsl:stylesheet>
