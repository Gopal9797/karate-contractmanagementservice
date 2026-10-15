Feature: Create DB connection with DbUtils java class

  Background:
    * def DbUtils = Java.type('service.Regression.util.PostgresDbUtils')
    * def configuration = { username: '#(cmt_db_username)', password: '#(cmt_db_password)', url: '#(DB_URL)', driverClassName: 'org.postgresql.Driver' }
    * def javaDBMethods = new DbUtils(configuration)
    * def CMTRestClient = call read('classpath:service/Regression/RestClient.feature@OAUTH2CMT')

  @readRowsPostgres
  Scenario: Retrieves the Contract Information from CMT - Postgres DB
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def ContractInformation = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id ='"+contractGUID+"'")
    * print ContractInformation
    * match $ContractInformation[*].contract_id contains contractGUID
#    * match $ContractInformation[*].current_status contains "PRESENTED"
    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * match $response.contractStatuses[*].statusCode contains "PRESENTED"

  @readRowsPostgresAcknowledged
  Scenario: Retrieves the Contract Information from CMT - Postgres DB
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def ContractInformation = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id ='"+contractGUID+"'")
    * print ContractInformation
    * match $ContractInformation[*].contract_id contains contractGUID
#    * match $ContractInformation[*].current_status contains "ACKNOWLEDGED"
    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * match $response.contractStatuses[*].statusCode contains "ACKNOWLEDGED"

  @readRowsPostgresAccepted
  Scenario: Retrieves the Contract Information from CMT - Postgres DB
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def ContractInformation = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id ='"+contractGUID+"'")
    * print ContractInformation
    * match $ContractInformation[*].contract_id contains contractGUID
#    * match $ContractInformation[*].current_status contains "ACCEPTED"
    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * match $response.contractStatuses[*].statusCode contains "ACCEPTED"

  @readRowsPostgresDeclined
  Scenario: Retrieves the Contract Information from CMT - Postgres DB
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def ContractInformation = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id ='"+contractGUID+"'")
    * print ContractInformation
    * match $ContractInformation[*].contract_id contains contractGUID
#    * match $ContractInformation[*].current_status contains "DECLINED"
    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * match $response.contractStatuses[*].statusCode contains "DECLINED"

  @readRowsPostgresTerminated
  Scenario: Retrieves the Contract Information from CMT - Postgres DB
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def ContractInformation = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id ='"+contractGUID+"'")
    * print ContractInformation
    * match $ContractInformation[*].contract_id contains contractGUID
#    * match $ContractInformation[*].current_status contains "TERMINATED"
    Given url Endpoint_REST_CMT + contractGUID
    And header Authorization = CMTRestClient.CMTAuthorization
    When method GET
    Then status 200
    * match $response.contractStatuses[*].statusCode contains "TERMINATED"


  @deleteRowsPostgres
  Scenario: Deletes the Contract Information from CMT - Postgres DB
    * def contractGUID = javaDBMethods.readRowsPostgres("select contract_id from cms.CONTRACT where term_id = '" + TermID + "' AND party_id in(select party_id from cms.party where party_reference_id = '" + AccountNumber + "');")
    * print 'Contract GUID:', contractGUID
    * def contractIDs = $contractGUID[*].contract_id
    * print contractIDs
    * def contractInfoDeletion = function(i){javaDBMethods.deleteRowsPostgres("delete from cms.contract where contract_id in('" + contractIDs[i] + "');")}
    * karate.repeat(contractIDs.length,contractInfoDeletion)
    * def contractGUID = javaDBMethods.readRowsPostgres("select contract_id from cms.CONTRACT where term_id = '" + TermID + "' AND party_id in(select party_id from cms.party where party_reference_id = '" + AccountNumber + "');")
    * print 'Contract GUID:', contractGUID

#  -- ContractIDs for Termid & AccountNumber Combination
#  select * from cms.CONTRACT where term_id = '$110ETF_1YEAR' AND party_id = (select party_id from cms.party where party_reference_id = '8155100515737637');

