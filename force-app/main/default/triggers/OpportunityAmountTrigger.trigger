trigger OpportunityAmountTrigger on Opportunity (after insert,after update) 
{
    /*
	Decimal Amount=Trigger.new[0].Amount;
    System.debug('Amount is-'+Amount);
    
    CustomNotificationType notificationType = 
    [
        SELECT Id, DeveloperName 
        FROM CustomNotificationType 
        WHERE DeveloperName='Amount_Notification'
    ];

    Set<String> setIds=new Set<String>{Trigger.new[0].OwnerId};

    if(Amount>100000)
    {
        Messaging.CustomNotification msg=new Messaging.CustomNotification();
        msg.setTitle('Amount Greater than 100000');
        msg.setBody('Amount Greater than 100000');
        msg.setNotificationTypeId(notificationType.Id);
        msg.setTargetId(Trigger.new[0].Id);
        User[] users=[Select Id from User where ProfileId IN ('00e5j000002VF3iAAG','00e5j000000xoISAAY')];
        for(User u:users)
        {
            setIds.add(u.Id);
        }
        System.debug(setIds);
        msg.send(setIds);
    }
    else if(Amount>50000)
    {
        Messaging.CustomNotification msg=new Messaging.CustomNotification();
        msg.setTitle('Amount Greater than 50000');
        msg.setBody('Amount Greater than 50000');
        msg.setNotificationTypeId(notificationType.Id);
        msg.setTargetId(Trigger.new[0].Id);
        User[] users=[Select Id from User where ProfileId='00e5j000000xoISAAY'];
        for(User u:users)
        {
            setIds.add(u.Id);
        }
        System.debug(setIds);
        msg.send(setIds);
    }
    else if(Amount>10000)
    {
        Messaging.CustomNotification msg=new Messaging.CustomNotification();
        msg.setTitle('Amount Greater than 10000');
        msg.setBody('Amount Greater than 10000');
        msg.setNotificationTypeId(notificationType.Id);
        msg.setTargetId(Trigger.new[0].Id);
        User[] users=[Select Id from User where ProfileId='00e5j000000xoIhAAI'];
        for(User u:users)
        {
            setIds.add(u.Id);
        }
        System.debug(setIds);
        msg.send(setIds);
    }
    //VP 00e5j000000xoISAAY
    //Manager 00e5j000000xoIhAAI
    //SR 00e5j000000xoP5AAI
    //CEO Admin 00e5j000002VF3iAAG
    */
}