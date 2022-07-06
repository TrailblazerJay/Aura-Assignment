public without sharing class LinkDocumentBatch implements Database.Batchable<ContentVersion> 
{
    Id contentVersionId;
    Id entityId;
    public LinkDocumentBatch(Id documentId,Id entityId)
    {
        this.contentVersionId=documentId;
        this.entityId=entityId;
    }
    public Iterable<contentVersion> start(Database.BatchableContext bc)
    {
        return [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionId];
    }
    public void execute(Database.BatchableContext bc,List<ContentVersion> listVersion)
    {
        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:listVersion[0].Id].ContentDocumentId;
        ContentDocumentLink cdv=new ContentDocumentLink(LinkedEntityId=entityId,ContentDocumentId=contentDocId,shareType = 'V',Visibility = 'AllUsers' );
        insert cdv;
    }
    public void finish(Database.BatchableContext bc)
    {

    }
}