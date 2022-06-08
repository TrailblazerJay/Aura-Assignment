trigger Trigger1 on Trigger_Object1__c (before insert,before update,before delete,after update,after insert,after delete,after undelete)
{
	/*
	System.debug('Trigger Object1');
	if(Trigger.new[0].Name!='Jay')
	{
		System.debug('Trigger Captured');
		Trigger.new[0].Name.addError('Name should be jay');
	}*/
}