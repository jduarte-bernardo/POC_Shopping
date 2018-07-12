<aura:application access="GLOBAL" extends="ltng:outApp" >
    <aura:attribute name="recordId" type="String" default=""/>
    <aura:attribute name="TipoRegistro" type="String" default=""/>
    <aura:attribute name="TipoChamada" type="String" default=""/>
    <c:TW1_Ancar_Venda_NovaCotacao recordId="{!v.recordId}" TipoRegistro="{!v.TipoRegistro}" TipoChamada="{!v.TipoChamada}" />
</aura:application>