import { LightningElement, api, track } from 'lwc';

export default class ChildComponent extends LightningElement {
    @api myName ="Name";
    // @api apiVariable ="apiVariableValue";
    // @track trackVariable="trackVariableValue";
    // nonReactiveVariable="nonReactiveVariableValue";
    
    // onClickButton(event)
    // {
    //     this.apiVariable="apiVariableValueChanged";
    //     this.trackVariable="trackVariableValueChanged";
    //     this.nonReactiveVariable="nonReactiveVariableValueChanged";
    // }

    buttonClicked()
    {
        var newEvent=new CustomEvent("myevent",{
            detail:'Jay',
        });
        this.dispatchEvent(newEvent);
    }
    // @api childMethod()
    // {   
    //     alert("Child Method Called");
    // }
}