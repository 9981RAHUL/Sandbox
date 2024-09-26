@isTest
public class attachPDFtoCaseTest {
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
        Name = '12345'
        );
   	    insert aggr2;  
        Product__c prod = new Product__c(
        name = 'ABC',
        Product_Color__c = 'Black',
        Box_Description__c = 'Desc',
        Description__c = 'desc',
        Quantity_Box__c = 123
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
        name = acc.ShippingPostalCode,
        Courier_Partner__c = 'India Post'
        );
        insert serv;
        Case cs=new Case(
        Contact_Name__c = acc.id,
        AWB__c = aggr2.id,
        Product_Color__c = 'Black',
        Product__c = prod.id,
        Serviceability__c = serv.id
        );
        insert cs;
       Test.startTest();
       ApexPages.currentPage().getParameters().put('id',String.valueOf(cs.id));
        new attachPDFtoCase();
       Test.stopTest();
    
    }
}