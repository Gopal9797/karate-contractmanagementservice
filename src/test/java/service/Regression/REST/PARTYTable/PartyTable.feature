Feature: PartyTableScenarios

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @P2K @PartyTableScenarios
  Scenario Outline: TermType - <termType> for <TermID>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('RecordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Account_Number = request_2.customerIdentifier.value
    * def orderID = request_2.orderID
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('GetContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('QueryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_4.contractCriteria.termType[0] = '<termType>'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<termType>"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "PRESENTED"

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('ModifyContractStatusModificationRequest.json')
    And request request_5
    * set request_5.contractID = contractID
    * set request_5.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_6 = read('GetContractRequest.json')
    And request request_6
    * set request_6.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('QueryContractRequest.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_9.contractCriteria.termType[0] = '<termType>'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<termType>"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "ACKNOWLEDGED"

    Given url Endpoint_REST
    Given path '/modifyContractOrderCancellation'
    * def request_7 = read('ModifyContractOrderCancellationRequest.json')
    And request request_7
    * set request_7.accountNumber = '<AccountNumber>'
    * set request_7.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_8 = read('GetContractRequest.json')
    And request request_8
    * set request_8.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "CANCELLED"

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('QueryContractRequest.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_9.contractCriteria.termType[0] = '<termType>'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<termType>"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "CANCELLED"

    * call read('classpath:service/Regression/util/PGDatabase.feature@selectPartyFromPartyTable')

    Examples:
      | AccountNumber    | OrderId          | TermID                                                  | TrackingID | termType  |
      | 8919100012524949 | 1160005567251015 | TP_VIP_X1Premier_200_$159.99x24_2Y_Q416_230ETF_SelfServ | BA         | COMMIT_VA |
#      | 8919100012498516 | 1160005783791018 | DP_VI_STBLST_50_$79.99x12_2Y_Q314                       | CT339      | COMMIT_VA     |
#      | 8919100012387263 | 1160005567251015 | NON_DS_TEST_COMMIT_WO_VA_DO_NOT_USE                     | CT3395     | COMMIT_WO_VA  |
#      | 8919100012449352 | 1160005783791018 | XH_EIP_2Y_Q119_COMP                                     | ST276      | COMMIT_WO_VA  |
#      | 8919100012371796 | 1160005563451015 | CNT_for_OffrNum_201091                                  | TF026      | NON_COMMIT_VA |
#      | 8919100012234242 | 1160005783791018 | SP_INTERNET_25_VA                                       | OT945      | NON_COMMIT_VA |