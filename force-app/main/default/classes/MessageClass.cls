/**
@description       : Class for sending WhatsApp / SMS messages to customer.
@author            : Avinash
@group             : 
@last modified on  : 21-06-2021
@last modified by  : Avinash
Modifications Log 
Ver   Date         Author        		 Modification
1.0   16-12-2021   Avinash   		     Initial Version
1.1   28-01-2022   Avinash	 			 Modified for Sub-Bucket Update
1.2   21-06-2022   Avinash	             Modified for F1 Tickets
1.3   24-05-2023   Avinash	 			 Modified for New WhatsApp Vendor
**/
public class MessageClass {
    
    @AuraEnabled @Future(callout=true)
    public static void sendWhatsApp( String caseId, Map<Id, String> caseIds, Boolean webRun){
        system.debug('caseIdParam17'+caseId);
            
            Map<String, whatsAppData__mdt> settingsMap = new Map<String, whatsAppData__mdt>();
            for (whatsAppData__mdt setting : [Select DeveloperName, MasterLabel, Value__c, Enable__c from whatsAppData__mdt]) {
                settingsMap.put(setting.DeveloperName, setting);
            } 
            
            List<Case> caseList = [ SELECT id, Call_No__c, Origin, Bucket__c, CaseNumber, Status, Incoming_AWB_Number__c, Courier_Partner_Name__c, AWB_No__c, SuppliedPhone, SuppliedName,Product__r.Name from case where id=:caseIds.keyset() limit 1 ];
           system.debug('awb in message class>>'+caseList[0].AWB_No__c);
            String templateId = null;
            String accountId =  settingsMap.get('accountId').Value__c;
            String custName = caseList.size() > 0 ? caseList[0].SuppliedName : '';
            String custPhone = caseList.size() > 0 ? caseList[0].SuppliedPhone : '';
            String caseNo = caseList.size() > 0 && caseList[0].Origin != 'F1' ? caseList[0].CaseNumber : Caselist[0].Call_No__c;
            String AWBNo = caseList.size() > 0 ? caseList[0].AWB_No__c : '';
            String ProdName = caseList.size() > 0 ? caseList[0].Product__r.Name:'';
            String endPoint = settingsMap.get('endPoint').Value__c;
            
             if(caseList[0].origin != 'F1'){
                 
            /*     //Sending WhatsApp message after Successful filling of F1 Ticket.
                if(webRun == true && caseList[0].Origin == 'Web' ){
                    System.debug('===Case Creation Template is===');
                    templateId = settingsMap.get('W2C_Ticket_Shipment_Info').Value__c;
                }*/
                 
                //Sending WhatsApp message after Successful filling of Support Form.
                 if( caseList[0].Bucket__c == 'In Transit' || caseList[0].Bucket__c == 'In Review' ){
                    system.debug('caseList[0].Bucket__c' +caseList[0].Bucket__c);
                    templateId = settingsMap.get('In_Transit').Value__c; 
                }
                 
                //Sending W.A. message after changing bucket value to Correct Product Received.
                else if( caseList[0].Bucket__c == 'Correct product received'){
                    //caseNo = caseList.size() > 0 ? caseList[0].Incoming_AWB_Number__c : '';
                    system.debug('caseList[0].Bucket__c' +caseList[0].Bucket__c);
                    templateId = settingsMap.get('Order_Received_at_Warehouse').Value__c;
                }
                
                //Sending W.A. message after changing bucket value to Different Brand Product Received at Warehouse.
                else if( caseList[0].Bucket__c == 'Different Brand Product'){
                    //caseNo = caseList.size() > 0 ? caseList[0].Incoming_AWB_Number__c : '';
                    system.debug('caseList[0].Bucket__c' +caseList[0].Bucket__c);
                    templateId = settingsMap.get('Diff_Brand_Product_Received_at_Warehouse').Value__c;
                }
                
                //Sending W.A. message after changing bucket value to Partial product.
                else if( caseList[0].Bucket__c == 'Partial product'){
                    //caseNo = caseList.size() > 0 ? caseList[0].Incoming_AWB_Number__c : '';
                    system.debug('caseList[0].Bucket__c' +caseList[0].Bucket__c);
                    templateId = settingsMap.get('Partial_product_Received_at_Warehouse').Value__c;    
                }
                
                //Sending W.A. message after changing bucket value to Physically damaged.
                else if( caseList[0].Bucket__c == 'Physically damaged'){
                    //caseNo = caseList.size() > 0 ? caseList[0].Incoming_AWB_Number__c : '';
                    system.debug('caseList[0].Bucket__c' +caseList[0].Bucket__c);
                    templateId = settingsMap.get('Damaged_Product_Received_at_Warehouse').Value__c;   
                }
                
                //Sending W.A. message after changing bucket value to DBAPR(Different BoultAudio Product Received).
                else if( caseList[0].Bucket__c == 'DBAPR(Different BoultAudio Product Received)'){
                    caseNo = caseList.size() > 0 ? caseList[0].Incoming_AWB_Number__c : '';
                    //system.debug('caseList[0].Bucket__c' +caseList[0].Bucket__c);
                    templateId = settingsMap.get('DBAPR_Received_at_Warehouse').Value__c;   
                }
                
                //Sending W.A. message after changing bucket value to Serviceable/Shipped.
                else if( caseList[0].Bucket__c == 'Serviceable/Shipped'){
                    system.debug('caseList[0].Bucket__c : '+caseList[0].Bucket__c);
                    if (caseList[0].Courier_Partner_Name__c == 'India Post'){
                        system.debug('caseList[0].Courier_Partner_Name__c 1 : '+caseList[0].Courier_Partner_Name__c);
                        //  caseNo = caseList.size() > 0 ? caseList[0].AWB_No__c : '';
                        templateId = settingsMap.get('Order_Dispatch_Indiapost').Value__c;
                        
                    }
                    else if (caseList[0].Courier_Partner_Name__c == 'ShipRocket'){
                        system.debug('caseList[0].Courier_Partner_Name__c 2 : '+caseList[0].Courier_Partner_Name__c);
                        //AWBNo = caseList.size() > 0 ? caseList[0].AWB_No__c : '';
                        templateId = settingsMap.get('Order_Dispatch_Shiprocket').Value__c;
                    }
                    else if (caseList[0].Courier_Partner_Name__c == 'Blue Dart'){
                        system.debug('caseList[0].Courier_Partner_Name__c 3 : '+caseList[0].Courier_Partner_Name__c);
                        // caseNo = caseList.size() > 0 ? caseList[0].AWB_No__c : '';
                        templateId = settingsMap.get('Order_Dispatch_Bluedart').Value__c;
                    }
                }
                 
                //Sending W.A. message after changing bucket value to Delivered	        
                else if(caseList[0].Bucket__c == 'Delivered'){
                    templateId = settingsMap.get('Order_Delivered').Value__c;
                }
                 
                //Sending W.A. message after changing bucket value to Replace/Repair.
                else if( caseList[0].Bucket__c == 'Repair'){
                    templateId = settingsMap.get('Replace_Repair').Value__c;
                }
                
                //Sending W.A. message after changing bucket value to Replaceable in stock
                else if( caseList[0].Bucket__c == 'Replaceable in stock'){
                    templateId = settingsMap.get('Replaceable_in_stock').Value__c;
                }
                
                //Sending W.A. message after changing bucket value to Replaceable out of stock
                else if( caseList[0].Bucket__c == 'Replaceable out of stock'){
                    templateId = settingsMap.get('Replaceable_out_of_Stock').Value__c;
                }
                
                //Sending W.A. message after changing bucket value to Replaceable out of Stock/CRM/Service
                else if( caseList[0].Bucket__c == 'Replaceable out of Stock/CRM/Service'){
                    templateId = settingsMap.get('Replaceable_out_of_Stock_CRM_Service').Value__c;
                }
            }
            
            else {
                //Sending WhatsApp message after Successful filling of F1 Ticket.
                if(caseList[0].Bucket__c == null && caseList[0].Status == 'Open'){
                    system.debug('caseList[0].Bucket__c' +caseList[0].Bucket__c);
                    system.debug('templateId' +templateId);
                    templateId = settingsMap.get('F1_Case_Create').Value__c;
                }
                
                //Sending W.A. message after F1 Ticket is Delivered
                else if(caseList[0].Bucket__c == 'Delivered'){
                    System.debug('caseList[0].Bucket__c : '+caseList[0].Bucket__c);
                    if(caseList[0].Status == 'Resolved'){
                        templateId = settingsMap.get('F1_Delivered').Value__c;
                    }
                }
                
                //Sending W.A. message after F1 Ticket is Resolved and Sub-Bucket value is Replaceable in stock
                else if( caseList[0].Bucket__c == 'Replaceable in stock'){
                    system.debug('caseList[0].Bucket__c : '+caseList[0].Bucket__c);
                    if( caseList[0].Status == 'Resolved'){
                        system.debug('caseList[0].Status' +caseList[0].Status);
                        templateId = settingsMap.get('F1_Replaceble_In_Stock_Resolved').Value__c;
                    }
                }
                
                //Sending W.A. message after F1 Ticket is Pending and Open and Sub-Bucket value is Replaceable out of stock
                else if( caseList[0].Bucket__c == 'Replaceable out of stock'){
                    system.debug('caseList[0].Bucket__c : '+caseList[0].Bucket__c);
                    if( caseList[0].Status == 'Pending'){
                        system.debug('caseList[0].Status' +caseList[0].Status);
                        templateId = settingsMap.get('F1_Replaceble_Out_Of_Stock_Pending').Value__c;
                    }
                    
                   else if( caseList[0].Status == 'Open'){
                        system.debug('caseList[0].Status' +caseList[0].Status);
                        templateId = settingsMap.get('F1_Replaceble_Out_Of_Stock_Open').Value__c;    
                    }
                }
                
                //Sending W.A. message after changing F1 bucket value to Serviceable/Shipped.
                else if( caseList[0].Bucket__c == 'Serviceable/Shipped'){
                    system.debug('caseList[0].Bucket__c : '+caseList[0].Bucket__c);
                    if (caseList[0].Courier_Partner_Name__c == 'Blue Dart'){
                        system.debug('caseList[0].Courier_Partner_Name__c 1 : '+caseList[0].Courier_Partner_Name__c);
                        //  caseNo = caseList.size() > 0 ? caseList[0].AWB_No__c : '';
                        templateId = settingsMap.get('Order_Dispatch_Bluedart_F1').Value__c;
                    }
                    
                    else if (caseList[0].Courier_Partner_Name__c == 'India Post'){
                        system.debug('caseList[0].Courier_Partner_Name__c 1 : '+caseList[0].Courier_Partner_Name__c);
                        //  caseNo = caseList.size() > 0 ? caseList[0].AWB_No__c : '';
                        templateId = settingsMap.get('Order_Dispatch_Indiapost_F1').Value__c;
                    }
                    
                    else if (caseList[0].Courier_Partner_Name__c == 'ShipRocket'){
                        system.debug('caseList[0].Courier_Partner_Name__c 1 : '+caseList[0].Courier_Partner_Name__c);
                        //  caseNo = caseList.size() > 0 ? caseList[0].AWB_No__c : '';
                        templateId = settingsMap.get('Order_Dispatch_Shiprocket_F1').Value__c;
                    }
                }
            }
            
            system.debug('custName '+custName+ 'custPhone '+custPhone+ 'caseNo '+caseNo);
            String jsonBody = '{"templateId":"'+templateId+'","accountId":"'+accountId+'","contentType":"TEXT","caption":"caption","text":null,"channelId":2,"customers":[{"to":'+custPhone+',"countryCode":"+91","hasSubscribed":true,"customerDetails":{"1":"'+custName+'","2":"'+caseNo+'","3":"'+AWBNo+'","4":"'+ProdName+'","5":""}}]}';
            system.debug('Json Body ===' +jsonBody);
            HttpRequest req = new HttpRequest();       
            req.setEndpoint(endPoint);
            system.debug('EndPoint is ===' +endPoint);
            req.setMethod('POST');        
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('apikey', settingsMap.get('apikey').Value__c );
            req.setTimeout(60000);
            req.setBody(jsonBody);
            System.debug('end point--> '+req.getEndpoint()); 
            
            Http http = new Http();
            HTTPResponse res ;
            if(!test.isRunningTest()){
                res = http.send(req);
                System.debug('response is ===' +res);  
            }
            
            else
            {
                res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"errorDetail":null,"msgResponse":[{"to":"+919826229899","msgId":"290736230","errorDetail":null}]}');
                res.setStatusCode(200);
            }
            
