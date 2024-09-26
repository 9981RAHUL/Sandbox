/*******************************************************
 * @description        : Shiprocket Access Token
 * @author             : Sharad
 * @last modified on   : 27-05-2024
 * @last modified by   : 
 * @last modified date : 
*********************************************************/

public class Shiprocket_API {
    public static String Shiprocket_APIMethod()
    {
        String AccessToken;
        HttpResponse res = new Httpresponse();
        Http http = new Http();
        String endPointURL = 'https://apiv2.shiprocket.in/v1/external/auth/login';
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(endPointURL);
        req.setTimeout(120000);
        req.setBody('{"email" : "d2c@boultaudio.com","password" : "d2c@123D"}');
        if(!test.isrunningtest()){
                     res = http.send(req);
            system.debug('res'+res);

        }
        else
        {
            res.setbody('{"token": "eyJ"}');
            res.setstatuscode(200);
            system.debug('200');

        }
        if (res.getStatusCode() == 200) 
        {
            Map<String,object> mapObj = (Map<String,object>)JSON.deserializeUntyped(res.getBody());
            System.debug('mapObj is :'+mapObj.get('token'));
            System.debug('mapObj is :'+mapObj.get('token'));
            AccessToken = (String)mapObj.get('token');
            system.debug('Access Token'+AccessToken);
            return AccessToken;
        }
        else
        {
            return null;
          //  system.debug('null');
        }
    }
}