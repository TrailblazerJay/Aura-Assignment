@isTest
public class TestFactoryProcessExternalData 
{
    public static List<Source_Data__c> createMultipleSourceData()
    {
        List<Source_Data__c> sourceDataList=new List<Source_Data__c>();
        List<Practice__c> practiceList=new List<Practice__c>();
        List<Referrer__c> referrerList=new List<Referrer__c>();
        List<Referral__c> referralList=new List<Referral__c>();
        List<Invoice__c> invoiceList=new List<Invoice__c>();
        
        try
        {
            for(Integer i=0;i<3;i++)
            {
                sourceDataList.add(new Source_Data__c(Name='9000'+i,First_Name__c='Fname'+i,Last_Name__c='Lname'+i,Organisation_Name__c='Org'+i,Email__c='org'+i+'@gmail.com',Referrer_Email__c='lname'+i+'@gmail.com',Description__c='Desc'+i,Provider_Code__c='0000000A',Processing_Status__c='Pending'));
            }
            insert sourceDataList;
            
            for(Source_Data__c sd:sourceDataList)
            {
                practiceList.add(ProcessExternalData.createPractice(sd));
                referrerList.add(ProcessExternalData.createReferrer(sd));
            }
            insert practiceList;
            insert referrerList;
            practiceList = [Select Id,External_Code__c from Practice__c where External_Code__c IN ('90001','90002','90003')];
            referrerList = [Select Id,External_Code__c from Referrer__c where External_Code__c IN ('90001','90002','90003')];
            for(Integer i=0;i<3;i++)
            {
                referralList.add(new Referral__c(Practice__c=practiceList[i].Id,Referrer__c=referrerList[i].Id));
                invoiceList.add(new Invoice__c(Practice__c=practiceList[i].Id,Referrer__c=referrerList[i].Id,Amount__c=1000));
            }
            insert referralList;
            insert invoiceList;
            return sourceDataList;
        }
        catch(Exception exception1)
        {
            System.debug(exception1.getMessage());
            return NULL;
        }
    }
    
    @isTest(SeeAllData=true) public static void getPracticeIds()
    {
        List<String> idList=new List<String>{'a035j000003ytUqAAI','a035j000003ytBQAAY','a035j000003ytisAAA'};
        
    }
}
