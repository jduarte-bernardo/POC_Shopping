<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_Status</fullName>
        <field>TW1_Status__c</field>
        <literalValue>Devolvido</literalValue>
        <name>Atualiza Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualizada_data_de_devolu_o</fullName>
        <field>TW1_Data_da_Devolucao__c</field>
        <formula>NOW()</formula>
        <name>Atualizada data de devolução</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Preenche_Data_Devolucao</fullName>
        <field>TW1_Data_da_Devolucao__c</field>
        <formula>Now()</formula>
        <name>Preenche Data Devolução</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_Emprestimo_Altera_Status</fullName>
        <actions>
            <name>Atualizada_data_de_devolu_o</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Quando o status for alterado a data de devolução será preenchida.</description>
        <formula>ISCHANGED(TW1_Status__c) &amp;&amp; ISPICKVAL(TW1_Status__c, &quot;Devolvido&quot;) &amp;&amp; ISNULL(TW1_Data_da_Devolucao__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Emprestimo_atualizaStatus</fullName>
        <actions>
            <name>Atualiza_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Quando a data de devolução for preenchida o status será alterado para &quot;Devolvido&quot;.</description>
        <formula>ISCHANGED(TW1_Data_da_Devolucao__c) &amp;&amp; NOT(ISBLANK(TW1_Data_da_Devolucao__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Emprestimo_preenche_dataDevolucao</fullName>
        <actions>
            <name>Preenche_Data_Devolucao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Preenche data de devolução quando o status é alterado para devolvido.</description>
        <formula>ISCHANGED(TW1_Status__c) &amp;&amp; ISPICKVAL(TW1_Status__c, &apos;Devolvido&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
