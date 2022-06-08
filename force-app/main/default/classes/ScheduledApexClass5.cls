public with sharing class ScheduledApexClass5 implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        System.debug('Scheduled Apex 5');
    }
}