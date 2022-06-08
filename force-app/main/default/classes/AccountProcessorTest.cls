@isTest
private class AccountProcessorTest 
{
	@isTest
    private static void countContactsTest()
    {
        List<Account> accounts=new List<Account>();
        for(Integer i=0;i<300;i++)
        {
            accounts.add(new Account(Name='Test Account'+i));
        }
        insert accounts;
        
        List<Contact> contacts=new List<Contact>();
        List<Id> accountIds=new List<Id>();
        for(Account acc:accounts)
        {
            contacts.add(new Contact(FirstName='FName',LastName='LName',AccountId=acc.Id));
            accountIds.add(acc.Id);
        }
        insert contacts;
        
        Test.startTest();
        AccountProcessor.countContacts(accountIds);
        Test.stopTest();
        
        List<Account> accList=[Select Id,Number_of_Contacts__c from Account];
        for(Account acc:accList)
        {
            System.assertEquals(1, acc.Number_of_Contacts__c, 'count is not 1');
        }
    }
}