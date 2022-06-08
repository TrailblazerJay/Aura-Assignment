public with sharing class ScheduledApexClass3 implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        System.debug('Scheduled Apex 3');
    }
}