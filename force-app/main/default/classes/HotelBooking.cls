public class HotelBooking 
{
	//1a Create Hotel
    public static void createHotel(String hotelName, String description, String city)
    {
        try
        {
            Hotel__c newHotel = new Hotel__c(
                Name = hotelName,
                Description__c = description,
                City__c = city
            );
        
            if(newHotel != NULL)
            {    
                insert newHotel;
                System.debug('Hotel Created');
            }
            else
            {
                System.debug('Hotel Not Created');
            }
        }
        catch(Exception exception1)
        {
            System.debug('Exception-'+exception1.getMessage());
            System.debug('Exception-'+exception1.getLineNumber());
            System.debug('Exception-'+exception1.getStackTraceString());
        }
    }

    /*
    try{
        bh.updateHotelDescription('ahdj','description');
    }
    catch(Exception exception1)
    {
        System.debug('Please enter valid data');
        System.debug('Message-'+exception1.getMessage());
    }
    */
    //1b Update Hotel
    public static void updateHotelDescription(Id hotelId, String description)
    {
        try
        {
            Hotel__c updateHotel = new Hotel__c(
                Id = hotelId,
                Description__c = description
            );
        
            if(updateHotel != NULL)
            {
                update updateHotel;
                System.debug('Hotel Updated');
            }
                //before creation/updation
            else
            {
                System.debug('Hotel Updation Failed');
            }
        }
        catch(Exception exception1)
        {
            System.debug('Message-'+exception1.getMessage());
        }
    }

    /*
    try{
        bh.updateHotelDescription('ahdj','description');
    }
    catch(Exception exception1)
    {
        System.debug('Please enter valid data');
        System.debug('Message-'+exception1.getMessage());
    }
    */
    //1c Delete Hotel by Id
    public static void deleteHotel(Id hotelId)
    {
        try
        {
            Hotel__c deleteHotel = new Hotel__c(Id = hotelId);
        
            if(deleteHotel != NULL)
            {
                delete deleteHotel;
                System.debug('Hotel Deleted');
            }
            else
            {
                System.debug('Hotel Deletion Failed');
            }
        }
        catch(Exception exception1)
        {
            System.debug('Message-'+exception1.getMessage());
        }
    }
    
    /*
    try{
        bh.updateHotelDescription('ahdj');
    }
    catch(Exception exception1)
    {
        System.debug('Please enter valid id');
        System.debug('Message-'+exception1.getMessage());
    }
    */

    //2 Creates booking records by AccountId & CountryId
    public static List<Booking__c> createBooking(Id accountId, Id countryId)
    {
        //Acc Id 0015j00000XHI5CAAX
        //Get All the Holidays based on Account
        Holiday__c[] holidays = [
            Select Contact__c, Date__c 
            from Holiday__c 
            where Account__c = :accountId
        ];

        if(holidays.isEmpty())
        {
            System.debug('No Holidays exist for his Account');
            return NULL;
        }
        
        //Country ID a0C5j000000gcBpEAI
        //Get all the available rooms based on Country and hotels in that country
        Room__c[] availableRooms = [
            Select Id,Name 
            from Room__c 
            where Id not IN ( Select Room__c from Booking__c where Booked__c = TRUE ) 
            AND 
            Hotel__c IN (Select Hotel__c from C_H_Junction__c where Country__c = :countryId)
        ];

        //If no rooms available then return Null
        if(availableRooms.isEmpty())
        {
            System.debug('No Rooms Available for All Hotels');
            return NULL;
        }
        
        //Create booking based on count of Holidays & Rooms
        List<Booking__c> bookingList = new List<Booking__c>();
        Integer noOfHolidays = holidays.size();
        Integer noOfRoomsAvailable = availableRooms.size();
        
        //If Rooms are more than Holidays than take holiday count
        if(noOfHolidays <= noOfRoomsAvailable)
        {
            System.debug('Rooms are more than Holidays');
            for(Integer i = 0; i < noOfHolidays; i++)
            {
                bookingList.add(new Booking__c(
                    Date__c = holidays[i].Date__c,
                    Room__c = availableRooms[i].Id,
                    Contact__c = holidays[i].Contact__c,
                    Booked__c = TRUE
                    )
                );
            }
        }
        //If Holidays are more than Rooms than take room count
        else
        {
            System.debug('Holidays are more than Rooms');
            for(Integer i = 0; i < noOfRoomsAvailable; i++)
            {
                bookingList.add(new Booking__c(
                    Date__c = holidays[i].Date__c,
                    Room__c = availableRooms[i].Id,
                    Contact__c = holidays[i].Contact__c,
                    Booked__c = TRUE
                    )
                );
            }
        }
        try
        {
            //Create Records
            insert bookingList;
            System.debug('Bookings Created for Holidays');
            return bookingList;
        }
        catch(Exception exception1)
        {
            System.debug('Bookings Creation Failed!!!');
            System.debug('Message-'+exception1.getMessage());
            return NULL;
        }
    }

    //3 Cancel a booking using booking Id
    public static void cancelBooking(String bookingId)
    {
        //Get booking based on bookingId
        Booking__c[] bookingRecord = [
            Select Id, Booked__c 
            from Booking__c 
            where Name = :bookingId
        ];

        //If list is not Empty
        if(!bookingRecord.isEmpty())
        {
            //And booked is TRUE
            if(bookingRecord[0].Booked__c == TRUE)
            {
                //then change to FALSE 
                bookingRecord[0].Booked__c = FALSE;
                try
                {
                    update bookingRecord[0];
                    System.debug('Booking Cancelled');
                }
                catch(Exception exception1)
                {
                    System.debug('Message-'+exception1.getMessage());
                }
            }        
            // Already Cancelled
            else
            {
                System.debug('Booking is already Cancelled');
            }
        }
        //Invalid Id
        else
        {
            System.debug('No record found or Invalid Id');
        }
    }

    //4 Delete Orphan record based on Holiday
    public static void deleteOrphanedContacts()
    {
        //Get a contacts who dont have a single holiday 
        List<Contact> orphanedContact = [
            Select Id 
            from Contact 
            where Id NOT IN (Select Contact__c from Holiday__c) LIMIT 1
        ];

        if(!orphanedContact.isEmpty())
        {
            System.debug(orphanedContact);
            try
            {
                //Delete Contacts
                delete orphanedContact;
                System.debug('Orphans deleted Successfully');
                System.debug('Number of Rows Deleted : '+Limits.getDmlRows());
            }
            catch(Exception exception1)
            {
                System.debug('Message-'+exception1.getMessage());
            }
        }
        else
        {
            System.debug('No orphan record found');
        }
    }

    //Get a Rooms based on Hotels based on specific Country & Date
    public static List<Room__c> getRoomByDate(Id countryId, Date bookingDate)
    {
        //Get Room__c records based on Country & Date
        Room__c[] availableRooms = [
            Select Id,Name,Hotel__c
            from Room__c
            where Id not IN (Select Room__c from Booking__c where (Date__c = :bookingDate AND Booked__c = TRUE))
            AND Hotel__c IN (Select Hotel__c from C_H_Junction__c where Country__c = :countryId)
        ];

        if(availableRooms.isEmpty())
        {
            System.debug('No Rooms Available for this Date');
            return NULL;
        }
        else
        {
            System.debug(availableRooms);
            return availableRooms;
        }
    }

    //Create a booking record
    public static void createSingleBooking(Id countryId, Id contactId, Date bookingDate)
    {
        //Check if contact already has booking on same date
        Booking__c[] bookings = [
            Select 
                Id,
                Name,
                Contact__r.Name,
                Room__r.Name,
                Date__c 
            from Booking__c 
            where Contact__c = :contactId 
            AND Date__c = :bookingDate AND Booked__c = TRUE
        ];
        
        if( bookings.isEmpty() )
        {
            //Check for rooms available in a particular Country/City and Date
            Room__c[] availableRooms = [
                Select Id, Name, Hotel__c
                from Room__c
                where Id not IN ( Select Room__c from Booking__c where ( Date__c = :bookingDate AND Booked__c = TRUE ) )
                AND Hotel__c IN ( Select Hotel__c from C_H_Junction__c where Country__c = :countryId )
            ];

            //If Rooms are available
            if( !availableRooms.isEmpty() )
            {
                //Creating a Map where key is HotelId and Values as List<Room>
                Map<Id, List<Room__c>> roomMap = new Map<Id, List<Room__c>>();
                for(Room__c room:availableRooms)
                {
                    if(roomMap.containsKey(room.Hotel__c))
                    {
                        Room__c[] roomList = roomMap.get(room.Hotel__c);
                        roomList.add(room);
                        roomMap.put(room.Hotel__c,roomList);
                    }
                    else
                    {
                        roomMap.put(room.Hotel__c,new List<Room__c>{room});
                    }
                }
                System.debug(roomMap);
                
                //Looping through Map and getting HotelId with highest Count of Rooms Available
                Integer highestCount = 0;
                Id highestId = NULL;
                for(Id ids:roomMap.keySet())
                {
                    if(roomMap.get(ids).size() > highestCount)
                    {
                        highestCount = roomMap.get(ids).size();
                        highestId = ids;
                    }
                }
                
                System.debug(highestCount);
                System.debug(highestId);
                System.debug(roomMap.get(highestId)[0]);

                //Get AccountId of that Contact 
                Contact contactRecord = [
                    Select AccountId 
                    from Contact 
                    where Id = :contactId
                ];
                
                //Get contacts from same account who have booking on same date
                Contact[] relatedContacts = [
                    Select Id, Name
                    from Contact
                    where AccountId = :contactRecord.AccountId AND Id IN ( 
                        Select Contact__c 
                        from Booking__c 
                        where Date__c = :bookingDate AND Booked__c = TRUE
                        )
                ];
                
                //Show contacts from same account who have leave on same date
                if(!relatedContacts.isEmpty())
                {
                    for(Contact relatedContact : relatedContacts)
                    {
                        System.debug(relatedContact.Name + ' also has an booking on ' + bookingDate);
                    }
                }
                
                try
                {
                    //Create a new Booking for Contact on fetched Rooms
                    Booking__c booking = new Booking__c(
                        Date__c = bookingDate,
                        Room__c = roomMap.get(highestId)[0].Id,
                        Contact__c = contactId,
                        Booked__c = TRUE
                    );
                    insert booking;
                    System.debug('Booking Created');
                }
                catch(Exception exception1)
                {
                    System.debug('Booking creation failed');
                    System.debug('Message-' +exception1.getMessage());
                }
            }
            else
            {
                System.debug('No Rooms Available for this Date');
            }
        }
        else
        {
            System.debug('Booking Already Exists\n' +bookings[0].Contact__r.Name+ ' has aleady booked Room No ' +bookings[0].Room__r.Name+ ' on '+bookings[0].Date__c);
        }
    }

    public static void createSingleBooking1(Id countryId, Id contactId, Date bookingDate)
    {
        //Get AccountId of that Contact 
        Contact contactRecord = [
            Select AccountId,Name
            from Contact
            where Id = :contactId
        ];
        
        //Get holidays from same account who have holidays on same date
        Holiday__c[] relatedHolidays = [
            Select Id, Contact__r.Name, Date__c
            from Holiday__c
            where Account__c = :contactRecord.AccountId AND Date__c = :bookingDate
        ];

        if(!relatedHolidays.isEmpty())
        {
            for(Holiday__c holiday:relatedHolidays)
            {
                System.debug(holiday.Contact__r.Name + ' already has an holiday on ' + holiday.Date__c);
            }
        }
        else
        {
            Holiday__c holiday=new Holiday__c(
                Contact__c = contactId,
                Date__c = bookingDate,
                Name = contactRecord.Name,
                Account__c = contactRecord.AccountId
            );

            try
            {
                insert holiday;
                System.debug('Holiday Created Successfully');
            }
            catch(Exception exception1)
            {
                System.debug('Holiday Creation Failed');
                System.debug('Message-'+exception1.getMessage());
            }

            Booking__c[] bookings = [
                Select 
                    Id,
                    Name,
                    Contact__r.Name,
                    Room__r.Name,
                    Date__c
                from Booking__c 
                where Contact__c = :contactId
                AND Date__c = :bookingDate AND Booked__c = TRUE
            ];
            
            if( bookings.isEmpty() )
            {
                //Check for rooms available in a particular Country/City and Date
                Room__c[] availableRooms = [
                    Select Id, Name, Hotel__c
                    from Room__c
                    where Id not IN ( Select Room__c from Booking__c where ( Date__c = :bookingDate AND Booked__c = TRUE ) )
                    AND Hotel__c IN ( Select Hotel__c from C_H_Junction__c where Country__c = :countryId )
                ];

                //If Rooms are available
                if( !availableRooms.isEmpty() )
                {
                    //Creating a Map where key is HotelId and Values as List<Room>
                    Map<Id, List<Room__c>> roomMap = new Map<Id, List<Room__c>>();
                    for(Room__c room:availableRooms)
                    {
                        if(roomMap.containsKey(room.Hotel__c))
                        {
                            Room__c[] roomList = roomMap.get(room.Hotel__c);
                            roomList.add(room);
                            roomMap.put(room.Hotel__c,roomList);
                        }
                        else
                        {
                            roomMap.put(room.Hotel__c,new List<Room__c>{room});
                        }
                    }
                    System.debug(roomMap);
                    
                    //Looping through Map and getting HotelId with highest Count of Rooms Available
                    Integer highestCount = 0;
                    Id highestId = NULL;
                    for(Id ids:roomMap.keySet())
                    {
                        if(roomMap.get(ids).size() > highestCount)
                        {
                            highestCount = roomMap.get(ids).size();
                            highestId = ids;
                        }
                    }
                    
                    System.debug(highestCount);
                    System.debug(highestId);
                    System.debug(roomMap.get(highestId)[0]);

                    try
                    {
                        //Create a new Booking for Contact on fetched Rooms
                        Booking__c booking = new Booking__c(
                            Date__c = bookingDate,
                            Room__c = roomMap.get(highestId)[0].Id,
                            Contact__c = contactId,
                            Booked__c = TRUE
                        );
                        insert booking;
                        System.debug('Booking Created');
                    }
                    catch(Exception exception1)
                    {
                        System.debug('Message-'+exception1.getMessage());
                    }
                }
            }
            else 
            {
                System.debug('Booking Already Exists\n' +bookings[0].Contact__r.Name+ ' has aleady booked Room No ' +bookings[0].Room__r.Name+ ' on '+bookings[0].Date__c);
            }
        }
    }
    
    //Contact c=[Select Contact__c from Holiday__c where Account__c='0015j00000XHI5CAAX']; get Holiday
    //Select Hotel__c from C_H_Junction__c where Country__c='a0C5j000000gcBpEAI' get Related Hotel
    //Select Room__c from Booking__c where Room__c NOT IN (Select Id from Room__c)
    //Select Id,Name from Room__c where Id not IN(Select Room__c from Booking__c where Booked__c=TRUE)

    //SELECT Id, Name FROM Room__c WHERE (Id NOT IN (SELECT Room__c FROM Booking__c WHERE (Date__c = 2022-04-30 AND Booked__c = TRUE)) AND Hotel__c IN (SELECT Hotel__c FROM C_H_Junction__c WHERE Country__c = 'a0C5j000000gcBpEAI'))

    //6th 
    //Select Id,Room__r.Name from Booking__c where Contact__r.AccountId in (Select AccountId from Contact where Id='0035j00000NL707AAD')
    //Select Id,Name from Contact where Id IN ( Select Contact__c from Booking__c ) AND AccountId='0015j00000dDP88AAG'
    /**
     * Contact[] relatedContacts = [
    Select Id,Name
    from Contact
    where
    AccountId='0015j00000dDP88AAG' AND
    Id IN (
        Select Contact__c
        from Booking__c
        where Date__c=Date.parse('20/04/2022')
    )
    //Date dateValue=Date.parse('30/04/2022');
        //Contact[] relatedContacts = [Select Id,Name from Contact where AccountId=(Select AccountId from Contact where Id='0035j00000NL6siAAD') AND Id IN ( Select Contact__c from Booking__c where Date__c=:dateValue AND Booked__c=TRUE)];
        //System.debug(relatedContacts);
];
     */

    //22=04-2022 3:18
    /*
    Date bookingDate=Date.parse('28/04/2022');
    Id countryId='a0C5j000000gcBkEAI';
    AggregateResult[] availableRoomsCount = [
                    Select Hotel__c,count(Id)
                    from Room__c
                    where Id not IN (Select Room__c from Booking__c where (Date__c=:bookingDate AND Booked__c=TRUE))
                    AND Hotel__c IN (Select Hotel__c from C_H_Junction__c where Country__c=:countryId) group by Hotel__c order by count(Id) DESC
                ];
    System.debug(availableRoomsCount);
    
    List<Id> listHotel=new List<Id>();
    for(AggregateResult ar:availableRoomsCount)
    {
        listHotel.add((Id)ar.get('Hotel__c'));
    }
    Room__c[] availableRooms = [
                    Select Id,Name,Hotel__c
                    from Room__c
                    where Id not IN (Select Room__c from Booking__c where (Date__c=:bookingDate AND Booked__c=TRUE))
                    AND Hotel__c IN (Select Hotel__c from C_H_Junction__c where Country__c=:countryId) order by listHotel
                ];
    System.debug(availableRooms);
    
    */
}