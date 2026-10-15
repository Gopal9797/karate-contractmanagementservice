Feature: recordContract

  Background:
    * url OAUTH_URL
    * call read('classpath:extension_tool.feature')
    * form field client_id = client_id
    * form field client_secret = client_pass
    * form field grant_type = 'client_credentials'
    * form field scope = 'esp:contractManagement'
    * method POST
    * status 200
    * print response
    * def accessToken = response.access_token
    * print accessToken
    * url Endpoint_REST
    * header Authorization = 'Bearer ' + accessToken
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}
  @HIT @HITScripts @Docusign
  Scenario: recordContract for Docusign
    * def requestBody = read('recordContractDocusign.json')
    Given request requestBody
    * header Authorization = 'Bearer ' + accessToken
    And path '/recordContract'
    When method POST
    Then status 200
    * def docusignEnvelopeID = response.docusignEnvelopeID

    * def completeDocusignContract = read('completeDocusignContract.json')
    Given request completeDocusignContract
    * header Authorization = 'Bearer ' + accessToken
    And path '/completeDocusignContract'
    When method POST
    Then status 200