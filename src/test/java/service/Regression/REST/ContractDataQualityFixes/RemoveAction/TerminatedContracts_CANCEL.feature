Feature: SubmitContract - Recon Request processing - CANCEL Action on Terminated Contracts with Same & Different OrderIDs

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * url Endpoint_REST
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}
    * def RecordContractRequest = read('RecordContractRequest.json')
    * def QueryContractRequest = read('QueryContractRequest.json')
    * def GetContractRequest = read('GetContractRequest.json')
    * def SubmitContractRequest = read('SubmitContractRequest.json')
    * def ModifyContractStatusModificationRequest = read('ModifyContractStatusModificationRequest.json')

  @SubmitContract @ContractDataQualityFixes @CDQF_S7
  Scenario Outline: CANCEL Action for existing TERMINATED contract - Same Dated EndDate with same OrderID - ReconUserID
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
    * set ModifyContractStatusModificationRequest.status = 'TERMINATED'
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    * set ModifyContractStatusModificationRequest.contractEndDate = global_extension.todaysDate
    And header Authorization = Authorization
    When method POST
    Then status 200

    * def dbCall2 = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresTerminated')
    * match dbCall2.ContractInformation[0].current_status == 'TERMINATED'
    * string CONTRACT_STATUSES = dbCall2.ContractInformation[0].contract_statuses
    * match each $CONTRACT_STATUSES[*].work_order_id contains "<OrderId>"
    * match $CONTRACT_STATUSES[*].status_change_date contains global_extension.todaysDateISO

    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountNumber>"
    * set SubmitContractRequest.orderID = "<OrderId>"
    * set SubmitContractRequest.billingContractSpecification[0].action = 'CANCEL'
    * set SubmitContractRequest.billingContractSpecification[0].endDate = global_extension.todaysDate
    * def ReconAuth = karate.call('classpath:service/Regression/RestClient.feature@restclientRecon')
    And header Authorization = ReconAuth.ReconAuthorization
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
    * match REQUEST_OBJECT.billingContractSpecification[0].action contains "CANCEL"

    * def AfterSubmit_DBCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')
    * match AfterSubmit_DBCall.ContractInformation[0].current_status == 'PRESENTED'
    * string CONTRACT_STATUSES_AFTER = AfterSubmit_DBCall.ContractInformation[0].contract_statuses
    * print CONTRACT_STATUSES_AFTER
    * match $CONTRACT_STATUSES_AFTER[*].status_code !contains 'TERMINATED'
    * match each $CONTRACT_STATUSES_AFTER[*].work_order_id contains "<OrderId>"
    * match $CONTRACT_STATUSES_AFTER[*].modified_by !contains 'cmsreconuser'

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
    * match statusChangeDateConvertion !contains global_extension.todaysDatePlus3Years
    * match statusChangeDateConvertion contains global_extension.todaysDate

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * match response contains 'PRESENTED'
    * match response contains '<OrderId>'

    Examples:
      | AccountNumber    | OrderId   | CSG_TrackingCode | TermID                 |
      | 8919100012552767 | 723497239 | OT1BE            | $110ETF_1YEAR_SelfServ |
