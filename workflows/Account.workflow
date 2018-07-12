<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Preenche_data_de_conversao_da_conta</fullName>
        <field>TW1_Data_de_conversao__c</field>
        <formula>DATETIMEVALUE(TODAY())</formula>
        <name>Preenche data de conversão da conta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Preenche_nome_do_shopping</fullName>
        <field>TW1_Nome_do_Shopping__c</field>
        <formula>TW1_Shopping__r.TW1_SGL_Empreendimento__c</formula>
        <name>Preenche nome do shopping</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Preenche_nome_fantasia</fullName>
        <field>TW1_Nome_fantasia__c</field>
        <formula>Name</formula>
        <name>Preenche nome fantasia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_PreencheDataDeConversao</fullName>
        <actions>
            <name>Preenche_data_de_conversao_da_conta</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Seleciona o campo &quot;data de conversão&quot; quando o tipo do registro é alterado de prospect para contato comercial pf</description>
        <formula>AND(ISCHANGED(TW1_Conta_convertida__c),ISPICKVAL(TW1_Conta_convertida__c, &apos;Sim&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TW1_PreencheNomeFantasiaVendas</fullName>
        <actions>
            <name>Preenche_nome_fantasia</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contato comercial PJ,Prospect</value>
        </criteriaItems>
        <description>Copia o valor do campo &quot;account name&quot; para o campo nome fantasia no cadastro de conta do tipo contato comercial PJ</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Conta_Loja_Copia_nome_shopping</fullName>
        <actions>
            <name>Preenche_nome_do_shopping</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED(TW1_Shopping__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
