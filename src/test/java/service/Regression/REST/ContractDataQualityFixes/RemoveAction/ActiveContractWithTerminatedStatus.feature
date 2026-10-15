Feature: SubmitContract - Recon Request processing - With TERMINATED status

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * url Endpoint_REST
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}
    * def RecordContractRequest = read('RecordContractRequest.json')
    * def QueryContractRequest = read('QueryContractRequest.json')
    * def GetContractRequest = read('GetContractRequest.json')
    * def SubmitContractRequest = read('SubmitContractRequest.json')
    * def ModifyContractStatusModificationRequest = read('ModifyContractStatusModificationRequest.json')

#  gradlew test -Dkarate.configpassword= -Dkarate.coreTablesLocal=Y -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @ContractDataQualityFixes"
  @SubmitContract @ContractDataQualityFixes @CDQF_S2a
  Scenario Outline: Remove Action for existing ACTIVE Contract - With Terminated status in CONTRACT_STATUSES Field - PRESENTED status
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given path '/recordContract'
    And request RecordContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true

    * def dbCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')
    * match dbCall.ContractInformation[0].current_status == 'PRESENTED'
    * def CONTRACT_STATUSES = dbCall.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES
    * match $CONTRACT_STATUSES[*].status_code !contains 'TERMINATED'
    * match each $CONTRACT_STATUSES[*].work_order_id contains "<OrderId>"

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractID
    * set ModifyContractStatusModificationRequest.status = 'TERMINATED'
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    * set ModifyContractStatusModificationRequest.contractEndDate = global_extension.fiveDaysAfter
    And header Authorization = Authorization
    When method POST
    Then status 200

    * def dbCall2 = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')
    * match dbCall2.ContractInformation[0].current_status == 'PRESENTED'
    * string CONTRACT_STATUSES = dbCall2.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES
    * match $CONTRACT_STATUSES[*].status_code contains 'TERMINATED'
    * match each $CONTRACT_STATUSES[*].work_order_id contains "<OrderId>"
    * print global_extension.fiveDaysAfterISO
    * match $CONTRACT_STATUSES[*].status_change_date contains global_extension.fiveDaysAfterISO

    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountNumber>"
    * set SubmitContractRequest.orderID = "<OrderId>"
    * set SubmitContractRequest.billingContractSpecification[0].endDate = global_extension.todaysDatePlus3Years
#    * def ReconAuth = karate.call('classpath:service/Regression/RestClient.feature@restclientRecon')
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    * def query = "Select * from async_operations_log where account_num = '"+AccountNumber+"' and message_ts > '" + global_extension.currentTimeInTimestamp + " 'order by message_ts desc;"
    * def queryResult = call read('classpath:service/Regression/util/CoreTables.feature@async_operations_log')
    * print queryResult.async_operations_log
    * match queryResult.async_operations_log[*].STATUS_CD contains 'SUCCESS'
    * json REQUEST_OBJECT = queryResult.async_operations_log[0].request_object
    * match REQUEST_OBJECT.accountNumber contains "<AccountNumber>"
    * match REQUEST_OBJECT.orderID contains "<OrderId>"
    * match REQUEST_OBJECT.billingContractSpecification[0].billingCode contains "<CSG_TrackingCode>"
    * match REQUEST_OBJECT.billingContractSpecification[0].action contains "REMOVE"

    * def AfterSubmit_DBCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')
    * match AfterSubmit_DBCall.ContractInformation[0].current_status == 'PRESENTED'
    * string CONTRACT_STATUSES_AFTER = AfterSubmit_DBCall.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES_AFTER
    * match $CONTRACT_STATUSES_AFTER[*].status_code contains 'TERMINATED'
    * match each $CONTRACT_STATUSES_AFTER[*].work_order_id contains "<OrderId>"
