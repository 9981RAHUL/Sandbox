public class WAmsg_forVoucher implements Schedulable {
    
// Implement the execute method from the Schedulable interface
     public void execute(SchedulableContext sc) {
        // Call the method to send SMS for orders
       // sendSMSforOrders();
    }
    
    // Method to send SMS for orders
  /*  @Future(callout=true)
    public static void sendSMSforOrders() {
        Map<String, whatsAppData__mdt> settingsMap = new Map<String, whatsAppData__mdt>();
        for (whatsAppData__mdt setting : [Select DeveloperName, MasterLabel, Value__c, Enable__c from whatsAppData__mdt]) {
            settingsMap.put(setting.DeveloperName, setting);
        } 

        // Query orders to send SMS for (modify this query as per your requirements)
        List<Order__c> orders = [SELECT Id, CreatedDate, Account__r.PersonMobilePhone, Account__r.Name 
                                 FROM Order__c 
                                 WHERE (NOT Tags__c LIKE '%Cash on Delivery (COD)%') 
                                 AND CreatedDate >= LAST_N_DAYS:1];

        for (Order__c order : orders) {
            String templateId = settingsMap.get('W2C_Ticket_Shipment_Info').Value__c;
            String accountId = settingsMap.get('accountId').Value__c;
            String custName = order.Account__r.Name;
            String custPhone = order.Account__r.PersonMobilePhone;
            String endPoint = settingsMap.get('endPoint').Value__c;

            System.debug('OrderId :' + order.Id);
            System.debug('custName ' + custName + ' custPhone ' + custPhone + ' orderId ' + order.Id);
            system.debug('templateId'+templateId);

            String jsonBody = '{"templateId":"' + templateId + '",'
                            + '"accountId":"' + accountId + '",'
                            + '"contentType":"TEXT",'
                            + '"caption":"caption",'
                            + '"text":null,'
                            + '"channelId":2,'
                            + '"customers":[{"to":"' + custPhone + '",'
                            + '"countryCode":"+91",'
                            + '"hasSubscribed":true,'
                            + '"customerDetails":{"1":"' + custName + '","2":"' + order.Id + '"}}]}';

            System.debug('Json Body ===' + jsonBody);

            HttpRequest req = new HttpRequest();       
            req.setEndpoint(endPoint);
            System.debug('EndPoint is ===' + endPoint);
            req.setMethod('POST');        
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('apikey', settingsMap.get('apikey').Value__c);
            req.setTimeout(60000);
            req.setBody(jsonBody);
            System.debug('end point--> ' + req.getEndpoint()); 
            
            Http http = new Http();
            HTTPResponse res;
            if (!Test.isRunningTest()) {
                res = http.send(req);
                System.debug('response is ===' + res);  
            } else {
                res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"errorDetail":null,"msgResponse":[{"to":"+919826229899","msgId":"290736230","errorDetail":null}]}');
                res.setStatusCode(200);
            }
            
            System.debug(res.getStatusCode() + ' * ' + res.getStatus() + '  *  ' + res.getBody());        
            if (res.getStatusCode() == 200) {
                System.Debug('WhatsApp Message sending Successful'); 
            } else {            
                System.Debug('WhatsApp Message sending Unsuccessful');
            }
        }
    } */
}