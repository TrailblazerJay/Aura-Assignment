public class OrphanDelete 
{
    public List<Practice__c> getOrphanedPractices()
    {
        List<Practice__c> orphanedPractice=[Select Id from Practice__c where Id Not IN (Select Practice__c from Provider__c)];
		return orphanedPractice;
    }
    
    public List<Referrer__c> getOrphanedReferrers()
    {
        List<Referrer__c> orphanedReferrer=[Select Id from Referrer__c where Id Not IN (Select Referrer__c from Provider__c)];
		return orphanedReferrer;
    }
    
    public void Main()
    {
        List<Referrer__c> orphanedReferrer=getOrphanedReferrers();
        List<Practice__c> orphanedPractice=getOrphanedPractices();
        System.debug(orphanedReferrer);
        System.debug(orphanedPractice);
        try
        {
            //create a if condition for empty list
        	if(!orphanedReferrer.isEmpty())
            {delete orphanedReferrer;}
            if(!orphanedPractice.isEmpty())
            {delete orphanedPractice;}
            System.debug('All Orphaned Records Deleted Successfully');
        }
        catch(DMLException dmlException)
        {
            System.debug('Error: '+dmlException.getMessage());
        }
        catch(Exception exception1)
        {
            System.debug('Error: '+exception1.getMessage());
        }
    }
}