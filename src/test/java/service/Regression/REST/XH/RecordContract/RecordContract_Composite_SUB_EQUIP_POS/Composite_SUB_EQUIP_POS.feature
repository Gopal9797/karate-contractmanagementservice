Feature: US618578_CMS_XH_1509_RecordContract_Composite_SUB_EQUIP_POS

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @XH @RecordContract @XH @RecordContract_Composite_SUB_EQUIP_POS @RecordContract_S5
  Scenario Outline: US618578_CMS_XH_1509_RecordContract_Composite_SUB_EQUIP_POS
    * def AccountNumber = <AccountNumber>



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given url Endpoint_REST
    Given path 'recordContract'
    * def request_1 = read('Test_2_recordContractRequest.json')
    And request request_1
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID_Equip = response.recordedContractSummary[1].contractID
    * def docusignEnvelopeID = response.docusignEnvelopeID
    * def contractID_Sub = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_2 = read('Test_4_QueryContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<AccountNumber>'
    And match response[0].termType contains 'XH'
    And match $response[*].termName contains 'Xfinity Home Services Test Contract'
    And match response[0].legacyContractIndicator  == false
    And match response[0].docusignEnvelopeID contains docusignEnvelopeID
    And match $response[*].contractID contains contractID_Sub
    And match $response[*].contractID contains contractID_Equip
    And match $response[*].termName contains 'Xfinity Home Equipment Test Contract'

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_5_getContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains 'PRESENTED'
    And match response contains contractID_Equip
    And match response contains 'ENGLISH'
    And match response contains '<AccountNumber>'
    And match response contains 'XH'
    And match response contains 'Xfinity Home Services Test Contract'
    And match response contains '<OrderId>'
    And match response contains 'false'
    And match response contains 'XHS'
    And match response contains docusignEnvelopeID
    And match response contains contractID_Sub
    And match response contains 'Xfinity Home Equipment Test Contract'
    And match response contains 'Manikantha Pothuri'
    And match response contains 'Manikantha_Pothuri@cable.comcast.com'
    And match response contains 'Amer Elissa'
    And match response contains 'Amer_Elissa@cable.comcast.com'
    And match response contains 'sent'

    Examples:
      | AccountNumber    | OrderId          |
      | 8210100200228895 | 1160005567251015 |
 