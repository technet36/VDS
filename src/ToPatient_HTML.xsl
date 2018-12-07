<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <html>
            <head>
                <title>Patient</title>
                <link rel="stylesheet" href="./patient.css" type="text/css" />
                <script type="text/javascript">
                    function toggle_actes(patient_row){
                        patient_row.nextElementSibling.classList.toggle("removed");
                    }
                </script>
            </head>
            <body>
                <h2> Vos informations </h2>
                Nom : <xsl:value-of select="patient/nom"/><br/>
                Prenom : <xsl:value-of select="patient/prénom"/><br/>
                Sexe : <xsl:value-of select="patient/sexe"/><br/>
                Naissance : <xsl:value-of select="patient/naissance"/><br/>
                Numero : <xsl:value-of select="patient/numéro"/><br/>
                Adresse :
                <xsl:value-of select="patient/adresse/numéro"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="patient/adresse/rue"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="patient/adresse/codePostal"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="patient/adresse/ville"/>
                <xsl:text> </xsl:text>
                <xsl:if test="patient/adresse/étage">
                    (étage: <xsl:value-of select="patient/adresse/étage"/>)
                </xsl:if>

                <hr/>

                <h1> Vos visites </h1>

                <table class="patients_table">
                    <tr>
                        <th>Date</th>
                        <th>Intervenant</th>
                    </tr>
                    <xsl:apply-templates select="//visite"/>
                </table>

            </body>
        </html>

    </xsl:template>


    <xsl:template match="visite">

        <tr class="patient_row" onclick="toggle_actes(this)">
            <td>
                <xsl:value-of select="@date"/>
            </td>
            <td>
                <xsl:value-of select="//prénom"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="//nom"/>
            </td>
        </tr>
        <tr class="patient_row_acte removed" >
            <td class="act_td" colspan="2">
                <table class="actes_table">
                    <tr class="row_acte_header">
                        <th>Acte</th>
                    </tr>
                    <xsl:apply-templates select="actes/acte"/>
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="acte">
        <tr class="row_acte">
            <td>
                <xsl:value-of select="./text()"/>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>