#    * print global_extension.todaysDatePlus3YearsISO
#    * match $CONTRACT_STATUSES_AFTER[*].status_change_date contains global_extension.todaysDatePlus3YearsISO


    * def STATUS_CHANGE_DATE = $CONTRACT_STATUSES_AFTER[*].status_change_date
    * print STATUS_CHANGE_DATE
    * def statusChangeDateConvertionFn =
    """
      function(input)
      { const output = [];
      for(var i=0;i<=input.length-1;i++)
       {
        console.log(input[i])
        date = new Date(input[i]);
        year = date.getFullYear();
        month = date.getMonth()+1;
        dt = date.getDate();
        if (dt < 10)
          dt = '0' + dt;
        if (month < 10)
          month = '0' + month;
        console.log("The output is: ");
        console.log(year+'-' + month + '-'+dt);
        output[i] = year+'-' + month + '-'+dt;
       }
       return output;
      }
      """
    * def statusChangeDateConvertion = statusChangeDateConvertionFn(STATUS_CHANGE_DATE)
    * print statusChangeDateConvertion
    * match statusChangeDateConvertion contains global_extension.todaysDatePlus3Years

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * match response contains 'PRESENTED'
    * match response contains '<OrderId>'

    Examples:
      | AccountNumber    | OrderId  | CSG_TrackingCode | TermID                 |
      | 8919100011363729 | 11111111 | OT1BE            | $110ETF_1YEAR_SelfServ |

  @SubmitContract @ContractDataQualityFixes @CDQF_S2b
  Scenario Outline: Remove Action for existing ACTIVE Contract - With Terminated status in CONTRACT_STATUSES Field - ACKNOWLEDGED status
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given path '/recordContract'
    And request RecordContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractID
    * set ModifyContractStatusModificationRequest.status = 'ACKNOWLEDGED'
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractID
    * set ModifyContractStatusModificationRequest.status = 'TERMINATED'
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    * set ModifyContractStatusModificationRequest.contractEndDate = global_extension.fiveDaysAfter
    And header Authorization = Authorization
    When method POST
    Then status 200

    * def dbCall2 = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAcknowledged')
    * match dbCall2.ContractInformation[0].current_status == 'ACKNOWLEDGED'
    * string CONTRACT_STATUSES = dbCall2.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES
    * match $CONTRACT_STATUSES[*].status_code contains 'TERMINATED'
    * match each $CONTRACT_STATUSES[*].work_order_id contains "<OrderId>"
    * print global_extension.fiveDaysAfterISO
    * match $CONTRACT_STATUSES[*].status_change_date contains global_extension.fiveDaysAfterISO

    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountNumber>"
    * set SubmitContractRequest.orderID = "<OrderId>"
    * set SubmitContractRequest.billingContractSpecification[0].endDate = global_extension.todaysDatePlus3Years
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    * def query = "Select * from async_operations_log where account_num = '"+AccountNumber+"' and message_ts > '" + global_extension.currentTimeInTimestamp + " 'order by message_ts desc;"
    * def queryResult = call read('classpath:service/Regression/util/CoreTables.feature@async_operations_log')
    * print queryResult.async_operations_log
    * match queryResult.async_operations_log[*].STATUS_CD contains 'SUCCESS'
    * json REQUEST_OBJECT = queryResult.async_operations_log[0].request_object
    * match REQUEST_OBJECT.accountNumber contains "<AccountNumber>"
    * match REQUEST_OBJECT.orderID contains "<OrderId>"
    * match REQUEST_OBJECT.billingContractSpecification[0].billingCode contains "<CSG_TrackingCode>"
    * match REQUEST_OBJECT.billingContractSpecification[0].action contains "REMOVE"

    * def AfterSubmit_DBCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAcknowledged')
    * match AfterSubmit_DBCall.ContractInformation[0].current_status == 'ACKNOWLEDGED'
    * string CONTRACT_STATUSES_AFTER = AfterSubmit_DBCall.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES_AFTER
    * match $CONTRACT_STATUSES_AFTER[*].status_code contains 'TERMINATED'
    * match each $CONTRACT_STATUSES_AFTER[*].work_order_id contains "<OrderId>"
