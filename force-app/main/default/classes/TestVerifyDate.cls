@isTest
private class TestVerifyDate 
{
	@isTest static void testDate()
    {
     	Date d1=VerifyDate.CheckDates(Date.today(), Date.today().addDays(31));
        System.assertEquals(Date.today().addDays(30), d1 , 'Date didnt matched');
    }
	@isTest static void testDate1()
    {
        Date d1=VerifyDate.CheckDates(Date.today(), Date.today().addDays(20));
        System.assertEquals(Date.today().addDays(20), d1);
    }
    @isTest static void testDate2()
    {
        Date d1=VerifyDate.CheckDates(Date.today(), Date.today());
        System.assertEquals(Date.today(), d1);
    }
}