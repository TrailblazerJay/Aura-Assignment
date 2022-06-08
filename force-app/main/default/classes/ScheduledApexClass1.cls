global with sharing class ScheduledApexClass1 implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        System.debug('Scheduled Apex 1');
    }
}