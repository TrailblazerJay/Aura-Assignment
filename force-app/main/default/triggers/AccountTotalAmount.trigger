trigger AccountTotalAmount on Opportunity (after insert,after update,after delete) 
{
    System.debug('Opportunity Trigger');
    Opportunity[] oppList=[Select Id from Opportunity where Id =:trigger.new[0].Id AND Id IN (Select ConvertedOpportunityId from Lead)];
    if(oppList.size()>0)
    {
        System.debug('Converted from Lead');
    }
    /*
	if(Trigger.isInsert || Trigger.isUpdate)
    {
        if(Trigger.new[0].AccountId!=NULL)
        {
            AggregateResult[] ar = [Select sum(Amount) from Opportunity where AccountId=:Trigger.new[0].AccountId group by AccountId];
            Account acc=new Account(Id=Trigger.new[0].AccountId,AnnualRevenue=(Decimal)ar[0].get('expr0'));
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
            System.debug('Opportunity is not linked to account');
        }
    }
    else if(Trigger.isDelete)
    {
        AggregateResult[] ar = [Select count(Id) from opportunity where AccountId=:Trigger.old[0].AccountId group by AccountId];
        Account acc=new Account(Id=Trigger.old[0].AccountId,AnnualRevenue=(Decimal)ar[0].get('expr0'));
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
    }*/
}