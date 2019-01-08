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
            "tweetMode": "extened",
        },
        "path": "eaTwitterUserTimeline"
    },
    "type": "apex"
}
```


<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
