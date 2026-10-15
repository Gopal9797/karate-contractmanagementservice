Feature: SubmitContract - TransferFromAccountNumber Scenario

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}

    * def request_2 = read('RecordContractRequest.json')
    * def request_22 = read('RecordContractRequest2.json')
    * def request_3 = read('QueryContractRequest.json')
    * def request_4 = read('SubmitContractRequest.json')


  @SubmitContract @TransferFromAccountNumber
  Scenario Outline: For <TermID> SubmitContract - TransferFromAccountNumber <transferFromAcc> to <Acc> - PresentedStatus
    * def AccountNumber = <transferFromAcc>

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given url Endpoint_REST
    Given path '/recordContract'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<transferFromAcc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<transferFromAcc>'
    And match response contains 'CMS'
    # And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'

    * def AccountNumber = <Acc>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<Acc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Given url Endpoint_REST
    Given path '/submitContract'
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<Acc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<Acc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false
    * def contractIDFromQueryContract = response[0].contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<Acc>'
    And match response contains 'CMS'
    # And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Examples:
      | transferFromAcc  | Acc              | CSG_TrackingCode | TermID                                                  | TermType     | MarketId | TermName                                                        | TermLen  | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId          | Outlet |
      | 8919100012453149 | 8919100012452109 | HT468            | $230ETF_2YEAR                                           | COMMIT_WO_VA | 9826    | 2 Year Contract with $230 Early Termination Fee                 | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 1001636905872097 | 9876   |
