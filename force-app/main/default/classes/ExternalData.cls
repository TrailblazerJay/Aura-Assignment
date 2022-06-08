public class ExternalData
{
    /*
 	//It takes External_Code as input and returns Record   
    public External__c getExternalRecord(String externalCode)
    {
        External__c external = [
            Select Id, Name, First_Name__c, Last_Name__c, Organisation_Name__c, Description__c, Provider_Code__c 
                               FROM External__c where Name = :externalCode];	
        return external;
    }

    //It takes External_Code as input and returns Practice Record else Creates a new Practice Record
    public Practice__c createPractice(External__c external)
    {
        // Create it using duplicate rule
        Practice__c[] duplicatePracticeList=[select Id from Practice__c where External_Code__c = :external.Name];
        //duplicatePracticeList=datacloud.FindDuplicates();
        if(duplicatePracticeList.size() == 0)
    	{                     
            System.debug('Practice Created');
        	Practice__c newPractice=new Practice__c(Name=external.Organisation_Name__c,Organisation_Name__c=external.Organisation_Name__c,External_Code__c=external.Name);
        	insert newPractice;
            return newPractice;
    	}
        else
        {
            System.debug('Practice Updated');
        	Practice__c updatePractice=[Select Organisation_Name__c from Practice__c where Id=:duplicatePracticeList[0].Id];
        	updatePractice.Organisation_Name__c=external.Organisation_Name__c;
            updatePractice.Name=external.Organisation_Name__c;
            update updatePractice;
            return updatePractice;
    	}
    }
    
    //It takes External_Code as input and returns Referrer Record else Creates a new Referrer Record
    public Referrer__c createReferrer(External__c external)
    {
     	Referrer__c[] rf=[Select Id from Referrer__c where External_Code__c=:external.Name];
    	if(rf.size()==0)
    	{                     
            System.debug('Referrer Created');
        	Referrer__c rf1=new Referrer__c(First_Name__c=external.First_Name__c,Name=external.Last_Name__c,External_Code__c=external.Name);
    		insert rf1;
            return rf1;
    	}
        else
        {
            System.debug('Referrer Updated');
        	Referrer__c rf2=[Select Id,First_Name__c,Name from Referrer__c where Id=:rf[0].Id];
        	rf2.First_Name__c=external.First_Name__c;
            rf2.Name=external.Last_Name__c;
            update rf2;
            return rf2;
    	}
    }
    
    //It takes Provider_Code as input and returns Practice based on Provider_Code
    public String getPractice(String providerCode)
    {
        String practice;
        Switch on providerCode.substring(7,8)
        {
            when 'A'
            {
                practice='ADF';
            }
            when 'D'
            {
                practice='Dental';
            }
            when 'M'
            {
                practice='Miscellaneous';
            }
            when ''
            {
                practice='Invalid';
            }
            when else
            {
                practice='Invalid';
            }
        }
        return practice;
    }
    
    //It takes External,Practice,Referrer as input and fetches Provider Record else Creates a new Provider Record
    public Provider__c createProvider(Practice__c pr,Referrer__c rf,External__c external)
    {
        Provider__c[] provider=[Select Id from Provider__c where External_Code__c=:external.Name];
        if(provider.size()==0)
    	{                     
            System.debug('Provider Created');
        	String practiceValue=getPractice(external.Provider_Code__c);
            Provider__c provider1=new Provider__c(Practice__c=pr.Id,Referrer__c=rf.Id,Description__c=external.Description__c,
                                                  Practice_Name__c=practiceValue,External_Code__c=external.Name);
    		insert provider1;
            return provider1;
    	}
        else
        {
            System.debug('Provider Updated');
        	Provider__c provider2=[Select Id,Practice__c,Referrer__c,Description__c,Practice_Name__c 
                                   from Provider__c where Id=:provider[0].Id];
        	provider2.Description__c=external.Description__c;
            //System.debug(getPractice(external.Provider_Code__c));
            provider2.Practice_Name__c=getPractice(external.Provider_Code__c);
            update provider2;
            return provider2;
    	}
	}
     
    public void Main(String externalCode)
    {
        SavePoint savePoint1=Database.setSavepoint();
        //Create a try catch block and rollback all the records created before
        try
        {
        	External__c external=getExternalRecord(externalCode);
        	Practice__c practice=createPractice(external);
        	Referrer__c referrer=createReferrer(external);
        	if(practice!=NULL && referrer!=NULL && external!=NULL)
        	{
            	Provider__c provider=createProvider(practice,referrer,external);
        	}
        	else
        	{
            	System.debug('Practice | Referrer | External Record is missing');
        	}
        }
        catch(DMLException dmlException)
        {
            System.debug(dmlException.getMessage());
            Database.rollback(savePoint1);
        }
        catch(Exception exception1)
        {
            System.debug(exception1.getMessage());
            Database.rollback(savePoint1);
        }
    }
*/
}