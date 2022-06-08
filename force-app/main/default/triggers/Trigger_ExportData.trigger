trigger Trigger_ExportData on ExportData__c (before insert,before update,after insert,after update) 
{ 
    
    // if(!Trigger.new[0].isClone() && Trigger.isBefore)
    // {
    //     ExportData__c exportData=Trigger.new[0];
    //     getRecords(exportData);
    // }
    if(Trigger.isAfter)
    {
        ExportData__c exportData=Trigger.new[0];
        getRecords(exportData);
    }
    
    public void getRecords(ExportData__c exportData)
    {
        if(exportData!=NULL)
        {
            try
            {
                if(!System.isBatch())
                {

                    Map<String,String> fieldValue=new Map<String,String>();

                    String filter=exportData.Filters__c;
                    
                    if(!Schema.getGlobalDescribe().containsKey(exportData.Object__c))
                    {
                        exportData.Object__c.addError(exportData.Object__c+' object does not exist.');
                        return;
                    }
                    
                    //Create a Map of Key=Field Name & Value=value
                    List<String> fields=filter.split(';');
                    SObject obj=Schema.getGlobalDescribe().get(exportData.Object__c).newSObject();
                    for(String str:fields)
                    {
                        String[] values=str.split(':');
                        if(obj.getSobjectType().getDescribe().fields.getMap().containsKey(values[0]))
                        {
                            if(values.size()==4)
                            {
                                fieldValue.put(values[0],values[1]+':'+values[2]+':'+values[3]);
                            }
                            else if(values.size()==3)
                            {
                                fieldValue.put(values[0],values[1]+':'+values[2]);
                            }
                            else
                            {
                                fieldValue.put(values[0],values[1]);
                            }
                        }
                        else
                        {   
                            exportData.Filters__c.addError(values[0]+' field does not exist.');
                            return;
                        }
                    }
                    for(String field:exportData.Fields__c.split(';'))
                    {
                        if(!obj.getSobjectType().getDescribe().fields.getMap().containsKey(field))
                        {
                            exportData.Fields__c.addError(field+' field does not exist.');
                            return;
                        }
                    }
                    //Creating query with fields and values in map
                    String query='Select count() from '+ exportData.Object__c+' where ';
                    for(String key:fieldValue.keySet())
                    {
                        if(key=='Amount' || key=='AnnualRevenue')
                        {                
                            //Conditions
                            switch on fieldValue.get(key).substringBefore(':') {
                                when 'GT' 
                                {
                                    query+=key+' > '+ fieldValue.get(key).substringAfter(':')+' ';        
                                }
                                when 'LT' 
                                {
                                    query+=key+' < '+ fieldValue.get(key).substringAfter(':')+' ';        
                                }
                                when 'GTE' 
                                {
                                    query+=key+' >= '+ fieldValue.get(key).substringAfter(':')+' ';        
                                }
                                when 'LTE' 
                                {
                                    query+=key+' <= '+ fieldValue.get(key).substringAfter(':')+' ';        
                                }
                                when 'E' 
                                {
                                    query+=key+' = '+ fieldValue.get(key).substringAfter(':')+' ';        
                                }
                                when 'NE' 
                                {
                                    query+=key+' != '+ fieldValue.get(key).substringAfter(':')+' ';        
                                }
                                when else {
                                    query+=key+' > '+ fieldValue.get(key).substringAfter(':')+' ';                        
                                }
                            }
                        }
                        else if((key=='CreatedDate' || key=='LastModifiedDate') && fieldValue.get(key).split(':').size()==3)
                        {
                            query+=key+' > '+fieldValue.get(key).replaceAll(':', '-')+'T00:00:00z';
                        }
                        else
                        {
                            query+=key+' = '+ fieldValue.get(key)+' ';
                        }
                        query+=' AND ';
                    }
                    
                    if(query.endsWith(' AND '))
                    {
                        query=query.removeEnd(' AND ');
                    }

                    // query+='OwnerId =\''+UserInfo.getUserId()+'\'';
                    if(exportData.Also_include_deleted_records__c)
                    {
                        query+=' ALL ROWS';
                    }
                    System.debug(query);
                    
                    Integer listSObject=0;
                    try
                    {
                        listSObject=Database.countQuery(query);
                        System.debug(listSObject);
                    }
                    catch(AsyncException exception1)
                    {
                        System.debug(exception1.getMessage());
                        // exportData.addError('Exception Occured-'+exception1.getMessage());
                        System.debug('Exception Occured-'+exception1.getMessage());
                    }
                    catch(Exception exception1)
                    {
                        System.debug(exception1.getMessage());
                        // exportData.addError('Exception Occured-'+exception1.getMessage());
                        System.debug('Exception Occured-'+exception1.getMessage());
                    }

                    if(listSObject>0)
                    {
                        System.debug('Trigger Data'+exportData);
                        EmailSobjectBatch esb=new EmailSobjectBatch(exportData.Id,UserInfo.getUserId());

                        Map<Id,AsyncApexJob> jobIds=new Map<Id,AsyncApexJob>([SELECT Id,CreatedDate,Status FROM AsyncApexJob WHERE status!='Completed' AND ApexClass.Name='EmailSobjectBatch' ORDER BY CreatedDate DESC]);
                        System.debug(jobIds);
                        List<FlexQueueItem> queueItems=[SELECT Id, JobType, FlexQueueItemId, JobPosition, AsyncApexJobId FROM FlexQueueItem where JobType='BatchApex' AND AsyncApexJobId in :jobIds.keySet() Order By JobPosition DESC];
                        System.debug(queueItems);
                        
                        if(queueItems.size()>0)
                        {
                            Id jobId=Database.executeBatch(esb);
                            System.Flexqueue.moveAfterJob(jobId,queueItems[0].AsyncApexJobId);
                            System.debug(queueItems[0].AsyncApexJobId);
                            System.debug(jobId);
                        }
                        else
                        {
                            Database.executeBatch(esb);
                            System.debug('Batch Called');
                        }
                    }
                    else
                    {
                        exportData.addError('No records exist for this filter. Please try some different values');
                        // System.debug('No records exist for this filter.');
                    }
                }
            }
            catch(Exception exception1)
            {
                System.debug(exception1.getMessage());
                exportData.addError(exception1.getMessage());
            }
        }
        else
        {
            System.debug('No ExportData Record');
        }           
    }
}