@isTest
public class ServicibilityCourierSelectionDataTest {
    static testmethod void test1() {
       String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
        ShippingPostalCode = '800001',
        ShippingStreet = 'A12',
        ShippingState = 'Goa',
        ShippingCountry = 'India',
        FirstName = 'Ram',
        LastName = 'SHyam',
        Salutation = 'Mr.',
        ShippingCity = 'Noida',
        PersonMobilePhone = '8375077127',
        RecordTypeId = strRecordTypeId,
        PersonEmail = 'orm@boult-audio.com'
        );
        insert acc;
        AWB__c aggr2=new AWB__c(
        Courier_Partner__c = 'Blue Dart',
        Name = '12345',
            IsUsed__c=true
        );
   	    insert aggr2;  
        AWB__c aggr3=new AWB__c(
        Courier_Partner__c = 'Blue Dart',
        Name = '123345',
            IsUsed__c=FALSE
        );
   	    insert aggr3;  
        Product__c prod = new Product__c(
        name = 'ABC',
        Product_Color__c = 'Black',
        Box_Description__c = 'Desc',
        Description__c = 'desc',
        Quantity_Box__c = 123
        );
        insert prod;
        Case cs=new Case(
        Contact_Name__c = acc.id,
        AWB__c = aggr2.id,
        Product_Color__c = 'Black',
        Product__c = prod.id
        );
        insert cs;
         Case cs2=new Case(
        Contact_Name__c = acc.id,
        AWB__c = aggr2.id,
        Product_Color__c = 'Black',
        Product__c = prod.id
        );
        insert cs2;
        Serviceability__c serv = new Serviceability__c(
        name = acc.ShippingPostalCode,
        Courier_Partner__c = 'India Post'
        );
        insert serv;
        Serviceability__c serv2 = new Serviceability__c(
        name = acc.ShippingPostalCode,
        Courier_Partner__c = 'Blue Dart'
        );
        insert serv2;
                    
           Test.startTest();     
        ServicibilityCourierSelectionDataTest s = new ServicibilityCourierSelectionDataTest();
        List<Serviceability__c> courierPartnerList=ServicibilityCourierSelectionDataService.getCourierPartner(cs.id);
       // ServicibilityCourierSelectionDataService.saveCourierPartnerSelected(serv.id,cs.id,'India Post');   
        ServicibilityCourierSelectionDataService.saveCourierPartnerSelected(serv.id,cs2.id,'Blue Dart');   
       // ServicibilityCourierSelectionDataService.saveCourierPartnerSelected(serv2.id,cs2.id,'DTDC');   
        Test.stopTest();     
    }
    
}