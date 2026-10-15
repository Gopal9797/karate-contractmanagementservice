Feature: Transfer_Plain

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @SubmitContract @TransferPlain
  Scenario Outline: Transfer_Plain Transfer_Plain
    * def AccountNumber = <Acc>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    * def AccountNumber = <Acc2>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')



    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_2 = read('Test_3_submitContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200

    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_3 = read('Test_5_queryContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].status contains 'PRESENTED'

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_4 = read('Test_6_submitContract_2Request.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_5 = read('Test_8_queryContract_2Request.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_6 = read('Test_9_queryContract_3Request.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].status contains 'PRESENTED'
    And match response[1].status contains 'PRESENTED'
    And match response[2].status contains 'PRESENTED'

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_7 = read('Test_10_submitContract_3Request.json')
    And request request_7
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_8 = read('Test_12_queryContract_4Request.json')
    And request request_8
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].status contains 'PRESENTED'
    And match response[1].status contains 'PRESENTED'
    And match response[2].status contains 'PRESENTED'
    # And match $response[*].status contains 'TERMINATED'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('Test_13_queryContract_5Request.json')
    And request request_9
    And header Authorization = Authorization
    When method POST
    Then status 200

    Examples:
      | Acc              | Acc2             | CSG_TrackingCode | TermID                              | TermType     | MarketId | TermName                                                         | TermLen | ProductDesc | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId | Outlet |
      | 8919100010857556 | 8919100010584358 | CT280            | DP_VI_STPI_$79.99x12_2Y_Q214_230ETF | COMMIT_WO_VA | 9826     | Digital Starter Video and Performance Internet: 2 Year Agreement | 24      | NULL        | 0                     | 30           | 1             | 230      | 10         | 1       | 1      |
 