/**
 * @description       : Provide Courier data to LWC component basis Pincode matching between Person Account and Servicibility matrix
 * @author            : Ajitesh
 * @last modified on  : 12-10-2020
 * @last modified by  : Ajitesh Singh
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   25 Nov 2020  Ajitesh                              Initial Version
**/

public with sharing class ServicibilityCourierSelectionDataService {
    /**
    * @description : Fetch Person Account pincode basis Person tagged to Case id passed to the function and check servicibility matrix and return matched courier
    * author Ajitesh | 25 Nov 2020
    * param caseId Id of current case 
    * return List<Serviceability__c> - List of Courier partner from Servicibility Matrix
    **/
    public static String ALL_PINCODE = 'All';
    public static String INDIA_POST = 'India Post';
    @AuraEnabled(cacheable=true)
    public static List<Serviceability__c> getCourierPartner(Id caseId){
        try{
            List<Serviceability__c> courierPartnerList = new List<Serviceability__c>();
            Case currentCase = [SELECT Contact_Name__c FROM Case WHERE Id=:caseId];
            if(currentCase.Contact_Name__c == null){
                return courierPartnerList;
            }
            
            Account accountRec = [SELECT ShippingPostalCode FROM Account WHERE Id=:currentCase.Contact_Name__c];
            courierPartnerList = [SELECT Courier_Partner__c, Id FROM Serviceability__c WHERE Name =: accountRec.ShippingPostalCode OR Name =: ALL_PINCODE];
            return courierPartnerList;
        }
        catch(Exception err){
            throw new  AuraHandledException('Issue exist due to this'+err.getMessage());
        }
    }

    /**
    * @description : To Save the selected Courier partner on the current case
    * @author Ajitesh | 26 Nov 2020 
    * @param serviciabilityId  : the Servicibility record id which is selected
    * @param caseId : the case id which is in context
    * @param courierPartnerVal : the Courier Partner string value which is selected
    **/
    @AuraEnabled
    public static String saveCourierPartnerSelected(Id serviciabilityId, Id caseId, String courierPartnerVal){
        try{
            Case currentCaseRec = [SELECT Serviceability__c, Courier_Partner_Name__c,AWB__c, Id FROM Case WHERE Id =: caseId];
            if(currentCaseRec.Courier_Partner_Name__c != null){
                return 'error';     
            }
            currentCaseRec.Serviceability__c = serviciabilityId;
            currentCaseRec.Courier_Partner_Name__c = courierPartnerVal;
            update currentCaseRec;
            if(currentCaseRec.Courier_Partner_Name__c != INDIA_POST){
                handleAWBAttachment(currentCaseRec);
            }
            PDFAttachment.getattachPDF(currentCaseRec);
            return 'success';
        }
        catch(Exception e){
            throw new AuraHandledException('Issue due to 62 '+e.getMessage()+'e:--'+e);
        }

    }

    
    /**
    * @description : When the courier Partner is attached, assign respective AWB number except incase of India Post
    * @author Ajitesh Singh | 12-01-2020 
    * @param currentCaseRec : Current case in context
    **/
    @AuraEnabled
     public static void handleAWBAttachment(Case currentCaseRec){
        try {
            system.debug(currentCaseRec.Courier_Partner_Name__c + ' --partner name');
            AWB__c awbRec = [SELECT Id, IsUsed__c,(Select id from cases__r) FROM AWB__c WHERE Courier_Partner__c=:currentCaseRec.Courier_Partner_Name__c AND IsUsed__c=FALSE LIMIT 1 FOR UPDATE];
            system.debug(awbRec.cases__r.size());
            system.debug(awbRec + '---AWB record');
            if(awbRec.cases__r.size() == 0)
            {
            currentCaseRec.AWB__c = awbRec.Id;
            update currentCaseRec;
            awbRec.IsUsed__c = true;
            update awbRec;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Issue due to 63 AWB not Updated '+e.getMessage());
        }
    }
}