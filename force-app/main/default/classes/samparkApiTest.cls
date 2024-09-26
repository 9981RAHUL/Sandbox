@IsTest
public class samparkApiTest {
     
   @IsTest static void getStatusTest(){
        Case caseTest = new Case();
        caseTest.Bucket__c ='In Transit';
        caseTest.Status ='New';
        caseTest.SuppliedPhone='9131702471';
        caseTest.SuppliedEmail ='nazeem@gmail.com';
        insert caseTest; 
   
        RestRequest request = new RestRequest();
        request.requestUri ='https://test.salesforce.com/services/apexrest/sampark/' + caseTest.CaseNumber + '/mobile/' + caseTest.SuppliedPhone + '/' ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        case returnedCase = SamparkApi.getStatus();
       system.debug('case name'+returnedCase.status);
        System.assert(returnedCase != null);
       
       
    }
    
}