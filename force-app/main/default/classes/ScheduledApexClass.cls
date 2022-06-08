global class ScheduledApexClass implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        System.debug('Scheduled Apex');
        System.debug(sc.getTriggerId());
        scheduljob();
    }
    public void scheduljob()
    {
        // ScheduledApexClass1 sac1=new ScheduledApexClass1();
        // String cronExp='0 34 20 11 5 ? 2022';
        // System.Schedule('Scheduled Apex 1',cronExp,sac1);
        
        // ScheduledApexClass2 sac2=new ScheduledApexClass2();
        // String cronExp1='0 35 20 11 5 ? 2022';
        // System.Schedule('Scheduled Apex 2',cronExp1,sac2);

        // ScheduledApexClass3 sac3=new ScheduledApexClass3();
        // String cronExp2='0 36 20 11 5 ? 2022';
        // System.Schedule('Scheduled Apex 3',cronExp2,sac3);

        // ScheduledApexClass4 sac4=new ScheduledApexClass4();
        // String cronExp4='0 37 20 11 5 ? 2022';
        // System.Schedule('Scheduled Apex 4',cronExp4,sac4);

        // ScheduledApexClass5 sac5=new ScheduledApexClass5();
        // String cronExp5='0 38 20 11 5 ? 2022';
        // System.Schedule('Scheduled Apex 5',cronExp5,sac5);
    }
}