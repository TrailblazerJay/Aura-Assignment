global class StatefulDemo implements Database.Batchable<SObject>,Database.Stateful
{
	private Integer count=0;
	global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('Select Id, Name from Contact');
    }
    global void execute(Database.BatchableContext bc, List<Contact> acc)
    {
        System.debug('Inside Batch Execute Method');
        for(Integer i=0;i<5;i++)
        {
            count++;
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        System.debug('in the finish method');
        System.debug('Count-'+count);
    }
}