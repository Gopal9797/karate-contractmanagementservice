Feature: FTS & GraphQL APIs Validations

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * def restClient = call read('classpath:service/Regression/RestClient.feature@OAUTH2PlatcoFTS')
    * def platcoFTSRequest = read('platcoFTSRequest.json')

  @P2K @PlatcoIntegrationPOS @PlatcoIntegration @PlatcoFTS
  Scenario: Platco FTS Validation
    Given url 'https://platco-fts-dev.codebig2.net'
    And path '/graphql'
    And request platcoFTSRequest
    And header Authorization = restClient.PlatcoFTSAuthorization
    When method post
    Then status 200
    * match response.data.serviceAccounts[0].customerRelationship.customerRelationshipId == 'test-cr-id-1'
    * match response.data.serviceAccounts[0].customerRelationship.acquisitionDate == '2020-01-01'
    * match response.data.serviceAccounts[0].customerRelationship.contract[0].contractId == '766ad4a6-7835-4a27-aa64-ca037d15eaa0'
    * match response.data.serviceAccounts[0].customerRelationship.contract[0].customerRelationshipId == 'test-cr-id-1'
    * match response.data.serviceAccounts[0].customerRelationship.contract[0].termId == 'TOS_TERM_ID_01'