#      | 8919100012453149 | 8919100012452109 | BA               | TP_VIP_X1Premier_200_$159.99x24_2Y_Q416_230ETF_SelfServ | COMMIT_VA    | 9826    | X1 Premier Triple Play: 2 Year Agreement with $200 Prepaid Card | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 1001636905872097 | 9876   |

  @SubmitContract @TransferFromAccountNumberMultipleContracts @TransferFromAccountNumber
  Scenario Outline: SubmitContract - TransferFromAccountNumber <transferFromAcc> to <Acc> - PresentedStatus - Different Contract Types
    * def AccountNumber = <transferFromAcc>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')

    Given url Endpoint_REST
    Given path '/recordContract'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/recordContract'
    And request request_22
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID2 = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    * set request_3.contractCriteria.termID[0] = '<TermID>'
    * set request_3.contractCriteria.termID[1] = '<TermID2>'
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID
    And match $response[*].contractID contains contractID2
    And match $response[*].termID contains '<TermID>'
    And match $response[*].termID contains '<TermID2>'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.value contains '<transferFromAcc>'
    And match $response[*].termType contains '<TermType>'
    And match $response[*].termType contains '<TermType2>'
    And match $response[*].termName contains '<TermName>'
    And match response[0].legacyContractIndicator == false

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    * set request_5.contractID[0] = contractID
    * set request_5.contractID[1] = contractID2
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    And match response contains contractID2
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains '<TermID2>'
    And match response contains 'PRESENTED'
    And match response contains '<transferFromAcc>'
    And match response contains 'CMS'
    And match response contains '<TermType>'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains 'POST_ORDER_SUMMARY'

    * def AccountNumber = <Acc>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<Acc>"
    * set request_3.contractCriteria.termID[0] = '<TermID>'
    * set request_3.contractCriteria.termID[1] = '<TermID2>'
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Given url Endpoint_REST
    Given path '/submitContract'
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<Acc>"
    And request request_3
    * set request_3.contractCriteria.termID[0] = '<TermID>'
    * set request_3.contractCriteria.termID[1] = '<TermID2>'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<Acc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false
    * def contractIDFromQueryContract = response[0].contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    * set request_5.contractID[0] = contractID
    * set request_5.contractID[1] = contractID2
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<Acc>'
    And match response contains 'CMS'
    And match response contains '<TermType>'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains 'POST_ORDER_SUMMARY'

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    * set request_3.contractCriteria.termID[0] = '<TermID>'
    * set request_3.contractCriteria.termID[1] = '<TermID2>'
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response != []
    And match $response[*].contractID contains contractID2
    And match $response[*].termID contains '<TermID2>'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.value contains '<transferFromAcc>'
    And match $response[*].termType contains '<TermType2>'
    And match response[0].legacyContractIndicator  == false

    Examples:
      | transferFromAcc  | Acc              | CSG_TrackingCode | CSG_TrackingCode2 | TermID        | TermID2                                                 | TermType     | TermType2 | MarketId | TermName                                        | TermLen  | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId          | Outlet |
      | 8919100012453149 | 8919100012452109 | HT468            | BA                | $230ETF_2YEAR | TP_VIP_X1Premier_200_$159.99x24_2Y_Q416_230ETF_SelfServ | COMMIT_WO_VA | COMMIT_VA | 9826    | 2 Year Contract with $230 Early Termination Fee | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 1001636905872097 | 9876   |

  @SubmitContract @TransferFromAccountNumber @TFAN_AcknowledgedStatus
  Scenario Outline: SubmitContract - TransferFromAccountNumber <transferFromAcc> to <Acc> - AcknowledgedStatus
    * def AccountNumber = <transferFromAcc>

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given url Endpoint_REST
    Given path '/recordContract'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<transferFromAcc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<transferFromAcc>'
    And match response contains 'CMS'
    # And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains '<StartAmt>'
    And match response contains '<DeclineAmt>'
    And match response contains '<DeclinePeriod>'
    And match response contains '<CancelPeriod>'
    And match response contains 'POST_ORDER_SUMMARY'


    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_M = read('ModifyContractStatusModificationRequest.json')
    And request request_M
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'ACKNOWLEDGED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<transferFromAcc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains 'ACKNOWLEDGED'
    And match response contains '<transferFromAcc>'
    And match response contains 'CMS'
    # And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains '<StartAmt>'
    And match response contains '<DeclineAmt>'
    And match response contains '<DeclinePeriod>'
    And match response contains '<CancelPeriod>'
    And match response contains 'POST_ORDER_SUMMARY'


    * def AccountNumber = <Acc>

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<Acc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Given url Endpoint_REST
    Given path '/submitContract'
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<Acc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'ACKNOWLEDGED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<Acc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false
    * def contractIDFromQueryContract = response[0].contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains 'ACKNOWLEDGED'
    And match response contains '<Acc>'
    And match response contains 'CMS'
    # And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains '<StartAmt>'
    And match response contains '<DeclineAmt>'
    And match response contains '<DeclinePeriod>'
    And match response contains '<CancelPeriod>'
    And match response contains 'POST_ORDER_SUMMARY'

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Examples:
      | transferFromAcc  | Acc              | CSG_TrackingCode | TermID        | TermType     | MarketId | TermName                                        | TermLen  | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId          | Outlet |
      | 8919100012538444 | 8919100012452109 | HT468            | $230ETF_2YEAR | COMMIT_WO_VA | 9826    | 2 Year Contract with $230 Early Termination Fee | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 1001636905872097 | 9876   |

  @SubmitContract @TransferFromAccountNumber @TFAN_CancelledStatus
  Scenario Outline: SubmitContract - TransferFromAccountNumber <transferFromAcc> to <Acc> - Cancelled Status
    * def AccountNumber = <transferFromAcc>

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given url Endpoint_REST
    Given path '/recordContract'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<transferFromAcc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<transferFromAcc>'
    And match response contains 'CMS'
    # And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains '<StartAmt>'
    And match response contains '<DeclineAmt>'
    And match response contains '<DeclinePeriod>'
    And match response contains '<CancelPeriod>'
    And match response contains 'POST_ORDER_SUMMARY'


    Given url Endpoint_REST
    Given path '/modifyContractOrderCancellation'
    * def request_MC = read('ModifyContractOrderCancellationRequest.json')
    And request request_MC
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'CANCELLED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<transferFromAcc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    # And match response contains contractIDFromQueryContract
    And match response contains '<TermID>'
    And match response contains 'CANCELLED'
    And match response contains '<transferFromAcc>'
    And match response contains 'CMS'
    # And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains '<StartAmt>'
    And match response contains '<DeclineAmt>'
    And match response contains '<DeclinePeriod>'
    And match response contains '<CancelPeriod>'
    And match response contains 'POST_ORDER_SUMMARY'


    * def AccountNumber = <Acc>

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<Acc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Given url Endpoint_REST
    Given path '/submitContract'
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<Acc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID !contains contractID
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<Acc>'
    And match response[0].termType contains '<TermType>'
    And match response[0].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false
    * def contractIDFromQueryContract = response[0].contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('GetContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
#    And match response !contains contractID
#     And match response contains contractIDFromQueryContract
#    And match response contains '<TermID>'
#    And match response contains 'PRESENTED'
#    And match response contains '<Acc>'
#    And match response contains 'CMS'
#     And match response contains 'WEB'
#    And match response contains '<TermType>'
#    And match response contains '<TermName>'
#    And match response contains '<OrderId>'
#    And match response contains 'false'
#    And match response contains '<StartAmt>'
#    And match response contains '<DeclineAmt>'
#    And match response contains '<DeclinePeriod>'
#    And match response contains '<CancelPeriod>'
#    And match response contains 'POST_ORDER_SUMMARY'

    Given url Endpoint_REST
    Given path '/queryContract'
    * set request_3.contractCriteria.customerIdentifier[0].value = "<transferFromAcc>"
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response != []

    Examples:
      | transferFromAcc  | Acc              | CSG_TrackingCode | TermID        | TermType     | MarketId | TermName                                        | TermLen  | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId          | Outlet |
      | 8919100012538444 | 8919100012452109 | HT468            | $230ETF_2YEAR | COMMIT_WO_VA | 9826    | 2 Year Contract with $230 Early Termination Fee | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 1001636905872097 | 9876   |
