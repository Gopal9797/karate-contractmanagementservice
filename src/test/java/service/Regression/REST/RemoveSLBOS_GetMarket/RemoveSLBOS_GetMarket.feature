Feature: C1509_RecordGet_Query

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @C1509_RemoveSLBOS_GetMarket
#  "message": "Term id - SP_I_BLST0x24_GM_Q113_RET is inactive. Contract cannot be created with this term id.",
  Scenario Outline: C1509_RecordGet_Query RemoveSLBOS_GetMarket
    * def AccountNumber = '<CSG_Acc>'

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
    * def Test2docusignEnvelopeID = response.docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_4_SOAP_getContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_5_SOAP_QueryContractRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains Test2contractID
    And match $response[*].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.value contains '<CSG_Acc>'
    And match $response[*].termType contains '<TermType>'
    And match $response[*].termName contains '<TermName>'
    And match $response[*].legacyContractIndicator contains false

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_5 = read('Test_6_SOAP_recordContract_DuplicateChk_withSameOrderIdRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'CONTRACTMANAGEMENT-1029'
    And match response.message contains 'Duplicate contract found in database for Account Number'

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_6 = read('Test_7_SOAP_recordContract_DuplicateChk_withDifferentOrderIdRequest.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'CONTRACTMANAGEMENT-1029'
    And match response.message contains 'Duplicate contract found in database for Account Number'

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_7 = read('Test_8_SOAP_recordContract_AfterOverlappingPeriodRequest.json')
    And request request_7
    And header Authorization = Authorization
    When method POST
    Then status 200

    Examples:
      | CSG_Acc          | CSG_TrackingCode | CSG_AcceptanceCode | TermID                    | TermType     | MarketId | TermName                                    | TermLen | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId | OrderId2 | Outlet |
      | 8919100012222288 | HT160            | OT695              | SP_I_BLST0x24_GM_Q113_RET | COMMIT_WO_VA |          | The Internet Speed Reward: 2 Year Agreement | 24      | $50 Prepaid Card | 75                    | 90           | 3             | 75.0     | 7.5        | 1       | 2        | 1      |
   
 