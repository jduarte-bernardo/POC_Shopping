<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_Tipo_Elogio</fullName>
        <field>Type</field>
        <literalValue>Elogios</literalValue>
        <name>Atualiza Tipo Elogio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Tipo_Reclamacao</fullName>
        <field>Type</field>
        <literalValue>Reclamações</literalValue>
        <name>Atualiza Tipo Reclamacao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Tipo_Solicitacao</fullName>
        <field>Type</field>
        <literalValue>Solicitações</literalValue>
        <name>Atualiza Tipo Solicitacao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Tipo_Sugestao</fullName>
        <field>Type</field>
        <literalValue>Sugestões</literalValue>
        <name>Atualiza Tipo Sugestao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_Tipo_Elogio</fullName>
        <actions>
            <name>Atualiza_Tipo_Elogio</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Elogios</value>
        </criteriaItems>
        <description>Preenche o tipo da ocorrência de acordo com o tipo de registro.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_Tipo_Reclamacao</fullName>
        <actions>
            <name>Atualiza_Tipo_Reclamacao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Reclamações</value>
        </criteriaItems>
        <description>Preenche o tipo da ocorrência de acordo com o tipo de registro.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_Tipo_Solicitacao</fullName>
        <actions>
            <name>Atualiza_Tipo_Solicitacao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Solicitações</value>
        </criteriaItems>
        <description>Preenche o tipo da ocorrência de acordo com o tipo de registro.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_Tipo_Sugestao</fullName>
        <actions>
            <name>Atualiza_Tipo_Sugestao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sugestões</value>
        </criteriaItems>
        <description>Preenche o tipo da ocorrência de acordo com o tipo de registro.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
