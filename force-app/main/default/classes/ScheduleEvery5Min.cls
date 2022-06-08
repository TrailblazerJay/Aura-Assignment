public class ScheduleEvery5Min  implements Schedulable 
{
    public void execute(SchedulableContext sc)
    {    
        System.debug(sc.getTriggerId());
        List<CronTrigger> cronTriggers = [SELECT Id,CronJobDetailId FROM CronTrigger WHERE Id = :sc.getTriggerId() LIMIT 1];
        List<CronJobDetail> cronDetails = [SELECT Id,Name FROM CronJobDetail WHERE Id= : cronTriggers[0].CronJobDetailId LIMIT 1];
        System.abortJob(cronTriggers[0].Id);
        

        // Datetime sysTime = System.now().addMinutes(5);
        // Integer minute=sysTime.minute();
        // String cronExpression='0 '+minute+' * * * ?';
        // System.schedule(cronDetail[0].Name, cronExpression, new ScheduleEvery5Min());

        // Datetime sysTime = System.now().addMinutes(30);
        // Integer minute=sysTime.minute();
        // String cronExpression='0 '+minute+' * * * ?';
        // System.schedule(cronDetails[0].Name, cronExpression, new ScheduleEvery5Min());
    
        //cron 0 35 * 1 * * ? 1st Day of Month

        //cron 0 35 * 1/15 * * ? last Day of Month
        
        //cron 0 35 * L * * ? last Day of Month
        
        //cron 0 35 * 1 1 ? 2023 1st Day of Year
    }
}