global class BatchDemo1 implements Database.Batchable<SObject>,Database.Stateful
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
            count=i;
        }
        
        System.debug(bc.getJobId());
        System.debug(bc.getChildJobId());
    }
    global void finish(Database.BatchableContext bc)
    {
        System.debug('in the finish method');
        System.debug('Count-'+count);
        
        // BatchDemo2 bd2=new BatchDemo2();
        // Database.executeBatch(bd2);
        // BatchDemo3 bd3=new BatchDemo3();
        // Database.executeBatch(bd3);
    }
}