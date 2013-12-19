<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd tei"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Dec 19, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> emeryr</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output indent="yes"/>
  
    <xsl:template match="/">
        <xsl:variable name="from_folio" select="//tei:msItem/tei:title[text() = 'Calendar']/parent::tei:msItem/tei:locus/@from"/>
        <xsl:variable name="to_folio" select="//tei:msItem/tei:title[text() = 'Calendar']/parent::tei:msItem/tei:locus/@to"/>
        <xsl:variable name="shelf_mark" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno"/>
        <xsl:variable name="url_base" select="concat('http://purl.thewalters.org/art/', $shelf_mark, '/data')"/>
        <calendar-pages>
            <shelf-mark><xsl:value-of select="$shelf_mark"></xsl:value-of></shelf-mark>
            <title><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='common']"></xsl:value-of></title>
            <tei url="{concat('http://purl.thewalters.org/art/', $shelf_mark, '/TEI')}"/>
            <xsl:call-template name="build_links">
                <xsl:with-param name="from_folio" select="$from_folio"/>
                <xsl:with-param name="to_folio" select="$to_folio"/>
                <xsl:with-param name="url_base" select="$url_base"/>
            </xsl:call-template>
        </calendar-pages>
    </xsl:template>
    
    <xsl:template name="build_links">
        <xsl:param name="from_folio"/>
        <xsl:param name="to_folio"/>
        <xsl:param name="url_base"/>
        <xsl:variable name="from_position" select="count(//tei:surface[@n = concat('fol. ', $from_folio)]/preceding-sibling::tei:surface) + 1"/>
        <xsl:variable name="to_position" select="count(//tei:surface[@n = concat('fol. ', $to_folio)]/preceding-sibling::tei:surface) + 1"/>
        <xsl:for-each select="//tei:surface[position() >= $from_position and not(position() > $to_position)]">
            <xsl:variable name="page" select="./@n"/>
            <xsl:variable name="url" select="concat($url_base, '/', replace(./tei:graphic[matches(@url, '_sap.jpg$')]/@url, '//', '/'))"/>
            <page n="{$page}" url="{$url}"/>
        </xsl:for-each>
    </xsl:template>
    
    
    
</xsl:stylesheet>