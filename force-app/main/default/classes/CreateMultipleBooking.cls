public class CreateMultipleBooking {
    public static void createMultipleBookings()
    {
        List<Booking__c> bookingList=new List<Booking__c>();
        bookingList.add(new Booking__c(Contact__c='0035j00000NLKmqAAH',Room__c='a0F5j000000OSkfEAG',Date__c=Date.parse('02/05/2022'),Booked__c=TRUE));
        bookingList.add(new Booking__c(Contact__c='0035j00000NLMfUAAX',Room__c='a0F5j000000OSuTEAW',Date__c=Date.parse('02/05/2022'),Booked__c=TRUE));
        bookingList.add(new Booking__c(Contact__c='0035j00000NokDnAAJ',Room__c='a0F5j000000OSunEAG',Date__c=Date.parse('02/05/2022'),Booked__c=TRUE));
        bookingList.add(new Booking__c(Contact__c='0035j00000NLL9zAAH',Room__c='a0F5j000000OSv2EAG',Date__c=Date.parse('02/05/2022'),Booked__c=TRUE));
        bookingList.add(new Booking__c(Contact__c='0035j00000NL707AAD',Room__c='a0F5j000000OSunEAG',Date__c=Date.parse('03/05/2022'),Booked__c=TRUE));
        bookingList.add(new Booking__c(Contact__c='0035j00000NL707AAD',Room__c='a0F5j000000OSunEAG',Date__c=Date.parse('04/05/2022'),Booked__c=TRUE));
        try
        {
        	Database.SaveResult[] insertResultList=Database.insert(bookingList,false);
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