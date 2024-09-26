public class WAmsg_forVoucherBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    
    // QueryLocator method to fetch the orders to be processed
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Modify the query to fetch the orders you need to process
        // Query to fetch orders with the specified conditions
        String query = 'SELECT Id, CreatedDate, Account__r.PersonMobilePhone, Account__r.Name ' +
                       'FROM Order__c ' +
                      'WHERE (NOT Tags__c LIKE \'%Cash on Delivery (COD)%\') ' +
                      'AND CreatedDate >= LAST_N_DAYS:1'; // Adjust this as needed for the 24-hour condition
        return Database.getQueryLocator(query); 
    }
    
    // Execute method to process each batch of orders
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        // Bulk process the orders in the current batch
      //  List<Order__c> orders = (List<Order__c>) scope;
     //   List<String> orderIds = new List<String>();
      //  for (Order__c order : orders) {
      //      orderIds.add(order.Id);
      //  }
      //  MessageClass.sendBulkSMSforOrders(orderIds);
    }
    
    // Finish method to execute any post-batch processes
    public void finish(Database.BatchableContext bc) {
        // Implement any post-processing logic here if needed
    }
}