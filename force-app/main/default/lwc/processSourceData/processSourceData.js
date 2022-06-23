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
    @api isLoaded=false;

    practiceRadioValue="new";
    referrerRadioValue="new";
    practiceValue=true;
    referrerValue=true;
    practiceDisabled=false;
    referrerDisabled=false;
    practiceLookupDisabled=false;
    referrerLookupDisabled=false;
    practiceMessage='';
    referrerMessage='';

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
            if(data[2]=="No Error")
            {
                if(data[0]!="No Data")
                {
                    this.practiceId=data[0];
                    this.practiceDisabled=true;
                    this.practiceLookupDisabled=true;
                    this.practiceRadioValue="existing";
                    this.practiceValue=false;
                    this.practiceMessage="This practice already exists.";
                    this.practiceLink="https://jay-atlas-dev-ed.my.salesforce.com/"+data[0];
                }
                if(data[1]!="No Data")
                {
                    this.referrerId=data[1];
                    this.referrerDisabled=true;
                    this.referrerLookupDisabled=true;
                    this.referrerRadioValue="existing";
                    this.referrerValue=false;
                    this.referrerMessage="This referrer already exists.";
                    this.referrerLink="https://jay-atlas-dev-ed.my.salesforce.com/"+data[1];
                }
                this.isLoaded=true;
            }
            else
            {
                this.isLoaded=true;
                this.dispatchEvent(new CloseActionScreenEvent());
                this.dispatchEvent(new ShowToastEvent({
                    title: "Info",
                    message: data[2],
                    variant: 'info'
                }));
            }
        }
    }

    practiceRadioChanged(event)
    {
        if(event.target.value=="existing")
        {
            this.practiceValue=false;
            this.practiceLookupDisabled=false;
        }
        else if(event.target.value=="new")
        {
            this.practiceValue=true;
            this.practiceLookupDisabled=true;
        }
    }

    referrerRadioChanged(event)
    {
        if(event.target.value=="existing")
        {
            this.referrerValue=false;
            this.referrerLookupDisabled=false;
        }
        else if(event.target.value=="new")
        {
            this.referrerLookupDisabled=true;
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
            this.dispatchEvent(new CloseActionScreenEvent());
            this.dispatchEvent(new ShowToastEvent({
                title: result,
                message: result,
                variant: 'success'
            }));
        })
        .catch(err=>{
            console.log(err);
            this.dispatchEvent(new ShowToastEvent({
                title: "Exception",
                message: err.body.message+"\n"+this.practiceId+"\n"+this.referrerId,
                variant: 'error'
            }));
        })
    }

    handleCancel(event) 
    {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}