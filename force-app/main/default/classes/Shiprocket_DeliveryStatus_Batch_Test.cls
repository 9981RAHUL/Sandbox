@isTest
public class Shiprocket_DeliveryStatus_Batch_Test {
    @testSetup
    static void setupTestData() {
        // Creating exactly 2 test orders to match the batch size
        List<Order__c> orders = new List<Order__c>();
        for (Integer i = 0; i < 2; i++) {
            Order__c order = new Order__c(
                Shopify_Order_Number__c = 'TestOrder_' + i,
               // Shiprocket_Max_Attempt_Date__c = Date.today(),
                Shiprocket_Status__c = 'Processing'
            );
            orders.add(order);
        }
        insert orders;
    }

    // Mock HTTP callout response
    private class ShiprocketMockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('[{"tracking_data": {"track_status": 1, "shipment_status": 7, "shipment_track": [{"id": 459167096, "awb_code": "SF1006647634KAC", "courier_company_id": 174, "shipment_id": 547479890, "order_id": 549375484, "current_status": "Delivered"}]}}]');
            return res;
        }
    }

/*    @isTest
    static void testBatchExecution() {
        // Test batch start and execution
        Test.startTest();
        
        // Set mock callout
        Test.setMock(HttpCalloutMock.class, new ShiprocketMockHttpResponse());
        
        // Instantiate the batch class and execute it with a batch size of 2 (matching the number of records)
        Shiprocket_DeliveryStatus_Batch batchJob = new Shiprocket_DeliveryStatus_Batch();
        Database.executeBatch(batchJob, 2); // Only 2 records, matching batch size
        
        Test.stopTest();
        
        // Assert that records were processed and updated correctly
        List<Order__c> orders = [SELECT Id, Shiprocket_Status__c, AWB_Code__c FROM Order__c WHERE Shopify_Order_Number__c != null];
        System.assert(orders.size() == 2, 'There should be exactly 2 orders processed.');
        for(Order__c order : orders) {
            System.assertEquals('Delivered', order.Shiprocket_Status__c, 'Order status should be updated to Delivered.');
            System.assertNotEquals(null, order.AWB_Code__c, 'AWB Code should be updated.');
        }
    } */

    @isTest
    static void testBatchWithQueueable() {
        // Test that the batch calls the queueable job

        Test.startTest();
        
        // Set mock callout
        Test.setMock(HttpCalloutMock.class, new ShiprocketMockHttpResponse());
        
        // Run the batch
        Shiprocket_DeliveryStatus_Batch batchJob = new Shiprocket_DeliveryStatus_Batch();
        Database.executeBatch(batchJob, 2); // Only 2 records, matching batch size
        
        Test.stopTest();
        
        // Verify that a queueable job was enqueued by asserting no errors
        List<AsyncApexJob> jobs = [SELECT Id, JobType, Status FROM AsyncApexJob WHERE JobType = 'Queueable' AND Status = 'Completed'];
        System.assert(jobs.size() > 0, 'Queueable job should have been enqueued.');
    }
}