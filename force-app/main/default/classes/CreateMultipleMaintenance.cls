public class CreateMultipleMaintenance 
{
	public static void createMultipleMaintenances()
    {
        List<Maintaenance__c> maintenanceList=new List<Maintaenance__c>();
        maintenanceList.add(new Maintaenance__c(Hotel__c='a0D5j0000069xbBEAQ',Name='3/05/2022 Country',Date__c=Date.parse('03/05/2022')));
        // maintenanceList.add(new Maintaenance__c(Hotel__c='a0D5j0000069xSKEAY',Name='2/05/2022 Taj',Date__c=Date.parse('02/05/2022')));
        // maintenanceList.add(new Maintaenance__c(Hotel__c='a0D5j0000069xbGEAQ',Name='2/05/2022 Ramada',Date__c=Date.parse('02/05/2022')));
        // maintenanceList.add(new Maintaenance__c(Hotel__c='a0D5j0000069xSPEAY',Name='2/05/2022 Marriott',Date__c=Date.parse('02/05/2022')));
        try
        {
        	Database.SaveResult[] insertResultList=Database.insert(maintenanceList,false);
            for(Database.SaveResult insertResult:insertResultList)
            {
                if(insertResult.isSuccess())
                {
                    System.debug('Successfully Created-'+insertResult.getId());
                }
                else
                {
                    System.debug('Error-'+insertResult.getErrors());
                }
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }
}