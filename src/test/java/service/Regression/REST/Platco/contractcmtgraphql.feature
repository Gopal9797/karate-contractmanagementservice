Feature: FTS & GraphQL APIs Validations

  Background:
    * url Endpoint_Platco_INT
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * def createContractRequest = read('CreateContract.json')
    * def restClient = call read('classpath:service/Regression/RestClient.feature@OAUTH2Platco')

#  gradlew test -Dkarate.configpassword= -Dkarate.coreTablesLocal=Y -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @PlatcoIntegration"
  @P2K @PlatcoIntegrationPOS @PlatcoIntegration @contractCMTGraphQL
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

    * def platcoContractCMT = read('platocontractCMT.graphql')
    Given url 'https://contract-cmt-ci.codebig2.net'
    Given path '/graphql'
    And header Authorization = restClient.PlatcoAuthorization
    And def variables = { contractIdVar: "#(contractID)" }
    And request { query: '#(platcoContractCMT)', variables: '#(variables)' }
    When method POST
    Then status 200
    * match response.data.contract.customerRelationshipId == createContractRequest.customerRelationshipId
    * match response.data.contract.languageInd == createContractRequest.languageInd
    * match response.data.contract.legalName == createContractRequest.legalName
    * match response.data.contract.legalText == createContractRequest.legalText
    * match response.data.contract.partner == createContractRequest.partner
    * match response.data.contract.termId == createContractRequest.termId
    * match response.data.contract.documentUrl == createContractRequest.documentUrl
    * match response.data.contract.version == createContractRequest.version

    * url Endpoint_Platco_INT
    Given path contractID
    And header Authorization = restClient.PlatcoAuthorization
    When method DELETE
    Then status 200

    * url Endpoint_Platco_INT
    Given path contractID
    And header Authorization = restClient.PlatcoAuthorization
    When method DELETE
    Then status 404
    * match response[0].message == 'Could not find a Contract with id ' + contractID + '.'
    * match response[0].errorCode == 'CONTRACT-30010'
    * match response[0].status == 'NOT_FOUND'

    Given url 'https://contract-cmt-ci.codebig2.net'
    Given path '/graphql'
    And header Authorization = restClient.PlatcoAuthorization
    And def variables = { contractIdVar: "#(contractID)" }
    And request { query: '#(platcoContractCMT)', variables: '#(variables)' }
    When method POST
    Then status 200
    * match response.data.contract == null
