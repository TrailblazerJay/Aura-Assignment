@isTest
private class TestProcessExternalData 
{
	// @isTest public static void getSourceDataRecordNotNull()
    // {
    //     Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
    //     insert sd;
    //     Source_Data__c res=ProcessExternalData.getSourceDataRecord(sd.Id);
    //     System.assert(res!=null);
    // }
    
    // @isTest public static void getSourceDataRecordNull()
    // {
    //     Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
    //     Source_Data__c res=ProcessExternalData.getSourceDataRecord(sd.Id);
    //     System.assert(res==null);
    // }

    // @isTest public static void createPracticeIfCase()
    // {
    //     Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
    //     insert sd;
    //     Practice__c pr = ProcessExternalData.createPractice(sd);
    //     System.assert(pr.Id!=NULL);
    // }
    
    // @isTest public static void createPracticeIfCaseCatchBlock()
    // {
    //     Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='',Organisation_Name__c='',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
    //     insert sd;
    //     Practice__c pr = ProcessExternalData.createPractice(sd);
    //     System.assert(pr==NULL);
    // }

    // @isTest public static void createPracticeElseCase()
    // {
    //     Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
    //     insert sd;
    //     Source_Data__c sd1=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org2',Description__c='Desc2',Provider_Code__c='0000000A',Processing_Status__c='Pending');
    //     insert sd1;
    //     Practice__c pr = ProcessExternalData.createPractice(sd);
    //     System.assert(pr.Id!=NULL);
    // }
    
    @isTest public static void createPracticeElseCaseCatchBlock()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Source_Data__c sd1=new Source_Data__c(Name='90002',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Description__c='',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd1;
        Practice__c pr = ProcessExternalData.createPractice(sd);
        System.assert(pr==NULL);
    }
}