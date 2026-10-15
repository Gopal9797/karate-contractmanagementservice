Feature: getContract

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

  @HIT @HITScripts @checkHIT
  Scenario Outline: getContract
    * def requestBody = read('getContract.json')
    Given request requestBody
    And path '/getContract'
    When method POST
    Then status 200

    Examples:
      | contractId                           |
      | 000d81e0-37bb-11ec-8b93-e19f0892b8d8 |

  @HIT @HITScripts
  Scenario Outline: getContract
    * def requestBody = read('getContract.json')
    Given request requestBody
    And path '/getContract'
    When method POST
    Then status 200

    Examples:
      | contractId                           |
      | 6c11d0f0-57dc-11ea-a47e-efx7e738a552 |

  @HIT @HITScripts
  Scenario: ENV Check
    Given url Endpoint_Env
    When method GET
    Then status 200

  Scenario: getContract
    * def requestBody = read('getContract.json')
    * form field contentType = ''
    Given request requestBody
    And path '/getContract'
    When method POST
    Then status 500

  Scenario: getContract
    * def requestBody = read('getContract.json')
    * header authorization = 'Bearer' + 'Test'
    Given request requestBody
    And path '/getContract'
    When method POST
    Then status 401