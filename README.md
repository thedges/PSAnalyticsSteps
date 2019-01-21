# PSAnalyticsSteps
Various Apex code to provide Einstein Analytics custom steps

Post package installation steps:
  1. To use the Twitter Steps, make sure you have a Twitter developer account at https://developer.twitter.com. 
     - Create an "app" and get the 'apiKey' and 'apiSecretKey'.
  2. Go to <b>Setup > Custom Code > Custom Settings</b>.
     - Click the 'Manage' link next to the 'TwitterAPI' entry
     - Click the 'New' button at top of TwitterAPI Custom Setting screen to create a new default org configuration. Enter your apiKey and apiSecretKey as defined in first step.

<b>Twitter User Timeline Step</b>

To use the Twitter User Timeline step in your Analytics dashboard according to [Apex Step Setup](https://developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_json.meta/bi_dev_guide_json/bi_dbjson_steps_types_apex.htm), perform the following steps in your dashboard JSON file:

```
"GetUserTimeline": {
    "query": {   
        "body": {
            "screenName": "NYPDnews",
            "count": 100,
            "trimUser": true,
            "includeRetweets": false,
            "tweetMode": "extended",
        },
        "path": "eaTwitterUserTimeline"
    },
    "type": "apex"
}
```

This will return a JSON object like the following for processing in the dashboard JSON file:

```
{  
   "metadata":{  
      "strings":[  
         "createdAt",
         "fullText",
         "hashTags",
         "userMentions",
         "geo",
         "coordinates",
         "favorited",
         "retweeted",
         "possiblySensitive",
         "lang"
      ],
      "numbers":[  
         "retweetCount",
         "favoriteCount"
      ],
      "groups":[  

      ]
   },
   "data":[  
      {  
         "userMentions":"NYPDTips",
         "retweeted":"false",
         "retweetCount":48,
         "possiblySensitive":"false",
         "place":"New York, NY",
         "mediaUrlHttps":"https://pbs.twimg.com/ext_tw_video_thumb/1082689736853151746/pu/img/vA0bL1vG5jVirh34.jpg",
         "lang":"en",
         "hashTags":"NYPDconnecting",
         "geo":null,
         "fullText":"WANTED FOR ROBBERY: Unknown male, last seen wearing a dark coat with fur-lined hood, dark sweatpants w/ red stripes &amp; dark boots. On 1/7/19 at 10:50 am he robbed a 77 year-old at gunpoint in the area of Southern Blvd &amp; Barretto in the Bronx. Info? #NYPDconnecting Call @NYPDTips at 800-577-TIPS. https://t.co/kysc0MtVwf",
         "favorited":"false",
         "favoriteCount":36,
         "createdAt":"2019-01-03T13:00:25Z",
         "coordinates":null
      },
      ...
     ]
  }
```

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
