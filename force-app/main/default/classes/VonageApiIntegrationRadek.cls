public without sharing class VonageApiIntegrationRadek {
   // TO DO:
    // ADD KEYS TO CUSTOM SETTINGS
    // CREATE JWT TOKEN METHOD
    // GETANSWERURL
    private static final String VONAGE_API_KEY = '1624d013';
    private static final String VONAGE_API_SECRET = 'P5rPqMhBornIH1k8';
    private static final String VONAGE_VIRTUAL_NUMBER = '48694220856';
    private static final String VONAGE_VOICE_API_URL = 'https://api.nexmo.com/v1/calls';
    private static final String VONAGE_APPLICATION_ID = 'daca0301-3d73-42c6-b6da-852a8bc9c5b8';

    public static void makeVoiceCall(String toNumber, String text) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(VONAGE_VOICE_API_URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        // request.setHeader('Authorization', 'Basic ' + createAuthHeader());
        request.setHeader('Authorization', 'Bearer ' + '2a8bc9c5b8eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MDA1NjQ1MjUsImp0aSI6IjY4NDgwMzMwLTg4NWQtMTFlZS04MjZhLTBkNGQ1YjhjYzI2OSIsImFwcGxpY2F0aW9uX2lkIjoiZGFjYTAzMDEtM2Q3My00MmM2LWI2ZGEtODUyYThiYzljNWI4In0.bpwJUwN8cV_htSmabcEo2REaxhoinyJbourghRCCbGxXNm3LJRbb6pCENIITZ0zykoHqUUsjdMqbXe75k2AYSZ0DJLv2kSLU54Q9WcxIXuXF9wtAqM161HIPk_sfsIQhTS5ymrMOm6poSZFatrQEOvVplBZFf8R1Ig1hALA-dMFdQudnaz-4YkH80mQ4z2qHBNqinzNBUsUxtgaFqAlYS_WJaSJblapxxsa6TffNKCzIway7w9kWoRKrB2tvqc_G5X9FuOFJBbR5Y6OkmsI3DgaHmAF3P3KHhZ1WN8vkisvdHXpnvvghFuskPAcD67T6Ut9fYbsqMP4lYdZ28om4Bg');
        String requestBody = '{"to":[{"type":"phone","number":"' + toNumber + '"}],"from":{"type":"phone","number":"' + VONAGE_VIRTUAL_NUMBER + '"},"answer_url":["' + getAnswerUrl(text) + '"]}';
        request.setBody(requestBody);
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('Vonage Voice API Response: ' + response.getBody());
    }

    // private static String createJwtToken() {
    //     return '';
    // }

    private static String getAnswerUrl(String text) {
        return '' + EncodingUtil.urlEncode(text, 'UTF-8');
    }

    // private static String createAuthHeader() {
    //     String apiKeySecret = VONAGE_API_KEY + ':' + VONAGE_API_SECRET;
    //     Blob apiKeySecretBlob = Blob.valueOf(apiKeySecret);
    //     String encodedApiKeySecret = EncodingUtil.base64Encode(apiKeySecretBlob);
    //     return encodedApiKeySecret;
    // }
}