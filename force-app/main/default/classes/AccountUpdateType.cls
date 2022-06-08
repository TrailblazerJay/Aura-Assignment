public class AccountUpdateType 
{
    public static void updateType(List<Account> accountList,Map<Id,Account> accountOldMap)
    {
        Map<Id,String> accountSerializedMap=new Map<Id,String>();

        //Updating account Values
        if(!accountList.isEmpty())
        {
            for(Account accountRecord:accountList)
            {
                accountRecord.Type='Technology Partner';
            }
        }
        else
        {
            return;
        }
        
        //Storing serialized Values
        if(!accountOldMap.isEmpty())
        {
            for(Account accountRecord:accountOldMap.values())
            {
                Account acc=new Account(Id=accountOldMap.get(accountRecord.Id).Id,Type=accountOldMap.get(accountRecord.Id).Type,Industry=accountOldMap.get(accountRecord.Id).Industry);
                accountSerializedMap.put(accountRecord.Id,JSON.serialize(acc));
            }
        }
        else
        {
            return;
        }
        
        try
        {
            update accountList;
            //Calling Future Method
            RollbackAccountFuture.updateIndustry(accountSerializedMap);
        }
        catch(Exception exception1)
        {
            System.debug(exception1.getMessage());
        }
    }    
}