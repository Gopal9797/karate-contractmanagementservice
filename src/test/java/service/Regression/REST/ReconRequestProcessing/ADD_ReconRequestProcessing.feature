Feature: CSSXCP-5058: Enhancement for Recon request processing - add contract tracking code

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * url Endpoint_REST
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}
    * def RecordContractRequest = read('RecordContractRequest.json')
    * def QueryContractRequest = read('QueryContractRequest.json')
    * def GetContractRequest = read('GetContractRequest.json')
    * def SubmitContractRequest = read('SubmitContractRequest.json')
    * def ModifyContractStatusModificationRequest = read('ModifyContractStatusModificationRequest.json')
    * def CMSAuthorization = Authorization
    * def CMTRestClient = call read('classpath:service/Regression/RestClient.feature@OAUTH2CMT')
    * def DbUtils = Java.type('service.Regression.util.PostgresDbUtils')
    * def configuration = { username: '#(cmt_db_username)', password: '#(cmt_db_password)', url: '#(DB_URL)', driverClassName: 'org.postgresql.Driver' }
    * def javaDBMethods = new DbUtils(configuration)

  @SubmitContract @ReconRequestProcessing
  Scenario Outline: SubmitContract - Recon Request Processing
    * def AccountNumber = <AccountNumber>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountNumber>"
    And request QueryContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    And match response == []

    Given url Endpoint_REST
    Given path '/recordContract'
    And request RecordContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    * def contractIDA = response.recordedContractSummary[0].contractID

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractIDA
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    * set ModifyContractStatusModificationRequest.status = 'ACKNOWLEDGED'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractIDA
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    * set ModifyContractStatusModificationRequest.status = 'ACCEPTED'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given path '/modifyContractStatusModification'
    And request ModifyContractStatusModificationRequest
    * set ModifyContractStatusModificationRequest.contractID = contractIDA
    * set ModifyContractStatusModificationRequest.orderID = '<OrderId>'
    * set ModifyContractStatusModificationRequest.status = 'TERMINATED'
    * set ModifyContractStatusModificationRequest.contractEndDate = global_extension.todaysDate
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/recordContract'
    And request RecordContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    * def contractIDB = response.recordedContractSummary[0].contractID

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountNumber>"
    And request QueryContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractIDA
    And match $response[*].contractID contains contractIDB
    And match $response[*].status contains 'TERMINATED'
    And match $response[*].status contains 'PRESENTED'

    * def contractGUIDA = contractIDA.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    Given url Endpoint_REST_CMT + contractGUIDA
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * def BeforeSubmit_CMTResponse = response

    * def contractGUIDB = contractIDA.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    Given url Endpoint_REST_CMT + contractGUIDB
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * def BeforeSubmit_CMTResponse = response

    * def ContractTable = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id in('" + contractGUIDA + "'," + contractGUIDB + "') order by created_ts desc;")
    * print ContractTable
    * match ContractTable[0].current_status == 'TERMINATED'
    * match ContractTable[1].current_status == 'PRESENTED'
    * print $ContractTable[*].contract_statuses
    * match $ContractTable[0].contract_statuses contains 'TERMINATED'
    * match $ContractTable[0].contract_statuses contains 'PRESENTED'
    * match $ContractTable[0].contract_statuses contains 'ACCEPTED'
    * match $ContractTable[0].contract_statuses contains 'ACKNOWLEDGED'
    * match $ContractTable[1].contract_statuses contains 'PRESENTED'

    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountNumber>"
    * set SubmitContractRequest.orderID = "<OrderId>"
    * def ReconAuth = karate.call('classpath:service/Regression/RestClient.feature@restclientRecon')
    And header Authorization = ReconAuth.ReconAuthorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountNumber>"
    And request QueryContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    And match $response[*].contractID contains contractIDA
    And match $response[*].contractID contains contractIDB
    And match $response[*].status contains 'ACCEPTED'
    And match $response[*].status contains 'TERMINATED'

    * def AfterSubmitContractTable = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id in('" + contractGUIDA + "'," + contractGUIDB + "') order by created_ts desc;")
    * print AfterSubmitContractTable
    * match ContractTable[0].current_status == 'ACCEPTED'
    * match ContractTable[1].current_status == 'TERMINATED'
    * print $ContractTable[*].contract_statuses
    * match $ContractTable[0].contract_statuses !contains 'TERMINATED'
    * match $ContractTable[0].contract_statuses contains 'PRESENTED'
    * match $ContractTable[0].contract_statuses contains 'ACCEPTED'
    * match $ContractTable[0].contract_statuses contains 'ACKNOWLEDGED'
    * match $ContractTable[1].contract_statuses contains 'TERMINATED'
    * match $ContractTable[1].contract_statuses contains 'PRESENTED'


    Examples:
      | AccountNumber    | OrderId | CSG_TrackingCode | TermID        | TermType     | MarketId | TermName                                        | TermLen  | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | Outlet |
      | 8919100012796133 | 979797  | HT468            | $230ETF_2YEAR | COMMIT_WO_VA | 9826     | 2 Year Contract with $230 Early Termination Fee | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 9876   |
