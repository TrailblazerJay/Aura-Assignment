import { LightningElement, wire, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getDuplicatePracticeNReferrer from '@salesforce/apex/processSourceDataLWC.getDuplicatePracticeNReferrer';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createProviderandProfileCode from '@salesforce/apex/processSourceDataLWC.createProviderandProfileCode';

export default class ProcessSourceData extends LightningElement 
{
    @api practiceId;
    @api referrerId;
    @api recordId;

    practiceRadioValue;
    referrerRadioValue;
    practiceValue=false;
    referrerValue=false;
    value="";

    // @wire(getRecord,{recordId:"$recordId",fields:[
    //     'Source_Data__c.Id',
    //     'Source_Data__c.Name',
    //     'Source_Data__c.Description__c',
    //     'Source_Data__c.Organisation_Name__c',
    //     'Source_Data__c.First_Name__c',
    //     'Source_Data__c.Last_Name__c'
    // ]})
    // getSourceData({data,error})
    // {
    //     this.sourceData=data;
    //     console.log(data.fields.Name.value);  
    // }

    @wire(getDuplicatePracticeNReferrer,{sourceDataId:"$recordId"})
    getPracticeNReferrer({error,data})
    {
        if(data)
        {
            this.handleData(data);
        }
        else
        {
            console.log(error);
        }
    }

    handleData(data)
    {
        if(data)
        {
            this.value=data.split(" ");
            console.log(this.value);
            console.log('data');
            this.practiceId=this.value[0];
            this.referrerId=this.value[1];
            
        }
    }

    practiceRadioChanged(event)
    {
        alert(this.practiceId+' '+this.referrerId);
        if(event.target.value=="existing")
        {
            this.practiceValue=false;
        }
        else if(event.target.value=="new")
        {
            this.practiceValue=true;
        }
    }

    referrerRadioChanged(event)
    {
        if(event.target.value=="existing")
        {
            this.referrerValue=false;
        }
        else if(event.target.value=="new")
        {
            this.referrerValue=true;
        }
    }

    get practiceOptions() {
        return [
            { label: 'Create New', value: "new" },
            { label: 'Choose Existing', value: "existing" },
        ];
    }

    get referrerOptions() {
        return [
            { label: 'Create New', value: "new" },
            { label: 'Choose Existing', value: "existing" },
        ];
    }

    handlePracticeSelection(event){
        this.practiceId=event.target.value;
    }

    handleReferrerSelection(event){
        this.referrerId=event.target.value;
    }

    handleSubmit(event)
    {
        createProviderandProfileCode({practiceId:this.practiceId,referrerId:this.referrerId,sourceDataId:this.recordId})
        .then((result)=>{
            alert(JSON.stringify(result));
            this.dispatchEvent(new CloseActionScreenEvent());
            this.dispatchEvent(new ShowToastEvent({
                title: result,
                message: result,
                variant: 'success'
            }));
        })
        .catch(err=>{
            console.log(err);
            alert(err);
        })
    }

    handleCancel(event) 
    {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}