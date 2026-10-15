Feature: Python Sample

  Background:
    * def DbUtils = Java.type('service.Regression.util.DbUtils')
    * def configuration = { username: '#(db_username)', password: '#(db_password)', url: #(DB_URL), driverClassName: 'datastax' }
    * def javaDBMethods = new DbUtils(configuration)

#  gradlew test -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @samplePy"
#  gradlew test -Dkarate.env=qa -Dkarate.options="--tags @samplePy"
  @samplePy
  Scenario: Call Sample Python
#    * def result = karate.exec('python src/test/java/service/Regression/util/dbcompare.py fd73dc80-21c7-11ec-b4aa-253ffbc4142e c044594d-eb98-4514-b0d0-04ea0c3a0a97')
    * print 'ProdCodeContractID: ', ProdCodeContractID,
    * print 'CMTChangesContractID: ', CMTChangesContractID
    * def contractGUID_ProdCode = ProdCodeContractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractGUID_CMTChanges = CMTChangesContractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def result = karate.exec('python src/test/java/service/Regression/util/dbcompare.py ' + contractGUID_ProdCode + ' ' + contractGUID_CMTChanges)
    * print result
    * if (envCheck.ContractCMTWriteFlag == "BOTH") karate.call('classpath:service/CMTMigration/sample.feature@CassandraComparison')
#    * if (envCheck.ContractCMTWriteFlag == "BOTH") karate.call('classpath:service/CMTMigration/sample.feature@CassandraComparison' , {CMTChangesContractID: CMTChangesContractID, ProdCodeContractID: ProdCodeContractID })

  @ProdCodeCassandra
  Scenario: Retrieves the Contract Information from Cassandra DB - ProdCode
    * def contractGUID_ProdCode = ProdCodeContractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractInfo_ProdCode = javaDBMethods.readRowsCassandraWithRow("select * from cms.contract where contract_guid in(" + contractGUID_ProdCode + ");")
    * print 'Contract Information: ', contractInfo_ProdCode
    * match contractInfo_ProdCode !contains "Nil"
    * match contractInfo_ProdCode contains contractGUID
#    * match contractInfo_ProdCode contains "PRESENTED"
    * def assertContractStatus = global_extension.assertionStatus(contractInfo_ProdCode)
    * match assertContractStatus == true
    * match contractInfo_ProdCode contains TermID
    * match contractInfo_ProdCode contains termType

  @CMTCodeCassandra
  Scenario: Retrieves the Contract Information from Cassandra DB - CMTChangesCode
    * def contractGUID_CMTChanges = CMTChangesContractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractInfo_CMTChanges = javaDBMethods.readRowsCassandraWithRow("select * from cms.contract where contract_guid in(" + contractGUID_CMTChanges + ");")
    * print 'Contract Information: ', contractInfo_CMTChanges
    * match contractInfo_CMTChanges !contains "Nil"
    * match contractInfo_CMTChanges contains contractGUID
    * def assertContractStatus = global_extension.assertionStatus(contractInfo_CMTChanges)
    * match assertContractStatus == true
    * match contractInfo_CMTChanges contains TermID
    * match contractInfo_CMTChanges contains termType

  @CassandraComparison
  Scenario: Comparison between Cassandra - CMTChangesCode vs ProdCode
    * def contractInfo_CMTChanges_AfterReplace = javaDBMethods.ReplaceAllNeededValues(contractInfo_CMTChanges)
    * print 'CMTChanges_ContractInfo: ',contractInfo_CMTChanges_AfterReplace
    * def contractInfo_ProdCode_AfterReplace = javaDBMethods.ReplaceAllNeededValues(contractInfo_CMTChanges)
    * print 'ProdCode_ContractInfo: ',contractInfo_ProdCode_AfterReplace
    * match contractInfo_CMTChanges_AfterReplace contains contractInfo_ProdCode_AfterReplace
