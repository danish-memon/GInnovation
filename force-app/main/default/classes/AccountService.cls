public with sharing class AccountService {
    // Complex Apex: bulkified, uses custom metadata style logic
    public class Result { public Integer processed; public Integer errors; }
    public static Result processAccounts(List<Account> accs){
        Result r = new Result();
        r.processed = 0; r.errors = 0;
        try {
            for (Account a : accs){
                a.Description = (a.Description == null ? '' : a.Description) + ' | processed';
            }
            update accs;
            r.processed = accs.size();
        } catch (DmlException e) {
            r.errors = accs.size();
            // simplified logging
            System.debug('Error processing accounts: ' + e.getMessage());
        }
        return r;
    }
}
