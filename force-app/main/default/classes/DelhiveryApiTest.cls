@isTest
public class DelhiveryApiTest {
    public static String body;  
    public static integer statuscode;
    public static string id;
    @testSetup
    private static void Data()
    {
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
        SR_Order__c srorderrec = new SR_Order__c(name = 'DEMO123');
        insert srorderrec;
        case caserec = new case(SuppliedName = 'Test1', SuppliedEmail='test2@test.com', SuppliedPhone='9087654321',
                                Address_street__c = '91/4 ias colony', City__c = 'patna',                
                                Pin_Code__c = '800001', State__c = 'bihar',
                                Product__c = prod.id,
                                Contact_Name__c = acc.id,
                                SR_Order__c = srorderrec.id,
                                Product_Problem__c = 'Battery Issue'
                               );
        insert caserec;
        DelhiveryApiTest.id = caserec.id;
        
        WareHouse__c wh = new WareHouse__c(Phone__c = '8817115911',
                                           City__c= 'New Delhi',
                                           Name = 'Exotic Mile Private Limited',
                                           Pin_Code__c= '110052',
                                           Address__c= 'B-67, Wazirpur Industrial Area, New Delhi',
                                           Country__c= 'India',
                                           Email__c= 'admin@boultaudio.com',
                                           Registered_Name__c= 'EXOTICB2C-B2C',
                                           Return_Address__c= 'B-67, Wazirpur Industrial Area, New Delhi',
                                           Return_Pin_Code__c= '110052',
                                           Return_City__c= 'New Delhi',
                                           Return_State__c= 'Delhi',
                                           Return_Country__c= 'India');
        
        insert wh;
    }
    
    @isTest
    private static void Delhivery()
    {
        
        DelhiveryApiTest.body = 'format=json&data={"shipments":[{"add":"Vijay Nagar","address_type":"home","phone":"9424903081","payment_mode":"Prepaid","name":"Devendra","pin":"452001","order":"1","country":"India","waybill":"89663322114477","shipping_mode":"Surface"}],"pickup_location":{"name":"Exotic","city":"Indore","pin":"452010","country":"India","phone":"9424903081","add":"Vijay Nagar"}}';
        
        Test.setMock(HttpCalloutMock.class, new DelhiveryApiMock());
        test.startTest();
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
        DelhiveryApiIntegration delcls = new DelhiveryApiIntegration(null);
        delcls.CreateOrderDelhivery();
        DelhiveryApiTest.statuscode = 200;
        test.stopTest();
        
    }
}