Trigger HolidayTrigger on Holiday__c (before update,before delete,after undelete) 
{
    If(Trigger.isBefore)
    {
        Set<Id> contactIdSet=new Set<Id>();
        Set<Date> dateSet=new Set<Date>();
       
        Map<Id,Booking__c> bookingMap=new Map<Id,Booking__c>();
        
        //store contactId and date in Set<Id>
        for(Holiday__c holiday:Trigger.old)
        {
            contactIdSet.add(holiday.Contact__c);
            dateSet.add(holiday.Date__c);
        }
        
        //Get all the bookings based on Date__c & Contact__c
        Booking__c[] bookingList=[
            Select Id,Contact__c,Date__c 
            from Booking__c 
            where Contact__c IN :contactIdSet AND Date__c IN :dateSet
        ];
        
        //Creating Map where Key is Contact__c & Value Booking
        for(Booking__c booking:bookingList)
        {
            bookingMap.put(booking.Contact__c,booking);
        }

        If(Trigger.isDelete)
        {
            //loop through all the triggered records
            for(Holiday__c holiday:Trigger.old)
            {
                //find key in Map where key is Contact__c
                if(bookingMap.containsKey(holiday.Contact__c))
                {
                    //compare date of Booking__c of value in Map
                    if(bookingMap.get(holiday.Contact__c).Date__c==holiday.Date__c)
                    {
                        holiday.addError('Holiday can\'t be Deleted, It Already has an booking.');
                    }
                }
            }
        }
        else
        {
            //loop through all the triggered records
            for(Holiday__c holiday:Trigger.old)
            {
                //find key in Map where key is Contact__c
                if(bookingMap.containsKey(holiday.Contact__c))
                {
                    //compare date of holiday__c of value in Map
                    if(bookingMap.get(holiday.Contact__c).Date__c==holiday.Date__c)
                    {
                        Trigger.newMap.get(holiday.Id).addError('Holiday can\'t be Updated, It Already has an booking');
                    }
                }
            }
        }
    }
    Else If(Trigger.isAfter)
    {
        Set<Id> contactIdSet=new Set<Id>();
        Set<Date> dateSet=new Set<Date>();
        
        Map<Id,Holiday__c> holidayMap=new Map<Id,Holiday__c>();
        
        //store contactId and date in Set<Id>
        for(Holiday__c holiday:Trigger.new)
        {
            contactIdSet.add(holiday.Contact__c);
            dateSet.add(holiday.Date__c);
        }

        //Get all the holidays based on Date__c & Contact__c
        Holiday__c[] holidayList=[
            Select Id,Contact__c,Date__c 
            from Holiday__c 
            where Contact__c IN :contactIdSet AND Date__c IN :dateSet
        ];
        
        //Creating Map where Key is Contact__c & Value Holiday
        for(Holiday__c holiday:holidayList)
        {
            holidayMap.put(holiday.Contact__c,holiday);
        }
        
        //loop through all the triggered records
        for(Holiday__c holiday:Trigger.new)
        {
            //find key in Map where key is Contact__c
            if(holidayMap.containsKey(holiday.Contact__c))
            {
                //compare date of Booking__c of value in Map
                if(holidayMap.get(holiday.Contact__c).Date__c==holiday.Date__c)
                {
                    //Checking the record found is not same as Triggered Record
                    if(holidayMap.get(holiday.Contact__c).Id!=holiday.Id)
                    {
                        holiday.addError('Holiday Already Exists');
                    }
                }
            }
        }
    }
}