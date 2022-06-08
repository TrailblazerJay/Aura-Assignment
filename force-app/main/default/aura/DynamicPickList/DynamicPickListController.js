({
	doInit : function(component, event, helper) 
    {
        //Calling objectNames() of Apex Controller
		var action=component.get("c.objectNames");
        action.setCallback(this,function(e)
        {
            var objectNameList=e.getReturnValue();
            component.set('v.objNames',objectNameList);
        });
        $A.enqueueAction(action);
	},
    
    //Sets the userId got from Lookup
    handleUserId:function(component,event,helper)
    {
     	var userId=component.find("userId").get("v.value");
        component.set("v.userId",userId);
    },

    //Object selected then populate field names in below picklists
    objectSelected:function(component, event, helper){
        
        var objectName=component.find('objects').get("v.value");
        component.set('v.objectName',objectName);
        
        //Calling fieldNames() of Apex Controller
        var action=component.get("c.fieldNames");
        action.setParams({Obj:objectName});
        action.setCallback(this,function(e)
        {
        	var fieldNameList=e.getReturnValue();
            component.set('v.fieldNames',fieldNameList);
        });
        $A.enqueueAction(action);
    },
    
    //Field1 Name salected
    fieldSelected1:function(component, event, helper){
        var field1Name = component.find('field1').get("v.value");
        component.set("v.field1Name",field1Name);
    },
    
    //Field2 Name salected
    fieldSelected2:function(component, event, helper){
        var field2Name = component.find('field2').get("v.value");
        component.set("v.field2Name",field2Name);
    },
    
    //Field3 Name salected
    fieldSelected3:function(component, event, helper){
        var field3Name = component.find('field3').get("v.value");
        component.set("v.field3Name",field3Name);
    },
    
    //takes data from all variables and sends it to Apex Controller
    createExportData:function(component,event,helper)
    {
        var Filters="";
        var Fields="";

        //Getting All values
     	var userId=component.get("v.userId");
    	var objectName=component.get("v.objectName");
        
    	var field1Name = component.get("v.field1Name");
		var field2Name = component.get("v.field2Name");    
 	   	var field3Name = component.get("v.field3Name");    
 	   	var field1Value = component.get("v.field1Value");
		var field2Value = component.get("v.field2Value");    
 	   	var field3Value = component.get("v.field3Value");    
 	   
        //Calling createExportDataRecord() of Apex Controller and passing Parameters
        var action=component.get("c.createExportDataRecord");
        
        //Checking if All the fields were selected
        if(field1Name!=null && field1Name!="")
        {
            Filters+=field1Name+':'+field1Value+';';
            Fields+=field1Name+';';
        }
        if(field2Name!=null && field2Name!="")
        {
            Filters+=field2Name+':'+field2Value+';';
            Fields+=field2Name+';';
        }
        if(field3Name!=null && field3Name!="")
        {
            Filters+=field3Name+':'+field3Value;
            Fields+=field3Name;
        }

        //Removing End ;
        if(Filters.endsWith(';'))
        {
            Filters=Filters.substring(0,Filters.length-1);
        }
        if(Fields.endsWith(';'))
        {
            Fields=Fields.substring(0,Fields.length-1);
        }
   
        //Passing values to Apex Controller
        action.setParams({
            "userId":userId,
            "objectName":objectName,
            "Filters":Filters,
            "Fields":Fields,
        });
        action.setCallback(this,function(e)
        {
        	var state = e.getReturnValue();
        	
            if(state==="SUCCESS")
            {
                var homeEvt = $A.get("e.force:navigateToObjectHome");
                homeEvt.setParams({
                    "scope": "ExportData__c"
                });
                homeEvt.fire();

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message : 'Export Data Record Created Successfully',
                    title: state,
                    duration:' 2000',
                    type: 'success'
                });
                toastEvent.fire();
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: state,
                    duration:' 5000',
                    type: 'error'
                });
                toastEvent.fire();
                }
            }
            );
        
        $A.enqueueAction(action);
    },

    //Method to close the Model
    cancelDialog : function(component, event, helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "ExportData__c"
        });
        homeEvt.fire();
	}
})