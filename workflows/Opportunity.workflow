<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Aviso_e_proposta_aprovada</fullName>
        <description>Aviso e proposta aprovada</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TW1_Oportunidade_proposta_aprovada</template>
    </alerts>
    <alerts>
        <fullName>TW1_Email_aprovacao_de_proposta</fullName>
        <description>Email de aprovação de proposta</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/TW1_Oportunidade_proposta_aprovada</template>
    </alerts>
    <alerts>
        <fullName>TW1_Email_rejeicao_de_proposta</fullName>
        <description>Email de rejeição de proposta</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TW1_Oportunidade_proposta_rejeitada</template>
    </alerts>
    <alerts>
        <fullName>TW1_Envia_email_de_solicitacao_de_aprovacao</fullName>
        <description>Envia email de solicitação de aprovação</description>
        <protected>false</protected>
        <recipients>
            <recipient>TW1_Comercial_EC</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>TW1_Regional_Loja_Centro_Oeste_Norte_1</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>TW1_Regional_Loja_Centro_Oeste_Norte_2</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>TW1_Regional_Loja_Nordeste</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>TW1_Regional_Loja_Rio_de_Janeiro</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>TW1_Regional_Loja_Sao_Paulo</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TW1_Oportunidade_solicitacao_de_aprovacao</template>
    </alerts>
    <alerts>
        <fullName>TW1_Solicitacao_de_reaprovacao</fullName>
        <description>Solicitação de reaprovação</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TW1_Oportunidade_solicitacao_de_aprovacao</template>
    </alerts>
    <fieldUpdates>
        <fullName>TW1_EstagioVendas_Proposta_aprovada</fullName>
        <field>StageName</field>
        <literalValue>Aprovada</literalValue>
        <name>Estagio de vendas Proposta aprovada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_EstagioVendas_Proposta_rejeitada</fullName>
        <field>StageName</field>
        <literalValue>Rejeitada</literalValue>
        <name>Estagio de vendas Proposta rejeitada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Oportunidade_aprovada_False</fullName>
        <field>TW1_Oportunidade_aprovada__c</field>
        <literalValue>0</literalValue>
        <name>Oportunidade aprovada False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Oportunidade_aprovada_true</fullName>
        <field>TW1_Oportunidade_aprovada__c</field>
        <literalValue>1</literalValue>
        <name>Oportunidade aprovada True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_PreecheEstagioDeVendas</fullName>
        <field>StageName</field>
        <literalValue>Em negociação</literalValue>
        <name>PreecheEstagioDeVendasDaOportunidade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Proposta_aguardando_aprovacao</fullName>
        <field>StageName</field>
        <literalValue>Aguardando aprovação</literalValue>
        <name>Proposta aguardando aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Proposta_reenviada_para_aprovacao</fullName>
        <field>StageName</field>
        <literalValue>Aguardando aprovação</literalValue>
        <name>Proposta reenviada para aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Valor</fullName>
        <field>Amount</field>
        <formula>IF(NOT(ISBLANK(TW1_VGL_total__c)), TW1_VGL_total__c, TW1_Valor__c)</formula>
        <name>Valor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Preenche Amount</fullName>
        <actions>
            <name>Valor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISNEW() || (ISCHANGED(TW1_VGL_total__c) || ISCHANGED(TW1_Valor__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>W1_WF_Oportunidade_DefaultValueEstagioDeVendas</fullName>
        <actions>
            <name>TW1_PreecheEstagioDeVendas</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Preenche o estagio de vendas da cotação com valor default &quot;Em Negociação&quot;</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
