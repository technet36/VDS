<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:inf="http://www.ujf-grenoble.fr/l3miage/medical"
    xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes">


    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>
    <xsl:param name="destinedName" >Alécole</xsl:param>
    <xsl:variable name="destinedPatient" select="//inf:patient[inf:nom/text()=$destinedName]"/>
<!--
    question: 6.1
    todo : formatted output
-->
    <xsl:output method="xml" indent="yes"/>


    <xsl:template match="/">
        <patient>
            <nom><xsl:value-of select="$destinedName"/></nom>
            <prénom><xsl:value-of select="$destinedPatient/inf:prénom"/></prénom>
            <sexe><xsl:value-of select="$destinedPatient/inf:sexe"/></sexe>
            <naissance><xsl:value-of select="$destinedPatient/inf:naissance"/></naissance>
            <numéro><xsl:value-of select="$destinedPatient/inf:numéro"/></numéro>
            <adresse>
                <numéro><xsl:value-of select="inf:adresse/inf:numéro"/></numéro>
                <rue><xsl:value-of select="$destinedPatient/inf:adresse/inf:rue"/></rue>
                <ville><xsl:value-of select="$destinedPatient/inf:adresse/inf:ville"/></ville>
                <codePostal><xsl:value-of select="$destinedPatient/inf:adresse/inf:codePostal"/></codePostal>
                <xsl:if test="inf:adresse/inf:étage">
                    <étage><xsl:value-of select="inf:adresse/inf:étage"/></étage>
                </xsl:if>
            </adresse>

            <xsl:apply-templates select="$destinedPatient/inf:visite"/>

        </patient>
    </xsl:template>

    <xsl:template match="inf:visite">
        <visite>
            <xsl:attribute name="date">
                "<xsl:value-of select="@date"/>"
            </xsl:attribute>
            <xsl:if test="@intervenant">
                <xsl:variable name="id_inf" select="@intervenant"/>
                <xsl:variable name="infirmier" select="//inf:infirmiers/inf:infirmier[@id=$id_inf]"/>
                <intervenant>
                    <nom> <xsl:value-of select="$infirmier/inf:nom"/> </nom>
                    <prénom> <xsl:value-of select="$infirmier/inf:prénom"/> </prénom>
                </intervenant>
            </xsl:if>
            <actes>
                <xsl:apply-templates select="inf:acte"/>
            </actes>
        </visite>
    </xsl:template>


    <xsl:template match="inf:acte">
        <xsl:param name="id_acte" select="@id"/>
        <acte>
            <xsl:value-of select="$actes//act:acte[@id=$id_acte]"/>
        </acte>
    </xsl:template>


</xsl:stylesheet>