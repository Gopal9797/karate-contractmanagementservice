Feature: SubmitContract - AddRemoveScenario

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * url Endpoint_REST
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}
    * def RecordContractRequest = read('RecordContractRequest.json')
    * def QueryContractRequest = read('QueryContractRequest.json')
    * def GetContractRequest = read('GetContractRequest.json')
    * def SubmitContractRequest = read('SubmitContractRequest.json')
    * def CMSAuthorization = Authorization
    * def CMTRestClient = call read('classpath:service/Regression/RestClient.feature@OAUTH2CMT')
    * def DbUtils = Java.type('service.Regression.util.PostgresDbUtils')
    * def configuration = { username: '#(cmt_db_username)', password: '#(cmt_db_password)', url: '#(DB_URL)', driverClassName: 'org.postgresql.Driver' }
    * def javaDBMethods = new DbUtils(configuration)

  @SubmitContract @AddRemoveScenario
  Scenario Outline: Whenever an Submit Request comes with both ADD & REMOVE for same TermID, it should just modify the startdate and terminateddate of the existing contract and should not create a new contract
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
    * def contractID = response.recordedContractSummary[0].contractID

    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * def BeforeSubmit_CMTResponse = response


    * def BeforeSubmit_CMT_DB = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id = '" + contractGUID + "';")
    * print BeforeSubmit_CMT_DB

    Given url Endpoint_REST
    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountNumber>"
    And request QueryContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    * def BeforeSubmit_QueryContractResponse = response

    Given url Endpoint_REST
    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountNumber>"
    * def ReconAuth = karate.call('classpath:service/Regression/RestClient.feature@restclientRecon')
    And header Authorization = ReconAuth.ReconAuthorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountNumber>"
    And request QueryContractRequest
    And header Authorization = CMSAuthorization
    When method POST
    Then status 200
    * def AfterSubmit_QueryContractResponse = response

    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * def AfterSubmit_CMTResponse = response

    * match AfterSubmit_CMTResponse.contractStartDate == global_extension.fiveDaysAfter
    * match AfterSubmit_CMTResponse.contractScheduledDate == global_extension.fiveDaysAfter
    * match AfterSubmit_CMTResponse.contractTerminationDate == global_extension.fiveDaysnTwoYearsAfter
    * match AfterSubmit_CMTResponse.contractStartDate == SubmitContractRequest.billingContractSpecification[0].startDate
    * match AfterSubmit_CMTResponse.contractScheduledDate == SubmitContractRequest.billingContractSpecification[0].startDate
#    * match AfterSubmit_CMTResponse.contractTerminationDate == SubmitContractRequest.billingContractSpecification[0].endDate


    * def AfterSubmit_CMT_DB = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id = '" + contractGUID + "';")
    * print AfterSubmit_CMT_DB

    Examples:
      | AccountNumber    | OrderId | CSG_TrackingCode | TermID        | TermType     | MarketId | TermName                                        | TermLen  | ProductDesc      | RequiredServicePeriod | CancelPeriod | DeclinePeriod | StartAmt | DeclineAmt | Outlet |
      | 8919100012796133 | 979797  | HT468            | $230ETF_2YEAR | COMMIT_WO_VA | 9826    | 2 Year Contract with $230 Early Termination Fee | 24 MONTH | $50 Prepaid Card | 75                    | 30           | 1             | 230      | 10         | 9876   |
