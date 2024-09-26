public class ResolveCasesController {
  
    @AuraEnabled(cacheable=true)
    public static List<Resolve_Cases2__b> getResolvedCases() {
        return [SELECT Id, Name__c, User__c,Case_Lookup__c, Case_Number__c   /* Add more fields as needed */ FROM Resolve_Cases2__b];
    }
}