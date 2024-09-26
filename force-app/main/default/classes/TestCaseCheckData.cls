@isTest
public class TestCaseCheckData {
    @isTest
    public static void caseMethod(){
     
        String recordid;
        Case cs = new Case();
        cs.Status ='Open';
        cs.SuppliedEmail ='arpit@gmail.com';
        insert cs;
         recordid = cs.Id;
        test.startTest();
            
       try
        {
            caseCheckData.findCaseData(recordid);
        }catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());  
        }

        test.stopTest();
    }
}