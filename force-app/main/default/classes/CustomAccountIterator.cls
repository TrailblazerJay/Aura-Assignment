public class CustomAccountIterator implements Iterator<Account>
{
    private List<Account> accList;
    private Integer index;

    public CustomAccountIterator(List<Account> accountList)
    {
        this.accList=accountList;
        this.index=0;
    }

    public Boolean hasNext()
    {
        return index < accList.size()-1;
    }

    public Account next()
    {
        if(hasNext())
        {
            index++;
            return accList[index];
        }
        else
        {
            throw new NoSuchElementException();
        }
    }
}
//When using iterator in batch does the batch runs after all the records are fetched or one iterator after another