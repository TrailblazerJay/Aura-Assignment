trigger ContactTrigger on Contact (before insert,before update, before delete,after insert,after update,after delete,after undelete) 
{
    System.debug('Contact Trigger');
    
    System.debug(trigger.new[0].Id);
    if(Trigger.isAfter)
    {
        Contact[] conList=[Select Id from Contact where Id =:trigger.new[0].Id AND Id IN (Select ConvertedContactId from Lead)];
        if(conList.size()>0)
        {
            System.debug('Converted from Lead');
        }
    }
        /*

    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            System.debug('Before Insert');
            System.debug(Trigger.new[0]);
        }
        else if(Trigger.isUpdate)
        {
            System.debug('Before Update');
        }
        else if(Trigger.isDelete)
        {
            System.debug('Before Delete');
        }
    }
    else if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            System.debug('After Insert');
            System.debug(Trigger.new[0]);
        }
        else if(Trigger.isUpdate)
        {
            System.debug('After Update');
        }
        else if(Trigger.isDelete)
        {
            System.debug('After Delete');
        }
        else if(Trigger.isUndelete)
        {
            System.debug('After Undelete');
        }
    }
    else{
        System.debug('Else Case');
    }
    */
}