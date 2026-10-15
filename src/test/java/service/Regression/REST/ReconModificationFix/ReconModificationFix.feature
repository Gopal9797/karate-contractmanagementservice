Feature: SubmitContract - ReconModificationFix

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * url Endpoint_REST
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}
    * def RecordContractRequest = read('RecordContractRequest.json')
    * def RecordContractRequest2 = read('RecordContractRequest2.json')
    * def QueryContractRequest = read('QueryContractRequest.json')
    * def GetContractRequest = read('GetContractRequest.json')
    * def SubmitContractRequest = read('SubmitContractRequest.json')
    * def CMSAuthorization = Authorization
    * def CMTRestClient = call read('classpath:service/Regression/RestClient.feature@OAUTH2CMT')
    * def DbUtils = Java.type('service.Regression.util.PostgresDbUtils')
    * def configuration = { username: '#(cmt_db_username)', password: '#(cmt_db_password)', url: '#(DB_URL)', driverClassName: 'org.postgresql.Driver' }
    * def javaDBMethods = new DbUtils(configuration)

  @SubmitContract @ReconModificationFix
  Scenario Outline: Whenever an Recon Request comes for a contract, there should be no change in OrderID - Defect Fix.
    * def AccountNumber = <AccountA>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountA>"
    And request QueryContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    And match response == []

    Given url Endpoint_REST
    Given path '/recordContract'
    And request RecordContractRequest
    * set RecordContractRequest.customerIdentifier.value = "<AccountA>"
    * set RecordContractRequest.RecordContractRequest.orderID = "<OrderId_Contract>"
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * def BeforeRecon_CMTResponse = response

    * def BeforeRecon_CMT_DB = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id = '" + contractGUID + "';")
    * print BeforeRecon_CMT_DB

    Given url Endpoint_REST
    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountA>"
    And request QueryContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    * def BeforeRecon_QueryContractResponse = response

    Given url Endpoint_REST
    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountA>"
    * set SubmitContractRequest.orderID = "<OrderId_Recon>"
    * def ReconAuth = karate.call('classpath:service/Regression/RestClient.feature@restclientRecon')
    And header Authorization = ReconAuth.ReconAuthorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountA>"
    And request QueryContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    * def AfterRecon_QueryContractResponse = response

    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * def AfterRecon_CMTResponse = response

    * def AfterRecon_CMT_DB = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id = '" + contractGUID + "';")
    * print AfterRecon_CMT_DB

    * print AfterRecon_CMT_DB[0].contract_statuses
    * print BeforeRecon_CMT_DB[0].contract_statuses

    * match AfterRecon_CMT_DB[0].contract_statuses == BeforeRecon_CMT_DB[0].contract_statuses
    Examples:
      | AccountA         | OrderId_Contract | OrderId_Recon | CSG_TrackingCode | TermID        | TermType     | MarketId | TermName                                        | TermLen  | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | Outlet |
      | 8919100012796133 | 979797           | 686868        | HT468            | $230ETF_2YEAR | COMMIT_WO_VA | 23879    | 2 Year Contract with $230 Early Termination Fee | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 9876   |
