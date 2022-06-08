trigger AccountAddressTrigger on Account (before insert,before update,after insert,after update,after delete,before delete,after undelete)
{
    // for(Account account: Trigger.new)
    // {
    //     if((account.Match_Billing_Address__c==true)&&(account.BillingPostalCode!=NULL)){
    //         account.ShippingPostalCode=account.BillingPostalCode;
    //     }
    // }
    // List<Id> accountIds=new List<Id>();
    // for(Account account: Trigger.new)
    // {
    //     accountIds.add(account.Id);
    // }
    // AccountProcessor.countContacts(accountIds);
    // System.debug('Trigger Ended');
    // System.debug('Account Trigger');
}