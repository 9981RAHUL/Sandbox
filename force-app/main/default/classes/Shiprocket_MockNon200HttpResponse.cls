@isTest
global class Shiprocket_MockNon200HttpResponse implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"error": "Error Response"}');
        response.setStatusCode(400); // Non-200 status code
        return response;
    }
}