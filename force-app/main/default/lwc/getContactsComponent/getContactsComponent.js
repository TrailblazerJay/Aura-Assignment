import { LightningElement,wire} from 'lwc';
import getContacts from '@salesforce/apex/SendContactDataToLWC.getContacts';

export default class GetContactsComponent extends LightningElement {
    result;
    error;
    @wire(getContacts)
    getContactsList({error, data}) 
    {
        console.log(data);
        if (data) 
        {
            this.error=undefined;
            this.result=data;
        }
        else if (error) 
        {
            this.error=error;
            this.result=undefined;
        }
    }    
}