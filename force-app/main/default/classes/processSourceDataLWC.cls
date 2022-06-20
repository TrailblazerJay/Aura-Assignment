public class processSourceDataLWC
{

    //It takes External_Code as input and returns Practice Record else Creates a new Practice Record
    public Practice__c createPractice(Source_Data__c sourceData)
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
    
    //It takes External_Code as input and returns Referrer Record else Creates a new Referrer Record
    public Referrer__c createReferrer(Source_Data__c sourceData)
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
    public String getPractice(String providerCode)
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
    public List<SObject> getDuplicates(List<SObject> recordValue)
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
    public Provider__c createProvider( Id practiceId, Id referrerId, Source_Data__c sourceDataRecord)
    {
        List< Provider__c > providerList = new List< Provider__c >();

        providerList.add(new Provider__c(
            Practice__c = practiceId,
            Referrer__c = referrerId,
            Description__c = sourceDataRecord.Description__c,
            External_Code__c = sourceDataRecord.Name
        ));
        
        //Checking for duplicates
        Provider__c[] duplicatePracticeList = getDuplicates(providerList);

        if(duplicatePracticeList.size() == 0 )
        {                     
            try
            {
                insert providerList[0];	
                System.debug('Provider Created');

                try
                {
                //Creating related Profile Code
                    Profile_Code__c profileCode = new Profile_Code__c(
                        Practice__c = practiceId,
                        Referrer__c = referrerId,
                        Provider__c = providerList[0].Id,
                        Description__c = sourceDataRecord.Description__c,
                        External_Code__c = sourceDataRecord.Name
                    );
                    
                    insert profileCode;
                    //System.debug('Profile Code Created');
                }
                catch(Exception exception1)
                {
                    System.debug('Exception occured while creating new Profile_Code__c');
                    System.debug('Message-'+exception1.getMessage());
                }
                return providerList[0];
            }
            catch(Exception exception1)
            {
                System.debug('Exception occured while creating new Provider__c');
                System.debug('Message-'+exception1.getMessage());
                return NULL;
            }
        }
        
        else    
        {
            Provider__c providerRecord = [
                Select 
                    Id,
                    External_Code__c 
                from Provider__c 
                where Id = :duplicatePracticeList[0].Id
            ];
            if(providerRecord.External_Code__c != sourceDataRecord.Name)
            {
                Provider__c newProvider = new Provider__c(
                    Practice__c = practiceId,
                    Referrer__c = referrerId,
                    Description__c = sourceDataRecord.Description__c,
                    External_Code__c = sourceDataRecord.Name
                );
                try
                {
                    insert newProvider;
                    System.debug('Provider Created');
                }
                catch(Exception exception1)
                {
                    System.debug('Exception occured while creating new Provider__c');
                    System.debug('Message-'+exception1.getMessage());
                    return NULL;
                }

                Profile_Code__c profileCode = new Profile_Code__c(
                    Practice__c = practiceId,
                    Referrer__c = referrerId,
                    Provider__c = newProvider.Id,
                    Description__c = sourceDataRecord.Description__c,
                    External_Code__c = sourceDataRecord.Name
                );
                
                try
                {
                    insert profileCode;
                    return newProvider;
                }
                catch(Exception exception1)
                {
                    System.debug('Exception occured while creating new Profile_Code__c');
                    System.debug('Message-'+exception1.getMessage());
                }
            }

            else
            {
                System.debug('Provider Cannot be Created\nDuplicate Data with Same External Code Exists');
            }
            return NULL;
        }
        //else
        //{
        //    System.debug('Provider Updated');
        //	Provider__c provider2=provider[0];
        //    provider2.Description__c=external.Description__c;
        //    provider2.Practice_Name__c=getPractice(external.Provider_Code__c);
        //    update provider2;
        //    return provider2;
        //}
	}
}