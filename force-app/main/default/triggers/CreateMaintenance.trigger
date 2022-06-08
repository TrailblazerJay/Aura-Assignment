trigger CreateMaintenance on Maintaenance__c (after insert)
{
    Set<Id> hotelIdSet=new Set<Id>();
    Set<Date> dateSet=new Set<Date>();
    
    Map<Id,Maintaenance__c> maintenanceMap=new Map<Id,Maintaenance__c>(Trigger.newMap);
    Map<Id,List<Room__c>> roomMap=new Map<Id,List<Room__c>>();
    
    //store hotelId and date in Set<Id>
    for(Maintaenance__c maintenanceRecord:Trigger.new)
    {
        hotelIdSet.add(maintenanceRecord.Hotel__c);
        dateSet.add(maintenanceRecord.Date__c);
    }
    
    //Get all the bookings from Set<Date__c>
    Booking__c[] bookingList=[
        Select Room__c 
        from Booking__c 
        where Date__c=:dateSet AND Booked__c=TRUE
    ];
    
    //Get Hotel__c from Room__c and not booked
    Room__c[] roomList=[
        Select Id,Hotel__c 
        from Room__c 
        where Hotel__c IN :hotelIdSet AND Id NOT IN (
            Select Room__c 
            from Booking__c 
            where Date__c=:dateSet AND Booked__c=TRUE
        )
    ];
    
    //Create Map of room where key is Hotel__c and value is List<Room__c>
    for(Room__c room:roomList)
    {
        if(roomMap.containsKey(room.Hotel__c))
        {
            Room__c[] rooms=roomMap.get(room.Hotel__c);
            rooms.add(room);
            roomMap.put(room.Hotel__c,rooms);
        }
        else
        {
            roomMap.put(room.Hotel__c,new List<Room__c>{room});
        }
    }
    
    //Records Found
    if(!roomList.isEmpty())
    {
        List<R_M_Junction__c> junctionList=new List<R_M_Junction__c>();

        //Rooms based on Room
        for(Maintaenance__c maintenanceRecord:Trigger.new)
        {
            //find key in Map where key is Hotel__c
            if(roomMap.containsKey(maintenanceRecord.Hotel__c))
            {
                //Loop through all rooms in map & create a junction record
                for(Room__c room:roomMap.get(maintenanceRecord.Hotel__c))
                {
                    junctionList.add(new R_M_Junction__c(Room__c=room.Id,Maintenance__c=maintenanceRecord.Id,Under_Maintenance__c=TRUE,Date__c=maintenanceRecord.Date__c));
                }
            }
        }
        
        // for(Room__c room:roomList)
        // {
        //     for(Maintaenance__c maintenanceRecord:Trigger.new)
        //     {
        //         if(room.Hotel__c==maintenanceRecord.Hotel__c)
        //         {
        //             junctionList.add(new R_M_Junction__c(Room__c=room.Id,Maintenance__c=maintenanceRecord.Id,Under_Maintenance__c=TRUE));
        //         }
        //     }
        // }
        
        try
        {
            insert junctionList;
            System.debug('All rooms updated as per booking in maintenance.');
        }
        catch(Exception exception1)
        {
            System.debug(exception1.getLineNumber());
            System.debug(exception1.getMessage());
            System.debug(exception1.getStackTraceString());
        }
    }
    else
    {
        System.debug('All rooms are already booked.');
    }
}