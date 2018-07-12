<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TW1_Preenche_nome_com_plano_de_mix</fullName>
        <description>Preenche o campo nome com a composição do plano de mix (Ramo/segmento/tipo de atividade)</description>
        <field>Name</field>
        <formula>TW1_Plano_de_mix__r.TW1_Grupo_de_atividade__c &amp; &apos;/ &apos;&amp; TW1_Plano_de_mix__r.Ramo_de_atividade__c &amp; &apos;/ &apos;&amp; TW1_Plano_de_mix__r.TW1_Tipo_de_atividade__c</formula>
        <name>Preenche nome com plano de mix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_MarcaPlanoMix_PreencheNome</fullName>
        <actions>
            <name>TW1_Preenche_nome_com_plano_de_mix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Preenche o campo nome com a composição do plano de mix (Ramo/segmento/tipo de atividade)</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
