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
    * header sourceSystemId = 'karate-sourceSystemId'
    * header sourceServerId = 'karate-sourceServerId'
    * header trackingId = currentTime

  @HIT @HITScripts @Parameter
  Scenario: recordContract
    * def requestBody = read('recordContract.json')
    Given request requestBody
    And path '/recordContract'
    When method POST
    Then status 200

  @HIT @HITScripts @recordContractHIT
  Scenario: recordContract
    * def requestBody = read('recordContract.json')
    * header Authorization = 'Bearer ' + accessToken
    Given request requestBody
    And path '/recordContract'
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    * karate.pause(10000)
    * def getRequestBody = read('getContract.json')
    * header Authorization = 'Bearer ' + accessToken
    * header sourceSystemId = 'karate-sourceSystemId'
    * header sourceServerId = 'karate-sourceServerId'
    * header trackingId = currentTime
    Given request getRequestBody
    And path '/getContract'
    When method POST
    Then status 200

    * def requestBody = read('recordContract.json')
#    * header authorization = 'Bearer' + 'Test'
#    Given request requestBody
#    And path '/recordContract'
#    When method POST
#    Then status 401

    * url OAUTH_URL
    * form field client_id = client_id
    * form field client_secret = client_pass
    * form field grant_type = 'client_credentials'
    * form field scope = 'xcp:cmt:contract:write xcp:cmt:contract:read xcp:cmt:contract:update xcp:cmt:contract:delete'
    * method POST
    * status 200
    * print response
    * def accessToken = response.access_token
    * print accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header sourceSystemId = 'karate-sourceSystemId'
    * header sourceServerId = 'karate-sourceServerId'
    * header trackingId = currentTime

    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    Given url CMTURL
    Given path contractGUID
    When method DELETE
    Then status 200