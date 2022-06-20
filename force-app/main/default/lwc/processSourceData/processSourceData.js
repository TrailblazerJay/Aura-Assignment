import { LightningElement } from 'lwc';

export default class ProcessSourceData extends LightningElement {
    practiceId;
    
    handlePracticeId(event)
    {
        this.practiceId=event.target.value;
        console.log(this.practicId);
    }
}