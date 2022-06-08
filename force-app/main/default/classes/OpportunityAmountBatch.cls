global class OpportunityAmountBatch implements Database.Batchable<SObject>,Database.Stateful
{
    private List<Account> accountList=new List<Account>();
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('Select Id from Account');
    }
    global void execute(Database.BatchableContext bc, List<Account> accList)
    {
        System.debug(accList);
        Set<Id> ids=new Set<Id>();
        for(Account acc:accList)
        {
            ids.add(acc.id);
        }
        AggregateResult[] arList=[Select AccountId,sum(Amount) from Opportunity where Id In :ids group by AccountId];
        for(AggregateResult ar:arList)
        {
            System.debug('Aggregate Query');
            accountList.add(new Account(Id=(Id)ar.get('AccountId'),Total_Amount__c=(Decimal)ar.get('expr0')));
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        try
        {
            update accountList;
            System.debug(accountList);
            System.debug('All Accounts Updated');
        }
        catch(Exception exception1)
        {
            System.debug('Exception-'+exception1.getMessage());
        }
    }
}