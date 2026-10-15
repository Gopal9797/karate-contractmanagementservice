Feature: C1603_QueryContract

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}



  @P2K @TOS_TERMS  @QueryContract_All_TOSTerms_S2R
  Scenario: C1603_QueryContract QueryContract_All
    * def AccountNumber = '8210100200228895'



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_3_recordContract__XH_SUBRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID_Sub = response.recordedContractSummary[0].contractID
    * def docusignEnvelopeID_Sub = response.docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_3 = read('Test_4_recordContract__XH_EQUIPRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID_Equip = response.recordedContractSummary[0].contractID
    * def docusignEnvelopeID_Equip = response.docusignEnvelopeID

    * def AccountNumber = '8210100200228895'
    * def TermID = 'NON_DS_TEST_COMMIT_WO_VA_DO_NOT_USE'



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_4 = read('Test_5_recordContract__CXRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID_CX = response.recordedContractSummary[0].contractID
    * def docusignEnvelopeID_CX = response.docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_5 = read('Test_6_recordContract__TOSRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID_TOS = response.recordedContractSummary[0].contractID
    * def docusignEnvelopeID_TOS = response.docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_6 = read('Test_7_queryContract__acctNumberRequest.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID_CX
    And match $response[*].termID contains 'NON_DS_TEST_COMMIT_WO_VA_DO_NOT_USE'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].termType contains  'COMMIT_WO_VA'
    And match $response[*].termName contains 'SP_V_PF_DCOM_Q412_VIDEO_DO_NOT_USE COMMIT_WO_VA'
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_CX
    And match $response[*].contractRecordedDtm == '#present'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_7 = read('Test_8_queryContract__acctNumber_termId_EQUIPRequest.json')
    And request request_7
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID_Equip
    And match $response[*].termID contains 'XH_EQUIP'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Equipment Test Contract'
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Equip
    And match $response[*].contractRecordedDtm == '#present'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_8 = read('Test_9_queryContract__acctNumber_termId_SUBRequest.json')
    And request request_8
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID_Sub
    And match $response[*].termID contains 'XH_SUB'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Services Test Contract'
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Sub
    And match $response[*].contractRecordedDtm == '#present'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('Test_10_queryContract__acctNumber_termId_TOSRequest.json')
    And request request_9
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID_TOS
    And match $response[*].termID contains  'XMOBILE_CONSENT_DS01'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'IDENTITY_ID'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].termType contains 'TERMS_OF_SERVICE'
    And match $response[*].termName contains 'XMOBILE_CONSENT_DS01'
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_TOS
    And match $response[*].contractRecordedDtm == '#present'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_10 = read('Test_11_queryContract__acctNumber_termId_ALLRequest.json')
    And request request_10
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termName contains 'Xfinity Home Services Test Contract'
    And match $response[*].termType contains 'XH'
    And match $response[*].status contains 'PRESENTED'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_11 = read('Test_12_queryContract__acctNumber_termType_XHRequest.json')
    And request request_11
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].contractRecordedDtm == '#present'
    And match $response[*].contractID contains contractID_Sub
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Services Test Contract'
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Sub
    And match $response[*].contractID contains contractID_Equip
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Equipment Test Contract'
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Equip

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_12 = read('Test_13_queryContract__acctNumber_termType_TOSRequest.json')
    And request request_12
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[*].contractID contains contractID_TOS
    And match response[*].termID contains  'XMOBILE_CONSENT_DS01'
    And match response[*].status contains 'PRESENTED'
    And match response[*].language contains 'ENGLISH'
    And match response[*].customerIdentifier.key contains 'IDENTITY_ID'
    And match response[*].customerIdentifier.value contains AccountNumber
    And match response[*].termType contains 'TERMS_OF_SERVICE'
    And match response[*].termName contains 'XMOBILE_CONSENT_DS01'
    And match response[*].legacyContractIndicator contains false
    And match response[*].docusignEnvelopeID contains docusignEnvelopeID_TOS
    And match response[*].contractRecordedDtm == '#present'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_15 = read('Test_16_queryContract__acctNumber_termType_ALLRequest.json')
    And request request_15
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID_Sub
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Services Test Contract'
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Sub
    And match $response[*].contractRecordedDtm == '#present'
    And match $response[*].contractID contains contractID_Equip
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Equipment Test Contract'
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Equip
    And match $response[*].contractID contains contractID_CX
    And match $response[*].status contains 'PRESENTED'
#    And match $response[*].termType contains 'COMMIT_VA'
#    And match $response[*].termName contains 'Digital Starter Video and Blast! Internet Double Play: 2 Year Agreement with $50 Prepaid Card'
#    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_CX

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_16 = read('Test_17_queryContract__acctNumber_termId_EQUIP_termType_AllRequest.json')
    And request request_16
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID_Equip
    And match $response[*].termID contains 'XH_EQUIP'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Equipment Test Contract'
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Equip
    And match $response[*].contractRecordedDtm == '#present'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_17 = read('Test_18_queryContract__acctNumber_termId_EQUIP_and_Sub_termType_AllRequest.json')
    And request request_17
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].contractRecordedDtm == '#present'
    And match $response[*].contractID contains contractID_Sub
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Services Test Contract'
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Sub
    And match $response[*].contractID contains contractID_Equip
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Equipment Test Contract'
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Equip

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_18 = read('Test_19_queryContract__acctNumber_and_OrderIdRequest.json')
    And request request_18
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_19 = read('Test_20_queryContract__acctNumber_and_CX_OrderIdRequest.json')
    And request request_19
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID_CX
    And match $response[*].termID contains 'NON_DS_TEST_COMMIT_WO_VA_DO_NOT_USE'
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].termType contains  'COMMIT_WO_VA'
    And match $response[*].termName contains 'SP_V_PF_DCOM_Q412_VIDEO_DO_NOT_USE COMMIT_WO_VA'
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_CX
    And match $response[*].contractRecordedDtm == '#present'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_20 = read('Test_21_queryContract__acctNumber_TermType_All_Status_PresentedRequest.json')
    And request request_20
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_21 = read('Test_22_queryContract__acctNumber_TermType_All_Status_AcceptedRequest.json')
    And request request_21
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_22 = read('Test_23_queryContract__acctNumber_TermType_All_Status_Presented_AcceptedRequest.json')
    And request request_22
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractID_Sub
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].language contains 'ENGLISH'
    And match $response[*].customerIdentifier.key contains 'ACCOUNT_NUMBER'
    And match $response[*].customerIdentifier.value contains AccountNumber
    And match $response[*].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Services Test Contract'
    And match $response[*].legacyContractIndicator contains false
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Sub
    And match $response[*].contractRecordedDtm == '#present'
    And match $response[*].contractID contains contractID_Equip
    And match $response[*].status contains 'PRESENTED'
    And match $response[*].termName contains 'Xfinity Home Equipment Test Contract'
    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_Equip
    And match $response[*].contractID contains contractID_CX
    And match $response[*].status contains 'PRESENTED'
#    And match $response[*].termType contains 'COMMIT_VA'
#    And match $response[*].termName contains 'Digital Starter Video and Blast! Internet Double Play: 2 Year Agreement with $50 Prepaid Card'
#    And match $response[*].docusignEnvelopeID contains docusignEnvelopeID_CX
 