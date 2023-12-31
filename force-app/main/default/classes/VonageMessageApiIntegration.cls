public with sharing class VonageMessageApiIntegration {
    
    private static final String API_ENDPOINT = 'https://rest.nexmo.com/sms/json';  

    @AuraEnabled
    public static void sendSummaryMessage(String caseId){
        Case testCase = VonageCaseSelector.selectCaseById(caseId);
        String message = createSummaryMessage(testCase.CaseNumber, testCase.Subject);
        createMessageHTTPRequest('Vonage APIs', '48694220856', message);
    }

    public static void createMessageHTTPRequest(String fromMessage, String toMessage, String message){
        System.debug('API Endpoint: ' + API_ENDPOINT);
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(API_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    
        String requestBody = 'from=' + fromMessage + '&text=' + message + '&to=' + toMessage + '&api_key=6d32af05&api_secret=iGW2pRcmefNf1shT';
        req.setBody(requestBody);
        
        System.debug('Request Body: ' + requestBody);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req);
    
        if (res.getStatusCode() == 200) {
            System.debug('Successfully send.');
        } else {
            System.debug('Error : ' + res.getStatusCode());
            System.debug('Response: ' + res.getBody());
        }
    }
    
    public static string createSummaryMessage(String caseNumber, String caseSubject){
        return 'Summary for case with number: ' + caseNumber + ', with subject: ' + caseSubject;
    }
}