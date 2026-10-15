Feature: SubmitContract - TransferFromAccountNumber - Duplicate Contracts Fix

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * url Endpoint_REST
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}
    * def RecordContractRequest = read('RecordContractRequest.json')
    * def RecordContractRequest2 = read('RecordContractRequest2.json')
    * def QueryContractRequest = read('QueryContractRequest.json')
    * def GetContractRequest = read('GetContractRequest.json')
    * def SubmitContractRequest = read('SubmitContractRequest.json')

  @SubmitContract @TransferFromAccountNumber @duplicateContractsFix
  Scenario Outline: For <TermID> SubmitContract - TransferFromAccountNumber <AccountA> to <AccountB> - Duplicate PresentedStatus
#    Expected: After Hitting SubmitContract, Contract from AccountA should be transferred to AccountB.
#    And Existing duplicate Contract in AccountB should be changed as TERMINATED. So AccountB should have 2 Contracts - PRESENTED & TERMINATED.
    * def AccountNumber = <AccountA>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    * def AccountNumber = <AccountB>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountA>"
    And request QueryContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountB>"
    And request QueryContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Given path '/recordContract'
    And request RecordContractRequest
    * set RecordContractRequest.customerIdentifier.value = "<AccountA>"
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID1 = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID1
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID1
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<AccountA>'

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountA>"
    And request QueryContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID1
    And match $response[*].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.value contains '<AccountA>'
    And match $response[*].termType contains '<TermType>'
    And match $response[*].termName contains '<TermName>'
    And match $response[*].legacyContractIndicator contains false

    Given path '/recordContract'
    And request RecordContractRequest
    * set RecordContractRequest.customerIdentifier.value = "<AccountB>"
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID2 = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID2
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID2
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<AccountB>'

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountB>"
    And request QueryContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID2
    And match $response[*].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.value contains '<AccountB>'
    And match $response[*].termType contains '<TermType>'
    And match $response[*].termName contains '<TermName>'
    And match $response[*].legacyContractIndicator contains false

    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.transferFromAccountNumber = "<AccountA>"
    * set SubmitContractRequest.accountNumber = "<AccountB>"
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountB>"
    And request QueryContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].customerIdentifier.value contains '<AccountB>'
    And match $response[*].contractID contains contractID1
    And match $response[*].contractID contains contractID2
    And match $response[*].termID contains '<TermID>'
    And match $response[*].status contains 'TERMINATED'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].termType contains '<TermType>'
    And match $response[*].termName contains '<TermName>'
    And match $response[*].legacyContractIndicator contains false

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountA>"
    And request QueryContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID1
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID1
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<AccountB>'

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID2
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID2
    And match response contains '<TermID>'
    And match response contains 'TERMINATED'
    And match response contains '<AccountB>'

    * def contractID = contractID1
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')

    * def contractID = contractID2
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresTerminated')

    * karate.pause(40000)
    * def query = "Select status_cd, error_cd, error_msg_text from async_operations_log where account_num = '"+AccountNumber+"' and message_ts > '" + global_extension.currentTimeInTimestamp + " 'order by message_ts desc;"
    * def queryResult = call read('classpath:service/Regression/util/CoreTables.feature@async_operations_log')
    * print queryResult.async_operations_log
    * match queryResult.async_operations_log[*].STATUS_CD contains 'SUCCESS'

    Examples:
      | AccountA         | AccountB         | CSG_TrackingCode | TermID        | TermType     | MarketId | TermName                                        | TermLen  | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId          | Outlet |
      | 8919100012453149 | 8919100012452109 | HT468            | $230ETF_2YEAR | COMMIT_WO_VA | 9826    | 2 Year Contract with $230 Early Termination Fee | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 1001636905872097 | 9876   |