#    * print global_extension.todaysDatePlus3YearsISO
#    * match $CONTRACT_STATUSES_AFTER[*].status_change_date contains global_extension.todaysDatePlus3YearsISO


    * def STATUS_CHANGE_DATE = $CONTRACT_STATUSES_AFTER[*].status_change_date
    * print STATUS_CHANGE_DATE
    * def statusChangeDateConvertionFn =
    """
      function(input)
      { const output = [];
      for(var i=0;i<=input.length-1;i++)
       {
        console.log(input[i])
        date = new Date(input[i]);
        year = date.getFullYear();
        month = date.getMonth()+1;
        dt = date.getDate();
        if (dt < 10)
          dt = '0' + dt;
        if (month < 10)
          month = '0' + month;
        console.log("The output is: ");
        console.log(year+'-' + month + '-'+dt);
        output[i] = year+'-' + month + '-'+dt;
       }
       return output;
      }
      """
    * def statusChangeDateConvertion = statusChangeDateConvertionFn(STATUS_CHANGE_DATE)
    * print statusChangeDateConvertion
    * match statusChangeDateConvertion contains global_extension.todaysDatePlus3Years

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * match response contains 'ACKNOWLEDGED'
    * match response contains '<OrderId>'

    Examples:
      | AccountNumber    | OrderId  | CSG_TrackingCode | TermID                 |
      | 8919100012379807 | 22222222 | OT1BE            | $110ETF_1YEAR_SelfServ |

  @SubmitContract @ContractDataQualityFixes @CDQF_S2c
  Scenario Outline: Remove Action for existing ACTIVE Contract - With Terminated status in CONTRACT_STATUSES Field - ACCEPTED status
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given path '/recordContract'
    And request RecordContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractID
    * set ModifyContractStatusModificationRequest.status = 'ACCEPTED'
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractID
    * set ModifyContractStatusModificationRequest.status = 'TERMINATED'
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    * set ModifyContractStatusModificationRequest.contractEndDate = global_extension.fiveDaysAfter
    And header Authorization = Authorization
    When method POST
    Then status 200

    * def dbCall2 = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAccepted')
    * match dbCall2.ContractInformation[0].current_status == 'ACCEPTED'
    * string CONTRACT_STATUSES = dbCall2.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES
    * match $CONTRACT_STATUSES[*].status_code contains 'TERMINATED'
    * match each $CONTRACT_STATUSES[*].work_order_id contains "<OrderId>"
    * print global_extension.fiveDaysAfterISO
    * match $CONTRACT_STATUSES[*].status_change_date contains global_extension.fiveDaysAfterISO

    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountNumber>"
    * set SubmitContractRequest.orderID = "<OrderId>"
    * set SubmitContractRequest.billingContractSpecification[0].endDate = global_extension.todaysDatePlus3Years
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    * def query = "Select * from async_operations_log where account_num = '"+AccountNumber+"' and message_ts > '" + global_extension.currentTimeInTimestamp + " 'order by message_ts desc;"
    * def queryResult = call read('classpath:service/Regression/util/CoreTables.feature@async_operations_log')
    * print queryResult.async_operations_log
    * match queryResult.async_operations_log[*].STATUS_CD contains 'SUCCESS'
    * json REQUEST_OBJECT = queryResult.async_operations_log[0].request_object
    * match REQUEST_OBJECT.accountNumber contains "<AccountNumber>"
    * match REQUEST_OBJECT.orderID contains "<OrderId>"
    * match REQUEST_OBJECT.billingContractSpecification[0].billingCode contains "<CSG_TrackingCode>"
    * match REQUEST_OBJECT.billingContractSpecification[0].action contains "REMOVE"

    * def AfterSubmit_DBCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAccepted')
    * match AfterSubmit_DBCall.ContractInformation[0].current_status == 'ACCEPTED'
    * string CONTRACT_STATUSES_AFTER = AfterSubmit_DBCall.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES_AFTER
    * match $CONTRACT_STATUSES_AFTER[*].status_code contains 'TERMINATED'
    * match each $CONTRACT_STATUSES_AFTER[*].work_order_id contains "<OrderId>"
