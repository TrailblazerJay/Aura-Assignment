public class RollbackAccountFuture
{
    /*
    @future
    public static void updateIndustry(Map<Id,String> accountSerializedValues)
    {
        if(!accountSerializedValues.isEmpty())
        {
            List<Account> updateAccountList=new List<Account>();
            //Get All the records with Id List
            Map<Id,Account> accountMap=new Map<Id,Account>([Select Id,Type,Name,Fax from Account where Id IN :accountSerializedValues.keySet()]);
            
            //Updating records
            try
            {
                for(Account acc:accountMap.values())
                {
                    if(acc.Name=='Prospector' || acc.Name=='ABG')
                    {
                        acc.Industry='Consulting';
                        // throw new DemoException();
                        acc.Fax='1';
                    }
                    else
                    {
                        acc.Industry='Consulting';
                        acc.Fax='0';
                    }
                }

                //Update Records
                Database.SaveResult[] updateResultList=Database.update(accountMap.values(),false);
                for(Database.SaveResult updateResult:updateResultList)
                {
                    if(updateResult.isSuccess())
                    {
                        System.debug('Successfully Created-'+updateResult.getId());
                    }
                    //If error occured rollback to initial values
                    else
                    {
                        System.debug('Error-'+updateResult.getErrors());
                        System.debug('Rolled Back');
                        if(accountSerializedValues.containsKey(updateResult.getId()))
                        {
                            updateAccountList.add((Account)JSON.deserializeStrict(accountSerializedValues.get(updateResult.getId()),Account.class));
                        }
                        else
                        {
                            System.debug('No Backup for Following Key');
                        }
                    }
                }
                update updateAccountList;
            }
            catch(Exception exception1)
            {
                System.debug('Exception Occured-Rolling Back');
                System.debug('Exception-'+Exception1.getMessage());
                List<Account> accountList=new List<Account>();
                for(String str:accountSerializedValues.values())
                {
                    accountList.add((Account)JSON.deserializeStrict(str,Account.class));
                }
                try
                {
                    update accountList;
                }
                catch(Exception exception2)
                {
                    System.debug(exception2.getMessage());
                }
            }
        }
        else
        {
            System.debug('No initial values exist');
        }
    }
    class DemoException extends Exception
    {

    }
    */
}