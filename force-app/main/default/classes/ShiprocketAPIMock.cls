@isTest
global class ShiprocketAPIMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a new HTTPResponse object
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        
        // Simulate a Shiprocket API response
        res.setBody('[{"tracking_data": {"track_status": 1, "shipment_status": 7, "shipment_track": [{"id": 459167096, "awb_code": "SF1006647634KAC", "courier_company_id": 174, "shipment_id": 547479890, "order_id": 549375484, "current_status": "Delivered"}]}}]');
        
        return res;
    }
}