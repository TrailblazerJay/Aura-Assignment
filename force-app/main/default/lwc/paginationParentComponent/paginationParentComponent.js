import { LightningElement } from 'lwc';

export default class PaginationParentComponent extends LightningElement 
{
    errorCallback(error,stack)
    {
        alert("Error Occured-"+error);
    }
    page=1;
    previousHandler()
    {
        if(this.page>1)
        {
            this.page=this.page-1;
        }
    }
    nextHandler()
    {
        this.page=this.page+1;
    }
}