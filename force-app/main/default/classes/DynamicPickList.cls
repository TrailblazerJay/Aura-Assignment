public with sharing class DynamicPickList 
{
    @AuraEnabled
    public static List<String> objectNames()
    {
        List<String> strList=new List<String>();
        List<ObjectPermissions> objList=[SELECT Id, SobjectType FROM ObjectPermissions where PermissionsCreate=TRUE AND  PermissionsRead=TRUE AND PermissionsEdit=TRUE AND PermissionsDelete=TRUE];
        for(ObjectPermissions obj:objList)
        {
            strList.add((String)obj.SobjectType);
        }
        return strList;
    }
    /*
    @AuraEnabled
    public static Map<String,String> objectNames()
    {
        Map<String,String> mapOfObjectNames=new Map<String,String>();
        Map<String,Schema.SObjectType> names=Schema.getGlobalDescribe();
        for(String key:names.keySet())
        {
            Schema.SObjectType objectType=names.get(key);
            Schema.DescribeSObjectResult result=objectType.getDescribe();
            mapOfObjectNames.put(key,result.getName());
        }
        return mapOfObjectNames;
    }*/
    
    @AuraEnabled
    public static List<String> fieldNames(String Obj)
    {
        List<String> listOfFieldNames=new List<String>();
        List<AggregateResult> fieldNames=[SELECT Field FROM FieldPermissions where SobjectType=:Obj AND PermissionsRead=TRUE GROUP BY Field];
        for(AggregateResult field:fieldNames)
        {
            String str=(String)field.get('Field');
            listOfFieldNames.add(str.substringAfter('.'));
        }
        return listOfFieldNames;
    }

	// @AuraEnabled
    // public static Map<String,String> fieldNames(String Obj)
    // {
    //     Map<String,String> mapOfFieldNames=new Map<String,String>();
    //     Map<String,Schema.SObjectField> fieldNames=Schema.getGlobalDescribe().get(Obj).getDescribe().fields.getMap();
    //     for(String key:fieldNames.keySet())
    //     {
    //         Schema.SObjectField field=fieldNames.get(key);
    //         Schema.DescribeFieldResult result=field.getDescribe();
    //         mapOfFieldNames.put(key,result.getName());
    //     }
    //     return mapOfFieldNames;
    // }
    
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