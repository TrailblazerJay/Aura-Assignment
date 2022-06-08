global class RollbackBatch implements Database.Batchable<SObject>,Database.Stateful
{
    public List<Contact> contactList=new List<Contact>();
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('Select Id from Contact where Email=\'jay.malde@gmail.com\'');
    }
    global void execute(Database.BatchableContext bc,List<Contact> contacts)
    {
        for(Contact con:contacts)
        {
            contactList.add(con);
            con.Email='jay@gmail.com';
        }
        update contacts;
    }
    global void finish(Database.BatchableContext bc)
    {
        System.debug(contactList);
        update contactList;
        System.debug('Finish');
    }
}