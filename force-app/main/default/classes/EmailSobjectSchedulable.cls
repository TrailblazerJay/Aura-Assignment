public class EmailSobjectSchedulable implements Schedulable,Database.Stateful
{
    Id userId;
    Id exportDataId;
    public EmailSobjectSchedulable(Id exportDataId,Id userId)
    {
        this.exportDataId=exportDataId;
        this.userId=userId;
    }
     
    public void execute(SchedulableContext sc)
    {
        System.debug('Scheduled for Next 1 min');
        Integer ExportDataCount=[SELECT count() FROM  AsyncApexJob WHERE status='Processing' AND ApexClass.Name='EmailSobjectBatch'];

        EmailSobjectBatch esb=new EmailSobjectBatch(exportDataId,userId);
        
        List<CronTrigger> cronTriggers = [SELECT Id,CronJobDetailId FROM CronTrigger WHERE Id = :sc.getTriggerId() LIMIT 1];
            
        if(ExportDataCount>0)
        {
            List<CronJobDetail> cronDetails = [SELECT Id,Name FROM CronJobDetail WHERE Id= : cronTriggers[0].CronJobDetailId LIMIT 1];    
            System.abortJob(cronTriggers[0].Id);
        
            Datetime sysTime = System.now().addMinutes(1);
            Integer minute=sysTime.minute();
            String cronExpression='0 '+minute+' * * * ?';
            System.schedule(cronDetails[0].Name, cronExpression, new EmailSobjectSchedulable(exportDataId,userId));
        }
        else
        {
            Database.executeBatch(esb);
            System.abortJob(cronTriggers[0].Id);
        }
    }
}