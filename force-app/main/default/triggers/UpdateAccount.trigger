trigger UpdateAccount on Account (after insert,after update)
{
    /*
    //Stop Trigger from Recursion & Future Calls
    if(RecursiveTriggerClass.isCalled && !System.isFuture())
    {
        RecursiveTriggerClass.isCalled=FALSE;
        List<Account> accountList=new List<Account>();
        Map<Id,Account> accountOldMap=new Map<Id,Account>();        

        //All Triggered Records
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            accountList=[
                Select Id,Industry,Type,Fax
                from Account
                where Id in :Trigger.newMap.keySet()
            ];

            //Map of All Old Triggered Records
            accountOldMap=new Map<Id,Account>([
                Select Id,Industry,Type,Fax
                from Account 
                where Id in :Trigger.oldMap.keySet()
            ]);

            AccountUpdateType.updateType(accountList,accountOldMap);
        }
        else if(Trigger.isAfter && Trigger.isInsert)
        {
            List<Id> listIds=new List<Id>();
            for(Account acc:Trigger.new)
            {
                listIds.add(acc.Id);
            }
            accountList=[
                Select Id,Industry,Type
                from Account
                where Id in :listIds
            ];

            //Map of All Old Triggered Records
            for(Account acc:Trigger.new)
            {
                accountOldMap.put(acc.Id,acc);
            }

            AccountUpdateType.updateType(accountList,accountOldMap);
        }
    }
    */
}