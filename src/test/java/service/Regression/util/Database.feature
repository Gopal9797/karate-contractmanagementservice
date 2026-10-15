Feature: Create DB connection with DbUtils java class

  Background:
#    * print 'Database URL:', DB_URL
    * def DbUtils = Java.type('service.Regression.util.DbUtils')
    * def configuration = { username: '#(db_username)', password: '#(db_password)', url: #(DB_URL), driverClassName: 'datastax' }
    * def javaDBMethods = new DbUtils(configuration)

  @deleteContractFromDB
  Scenario: Deletes the Contract Information from Cassandra DB
    * print 'Database URL:', DB_URL

#    * def contractGUID = javaDBMethods.readRowsCassandraWithRow("select contract_guid from cms.contract where party_reference_id = '" + AccountNumber + "' and term_id = '" + TermID + "' allow filtering;")
    * def contractGUID = javaDBMethods.readRowsCassandraWithRow("select contract_guid from cms.contract where solr_query='{\"q\":\"party_reference_id:" + AccountNumber + " AND term_id:" + TermID + "\", \"sort\":\"created_dt asc\", \"paging\":\"driver\"}';")
#  select contract_guid from cms.contract where solr_query='{"q":"party_reference_id:8919100012890084 AND term_id:TP_VIP_X1Premier_200_$159.99x24_2Y_Q416_230ETF_SelfServ", "sort":"created_dt asc", "paging":"driver"}';
    * print 'Contract GUID:', contractGUID
    * if (contractGUID == "Nil") karate.abort()
    * def contractInfoDeleted = javaDBMethods.deleteRowsCassandra("delete from cms.contract where contract_guid in(" + contractGUID + ");")
    * print 'After Deleting:', contractInfoDeleted
    * match contractInfoDeleted contains '[]'

  @deleteAllContractsWithAccNumber
  Scenario: Deletes the Contract Information from Cassandra DB
    * print 'Database URL:', DB_URL
    * def contractGUID = javaDBMethods.readRowsCassandraWithRow("select contract_guid from cms.contract where solr_query='{\"q\":\"party_reference_id:" + AccountNumber + "\", \"sort\":\"created_dt asc\", \"paging\":\"driver\"}';")
#    * def contractGUID = javaDBMethods.readRowsCassandraWithRow("select contract_guid from cms.contract where party_reference_id = '" + AccountNumber + "' allow filtering;")
    * print 'Contract GUID:', contractGUID
    * if (contractGUID == "Nil") karate.abort()
    * def contractInfoDeleted = javaDBMethods.deleteRowsCassandra("delete from cms.contract where contract_guid in(" + contractGUID + ");")
    * print 'After Deleting:', contractInfoDeleted
    * match contractInfoDeleted contains '[]'

  @deleteMultipleContracts
  Scenario: Deletes the Contract Information from Cassandra DB
    * def contractInfoDeleted = javaDBMethods.deleteRowsCassandra("delete from cms.contract where contract_guid in(" + contractGUID + ");")
    * print 'After Deleting:', contractInfoDeleted
    * match contractInfoDeleted contains '[]'

  @selectContract
  Scenario: Retrieves the Contract Information from Cassandra DB
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractInfo = javaDBMethods.readRowsCassandraWithRow("select * from cms.contract where contract_guid in(" + contractGUID + ");")
    * print 'Contract Information:', contractInfo
    * match contractInfo !contains "Nil"
    * match contractInfo contains contractGUID
    * match contractInfo contains "PRESENTED"

  @selectContract_Accepted
  Scenario: Retrieves the Contract Information from Cassandra DB
    * def contractGUID = contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractInfo = javaDBMethods.readRowsCassandraWithRow("select * from cms.contract where contract_guid in(" + contractGUID + ");")
    * print 'Contract Information:', contractInfo
    * match contractInfo !contains "Nil"
    * match contractInfo contains contractGUID
    * match contractInfo contains "ACCEPTED"

  @readarecord
  Scenario: Retrieves the Contract Information from Cassandra DB
    * def contract_atrributes = javaDBMethods.readARecordCassandra("select contract_attributes from cms.contract where contract_guid=fd73dc80-21c7-11ec-b4aa-253ffbc4142e;")
    * print contract_atrributes


  @deletePartyFromPartyTable
  Scenario: Deletes Party From Party Table - Cassandra DB
    * def PartyGUID = javaDBMethods.readRowsCassandraWithRow("select party_guid from cms.party where party_reference_id = '" + AccountNumber + "' allow filtering;")
    * print 'Party GUID:', PartyGUID
    * if (PartyGUID == "Nil") karate.abort()
    * def PartyInfoDeleted = javaDBMethods.deleteRowsCassandra("delete from cms.party where party_guid in(" + PartyGUID + ");")
    * print 'After Deleting:', PartyInfoDeleted
    * match PartyInfoDeleted contains '[]'

  @selectPartyFromPartyTable
  Scenario: Reads Party From Party Table - Cassandra DB
    * def PartyGUID_cassandra = javaDBMethods.readRowsCassandraWithRow("select party_guid from cms.party where party_reference_id = '" + AccountNumber + "' allow filtering;")
    * print 'Party GUID:', PartyGUID_cassandra