#  -- ContractIDs for AccountNumbers
#  select * from cms.CONTRACT where party_id = (select party_id from cms.party where party_reference_id = '8155100515737637');

  @deleteAllContractsWithAccNumber
  Scenario: Deletes the Contract Information from CMT - Postgres DB
    * def contractGUID = javaDBMethods.readRowsPostgres("select contract_id from cms.CONTRACT where party_id in(select party_id from cms.party where party_reference_id = '" + AccountNumber + "');")
    * print 'Contract GUID:', contractGUID
    * if (contractGUID == []) karate.abort()
    * def contractIDs = $contractGUID[*].contract_id
    * print contractIDs
    * def contractInfoDeletion = function(i){javaDBMethods.deleteRowsPostgres("delete from cms.contract where contract_id in('" + contractIDs[i] + "');")}
    * karate.repeat(contractIDs.length,contractInfoDeletion)
    * def AftercontractGUID = javaDBMethods.readRowsPostgres("select contract_id from cms.CONTRACT where party_id in(select party_id from cms.party where party_reference_id = '" + AccountNumber + "');")
    * print 'Contract GUID:', AftercontractGUID

  @deleteMultipleContracts
  Scenario: Deletes the Contract Information from CMT - CMT Postgres DB
    * def contractInfoDeletion = function(i){javaDBMethods.deleteRowsPostgres("delete from cms.contract where contract_id in('" + contractGUID[i] + "');")}
    * karate.repeat(contractIDs.length,contractInfoDeletion)

  @deletePartyFromPartyTable
  Scenario: Deletes Party From Party Table - CMT Postgres DB
    * def partyDeleting = javaDBMethods.deleteRowsPostgres("delete from cms.party where party_reference_id = '" + AccountNumber + "';")
    * print 'partyDeleting', partyDeleting

  @selectPartyFromPartyTable
  Scenario: Reads Party From Party Table
    * def PartyID_CMT = javaDBMethods.readRowsPostgres("select party_id from cms.party where party_reference_id = '" + AccountNumber + "';")
    * print 'Party GUID:', PartyID_CMT

  @deleteRowsPostgresPhoneNumber
  Scenario: Deletes the Contract Information from CMT - Postgres DB for PhoneNumber
    * def contractGUID = javaDBMethods.readRowsPostgres("select contract_id from cms.CONTRACT where term_id = '" + TermID + "' AND party_id in(select party_id from cms.party where party_reference_id = '" + PhoneNumberDef + "');")
    * print 'Contract GUID:', contractGUID
    * def contractIDs = $contractGUID[*].contract_id
    * print contractIDs
    * def contractInfoDeletion = function(i){javaDBMethods.deleteRowsPostgres("delete from cms.contract where contract_id in('" + contractIDs[i] + "');")}
    * karate.repeat(contractIDs.length,contractInfoDeletion)
    * def contractGUID = javaDBMethods.readRowsPostgres("select contract_id from cms.CONTRACT where term_id = '" + TermID + "' AND party_id in(select party_id from cms.party where party_reference_id = '" + PhoneNumberDef + "');")
    * print 'Contract GUID:', contractGUID

  @deleteRowsPostgresEmailAddress
  Scenario: Deletes the Contract Information from CMT - Postgres DB for PhoneNumber
    * def contractGUID = javaDBMethods.readRowsPostgres("select contract_id from cms.CONTRACT where term_id = '" + TermID + "' AND party_id in(select party_id from cms.party where party_reference_id = '" + EmailAddressDef + "');")
    * print 'Contract GUID:', contractGUID
    * def contractIDs = $contractGUID[*].contract_id
    * print contractIDs
    * def contractInfoDeletion = function(i){javaDBMethods.deleteRowsPostgres("delete from cms.contract where contract_id in('" + contractIDs[i] + "');")}
    * karate.repeat(contractIDs.length,contractInfoDeletion)
    * def contractGUID = javaDBMethods.readRowsPostgres("select contract_id from cms.CONTRACT where term_id = '" + TermID + "' AND party_id in(select party_id from cms.party where party_reference_id = '" + EmailAddressDef + "');")
    * print 'Contract GUID:', contractGUID

  @selectPartyFromPartyTablePhoneNumber
  Scenario: Reads Party From Party Table
    * def PartyID_CMT = javaDBMethods.readRowsPostgres("select party_id from cms.party where party_reference_id = '" + PhoneNumberDef + "';")
    * print 'Party GUID:', PartyID_CMT
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def ContractInformation = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id ='"+contractGUID+"'")
    * print ContractInformation
    * match $ContractInformation[*].party_id contains PartyID_CMT[0].party_id

  @selectPartyFromPartyTableEmailAddress
  Scenario: Reads Party From Party Table
    * def PartyID_CMT = javaDBMethods.readRowsPostgres("select party_id from cms.party where party_reference_id = '" + EmailAddressDef + "';")
    * print 'Party GUID:', PartyID_CMT
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def ContractInformation = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id ='"+contractGUID+"'")
    * print ContractInformation
    * match $ContractInformation[*].party_id contains PartyID_CMT[0].party_id

  @readRowsPlatco
  Scenario: Retrieves the Contract Information from CMT - Postgres DB
    * def ContractInformation = javaDBMethods.readRowsPostgres("select * from cms.contract where contract_id ='"+contractID+"'")
    * print ContractInformation
    * match $ContractInformation[*].contract_id contains contractID

    * def PartyInformation = javaDBMethods.readRowsPostgres("select * from cms.party where party_reference_id ='"+customerRelationshipID+"'")
    * print PartyInformation
    * match $PartyInformation[*].party_reference_id contains customerRelationshipID