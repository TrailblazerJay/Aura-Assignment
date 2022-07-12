@isTest
public class TestProcessExternalData 
{
	@isTest public static void getSourceDataRecordNotNull()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Source_Data__c res=ProcessExternalData.getSourceDataRecord(sd.Id);
        System.assert(res!=null);
    }
    
    @isTest public static void getSourceDataRecordNull()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        Source_Data__c res=ProcessExternalData.getSourceDataRecord(sd.Id);
        System.assert(res==null);
    }

    @isTest public static void createPracticeIfCase()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c pr = ProcessExternalData.createPractice(sd);
        System.assert(pr.Id!=NULL);
    }
    
    @isTest public static void createPracticeIfCaseCatchBlock()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='',Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c pr = ProcessExternalData.createPractice(sd);
        System.assert(pr==NULL);
    }

    @isTest public static void createPracticeElseCase()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Source_Data__c sd1=new Source_Data__c(Name='90002',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd1;
        Practice__c pr = ProcessExternalData.createPractice(sd);
        Practice__c pr1 = ProcessExternalData.createPractice(sd1);
        System.assert(pr1.Id!=NULL);
    }

    @isTest public static void createPracticeElseCaseCatchBlock()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Source_Data__c sd1=new Source_Data__c(Name='90002',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd1;
        Practice__c pr = ProcessExternalData.createPractice(sd);
        Practice__c pr1 = ProcessExternalData.createPractice(sd1);
        System.assert(pr1==NULL);
    }

    @isTest public static void createReferrerIfCase()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Referrer__c rf = ProcessExternalData.createReferrer(sd);
        System.assert(rf.Id!=NULL);
    }
    
    @isTest public static void createReferrerIfCaseCatchBlock()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Referrer__c rf = ProcessExternalData.createReferrer(sd);
        System.assert(rf==NULL);
    }
    
    @isTest public static void createReferrerElseIfCase()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Source_Data__c sd1=new Source_Data__c(Name='90002',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd1;
        Referrer__c rf = ProcessExternalData.createReferrer(sd);
        Referrer__c rf1 = ProcessExternalData.createReferrer(sd1);
        System.assert(rf1.Id!=NULL);
    }

    @isTest public static void createReferrerElseCaseCatchBlock()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Source_Data__c sd1=new Source_Data__c(Name='90002',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd1;
        Referrer__c rf = ProcessExternalData.createReferrer(sd);
        Referrer__c rf1 = ProcessExternalData.createReferrer(sd1);
        System.assert(rf1==NULL);
    }

    @isTest public static void getPracticeADF()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        String practiceId = ProcessExternalData.getPractice(sd.Provider_Code__c);
        System.assertEquals('a025j000008VnFXAA0',practiceId);
    }

    @isTest public static void getPracticeDental()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000D',Processing_Status__c='Pending');
        insert sd;
        String practiceId = ProcessExternalData.getPractice(sd.Provider_Code__c);
        System.assertEquals('a025j000008VnFcAAK',practiceId);
    }

    @isTest public static void getPracticeMiscellaneous()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000M',Processing_Status__c='Pending');
        insert sd;
        String practiceId = ProcessExternalData.getPractice(sd.Provider_Code__c);
        System.assertEquals('a025j000008VnFdAAK',practiceId);
    }

    @isTest public static void getPracticeElseCase()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='00000000',Processing_Status__c='Pending');
        insert sd;
        String practiceId = ProcessExternalData.getPractice(sd.Provider_Code__c);
        System.assertEquals('',practiceId);
    }

    @isTest public static void getPracticeLessThan8Chars()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Referrer_Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000',Processing_Status__c='Pending');
        insert sd;
        String practiceId = ProcessExternalData.getPractice(sd.Provider_Code__c);
        System.assertEquals('a025j000008VnFhAAK',practiceId);
    }

    @isTest public static void getDuplicatesTest()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c pr = ProcessExternalData.createPractice(sd);

        List< Practice__c > practiceList = new List< Practice__c >(); 
        
        practiceList.add(new Practice__c(
            Name = sd.Organisation_Name__c,
            Organisation_Name__c = sd.Organisation_Name__c,
            External_Code__c = sd.Name,
            Email__c = sd.Email__c
        ));
        
        Practice__c[] duplicatePracticeList = ProcessExternalData.getDuplicates(practiceList);
        
        System.assert(duplicatePracticeList.size()>0);
    }

    @isTest public static void getDuplicatesTestCatch()
    {
        List< Practice__c > practiceList = new List< Practice__c >(); 
        
        Practice__c[] duplicatePracticeList = ProcessExternalData.getDuplicates(practiceList);
        
        System.assertEquals(duplicatePracticeList,NULL);
    }

    @isTest public static void createProviderTest()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c  pr=ProcessExternalData.createPractice(sd);
        Referrer__c  rf=ProcessExternalData.createReferrer(sd);
        Provider__c pro=ProcessExternalData.createProvider(pr.Id,rf.Id,sd);
        System.assert(pro.Id!=NULL);   
    }

    @isTest public static void createProviderTestCatch()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c  pr=ProcessExternalData.createPractice(sd);
        Referrer__c  rf=ProcessExternalData.createReferrer(sd);
        Provider__c pro=ProcessExternalData.createProvider(pr.Id,rf.Id,sd);
        System.assert(pro==NULL);   
    }

    @isTest public static void createProviderTestDuplicate()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c  pr=ProcessExternalData.createPractice(sd);
        Referrer__c  rf=ProcessExternalData.createReferrer(sd);
        Provider__c pro=ProcessExternalData.createProvider(pr.Id,rf.Id,sd);
        
        Source_Data__c sd1=new Source_Data__c(Name='90002',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd1;
        Practice__c  pr1=ProcessExternalData.createPractice(sd1);
        Referrer__c  rf1=ProcessExternalData.createReferrer(sd1);
        Provider__c pro1=ProcessExternalData.createProvider(pr1.Id,rf1.Id,sd1);
        
        System.assert(pro1.Id!=NULL);   
    }

    @isTest public static void createProviderTestDuplicateCatch()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c  pr=ProcessExternalData.createPractice(sd);
        Referrer__c  rf=ProcessExternalData.createReferrer(sd);
        Provider__c pro=ProcessExternalData.createProvider(pr.Id,rf.Id,sd);
        
        Source_Data__c sd1=new Source_Data__c(Name='90002',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd1;
        Practice__c  pr1=ProcessExternalData.createPractice(sd1);
        Referrer__c  rf1=ProcessExternalData.createReferrer(sd1);
        Provider__c pro1=ProcessExternalData.createProvider(pr1.Id,rf1.Id,sd1);
        
        System.assert(pro1==NULL);   
    }

    @isTest public static void createProviderTestElseDuplicate()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c  pr=ProcessExternalData.createPractice(sd);
        Referrer__c  rf=ProcessExternalData.createReferrer(sd);
        Provider__c pro=ProcessExternalData.createProvider(pr.Id,rf.Id,sd);
        
        Source_Data__c sd1=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd1;
        Practice__c  pr1=ProcessExternalData.createPractice(sd1);
        Referrer__c  rf1=ProcessExternalData.createReferrer(sd1);
        Provider__c pro1=ProcessExternalData.createProvider(pr1.Id,rf1.Id,sd1);
        
        System.assert(pro1==NULL);
    }

    @isTest public static void updateTotalRevenueAndReferralCountReferrer()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c  pr=ProcessExternalData.createPractice(sd);
        Referrer__c  rf=ProcessExternalData.createReferrer(sd);
        
        Referral__c ref=new Referral__c(Practice__c=pr.Id,Referrer__c=rf.Id);
        insert ref;

        Invoice__c inv=new Invoice__c(Practice__c=pr.Id,Referrer__c=rf.Id,Amount__c=1000);
        insert inv;
        
        ProcessExternalData.updateTotalRevenueAndReferralCount(rf.Id);
        Referrer__c ref1=[Select Id,Count_Referral__c,Total_Revenue__c from Referrer__c where Id=:rf.Id];
        System.assert(ref1.Count_Referral__c==1 && ref1.Total_Revenue__c==1000);
    }

    @isTest public static void updateTotalRevenueAndReferralCountReferrerCatch()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        
        Practice__c  pr=ProcessExternalData.createPractice(sd);
        Referrer__c  rf=ProcessExternalData.createReferrer(sd);
        
        String message=ProcessExternalData.updateTotalRevenueAndReferralCount(sd.Id);
        System.assert(message==NULL);
    }

    @isTest public static void updateTotalRevenueAndReferralCountPractice()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        Practice__c  pr=ProcessExternalData.createPractice(sd);
        Referrer__c  rf=ProcessExternalData.createReferrer(sd);
        
        Referral__c ref=new Referral__c(Practice__c=pr.Id,Referrer__c=rf.Id);
        insert ref;

        Invoice__c inv=new Invoice__c(Practice__c=pr.Id,Referrer__c=rf.Id,Amount__c=1000);
        insert inv;
        
        ProcessExternalData.updateTotalRevenueAndReferralCount(pr.Id);
        Practice__c pr1=[Select Id,Count_Referral__c,Total_Revenue__c from Practice__c where Id=:pr.Id];
        System.assert(pr1.Count_Referral__c==1 && pr1.Total_Revenue__c==1000);
    }

    @isTest(SeeAllData=true) public static void updateTotalRevenueAndReferralCountsReferrer()
    {
        List<String> idList=new List<String>{'a035j000003ytUqAAI','a035j000003ytBQAAY','a035j000003ytisAAA'};
        ProcessExternalData.updateTotalRevenueAndReferralCounts(idList);
        Referrer__c[] refList=[Select Id,Count_Referral__c,Total_Revenue__c from Referrer__c where Id IN :idList];
        for(Referrer__c rf:refList)
        {
            System.assert(rf.Count_Referral__c==1 && rf.Total_Revenue__c==1000);
        }
    }

    @isTest(SeeAllData=true) public static void updateTotalRevenueAndReferralCountsReferrerElse()
    {
        List<String> idList=new List<String>{'a035j000003yt8LAAQ'};
        ProcessExternalData.updateTotalRevenueAndReferralCounts(idList);
        Referrer__c[] rfList=[Select Id,Count_Referral__c,Total_Revenue__c from Referrer__c where Id IN :idList];
        for(Referrer__c rf:rfList)
        {
            System.assert(rf.Total_Revenue__c==1000);
        }
    }

    @isTest(SeeAllData=true) public static void updateTotalRevenueAndReferralCountsReferrerCatch()
    {
        List<String> idList=new List<String>{'a035j000003ytixAAA'};
        String message=ProcessExternalData.updateTotalRevenueAndReferralCounts(idList);
        Referrer__c[] rfList=[Select Id,Count_Referral__c,Total_Revenue__c from Referrer__c where Id IN :idList];
        for(Referrer__c rf:rfList)
        {
            System.assert(message.startsWith('Message-'));
        }
    }

    @isTest(SeeAllData=true) public static void updateTotalRevenueAndReferralCountsPractice()
    {
        List<String> idList=new List<String>{'a025j000008M4AVAA0','a025j000008VnJ5AAK','a025j000008M4G4AAK'};
        ProcessExternalData.updateTotalRevenueAndReferralCounts(idList);
        Practice__c[] prList=[Select Id,Count_Referral__c,Total_Revenue__c from Practice__c where Id IN :idList];
        for(Practice__c pr:prList)
        {
            System.assert(pr.Count_Referral__c==1 && pr.Total_Revenue__c==1000);
        }
    }

    @isTest(SeeAllData=true) public static void updateTotalRevenueAndReferralCountsPracticeElse()
    {
        List<String> idList=new List<String>{'a025j0000077b1tAAA'};
        ProcessExternalData.updateTotalRevenueAndReferralCounts(idList);
        Practice__c[] prList=[Select Id,Count_Referral__c,Total_Revenue__c from Practice__c where Id IN :idList];
        for(Practice__c pr:prList)
        {
            System.assert(pr.Total_Revenue__c==1000);
        }
    }

    @isTest(SeeAllData=true) public static void updateTotalRevenueAndReferralCountsPracticeCatch()
    {
        List<String> idList=new List<String>{'a025j000008ji6LAAQ'};
        String message=ProcessExternalData.updateTotalRevenueAndReferralCounts(idList);
        Practice__c[] prList=[Select Id,Count_Referral__c,Total_Revenue__c from Practice__c where Id IN :idList];
        for(Practice__c pr:prList)
        {
            System.assert(message.startsWith('Message-'));
        }
    }
    @isTest(SeeAllData=true) public static void updateTotalRevenueAndReferralCountsNULL()
    {
        List<String> idList=new List<String>{'a075j000000dL9tAAE'};
        String message=ProcessExternalData.updateTotalRevenueAndReferralCounts(idList);
        Practice__c[] prList=[Select Id,Count_Referral__c,Total_Revenue__c from Practice__c where Id IN :idList];
        for(Practice__c pr:prList)
        {
            System.assert(message==NULL);
        }
    }

    @isTest public static void mainTest()
    {
        Source_Data__c sd=new Source_Data__c(Name='90001',First_Name__c='Fname1',Last_Name__c='Lname1',Organisation_Name__c='Org1',Email__c='org1@gmail.com',Referrer_Email__c='lname@gmail.com',Description__c='Desc1',Provider_Code__c='0000000A',Processing_Status__c='Pending');
        insert sd;
        String message=ProcessExternalData.Main(sd.Id);
        System.assertEquals(message,'Provider Created');
    }
}