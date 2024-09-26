// Mock class to simulate HTTP callouts
global class Shiprocket_API_Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Simulate the API response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"tracking_data": {"track_status": 1, "shipment_status": 7, "shipment_track": [{"id": 459167096, "awb_code": "SF1006647634KAC", "current_status": "Delivered"}]}}]');
            res.setStatusCode(200);
            return res;
        }
    }