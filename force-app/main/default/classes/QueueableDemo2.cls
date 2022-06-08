public with sharing class QueueableDemo2 implements Queueable
{
    public void execute(QueueableContext qc) {
        System.debug('Queueable Async Apex 2');
        QueueableDemo3 qd3=new QueueableDemo3();
        String jobId=System.enqueueJob(qd3);
        Contact c=new Contact(FirstName='Jay2',LastName='Malde2',Phone='1');
        insert c;
    }
}