public class processSourceDataLWC
{
    //It takes External_Code as input and returns Practice Record else Creates a new Practice Record
    public static Practice__c createPractice(Source_Data__c sourceData)
    {
        List< Practice__c > practiceList = new List< Practice__c >(); 
        
        practiceList.add(new Practice__c(
            Name = sourceData.Organisation_Name__c,
            Organisation_Name__c = sourceData.Organisation_Name__c,
            External_Code__c = sourceData.Name
        ));
        
        //fetching Duplicate if it exists
        Practice__c[] duplicatePracticeList = getDuplicates(practiceList);
        
        //If no duplicate found then create new Practice
        if( duplicatePracticeList.size() == 0 )
    	{
            try
            {                    
                insert practiceList;
                System.debug('Practice Created');
                return practiceList[0];
            }
            catch(Exception exception1)
            {
                System.debug('Exception occured while creating new Practice__c');
                System.debug('Message-'+exception1.getMessage());
                return NULL;
            }
    	}
        //Else update the duplicate practice record with new data 
        else
        {
            Practice__c updatePractice = new Practice__c(
                Id = duplicatePracticeList[0].Id,
                Name = sourceData.Organisation_Name__c,
                Organisation_Name__c = sourceData.Organisation_Name__c
            );

            try
            {
               	update updatePractice;
                System.debug('Practice Updated');
                return updatePractice;
            }
            catch(Exception exception1)
            {
                System.debug('Exception occured while updating Practice__c');
                System.debug('Message-'+exception1.getMessage());
                return NULL;
            }
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String getDuplicatePracticeNReferrer(String sourceDataId)
    {
        String msg='Demo';
        try
        {
            Source_Data__c sd=[Select Id,Name,Organisation_Name__c,First_Name__c,Last_Name__c from Source_Data__c where Id=:sourceDataId];

            List< Practice__c > practiceList = new List< Practice__c >(); 
            
            practiceList.add(new Practice__c(
                Name = sd.Organisation_Name__c,
                Organisation_Name__c = sd.Organisation_Name__c,
                External_Code__c = sd.Name
            ));
            
            //fetching Duplicate if it exists
            Practice__c[] duplicatePracticeList = getDuplicates(practiceList);
            
            List< Referrer__c > referrerList = new List< Referrer__c >();
            
            referrerList.add(new Referrer__c( 
                First_Name__c = sd.First_Name__c,
                Name = sd.Last_Name__c,
                External_Code__c = sd.Name
            ));
            
            //fetching Duplicate if it exists
            Referrer__c[] duplicateReferrerList = getDuplicates(referrerList);
    
            if(duplicatePracticeList[0].Id!=NULL && duplicateReferrerList[0].Id!=NULL)
            {
                msg=duplicatePracticeList[0].Id+' '+duplicateReferrerList[0].Id;
            }
            else
            {
                msg='No Duplicates Found';
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            msg = e.getMessage();
        }
        return msg;
    }

    //It takes External_Code as input and returns Referrer Record else Creates a new Referrer Record
    public static Referrer__c createReferrer(Source_Data__c sourceData)
    {
     	List< Referrer__c > referrerList = new List< Referrer__c >();
        
        referrerList.add(new Referrer__c( 
            First_Name__c = sourceData.First_Name__c,
            Name = sourceData.Last_Name__c,
            External_Code__c = sourceData.Name
        ));
        
        //fetching Duplicate if it exists
        Referrer__c[] duplicateReferrerList = getDuplicates(referrerList);
        
        //If no duplicate found then create new Practice
        if( duplicateReferrerList.size() == 0 )
    	{                     
            try
            {
                insert referrerList;            
                System.debug('Referrer Created');
                return referrerList[0];
            }
            catch(Exception exception1)
            {
                System.debug('Exception occured while creating new Referrer__c');
                System.debug('Message-'+exception1.getMessage());
                return NULL;
            }
        }

        //Else update the duplicate practice record with new data 
        else
        {
            Referrer__c updateReferrer = new Referrer__c(
                Id = duplicateReferrerList[0].Id,
                First_Name__c = sourceData.First_Name__c,
                Name = sourceData.Last_Name__c
            );
        	
            try
            {
                update updateReferrer;
                System.debug('Referrer Updated');
                return updateReferrer;
            }
            catch(Exception exception1)
            {
                System.debug('Exception occured while updating Referrer__c');
                System.debug('Message-'+exception1.getMessage());
                return NULL;
            }
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
    
    //It takes External,Practice,Referrer as input and fetches Provider Record else Creates a new Provider Record
    @AuraEnabled
    public static String createProviderandProfileCode(Id practiceId, Id referrerId, Id sourceDataId)
    {
        Source_Data__c sd=[Select Id,Name,Description__c,Organisation_Name__c,First_Name__c,Last_Name__c from Source_Data__c where Id=:sourceDataId];

        List<Provider__c> providerList = new List<Provider__c>();

        providerList.add(new Provider__c(
            Practice__c = practiceId,
            Referrer__c = referrerId,
            Description__c = sd.Description__c,
            External_Code__c = sd.Name
        ));
        
        //Checking for duplicate junction
        Provider__c[] duplicateProviderList=[Select Id,Name from Provider__c where Practice__c=:practiceId AND Referrer__c=:referrerId];

        if(duplicateProviderList.size() == 0)
        {   
            String msg='';
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
                    msg = 'Provider & Profile Created Successfully';
                    System.debug('Provider & Profile Created Successfully');
                }
                else
                {
                    msg = 'Provider Created Successfully & Profile Code Already exists';
                }
            }
            catch(Exception exception1)
            {
                System.debug('Exception occured while creating new Provider__c');
                System.debug('Message-'+exception1.getMessage());
                msg = exception1.getMessage();
            }
            return msg;
        }       
        else    
        {
            String msg = '';
            
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
                    msg = 'Provider Already Exists and Profile Code Created Successfully';
                }
                catch(Exception exception1)
                {
                    System.debug('Exception occured while creating new Profile_Code__c');
                    System.debug('Message-'+exception1.getMessage());
                    msg = exception1.getMessage();
                }
            }
            else
            {
                msg = 'Provider & Profile Code Already exists';
                System.debug('Provider & Profile Code Already exists');
            }
            // else
            // {
            //     System.debug('Provider Updated');
            //     Provider__c provider2=provider[0];
            //     provider2.Description__c=external.Description__c;
            //     provider2.Practice_Name__c=getPractice(external.Provider_Code__c);
            //     update provider2;
            //     return provider2;
            // }
            return msg;
        }
	}
}