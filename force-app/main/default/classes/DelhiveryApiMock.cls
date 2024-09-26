@isTest
global class DelhiveryApiMock implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request){
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"cash_pickups_count":0.0,"package_count":1,"upload_wbn":"UPL17698315677101935290","replacement_count":0,"pickups_count":0,"packages":[{"status":"Success","client":"EXOTICB2C-B2C","sort_code":"KCF/MDL","remarks":[""],"waybill":"6026110002144","cod_amount":0.0,"payment":"Pre-paid","serviceable":true,"refnum":"1"}],"cash_pickups":0.0,"cod_count":0,"success":true,"prepaid_count":1,"cod_amount":0.0}');
        response.setStatusCode(200);
        return response; 
    }

}