<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Preenche_nome_do_shopping</fullName>
        <field>TW1_Shopping__c</field>
        <formula>TW1_SGL_Shopping__c</formula>
        <name>Preenche nome do shopping</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_Contato_Funcionario_Preenche_Shopping</fullName>
        <actions>
            <name>Preenche_nome_do_shopping</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Preenche o campo Shopping no contato do tipo &quot;Funcionário&quot;.</description>
        <formula>ISNEW() || ISCHANGED(TW1_SGL_Shopping__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
