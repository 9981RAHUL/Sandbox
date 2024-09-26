public with sharing class caseCheckData {

    @AuraEnabled (cacheable=true)
    public static List<Case> findCaseData(String recordid){
    
        try {
            system.debug('Hello Apex data' + recordid);
            List<Case> CaseList=[select SuppliedEmail from Case where id=:recordid limit 1];
            
            String emailid;
            for(Case caseRecord: CaseList){
            //    if (!String.isBlank(caseRecord.SuppliedEmail)) {
                   if(caseRecord.SuppliedEmail == null){
System.debug('===-----==== null');
              
                  }
                 else {
                    emailid=caseRecord.SuppliedEmail;
                    }   
            }
              
            System.debug('EMAILID '+ emailid);
            
            return [Select Id, CaseNumber,SuppliedEmail,Status from Case where SuppliedEmail=: emailid and SuppliedEmail !=null ];
        
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}