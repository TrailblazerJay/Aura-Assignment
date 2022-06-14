import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
    greeting="World";
    inputText="";
    changeHandler(event)
    {
        this.inputText=event.target.value;
    }
    onSubmit()
    {
        alert('Button Clicked');
    }
}