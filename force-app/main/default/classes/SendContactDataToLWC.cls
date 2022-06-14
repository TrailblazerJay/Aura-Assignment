public with sharing class SendContactDataToLWC 
{
    @AuraEnabled(cacheable=true)    
    public static List<Contact> getContacts(){
        try {
            return [Select Id,Name,Email,Phone from Contact LIMIT 10];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