            System.debug(res.getStatusCode()+' * '+res.getStatus()+'  *  '+res.getBody());        
            if( res.getStatusCode() == 200 ){
                System.Debug('WhatsApp Message sending Successful'); 
            } else {            
                System.Debug('WhatsApp Message sending Unsuccessful');
            }
            
        }

    
    
    @Future(callout=true)
    public static void sendBulkSMSforOrders(List<String> orderIds) {
        Map<String, whatsAppData__mdt> settingsMap = new Map<String, whatsAppData__mdt>();
        for (whatsAppData__mdt setting : [SELECT DeveloperName, MasterLabel, Value__c, Enable__c FROM whatsAppData__mdt]) {
            settingsMap.put(setting.DeveloperName, setting);
        } 

        List<Order__c> orders = [SELECT Id, Account__r.PersonMobilePhone, Account__r.Name FROM Order__c WHERE Id IN :orderIds];
        String templateId = settingsMap.get('W2C_Ticket_Shipment_Info').Value__c;
        String accountId = settingsMap.get('accountId').Value__c;
        String endPoint = settingsMap.get('endPoint').Value__c;

        List<Map<String, Object>> customersList = new List<Map<String, Object>>();
        for (Order__c order : orders) {
            Map<String, Object> customerDetails = new Map<String, Object>{
                'to' => order.Account__r.PersonMobilePhone,
                'countryCode' => '+91',
                'hasSubscribed' => true,
                'customerDetails' => new Map<String, String>{ '1' => order.Account__r.Name, '2' => order.Id }
            };
            customersList.add(customerDetails);
        }

        String jsonBody = JSON.serialize(new Map<String, Object>{
            'templateId' => templateId,
            'accountId' => accountId,
            'contentType' => 'TEXT',
            'caption' => 'caption',
            'text' => null,
            'channelId' => 2,
            'customers' => customersList
        });

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
}