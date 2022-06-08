trigger CreateBooking on Booking__c (before insert) 
{

    Set<Id> roomIdSet=new Set<Id>();
    Set<Date> dateSet=new Set<Date>();
    
    Map<String,List<Room__c>> mapOfRoomsByType=new Map<String,List<Room__c>>();
    Map<Id,Booking__c> mapOfBookings=new Map<Id,Booking__c>();
    
    //store roomId and date in Set<Id>
    for(Booking__c booking:Trigger.new)
    {
        roomIdSet.add(booking.Room__c);
        dateSet.add(booking.Date__c);
    }

    //Get all the bookings based on Date__c & Room__C
    Booking__c[] bookings=[
        Select Id,Room__r.Type__c,Date__c 
        from Booking__c 
        where Date__c In :dateSet AND Room__c IN :roomIdSet
    ];
    
    //Get Type__c & Hotel__c from Room__c and not booked
    Room__c[] roomRecords=[
        Select Id,Name,Hotel__r.Name,Type__c 
        from Room__c 
        where Id Not IN
        (
            Select Room__c
            from Booking__c
            where Date__c IN :dateSet
        )
    ];

    //Fetch details of Junction & Room__c
    R_M_Junction__c[] rooms=[
        Select Id,Name,Room__c,Room__r.Name,Room__r.Type__c,Room__r.Hotel__c,Room__r.OwnerId,Under_Maintenance__c
        from R_M_Junction__c
        where Room__c=:roomIdSet
        AND Date__c=:dateSet
    ];
    
    CustomNotificationType notificationType = 
    [
        SELECT Id, DeveloperName 
        FROM CustomNotificationType 
        WHERE DeveloperName='Amount_Notification' LIMIT 1
    ];

    //Creating Map of room where key is Type__c and value is List<Room__c>
    for(Room__c room:roomRecords)
    {
        if(mapOfRoomsByType.containsKey(room.Type__c))
        {
            Room__c[] typeRooms=mapOfRoomsByType.get(room.Type__c);
            typeRooms.add(room);
            mapOfRoomsByType.put(room.Type__c,typeRooms);
        }
        else
        {
            mapOfRoomsByType.put(room.Type__c,new List<Room__c>{room});
        }
    }

    //Creating Map where Key is Room__c & Value Booking
    if(!bookings.isEmpty())
    {
        for(Booking__c booking:bookings)
        {
            mapOfBookings.put(booking.Room__c,booking);
        }
    }



    //if room exists
    if(!roomRecords.isEmpty())
    {
        List<R_M_Junction__c> updateRMJunction=new List<R_M_Junction__c>();

        //loop through all the triggered records
        for(Booking__c booking:Trigger.new)
        {
            //find key in Map where key is Room__c
            if(mapOfBookings.containsKey(booking.Room__c))
            {
                //compare date of booking__c of value in Map
                if(mapOfBookings.get(booking.Room__c).Date__c==booking.Date__c)
                {
                    String recommendationMessage='The room is already booked you can book Room No. ';
                    
                    //find key from Map where key is Type__c
                    if(mapOfRoomsByType.containsKey(mapOfBookings.get(booking.Room__c).Room__r.Type__c))
                    {
                        //if List<Room__c> > 0
                        if(mapOfRoomsByType.get(mapOfBookings.get(booking.Room__c).Room__r.Type__c).size()>0)
                        {
                            //Append Room No & Hotel_Name
                            for(Room__c room:mapOfRoomsByType.get(mapOfBookings.get(booking.Room__c).Room__r.Type__c))
                            {
                                recommendationMessage+=(room.Name+' in '+room.Hotel__r.Name+' ');
                            }
                            booking.addError(recommendationMessage);
                        }
                        else
                        {
                            booking.addError('No rooms available.');
                        }
                    }
                    //No room found for this type
                    else
                    {
                        booking.addError('No rooms available for this type.');    
                    }
                }
            }
            else
            {
                if(rooms.size()>0)
                {
                    for(R_M_Junction__c room:rooms)
                    {
                        if(booking.Room__c==room.Room__c)
                        {
                            if(room.Under_Maintenance__c==TRUE)
                            {
                                updateRMJunction.add(new R_M_Junction__c(Id=room.Id,Under_Maintenance__c=FALSE));
                                
                                Messaging.CustomNotification msg=new Messaging.CustomNotification();
                                msg.setTitle('Room No. '+room.Room__r.Name+' has removed from Maintenance');
                                msg.setBody('Room No. '+room.Room__r.Name+' has been booked on '+booking.Date__c);
                                msg.setNotificationTypeId(notificationType.Id);
                                msg.setTargetId(room.Id);
                                Set<String> userIds=new Set<String>{room.Room__r.OwnerId};
                                msg.send(userIds); 
                            }
                        }
                    }
                }
            }
        }
        try
        {
            update updateRMJunction;
        }               
        catch(Exception exception1)
        {
            System.debug(exception1.getMessage());
        }
    }
    //No rooms found
    else
    {
        System.debug('Room Container List is Empty');
    }    
}