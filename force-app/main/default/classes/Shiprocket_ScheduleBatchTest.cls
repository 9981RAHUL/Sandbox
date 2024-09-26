@isTest
public class Shiprocket_ScheduleBatchTest {
    
    @testSetup
    static void setupTestData() {
        // Create test data if needed
        List<Order__c> orders = new List<Order__c>();
        for (Integer i = 0; i < 2; i++) {
            Order__c order = new Order__c(
                Shopify_Order_Number__c = 'TestOrder_' + i,
                Shiprocket_Status__c = 'Processing'
            );
            orders.add(order);
        }
        insert orders;
    }

    @isTest
    static void testScheduleJob() {
        // Set mock callout to prevent any actual HTTP requests
        Test.setMock(HttpCalloutMock.class, new ShiprocketMockHttpResponse());

        Test.startTest();
        // Schedule the job
        Shiprocket_ScheduleBatch.scheduleJob();
        Test.stopTest();
        
        // Verify that the job has been scheduled
        List<CronTrigger> cronTriggers = [SELECT Id, CronExpression FROM CronTrigger WHERE CronExpression = '0 25 * * * ?'];
        System.assert(cronTriggers.size() > 0, 'Scheduled job should be found with the correct cron expression.');
    }

@isTest
static void testScheduledBatchExecution() {
    // Set mock callout to avoid actual HTTP requests during tests
    Test.setMock(HttpCalloutMock.class, new ShiprocketMockHttpResponse());

    Test.startTest();
    
    // Use a cron expression that will schedule the job to run shortly after the test starts
    String cronExpression = '0 22 * * * ?';  // Runs at the top of the next minute
    String jobID = System.schedule('Shiprocket_DeliveryStatus_15mnts_Test', cronExpression, new Shiprocket_ScheduleBatch());
    
    // Verify the job was scheduled
    List<CronTrigger> cronTriggers = [SELECT Id, CronExpression FROM CronTrigger WHERE CronExpression = :cronExpression];
    System.assert(cronTriggers.size() > 0, 'Scheduled job should be found.');
    
    // Now execute the batch job immediately in the same test context
    Database.executeBatch(new Shiprocket_DeliveryStatus_Batch(), 200);
    
    Test.stopTest();
    
    // Verify that the batch job has executed
    List<AsyncApexJob> jobs = [SELECT Id, JobType, Status FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status = 'Completed'];
    System.assert(jobs.size() > 0, 'Batch job should be executed and completed.');
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
}