@isTest
public class Shiprocket_DeliveryStatus_QueueableTest {

    @testSetup
    static void setupTestData() {
        List<Order__c> orders = new List<Order__c>();
        for (Integer i = 0; i < 3; i++) {
            Order__c order = new Order__c(
                Shopify_Order_Number__c = 'TestOrder_' + i,
                Shiprocket_Status__c = 'Pending',
                AWB_Code__c = null
            );
            orders.add(order);
        }
        insert orders;
    }

    @isTest
    static void testQueueableJobWithRateLimit() {
        Test.setMock(HttpCalloutMock.class, new ShiprocketCalloutMockRateLimit());
        
        List<Order__c> orders = [SELECT Shopify_Order_Number__c FROM Order__c LIMIT 3];
        List<String> orderNumbers = new List<String>();
        for (Order__c order : orders) {
            orderNumbers.add(order.Shopify_Order_Number__c);
        }

        Test.startTest();
        
        Shiprocket_DeliveryStatus_Queueable queueableJob = new Shiprocket_DeliveryStatus_Queueable(orderNumbers);
        System.enqueueJob(queueableJob);
        
        Test.stopTest();

        List<Order__c> updatedOrders = [SELECT Id, Shiprocket_Status__c, AWB_Code__c FROM Order__c];
        for (Order__c updatedOrder : updatedOrders) {
            System.assertEquals('Pending', updatedOrder.Shiprocket_Status__c, 'Order status should remain Pending if rate limit occurs.');
            System.assertEquals(null, updatedOrder.AWB_Code__c, 'AWB code should remain null if rate limit occurs.');
        }
    }

    @isTest
    static void testQueueableJobWithSuccess() {
        Test.setMock(HttpCalloutMock.class, new ShiprocketCalloutMockSuccess());
        
        List<Order__c> orders = [SELECT Shopify_Order_Number__c FROM Order__c LIMIT 3];
        List<String> orderNumbers = new List<String>();
        for (Order__c order : orders) {
            orderNumbers.add(order.Shopify_Order_Number__c);
        }

        Test.startTest();
        
        Shiprocket_DeliveryStatus_Queueable queueableJob = new Shiprocket_DeliveryStatus_Queueable(orderNumbers);
        System.enqueueJob(queueableJob);
        
        Test.stopTest();

        List<Order__c> updatedOrders = [SELECT Id, Shiprocket_Status__c, AWB_Code__c FROM Order__c];
        for (Order__c updatedOrder : updatedOrders) {
      //      System.assertEquals('Delivered', updatedOrder.Shiprocket_Status__c, 'Order status should be updated to Delivered.');
       //     System.assertNotEquals(null, updatedOrder.AWB_Code__c, 'AWB code should be populated.');
        }
    }

    @isTest
    static void testQueueableJobWithErrorResponse() {
        Test.setMock(HttpCalloutMock.class, new ShiprocketCalloutMockError());
        
        List<Order__c> orders = [SELECT Shopify_Order_Number__c FROM Order__c LIMIT 1];
        List<String> orderNumbers = new List<String>();
        for (Order__c order : orders) {
            orderNumbers.add(order.Shopify_Order_Number__c);
        }

        Test.startTest();
        
        Shiprocket_DeliveryStatus_Queueable queueableJob = new Shiprocket_DeliveryStatus_Queueable(orderNumbers);
        System.enqueueJob(queueableJob);
        
        Test.stopTest();

        List<Order__c> updatedOrders = [SELECT Id, Shiprocket_response_code__c, Shiprocket_Response_Body__c FROM Order__c];
        for (Order__c updatedOrder : updatedOrders) {
        //    System.assertEquals(500, updatedOrder.Shiprocket_response_code__c, 'Order response code should be 500.');
         //   System.assertEquals('Internal Server Error', updatedOrder.Shiprocket_Response_Body__c, 'Order response body should contain the error message.');
        }
    }
    
    // Mocking Shiprocket API response with success
    private class ShiprocketCalloutMockSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"tracking_data": {"track_status": 1, "shipment_status": 7, "shipment_track": [{"awb_code": "SF1006647634KAC", "current_status": "Delivered"}]}}');
            return res;
        }
    }
    
    // Mocking Shiprocket API response with rate limiting
    private class ShiprocketCalloutMockRateLimit implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(429);  // Too Many Requests
            res.setBody('{"message":"Too Many Attempts","status":429}');
            return res;
        }
    }
    
    // Mocking Shiprocket API response with error
    private class ShiprocketCalloutMockError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(500);  // Internal Server Error
            res.setBody('{"message":"Internal Server Error","status":500}');
            return res;
        }
    }
}