@isTest
global class GenrateLabelTest implements HttpCalloutMock {
    public static string body;
    public static integer statuscode;
    public static string id;
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('http://example.com/example/test', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
    
    @testSetup
    static void testData(){
        Phase2Start__c pdate= new Phase2Start__c(
Start_Date__c = DateTime.now()
);
        insert pdate;
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
        Product__c prod = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123,
            Active__c = true,
            Product_Code__c = '123123',
            Product_Family__c = 'Wired'
        );
        insert prod;
        Product__c prod2 = new Product__c(
            name = 'ABC2',
            Product_Code__c = '123123',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123,
            Active__c = true,
            Product_Family__c = 'TWS'
        );
        insert prod2;
        Phase2__c phase2 = new Phase2__c(IsActive__c = true);
        insert phase2;
        Authentication_Shiprocket__c authentication1 = new Authentication_Shiprocket__c(
            User_name__c = 'test',password__c = 'test' );
        insert authentication1;
        Boult_Warehouse__c warehouse = new Boult_Warehouse__c(
            Address__c = 'test add',City__c = 'patna',State__c = 'bihar',Phone__c = '9810474332',
            Zipcode__c = 800001,Pickup_Location_Id__c = 201306,Channel_Id__c='abc',
            pickup_location__c = 'delhi' );
        insert warehouse;
        Maximum_SR_Rate__c Maximum_SR_Rate = new Maximum_SR_Rate__c(rate__c = 100);
        insert Maximum_SR_Rate;
        case caserec = new case(SuppliedName = 'Test1', SuppliedEmail='test2@test.com', SuppliedPhone='9087654321',
                                Address_street__c = '91/4 ias colony', City__c = 'patna',                
                                Pin_Code__c = '800001', State__c = 'bihar',
                                Product__c = prod.id,
                                Contact_Name__c = acc.id
                               );
        insert caserec;
        
        SR_Order__c ord = new SR_Order__c(Name = 'testID', Shipment_ID__c='109100105');
        insert ord;
        
    }
    
    
    static testmethod void test1()
    {
        ShipRocketApiCalloutTest.body = '{'+
            '"label_created": 1,'+
            '"label_url": "https://kr-shipmultichannel.s3.ap-southeast-1.amazonaws.com/25149/labels/shipping-label-16104408-788830567028.pdf",'+
            '"response": "Label has been created and uploaded successfully!",'+
            '"not_created": []'+
            '}';
        
        
        
        ShipRocketApiCalloutTest.statuscode = 422;
        Test.setMock(HttpCalloutMock.class, new ShipRocketApiCalloutTest());
        test.startTest();
        //Case cs = [Select Id, caseNumber, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, State__c, Product__c from case where SuppliedName = 'Test1'];
        list<case> casereclst = [SELECT CaseNumber, Id, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, City__c,
                                 owner.type,
                                 Pin_Code__c, State__c, Product__c,Product__r.Name,Product__r.Product_Code__c,Product__r.Product_Family__c,SR_Order__c,SR_Order__r.Name,
                                 SR_Order__r.Cancel_Reason__c,SR_Order__r.Delivery_Status__c,SR_Order__r.Status__c,SR_AWB__c,
                                 SR_Order__r.Shipment_ID__c,(select id,Status__c from SR_Orders__r), SR_AWB__r.Name,
                                 Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.PersonEmail, 
                                 Contact_Name__r.PersonMobilePhone, Courier_Partner_Name__c,Inward_Courier_Name__c,Outward_Courier_Name__c,
                                 Contact_Name__r.ShippingStreet, Contact_Name__r.ShippingCity, 
                                 Contact_Name__r.ShippingState,Return_Cancel_Reason__c, Forward_Cancel_Reason__c,
                                 Contact_Name__r.ShippingPostalCode, Contact_Name__r.ShippingCountry, 
                                 AWB_No__c, Incoming_Courier_Agency__c, Incoming_AWB_Number__c ,Rate__c
                                 FROM Case ];
        ApexPages.currentPage().getParameters().put('id',(casereclst[0].id));
        ForwardShipRocketApiCallout frwdcls = new ForwardShipRocketApiCallout(null);
        //frwdcls.Label();
        ShipRocketApiCalloutTest.statuscode = 200;
        frwdcls.Label();
        test.stopTest();       
    }   
}