public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getTopAccounts(){
        return [SELECT Id, Name, AnnualRevenue FROM Account ORDER BY AnnualRevenue DESC LIMIT 10];
    }
}
