trigger OpportunityTrigger on Opportunity (before insert,before update,before delete,after insert,after update,after delete,after undelete) 
{
    // if(Trigger.new[0].AccountId!=NULL)
    // {
    //     Integer count=[Select count() from Account where Id=:Trigger.new[0].AccountId AND TYPE='Technology Partner'];
    //     if(count==0)
    //     {
    //         Trigger.new[0].addError('Account Type should be Technology Partner');
    //     }
    // }
    // else{
    //     System.debug('No Account Linked');
    // }
    /*
    System.debug('Opportunity Trigger Called');
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            Trigger.new[0].Amount=10000;
        }
    }
    else
    {
        if(Trigger.isInsert)
        {
            if(RecursiveTriggerClass.isCalled)
            {
                RecursiveTriggerClass.isCalled=FALSE;
                Opportunity opp=new Opportunity(Id=Trigger.new[0].Id,Amount=Trigger.new[0].Amount=2000);
                System.debug('Opp Updated');
                update opp;
            }
        }
    }
    */
}