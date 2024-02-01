public class VonageConversationApi {

    private static final String CONVERSATION_API_ENDPOINT = 'https://api.nexmo.com/v0.3/conversations';

    @AuraEnabled(cacheable=true)
    public static String createConversation(String caseRecordId) {
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CONVERSATION_API_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + meta.JWT_token__c);

        String requestBody = '{"display_name": "' + caseRecordId + '"}';
        req.setBody(requestBody);

        System.debug('Request body: ' + requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req);

        if (res.getStatusCode() == 201) {
            System.debug('conversation created successfully: ' + res.getBody());
            return res.getBody();
        } else {
            System.debug('error creating conversation: ' + res.getStatusCode());
            System.debug('response: ' + res.getBody());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static String updateConversation(String conversationId, List<Map<String, String>> additionalProperties) {
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CONVERSATION_API_ENDPOINT + '/' + conversationId);
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + meta.JWT_token__c);
    
        List<String> customDataList = new List<String>();
        for (Map<String, String> messageMap : additionalProperties) {
            customDataList.add('"' + messageMap.get('id') + '": "' + messageMap.get('text') + '"');
        }
    
        String customData = '"custom_data": {' + String.join(customDataList, ', ') + '}';
    
        String requestBody = '{"properties": {"ttl": 60, "type": "string", ' + customData + '}}';
        req.setBody(requestBody);
    
        System.debug('request Body: ' + requestBody);
    
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req);
    
        if (res.getStatusCode() == 200) {
            System.debug('conversation updated successfully: ' + res.getBody());
            return res.getBody();
        } else {
            System.debug('error updating conversation: ' + res.getStatusCode());
            System.debug('response: ' + res.getBody());
            return null; 
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getConversationById(String conversationId) {
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CONVERSATION_API_ENDPOINT + '/' + conversationId);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + meta.JWT_token__c);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            System.debug('conversation retrieved successfully: ' + res.getBody());
            return res.getBody();
        } else {
            System.debug('error retrieving conversation: ' + res.getStatusCode());
            System.debug('response: ' + res.getBody());
            return null;
        }
    }


}