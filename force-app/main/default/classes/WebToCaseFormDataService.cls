/**
 * @description       : Web to Case form force.com sites data service
 * @author            : Avinash
 * @group             : 
 * @last modified on  : 07-12-2020
 * @last modified by  : Avinash
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   12-04-2020   Avinash   Initial Version
**/
public without sharing class WebToCaseFormDataService {
/**
* @description : return active Boult Audio products in asc order
* @author Ajitesh Singh | 12-07-2020 
* @return List<Product__c> : Active Boult Audio products for selected
**/
Public static string retrunResult;
public static id invoiceId;

@AuraEnabled(cacheable=true)
public static List<Product__c> getProducts(String productFamily) {
    // Initialize the base query
    String query = 'SELECT Id, Name, Product_Family__c, Market_Place_Platform__c FROM Product__c WHERE Active__c = TRUE';
    
    // Check if the productFamily parameter is not null or empty
    if (productFamily != null && !String.isEmpty(productFamily)) {
        query += ' AND Product_Family__c = :productFamily';
    }
    
    // Add ORDER BY clause to sort by Name in ascending order
    query += ' ORDER BY Name ASC';
    
    // Execute the query and return results
    return Database.query(query);
}
    
/**
* @description : Case record submited from Web to Case form force.com sites and duplicay check and file attached
* @author Ajitesh Singh | 12-07-2020 
* @param fileName : Name of the file attached with the case
* @param base64Data : File content in base64 format
* @param caseRec : Case record to be created
* @return string 
**/
@AuraEnabled
public static string submitCaseRec(String caseRecStr, String Streetadd, String Cityadd, String Pincodeadd, String Stateadd, String Countryadd){
    
    
    list<String>proList = new list<String>{'Curve Black','Curve X Blue','Curve blue','Curve Pro Green','Curve pro Grey','curve pro red','Curve Red','Curve X Black','BA-CURVEX-Grey'};
    
   
    System.debug('First');
    //fetch the custom label that contain the curve case queue id. 
    String curvecaseid = Label.CurveCaseId;
    //List<Group> curvecaseid = [SELECT Id FROM Group WHERE Type = 'Queue' and Name='Curve Cases'];
    System.debug('====curvelab==='+ curvecaseid);
    
    String caseId ='';
    
    try {
        Case caseRec = (Case)JSON.deserialize(caseRecStr, Case.class);
        System.debug('Case Record is :' + caseRec);
        if(duplicacyCheck(caseRec)){
            
            return retrunResult;
        }
                if(invoiceId <> null)
        {
            caseRec.Related_Invoice_del__c=invoiceId;
        }
        
        caseRec.Address_street__c = Streetadd;
        caseRec.City__c = Cityadd;
        caseRec.Pin_Code__c = Pincodeadd;
        caseRec.State__c = Stateadd;
        
        insert caseRec;
        
        CaseId = caseRec.Id;
        System.debug('Case Id is-------' + CaseId);
        
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
    return CaseId; 
}

/**
* @description 
* @author Ajitesh Singh | 12-07-2020 
* @param caseRec : Current case record whose duplicacy needs to be checked 
* @return Boolean 
**/
public static Boolean duplicacyCheck(Case caseRec){
    try{
        /*Phase 1 version duplicacy check Logic
        *  List<Case> duplicateCase = [SELECT Id FROM Case WHERE Product__c=:caseRec.Product__c AND ((SuppliedPhone =: caseRec.SuppliedPhone AND SuppliedPhone != null ) OR (SuppliedEmail =: caseRec.SuppliedEmail AND SuppliedEmail != null) OR (Order_ID__c =: caseRec.Order_ID__c AND Order_ID__c != null) )];
        if(duplicateCase.size()>0){
            return true;
        }
        else{
            return false;
        }*/
        //phase 2 logic for duplicacy check
        list<case> checkInvoiceCase = [select id,Related_Invoice_del__c,Product__r.Product_Family__c from case where Invoice_Number__c =: caserec.Invoice_Number__c AND (Status <> 'Closed') limit 50000];
        integer wiredCount = 0;
        integer NonWiredCount = 0;
        for(case tempcase : checkInvoiceCase)
        {
            if(tempcase.Product__r.Product_Family__c == 'Wired')
            {
                wiredCount++; 
            }
            else
            {
            NonWiredCount++;   
            }
        }
        
        list<Invoice__c> checkInvoice = [select Id, Case__c, Contact_Name__c, No_of_Wired_Product__c,
                                        Number_of_Cases__c, Total_Number_of_Products_in_Invoice__c,
                                        Total_Number_of_Cases__c, Order_ID__c, Case_ID__c
                                        from invoice__c where name =: caserec.Invoice_Number__c
                                        limit 50000];
        System.debug('Limits.getLimitAggregateQueries - '+ Limits.getLimitAggregateQueries());

        
        /* if(checkInvoice <> null)
        {
            if(checkInvoice[0] <> null)
            invoiceId = checkInvoice[0].id;
        }*/
        if(checkInvoiceCase.size() == 0)
        {
            retrunResult = 'NoOpenCase';
            return false;
        }
        else if(checkInvoice.size() == 0)
        {
            retrunResult = 'NoInvoice';
            return false;
        }
        else if(checkInvoice[0].Total_Number_of_Products_in_Invoice__c	<= checkInvoiceCase.size())
        {
            retrunResult = 'MaxCaseReg';
                return true;
        }
        else if(checkInvoice[0].Total_Number_of_Products_in_Invoice__c	> checkInvoiceCase.size())
        {
            Product__c lprod = [select id,Product_Family__c from product__c where id =: caserec.Product__c];
            if(lprod != null){
            if(lprod.Product_Family__c == 'Wired')
            { 
                if(wiredCount < checkInvoice[0].No_of_Wired_Product__c)
                {
                    system.debug('******** inside 112');
                retrunResult = 'CaseReg';
                    invoiceId = checkInvoice[0].id;
                return false;
                }
                else
                {
                    retrunResult = 'MaxWiredCaseReg';
                    return true;
                }
            }
                else if((lprod.Product_Family__c <> 'Wired') )
                {
                    if((checkInvoice[0].Total_Number_of_Products_in_Invoice__c-checkInvoice[0].No_of_Wired_Product__c ) > NonWiredCount)//(checkInvoice[0].Total_Number_of_Cases__c-checkInvoice[0].Number_of_Cases__c)  )
                    {
                        system.debug('******** inside 126');
                        invoiceId = checkInvoice[0].id;
                        return false;
                    }
                    else
                    {
                        retrunResult = 'MaxNwiredCaseReg';
                        return true;
                    }
                }
            }
            else
            {retrunResult = 'MaxNwiredCaseReg';
                        return true;}
            
        }
        
            return true;
        
    }
    catch(Exception e){
        System.debug('Error due to'+e.getMessage());
        retrunResult = 'duplicate';
        return true;
    }
    
}
/**
* @description : Attach the bill or receipt to the case created
* @author Ajitesh Singh | 12-07-2020 
* @param parentId : Case record id on which file will be attached
* @param fileName : Name of file
* @param base64Data : File content into base 64 format
**/
@AuraEnabled
public static void attachFile(Id parentId, String fileName, String base64Data){
    System.debug('attachFile');
    System.debug('parentId == >> '+parentId);
    System.debug('fileName == >> '+fileName);
    System.debug('base64Data == >> '+base64Data);
    
    base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
    //Insert ContentVersion
    ContentVersion contentVersion = new ContentVersion();
    contentVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
    contentVersion.PathOnClient = fileName;//File name with extention
    contentVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
    contentVersion.OwnerId = UserInfo.getUserId();//Owner of the file
    contentVersion.Title = fileName;//Name of the file
    contentVersion.VersionData = EncodingUtil.base64Decode(base64Data);//File content
    Insert contentVersion;
    System.debug('Content Id >>>>>>>> '+contentVersion.Id);
    //After saved the Content Verison, get the ContentDocumentId
    Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;

    //Insert ContentDocumentLink
    ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
    contentDocumentLink.ContentDocumentId = contentDocumentId;//Add ContentDocumentId
    contentDocumentLink.LinkedEntityId = parentId;//Add attachment parentId
    contentDocumentLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
    contentDocumentLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
    Insert contentDocumentLink;
    
    System.debug('contentDocumentLink ==>> '+contentDocumentLink);
}
    @auraEnabled
    public static string fetchCaseNumber (String caseID){
    return [select id , caseNumber from Case where id =: caseId limit 1].casenumber;
}
    @auraEnabled
    public static string fetchCustomerName(String casesID){
        String custName = [Select id, SuppliedName from case where id =: casesId limit 1].SuppliedName;
        System.debug('Customer Name is ===' + custName);
        return custName;   
    }

//query for city and state
@AuraEnabled(cacheable=true)
public static List<PinCodeList__c> getPinCodeData(String pinNumber) {
    try {
        // Throw an exception if pinNumber is null or empty
        if (String.isBlank(pinNumber)) {
            throw new AuraHandledException('PinCode is required');
        }
        
        // Query for the PinCodeList__c record
        return [SELECT Id, City__c, State__c, PinCode__c FROM PinCodeList__c WHERE PinCode__c = :pinNumber LIMIT 1];

    } catch (Exception e) {
        // Properly closing the catch block
        throw new AuraHandledException(e.getMessage());
    }
}






}