Feature: TOS_XM

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}

    * def request_2 = read('Test_4_RecordContractRequest.json')

  @P2K @TOS_XM
  Scenario: TOS_XM
    * def AccountNumber = request_2.customerIdentifier.value
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given url Endpoint_REST
    Given path '/recordContract'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def IdentityValue = request_2.customerIdentifier.value
    * def docusignEnvelopeID = response.docusignEnvelopeID
    * def contractID = response.recordedContractSummary[0].contractID
    And match response.docusignEnvelopeID == "#present"
    And match $response.docusignURL[*].url == "#present"

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_6_getContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "PRESENTED"

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_7_queryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = IdentityValue
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains 'TERMS_OF_SERVICE'
    And match $response[*].customerIdentifier.value contains IdentityValue
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].contractID contains contractID
