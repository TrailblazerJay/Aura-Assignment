<aura:application controller="DynamicPickList" extends="force:slds">
    
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>

    <aura:attribute name="objNames" type="string[]"/>
    <aura:attribute name="fieldNames" type="string[]"/>
    <aura:attribute name="usersId" type="String"/>
    <aura:attribute name="objectName" type="String"/>
    <aura:attribute name="field1Name" type="String"/>
    <aura:attribute name="field1Value" type="String"/>
    <aura:attribute name="Filters" type="String"/>
    <aura:attribute name="Fields" type="String"/>

    <lightning:layout class="slds-page-header slds-page-header_object-home">
        <lightning:layoutItem>
            <lightning:icon iconName="action:goal" alternativeText="Create ExportData"/>
        </lightning:layoutItem>
        <lightning:layoutItem padding="horizontal-small">
            <div class="page-section page-header">
                <h1 class="slds-text-heading_label">ExportData</h1>
                <h2 class="slds-text-heading_medium">Create ExportData</h2>
            </div>
        </lightning:layoutItem>
    </lightning:layout>

    <lightning:layout>
    	<lightning:layoutItem padding="around-small" size="12">
        	<div aria-labelledby="exportdataform">
            	<fieldset class="slds-box slds-theme_default slds-container_small">
                	<legend id="exportdataform" class="slds-text-heading_small slds-p-vertical_medium">Add ExportData</legend>
                    <form action="https://jaymalde-developer-edition.ap27.force.com/exportdata/services/apexrest/api/create/ExportData/" method="POST">
                        <lightning:recordEditForm objectApiName="ExportData__c">
                            <lightning:inputField aura:id="userId" fieldName="User__c" onchange="{!c.handleUserId}" />
                        </lightning:recordEditForm>
                        
                        <lightning:select label="Objects" aura:id="objects" name="objectName" value="{!v.objectName}" onchange="{!c.objectSelected}">
                            <option value="">--None--</option>
                            <aura:iteration items="{!v.objNames}" var="objectValue">
                                    <option value="{!objectValue}" text="{!objectValue}" selected="{!objectValue==v.objectName}"/>
                            </aura:iteration>
                        </lightning:select>
                        
                        <lightning:select label="Field1" value="v.field1Name" name="fiel1Name" aura:id="field1" onchange="{!c.fieldSelected1}">
                            <option value="">--None--</option>
                            <aura:iteration items="{!v.fieldNames}" var="fieldName1">
                                <option value="{!fieldName1}" text="{!fieldName1}" selected="{!fieldName1==v.field1Name}"/>
                            </aura:iteration>
                        </lightning:select>
                        <lightning:input aura:id="field1Value" value="{!v.field1Value}" type="text" label="Field 1 Value" name="Field1Value"/>

                        <lightning:input name="Filters" value="{!v.Filters}" aura:Id="Filters" class="slds-hide"/>
                        <lightning:input name="Fields" value="{!v.Fields}" aura:Id="Fields" class="slds-hide"/>
                        <lightning:input name="usersId" value="{!v.usersId}" aura:Id="usersId" class="slds-hide"/>
                        <lightning:button type="submit" variant="brand" label="Create ExportData" onclick="{!c.buttonClicked}"/>
                    </form>
                </fieldset>
            </div>
        </lightning:layoutItem>
    </lightning:layout>   
</aura:application>	