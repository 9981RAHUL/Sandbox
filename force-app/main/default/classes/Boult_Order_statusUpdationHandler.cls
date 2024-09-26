public class Boult_Order_statusUpdationHandler {

    @InvocableMethod(label='Extract Phone Numbers' description='Extract the last 10 digits of phone numbers from orders')
    public static List<ExtractedPhoneNumber> assignVouchersFlow(List<Id> orderIds) {
        // Enqueue the processing of orders in smaller batches
    //    System.enqueueJob(new OrderProcessorQueueable(orderIds));
        // Return an empty list since actual processing is deferred to the queueable job
        return new List<ExtractedPhoneNumber>();
    }

    public static List<ExtractedPhoneNumber> processOrders(List<Order__c> newOrders) {
        List<ExtractedPhoneNumber> phoneNumbers = new List<ExtractedPhoneNumber>();

        // Extract the last 10 digits of phone numbers for the orders
        for (Order__c order : newOrders) {
            if (order.Phone__c != null) {
                String phone = order.Phone__c;
                phone = phone.replaceAll('[^0-9]', ''); // Remove non-numeric characters
                if (phone.length() > 10) {
                    phone = phone.substring(phone.length() - 10);
                }
                phoneNumbers.add(new ExtractedPhoneNumber(order.Id, phone));
            }
        }

        return phoneNumbers;
    }

    // Custom exception class
    public class CustomException extends Exception {}

    // Wrapper class for returning phone numbers
    public class ExtractedPhoneNumber {
        @InvocableVariable
        public Id orderId;
        @InvocableVariable
        public String phoneNumber;

        public ExtractedPhoneNumber(Id orderId, String phoneNumber) {
            this.orderId = orderId;
            this.phoneNumber = phoneNumber;
        }
    }
}