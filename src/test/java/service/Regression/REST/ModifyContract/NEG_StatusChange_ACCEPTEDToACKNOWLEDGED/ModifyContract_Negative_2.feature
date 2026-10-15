Feature: ScenarioModifyContract_NEG_StatusChange_ACCEPTEDToACKNOWLEDGED

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @ModifyContract @ModifyContract_NEG_StatusChange_ACCEPTEDToACKNOWLEDGED
  Scenario Outline: ModifyContract_NEG_StatusChange_ACCEPTEDToACKNOWLEDGED
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
    * def request_4 = read('Test_5_SOAP_QueryContract.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Test3contractID = response[0].contractID
    And match $response[*].status contains 'ACCEPTED'

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('Test_6_modifyContract_ACCEPTED_to_ACKNOWLEDGEDRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code == 'CONTRACTMANAGEMENT-1034'
    And match response.message contains 'Contract Status update is not allowed for Contract Id:'
    And match response.message contains 'ACCEPTED to ACKNOWLEDGED'

    Examples:
      | Acc_Presented1   | TrackingCode | TermID                            | TermType  | MarketId | TermLen | OrderId1 | Outlet1 | CSG_AcceptanceCode |
      | 8210100200239991 | CT339        | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | COMMIT_VA | 9826    | 24      | 1        | 1       | OT695              |
   
 