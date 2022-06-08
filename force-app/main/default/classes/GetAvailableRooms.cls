public class GetAvailableRooms 
{
    public static List<Room__c> getAvailableRooms(Id hotelId,Date bookingDate,String bookingType)
    {
        C_H_Junction__c[] countryRecord=[Select Country__c from C_H_Junction__c where Hotel__c= :hotelId LIMIT 1];

        Room__c[] availableRooms = [
            Select Id,Name,Hotel__c,Type__c,Hotel__r.Name
            from Room__c
            where 
            type__c=:bookingType AND
            Id not IN (Select Room__c from Booking__c where (Date__c = :bookingDate AND Booked__c = TRUE)) AND 
            Hotel__c IN (Select Hotel__c from C_H_Junction__c where Country__c = :countryRecord[0].Country__c)
        ];
        if(!availableRooms.isEmpty())
        {
            return availableRooms;
        }
        else
        {
            return NULL;
        }
    }
}