public with sharing class AsyncConcurrencyDemo 
{
    public static void Future1(Id id1)
    {
        Account acc=[Select Id,Name from Account where Id=:id1];
        acc.Phone='123';
        update acc;
        System.debug('Future1');
        System.debug(acc.Name);
    }
}