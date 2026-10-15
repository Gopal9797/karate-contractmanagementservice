Feature: queryContract

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
  Scenario Outline: queryContract
    * def requestBody = read('queryContract.json')
    Given request requestBody
    And path '/queryContract'
    When method POST
    Then status 200
    And match response[*].contractID contains 'b0aab000d13911eca9bfa19fa93b8871'
    And match response[*].customerIdentifier.value contains '8529113050135132'
    And match response[*].docusignEnvelopeID contains '6c8b5932a93a47dc80023e1892dcfa12'

    Examples:
      | AccountNumber    |
      | 8529113050135132 |

  Scenario: queryContract
    * def requestBody = read('queryContract.json')
    * form field contentType = ''
    Given request requestBody
    And path '/queryContract'
    When method POST
    Then status 500

  Scenario: queryContract
    * def requestBody = read('queryContract.json')
    * header authorization = 'Bearer' + 'Test'
    Given request requestBody
    And path '/queryContract'
    When method POST
    Then status 401