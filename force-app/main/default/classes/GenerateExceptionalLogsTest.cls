@isTest
global class GenerateExceptionalLogsTest {
    
    public static HttpResponse getInfoFromExternalService() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://example.com/example/test');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }

	 @isTest static void testCallout() {
        // Set mock callout class 
        DateTime reqSentTime = system.now();
        Test.setMock(HttpCalloutMock.class, new GenerateExceptionalMockCallout());    
         HttpResponse res = GenerateExceptionalLogsTest.getInfoFromExternalService();
         map<string, string> attributeMap = new map<string, string>{'className'=>'ShipRocketApiCallout', 'methodName'=>'CheckServicebility','objectType'=>'Case','recordId'=>'caserec.Id'};
         GenerateExceptionLogs.insertIntegrationLog(new HttpRequest(), res, attributeMap, reqSentTime, reqSentTime);
        GenerateExceptionLogs.insertIntegrationLog(new HttpRequest(), attributeMap, reqSentTime);
    }
    @isTest
    public static void F1ApiTestException(){
         test.startTest(); 
        F1Apicallout.F1caseupdation(null);
        test.stopTest();
    }

}