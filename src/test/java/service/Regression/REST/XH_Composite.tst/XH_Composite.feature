Feature: XH_Composite.tst

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}

    * def request_2 = read('Test_4_RecordContractRequest.json')

  @P2K @XH_Composite
  Scenario: XH_Composite
    * def AccountNumber = request_2.customerIdentifier.value
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given url Endpoint_REST
    Given path '/recordContract'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Account_Number = request_2.customerIdentifier.value
    * def contractID = response.recordedContractSummary[0].contractID
    * def contractID_2 = response.recordedContractSummary[1].contractID

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
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains 'XH'
    And match $response[*].customerIdentifier.value contains Account_Number
