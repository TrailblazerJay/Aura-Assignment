public without sharing class SnTrialClass {
    
    public static void performContentInsertion(){
        String s = 'abc';
        ContentVersion cv = new ContentVersion(
            PathOnClient= 'Records as per Filters.csv',
            Title= 'Records as per Filters',
            VersionData=Blob.valueOf(s), 
            IsMajorVersion= true
        );               
        insert cv;
        
        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdv=new ContentDocumentLink(LinkedEntityId='a0M5j000001uCxfEAE',ContentDocumentId=contentDocId,shareType = 'V' );
        insert cdv;
    } 
    
}