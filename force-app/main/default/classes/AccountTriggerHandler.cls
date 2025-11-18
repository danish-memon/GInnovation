public with sharing class AccountTriggerHandler {
    public static void handleBefore(List<Account> newList){
        for(Account a : newList){
            if (a.Name != null && a.Name.length() > 80) a.Name = a.Name.substring(0,80);
        }
    }
}
