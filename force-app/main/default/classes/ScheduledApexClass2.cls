public with sharing class ScheduledApexClass2 implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        System.debug('Scheduled Apex 2');
    }
}