#    * print global_extension.todaysDatePlus3YearsISO
#    * match $CONTRACT_STATUSES_AFTER[*].status_change_date contains global_extension.todaysDatePlus3YearsISO


    * def STATUS_CHANGE_DATE = $CONTRACT_STATUSES_AFTER[*].status_change_date
    * print STATUS_CHANGE_DATE
    * def statusChangeDateConvertionFn =
    """
      function(input)
      { const output = [];
      for(var i=0;i<=input.length-1;i++)
       {
        console.log(input[i])
        date = new Date(input[i]);
        year = date.getFullYear();
        month = date.getMonth()+1;
        dt = date.getDate();
        if (dt < 10)
          dt = '0' + dt;
        if (month < 10)
          month = '0' + month;
        console.log("The output is: ");
        console.log(year+'-' + month + '-'+dt);
        output[i] = year+'-' + month + '-'+dt;
       }
       return output;
      }
      """
    * def statusChangeDateConvertion = statusChangeDateConvertionFn(STATUS_CHANGE_DATE)
    * print statusChangeDateConvertion
    * match statusChangeDateConvertion contains global_extension.todaysDatePlus3Years

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * match response contains 'ACCEPTED'
    * match response contains '<OrderId>'

    Examples:
      | AccountNumber    | OrderId  | CSG_TrackingCode | TermID                 |
      | 8919100011341451 | 33333333 | OT1BE            | $110ETF_1YEAR_SelfServ |

  @SubmitContract @ContractDataQualityFixes @CDQF_S2d
  Scenario Outline: Remove Action for existing ACTIVE Contract - With Terminated status in CONTRACT_STATUSES Field - DECLINED status
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given path '/recordContract'
    And request RecordContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractID
    * set ModifyContractStatusModificationRequest.status = 'DECLINED'
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractID
    * set ModifyContractStatusModificationRequest.status = 'TERMINATED'
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    * set ModifyContractStatusModificationRequest.contractEndDate = global_extension.fiveDaysAfter
    And header Authorization = Authorization
    When method POST
    Then status 200

    * def dbCall2 = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresDeclined')
    * match dbCall2.ContractInformation[0].current_status == 'DECLINED'
    * string CONTRACT_STATUSES = dbCall2.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES
    * match $CONTRACT_STATUSES[*].status_code contains 'TERMINATED'
    * match each $CONTRACT_STATUSES[*].work_order_id contains "<OrderId>"
    * print global_extension.fiveDaysAfterISO
    * match $CONTRACT_STATUSES[*].status_change_date contains global_extension.fiveDaysAfterISO

    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountNumber>"
    * set SubmitContractRequest.orderID = "<OrderId>"
    * set SubmitContractRequest.billingContractSpecification[0].endDate = global_extension.todaysDatePlus3Years
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    * def query = "Select * from async_operations_log where account_num = '"+AccountNumber+"' and message_ts > '" + global_extension.currentTimeInTimestamp + " 'order by message_ts desc;"
    * def queryResult = call read('classpath:service/Regression/util/CoreTables.feature@async_operations_log')
    * print queryResult.async_operations_log
    * match queryResult.async_operations_log[*].STATUS_CD contains 'SUCCESS'
    * json REQUEST_OBJECT = queryResult.async_operations_log[0].request_object
    * match REQUEST_OBJECT.accountNumber contains "<AccountNumber>"
    * match REQUEST_OBJECT.orderID contains "<OrderId>"
    * match REQUEST_OBJECT.billingContractSpecification[0].billingCode contains "<CSG_TrackingCode>"
    * match REQUEST_OBJECT.billingContractSpecification[0].action contains "REMOVE"

    * def AfterSubmit_DBCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresDeclined')
    * match AfterSubmit_DBCall.ContractInformation[0].current_status == 'DECLINED'
    * string CONTRACT_STATUSES_AFTER = AfterSubmit_DBCall.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES_AFTER
    * match $CONTRACT_STATUSES_AFTER[*].status_code contains 'TERMINATED'
    * match each $CONTRACT_STATUSES_AFTER[*].work_order_id contains "<OrderId>"
#    * print global_extension.todaysDatePlus3YearsISO
#    * match $CONTRACT_STATUSES_AFTER[*].status_change_date contains global_extension.todaysDatePlus3YearsISO


    * def STATUS_CHANGE_DATE = $CONTRACT_STATUSES_AFTER[*].status_change_date
    * print STATUS_CHANGE_DATE
    * def statusChangeDateConvertionFn =
    """
      function(input)
      { const output = [];
      for(var i=0;i<=input.length-1;i++)
       {
        console.log(input[i])
        date = new Date(input[i]);
        year = date.getFullYear();
        month = date.getMonth()+1;
        dt = date.getDate();
        if (dt < 10)
          dt = '0' + dt;
        if (month < 10)
          month = '0' + month;
        console.log("The output is: ");
        console.log(year+'-' + month + '-'+dt);
        output[i] = year+'-' + month + '-'+dt;
       }
       return output;
      }
      """
    * def statusChangeDateConvertion = statusChangeDateConvertionFn(STATUS_CHANGE_DATE)
    * print statusChangeDateConvertion
    * match statusChangeDateConvertion contains global_extension.todaysDatePlus3Years

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * match response contains 'DECLINED'
    * match response contains '<OrderId>'

    Examples:
      | AccountNumber    | OrderId  | CSG_TrackingCode | TermID                 |
      | 8919100012359296 | 44444444 | OT1BE            | $110ETF_1YEAR_SelfServ |
