Feature: ScenarioModifyContract_POS_StatusChange_CX

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @ModifyContract_POS_StatusChange_CX
  Scenario Outline: ScenarioModifyContract_POS_StatusChange_CX
    * def AccountNumber = '<Acc_Presented1>'



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_0 = read('Test_2_SOAP_recordContractRequest.json')
    And request request_0
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID
    * def envelopeID = response.docusignEnvelopeID

    * karate.pause(40000)
    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_1 = read('Test_3_CompleteDocusignContract_PresentedRequest.json')
    And request request_1
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_2 = read('Test_4_SOAP_QueryContract_getContractGUIDRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Test3contractID = response[0].contractID
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_3 = read('Test_6_modifyContract_PRESENTED_to_ACKNOWLEDGEDRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'CONTRACTMANAGEMENT-1038'
    And match response.message contains 'Acceptance Method is required'

    Examples:
      | Acc3             | Acc_Presented1   | TrackingCode | CSG_AcceptanceCode | TermID                            | TermType  | MarketId | TermName                                                                                      | TermLen | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | OrderId | OrderId2 | Outlet | Test2contractID                  |
      | 8210100200228895 | 8919100012222288 | CT339        | OT695              | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | COMMIT_VA | 9826    | Digital Starter Video and Blast! Internet Double Play: 2 Year Agreement with $50 Prepaid Card | 24      | $50 Prepaid Card | 75                    | 90           | 3             | 75.0     | 7.5        | 1       | 2        | 1      | 211e47902a6811eb97cfa725254498e0 |
 