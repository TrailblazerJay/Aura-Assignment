trigger RecursiveTrigger on Account (after update) 
{
    /*
    if(RecursiveTriggerClass.isCalled==TRUE)
    {
        Integer countContact = [Select count() from contact where AccountId=:Trigger.new[0].Id];
        Account acc=new Account(Id=Trigger.new[0].Id,Count_Contact__c=countContact);
        try
        {
            RecursiveTriggerClass.isCalled=FALSE;
            update acc;
            System.debug('Account Updated');
            System.debug(CountContact);
        }
        catch(Exception exception1)
        {
            System.debug(exception1.getLineNumber());
            System.debug(exception1.getMessage());
            System.debug(exception1.getStackTraceString());
        }
    }
    */
}