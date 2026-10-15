Feature: CC01_TermType

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}



  @P2K @TOS_TERMS
  Scenario Outline: CC01_TermType CC01_TermType
    * def AccountNumber = <DDP_Acc>



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')


    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_3_SOAP_recordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Test2salesChannel = request_2.salesChannel
    * def Test2acceptanceMethod = request_2.acceptanceMethod
    * def Test2contractID = response.recordedContractSummary[0].contractID
    * def Test2termID = response.recordedContractSummary[0].termID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_5_SOAP_getContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains Test2contractID
    And match response contains Test2termID
    And match response contains 'ACCEPTED'
    And match response contains Test2salesChannel
    And match response contains Test2acceptanceMethod
    And match response contains '<TermType>'
    And match response contains 'My Account Terms of Service'
    And match response contains '<OrderId>'
    And match response contains 'false'

    * karate.pause(10000)
    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_6_SOAP_QueryContract_AllTermTypeRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains Test2contractID
    And match $response[*].termID contains '<TermID>'
    And match $response[*].status contains 'ACCEPTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].termType contains '<TermType>'
    And match $response[*].termName contains 'My Account Terms of Service'
    And match $response[*].legacyContractIndicator contains false

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_5 = read('Test_7_SOAP_QueryContract_TERMS_OF_SERVICERequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains Test2contractID
    And match $response[*].termID contains '<TermID>'
    And match $response[*].status contains 'ACCEPTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].termType contains '<TermType>'
    And match $response[*].termName contains 'My Account Terms of Service'
    And match $response[*].legacyContractIndicator contains false

    Examples:
      | DDP_Acc          | DDP_TrackingCode | DDP_AcceptanceCode | TermID | TermType         | MarketId | TermName          | TermLen | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId | OrderId2 | Outlet |
      | 8919100011339372 | Sample           | Sample             | CC01   | TERMS_OF_SERVICE | 9826    | Test TOS Contract | 24      | $50 Prepaid Card | 75                    | 90           | 3             | 75       | 7.5        | 1       | 2        | 1      |
 