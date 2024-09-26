global class Shiprocket_DeliveryStatus_Batch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Shopify_Order_Number__c FROM Order__c WHERE Shopify_Order_Number__c != null AND Shiprocket_Max_Attempt_Date__c >= TODAY AND Shiprocket_Status__c != \'Delivered\'';
        return Database.getQueryLocator(query);
        
    }

    global void execute(Database.BatchableContext BC, List<Order__c> orderList) {
        // Collect order numbers
        List<String> orderNumbers = new List<String>();
        for (Order__c order : orderList) {
            orderNumbers.add(order.Shopify_Order_Number__c);
        }
       Integer size = orderNumbers.size();
       system.debug('Batch soql size of orders'+size);
        // Enqueue the Queueable job to process the callouts
        if (!orderNumbers.isEmpty()) {
            Shiprocket_DeliveryStatus_Queueable queueableJob = new Shiprocket_DeliveryStatus_Queueable(orderNumbers);
            System.enqueueJob(queueableJob);
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch processing completed.');
    }
}