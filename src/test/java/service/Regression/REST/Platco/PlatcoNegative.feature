Feature: Integration of Platco CMT API into Contract Management Service

  Background:
    * url Endpoint_Platco
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * def createContractRequest = read('CreateContract.json')
    * def updateContractRequest = read('UpdateContract.json')
    * def restClient = call read('classpath:service/Regression/RestClient.feature@OAUTH2Platco')

  @P2K @PlatcoIntegration @negative
  Scenario: Negative scenarios with Platco CMT APIs
    Given path ''
    And request createContractRequest
    * remove createContractRequest.customerRelationshipId
    And header Authorization = restClient.PlatcoAuthorization
    When method POST
    Then status 400
    * match response[0].message == "CustomerRelationshipId is required to create new Contract"
    * match response[0].errorCode == "CONTRACT-1002"

  @P2K @PlatcoIntegration @negative
  Scenario: Negative scenarios with Platco CMT APIs
    Given path ''
    And request createContractRequest
    * remove createContractRequest.termId
    And header Authorization = restClient.PlatcoAuthorization
    When method POST
    Then status 400
    * match response[0].message == "TermId is required to create new Contract"
    * match response[0].errorCode == "CONTRACT-1002"

  @P2K @PlatcoIntegration @negative
  Scenario: Negative scenarios with Platco CMT APIs
    Given path ''
    And request createContractRequest
    * remove createContractRequest.languageInd
    And header Authorization = restClient.PlatcoAuthorization
    When method POST
    Then status 400
    * match response[0].message == "languageInd is required to create new Contract"
    * match response[0].errorCode == "CONTRACT-1002"

  @P2K @PlatcoIntegration @negative
  Scenario: Negative scenarios with Platco CMT APIs
    * def contractID = '7d5c025f-915f-4b74-851f-d7e806464822rfsdfs'
    Given path contractID
    And header Authorization = restClient.PlatcoAuthorization
    When method GET
    Then status 404
    * match response[0].message contains "Could not find a Contract with id"
    * match response[0].errorCode == "CONTRACT-30010"

  @P2K @PlatcoIntegration @negative
  Scenario: Negative scenarios with Platco CMT APIs
    * def contractID = '7d5c025f-915f-4b74-851f-d7e806464822rfsdfs'
    Given path contractID
    When method GET
    Then status 401

    Given path contractID
    When method DELETE
    Then status 401

    Given path '/customerrelationship/' + contractID
    When method GET
    Then status 401

    Given path ''
    And request createContractRequest
    When method POST
    Then status 401

    Given path contractID
    And request updateContractRequest
    When method PATCH
    Then status 401
