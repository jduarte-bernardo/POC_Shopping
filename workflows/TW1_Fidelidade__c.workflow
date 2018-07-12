<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_SGL</fullName>
        <field>TW1_SGL__c</field>
        <formula>TW1_Shopping__r.TW1_SGL_Empreendimento__c</formula>
        <name>Atualiza SGL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Desmarcar_Acao_Marketing</fullName>
        <field>Acao_Marketing__c</field>
        <literalValue>0</literalValue>
        <name>Desmarcar Ação Marketing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Atualiza SGL</fullName>
        <actions>
            <name>Atualiza_SGL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Preenche o campo oculto &quot;SGL&quot; para o funcionamento do compartilhamento.</description>
        <formula>ISNEW() || ISCHANGED(TW1_Shopping__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Fidelidade_Desmarca_Acao_Marketing</fullName>
        <actions>
            <name>Desmarcar_Acao_Marketing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Quando um cliente Platinum por meio do marketing voltar a se tornar prospect o campo Ação Marketing será desmarcado.</description>
        <formula>AND(ISCHANGED(TW1_Modalidade__c), ISPICKVAL(TW1_Modalidade__c, &quot;Prospect&quot;), Acao_Marketing__c = True)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Preenche_Id_Fidelidade_Cliente</fullName>
        <active>false</active>
        <criteriaItems>
            <field>TW1_Fidelidade__c.TW1_Modalidade__c</field>
            <operation>equals</operation>
            <value>Gold,Platinum,Prospect</value>
        </criteriaItems>
        <description>Preencher o campo de Fidelidade no campo relacionado no objeto de Conta.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
