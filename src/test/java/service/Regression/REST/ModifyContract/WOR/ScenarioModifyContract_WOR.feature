Feature: ScenarioModifyContract_WOR - Version 1507

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @ModifyContract_WOR
  Scenario Outline: ScenarioModifyContract_WOR
    * def AccountNumber = <CSG_Acc>



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_4_SOAP_recordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_00 = read('Test_1_modifyContract_PRESENTED_To_TERMINATEDRequest.json')
    And request request_00
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_0 = read('Test_2_modifyContract_TERMINATED_to_ACKNOWLEDGEDRequest.json')
    And request request_0
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'CONTRACTMANAGEMENT-1034'
    And match response.message contains 'Contract Status update is not allowed for Contract Id:'
    And match response.message contains 'From TERMINATED to ACKNOWLEDGED'

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_1 = read('Test_3_modifyContract_TERMINATED_to_ACCEPTEDRequest.json')
    And request request_1
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'CONTRACTMANAGEMENT-1034'
    And match response.message contains 'Contract Status update is not allowed for Contract Id:'
    And match response.message contains 'From TERMINATED to ACCEPTED'

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_2 = read('Test_4_modifyContract_TERMINATED_to_DECLINEDRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'CONTRACTMANAGEMENT-1034'
    And match response.message contains 'Contract Status update is not allowed for Contract Id:'
    And match response.message contains 'From TERMINATED to DECLINED'

    Examples:
      | CSG_Acc          | CSG_TrackingCode | CSG_AcceptanceCode | TermID                            | TermType  | MarketId | TermName                                                                                      | TermLen | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId | OrderId2 | Outlet |
      | 8045100010263836 | CT339            | OT695              | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | COMMIT_VA | 9826    | Digital Starter Video and Blast! Internet Double Play: 2 Year Agreement with $50 Prepaid Card | 24      | $50 Prepaid Card | 75                    | 90           | 3             | 75.0     | 7.5        | 1       | 2        | 1      |
 