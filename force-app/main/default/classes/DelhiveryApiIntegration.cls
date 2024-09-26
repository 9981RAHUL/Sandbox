/**
* @description       : Delhivery Api Integration and Generating AWB No.
* @author            : Avinash
* @group             : 
* @last modified on  : 21-12-2022
* @last modified by  : Avinash
* Modifications Log 
* Ver   Date         Author          Modification
* 1.2   16-12-2022   Avinash        Updated Version
**/
public class DelhiveryApiIntegration {
    public case caserec{get;set;}
    public string id{get;set;}
    public string page1{get;set;}
    public WareHouse__c warehouse{get;set;}
    public string jsonString {get;set;}
    string apiToken = Label.DelhiveryApiToken;
    string orderCreateUrl = Label.DelhiveryApiCreateOrderUrl;
    
    /**
* @description 
* @author Avinash | 16-12-2022 
* @param controller : Current page controller
* @Constructor 
**/
    public DelhiveryApiIntegration(ApexPages.StandardController  controller){
        page1 = 'Delhivery_fwd';
        id=ApexPages.Currentpage().getParameters().get('id');   
        caserec = [SELECT CaseNumber, Id, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, City__c,
                   Owner.type,CountAwb__c,
                   Pin_Code__c, State__c, Product__c,Product__r.Name,Product__r.Product_Code__c,Product__r.Product_Family__c,
                   Product__r.Carton_Height_H__c,Product__r.Carton_Length_L__c,Product__r.Carton_Weight__c,
                   Product__r.Carton_Width_W__c,Product__r.Product_SKU__c,Product__r.Unit_Price__c,Product__r.Quantity_Box__c,
                   SR_Order__c,SR_Order__r.Name,
                   SR_Order__r.Cancel_Reason__c,SR_Order__r.Pickup_Generated__c,SR_Order__r.Delivery_Status__c,
                   SR_Order__r.Status__c,SR_AWB__c,
                   SR_Order__r.Shipment_ID__c,(select id,Status__c from SR_Orders__r), SR_AWB__r.Name,
                   Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.PersonEmail, 
                   Contact_Name__r.PersonMobilePhone, Courier_Partner_Name__c,Inward_Courier_Name__c,Outward_Courier_Name__c,
                   Contact_Name__r.ShippingStreet, Contact_Name__r.ShippingCity, 
                   Contact_Name__r.ShippingState,Return_Cancel_Reason__c, Forward_Cancel_Reason__c,
                   Contact_Name__r.ShippingPostalCode, Contact_Name__r.ShippingCountry,
                   AWB_No__c, Incoming_Courier_Agency__c, Incoming_AWB_Number__c ,Rate__c,WareHouse__c,WareHouse__r.Address__c,WareHouse__r.Phone__c
                   FROM Case where id =: id];
        
        warehouse = [Select Name,Email__c,City__c,Pin_Code__c,Country__c,Phone__c,Address__c,State__c,Registered_Name__c,Return_Address__c,	
                     Return_City__c,Return_Country__c,Return_Pin_Code__c,Return_State__c From WareHouse__c];
    }    
    
    // For Creating Order
    public PageReference CreateOrderDelhivery (){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(orderCreateUrl);
        request.setMethod('POST');
        ApexPages.Message MyMsg1;
        request.setHeader('Authorization', apiToken);
        request.setHeader('Content-Type', 'application/json'); 
        
        String body = 'format=json&data={"shipments":[{"add":"'+caserec.Address_street__c+'","address_type":"home","phone":"'+caserec.SuppliedPhone+'","products_desc":"'+caserec.Product__r.Name + '-'+caserec.Product__r.Product_SKU__c+'","weight":"'+caserec.Product__r.Carton_Weight__c+'","total_amount":"'+caserec.Product__r.Unit_Price__c+'","quantity":"'+caserec.Product__r.Quantity_Box__c+'","payment_mode":"Prepaid","name":"'+caserec.SuppliedName+'","seller_name":"Boult Audio","pin":"'+caserec.Pin_Code__c+'","order":"'+caserec.CaseNumber+'","country":"India","waybill":"","shipping_mode":"Surface"}],"pickup_location":{"name":"'+warehouse.Name+'","city":"'+warehouse.City__c+'","pin":"'+warehouse.Pin_Code__c+'","country":"India","phone":"'+warehouse.Phone__c+'","add":"'+warehouse.Address__c+'"}}';
        request.setBody(body);
        System.debug('---Body is--' + body);
        
        HttpResponse res =http.send(request);
        System.debug(res.getStatusCode());
        string jsonString = res.getBody();
        System.debug('---Response is--- :' + jsonString);
        System.JSONParser parser=JSON.createParser(jsonString);
        
        while(parser.nextToken()!=null){
            if(parser.getText()=='status'){
                parser.nextToken();
                system.debug(parser.getText());
                if (parser.getText() == 'Success'){
                    myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'Order Created Successfully');
                    
                    while(parser.nextToken()!=null){
                        if(parser.getText()=='waybill'){
                            parser.nextToken();
                            system.debug(parser.getText());
                            String awb = parser.getText();
                            System.debug('Awb No.'+awb);
                            caserec.AWB_No__c = awb ;
                        }
                        
                        update caserec;
                    }
                }
                
                else if(parser.getText() == 'Fail'){
                    String AWBB = caserec.AWB_No__c;
                    System.debug('awb'+AWBB);
                    if(AWBB != null){	
                        myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Order Already Created');  
                    }
                    else if(parser.getText() == 'Fail'){
                        myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Order Not Created');
                    }
                }
            }
        }
        ApexPages.addMessage(myMsg1);
        PageReference savepage = new PageReference('/apex/'+page1+'?id='+Id);
        return savepage;
    }
   
    
}