public class LWCCustomLookup {
    @AuraEnabled(cacheable=true)
    public static List<User> getAllUsers() 
    {
        return Database.query('SELECT Id, Name FROM User');
    }
}