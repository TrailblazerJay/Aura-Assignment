public class AsyncExecutionExample implements Queueable {
  
    public void execute(QueueableContext context){
        Account a = new Account(Name = 'QueueableAccount1');
        try{
        insert a;
        system.debug('inside try');
        }
        catch(Exception e){
            system.debug('Exception occured'+e.getMessage());
        }
    }
    
}