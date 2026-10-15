Feature: xsp-esp-customer-config-server

  Background:
    * print config_password
    * def auth =
     """
       function(creds) {
       var temp = creds.username + ':' + creds.password;
       var Base64 = Java.type('java.util.Base64');
       var encoded = Base64.getEncoder().encodeToString(temp.getBytes());
       return 'Basic ' + encoded;
        }
     """

  @qa
  Scenario: Retrieving all the Password required for Contract Management Service
    Given url 'https://esp-customer-config-int-ghec.as-g8.cf.comcast.net/karate-service/contract-management-service-qa/develop'
    And header Authorization = call auth { username: 'EspTeamC', password: '#(config_password)' }
    When method get
    Then status 200
    * def client_id = response.propertySources[0].source.username_cms
    * def client_pass = response.propertySources[0].source.cms_secret
    * def db_username = response.propertySources[0].source.contract_cassandra_username_cms
    * def db_password = response.propertySources[0].source.contract_cassandra_cms_password

    Given url 'https://esp-customer-config-int-ghec.as-g8.cf.comcast.net/karate-service/contract-cmt-qa/develop'
    And header Authorization = call auth { username: 'EspTeamC', password: '#(config_password)' }
    When method get
    Then status 200
    * def cmt_client_id = response.propertySources[0].source.client_id
    * def cmt_client_pass = response.propertySources[0].source.client_pass
    * def cmt_db_username = response.propertySources[0].source.write_spring_datasource_username
    * def cmt_db_password = response.propertySources[0].source.write_spring_datasource_password

    Given url 'https://esp-customer-config-int-ghec.as-g8.cf.comcast.net/contract-recon-service/esp-qa/develop'
    And header Authorization = call auth { username: 'EspTeamC', password: '#(config_password)' }
    When method get
    Then status 200
    * def recon_client_pass = response.propertySources[3].source.cmsrecon_secret

  @prod
  Scenario: Retrieving all the Password required for Contract Management Service
    Given url 'https://esp-customer-config-int-ghec.as-g8.cf.comcast.net/karate-service/contract-management-service-prd/develop'
    And header Authorization = call auth { username: 'EspTeamC', password: '#(config_password)' }
    When method get
    Then status 200
    * def client_id = response.propertySources[0].source.client_id
    * def client_pass = response.propertySources[0].source.client_pass
    * def db_username = response.propertySources[0].source.contract_pdf_postgres_username
    * def db_password = response.propertySources[0].source.contract_pdf_postgres_password

    Given url 'https://esp-customer-config-int-ghec.as-g8.cf.comcast.net/karate-service/contract-cmt-prd/develop'
    And header Authorization = call auth { username: 'EspTeamC', password: '#(config_password)' }
    When method get
    Then status 200
    * def cmt_client_id = response.propertySources[1].source.client_id
    * def cmt_client_pass = response.propertySources[1].source.client_pass
    * def cmt_db_username = response.propertySources[1].source.write_spring_datasource_username
    * def cmt_db_password = response.propertySources[1].source.write_spring_datasource_password
