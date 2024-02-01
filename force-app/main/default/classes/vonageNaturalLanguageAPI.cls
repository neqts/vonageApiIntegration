public class vonageNaturalLanguageAPI {
    public class SentimentResult {
        public Double score { get; set; }
        public Double magnitude { get; set; }
    }

    public static SentimentResult analyzeSentiment(String text) {
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        String API_URL = 'https://language.googleapis.com/v1/documents:analyzeSentiment?key=' + meta.Google_NL_Api_Key__c;
        String sentimentAnalysisResult = makeApiRequest(API_URL, text);

        if (sentimentAnalysisResult != null) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(sentimentAnalysisResult);
            Map<String, Object> sentimentMap = (Map<String, Object>) result.get('documentSentiment');
            SentimentResult sentimentResult = new SentimentResult();
            sentimentResult.score = (Double) sentimentMap.get('score');
            sentimentResult.magnitude = (Double) sentimentMap.get('magnitude');
          
            return sentimentResult;
        } else {
            return null;
        }
    }

    public static List<String> analyzeEntities(String text) {
        Vonage_Integration_Data__mdt meta = VonageAuthorizationHelper.getVonageMainAppMetadataInfo();
        String API_URL = 'https://language.googleapis.com/v1/documents:analyzeEntities?key=' + meta.Google_NL_Api_Key__c;
        String entitiesAnalysisResult = makeApiRequest(API_URL, text);
    
        if (entitiesAnalysisResult != null) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(entitiesAnalysisResult);
            List<Object> entitiesList = (List<Object>) result.get('entities');
            List<String> locationEntities = new List<String>();
    
            for (Object entityObj : entitiesList) {
                Map<String, Object> entity = (Map<String, Object>) entityObj;
                String entityType = (String) entity.get('type');
                if (entityType != null && entityType.equals('LOCATION')) {
                    locationEntities.add((String) entity.get('name'));
                }
            }
    
            System.debug(locationEntities);
            return locationEntities;
        } else {
            return null;
        }
    }

    @future(callout=true)
    public static void analyzeSentimentAsync(String text, Id callId) {
        SentimentResult sentimentResult = analyzeSentiment(text);

        if (sentimentResult != null) {
            VonageCall__c callToUpdate = new VonageCall__c(Id = callId, Evaluation__c = String.valueOf(sentimentResult.score));
            update callToUpdate;
            
        }
    }
    @future(callout=true)
    public static void analyzeEntitiesAsync(String text, Id callId) {
        List<String> locationEntities = analyzeEntities(text);

        if (locationEntities != null && !locationEntities.isEmpty()) {
            VonageCall__c callToUpdate = new VonageCall__c(Id = callId, Issue_Location__c = locationEntities[0]);
            update callToUpdate;
        }
    }

    private static String makeApiRequest(String apiUrl, String text) {
        String requestBody = '{"document": {"content": "' + text + '", "type": "PLAIN_TEXT"}}';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);

        HttpResponse response = new Http().send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('Error Response: ' + response.getBody());
            return null;
        }
    }
}
