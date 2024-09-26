@isTest
global class ShipRocketApiCalloutTest implements HttpCalloutMock {
    public static string body;
    public static integer statuscode;
    public static string id;
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(ShipRocketApiCalloutTest.body);
        res.setStatusCode(ShipRocketApiCalloutTest.statuscode);
        return res;
    }
    
 @testSetup 
    static void setup() {
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
                     Zipcode__c = 800001,Pickup_Location_Id__c = 201306,Channel_Id__c='abc',Warehouse_Email__c= 'admin@boultaudio.com' ,Warehouse_Phone__c = '9560682910',
                     pickup_location__c = 'delhi' );
    insert warehouse;
     Maximum_SR_Rate__c Maximum_SR_Rate = new Maximum_SR_Rate__c(rate__c = 100);
    insert Maximum_SR_Rate;
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
        ShipRocketApiCalloutTest.id = caserec.id;
    }
    @isTest 
    static void testMethod1() {
      
   ShipRocketApiCalloutTest.body = '{'+
  '"order_id": 16161616,'+
  '"shipment_id": 15151515,'+
  '"status": "NEW",'+
  '"status_code": 1,'+
  '"onboarding_completed_now": 0,'+
  '"awb_code": null,'+
  '"courier_company_id": null,'+
  '"courier_name": null'+
  '}';
        
    ShipRocketApiCalloutTest.statuscode = 422;
    Test.setMock(HttpCalloutMock.class, new ShipRocketApiCalloutTest());
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
    ForwardShipRocketApiCallout frwdcls = new ForwardShipRocketApiCallout(null);
    frwdcls.CreateForwardOrder();
    //ForwardShipRocketApiCallout frwdcls2 = new ForwardShipRocketApiCallout(null);
    frwdcls.CheckForwardServicebility();
    ShipRocketApiCalloutTest.statuscode = 200;
    frwdcls.CreateForwardOrder();
    //frwdcls.CheckForwardServicebility();
    test.stopTest();
    
}
    @isTest 
    static void testMethodAWB() {
   ShipRocketApiCalloutTest.body = '{'+
  '"awb_assign_status": 1,'+
  '"response": {'+
    '"data": {'+
      '"courier_company_id": 10,'+
      '"awb_code": "109139884724",'+
      '"cod": 0,'+
      '"order_id": 16241076,'+
      '"shipment_id": 16090281,'+
      '"awb_code_status": 1,'+
      '"assigned_date_time": {'+
        '"date": "2019-08-01 12:41:46.281791",'+
        '"timezone_type": 3,'+
       ' "timezone": "Asia/Kolkata"'+
      '},'+
      '"applied_weight": 2.5,'+
      '"company_id": 25149,'+
      '"courier_name": "Delhivery",'+
      '"child_courier_name": null'+
          '}}}';
  

        
    ShipRocketApiCalloutTest.statuscode = 422;
    Test.setMock(HttpCalloutMock.class, new ShipRocketApiCalloutTest());
        
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
    ForwardShipRocketApiCallout frwdcls = new ForwardShipRocketApiCallout(null);
    frwdcls.CheckForwardServicebility();
    frwdcls.FwdCreateAWB();
    ShipRocketApiCalloutTest.statuscode = 200;
    frwdcls.FwdCreateAWB();
    test.stopTest();
    
}
     @isTest 
    static void testMethodTrak() {
   ShipRocketApiCalloutTest.body ='{'+
  '"tracking_data": {'+
   ' "track_status": 1,'+
    '"shipment_status": 3,'+
    '"shipment_track": [{'+
     '   "id": 8087109,'+
      '  "awb_code": "788830567028",'+
       ' "courier_company_id": 2,'+
        '"shipment_id": null,'+
        '"order_id": 16255275,'+
        '"pickup_date": null,'+
        '"delivered_date": null,'+
        '"weight": "2.5",'+
        '"packages": 1,'+
        '"current_status": "Pickup Generated",'+
        '"delivered_to": "New Delhi",'+
        '"destination": "New Delhi",'+
        '"consignee_name": "Naruto",'+
        '"origin": "Jammu",'+
        '"courier_agent_details": null'+
     ' }    ],'+
    '"shipment_track_activities": [ {'+
     '   "date": "2019-08-01 05:20:55",'+
      '  "activity": "Shipment information sent to FedEx - OC",'+
       ' "location": "NA"'+
      '}    ],'+
    '"track_url": "https://app.shiprocket.in/tracking/awb/788830567028"'+
  '}}';
  

        
    ShipRocketApiCalloutTest.statuscode = 422;
    Test.setMock(HttpCalloutMock.class, new ShipRocketApiCalloutTest());
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
    ForwardShipRocketApiCallout frwdcls = new ForwardShipRocketApiCallout(null);
    frwdcls.FwdOrderTracking();
    ShipRocketApiCalloutTest.statuscode = 200;
    frwdcls.FwdOrderTracking();
    test.stopTest();
    
}
     /*  @isTest 
    static void testMethodLabel() {
   ShipRocketApiCalloutTest.body = '{'+
  '"label_created": 1,'+
  '"label_url": "https://kr-shipmultichannel.s3.ap-southeast-1.amazonaws.com/25149/labels/shipping-label-16104408-788830567028.pdf",'+
  '"response": "Label has been created and uploaded successfully!",'+
  '"not_created": []'+
  '}';
  

        
    ShipRocketApiCalloutTest.statuscode = 422;
    Test.setMock(HttpCalloutMock.class, new ShipRocketApiCalloutTest());
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
    ForwardShipRocketApiCallout frwdcls = new ForwardShipRocketApiCallout(null);
    frwdcls.Label();
    ShipRocketApiCalloutTest.statuscode = 200;
    frwdcls.Label();
    test.stopTest();
    
}*/
   

    
    @isTest 
    static void testCreateReturnOrder() {
   ShipRocketApiCalloutTest.body = '{'+
  '"order_id": 16525854,'+
  '"shipment_id": 16370682,'+
  '"status": "RETURN PENDING",'+
  '"status_code": 21'+
  '}';
        
    ShipRocketApiCalloutTest.statuscode = 422;
    Test.setMock(HttpCalloutMock.class, new ShipRocketApiCalloutTest());
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
    ShipRocketApiCallout frwdcls = new ShipRocketApiCallout(null);
    frwdcls.CreateReturnOrder();
    //ForwardShipRocketApiCallout frwdcls2 = new ForwardShipRocketApiCallout(null);
    ShipRocketApiCalloutTest.statuscode = 200;
    frwdcls.CreateReturnOrder();
    //frwdcls.CheckForwardServicebility();
    test.stopTest();
    
}
       @isTest 
    static void testPickup() {
   ShipRocketApiCalloutTest.body = '{'+
  '"order_id": 16525854,'+
  '"shipment_id": 16370682,'+
  '"status": "RETURN PENDING",'+
  '"status_code": 21'+
  '}';
        
    ShipRocketApiCalloutTest.statuscode = 422;
    Test.setMock(HttpCalloutMock.class, new ShipRocketApiCalloutTest());
    test.startTest();
        list<case> casereclst = [SELECT CaseNumber, Id, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, City__c,
                owner.type,SR_Order__r.Pickup_Generated__c,
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
    frwdcls.FwdPickup();
    ShipRocketApiCalloutTest.statuscode = 200;
    frwdcls.FwdPickup();
    test.stopTest();
    
}
}