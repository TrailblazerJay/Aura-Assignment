({
	java : function(component, event, helper) {
		let button=event.getSource();
        let label=button.get('v.label');
        component.set('v.lname',label);
	},
    python : function(component, event, helper) {
		let button=event.getSource();
        let label=button.get('v.label');
        component.set('v.lname',label);
	},
    javascript : function(component, event, helper) {
		let button=event.getSource();
        let label=button.get('v.label');
        component.set('v.lname',label);
	},
    apex : function(component, event, helper) {
		let button=event.getSource();
        let label=button.get('v.label');
        component.set('v.lname',label);
	}
})