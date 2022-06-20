import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import createProvider from '@salesforce/apex/processSourceDataLWC.createProvider';

export default class ProcessSourceData extends LightningElement {
    practiceId;
    referrerId;
    @api recordId;
    @api practiceRadioValue;
    @api referrerRadioValue;
    practiceValue=false;
    referrerValue=false;

    practiceRadioChanged(event)
    {
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

    @wire(getRecord,{recordId:"$recordId",fields:[
        'Source_Data__c.Id',
        'Source_Data__c.Name',
        'Source_Data__c.Description__c'
    ]})
    sourceData;

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
        this.practiceId=event.detail;
    }

    handleReferrerSelection(event){
        this.referrerId=event.detail;
    }

    handleSubmit(event)
    {
        createProvider({practiceId:this.practiceId,referrerId:this.referrerId,description:this.sourceData.data.fields.Description__c.value,externalCode:this.sourceData.data.fields.Name.value})
        .then((result)=>{
            console.log(result);
            alert(JSON.stringify(result));
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