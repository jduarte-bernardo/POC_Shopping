<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_status_do_cartao</fullName>
        <field>TW1_Status__c</field>
        <literalValue>Inativo</literalValue>
        <name>Atualiza status do cartão</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Preenche_NumeroCartao</fullName>
        <field>TW1_Numero_do_Cartao__c</field>
        <formula>Name</formula>
        <name>Preenche NumeroCartao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_CarEstacionamento_PreencheNumeroCartao</fullName>
        <actions>
            <name>Preenche_NumeroCartao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Copia o número do cartão automático do campo padrão oculto para o campo personalizado &quot;Número do Cartão&quot;.</description>
        <formula>ISNEW() &amp;&amp; ISBLANK(TW1_Numero_do_Cartao__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_CartaoEstacionamento_Verifica_DataFim</fullName>
        <actions>
            <name>Atualiza_status_do_cartao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Verifica se a data fim está válida, caso contrário inativa o cartão.</description>
        <formula>TW1_Data_Fim__c  &lt; TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
