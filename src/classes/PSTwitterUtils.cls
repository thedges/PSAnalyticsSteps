public class PSTwitterUtils {
    private String accessToken;
    
    // /////////////////////////////////////////////////////////////////////////////////////////////// //
    // Provide the 'API key' and 'API secret key' for an app created in your Twitter developer account //
    // at https://developer.twitter.com                                                                //
    //                                                                                                 //
    // Also make sure to create a Remote Site Setting in Salesforce for https://api.twitter.com        //
    // /////////////////////////////////////////////////////////////////////////////////////////////// //
    public PSTwitterUtils(String apiKey, String apiSecretKey)
    {
       setAccessToken(apiKey, apiSecretKey);
    }
    
    public PSTwitterUtils()
    {
        this(TwitterAPI__c.getInstance().apiKey__c, TwitterAPI__c.getInstance().apiSecretKey__c);
    }
    
    private void setAccessToken(String apiKey, String apiSecretKey)
    {
        accessToken = null;
        
        String keyencoded = EncodingUtil.urlEncode(apiKey,'UTF-8');
        String secretkeyencoded = EncodingUtil.urlEncode(apiSecretKey, 'UTF-8');
        String sFinal = keyencoded + ':' + secretkeyencoded;
        Blob headerValue = Blob.valueOf(sFinal);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twitter.com/oauth2/token');
        req.setMethod('POST');
        
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setBody('grant_type=client_credentials');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        JSONParser parser = JSON.createParser(res.getBody());
        while(parser.nextToken() != null)
        {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME)
            {
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'access_token')
                {
                    accessToken = parser.getText();
                }
                
            }
        }
        
        //System.debug('accessToken=' + accessToken);        
    }
    
    public String getUserTimeline(String screenName, Integer count, Boolean trimUser, Boolean includeRetweets, String tweetMode)
    {
        if (count == null) count = 100;
        if (trimUser == null) trimUser = true;
        if (includeRetweets == null) includeRetweets = false;
        if (tweetMode == null || tweetMode.length() == 0) tweetMode = 'extended';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=' + screenName + 
                        '&count=' + count + '&trim_user=' + trimUser + '&include_rts=' + includeRetweets + '&tweet_mode=' + tweetMode);
        req.setMethod('GET');
        
        //Call Bearer token Method
        String authorizationHeader = 'Bearer ' + accessToken;
        req.setHeader('Authorization', authorizationHeader);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        String tweets = res.getBody();
        //System.debug('tweets=' + tweets);
        
        return tweets;
    }
}