trigger Trigger_Room on Room__c (before insert,after insert,after update,before update,before delete,after delete,after undelete) 
{
	System.debug('Room Trigger');
}