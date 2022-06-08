({
    clickCreateExportData: function(component, event, helper) 
    {
        let validItem = component.find('exportdataform').reduce(function (validSoFar, inputCmp) 
        {
            console.log(inputCmp);
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validItem)
        {
            let newItem = component.get("v.exportData");
            console.log('ED-'+newItem);
        }
    }
})