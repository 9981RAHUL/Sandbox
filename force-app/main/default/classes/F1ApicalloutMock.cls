@isTest
global class F1ApicalloutMock implements HttpCalloutMock{
    //implement this interface method
    global HTTPResponse respond(HTTPRequest request){
        //create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"serviceRequestNumber":"00687450","awbNo":"1584512412","deliveryPartnerName":"ShipRocket","deliveryStatus":"Pending","deliveryDateAndTime":"7/5/2023","ticketStatus":"1","rejectionReason":"","resolutionRemarks":"Mic Issue","dispatchDateAndTime":"7/5/2023"}');
        response.setStatusCode(200);
        return response;
    }
}