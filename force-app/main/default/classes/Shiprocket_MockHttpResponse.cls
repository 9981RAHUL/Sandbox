public class Shiprocket_MockHttpResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"tracking_data": {"track_status": 1, "shipment_status": 7, "shipment_track": [{"id": 459167096, "awb_code": "SF1006647634KAC", "courier_company_id": 174, "shipment_id": 547479890, "order_id": 549375484, "current_status": "Delivered"}]}}]');
        res.setStatusCode(200);
        return res;
    }
}