trigger CountContact on Contact (after insert,after delete) 
{
    /*
    if(Trigger.isInsert)
    {
        if(Trigger.new[0].AccountId!=NULL)
        {
            System.debug('Account Trigger Captured');
            AggregateResult[] ar = [Select count(Id) from contact where AccountId=:Trigger.new[0].AccountId group by AccountId];
            Account acc=new Account(Id=Trigger.new[0].AccountId,Count_Contact__c=(Decimal)ar[0].get('expr0'));
            System.debug('Count Contact Trigger'+ar[0].get('expr0'));
            try
            {
                update acc;
                System.debug('Account Updated');
            }
            catch(Exception exception1)
            {
                System.debug(exception1.getLineNumber());
                System.debug(exception1.getMessage());
                System.debug(exception1.getStackTraceString());
            }
        }
        else {
            System.debug('Contact is not linked to account');
        }
    }
    else if(Trigger.isDelete)
    {
        System.debug('Account Trigger Captured');
        AggregateResult[] ar = [Select count(Id) from contact where AccountId=:Trigger.old[0].AccountId group by AccountId];
        Account acc=new Account(Id=Trigger.old[0].AccountId,Count_Contact__c=(Decimal)ar[0].get('expr0'));
        System.debug('Count Contact Trigger'+ar[0].get('expr0'));
        try
        {
            update acc;
            System.debug('Account Updated');
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