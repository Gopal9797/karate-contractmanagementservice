Feature: US633499_CMS_XH_1509_CompleteDocusignContract

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @XH @CompleteDocusignContract @CompleteDocusignContract_001
  Scenario Outline: US633499_CMS_XH_1509_CompleteDocusignContract for <AccountNumber> and <OrderId>
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_3_recordContract__EQUIPRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def docusignEnvelopeID_Equip = response.docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_3 = read('Test_4_recordContract__SUBRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def docusignEnvelopeID_Sub = response.docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_4 = read('Test_5_recordContract__ManualRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def docusignEnvelopeID_Manual = response.docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_5 = read('Test_6_recordContract__compositeRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def docusignEnvelopeID_Composite = response.docusignEnvelopeID

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_6 = read('Test_7_completeDocusignContract__Equip_Completed_without_signer_statusRequest.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_7 = read('Test_8_completeDocusignContract_Sub__Completed_without_signer_statusRequest.json')
    And request request_7
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_8 = read('Test_9_completeDocusignContract__Manual_Completed_without_signer_statusRequest.json')
    And request request_8
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_9 = read('Test_10_completeDocusignContract__Composite_Completed_without_signer_statusRequest.json')
    And request request_9
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url 'https://demo.docusign.net/restapi/v2/accounts/451173/envelopes/' + docusignEnvelopeID_Equip + '/recipients'
    And header Authorization = 'bearer 0n1KPtyFPkepluDRFLpDucw6Pj0='
    When method GET
    Then status 200
    * def Equip_clientUserId_1 = response.signers[0].clientUserId

    Given url 'https://demo.docusign.net/restapi/v2/accounts/451173/envelopes/' + docusignEnvelopeID_Sub + '/recipients'
    And header Authorization = 'bearer 0n1KPtyFPkepluDRFLpDucw6Pj0='
    When method GET
    Then status 200
    * def Sub_clientUserId_1 = response.signers[0].clientUserId

    Given url 'https://demo.docusign.net/restapi/v2/accounts/451173/envelopes/' + docusignEnvelopeID_Composite + '/recipients'
    And header Authorization = 'bearer 0n1KPtyFPkepluDRFLpDucw6Pj0='
    When method GET
    Then status 200
    * def Sub_clientUserId_2 = response.signers[0].clientUserId

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_13 = read('Test_14_completeDocusignContract__EQUIP_completed_with_Signer_StatusRequest.json')
    And request request_13
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_14 = read('Test_15_completeDocusignContract__Sub_completed_with_Signer_StatusRequest.json')
    And request request_14
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_15 = read('Test_16_completeDocusignContract__Composite_Completed_with_signer_statusRequest.json')
    And request request_15
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_16 = read('Test_17_completeDocusignContract__Invalid_envelope_idRequest.json')
    And request request_16
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.message contains 'Failed to get contract envelopes for the envelope id.'
    And match response.code contains 'CONTRACTMANAGEMENT-1015'

    Examples:
      | AccountNumber    | OrderId          |
      | 8210100200228895 | 1160005783791018 |
      | 8210100200239991 | 1160005563451015 |
      | 8210100200228697 | 1160021420351017 |
      | 8210100200681879 | 1160005567251015 |
 