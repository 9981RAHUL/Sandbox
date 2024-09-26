/**
* @description       : To provide OCR Functionality to re open the cases basis specfic keywords provided
* @author            : Ajitesh Singh
* @group             : 
* @last modified on  : 12-18-2020
* @last modified by  : Ajitesh Singh
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   12-18-2020   Ajitesh Singh   Initial Version
**/
trigger EmailMessageTrigger on EmailMessage (before insert, after insert, before update, after update) {
    
    EmailMessageTriggerHandler.ocrFunctionality(Trigger.new);
    
    List<EmailMessage> emailMsgList = new List<EmailMessage>();
    
    if( Trigger.isAfter && Trigger.isInsert  ){
        System.debug('EmailMessage after insert ');
        for( EmailMessage em : Trigger.new ){
            if( em.Incoming && em.CaseOrigin__c == 'Email' ){
                 emailMsgList.add( em );
            }
        }
    }
    
    if( emailMsgList.size() > 0 ){
        EmailMessageTriggerHandler.firstRun = false;
        EmailMessageTriggerHandler.emailTrailE2C( emailMsgList );
    }
    
}