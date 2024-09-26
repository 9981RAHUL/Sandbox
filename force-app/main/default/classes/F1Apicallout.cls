/**
* @description       : F1 api callout and controller for Sending Case data to F1 Smart
* @author            : Avinash
* @group             : 
* @last modified on  : 01-05-2022
* @last modified by  : Avinash
* Modifications Log 
* Ver   Date         Author          Modification
* 1.2   01-05-2022   Avinash        Updated Version
**/
public class F1Apicallout 
{
    // Method to perform callouts
    @future(callout=true)
    public static void F1caseupdation ( Set<Id> caseId)  
    { 
       // system.debug('caseIDs>>>'+caseId);
        // define a response to caller
        String outcomeMsg;
        List<case> casestoUpdate = [SELECT id, Call_No__c, AWB_No__c, Courier_Partner_Name__c, Delivery_Partner_Response__c, ORM_Recieving_Date__c, Outward_Ticket_receiving_Date__c, Case_Closure_Reason_Open_as_Error_Open__c, Status FROM case where Id=: caseId];
        // define basic information for later, store these in a protected custom setting
        System.debug('===='+casestoUpdate);
        string endpoint = 'https://smart.f1infoservices.com/smsv6.0/rest/WebAPIs/updateCall/'; // be sure this is configured in "Remote Site Settings"
        string username = 'BOULT'; 
        string password = 'BOULT31052022';
        string method = 'POST';
        string body = '';
        string errorMsg;
        Integer statusValue;
        string reason;
        if( casestoUpdate.size() > 0 ){
        	statusValue = casestoUpdate[0].Status == 'Reject' ? 2 : 1;
            reason = casestoUpdate[0].Status == 'Reject' ? 'Customer Details Incorrect' : '';
        }
        
        if( casestoUpdate.size() > 0 ){
            body = '{"serviceRequestNumber":"'+casestoUpdate[0].Call_No__c+'","awbNo":"'+casestoUpdate[0].AWB_No__c+'","deliveryPartnerName":"'+casestoUpdate[0].Courier_Partner_Name__c+'","deliveryStatus":"'+casestoUpdate[0].Delivery_Partner_Response__c+'","deliveryDateAndTime":"'+casestoUpdate[0].ORM_Recieving_Date__c+'","ticketStatus":"'+statusValue+'","rejectionReason":"'+reason+'","resolutionRemarks":"'+casestoUpdate[0].Case_Closure_Reason_Open_as_Error_Open__c+'","dispatchDateAndTime":"'+casestoUpdate[0].Outward_Ticket_receiving_Date__c+'"}';   
                System.debug('===='+body);
        }
        // check to ensure a callout can be performed using the Limits class. 
        if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
            outcomeMsg = 'Maximum number of callouts has been reached.';
            
            // check for credentials error
        } else if (endpoint == null || username == null || password == null) {
            outcomeMsg = 'Please verify your API Credentials';
            System.debug(outcomeMsg);
            // configure and perform the callout
        } else {
            
            // define transaction variables
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http h = new Http();
            
            // Configure the request
            req.setEndpoint(endpoint);
            req.setMethod(method);
            req.setTimeout(120000);
            
            // Add basic authentication to header
            // Create blob of user:pass
            Blob headerValue = Blob.valueOf(username + ':' + password);
            // Base 64 Encode the blob and prepend "Basic "
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            // Add the basic auth string to the Request Header
            req.setHeader('Username', username); 
            req.setHeader('Password', password);
         // req.setHeader('TLS-Version', '1.2');
         // req.setClientCertificateName('smart.f1infoservices.com');
            // Configure standard headers
            req.setHeader('Content-Type', 'application/json');
            req.setBody(body);
            map<string, string> attributeMap = new map<string, string>{'className'=>'F1Apicallout', 'methodName'=>'F1caseupdation','objectType'=>'Case','recordId'=>JSON.serialize(caseId)};
            DateTime reqSentTime;
            DateTime resRecvTime;
            try {
                
                // Perform callout and set response
                reqSentTime = system.now();
                res = h.send(req);
                if(res != null){
                	resRecvTime = system.now();    
                }
                
                System.debug('F1response'+res);
                
                // check response 
                if ((res.getStatusCode() == 200 /*|| res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null*/)) {
                    
                    System.debug(res.getBody());
                    // Deserialize the response untyped
                    Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    
                    // Check success of deserialization
                    if(untypedMap!=null){
                        // The deserialized response contains the expected key!
                        outcomeMsg = 'Record Updated Successfully';
                        System.debug(untypedMap); 
                        System.debug(outcomeMsg);
                      
                    }   
                } 
                else {
                    // callout failed
                    outcomeMsg = 'Error: Service Request Number is required|Ticket Status is Invalid.';
                    System.debug(outcomeMsg);
                    errorMsg = outcomeMsg;
                    if(!Test.isRunningTest()){
                    	attributeMap.put('error', errorMsg);
                    	GenerateExceptionLogs.insertIntegrationLog(req, res, attributeMap, reqSentTime, resRecvTime);
                    }    
                }
                
            } catch (exception e) {
                // Unexpected exceptions will be caught here, like a deserialization error.
                outcomeMsg = 'Error: An exception has been encountered while calling out to Integration:  ' + e.getMessage()+e.getstacktracestring();
                System.debug(outcomeMsg);
				GenerateExceptionLogs.insertErrorLogs('F1Apicallout', 'F1caseupdation', e);
            }
        }
        
    }
}