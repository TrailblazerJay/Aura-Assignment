public class IvocableAccountObject 
{
    @InvocableMethod(label='ShowAccounts' description='ShowAccounts' category='Account')
    public static List<List<Account>> showAccounts()
    {
        List<List<Account>> listAccs=new List<List<Account>>();
        listAccs.add(new List<Account>([Select Id,Name from Account LIMIT 10]));
        return listAccs;
    }
}