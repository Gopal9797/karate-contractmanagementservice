Feature: modifyContract

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
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}

  @HIT @HITScripts @modifyContractHIT
  Scenario: modifyContract
    * def recordRequestBody = read('recordContract.json')
    * def TermID = '$230ETF_2YEAR'
    * def AccountNumber = recordRequestBody.customerIdentifier.value
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    And header Authorization = 'Bearer ' + accessToken
    Given request recordRequestBody
    And path '/recordContract'
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    * karate.pause(10000)
    * def getRequestBody = read('getContract.json')
    Given request getRequestBody
    And header Authorization = 'Bearer ' + accessToken
    And path '/getContract'
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true

    * def modifyRequestBody = read('modifyContractStatus.json')
    Given request modifyRequestBody
    And header Authorization = 'Bearer ' + accessToken
    And path '/modifyContractStatusModification'
    When method POST
    Then status 200

    * karate.pause(10000)
    Given request getRequestBody
    And header Authorization = 'Bearer ' + accessToken
    And path '/getContract'
    When method POST
    Then status 200
    And match response contains "DECLINED"

#    * def requestBody = read('modifyContractStatus.json')
#    * header Authorization = 'Bearer ' + accessToken
#    * form field contentType = ''
#    Given request requestBody
#    And path '/modifyContractStatusModification'
#    When method POST
#    Then status 500

#    * def requestBody = read('modifyContractStatus.json')
#    * header authorization = 'Bearer' + 'Test'
#    Given request requestBody
#    And path '/modifyContractStatusModification'
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