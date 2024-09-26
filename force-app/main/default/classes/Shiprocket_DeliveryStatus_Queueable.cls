public class Shiprocket_DeliveryStatus_Queueable implements Queueable, Database.AllowsCallouts {
    private List<String> orderNumbers;
    private static final Integer BATCH_SIZE = 50; // Define the size of each chunk

    // Constructor to pass the list of orders
    public Shiprocket_DeliveryStatus_Queueable(List<String> orderNumbers) {
        this.orderNumbers = orderNumbers;
    }

    public void execute(QueueableContext context) {
        // Process the order numbers in batches
        processOrderNumbersInBatches(orderNumbers);
    }

    // Method to process the order numbers in batches and chain queueable jobs if necessary
    private void processOrderNumbersInBatches(List<String> fullOrderList) {
        Integer totalOrders = fullOrderList.size();
        Integer processedRecords = 0;

        while (processedRecords < totalOrders) {
            // Create a sublist manually by slicing the list
            List<String> currentBatch = new List<String>();
            for (Integer i = processedRecords; i < Math.min(processedRecords + BATCH_SIZE, totalOrders); i++) {
                currentBatch.add(fullOrderList[i]);
            }

            // Process the current batch
            processBatch(currentBatch);

            // Update the counter to move to the next set of records
            processedRecords += BATCH_SIZE;

            // If there are remaining records, chain the next queueable job
            if (processedRecords < totalOrders) {
                List<String> remainingBatch = new List<String>();
                for (Integer i = processedRecords; i < Math.min(processedRecords + BATCH_SIZE, totalOrders); i++) {
                    remainingBatch.add(fullOrderList[i]);
                }
                System.enqueueJob(new Shiprocket_DeliveryStatus_Queueable(remainingBatch));
            }
        }
    }

    // Method to process the current batch of orders
    private void processBatch(List<String> batchOrderNumbers) {
        String token = Shiprocket_API.Shiprocket_APIMethod();  // Get the token for callout
        List<Order__c> orList = new List<Order__c>();  // List to hold orders to be updated

        // Fetch all orders for this batch in one SOQL query
        List<Order__c> orders = [SELECT Id, Shiprocket_Status__c, Shopify_Order_Number__c 
                                 FROM Order__c 
                                 WHERE Shopify_Order_Number__c IN :batchOrderNumbers];

        // Map to store the Shopify Order Numbers and their corresponding records
        Map<String, Order__c> orderMap = new Map<String, Order__c>();
        for (Order__c order : orders) {
            orderMap.put(order.Shopify_Order_Number__c, order);
        }

        for (String orderNumber : batchOrderNumbers) {
            if (orderMap.containsKey(orderNumber)) {
                Http http = new Http();
                String endPoint = 'https://apiv2.shiprocket.in/v1/external/courier/track?order_id=' + orderNumber;
                HttpRequest request = new HttpRequest();
                request.setEndpoint(endPoint);
                request.setMethod('GET');
                request.setHeader('Authorization', 'Bearer ' + token);
                HTTPResponse response;

                try {
                    // Callout to the Shiprocket API
                    response = http.send(request);
                    System.debug('Response for order ' + orderNumber + ': ' + response.getBody());

                    if (response.getStatusCode() == 200) {
                        String responseBody = response.getBody();
                        responseBody = responseBody.substring(1, responseBody.length() - 1);  // Clean up the response string

                        if (!String.isEmpty(responseBody)) {
                            Shiprocket_DeliveryStatusJSON2APEX resdata = (Shiprocket_DeliveryStatusJSON2APEX) System.JSON.deserialize(responseBody, Shiprocket_DeliveryStatusJSON2APEX.class);
                            System.debug('Deserialized response data: ' + resdata);

                            if (resdata != null && resdata.tracking_data != null) {
                                List<Shiprocket_DeliveryStatusJSON2APEX.shipment_track> shipmentTracks = resdata.tracking_data.shipment_track;
                                System.debug('Shipment track data list: ' + shipmentTracks);

                                for (Shiprocket_DeliveryStatusJSON2APEX.shipment_track track : shipmentTracks) {
                                    Order__c orderObject = orderMap.get(orderNumber);

                                    // Compare the current status with the new status from the callout
                                    if (orderObject.Shiprocket_Status__c != track.current_status) {
                                        // If the status is different, update the record
                                        orderObject.Shiprocket_Status__c = track.current_status;
                                        orderObject.AWB_Code__c = track.awb_code;
                                        orList.add(orderObject);  // Add to the list for update
                                    } else {
                                        System.debug('No update needed for order ' + orderNumber + '. Status is the same.');
                                    }
                                }
                            }
                        }
                    } else {
                        handleNon200Response(response, orderNumber, orList);  // Handle non-200 responses
                    }
                } catch (Exception e) {
                    System.debug('Error during callout: ' + e.getMessage());
                }
            }
        }

        // Bulk update after processing the batch
        if (!orList.isEmpty()) {
            try {
                update orList;
                System.debug('Updated order list: ' + orList);
            } catch (DmlException dmlEx) {
                System.debug('DML Exception: ' + dmlEx.getMessage());
            }
        }
    }

    // Handle non-200 responses in a separate method
    private void handleNon200Response(HTTPResponse response, String orderNumber, List<Order__c> orList) {
        Order__c orderObject = [SELECT Id FROM Order__c WHERE Shopify_Order_Number__c = :orderNumber LIMIT 1];
        orderObject.Shiprocket_response_code__c = response.getStatusCode();
        orderObject.Shiprocket_Response_Body__c = response.getBody();
        orList.add(orderObject);  // Add to the list for updating
    }
}