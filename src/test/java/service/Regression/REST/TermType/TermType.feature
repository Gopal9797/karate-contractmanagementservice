Feature: contract_RecordGet_Query

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @TermType
  Scenario Outline: contract_RecordGet_Query TermType
    * def AccountNumber = <Acc>



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
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
    * def request_3 = read('Test_5_SOAP_getContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains Test2contractID
    And match response contains Test2termID
    And match response contains 'ACCEPTED'
    And match response contains '<Acc>'
    And match response contains Test2salesChannel
    And match response contains Test2acceptanceMethod
    And match response contains TermType
    And match response contains TermName
    And match response contains '1'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_6_SOAP_QueryContractRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].contractID contains Test2contractID
    And match response[0].termID contains '<TermID>'
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<Acc>'
    And match response[0].termType contains '<TermType>'
    And match $response[*].termName contains '<TermName>'
    And match response[0].legacyContractIndicator == false
    And match response[0].docusignEnvelopeID contains Test2docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_5 = read('Test_7_SOAP_recordContract_DuplicateChk_withSameOrderIdRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'CONTRACTMANAGEMENT-1029'
    And match response.message contains 'Duplicate contract found in database for Account Number'

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_6 = read('Test_8_SOAP_recordContract_DuplicateChk_withDifferentOrderIdRequest.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'CONTRACTMANAGEMENT-1029'
    And match response.message contains 'Duplicate contract found in database for Account Number'

    Examples:
      | Acc              | TermID                                                  | TermType  | TermName                                                        |
      | 8919100012878949 | TP_VIP_X1Premier_200_$159.99x24_2Y_Q416_230ETF_SelfServ | COMMIT_VA | X1 Premier Triple Play: 2 Year Agreement with $200 Prepaid Card |
