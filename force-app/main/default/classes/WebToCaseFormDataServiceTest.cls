@isTest
public class WebToCaseFormDataServiceTest {
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
        
        AWB__c aggr2 = new AWB__c(
            Courier_Partner__c = 'Blue Dart',
            Name = '12345'
        );
        insert aggr2;

        Product__c prod = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123,
            Active__c = true,
            Product_Code__c = '12313',
            Product_Family__c = 'Wired'
        );
        insert prod;

        Product__c prod2 = new Product__c(
            name = 'ABC2',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123,
            Active__c = true,
            Product_Code__c = '12312',
            Product_Family__c = 'Wired'
        );
        insert prod2;

        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;

        list<Group> g = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'CRM_Agents'];
        Group gr = g[0];

        Test.startTest();
        
        WebToCaseFormDataService wtc = new WebToCaseFormDataService();
        
        // Assuming getProducts now has different parameters or returns a non-void value
        List<Product__c> prodlst = WebToCaseFormDataService.getProducts(acc.Id);  // Adjust if parameters have changed
        
        Case cs = new Case(
            Contact_Name__c = acc.Id,
            AWB__c = aggr2.Id,
            Product_Color__c = 'Black',
            Product__c = prod.Id,
            Serviceability__c = serv.Id,
            Bucket__c = 'New',
            OwnerId = gr.Id,
            SuppliedEmail = 'xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_Street__c = 'Address Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234567890'
        );
        insert cs;

        WebToCaseFormDataService.attachFile(cs.Id, 'file', 'cvd');

        Case cs2 = new Case(
            Contact_Name__c = acc.Id,
            AWB__c = aggr2.Id,
            Product_Color__c = 'Black',
            Product__c = prod.Id,
            Serviceability__c = serv.Id,
            Bucket__c = 'New',
            OwnerId = gr.Id,
            SuppliedEmail = 'xyz09@gmail.com',
            SuppliedPhone = '1234567890',
            SuppliedName = 'Test PersonAccount',
            Address_Street__c = 'Address Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India'
        );
        
        String jsn = JSON.serialize(cs2);
        WebToCaseFormDataService.submitCaseRec(jsn, 'street', 'Cityadd', 'Pincodeadd', 'Stateadd', 'Countryadd');

        cs2.Invoice_Number__c = 'Test123';
        jsn = JSON.serialize(cs2);
        WebToCaseFormDataService.submitCaseRec(jsn, 'street', 'Cityadd', 'Pincodeadd', 'Stateadd', 'Countryadd');

        Invoice__c invc = new Invoice__c(
            Name = 'Test123',
            No_of_Wired_Product__c = 2,
            Number_of_Cases__c = 0,
            Total_Number_of_Products_in_Invoice__c = 4,
            Total_Number_of_Cases__c = 0,
            Total_Number_of_Cases_All_Time__c = 0,
            Cases_For_Wired_Product_All_Time__c = 0
        );
        insert invc;

        WebToCaseFormDataService.submitCaseRec(jsn, 'street', 'Cityadd', 'Pincodeadd', 'Stateadd', 'Countryadd');

        cs2.Product__c = prod2.Id;
        jsn = JSON.serialize(cs2);
        WebToCaseFormDataService.submitCaseRec(jsn, 'street', 'Cityadd', 'Pincodeadd', 'Stateadd', 'Countryadd');

        WebToCaseFormDataService.fetchCaseNumber(cs.Id);

        Test.stopTest();
    }

    static testMethod void testPinCodeList() {
        String PinNumber;

        PinCodeList__c PinLst2 = new PinCodeList__c(
            PinCode__c = '452001',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh'
        );
        Insert PinLst2;

        Case cs = new Case(
            Pin_Code__c = PinLst2.PinCode__c,
            City__c = PinLst2.City__c,
            State__c = PinLst2.State__c,
            SuppliedEmail = 'xyz09@gmail.com'
        );
        insert cs;

        PinNumber = cs.Pin_Code__c;

        Test.startTest();
        WebToCaseFormDataService.getPinCodeData(PinNumber);
        Test.stopTest();
    }
}