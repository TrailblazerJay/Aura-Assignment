public class DynamicPickList 
{
    
    @AuraEnabled
    public static List<String> objectNames()
    {
        List<String> mapOfObjectNames=new List<String>();
        List<String> objnames=new List<String>();
        Set<String> names=Schema.getGlobalDescribe().keySet();
        for(String str:names)
        {
            objnames.add(str);
        }
        Schema.DescribeSObjectResult[] result=Schema.describeSObjects(objnames);
        for(Schema.DescribeSObjectResult res:result)
        {
            if(res.isAccessible())
            {
                mapOfObjectNames.add(res.getName());
            }
        }
        return mapOfObjectNames;
    }

	@AuraEnabled
    public static List<String> fieldNames(String Obj)
    {
        List<String> mapOfFieldNames=new List<String>();
        Map<String,Schema.SObjectField> fieldNames=Schema.getGlobalDescribe().get(Obj).getDescribe().fields.getMap();
        for(SObjectField field:fieldNames.values())
        {
            if(field.getDescribe().isCreateable())
            {
                mapOfFieldNames.add(field.getDescribe().getName());
            }
        }
        return mapOfFieldNames;
    }
    
    @AuraEnabled
    public static String createExportDataRecord(String userId,String objectName,String Filters,String Fields)
    {
        try
        {
            List<ExportData__c> edList=new List<ExportData__c>();
            edList.add(new ExportData__c(User__c=userId,Object__c=objectName,Filters__c=Filters,Fields__c=Fields));
            //ExportData__c ed=new ExportData__c(User__c='0055j0000044VNvAAM',Object__c='Account',Filters__c='CreatedDate:THIS_YEAR',Fields__c='CreatedDate');
            Database.SaveResult[] resultList=Database.insert(edList);
            for(Database.SaveResult result:resultList)
            {
                if(result.isSuccess())
                {
            		return 'SUCCESS';        
                }
                else
                {
                    return 'Error-'+result.getErrors();
                }
            }
            return NULL;
        }
        catch(Exception exception1)
        {
            System.debug('Exception Occured'+exception1.getMessage());
            return 'Exception Occured'+exception1.getMessage();
        }
    }
}