Feature: TestSuiteUS434123_CMS_QueryContract_POS_Status_TermId

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @QueryContract  @QueryContract_004 @P2K @QueryContract_POS_Status_TermId
  Scenario Outline: TestSuiteUS434123_CMS_QueryContract_POS_Status_TermId
    * def AccountNumber = <Acc1>



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_6 = read('RecordContractRequest.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def ContractId = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_0 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_0
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any response[0].status
    And match response[0].contractID contains ContractId

    Examples:
      | Acc1             | TermID                                   | OrderId1 | billerTrackingCode |
      | 8919100012881703 | BB_VIP_HDPF_75_$119.99x12_2Y_Q214_230ETF | 97987    | AA11               |