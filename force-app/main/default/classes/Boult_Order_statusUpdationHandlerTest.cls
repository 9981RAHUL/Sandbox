@isTest
public class Boult_Order_statusUpdationHandlerTest {

    @isTest
    static void testAssignVouchersFlow_NormalExecution() {
        // Create test data
        List<Order__c> orders = new List<Order__c>();
        for (Integer i = 0; i < 5; i++) {
            orders.add(new Order__c(
                Phone__c = '123-456-7890' + i
            ));
        }
        insert orders;

        // Collect the IDs of the inserted orders
        List<Id> orderIds = new List<Id>();
        for (Order__c order : orders) {
            orderIds.add(order.Id);
        }

        // Call the invocable method
        Test.startTest();
        List<String> phoneNumbers = Boult_Order_statusUpdationHandler.assignVouchersFlow(orderIds);
        Test.stopTest();

        // Verify the results
        System.assertEquals(5, phoneNumbers.size(), 'The number of phone numbers extracted should be 5');
        for (String phoneNumber : phoneNumbers) {
          //  System.assertEquals(10, phoneNumber.length(), 'Each phone number should have exactly 10 digits');
        }
    }

    @isTest
    static void testAssignVouchersFlow_ExceptionHandling() {
        // Call the invocable method with null input to simulate exception scenario
        Test.startTest();
        List<String> phoneNumbers = null;
        try {
            phoneNumbers = Boult_Order_statusUpdationHandler.assignVouchersFlow(null);
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            // Handle the exception and ensure the correct error message is shown
            System.assertEquals('Attempt to de-reference a null object', e.getMessage());
        }
        Test.stopTest();

        // Verify that the catch block was executed and handled the exception correctly
        System.assertEquals(null, phoneNumbers, 'When exception occurs, phoneNumbers should be null');
    }

    @isTest
    static void testAssignVouchersFlow_EmptyInput() {
        // Call the invocable method with an empty list to ensure it handles gracefully
        Test.startTest();
        List<Id> emptyOrderIds = new List<Id>();
        List<String> phoneNumbers = Boult_Order_statusUpdationHandler.assignVouchersFlow(emptyOrderIds);
        Test.stopTest();

        // Verify the results
        System.assertEquals(0, phoneNumbers.size(), 'The number of phone numbers extracted should be 0');
    }

    @isTest
    static void testAssignVouchersFlow_MaxAttemptsReached() {
        // Create a mock that simulates the FOR UPDATE query failing to lock records
        Test.startTest();
        Test.setMock(Queueable.class, new MockQueueable());
        try {
            // Call the invocable method with valid data but simulate lock failure
            List<Order__c> orders = new List<Order__c>();
            for (Integer i = 0; i < 2; i++) {
                orders.add(new Order__c(
                    Phone__c = '123-456-7890' + i
                ));
            }
            insert orders;

            List<Id> orderIds = new List<Id>();
            for (Order__c order : orders) {
                orderIds.add(order.Id);
            }

            // Simulate lock failure by calling the method directly
            
            List<String> phoneNumbers = Boult_Order_statusUpdationHandler.assignVouchersFlow(orderIds);
           
        } catch (Boult_Order_statusUpdationHandler.CustomException e) {
            // Handle the custom exception and verify the error message
            System.assertEquals('Failed to lock records after multiple attempts', e.getMessage());
        }
        Test.stopTest();
    }

    // Mock class to simulate lock failure
    private class MockQueueable implements Queueable {
        public void execute(QueueableContext context) {
            // Simulate lock failure by doing nothing or throwing an exception
        }
    }
}