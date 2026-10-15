Feature: submitContract

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
    * header sourceSystemId = 'karate-sourceSystemId'
    * header sourceServerId = 'karate-sourceServerId'
    * header trackingId = currentTime

  @HIT @HITScripts
  Scenario: submitContract
    * def requestBody = read('submitContract.json')
    Given request requestBody
    And path '/submitContract'
    When method POST
    Then status 200

    * def requestBody = read('submitContract.json')
    * header Authorization = 'Bearer ' + accessToken
    Given request requestBody
    And path '/submitContract'
    When method POST
    Then status 200
