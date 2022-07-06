@isTest
private class TestRestrictContactByName 
{
    @isTest static void testContact()
    {
        Contact con=new Contact(FirstName='Jay',LastName='INVALIDNAME');
        
        Test.startTest();
        Database.SaveResult res=Database.insert(con,false);
        Test.stopTest();
        
        System.assert(!res.isSuccess());
        System.assert(res.getErrors().size()>0);
        System.assertEquals('The Last Name INVALIDNAME is not allowed for DML',res.getErrors()[0].getMessage());
    }
}