({
	doInit : function(component, event, helper) {
		var action=component.get("c.objectNames");
        action.setCallback(this,function(e)
        {
            var records=e.getReturnValue();
            /*
            var objectMap=[];
            for(var key in records)
            {
                objectMap.push({key:key,value:records[key]});
            }
            console.log('Objects Count-'+objectMap.size);
            */
            component.set('v.objNames',records);
        });
        $A.enqueueAction(action);
	},
    
    
    inputChanged:function(component, event, helper){
        var objName = component.find('objects').get("v.value");
        
        var action=component.get("c.fieldNames");
        console.log(objName);
        action.setParams({Obj:objName});
        action.setCallback(this,function(e)
        {
        	var records=e.getReturnValue();
            var fieldNameMap=[];
            for(var key in records)
            {
                fieldNameMap.push({key:key,value:records[key]});
            }
            component.set('v.fieldNames',fieldNameMap);
        });
        $A.enqueueAction(action);
    },
    
    fieldSelected1:function(component, event, helper){
        var objName = component.find('field1').get("v.value");
        console.log(objName);
        component.set("v.field1Name",objName);
    },
    
    fieldSelected2:function(component, event, helper){
        var objName = component.find('field2').get("v.value");
        console.log(objName);
        component.set("v.field2Name",objName);
    },
    
    fieldSelected3:function(component, event, helper){
        var objName = component.find('field3').get("v.value");
        console.log(objName);
        component.set("v.field3Name",objName);
    },
    
    handleUserId:function(component,event,helper)
    {
     	var userId=component.find("lookupField").get("v.value");
        console.log(userId);
        component.set("v.userId",userId);
    },
    
    createExportData:function(component,event,helper)
    {
     	var userId=component.get("v.userId");
    	var objectName=component.get("v.ed.Object__c");
        
    	var field1Name = component.get("v.field1Name");
		var field2Name = component.get("v.field2Name");    
 	   	var field3Name = component.get("v.field3Name");    
 	   	var field1Value = component.get("v.field1Value");
		var field2Value = component.get("v.field2Value");    
 	   	var field3Value = component.get("v.field3Value");    
 	   
        console.log(userId+' '+objectName);
    	console.log(field1Name+' name '+field2Name);
    	console.log(field1Value+' '+field2Value);
        var action=component.get("c.createExportDataRecord");
        
        var Filters="";
        var Fields="";
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
        if(Filters.endsWith(';'))
        {
            Filters=Filters.substring(0,Filters.length-1);
            console.log(Filters);
        }
        if(Fields.endsWith(';'))
        {
            Fields=Fields.substring(0,Fields.length-1);
            console.log(Fields);
        }

        console.log(Filters);
        console.log(Fields);    
        action.setParams({
            "userId":userId,
            "objectName":objectName,
            "Filters":Filters,
            "Fields":Fields,
        });
        console.log(action);
        action.setCallback(this,function(e)
        {
        	var state = e.getReturnValue();
        	//var state = e.getState();
            console.log(state);
            if(state==="SUCCESS")
            {
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Export Data Record Created Successfully',
                    message: state,
                    duration:' 2000',
                    type: 'success'
                });
                toastEvent.fire();

                var homeEvt = $A.get("e.force:navigateToObjectHome");
                homeEvt.setParams({
                    "scope": "ExportData__c"
                });
                homeEvt.fire();
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
    cancelDialog : function(component, event, helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "ExportData__c"
        });
        homeEvt.fire();
	}
})