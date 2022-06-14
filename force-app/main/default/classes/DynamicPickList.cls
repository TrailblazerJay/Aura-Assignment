public class DynamicPickList 
{
    //Returns all the ObjectNames based on User 
    // @AuraEnabled(cacheable=true)
    // public static Map<String,String> objectNames()
    // {
    //     Map<String,String> mapOfObjectNames=new Map<String,String>();
    //     List<String> objnames=new List<String>();
    //     Set<String> names=Schema.getGlobalDescribe().keySet();
    //     for(String str:names)
    //     {
    //         objnames.add(str);
    //     }

    //     Schema.DescribeSObjectResult[] result=Schema.describeSObjects(objnames);
    //     for(Schema.DescribeSObjectResult res:result)
    //     {
    //         if(res.isAccessible())
    //         {
    //             mapOfObjectNames.put(res.getName(),res.getName());
    //         }
    //     }
    //     return mapOfObjectNames;
    // }

    @AuraEnabled(cacheable=true)
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
        mapOfObjectNames.sort();
        return mapOfObjectNames;
    }

    //Returns all the fieldNames based on User and objectName
	@AuraEnabled
    public static List<String> fieldNames(String Obj)
    {
        List<String> mapOfFieldNames=new List<String>();
        Map<String,Schema.SObjectField> fieldNames=Schema.getGlobalDescribe().get(Obj).getDescribe().fields.getMap();
        for(SObjectField field:fieldNames.values())
        {
            if(field.getDescribe().isAccessible())
            {
                mapOfFieldNames.add(field.getDescribe().getName());
            }
        }
        mapOfFieldNames.sort();
        return mapOfFieldNames;
    }
    
    //Creates a new ExportData Record 
    @AuraEnabled
    public static String createExportDataRecord(String userId,String objectName,String Filters,String Fields)
    {
        try
        {
            List<ExportData__c> exportdDataList=new List<ExportData__c>();
            exportdDataList.add(new ExportData__c(User__c=userId,Object__c=objectName,Filters__c=Filters,Fields__c=Fields));
            
            Database.SaveResult[] resultList=Database.insert(exportdDataList);
            
            for(Database.SaveResult result:resultList)
            {
                if(result.isSuccess())
                {
            		return 'SUCCESS';        
                }
                else
                {
                    for(Database.Error error:result.getErrors())
                    {
                        System.debug(error.getMessage());
                        return error.getMessage();
                    }
                }
            }
            return NULL;
        }
        catch(Exception exception1)
        {
            System.debug('Exception Occured'+exception1.getMessage());
            return 'Exception Occured-'+exception1.getMessage();
        }
    }
}