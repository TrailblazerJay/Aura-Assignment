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
        RestContext.response.responseBody = Blob.valueOf('<script> alert("UserId-'+usersId+'\nObject'+objectName+'\nFilters'+Filters+'\nFields'+Fields+'"); </script>');
        
        ExportData__c ed=new ExportData__c(User__c=usersId,Object__c=objectName,Filters__c=Filters,Fields__c=Fields);
        insert ed;
        
    }
}