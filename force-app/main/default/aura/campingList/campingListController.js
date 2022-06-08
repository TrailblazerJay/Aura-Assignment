({
    clickCreateItem: function(component, event, helper) 
    {
        let validItem = component.find('itemform').reduce(function (validSoFar, inputCmp) 
        {
            console.log(inputCmp);
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validItem)
        {
            let newItem = component.get("v.newItem");
        	let theItems = component.get("v.items");
            theItems.push(newItem);
            console.log("Create Item: " + JSON.stringify(newItem));        
            component.set("v.items", theItems);
            component.set("v.newItem",{'sobjectType':'Camping_Item__c','Name': '','Quantity__c': 0,'Price__c': 0,'Packed__c': false});
        }
    }
})