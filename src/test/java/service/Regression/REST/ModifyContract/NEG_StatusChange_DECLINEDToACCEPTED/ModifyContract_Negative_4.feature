Feature: ScenarioModifyContract_NEG_StatusChange_DECLINEDToACCEPTED

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @ModifyContract_NEG_StatusChange_DECLINEDToACCEPTED
  Scenario Outline: ModifyContract_NEG_StatusChange_DECLINEDToACCEPTED
    * def AccountNumber = '<Acc_Presented1>'



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_3_SOAP_recordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_3 = read('Test_4_modifyContract_PRESENTED_to_ACCEPTEDRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_6_SOAP_QueryContract.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Test3contractID = response[0].contractID
    And match $response[*].status contains 'ACCEPTED'

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('Test_7_modifyContract_Accepted_to_DeclinedRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_6 = read('Test_9_SOAP_QueryContract_StatusCheckRequest.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].status contains 'DECLINED'

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_7 = read('Test_10_modifyContract_Declined_to_AcceptedRequest.json')
    And request request_7
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_8 = read('Test_12_SOAP_QueryContract_StatusCheck_2Request.json')
    And request request_8
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].status contains 'ACCEPTED'

    Examples:
      | Acc_Presented1   | TrackingCode | TermID                            | TermType  | MarketId | TermLen | OrderId1 | Outlet1 | CSG_AcceptanceCode |
      | 8210100200239991 | CT339        | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | COMMIT_VA | 9826    | 24      | 1        | 1       | OT695              |
   
 