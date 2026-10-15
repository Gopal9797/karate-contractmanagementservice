Feature: NON_COMMIT_VA

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @P2K @NON_COMMIT_VA
  Scenario Outline: TermType - NON_COMMIT_VA for <TermID>



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
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
    * set request_4.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_4.contractCriteria.termType[0] = 'NON_COMMIT_VA'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "NON_COMMIT_VA"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "PRESENTED"

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('Test_8_modifyContractStatusModificationRequest.json')
    And request request_5
    * set request_5.contractID = contractID
    * set request_5.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_6 = read('Test_10_getContract_2Request.json')
    And request request_6
    * set request_6.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('Test_14_queryContract_2Request.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_9.contractCriteria.termType[0] = 'NON_COMMIT_VA'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "NON_COMMIT_VA"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "ACKNOWLEDGED"

    Given url Endpoint_REST
    Given path '/modifyContractOrderCancellation'
    * def request_7 = read('Test_11_modifyContractOrderCancellationRequest.json')
    And request request_7
    * set request_7.accountNumber = '<AccountNumber>'
    * set request_7.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_8 = read('Test_13_getContract_3Request.json')
    And request request_8
    * set request_8.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('Test_14_queryContract_2Request.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_9.contractCriteria.termType[0] = 'NON_COMMIT_VA'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "NON_COMMIT_VA"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "CANCELLED"

    Examples:
      | AccountNumber    | OrderId          | TermID                 | TrackingID |
      | 8210100200228697 | 1160005563451015 | CNT_for_OffrNum_201091 | TF026      |
#      | 8919100010857622 | 1160005783791018 | SP_INTERNET_25_VA      | OT945      |
