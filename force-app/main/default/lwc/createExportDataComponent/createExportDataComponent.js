import createExportDataRecord from '@salesforce/apex/DynamicPickList.createExportDataRecord';
import fieldNames from '@salesforce/apex/DynamicPickList.fieldNames';
import objectNames from '@salesforce/apex/DynamicPickList.objectNames';
import { LightningElement ,api, wire, track} from 'lwc';

export default class CreateExportDataComponent extends LightningElement 
{
    error="";
    userId="";
    objectName="";
    field1Name="";
    field1Value="";
    field2Value="";
    field3Value="";
    field2Name="";
    field3Name="";
    
    @api objectList;
    @api options;
    @api fieldOptions;

    @wire(objectNames)
    getObjectNames({error,data})
    {
        if(data)
        {
            let options=[];
            data.forEach(r => 
                {
                options.push({
                    label: r,
                    value: r,
                });
                });

            this.options=options;
            this.error=undefined;
        }
        else if(error)
        {
            this.error=error;
            this.objectList=undefined;
        }
    }
    
    handleUserId(event)
    {
        this.userId=event.target.value;
        console.log(this.userId);
    }

    onObjectSelected(event)
    {
        this.objectName=event.detail.value;

        fieldNames({Obj:this.objectName})
        .then((data)=>{
        if(data)
        {
            let options=[];
            data.forEach(r =>
                {
                options.push({
                    label: r,
                    value: r,
                });
                });

            this.fieldOptions=options;
            this.error=undefined;
            }
        })
        .catch(err=>{
            console.log(err);
        })   
    }

    onField1Selected(event)
    {
        this.field1Name=event.detail.value;
    }
    onField2Selected(event)
    {
        this.field2Name=event.detail.value;
    }
    onField3Selected(event)
    {
        this.field3Name=event.detail.value;
    }

    field1ValueChanged(event)
    {
        this.field1Value=event.target.value;
    }
    field2ValueChanged(event)
    {
        this.field2Value=event.target.value;
    }
    field3ValueChanged(event)
    {
        this.field3Value=event.target.value;
    }

    formSubmitted()
    {
        // console.log("UserId-"+this.userId+"\nObject Name-"+this.objectName+"\nfield1-"+this.field1Name+"\nfield2-"+this.field2Name+"\nfield3-"+this.field3Name+"\nfield1Value-"+this.field1Value+"\nfield2Value-"+this.field2Value+"\nfield3Value-"+this.field3Value);
        // alert("UserId-"+this.userId+"\nObject Name-"+this.objectName+"\nfield1-"+this.field1Name+"\nfield2-"+this.field2Name+"\nfield3-"+this.field3Name+"\nfield1Value-"+this.field1Value+"\nfield2Value-"+this.field2Value+"\nfield3Value-"+this.field3Value);
        
        var Filters="";
        var Fields="";

        if(this.field1Name!=null && this.field1Name!="")
        {
            Filters+=this.field1Name+':'+this.field1Value+';';
            Fields+=this.field1Name+';';
        }
        if(this.field2Name!=null && this.field2Name!="")
        {
            Filters+=this.field2Name+':'+this.field2Value+';';
            Fields+=this.field2Name+';';
        }
        if(this.field3Name!=null && this.field3Name!="")
        {
            Filters+=this.field3Name+':'+this.field3Value+';';
            Fields+=this.field3Name+';';
        }
        
        if(Filters.endsWith(';'))
        {
            Filters=Filters.substring(0,Filters.length-1);
        }
        if(Fields.endsWith(';'))
        {
            Fields=Fields.substring(0,Fields.length-1);
        }

        createExportDataRecord({userId:this.userId,objectName:this.objectName,Filters:Filters,Fields:Fields})
        .then((res)=>{
            alert(res);
        })
    }
}