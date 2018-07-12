<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copia_Nome</fullName>
        <field>TW1_Nome_do_Filmes__c</field>
        <formula>Name</formula>
        <name>Copia Nome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_Programacao_Copia_Nome</fullName>
        <actions>
            <name>Copia_Nome</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Copia nome do registro para o campo &quot;Nome do Filme&quot; para validar como exclusivo.</description>
        <formula>ISNEW() || ISCHANGED(Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
