public without sharing class AccountProcessor {
    public List<Account> accList=[Select Id from Account LIMIT 10];
    public AccountProcessor()
    {
        System.debug(accList);
        AccountProcessor1 a1=new AccountProcessor1(accList);
    }
    public AccountProcessor(Integer i1)
    {
        System.debug('1 Param');
    }
    public AccountProcessor(Integer i1,Integer i2)
    {
        System.debug('2 Param');
    }
    public void method1(List<Account> accList)
    {
        System.debug(accList);
        method2(accList);
    }
    public void method2(List<Account> accList)
    {
        for(Account acc:accList)
        {
            acc.Industry='Apparel';
        }
        System.debug(accList);
        System.debug(this.accList);
    }
    // @future
    // public static void countContacts(List<Id> accountIds)
    // {
        // List<Account> accountList=[Select Id,(select Id from Contacts) from Account where Id IN : accountIds];
        // for(Account acc:accountList)
        // {
        //     acc.Number_of_Contacts__c=acc.Contacts.size();
        // }
        // update accountList;
        // System.debug('Future Method');
    // }
}