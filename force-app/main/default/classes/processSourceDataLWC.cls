public class processSourceDataLWC
{
    //It takes External_Code as input and returns Practice Record else Creates a new Practice Record
    public static String createPractice(Practice__c[] practiceList)
    {
        try
        {                    
            insert practiceList;
            System.debug('Practice Created');
            return practiceList[0].Id;
        }
        catch(Exception exception1)
        {
            System.debug('Exception occured while creating new Practice__c');
            System.debug('Message-'+exception1.getMessage());
            return NULL;
        }
    }
    
    //It takes External_Code as input and returns Referrer Record else Creates a new Referrer Record
    public static String createReferrer(Referrer__c[] referrerList)
    {
        try
        {
            insert referrerList;            
            System.debug('Referrer Created');
            return referrerList[0].Id;
        }
        catch(Exception exception1)
        {
            System.debug('Exception occured while creating new Referrer__c');
            System.debug('Message-'+exception1.getMessage());
            return NULL;
        }
    }    

    //It takes Provider_Code as input and returns Practice based on Provider_Code
    public static String getPractice(String providerCode)
    {
        String practice;
        if( providerCode.length() == 8 )
        {
            Switch on providerCode.substring(7,8)
            {
                when 'A'
                {
                    practice = 'a025j000008VnFXAA0';
                    System.debug('Practice Attached to ADF');
                }
                when 'D'
                {
                    practice = 'a025j000008VnFcAAK';
                    System.debug('Practice Attached to Dental');
                }
                when 'M'
                {
                    practice = 'a025j000008VnFdAAK';
                    System.debug('Practice Attached to Miscellaneous');
                }
                when else 
                {
                    practice = '';
                }
            }
        }
        else{
            practice = 'a025j000008VnFhAAK';
            System.debug('Practice Attached to Invalid');
        }
        return practice;
    }

    @AuraEnabled(cacheable=true)
    public static String[] getDuplicatePracticeNReferrer(String sourceDataId)
    {
        String[] msg=new String[3];
        try
        {
            Source_Data__c sd = [
                Select Id,Name,Organisation_Name__c,First_Name__c,Last_Name__c,Provider_Code__c,Processing_Status__c
                from Source_Data__c 
                where Id=:sourceDataId
            ];

            if(sd.Processing_Status__c!='Processed')
            {
                String existingPracticeId = getPractice(sd.Provider_Code__c);
                if(existingPracticeId=='')
                {
                    List<Practice__c> practiceList = new List< Practice__c >(); 
                
                    practiceList.add(new Practice__c(
                        Name = sd.Organisation_Name__c,
                        Organisation_Name__c = sd.Organisation_Name__c,
                        External_Code__c = sd.Name
                    ));
                    
                    //fetching Duplicate if it exists
                    Practice__c[] duplicatePracticeList = getDuplicates(practiceList);

                    if(duplicatePracticeList.size()>0)
                    {
                        msg[0] = duplicatePracticeList[0].Id;
                    }
                    else
                    {
                        msg[0] = 'No Data';
                    }
                }
                else
                {
                    msg[0] = existingPracticeId;
                }
                List<Referrer__c> referrerList = new List<Referrer__c>();
                
                referrerList.add(new Referrer__c(
                    First_Name__c = sd.First_Name__c,
                    Name = sd.Last_Name__c,
                    External_Code__c = sd.Name
                ));
                
                //fetching Duplicate if it exists
                Referrer__c[] duplicateReferrerList = getDuplicates(referrerList);
                if(duplicateReferrerList.size()>0)
                {
                    msg[1] = duplicateReferrerList[0].Id;
                }
                else
                {
                    msg[1] = 'No Data';
                }
                msg[2] = 'No Error';
            }
            else
            {
                msg[0] = 'No Data';
                msg[1] = 'No Data';
                msg[2] = 'Record is already processed.';
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            msg[0] = 'No Data';
            msg[1] = 'No Data';
            msg[2] = e.getMessage();
        }
        return msg;
    }
        
    //It takes RecordList as input and returns Duplicate list if found else empty list    
    public static List<SObject> getDuplicates(List<SObject> recordValue)
    {
        List<SObject> duplicateRecord = new List<SObject>();
        try
        {
            List<Datacloud.FindDuplicatesResult> findDuplicatesResult = Datacloud.FindDuplicates.findDuplicates(recordValue);
            datacloud.DuplicateResult duplicateResult = findDuplicatesResult.get(0).getDuplicateResults().get(0);
            datacloud.MatchResult matchResult = duplicateResult.getMatchResults()[0];
            datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
            
            if(!matchRecords.isEmpty())
            {
                duplicateRecord.add(matchRecords[0].getRecord());
            }
        }
        catch(Exception exception1)
        {
            System.debug('Error-'+exception1.getMessage());
        }
        return duplicateRecord;
    }
    
    //It takes SourceData,Practice,Referrer as input and fetches Provider Record else Creates a new Provider Record & Profile Code
    @AuraEnabled
    public static String createProviderandProfileCode(Id practiceId, Id referrerId, Id sourceDataId)
    {
        String msg='';
                
        Source_Data__c sd = [
            Select 
            Id,Name,Description__c,Organisation_Name__c,First_Name__c,Last_Name__c,Provider_Code__c ,Processing_Status__c
            from Source_Data__c 
            where Id=:sourceDataId
        ];
        
        Source_Data__c[] duplicateSourceData = getDuplicates(new List<Source_Data__c>{sd});

        if(duplicateSourceData.size()==0)
        {
            SavePoint practiceSavepoint=Database.setSavepoint();
                
            if(sd.Processing_Status__c=='Pending')
            {
                List<Provider__c> providerList = new List<Provider__c>();
                
                try
                {
                    if(practiceId == NULL)
                    {    
                        String existingPracticeId = getPractice(sd.Provider_Code__c);
                        if(existingPracticeId == '')
                        {
                            List<Practice__c> practiceList = new List< Practice__c >(); 
                            
                            practiceList.add(new Practice__c(
                                Name = sd.Organisation_Name__c,
                                Organisation_Name__c = sd.Organisation_Name__c,
                                External_Code__c = sd.Name
                            ));
                            if(createPractice(practiceList) != NULL)
                            {
                                practiceId = createPractice(practiceList);
                            }
                            else
                            {
                                throw new IDException('Please enter valid Practice ID');
                            }
                        }
                        practiceId=existingPracticeId;
                    }
                }
                catch(Exception exception1)
                {
                    msg=exception1.getMessage();
                    return msg;
                }

                try
                {
                    if(referrerId == NULL)
                    {    
                        List<Referrer__c> referrerList = new List<Referrer__c>(); 
                        
                        referrerList.add(new Referrer__c(
                            First_Name__c = sd.First_Name__c,
                            Name = sd.Last_Name__c,
                            External_Code__c = sd.Name
                        ));
                        if(createReferrer(ReferrerList) != NULL)
                        {
                            referrerId = createReferrer(ReferrerList);
                        }
                        else
                        {
                            throw new IDException('Please enter valid Referrer ID');
                        }
                    }
                }
                catch(Exception exception1)
                {
                    msg=exception1.getMessage();
                    Database.rollback(practiceSavepoint);
                    return msg;
                }

                providerList.add(new Provider__c(
                    Practice__c = practiceId,
                    Referrer__c = referrerId,
                    Description__c = sd.Description__c,
                    External_Code__c = sd.Name
                ));
                
                //Checking for duplicate junction
                Provider__c[] duplicateProviderList=[
                    Select Id,Name 
                    from Provider__c 
                    where Practice__c=:practiceId AND Referrer__c=:referrerId
                ];

                if(duplicateProviderList.size() == 0)
                {   
                    try
                    {
                        insert providerList[0];
                        System.debug('Provider Created');

                        Profile_Code__c[] duplicateProfileCodeList=[Select Id,Name from Profile_Code__c where External_Code__c=:sd.Name];
                        
                        if(duplicateProfileCodeList.size() == 0)
                        {
                            //Creating related Profile Code
                            Profile_Code__c profileCode = new Profile_Code__c(
                                Practice__c = practiceId,
                                Referrer__c = referrerId,
                                Provider__c = providerList[0].Id,
                                Description__c = sd.Description__c,
                                External_Code__c = sd.Name
                            );
                            
                            insert profileCode;
                            msg = 'Provider & Profile Created Successfully.';
                            System.debug('Provider & Profile Created Successfully.');
                        }
                        else
                        {
                            msg = 'Provider Created Successfully & Profile Code Already exists.';
                        }
                        
                        sd.Processing_Status__c='Processed';
                        update sd;
                    }
                    catch(Exception exception1)
                    {
                        System.debug('Exception occured while creating new Provider__c.');
                        System.debug('Message-'+exception1.getMessage());
                        msg = exception1.getMessage();
                    }
                    return msg;
                }      
                else    
                {   
                    Profile_Code__c[] duplicateProfileCodeList = [Select Id,Name from Profile_Code__c where External_Code__c=:sd.Name];
                        
                    if(duplicateProfileCodeList.size() == 0)
                    {
                        Profile_Code__c profileCode = new Profile_Code__c(
                            Practice__c = practiceId,
                            Referrer__c = referrerId,
                            Provider__c = duplicateProviderList[0].Id,
                            Description__c = sd.Description__c,
                            External_Code__c = sd.Name
                        );
                        
                        try
                        {
                            insert profileCode;
                            msg = 'Provider Already Exists and Profile Code Created Successfully.';
                        }
                        catch(Exception exception1)
                        {
                            System.debug('Exception occured while creating new Profile_Code__c.');
                            System.debug('Message-'+exception1.getMessage());
                            msg = exception1.getMessage();
                        }
                    }
                    else
                    {
                        msg = 'Provider & Profile Code Already exists.';
                        System.debug('Provider & Profile Code Already exists.');
                    }
                    sd.Processing_Status__c='Processed';
                    update sd;

                    return msg;
                }
            }
            else if(sd.Processing_Status__c=='Duplicate Discarded')
            {
                return 'Duplicate Record cannot be processed.';    
            }
            else
            {
                return 'Record is already processed.';
            }
        }
        else
        {
            try
            {
                sd.Processing_Status__c='Duplicate_Discarded';
                update sd;
                return 'Duplicate record cannot be processed.';
            }
            catch(Exception exception1)
            {
                return exception1.getMessage();
            }
        }
	}

    public class IDException extends Exception{}
}