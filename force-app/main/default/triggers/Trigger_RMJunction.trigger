trigger Trigger_RMJunction on R_M_Junction__c (before insert,after insert,after update,before update,before delete,after delete,after undelete) 
{
	System.debug('RMJunction Trigger');
}