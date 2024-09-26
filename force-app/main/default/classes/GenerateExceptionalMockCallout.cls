global class GenerateExceptionalMockCallout implements HttpCalloutMock {
        // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {       
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(422);
        return res;
    }

}