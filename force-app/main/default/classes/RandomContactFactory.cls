public class RandomContactFactory 
{
    public static List<Contact> generateRandomContacts(Integer count,String lname)
    {
        List<Contact> conList=new List<Contact>();
        for(Integer i=0;i<count;i++)
        {
			conList.add(new Contact(FirstName='Test '+i,LastName=lname));
        }
        return conList;
    }
}