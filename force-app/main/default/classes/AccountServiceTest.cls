@isTest
private class AccountServiceTest {
    static testMethod void testProcess(){
        Account a = new Account(Name='T1');
        insert a;
        Test.startTest();
        AccountService.Result r = AccountService.processAccounts(new List<Account>{a});
        Test.stopTest();
        System.assertEquals(1, r.processed);
    }
}
