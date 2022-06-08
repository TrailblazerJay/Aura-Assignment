Trigger LeadConvert on Lead (after update) 
{
    if(RecursiveTriggerClass.isCalled)
    {
        RecursiveTriggerClass.isCalled=False;
        Lead[] listLeads=[Select Id,IsConverted,ConvertedAccountId,ConvertedContactId from Lead where Id in :Trigger.newMap.keySet()];
        for(Lead l:listLeads)
        {
            if(l.IsConverted)
            {
                Database.LeadConvert lc=new Database.LeadConvert();
                lc.setLeadId(l.Id);
                System.debug(lc.getAccountId());
                System.debug(lc.getContactId());
            }
            l.LastName='M';
        }  
        update listLeads;
    }
}