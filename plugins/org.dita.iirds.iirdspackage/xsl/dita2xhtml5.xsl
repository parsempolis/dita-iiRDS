<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0" 
	xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
	xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
	xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="dita2html ditamsg related-links"
	>

	<xsl:import href="plugin:org.dita.html5:xsl/dita2html5Impl.xsl" />

	<xsl:output method="xml" encoding="UTF-8" indent="no"
		omit-xml-declaration="no" />

	<!-- root rule -->
	<xsl:template match="/">
		<xsl:variable name="phase1">
			<xsl:apply-templates />
		</xsl:variable>
		<xsl:apply-templates select="$phase1" mode="cleanup" />
	</xsl:template>

	<xsl:template match="*" mode="cleanup">
		<xsl:element name="{name(.)}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates select="@*"
				mode="cleanup" />
			<xsl:apply-templates select="node()" mode="cleanup" />
		</xsl:element>
	</xsl:template>

	<!-- ignore some elements -->
	<xsl:template match="meta|base|embed|object|canvas|svg|math|from|fieldset|legend|label|input|button|select|datalis|optgroup|option|textarea|keygen|progress|meter|iframe|command|menu" mode="cleanup"/>
	
	<xsl:template match="link[@rel='stylesheet']" mode="cleanup">
		<xsl:element name="{name(.)}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:copy-of select="@*"/>
		</xsl:element>
	</xsl:template>

	<!--  convert some elements to divisions  -->
	<xsl:template match="section|article|nav|main|base|noscript|aside|header|footer|address|blockquote|small|details" mode="cleanup">
		<div xmlns="http://www.w3.org/1999/xhtml" data-role="{name(.)}">
			<xsl:apply-templates select="@*" mode="cleanup" />
			<xsl:apply-templates mode="cleanup" />
		</div>
	</xsl:template>

	<!--  convert some elements to spans  -->
	<xsl:template match="var|code|mark|ruby|rt|rp|ins|del" mode="cleanup">
		<span xmlns="http://www.w3.org/1999/xhtml" data-role="{name(.)}">
			<xsl:apply-templates select="@*" mode="cleanup" />
			<xsl:apply-templates mode="cleanup" />
		</span>
	</xsl:template>
	
	<!-- hazardstatements and notes -->
	<xsl:template match="div[contains(@class,'note hazardstatement warning')]" mode="cleanup">
		<div xmlns="http://www.w3.org/1999/xhtml" data-role="warning">
			<xsl:apply-templates select="@*" mode="cleanup" />
			<xsl:apply-templates mode="cleanup" />
		</div>
	</xsl:template>
	<xsl:template match="div[contains(@class,'note hazardstatement caution')]" mode="cleanup">
		<div xmlns="http://www.w3.org/1999/xhtml" data-role="caution">
			<xsl:apply-templates select="@*" mode="cleanup" />
			<xsl:apply-templates mode="cleanup" />
		</div>
	</xsl:template>
	<xsl:template match="div[contains(@class,'note hazardstatement danger')]" mode="cleanup">
		<div xmlns="http://www.w3.org/1999/xhtml" data-role="danger">
			<xsl:apply-templates select="@*" mode="cleanup" />
			<xsl:apply-templates mode="cleanup" />
		</div>
	</xsl:template>
	<xsl:template match="div[contains(@class,'note hazardstatement note')]" mode="cleanup">
		<div xmlns="http://www.w3.org/1999/xhtml" data-role="notice">
			<xsl:apply-templates select="@*" mode="cleanup" />
			<xsl:apply-templates mode="cleanup" />
		</div>
	</xsl:template>
	
	<!-- message panel -->
	<xsl:template match="ul[contains(@class,'ul messagepanel')]" mode="cleanup">
		<div xmlns="http://www.w3.org/1999/xhtml" data-role="messagepanel">
			<ul xmlns="http://www.w3.org/1999/xhtml">
				<xsl:apply-templates select="@*" mode="cleanup" />
				<xsl:apply-templates mode="cleanup" />
			</ul>
		</div>
	</xsl:template>
	
	<!-- signalword panel -->
	<xsl:template match="span[contains(@class,'note__title')]" mode="cleanup">
		<div data-role="signalword-panel">
			<p xmlns="http://www.w3.org/1999/xhtml" data-role="signalword">
					<xsl:apply-templates select="@*" mode="cleanup" />
					<xsl:apply-templates mode="cleanup" />
			</p>
		</div>		
	</xsl:template>
	
	<!-- symbol panel -->
	<xsl:template match="img[contains(@class,'image hazardsymbol')]" mode="cleanup">
		<div xmlns="http://www.w3.org/1999/xhtml" data-role="symbol-panel">
			<img xmlns="http://www.w3.org/1999/xhtml">
					<xsl:apply-templates select="@*" mode="cleanup" />
					<xsl:apply-templates mode="cleanup" />
			</img>
		</div>	
	</xsl:template>



	<xsl:template match="@lang" mode="cleanup">
		<xsl:attribute name="xml:lang">
 		<xsl:value-of select="." />
 	</xsl:attribute>
	</xsl:template>


	<!-- ignore some attributes -->
	<xsl:template match="@class|@style|@role" mode="cleanup"/>

	<xsl:template match="@*" mode="cleanup">
		<xsl:copy />
	</xsl:template>

	<xsl:template match="text()" mode="cleanup">
		<xsl:copy/>
	</xsl:template>

	<xsl:template match="processing-instruction() | comment()"
		mode="cleanup">
		<xsl:copy />
	</xsl:template>

</xsl:stylesheet>
