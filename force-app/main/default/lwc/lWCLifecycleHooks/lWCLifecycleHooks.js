import { LightningElement,api } from 'lwc';
import LWCLifecycleHooksTemplate from './lWCLifecycleHooks.html';
import template2 from './template2.html';
export default class LWCLifecycleHooks extends LightningElement {
    @api templateNo="temp1";
    constructor()
    {
        super();
        console.log("Constructor Called");
    }
    connectedCallback()
    {
        console.log("connected callback called");
    }
    disconnectedCallback()
    {
        console.log("disconnected callback called");
    }
    changetemplate()
    {
        if(this.templateNo==="temp1")
        {
            this.templateNo="temp2";
        }
        else
        {
            this.templateNo="temp1"
        }
    }
    render()
    {
        if(this.templateNo=="temp1")
            return LWCLifecycleHooksTemplate;
        else
            return template2;
    }
    renderedCallback()
    {
        console.log("Inside RenderCallback");
    }
    errorCallback(error,stack)
    {
        console.log('inside error callback'+error);
        alert('error'+error);
    }
}