Feature: SubmitContract_ActiveInvalidTermID

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}
    * def SubmitContractRequest = read('ActiveInactiveSubmitContractRequest.json')
    * def QueryContractRequest = read('QueryContractRequest.json')

  @SubmitContract @Negative @InactiveTermID @ContractDataQualityFixes @Retest
  Scenario Outline: SubmitContract with InactiveTermID
    * def AccountNumber = '<AccountNumber>'
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given url Endpoint_REST
    Given path '/submitContract'
    And request SubmitContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200

    * karate.pause(40000)
    * def query = "Select * from async_operations_log where account_num = '"+AccountNumber+"' and message_ts > '" + global_extension.currentTimeInTimestamp + " 'order by message_ts desc;"
    * def queryResult = call read('classpath:service/Regression/util/CoreTables.feature@async_operations_log')
    * print queryResult.async_operations_log
    * match queryResult.async_operations_log[*].account_num contains '<AccountNumber>'
    * match queryResult.async_operations_log[*].STATUS_CD contains 'FAILED'
    * match queryResult.async_operations_log[*].error_cd contains 'CONTRACTMANAGEMENT-1095'
    * def ERROR_MSG_TEXT = $queryResult.async_operations_log[*].error_msg_text
    * match $queryResult.async_operations_log[*].error_msg_text contains 'NED_50_Q217_VA'
    * match $queryResult.async_operations_log[*].error_msg_text contains 'XH_SEC300_$29.95x12_2Y_Q414'
    * match $queryResult.async_operations_log[*].error_msg_text contains 'TP_VIP_HDPP_$139.99x24_2Y_Q413_NED_RET'

    Given url Endpoint_REST
    Given path '/queryContract'
    And request QueryContractRequest
    * set QueryContractRequest.termID[0] = 'NED_50_Q217_VA'
    * set QueryContractRequest.termID[1] = 'XH_SEC300_$29.95x12_2Y_Q414'
    * set QueryContractRequest.termID[2] = 'TP_VIP_HDPP_$139.99x24_2Y_Q413_NED_RET'
    * set QueryContractRequest.termID[3] = '$110ETF_1YEAR_SelfServ'
    * set QueryContractRequest.termID[4] = '$230ETF_2YEAR'
    And header Authorization = Authorization
    When method POST
    Then status 200
    * match $response[*].termID !contains 'NED_50_Q217_VA'
    * match $response[*].termID !contains 'XH_SEC300_$29.95x12_2Y_Q414'
    * match $response[*].termID !contains 'TP_VIP_HDPP_$139.99x24_2Y_Q413_NED_RET'
    * match $response[*].termID contains '$110ETF_1YEAR_SelfServ'
    * match $response[*].termID contains '$230ETF_2YEAR'


    Examples:
      | AccountNumber    |
      | 8919100012795499 |

