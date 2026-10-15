Feature: TestSuiteUS434123_CMS_QueryContract_POS_Status_OrderId

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @ignore @P2K @QueryContract
  Scenario Outline: TestSuiteUS434123_CMS_QueryContract_POS_Status_OrderId TestSuiteUS434123_CMS_QueryContract_POS_Status_OrderId
    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_0 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_0
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID == '#present'

    Examples:
      | Acc1             | Acc2             | Acc3             | TrackingCode | TrackingCode_Commit_WO_VA | AcceptanceCode | TermID                            | TermType  | MarketId | TermIDNotMatchChk                         | OrderId1 | OrderId2 | Outlet1 | Outlet2 | SignerEmail             | ContractId                       |
      | 8045100010263836 | 8045100010242343 | 8045100010242350 | CT339        | AT761                     | OT695          | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | COMMIT_VA | 23879    | TP_VIP_HDPM_200AMZ_$159.99x24_2Y_Q114_HVA | 1        | 2        | 1       | 2       | CMSQA@cable.comcast.com | 898c1160736511e99308e99915659e8a |
 