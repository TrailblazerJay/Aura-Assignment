public with sharing class QueueableDemo4 implements Queueable
{
    public void execute(QueueableContext qc) {
        System.debug('Queueable Async Apex 4');
        Contact c=new Contact(FirstName='Jay4',LastName='Malde4',Phone='1');
        insert c;
        Contact c1=new Contact(FirstName='Jay5',LastName='Malde5');
        insert c1;
    }
}