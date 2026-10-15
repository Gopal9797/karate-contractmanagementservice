Feature: SubmitContract_CSG_Commit_VA

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @SubmitContract @SubmitContract_CSG_Commit_VA
  Scenario Outline: SubmitContract_CSG_Commit_VA
    * def AccountNumber = <Acc>

    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_2 = read('Test_3_SOAPRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_3 = read('Test_5_SOAP_QueryContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<Acc>'
    And match response[0].termType contains '<TermType>'
    And match $response[*].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false
    * def contractID = response[0].contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_4 = read('Test_6_SOAP_getContractRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
    And match response contains '<Acc>'
    And match response contains 'CMS'
    And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains '<StartAmt>'
    And match response contains '<DeclineAmt>'
    And match response contains '<DeclinePeriod>'
    And match response contains '<CancelPeriod>'
    And match response contains '<ProductDesc>'
    And match response contains '<RequiredServicePeriod>'
    And match response contains 'PENDING'
    And match response contains 'POST_ORDER_SUMMARY'

    Examples:
      | Acc              | CSG_TrackingCode | TermID                            | TermType  | MarketId | TermName                                                                                      | TermLen | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId | Outlet |
      | 8919100010857622 | CT339            | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | COMMIT_VA | 9826    | Digital Starter Video and Blast! Internet Double Play: 2 Year Agreement with $50 Prepaid Card | 24      | $50 Prepaid Card | 75                    | 90           | 3             | 75.0     | 7.5        | 1       | 1      |
   
 