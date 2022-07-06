global without sharing class EmailSobjectBatch implements Database.Batchable<SObject>,Database.Stateful
{
    public List<ExportData__c> externalDataRecords=new List<ExportData__c>();
    public String externalDataCSV='';
    public String[] csvRows=new String[0];
    String filter;
    String fieldNames;
    String errorMessage='';
    Integer countOfRecords=0;
    Id userId;

    public EmailSobjectBatch(Id exportDataId,Id user)
    {
        this.userId=user;
        ExportData__c ed=[Select Id,Object__c,User__c,Filters__c,Fields__c,Also_include_deleted_records__c,Enforce_sharing__c from ExportData__c where Id = :exportDataId];
        externalDataRecords.add(ed);
    }

    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        try
        {
            externalDataRecords[0].status__c='In Progress';
            update externalDataRecords[0];
        }
        catch(Exception exception1)
        {
            System.debug(exception1.getMessage());
            return Null;
        }
        return Database.getQueryLocator([
            Select Id,Object__c,User__c,Filters__c,Fields__c
            from ExportData__c
            where Id = :externalDataRecords[0].Id
            ]);
    }
    public void execute(Database.BatchableContext bc,List<ExportData__c> scope)
    {   
        if(scope!=NULL)
        {
            for(Integer i=0;i<1000000;i++)
            {
            }
            filter=scope[0].Filters__c;

            fieldNames=externalDataRecords[0].Fields__c.replace(';',',');

            List<String> fields=filter.split(';');
            
            Map<String,String> fieldValue=new Map<String,String>();
            //Create a Map of Key=Field Name & Value=value
            for(String str:fields)
            {
                String[] values=str.split(':');
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
            System.debug(fieldValue);

            //Creating query with fields and values in map
            String query='Select Id,Owner.Name,'+fieldNames+' from '+ scope[0].Object__c+' where ';
            
            for(String key:fieldValue.keySet())
            {
                //Conditions
                if(key=='Amount' || key=='AnnualRevenue')
                {
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

            // query+='OwnerId =\''+userId+'\'';
            if(externalDataRecords[0].Also_include_deleted_records__c)
            {
                query+='ALL ROWS';
            }
            
            // query=query.replaceFirst('CreatedDate', 'format(CreatedDate)');
            // query=query.replaceFirst('LastModifiedDate', 'format(LastModifiedDate)');
            if(query.endsWith(' AND '))
            {
                query=query.removeEnd(' AND ');
            }
            System.debug(query);
            
            List<SObject> listSObject=new List<SObject>();
            try
            {
                // if(externalDataRecords[0].Enforce_sharing__c)
                // {
                //     EnforceSharing es=new EnforceSharing();
                //     listSObject=es.withSharing(query);  
                //     countOfRecords=listSObject.size();
                // }
                if(!externalDataRecords[0].Enforce_sharing__c)
                {
                    BypassSharing bs=new BypassSharing();
                    listSObject=bs.withSharing(query);
                    countOfRecords=listSObject.size();    
                }
            }
            catch(Exception exception1)
            {
                errorMessage=exception1.getMessage();
                System.debug(exception1.getMessage());
            }

            String header='Id,'+fieldNames+',Owner.Name';
            header.replace('.',' ');
            System.debug(header);
            csvRows.add(header);
            
            for(SObject obj:listSObject)
            {
                String values='';
                for(String field:csvRows[0].split(','))
                {
                    if(field.contains('.'))
                    {
                        values+=(String.valueOf(obj.getSobject(field.substringBefore('.')).get(field.substringAfter('.'))));
                    }
                    else if(field=='CreatedDate')
                    {
                        values+=(String.valueOf(obj.get(field)).substringBefore(',')+' '+String.valueOf(obj.get(field)).substringAfter(','));
                    }
                    else
                    {
                        values+=(String.valueOf(obj.get(field)));
                    }           
                    values+=',';
                }
                System.debug(values);
                csvRows.add(values.substring(0, values.length()-1));
            }
        }
        else
        {
            System.debug('Empty Scope');
        }
    }

    public void finish(Database.BatchableContext bc)
    { 
        if(errorMessage.length()==NULL || errorMessage.length()==0)
        {
            try
            {
                //Convert List of String Records into Single String
                externalDataCSV=externalDataCSV+String.join(csvRows,'\n');

                //Creating CSV of Above String
                Messaging.EmailFileAttachment csvFile=new Messaging.EmailFileAttachment();
                csvFile.setFileName('ExportData for '+externalDataRecords[0].Object__c+' Object.csv');
                csvFile.setBody(Blob.valueOf(externalDataCSV));

                System.debug(userId);
                User user1=[Select Id,Email from User where Id=:userId LIMIT 1];

                //Sending Mail
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                mail.setSubject(externalDataRecords[0].Object__c+' Records as per Filters');
                mail.setToAddresses(new List<String>{user1.Email});
                mail.setPlainTextBody('Here are the '+externalDataRecords[0].Object__c+' Records as per\n\nThese filters - '+filter+'\n\nAnd Fields - '+fieldNames+'\n\nTotal Records - '+countOfRecords+'\n\nLink - '+URL.getSalesforceBaseUrl().toExternalForm() + '/' + externalDataRecords[0].Id);
                mail.setFileAttachments(new list<Messaging.EmailFileAttachment>{csvFile});
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});

                externalDataRecords[0].status__c='Completed';
                update externalDataRecords[0];

                CustomNotificationType notificationType = 
                [
                    SELECT Id, DeveloperName 
                    FROM CustomNotificationType 
                    WHERE DeveloperName='Amount_Notification'
                ];

                Messaging.CustomNotification msg=new Messaging.CustomNotification();
                msg.setTitle(externalDataRecords[0].Object__c+' Records as per Filters');
                msg.setBody('Here are the '+externalDataRecords[0].Object__c+' Records as per\n\nThese filters - '+filter+'\n\nAnd Fields - '+fieldNames+'\n\nTotal Records - '+countOfRecords+'\n\nLink - '+URL.getSalesforceBaseUrl().toExternalForm() + '/' + externalDataRecords[0].Id);
                msg.setNotificationTypeId(notificationType.Id);
                msg.setTargetId(externalDataRecords[0].Id);
                // User[] users=[Select Id from User where ProfileId IN ('00e5j000002VF3iAAG','00e5j000000xoISAAY')];
                Set<String> setIds=new Set<String>();
                setIds.add(user1.Id);
                System.debug(setIds);
                msg.send(setIds);   

                Attachment naa=new Attachment(OwnerId=user1.Id,ParentId=externalDataRecords[0].Id,Body=Blob.valueOf(externalDataCSV),Name=externalDataRecords[0].Object__c+' Records as per Filters.csv',ContentType='text/csv');
                insert naa;

                // ContentVersion cv = new ContentVersion(
                //     FirstPublishLocationId='0585j00000056HDAAY',
                //     PathOnClient=externalDataRecords[0].Object__c+' Records as per Filters.csv',
                //     Title=externalDataRecords[0].Object__c+' Records as per Filters',
                //     VersionData=Blob.valueOf(externalDataCSV), 
                //     IsMajorVersion= true
                // );               
                // insert cv;
                // System.debug(cv);

                //Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                //System.debug(contentDocId);
                //ContentDocumentLink cdv=new ContentDocumentLink(LinkedEntityId=externalDataRecords[0].Id,ContentDocumentId=contentDocId,shareType = 'V' );
                //insert cdv;
                //System.debug(cdv);
                // LinkDocumentBatch ldb=new LinkDocumentBatch(cv.Id,externalDataRecords[0].Id);
                // Database.executeBatch(ldb);
            }
            catch(Exception e)
            {
                System.debug(e.getStackTraceString());
                System.debug(e.getMessage());
            }
        }
        else
        {
            System.debug(errorMessage);
            externalDataRecords[0].status__c='Failed';
            update externalDataRecords[0];
        }
    }

    public with sharing class EnforceSharing
    {
        public List<SObject> withSharing(String query)
        {
            List<SObject> listObject=Database.query(query);
            return listObject;
        }
    }
    public without sharing class BypassSharing
    {
        public List<SObject> withSharing(String query)
        {
            List<SObject> listObject=Database.query(query);
            return listObject;
        }
    }
}