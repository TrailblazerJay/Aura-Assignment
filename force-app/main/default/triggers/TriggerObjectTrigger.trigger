trigger TriggerObjectTrigger on Trigger_Object__c (before insert,after insert,before update,after update,before delete,after delete,after undelete)
{
    /*
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            System.debug('Before Insert');
        }
        else if(Trigger.isUpdate)
        {
            System.debug('Before Update');
        }
        else if(Trigger.isDelete)
        {
            System.debug('Before Delete');
            System.debug(Trigger.new[0].Id);
        }
    }
    else if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            System.debug('After Insert');
            // System.debug(Trigger.new[0].Count_Triggers__c);
        }
        else if(Trigger.isUpdate)
        {
            System.debug('After Update');
            //System.debug(Trigger.new[0].Count_Triggers__c);
            //Trigger_Object__c triggerObject=new Trigger_Object__c();
            // delete Trigger.new[0].Id;
        }
        else if(Trigger.isDelete)
        {
            System.debug('After Delete');
            System.debug(Trigger.new[0].Id);
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