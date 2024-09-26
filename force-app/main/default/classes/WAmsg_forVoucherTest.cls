@isTest
public class WAmsg_forVoucherTest {
    @isTest
    static void testSendSMSforOrders() {
        // Query WhatsAppData records for the test case
        List<whatsAppData__mdt> whatsappSettings = [SELECT DeveloperName, MasterLabel, Value__c, Enable__c FROM whatsAppData__mdt ];

        // Ensure required metadata records exist
        System.assertNotEquals(0, whatsappSettings.size(), 'No WhatsAppData records found for TestCase1');

        // Create test person account and order
        Account testAccount = new Account(
            FirstName = 'Test', 
            LastName = 'Person', 
            PersonMobilePhone = '1234567890',
            PersonEmail = 'test@example.com',
            RecordTypeId = '0122w0000002noJAAQ',
            ShippingCountry = 'India',
            ShippingState = 'Gujarat',
            ShippingStreet = 'dummy street',
            ShippingCity='SURAT',
            ShippingPostalCode = '395007'
        );
        insert testAccount;
        Order__c testOrder = new Order__c(Account__c = testAccount.Id);
        insert testOrder;

        // Test execution
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        WAmsg_forVoucher.sendSMSforOrders();
        Test.stopTest();
    }

    // Mock HTTP callout class
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"errorDetail":null,"msgResponse":[{"to":"+919826229899","msgId":"290736230","errorDetail":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}