public with sharing class CaseService {
    public static void closeCases(Set<ID> caseIds, String closeReason) {
    
        // Validate parameters
        if(caseIds == null || caseIds.size() == 0)
            throw new CaseServiceException('Cases not specified.');
        if(closeReason == null || String.isEmpty(closeReason))
            throw new CaseServiceException('closeReason is not specified.');
        
        List<Case> cases = [select reason from Case where Id in :caseIds];
        
        for (Case c : cases) {
            c.reason = closeReason;
            c.status = 'Closed';
        }
        
        // Update the database
        SavePoint sp = Database.setSavePoint();
        try {
            update cases;
        } catch (Exception e) {
            // Rollback
            Database.rollback(sp);
            // Throw exception on to caller
            throw e;
        }       
    }
    public class CaseServiceException extends Exception {} 
}