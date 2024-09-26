/**
@description       : SMS text body and template Ids.
@author            : Vishvambhar Singh
@group             : 
@last modified on  : 27-12-2021
@last modified by  : Vishvambhar Singh
Modifications Log 
Ver   Date         Author        		 Modification
1.0   27-12-2021   Vishvambhar Singh   	 Initial Version
1.1   28-01-2022   Vishvambhar Singh	 Modified for Blue Dart/India Post/Ship Rocket
**/
public class SMSTextUtility{
    
    public static final String shipmentInfoTempId = '1107164059999017101';
    public static final String orderDispatchTempId = '1107164059951902820';
    public static final String orderDeliveredTempId = '1107164059959013468';
    public static final String orderReceivedAtWarehouseTempId = '1107164059941499952';
    public static final String productPurchaseTempId = '1107164059924766243';
    public static final String orderTrackingOnly_D2CTempId = '1107164059932044057';
    public static final String outwardTeamShippedStatusTempId = '1107164217379787906';
    public static final String orderDispatchedViaIndiaPostTempId = '1107164277650644563';
    public static final String orderDispatchedViaBlueDartTempId = '1107164277642766410';
    public static final String orderDispatchedViaShipRocketTempId = '1107164277633432343';
    
    
    public static String shipmentInfoText (String custName , String caseNo){
        
        return 'Dear '+custName+', We request you to courier your product against the ticket id '+caseNo+' to our service centre at the address below; Address: Exotic Mile Private Limited, B-67, Wazirpur Industrial Area, New Delhi 110052. Packing & Courier Instruction: 1) Please send the complete product (charging case & buds/pods) without the accessories. 2) Do not send any accessories like USB Cable, extra cushions etc. 3) Kindly record a video while packing your product & handing over it to the courier company. 4) Mention your mobile number and Ticket ID '+caseNo+' on the courier package. 5) Do not forget to mention this phone number 9555602502, as the recipients contact detail on the courier slip. Thanks for your cooperation, Support Team, Boult Audio';

    }  

    public static String orderDispatchText (String custName , String caseNo){
        return 'Dear '+custName+', Please be informed that your product against ticket id '+caseNo+' has been successfully shipped by Boult Audio. Refer AWB number to track your shipment: https://www.shiprocket.in/shipment-tracking/ You will receive your product within 2-5 working days (Depending on Location) Thanks for your cooperation, Support Team, Boult Audio';
    }

    public static String orderDeliveredText (String custName , String caseNo){
        return 'Dear '+custName+', Please be informed that your product against ticket id '+caseNo+' has been successfully delivered by Boult Audio. Thanks for your cooperation, Support Team, Boult Audio'; 
    } 

    public static String orderReceivedAtWarehouseText (String custName , String caseNo){
        return 'Dear '+custName+', We have received your product against AWB number '+caseNo+'. Your product will be dispatched back to you within 24-48 working hours. Once the product is dispatched, the delivery will generally take between 2-5 working days (Depending on Location). Refer Ticket Id to track your ticket status: www.boultaudio.com/page/support Thanks for your cooperation, Support Team, Boult Audio';
    } 

    public static String productPurchaseText (String custName , String caseNo){
        return 'Dear '+custName+', We would like to welcome you to the Boult Audio Family. Your order '+caseNo+' has been successfully placed. You can track your order by clicking on the following link: https://www.shiprocket.in/shipment-tracking/ Thanks for your cooperation, Support Team, Boult Audio';
    }
    public static String orderTrackingOnly_D2CText (String custName , String caseNo){
        return 'Dear '+custName+' , We are glad to inform you that your Boult Audio product has been dispatched. Now you can track your order with AWB Number '+caseNo+' by clicking the following link: https://www.shiprocket.in/shipment-tracking/ Thanks for your cooperation, Support Team, Boult Audio';
    }
    public static String outwardTeamShippedStatusText (String custName){
        return 'Dear '+custName+', Greetings from Boult Audio! Please be informed your product is repaired/replaced and due for dispatch. We will share the tracking details once the product is shipped. Thank you for your patience and cooperation. Note In case of any issues we request you to kindly share an unboxing video of your shipment. Namaste, Boult Audio';
    }
    public static String orderDispatchedViaIndiaPostText (String custName , String CaseNo, String AWBNo){
        return 'Dear '+custName+', Please be informed that your product against ticket id '+caseNo+' has been successfully shipped by Boult Audio. Refer AWB '+AWBNo+' to track your shipment: https://www.indiapost.gov.in/_layouts/15/dop.portal.tracking/trackconsignment.aspx You will receive your product within 2-5 working days (Depending on Location) Thanks for your cooperation, Support Team, Boult Audio';
    }
    public static String orderDispatchedViaBlueDartText (String custName , String CaseNo, String AWBNo){
        return 'Dear '+custName+', Please be informed that your product against ticket id '+caseNo+' has been successfully shipped by Boult Audio. Refer AWB '+AWBNo+' to track your shipment: https://www.bluedart.com/home You will receive your product within 2-5 working days (Depending on Location) Thanks for your cooperation, Support Team, Boult Audio';
    }
    public static String orderDispatchedViaShipRocketText (String custName , String CaseNo, String AWBNo){
        return 'Dear '+custName+', Please be informed that your product against ticket id '+caseNo+' has been successfully shipped by Boult Audio. Refer AWB '+AWBNo+' to track your shipment: https://www.shiprocket.in/shipment-tracking/ You will receive your product within 2-5 working days (Depending on Location) Thanks for your cooperation, Support Team, Boult Audio';
    }
}