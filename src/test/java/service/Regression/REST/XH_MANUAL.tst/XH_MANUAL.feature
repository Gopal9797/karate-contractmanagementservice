Feature: XH_MANUAL.tst

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}

    * def request_2 = read('Test_4_RecordContractRequest.json')

  @P2K @XH_MANUAL
  Scenario: XH_MANUAL
    * def TermID = "XH_MANUAL"
    * def AccountNumber = request_2.customerIdentifier.value

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_4_RecordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID
    * def Account_Number = request_2.customerIdentifier.value
    * def orderID = request_2.orderID

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
