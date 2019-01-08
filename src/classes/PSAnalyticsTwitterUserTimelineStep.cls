@RestResource(urlMapping='/eaTwitterUserTimeline')
global class PSAnalyticsTwitterUserTimelineStep {
    private static Map<String, String> monthMap;
    
    static {
        monthMap = new Map<String, String>();
        monthMap.put('Jan', '01');
        monthMap.put('Feb', '02');
        monthMap.put('Mar', '03');
        monthMap.put('Apr', '04');
        monthMap.put('May', '05');
        monthMap.put('Jun', '06');
        monthMap.put('Jul', '07');
        monthMap.put('Aug', '08');
        monthMap.put('Sep', '09');
        monthMap.put('Oct', '10');
        monthMap.put('Nov', '11');
        monthMap.put('Dec', '12');
    }
    
    @HttpPost   
    global static String getUserTimeline(String screenName, Integer count, Boolean trimUser, Boolean includeRetweets, String tweetMode) {
        PSTwitterUtils utils = new PSTwitterUtils();
        String tweets = utils.getUserTimeline(screenName, count, trimUser, includeRetweets, tweetMode);
        
        List<Tweets> tweetsList = (List<Tweets>)JSON.deserialize(tweets, List<Tweets>.class);
        
        List<ReturnItem> returnItemList = new List<ReturnItem>();
        
        for (Tweets tw : tweetsList)
        {
            ReturnItem ri = new ReturnItem();
            ri.createdAt = tw.getCreatedDTTM();
            ri.fullText = tw.full_text;
            ri.hashTags = tw.getDelimHashtag(',');
            ri.userMentions = tw.getDelimUserMentions(',');
            ri.mediaUrlHttps = tw.getDelimMediaUrl(',');
            ri.geo = tw.geo;
            ri.coordinates = tw.coordinates;
            
            ri.place = null;
            if (tw.place != null && tw.place.full_name != null) ri.place = tw.place.full_name;
            
            ri.retweetCount = tw.retweet_count;
            ri.favoriteCount = tw.favorite_count;
            ri.favorited = tw.favorited;
            ri.retweeted = tw.retweeted;
            ri.possiblySensitive = tw.possibly_sensitive;
            ri.lang = tw.lang;
            returnItemList.add(ri);
        }
        
        ReturnMetadata rm = new ReturnMetadata();
        rm.strings = new List<String>{'createdAt', 'fullText', 'hashTags', 'userMentions', 'geo', 'coordinates', 'favorited', 'retweeted', 'possiblySensitive', 'lang'};
        rm.numbers = new List<String>{'retweetCount', 'favoriteCount'};
        rm.groups = new List<String>();
        
        PackagedReturnItem pri = new PackagedReturnItem();
        pri.data = returnItemList;
        pri.metadata = rm;
        return JSON.serialize(pri);
    }
    
    public class Tweets {
        public String created_at;
        public String full_text; 
        public String geo; 
        public String coordinates; 
        public Place place;
        public Integer retweet_count;
        public Integer favorite_count;
        public String favorited;
        public String retweeted;
        public String possibly_sensitive;
        public String lang;
        
        public Entity entities;
        
        
        
        public String getCreatedDTTM()
        {
            if (created_at != null && created_at.length() == 30)
            {
                String[] vals = created_at.split(' ');
                
                return(vals[5] + '-' + monthMap.get(vals[1]) + '-' + vals[2] + 'T' + vals[3] + 'Z');
                //"EEE MMM dd HH:mm:ss Z yyyy"
            }
            
            return created_at;
        }
        
        public String getDelimHashtag(String delim)
        {
            if (entities != null && entities.hashtags != null && entities.hashtags.size() > 0)
            {
                String resp = null;
                for (Hashtag HT : entities.hashtags)
                {
                    if (resp == null)
                    {
                        resp = ht.text;
                    }
                    else
                    {
                        resp += delim + ht.text;
                    }
                }
                
                return resp;
            }
            
            return null;
        }
        
        public String getDelimUserMentions(String delim)
        {
            if (entities != null && entities.user_mentions != null && entities.user_mentions.size() > 0)
            {
                String resp = null;
                for (UserMention um : entities.user_mentions)
                {
                    if (resp == null)
                    {
                        resp = um.screen_name;
                    }
                    else
                    {
                        resp += delim + um.screen_name;
                    }
                }
                
                return resp;
            }
            
            return null;            
        }
        
        public String getDelimMediaUrl(String delim)
        {  
            if (entities != null && entities.media != null && entities.media.size() > 0)
            {
                String resp = null;
                for (Media m : entities.media)
                {
                    if (resp == null)
                    {
                        resp = m.media_url_https;
                    }
                    else
                    {
                        resp += delim + m.media_url_https;
                    }
                }
                
                return resp;
            }
            return null;            
        }
    }
    
    public class Entity {
        public List<Hashtag> hashtags;
        public List<UserMention> user_mentions;
        public List<Media> media;
    }
    
    public class Media {
        public String media_url;
        public String media_url_https;
    }
    
    public class UserMention {
        public String screen_name;
        public String name;
    }
    
    public class Hashtag {
        public String text;
    }
    
    public class Place {
        public String place_type;
        public String name;
        public String full_name;
        public String country_code;
        public String country;
    }
    
    public class ReturnItem {
        public String createdAt;
        public String fullText;
        public String hashTags;
        public String userMentions;
        public String mediaUrlHttps;
        public String geo;
        public String coordinates;
        public String place;
        public Integer retweetCount;
        public Integer favoriteCount;
        public String favorited;
        public String retweeted;
        public String possiblySensitive;
        public String lang;
    }
    
    public class ReturnMetadata {
        
        public List<String> strings;
        public List<String> numbers;
        public List<String> groups;
        
        public ReturnMetadata() {
            
        }
        
        public ReturnMetadata(List<String> strings, List<String> numbers, List<String> groups) {
            this.strings = strings;
            this.numbers = numbers;
            this.groups = groups;
        }
    }
    
    public class PackagedReturnItem {
        public List<ReturnItem> data;
        public ReturnMetadata metadata;
    }  
}