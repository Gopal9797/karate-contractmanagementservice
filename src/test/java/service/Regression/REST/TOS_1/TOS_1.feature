Feature: TOS_1_Contract

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @P2K @TOS1
  Scenario: TermType - TOS
#    * def AccountNumber = "8210100201104244"
#    * def TermID = "TOS_LEARN_MORE_BTV_RSN"
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_4_RecordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Account_Number = request_2.customerIdentifier.value
    * def orderID = request_2.orderID
    * def contractID = response.recordedContractSummary[0].contractID
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAccepted')

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_6_getContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "ACCEPTED"

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_7_queryContractRequest.json')
    * set request_4.contractCriteria.customerIdentifier[0].value = Account_Number
    * set request_4.contractCriteria.termType[0] = 'TERMS_OF_SERVICE'
    And header Authorization = Authorization
    And request request_4
    When method POST
    Then status 200
    And match $response[*].termType contains "TERMS_OF_SERVICE"
    And match $response[*].customerIdentifier.value contains Account_Number
    And match $response[*].status contains "ACCEPTED"
