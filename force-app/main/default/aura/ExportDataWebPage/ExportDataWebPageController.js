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
        component.set("v.usersId",userId);
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

    buttonClicked:function(component,event,helper)
    {
        var Filters="";
        var Fields="";

        //Getting All values
     	var userId=component.get("v.userId");
    	var objectName=component.get("v.objectName");
        console.log(userId);
        console.log(objectName);
    	var field1Name = component.get("v.field1Name");
 	   	var field1Value = component.get("v.field1Value");
        console.log(field1Name);
        console.log(field1Value);
        
        if(field1Name!=null && field1Name!="")
        {
            Filters+=field1Name+':'+field1Value+';';
            Fields+=field1Name+';';
        }
        
        if(Filters.endsWith(';'))
        {
            Filters=Filters.substring(0,Filters.length-1);
        }
        if(Fields.endsWith(';'))
        {
            Fields=Fields.substring(0,Fields.length-1);
        }

        component.set("v.Filters",Filters);
        component.set("v.Fields",Fields);
        console.log(Filters);
        console.log(Fields);
    }
})
