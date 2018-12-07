<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:inf='http://www.ujf-grenoble.fr/l3miage/medical'
                xmlns:act='http://www.ujf-grenoble.fr/l3miage/actes'>
    <xsl:param
        name="id_infirmier"
        select="001"/>
    <xsl:variable
        name="visitesDuJour"
        select="//inf:patient/inf:visite[@intervenant=$id_infirmier]"/>
    <xsl:variable
        name="actes"
        select="document('actes.xml', /)/act:ngap"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Voyageur de santé</title>
                <link rel="stylesheet" href="./cabinet.css" type="text/css" />
                <script type="text/javascript" src="./facture.js"/>
                <script type="text/javascript">
                    function openFacture(prenom, nom, actes) {
                        var width  = 1000;
                        var height = 600;
                        if(window.innerWidth) {
                            var left = (window.innerWidth-width)/2;
                            var top = (window.innerHeight-height)/2;
                        }
                        else {
                            var left = (document.body.clientWidth-width)/2;
                            var top = (document.body.clientHeight-height)/2;
                        }
                        var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
                        //factureText = "Facture pour : " + prenom + " " + nom;
                        var factureText = afficherFacture(prenom, nom, actes);
                        factureWindow.document.write(factureText);
                    }
                    function toggle_actes(patient_row){
                        patient_row.nextElementSibling.classList.toggle("removed");
                    }
                </script>
            </head>
            <body>
                <h2 id ="titre">Cabinet médical</h2>
                <p>Bonjour
                    <xsl:value-of select="//inf:infirmier[@id=$id_infirmier]/inf:prénom"/>
                    ,
                    <br/>
                    <br/>
                    Aujourd'hui, vous avez
                    <xsl:value-of select="count($visitesDuJour)"/>
                    patients.
                </p>
                <hr/>
                <div>
                    <h3>Patient :</h3>
                    <table class="patients_table">
                        <tr>
                            <th>Nom</th>
                            <th>Adresse</th>
                            <th/>
                        </tr>
                        <xsl:apply-templates select="$visitesDuJour/.."/>
                    </table>
                </div>
                <hr/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="inf:patient">

        <tr class="patient_row" onclick="toggle_actes(this)">
            <td>
                <xsl:value-of select="inf:prénom"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="inf:nom"/>
            </td>
            <td>
                <xsl:value-of select="inf:adresse/inf:numéro"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="inf:adresse/inf:rue"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="inf:adresse/inf:codePostal"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="inf:adresse/inf:ville"/>
                <xsl:text> </xsl:text>
                <xsl:if test="inf:adresse/inf:étage">
                    (étage: <xsl:value-of select="inf:adresse/inf:étage"/>)
                </xsl:if>
            </td>
            <td>
                <button>
                    <xsl:attribute name="onclick">
                        openFacture(
                        '<xsl:value-of select="inf:prénom"/>',
                        '<xsl:value-of select="inf:nom"/>',
                        '<xsl:value-of select="inf:visite/inf:acte/@id"/>'
                        )
                    </xsl:attribute>
                    Facture
                </button>
            </td>
        </tr>
        <tr class="patient_row_acte removed" >
            <td class="act_td" colspan="3">
                <table class="actes_table">
                    <tr class="row_acte_header">
                        <th>Acte</th>
                        <th>Commentaire</th>
                    </tr>
                    <xsl:apply-templates select="inf:visite"/>
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="inf:acte">
        <xsl:variable name="act_id" select="@id"/>
        <xsl:variable name="act_type" select="$actes//act:actes/act:acte/@type"/>
        <tr class="row_acte">
            <td>
                <xsl:value-of select="$actes//act:actes/act:acte[@id=$act_id]"/>
            </td>
            <td>
                <xsl:value-of select="$actes//act:types/act:type[@id=$act_type]"/>
            </td>
            <td></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>