public class AccountIterable implements Iterable<Account>
{
    public Iterator<Account> Iterator()
    {
        List<Account> accList=[Select Id from Account LIMIT 10];
        return new CustomAccountIterator(accList);
    }
}