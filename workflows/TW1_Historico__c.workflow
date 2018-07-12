<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copia_valor</fullName>
        <field>TW1_Pontos__c</field>
        <formula>TW1_Valor_RS__c</formula>
        <name>Copia valor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Marca_Bonus_Aniversario</fullName>
        <field>TW1_Bonus_Aniversario__c</field>
        <literalValue>1</literalValue>
        <name>Marca Bonus Aniversario</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>TW1_Fidelidade__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_Historico_Marca_Bonus_Aniversario</fullName>
        <actions>
            <name>Marca_Bonus_Aniversario</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Quando o registro de aniversário for criado no histórico da fidelidade marcará o campo &quot;Bônus Aniversário&quot; oculto na fidelidade.</description>
        <formula>ISNEW() &amp;&amp; ISPICKVAL(TW1_Tipo__c, &apos;Aniversario&apos;) &amp;&amp; TW1_Fidelidade__r.TW1_Bonus_Aniversario__c = False</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Historico_converte_valor_pontos</fullName>
        <actions>
            <name>Copia_valor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Copia o campo Valor (R$) para o campo Pontos para que o mesmo sumarize em Fidelidade.</description>
        <formula>(ISNEW() || ISCHANGED(TW1_Valor_RS__c)) &amp;&amp; (ISPICKVAL(TW1_Tipo__c, &apos;Cadastro de NTFS&apos;) || ISPICKVAL(TW1_Tipo__c, &apos;Nota Expirada&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
