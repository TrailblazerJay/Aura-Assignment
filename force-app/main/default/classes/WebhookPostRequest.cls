@RestResource(urlMapping='/api/create/ExportData/')
global without sharing class WebhookPostRequest
{
    @HttpPost
    global static void createExportData()
    {
        String usersId=RestContext.request.params.get('usersId');
        String objectName=RestContext.request.params.get('objectName');
        String Filters=RestContext.request.params.get('Filters');
        String Fields=RestContext.request.params.get('Fields');
        
        
        ExportData__c ed=new ExportData__c(User__c=usersId,Object__c=objectName,Filters__c=Filters,Fields__c=Fields);
        insert ed;
        
        String s = 'abc';
        ContentVersion cv = new ContentVersion(
            PathOnClient= 'Records as per Filters new.csv',
            Title= 'Records as per Filters',
            VersionData=Blob.valueOf(s), 
            IsMajorVersion= true
        );               
        insert cv;
        
        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdv=new ContentDocumentLink(LinkedEntityId=ed.ID,ContentDocumentId=contentDocId,shareType = 'V' );
        insert cdv;
        //insertContentDocument(ed.Id);
        
        RestContext.response.responseBody = Blob.valueOf('<script> alert("UserId-'+usersId+'\nObject'+objectName+'\nFilters'+Filters+'\nFields'+Fields+'"); </script>');
        
    }
    
    @future
    public static void insertContentDocument(String Id){
        String s = 'abc';
        ContentVersion cv = new ContentVersion(
            PathOnClient= 'Records as per Filters.csv',
            Title= 'Records as per Filters',
            VersionData=Blob.valueOf(s), 
            IsMajorVersion= true
        );               
        insert cv;
        
        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        try{
        ContentDocumentLink cdv=new ContentDocumentLink(LinkedEntityId=Id,ContentDocumentId=contentDocId,shareType = 'V' );
        insert cdv;
        }catch(Exception e){}
        
        try{
        ContentDocumentLink cdv=new ContentDocumentLink(LinkedEntityId='a0M5j000001uCyYEAU',ContentDocumentId=contentDocId,shareType = 'V' );
        insert cdv;
        }catch(Exception e){}
    }
}