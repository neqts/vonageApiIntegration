public class vonageApiIntegration {

    private static final String API_ENDPOINT = 'https://api.nexmo.com/v1/calls';
    private static final String JWT_TOKEN = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbl9pZCI6ImRhY2EwMzAxLTNkNzMtNDJjNi1iNmRhLTg1MmE4YmM5YzViOCIsImlhdCI6MTcwMDU2OTgwNiwianRpIjoiMDQwZGM3MWUtNGJhNy00ZWJlLWE4MmItNTVjMWFhMTY2MmFlIiwiZXhwIjoxNzAwNTcwNzA2fQ.JBWkfhKis7SQ8OQNNzVadX3rpJKNKalIo-jXkucvLaOkhGGzWnU_7obFiDIyDFFaN6NahJIQFGvQlgdMAfH6L3RcBaxDvFPhIN2C6Gs1mf4v2ruYs7c_-hWpIDHXYOTUPPj8JZsmlgsvU2ywvJFgbsdQSG4hNKCXPwMKDX4KMeftrlZc5agxcA0SAs4t8hN0rWVKopDiDl4HEnpf1m3OrpWV-jMyi8vLd7ji0asdN5XhY3xmkIZotIZ0K0X78ew9-yfBlORf9dawZvv_0Iv7Jk22ZFQ4GXgjpvzLpM9vFBwEsffB8WJh4eIyv_X1U2jMZ1ralYUTuBuWB48aHkojIg'; 
    private static final String FROM_NUMBER = '48577370998';  
    private static final String TO_NUMBER = '48577370998';  

    public static void makeOutboundCall() {
        System.debug('JWT Token: ' + JWT_TOKEN);
        System.debug('API Endpoint: ' + API_ENDPOINT);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(API_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + JWT_TOKEN);

        String ncco = '[{"action": "talk", "text": "This is a test call from Salesforce Apex."}]';
        String requestBody = '{"to": [{"type": "phone", "number": "' + TO_NUMBER + '"}], "from": {"type": "phone", "number": "' + FROM_NUMBER + '"}, "ncco": ' + ncco + '}';
        req.setBody(requestBody);

        System.debug('Request Body: ' + requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            System.debug('Outbound call successfully initiated.');
        } else {
            System.debug('Error making outbound call. Status code: ' + res.getStatusCode());
            System.debug('Response: ' + res.getBody());
        }
    }
}