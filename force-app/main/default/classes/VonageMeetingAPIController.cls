public with sharing class VonageMeetingAPIController {
    private static final String CONVERSATION_API_ENDPOINT = 'https://api-eu.vonage.com/v1/meetings/rooms';
    
    public class RoomParameters {
        @InvocableVariable(required=true)
        public string roomName;
        @InvocableVariable(required=true)
        public Datetime expirationDatetime;
        @InvocableVariable(required=true)
        public String caseRecordID;
    }
    public VonageMeetingAPIController() {

    }

    @InvocableMethod(label='Create Vonage meeting room' description='Creates room for an online meeting' category='Call')
    public static List<String> createMeetingRoom(List<RoomParameters> params) {
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CONVERSATION_API_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + meta.JWT_token__c);

        System.debug('TEST meeting api ' + params);

        String dateInput = '' + params[0].expirationDatetime;
        String dateInputGMT = String.valueOfGMT(params[0].expirationDatetime);
        System.debug('dateInputGMT ' + dateInputGMT);

        String startDate2 = params[0].expirationDatetime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + '+00:00';


        String requestBody = '{"display_name": "' + params[0].roomName + '", "type": "long_term", "expires_at": "'+ startDate2 + '"}';
        req.setBody(requestBody);

        System.debug('Request body: ' + requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req);

        if (res.getStatusCode() == 201) {
            System.debug('TEST params[0].caseRecordID api ' + params[0].caseRecordID);

            String result = createVonageMeetingRecord(params[0].caseRecordID, res.getBody());
            System.debug('Meeting room created successfully: ' + result);
            return new List<String>{result};
        } else {
            System.debug('error creating meeting room: ' + res.getStatusCode());
            System.debug('response: ' + res.getBody());
            return null;
        }
    }

    private static String createVonageMeetingRecord(String caseID, String response) {
        System.debug('CASE ID passed: ' + caseID);
        Map<String, Object> parsedData = (Map<String, Object>)JSON.deserializeUntyped(response);
      
        String id = (String)parsedData.get('id');
        String displayName = (String)parsedData.get('display_name');
        String expiresAt = (String)parsedData.get('expires_at');
        String guestUrl = '';
        String hostUrl='';
        
        Map<String, Object> links = (Map<String, Object>)parsedData.get('_links');
        if (links != null) {
            Map<String, Object> guestUrlMap = (Map<String, Object>)links.get('guest_url');
            if (guestUrlMap != null) {
                guestUrl = (String)guestUrlMap.get('href');
            }
            
            Map<String, Object> hostUrlMap = (Map<String, Object>)links.get('host_url');
            if (hostUrlMap != null) {
                hostUrl = (String)hostUrlMap.get('href');
            }
        }
        Vonage_Meeting__c meeting;
        try {
            String data = expiresAt;
            Datetime dt = (DateTime)JSON.deserialize('"' + data + '"', DateTime.class);
            meeting = new Vonage_Meeting__c(Case__c = caseID,Guest_URL__c = guestUrl, Host_URL__c = hostUrl, Meeting_ID__c = id, Name = displayName, Expiration_date__c = dt);
            insert meeting;
        } catch (DMLException ex) {
           System.debug('Error' );
        }
        return 'Meeting succesfully created' + meeting.Id ;
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