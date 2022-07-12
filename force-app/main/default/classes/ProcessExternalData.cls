public class ProcessExternalData
{
 	//It takes External_Code as input and returns Record  
    public static Source_Data__c getSourceDataRecord(Id sourceDataId)
    {
        Source_Data__c[] sourceData=[
            Select 
                Id, 
                Name,
                First_Name__c,
                Last_Name__c,
                Organisation_Name__c,
                Description__c,
                Provider_Code__c,
                Processing_Status__c,
                Email__c,
                Referrer_Email__C
            FROM Source_Data__c
            where Id = :sourceDataId
        ];

        if(sourceData.size()!=0)
        {    
            return sourceData[0];
        }
        else
        {
            System.debug('Please Enter Valid Source Code Id');
            return NULL;
        }
    }

    //It takes External_Code as input and returns Practice Record else Creates a new Practice Record
    public static Practice__c createPractice(Source_Data__c sourceData)
    {
        List< Practice__c > practiceList = new List< Practice__c >(); 
        
        practiceList.add(new Practice__c(
            Name = sourceData.Organisation_Name__c,
            Organisation_Name__c = sourceData.Organisation_Name__c,
            External_Code__c = sourceData.Name,
            Email__c = sourceData.Email__c
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
                Organisation_Name__c = sourceData.Organisation_Name__c,
                Email__c = sourceData.Email__c
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
                System.debug('Message1-'+exception1.getMessage());
                return NULL;
            }
        }
    }
    
    //It takes External_Code as input and returns Referrer Record else Creates a new Referrer Record
    public static Referrer__c createReferrer(Source_Data__c sourceData)
    {
     	List< Referrer__c > referrerList = new List< Referrer__c >();
        
        referrerList.add(new Referrer__c( 
            First_Name__c = sourceData.First_Name__c,
            Name = sourceData.Last_Name__c,
            External_Code__c = sourceData.Name,
            Email__c = sourceData.Referrer_Email__c
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
                Name = sourceData.Last_Name__c,
                Email__c = sourceData.Referrer_Email__c
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
            return NULL;
        }
        return duplicateRecord;
    }
    
    //It takes External,Practice,Referrer as input and fetches Provider Record else Creates a new Provider Record
    public static Provider__c createProvider( Id practiceId, Id referrerId, Source_Data__c sourceDataRecord)
    {
        List< Provider__c > providerList = new List< Provider__c >();

        providerList.add(new Provider__c(
            Practice__c = practiceId,
            Referrer__c = referrerId,
            Description__c = sourceDataRecord.Description__c,
            External_Code__c = sourceDataRecord.Name
        ));
        
        //Checking for duplicates
        Provider__c[] duplicatePracticeList = [Select Id,Practice__c,Referrer__c from Provider__c where Practice__c=:practiceId AND Referrer__c=:referrerId];

        if(duplicatePracticeList.size() == 0 )
        {                     
            try
            {
                insert providerList[0];	
                System.debug('Provider Created');
                
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

                    Profile_Code__c profileCode = new Profile_Code__c(
                        Practice__c = practiceId,
                        Referrer__c = referrerId,
                        Provider__c = newProvider.Id,
                        Description__c = sourceDataRecord.Description__c,
                        External_Code__c = sourceDataRecord.Name        
                    );

                    insert profileCode;
                    return newProvider;        
                }
                catch(Exception exception1)
                {
                    System.debug('Exception occured while creating new Provider__c');
                    System.debug('Message-'+exception1.getMessage());
                    return NULL;
                }
            }
            else if(providerRecord.External_Code__c == sourceDataRecord.Name)
            {
                System.debug('Provider Cannot be Created\nDuplicate Data with Same External Code Exists');
                return NULL;
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
    
    //4a Takes recordId and updates Total Revenue & Referral Count fields of Referrer or Pratice
    public static String updateTotalRevenueAndReferralCount(String recordId)
    {
        Schema.DescribeSObjectResult[] describeObject = Schema.describeSObjects(new String[]{'Practice__c','Referrer__c'});
        
        if(recordId.substring(0,3) == describeObject[1].getKeyPrefix())
        {
            Integer countReferrals = [
                Select count() 
                from Referral__c 
                where Referrer__c = :recordId
            ];

            Decimal totalAmount = 0;
            AggregateResult[] aggregateResultReferrer=[
                Select sum(Amount__c) 
                from Invoice__c 
                where Referrer__c=:recordId group by Referrer__c
            ];
            if(!aggregateResultReferrer.isEmpty())
            {
                totalAmount = (Decimal)aggregateResultReferrer[0].get('expr0');
            }
            
            Referrer__c referrer=new Referrer__c(
                Id = recordId,
                Total_Revenue__c = totalAmount,
                Count_Referral__c = countReferrals
            );
            
            try
            {
                update referrer;
                System.debug('Referrer Updated');   
                return 'Referrer Updated';   
            }
            catch(DMLException dmlException)
            {
                System.debug('Error-'+dmlException.getMessage());
                return 'Error-'+dmlException.getMessage();
            }
        }

        else if(recordId.substring(0,3) == describeObject[0].getKeyPrefix())
        {
            Integer countPractices=[
                Select count() 
                from Referral__c 
                where Practice__c=:recordId
            ];
            
            Decimal totalAmount = 0;
            AggregateResult[] aggregateResultPractice=[
                Select sum(Amount__c) 
                from Invoice__c 
                where Practice__c=:recordId group by Practice__c
            ];

            if(!aggregateResultPractice.isEmpty())
            {
                totalAmount = (Decimal)aggregateResultPractice[0].get('expr0');
            }
            
            Practice__c practice = new Practice__c(
                Id = recordId,
                Total_Revenue__c = totalAmount,
                Count_Referral__c = countPractices
            );
            
            try
            {
                update practice;
                System.debug('Practice Updated');
                return 'Practice Updated';
            }
            catch(DMLException dmlException)
            {
                System.debug('Error-'+dmlException.getMessage());
                return 'Error-'+dmlException.getMessage();
            }
        }
        return NULL;
	}
    
    //4b Takes recordId and updates Total Revenue & Referral Count fields of Referrer or Pratice
    public static String updateTotalRevenueAndReferralCounts( List<Id> recordIds )
    {
        Schema.DescribeSObjectResult[] describeObject = Schema.describeSObjects(new String[]{'Practice__c','Referrer__c'});
        if(String.valueOf(recordIds[0].getSObjectType()) == describeObject[0].getName())
        {
            //Use single map instead of list
            Map<Id,Practice__c> practiceMapList = new Map<Id,Practice__c>();

            //List<Id> recordIds=new List<Id>{'a025j000008JQv0AAG','a025j000008JRBSAA4','a025j000008M43KAAS'};
            for(AggregateResult aggregateResultPractice:[
                Select Practice__c,Count(Id) 
                from Referral__c 
                where Practice__c IN :recordIds group by Practice__c
            ])
            {
                practiceMapList.put(
                    (Id) aggregateResultPractice.get('Practice__c') ,
                    new Practice__c(
                        Id = (Id) aggregateResultPractice.get('Practice__c'),
                        Count_Referral__c= (Decimal) aggregateResultPractice.get('expr0')
                    )
                );
            }

            for(AggregateResult aggregateResultPractice:[
                Select Practice__c,sum(Amount__c) 
                from Invoice__c 
                where Practice__c IN :recordIds group by Practice__c
            ])
            {
                if(practiceMapList.containsKey( (Id) aggregateResultPractice.get('Practice__c') ) )
                {
                    practiceMapList.get( (Id) aggregateResultPractice.get('Practice__c'))
                        .Total_Revenue__c = (Decimal) aggregateResultPractice.get('expr0');
                }
                else
                {
                    practiceMapList.put( (Id) aggregateResultPractice.get('Practice__c'),
                        new Practice__c(
                            Id= (Id) aggregateResultPractice.get('Practice__c'),
                            Total_Revenue__c= (Decimal) aggregateResultPractice.get('expr0')
                        )
                    );
                }
            }

            try
            {
                update practiceMapList.values();
                System.debug('Revenue & Referral Count Updated for Practice__c');
                return 'Revenue & Referral Count Updated for Practice__c';
            }
            catch(Exception exception1)
            {
                System.debug('Message-'+exception1.getMessage());
                return 'Message-'+exception1.getMessage();
            }
        }
        else if(String.valueOf(recordIds[0].getSObjectType()) == describeObject[1].getName())
        {
            //List<Id> recordIds=new List<Id>{'a035j0000037HFyAAM','a035j0000037HFtAAM','a035j0000037I7cAAE'};
            Map<Id,Referrer__c> referrerMapList = new Map<Id,Referrer__c>();

            for(AggregateResult aggregateResultReferrer:[
                Select Referrer__c,count(Id) 
                from Referral__c
                where Referrer__c IN :recordIds group by Referrer__c
            ])
            {
                referrerMapList.put(
                    (Id) aggregateResultReferrer.get('Referrer__c'),
                    new Referrer__c(
                        Id= (Id) aggregateResultReferrer.get('Referrer__c'),
                        Count_Referral__c = (Decimal) aggregateResultReferrer.get('expr0')
                    )
                );
            }

            for(AggregateResult aggregateResultReferrer:[
                Select Referrer__c,sum(Amount__c) 
                from Invoice__c 
                where Referrer__c IN :recordIds group by Referrer__c
            ])
            {
                if(referrerMapList.containsKey( (Id) aggregateResultReferrer.get('Referrer__c')))
                {
                    referrerMapList.get( (Id) aggregateResultReferrer.get('Referrer__c'))
                        .Total_Revenue__c= (Decimal) aggregateResultReferrer.get('expr0');
                }else
                {
                    referrerMapList.put( (Id) aggregateResultReferrer.get('Referrer__c'),
                        new Referrer__c( 
                            Id = (Id) aggregateResultReferrer.get('Referrer__c'),
                            Total_Revenue__c = (Decimal) aggregateResultReferrer.get('expr0')
                        )
                    );
                }
            }

            try
            {
                update referrerMapList.values();
                System.debug('Revenue & Referral Count Updated for Referrer__c');
                return 'Revenue & Referral Count Updated for Referrer__c';
            }
            catch(Exception exception1)
            {
                System.debug('Message-'+exception1.getMessage());
                return 'Message-'+exception1.getMessage();
            }
        }
        return NULL;
	}
    
    public static String Main(Id sourceDataId)
    {
        Source_Data__c sourceDataRecord = getSourceDataRecord(sourceDataId);
        if(sourceDataRecord.Processing_Status__c != 'Processed')
        {
            if(sourceDataRecord == NULL){
                return 'No Source Data';
            }
            
            String practiceId = getPractice(sourceDataRecord.Provider_Code__c);
            
            if(practiceId == '')
            {
                Practice__c practiceData = createPractice(sourceDataRecord);
                if(practiceData == NULL){
                    return 'No Practice';
                }
                practiceId = practiceData.Id;
            }
            
            Referrer__c referrer = createReferrer(sourceDataRecord);
            if(referrer == NULL){
                return 'No Referrer';
            }

            Provider__c provider = createProvider(practiceId, referrer.Id, sourceDataRecord);       
            if(provider == NULL){
                return 'No Provider';
            }

            sourceDataRecord.Processing_Status__c = 'Processed';
            try
            {
                update sourceDataRecord;
                return 'Provider Created';
            }
            catch(Exception e)
            {
                System.debug('External Updation Failed');
                System.debug(e.getMessage());
                return 'Message-'+e.getMessage();
            }
        }
        else if(sourceDataRecord.Processing_Status__c != 'Duplicate Discarded') 
        {
            System.debug('Duplicate Data cannot be processed');
            return 'Duplicate Discarded';
        }
        System.debug('Data is Already Processed');
        return 'Already Processed';
    }
}