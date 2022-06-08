public with sharing class ScheduledApexClass4 implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        System.debug('Scheduled Apex 4');
    }
}