/**
* @description       : Sampark api callout and controller for Sending Case Status to Sampark
* @author            : Avinash
* @group             : 
* @last modified on  : 20-09-2022
* @last modified by  : Avinash
* Modifications Log 
* Ver   Date         Author          Modification
* 1.2   20-09-2022   Avinash        Updated Version
**/
@RestResource (urlMapping='/TicketId/*/mobile/*/*')
global with sharing class SamparkApi {
    @HttpGet
    // Method to perform web service callouts
    global static case getStatus(){
        // Set up a test request
        RestRequest request = RestContext.request;
        system.debug('request=:'+request);
        
        // grab the caseNumber from the URL
        string caseNumber = request.requestURI.substringBetween('TicketId/','/mobile');
        system.debug('casenumber=:'+caseNumber);
        
        // grab the mobileNumber from the end of the URL
        String onlymobileNumber = request.requestURI.substringBetween('/mobile/','/');
        system.debug('mobileNumber=:'+onlymobileNumber);
        
        String onlyCaseNumber = request.requestURI.substringBetween('TicketId/','/');
        system.debug('onlyCaseNumber=:'+onlyCaseNumber);
      
        case result = new case();
        Try{
            if(string.isNotEmpty(caseNumber) && onlymobileNumber == null){
                // Perform web service callout 
                result =[select CaseNumber, Status, LastModifiedDate, Bucket__c from case where CaseNumber=: caseNumber LIMIT 1];
            System.debug('===mobile number null =='+result);
            }
            else if( string.isNotEmpty(onlymobileNumber) && string.isBlank(onlyCaseNumber) )
            {
                result =[select CaseNumber, Status, LastModifiedDate, Bucket__c from case where  SuppliedPhone=: onlyCaseNumber];
               System.debug('===case number null =='+result);
            }
            else if(string.isNotEmpty(caseNumber)&& string.isNotEmpty(onlymobileNumber)){
                result =[select CaseNumber, Status, LastModifiedDate, Bucket__c from case where CaseNumber=: onlyCaseNumber or SuppliedPhone=: onlymobileNumber];
                System.debug('===both not null =='+result);
            }
            else {
                System.debug('===else===');
            }
        } 
        Catch(System.QueryException e){
            // Unexpected exceptions will be caught here, like a deserialization error.
            system.debug('error occured : '+ e);
        }
        
        // Return the case record Data.
        return result;
    }
}