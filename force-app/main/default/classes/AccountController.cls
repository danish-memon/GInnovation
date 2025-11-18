public with sharing class AccountController {
    /**
     * Deprecated compatibility method kept for callers that still call getTopAccounts()
     * It routes to fetchTopAccounts with conservative defaults.
     */
    @AuraEnabled(cacheable=true)
    @Deprecated
    public static List<Account> getTopAccounts() {
        // Previously returned top 10 accounts. Now delegates to new implementation.
        return fetchTopAccounts(0, 10, null);
    }
    /**
     * New, more flexible API:
     * - Accepts minRevenue filter, page size (limit), and optional industry filter.
     * - Returns Id, Name, AnnualRevenue, Industry and OwnerId (new fields).
     * - Enforces Field-Level Security / Object permissions for selected fields via WITH SECURITY_ENFORCED.
     * - Default limit is 20 (was 10 previously).
     *
     * IMPORTANT: Because we added WITH SECURITY_ENFORCED and SELECTed new fields,
     * callers must ensure the running user has FLS/CRUD for Industry and OwnerId; otherwise a QueryException will be thrown.
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchTopAccounts(Integer minRevenue, Integer limitSize, String industry) {
        Integer minRev = (minRevenue == null) ? 0 : minRevenue;
        Integer lim = (limitSize == null || limitSize <= 0) ? 20 : limitSize;
        try {
            // Note: using a bind for industry and allowing null (no industry filter) via OR check
            List<Account> accounts = [
                SELECT Id, Name, AnnualRevenue, Industry, OwnerId
                FROM Account
                WITH SECURITY_ENFORCED
                WHERE AnnualRevenue >= :minRev
                  AND (:industry = NULL OR Industry = :industry)
                ORDER BY AnnualRevenue DESC
                LIMIT :lim
            ];
            return accounts;
        } catch (QueryException qe) {
            // Return a controlled Aura error — front end should handle this gracefully
            throw new AuraHandledException('Account query failed: ' + qe.getMessage());
        } catch (Exception e) {
            // Generic fallback
            throw new AuraHandledException('Unable to fetch accounts: ' + e.getMessage());
        }
    }
}