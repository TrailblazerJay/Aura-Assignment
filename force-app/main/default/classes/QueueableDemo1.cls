public with sharing class QueueableDemo1 implements Queueable
{
    public void execute(QueueableContext qc) {
        System.debug('Queueable Async Apex 1');
        QueueableDemo2 qd2=new QueueableDemo2();
        String jobId=System.enqueueJob(qd2);
        Contact c=new Contact(FirstName='Jay1',LastName='Malde1',Phone='1');
        insert c;
    }
}