global class LargeAccountBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer totalProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Name FROM Account WHERE AnnualRevenue > 1000000]);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Account> accs = (List<Account>)scope;
        for(Account a : accs){
            a.Description = (a.Description == null ? '' : a.Description) + ' | batch-processed';
        }
        update accs;
        totalProcessed += accs.size();
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Batch finished. processed=' + totalProcessed);
    }
}
