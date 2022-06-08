public class CreateMultipleHoliday 
{
	public static void createMultipleHolidays()
    {
        List<Holiday__c> holidayList=new List<Holiday__c>();
        holidayList.add(new holiday__c(Contact__c='0035j00000NL707AAD',Name='2/06/2022 Aravind',Date__c=Date.parse('02/06/2022')));
        holidayList.add(new holiday__c(Contact__c='0035j00000NLL9zAAH',Name='2/06/2022 Bhanu',Date__c=Date.parse('02/06/2022')));    	
        try
        {
            insert holidayList;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }

    public static void updateMultipleHolidays()
    {
        List<Id> holidayList=new List<Id>{'a055j0000052V9xAAE','a055j0000052VACAA2','a055j0000052VA7AAM'};
        Holiday__c[] holidays=[Select Id from Holiday__c where Id IN :holidayList];
        for(Holiday__c holiday:holidays)
        {
            holiday.Date__c=Date.today();
        }
        try
        {
        	Database.SaveResult[] updateResultList=Database.update(holidays,false);
            for(Database.SaveResult updateResult:updateResultList)
            {
                if(updateResult.isSuccess())
                {
                    System.debug('Successfully Created-'+updateResult.getId());
                }
                else
                {
                    System.debug('Error-'+updateResult.getErrors());
                }
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }

    public static void deleteMultipleHolidays()
    {
        List<Id> holidayList=new List<Id>{'a055j0000052V6KAAU','a055j0000052V6FAAU','a055j0000052V66AAE'};
        Holiday__c[] holidays=[Select Id from Holiday__c where Id IN :holidayList];
        try
        {
        	Database.DeleteResult[] deleteResultList=Database.delete(holidays,false);
            for(Database.DeleteResult deleteResult:deleteResultList)
            {
                if(deleteResult.isSuccess())
                {
                    System.debug('Successfully Created-'+deleteResult.getId());
                }
                else
                {
                    System.debug('Error-'+deleteResult.getErrors());
                }
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }
    public static void undeleteMultipleHolidays()
    {
        List<String> holidayList=new List<String>{'Jay Holiday','Kartik Holiday','Arvind Holiday'};
        Holiday__c[] holidays=[Select Id from Holiday__c where Name IN :holidayList ALL ROWS];
        try
        {
        	Database.UndeleteResult[] undeleteResultList=Database.undelete(holidays,false);
            for(Database.UndeleteResult undeleteResult:undeleteResultList)
            {
                if(undeleteResult.isSuccess())
                {
                    System.debug('Successfully undeleted-'+undeleteResult.getId());
                }
                else
                {
                    System.debug('Error-'+undeleteResult.getErrors());
                }
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }

    // trigger HolidayTrigger on Holiday__c (before update,before delete,after undelete) {
    //     try{
    //         if(trigger.isUpdate || trigger.isDelete){
    //             List<Id> holidayIds = new list<Id>();                                       //list to store triggered holiday records ids
    //             Map<Id,Id> mapOfContacts = new Map<Id,Id>();                                //map to store contact ids and booking record ids
    //             for(Holiday__c triggeredRecord : trigger.old){
    //                 holidayIds.add(triggeredRecord.Id);
    //             }
    //             for(Booking__c bookingRecord : [SELECT Id, Contact__c                       
    //                                             FROM Booking__c 
    //                                             WHERE Contact__c  IN (SELECT Contact__c FROM Holiday__c WHERE Id IN : holidayIds)]){
    //                 mapOfContacts.put(bookingRecord.Contact__c, bookingRecord.Id);          //storing map with contact id and booking id who have holiday record associated
    //             }
    //             if(trigger.isDelete){
    //                 for(Holiday__c triggeredRecord : trigger.old){
    //                     if(mapOfContacts.containsKey(triggeredRecord.Contact__c)){          //checking if triggered holiday record has associated booking record
    //                         triggeredRecord.addError('You can\'t delete this record, this record is associated with a booking record');
    //                     }  
    //                 }
    //             }
    //             if(trigger.isUpdate){
    //                 for(Holiday__c triggeredRecord : trigger.new){
    //                     if(mapOfContacts.containsKey(triggeredRecord.Contact__c)){           //checking if triggered holiday record has associated booking record
    //                         triggeredRecord.addError('You can\'t delete this record, this record is associated with a booking record');
    //                     }
    //                 }
    //             }
    //         }
    //         if(trigger.isUndelete){
    //             List<Date> dateList = new List<Date>();                                     //list to store all dates of triggered records
    //             List<Id> accIds =new List<Id>();                                            //list to store all associated account ids of triggered records
    //             Map<Id,Holiday__c> mapOfTrigger = new Map<Id,Holiday__c>();                 //map to store account id and triggered record
    //             for(Holiday__c triggeredRecord : trigger.new){
    //                 dateList.add(triggeredRecord.Date__c);
    //                 accIds.add(triggeredRecord.Account__c);
    //                 mapOfTrigger.put(triggeredRecord.Account__c,triggeredRecord);           //storing associated account id and triggered record in map
    //             }
    //             for(AggregateResult holidayRecord : [SELECT Count(Id) countr ,Account__c a           
    //                                                  FROM Holiday__c 
    //                                                  WHERE (Date__c IN : dateList) AND (Account__c IN : accIds) GROUP BY Account__c]){
    //                 if(Integer.valueOf(holidayRecord.get('countr'))>1){                     //checking if undeleted holiday record already exists
    //                     mapOfTrigger.get((Id)holidayRecord.get('a')).addError('You can\'t restore this holiday record, there is an existing holiday record on same date for same account');
    //                 }
    //             }
    //         }
    //     }
    //     catch(DmlException e){
    //         system.debug('The following exception has occurred:-'+e.getMessage());
    //         system.debug('Line number:-' + e.getLineNumber());  
    //     }
    // }

}