public with sharing class AccountProcessor1 {
    public AccountProcessor1(List<Account> listAccount) {
        System.debug(listAccount);
        for(Account acc:listAccount)
        {
            acc.Industry='Apparel';
        }
        System.debug(listAccount);
        // update listAccount;
        
    }
}