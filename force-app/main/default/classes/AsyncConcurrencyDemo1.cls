public with sharing class AsyncConcurrencyDemo1 
{
    public static void Future2(Id id2)
    {
        Account acc=[Select Id,Name from Account where Id=:id2];
        acc.Phone='124';
        update acc;
        System.debug('Future2');
        System.debug(acc.Name);
    }
}