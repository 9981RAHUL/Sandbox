public class Shiprocket_MockFailedHttpResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(500);  // Simulate a failure response
        res.setBody('{"error": "Internal Server Error"}');
        return res;
    }
}