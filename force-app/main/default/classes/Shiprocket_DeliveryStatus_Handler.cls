public class Shiprocket_DeliveryStatus_Handler {

    @future(callout=true)
    public static void processOrderStatuses(List<String> orderIds) {
        String token = Shiprocket_API.Shiprocket_APIMethod();
        List<Order__c> ordersToUpdate = new List<Order__c>();
        
        List<Order__c> orderList = [SELECT Id, Shopify_Order_Number__c FROM Order__c WHERE Id IN :orderIds];
        
        for (Order__c order : orderList) {
            Http http = new Http();
            String endPoint = 'https://apiv2.shiprocket.in/v1/external/courier/track?order_id=' + order.Shopify_Order_Number__c;
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + token);
            HTTPResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                Shiprocket_DeliveryStatusJSON2APEX resData = (Shiprocket_DeliveryStatusJSON2APEX) System.JSON.deserialize(responseBody, Shiprocket_DeliveryStatusJSON2APEX.class);
                
                if (resData != null && resData.tracking_data != null) {
                    for (Shiprocket_DeliveryStatusJSON2APEX.shipment_track track : resData.tracking_data.shipment_track) {
                        Order__c orderToUpdate = new Order__c();
                        orderToUpdate.Id = order.Id;
                        orderToUpdate.Shiprocket_Status__c = track.current_status;
                        orderToUpdate.AWB_Code__c = track.awb_code;
                        ordersToUpdate.add(orderToUpdate);
                    }
                }
            } else {
                // Handle failed responses
                Order__c failedOrder = new Order__c();
                failedOrder.Id = order.Id;
                failedOrder.Shiprocket_response_code__c = response.getStatusCode();
                failedOrder.Shiprocket_Response_Body__c = response.getBody();
                ordersToUpdate.add(failedOrder);
            }
        }
        
        if (!ordersToUpdate.isEmpty()) {
            try {
                update ordersToUpdate;
                System.debug('Orders updated successfully.');
            } catch (DmlException e) {
                System.debug('DML Exception: ' + e.getMessage());
            }
        }
    }
}