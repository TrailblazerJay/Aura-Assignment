public class IterableBatch implements Database.Batchable<Account>
{
    public Iterable<Account> start(Database.BatchableContext bc)
    {
        return new AccountIterable();
    }
    public void execute(Database.BatchableContext bc,Account[] accList)
    {
        List<Account> accsToUpdate = new List<Account>();
        for(Account acc:accList){
            acc.Name='true';
            acc.NumberOfEmployees=69;
            accsToUpdate.add(acc);
        }
        update accsToUpdate;
    }
    public void finish(Database.BatchableContext bc)
    {
        System.debug('finish');
    }
}