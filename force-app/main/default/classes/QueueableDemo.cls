public class QueueableDemo implements Queueable
{
    public void execute(QueueableContext qc) {
        System.debug('Queueable Async Apex');
        // QueueableDemo1 qd1=new QueueableDemo1();
        // String jobId=System.enqueueJob(qd1);
        Contact c=new Contact(FirstName='Jay0',LastName='Malde0',Phone='1');
        insert c;
    }
}