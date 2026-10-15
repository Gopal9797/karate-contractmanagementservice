Feature: Integration of Platco CMT API into Contract Management Service

  Background:
    * url Endpoint_Platco
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * def createContractRequest = read('CreateContract.json')
    * def updateContractRequest = read('UpdateContract.json')
    * def restClient = call read('classpath:service/Regression/RestClient.feature@OAUTH2Platco')

#  gradlew test -Dkarate.configpassword= -Dkarate.coreTablesLocal=Y -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @PlatcoIntegration"
  @P2K @PlatcoIntegrationPOS @PlatcoIntegration
  Scenario: Happy Flow with Platco CMT APIs - Same CRID in PATCH
    Given path ''
    And request createContractRequest
    And header Authorization = restClient.PlatcoAuthorization
    When method POST
    Then status 200
    * def contractID = response.contractId
    * def customerRelationshipID = createContractRequest.customerRelationshipId
    * def CreateContractResponse = response
    * print 'Contract ID: ' + contractID
    * match response.customerRelationshipId == createContractRequest.customerRelationshipId
    * match response.languageInd == createContractRequest.languageInd
    * match response.legalName == createContractRequest.legalName
    * match response.legalText == createContractRequest.legalText
    * match response.partner == createContractRequest.partner
    * match response.termId == createContractRequest.termId
    * match response.documentUrl == createContractRequest.documentUrl
    * match response.version == createContractRequest.version

    Given path contractID
    And header Authorization = restClient.PlatcoAuthorization
    When method GET
    Then status 200
    * match response == CreateContractResponse

#    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPlatco')

    Given path '/customerrelationship/' + createContractRequest.customerRelationshipId
    And header Authorization = restClient.PlatcoAuthorization
    When method GET
    Then status 200
    * match $response[*].contractId contains contractID

    Given path contractID
    And request updateContractRequest
    And header Authorization = restClient.PlatcoAuthorization
    When method PATCH
    Then status 200
    * def UpdateContractResponse = response
    * match response.contractId == contractID
    * match response.customerRelationshipId == updateContractRequest.customerRelationshipId
    * match response.languageInd == updateContractRequest.languageInd
    * match response.legalName == updateContractRequest.legalName
    * match response.legalText == updateContractRequest.legalText
    * match response.partner == updateContractRequest.partner
    * match response.termId == updateContractRequest.termId
    * match response.documentUrl == updateContractRequest.documentUrl
    * match response.version == updateContractRequest.version

    Given path contractID
    And header Authorization = restClient.PlatcoAuthorization
    When method GET
    Then status 200
    * match response == UpdateContractResponse

#    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPlatco')

    Given path contractID
    And request updateContractRequest
    * set updateContractRequest.customerRelationshipId = global_extension.uuid2
    And header Authorization = restClient.PlatcoAuthorization
    When method PATCH
    Then status 200
    * def UpdateContractResponse = response
    * match response.contractId == contractID
    * match response.customerRelationshipId == global_extension.uuid2
    * match response.languageInd == updateContractRequest.languageInd
    * match response.legalName == updateContractRequest.legalName
    * match response.legalText == updateContractRequest.legalText
    * match response.partner == updateContractRequest.partner
    * match response.termId == updateContractRequest.termId
    * match response.documentUrl == updateContractRequest.documentUrl
    * match response.version == updateContractRequest.version

    Given path '/customerrelationship/' + createContractRequest.customerRelationshipId
    And header Authorization = restClient.PlatcoAuthorization
    When method GET
    Then status 404

    Given path '/customerrelationship/' + global_extension.uuid2
    And header Authorization = restClient.PlatcoAuthorization
    When method GET
    Then status 200
    * match $response[*].contractId contains contractID

    Given path contractID
    And header Authorization = restClient.PlatcoAuthorization
    When method GET
    Then status 200
    * match response == UpdateContractResponse

    * def customerRelationshipID = global_extension.uuid2
#    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPlatco')

    Given path contractID
    And header Authorization = restClient.PlatcoAuthorization
    When method DELETE
    Then status 200

    Given path contractID
    And header Authorization = restClient.PlatcoAuthorization
    When method DELETE
    Then status 404
    * match response[0].message == 'Could not find a Contract with id ' + contractID + '.'
    * match response[0].errorCode == 'CONTRACT-30010'
    * match response[0].status == 'NOT_FOUND'