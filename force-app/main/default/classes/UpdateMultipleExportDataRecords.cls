public with sharing class UpdateMultipleExportDataRecords 
{
    public static void updateExportDataRecord()
    {
        // ExportData__c[] exportDataList=[Select Id,filters__c from ExportData__c where Id in :listIds];
        // for(ExportData__c ed:exportDataList)
        // {
        //     ed.filters__c=ed.filters__c+';';
        // }
        // try
        // {
        // 	update exportDataList;
        // }
        // catch(Exception e)
        // {
        //     System.debug(e.getMessage());
        // }

        EmailSobjectBatch esb1=new EmailSobjectBatch('a0M5j000001uCOxEAM','0055j0000044VNvAAM');
        EmailSobjectBatch esb2=new EmailSobjectBatch('a0M5j000001uCO9EAM','0055j0000044VNvAAM');
        EmailSobjectBatch esb3=new EmailSobjectBatch('a0M5j000001uCNWEA2','0055j0000044VNvAAM');
        EmailSobjectBatch esb4=new EmailSobjectBatch('a0M5j000001uCP2EAM','0055j0000044VNvAAM');
        EmailSobjectBatch esb5=new EmailSobjectBatch('a0M5j000001uCP7EAM','0055j0000044VNvAAM');
        EmailSobjectBatch esb6=new EmailSobjectBatch('a0M5j000001uCP8EAM','0055j0000044VNvAAM');
        EmailSobjectBatch esb7=new EmailSobjectBatch('a0M5j000001uCPCEA2','0055j0000044VNvAAM');
        EmailSobjectBatch esb8=new EmailSobjectBatch('a0M5j000001uCPREA2','0055j0000044VNvAAM');
        EmailSobjectBatch esb9=new EmailSobjectBatch('a0M5j000001uCPcEAM','0055j0000044VNvAAM');
        EmailSobjectBatch esb10=new EmailSobjectBatch('a0M5j000001uCPgEAM','0055j0000044VNvAAM');
        Database.executeBatch(esb1);
        Database.executeBatch(esb2);
        Database.executeBatch(esb3);
        Database.executeBatch(esb4);
        Database.executeBatch(esb5);
        Database.executeBatch(esb6);
        Database.executeBatch(esb7);
        Database.executeBatch(esb8);
        Database.executeBatch(esb9);
        Database.executeBatch(esb10);
    }
}
/*
List<Id> listIds=new List<Id>{'a0M5j000001uCOxEAM','a0M5j000001uCO9EAM','a0M5j000001uCNWEA2'};
UpdateMultipleExportDataRecords.updateExportDataRecord();
Map<Id,AsyncApexJob> jobIds=new Map<Id,AsyncApexJob>([SELECT Id,Status FROM AsyncApexJob WHERE status='Processing' AND ApexClass.Name='EmailSobjectBatch']);
System.debug(jobIds);
List<FlexQueueItem> listJobs=[SELECT Id, JobType, FlexQueueItemId, JobPosition, AsyncApexJobId FROM FlexQueueItem where AsyncApexJobId in :jobIds.keySet()];
System.debug(listJobs);
*/