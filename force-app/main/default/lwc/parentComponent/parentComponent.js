import { LightningElement ,api} from 'lwc';

export default class ParentComponent extends LightningElement {
    @api parentVariable="Parent Value";
    onClickButton1()
    {
        var childComp=this.template.querySelector('c-child-component');
        childComp.childMethod();
    }

    functionCall(event)
    {
        alert("Custom Event Called"+event.detail);
    }
}