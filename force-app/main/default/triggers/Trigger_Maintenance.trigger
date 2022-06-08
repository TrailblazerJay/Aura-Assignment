trigger Trigger_Maintenance on Maintaenance__c (before insert,after insert,after update,before update,before delete,after delete,after undelete) 
{
	System.debug('Maintenance Trigger');
}