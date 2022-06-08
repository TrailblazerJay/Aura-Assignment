trigger OpportunityQuoteLineItems on Opportunity (after insert) 
{
    /*
    if(Trigger.new[0].StageName=='Proposal/Price Quote')
    {
        Quote quote1=new Quote(Name=Trigger.new[0].Name,OpportunityId=Trigger.new[0].Id);
        insert quote1;
    }
    */
}