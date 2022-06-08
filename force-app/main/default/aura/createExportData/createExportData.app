<aura:application  extends="force:slds">
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
    <c:createExportDataRecord/>
</aura:application>