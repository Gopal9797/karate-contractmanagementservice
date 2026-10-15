Feature: Retrieve the FrontEnd & BackEnd Rest Request & Response using ElasticSearch API

  Background:
    * def ElasticRequest = read('ElasticRequest.json')
    * def auth =
     """
       function(creds) {
       var temp = creds.username + ':' + creds.password;
       var Base64 = Java.type('java.util.Base64');
       var encoded = Base64.getEncoder().encodeToString(temp.getBytes());
       return 'Basic ' + encoded;
        }
     """

    @ElasticSearchAPI
    Scenario: Retrieve CMS Audit Logs using TrackingID
      Given url 'https://xcplowerkibana-asa-b-001.logging.comcast.net:9200/_search'
      And header Authorization = call auth { username: 'espteamc', password: 'TjiEHA8llM' }
      And request ElasticRequest
#      * set ElasticRequest.query.bool.filter[0].multi_match.query = global_extension.currentTime
      * set ElasticRequest.query.bool.filter[0].multi_match.query = 'CurrenCode_1
      * set ElasticRequest.query.bool.filter[3].range.@timestamp.gte = global_extension.currentTime
      * set ElasticRequest.query.bool.filter[3].range.@timestamp.lte = 'CurrenCode_1'
      When method post
      Then status 200
