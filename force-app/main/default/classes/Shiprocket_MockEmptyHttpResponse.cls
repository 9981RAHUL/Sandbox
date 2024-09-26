public class Shiprocket_MockEmptyHttpResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);  // Simulate success with empty response
        res.setBody('[]');
        return res;
    }
}