import psycopg2
import sys
from cassandra.auth import PlainTextAuthProvider
from cassandra.cluster import Cluster
from cassandra.query import tuple_factory
from cassandra.query import dict_factory
from jproperties import Properties

count = 0
tcount = 0
mylist = ["customer_relationship_id", "partner", "contract_templates", "acceptance_cd", "created_dt", "updated_dt",
          "tracking_cd","created_ts","updated_ts"]
print("Ignored Fields to Compare: ", mylist)


def compareCommonResult(casres, pgres):
    commonres = ['acceptance_channel', 'created_dt', 'cancel_period', 'created_by', 'customer_id',
                 'electronic_template_id', 'language_ind', 'legal_name', 'market_id', 'updated_by', 'updated_dt',
                 'sales_channel', 'state_cd', 'term_id', 'term_length', 'term_type_cd', 'version',
                 'contract_recorded_ts', 'contract_scheduled_dt', 'contract_start_dt', 'contract_termination_dt',
                 'party_reference_id', 'term_description', 'customer_relationship_id',
                 'partner', 'contract_templates']
    global count, tcount
    tcount = tcount + len(casres)
    print(casres, pgres, sep='\n')
    for i in range(len(casres)):
        if (commonres[i] in mylist):
            continue
        if isinstance(casres[i], str) and isinstance(pgres[i], str):
            if casres[i].casefold() != pgres[i].casefold():
                print("\nCA *VS* PG: Field difference ", commonres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
        elif (isinstance(casres[i], str) and isinstance(pgres[i], int)) or (
                isinstance(casres[i], int) and isinstance(pgres[i], str)):
            if int(casres[i]) != int(pgres[i]):
                print("\nCA *VS* PG: Field difference ", commonres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
        elif casres[i] != pgres[i]:
            print("\nCA *VS* PG: Field difference ", commonres[i], "->", casres[i], "*VS*", pgres[i])
            count += 1


def compareJsonQueryResult(casres, pgres):
    ccres = ['legacy_contract_id', 'legacy_outlet', 'legacy_reference_num', 'legacy_reference_type',
             'legacy_service_ind', 'contract_incentive_details->product_id',
             'contract_incentive_details->product_desc', 'contract_incentive_details->required_services_period',
             'contract_incentive_details->fulfillment_address_type']
    print(casres, pgres, sep='\n')
    global count, tcount
    tcount = tcount + len(casres)
    for i in range(len(casres)):
        if (ccres[i] in mylist):
            continue
        if isinstance(casres[i], str) and isinstance(pgres[i], str):
            if casres[i].casefold() != pgres[i].casefold():
                print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
        elif (isinstance(casres[i], bool) and isinstance(pgres[i], bool)):
            if bool(casres[i]) != bool(pgres[i]):
                print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
        elif (isinstance(casres[i], str) and isinstance(pgres[i], int)) or (
                isinstance(casres[i], int) and isinstance(pgres[i], str)):
            if str(casres[i]) != str(pgres[i]):
                print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
            elif int(casres[i]) != int(pgres[i]):
                print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
        elif casres[i] != pgres[i]:
            print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
            count += 1


def compare_contractAttributes_Result(casres, pgres):
    ccres = ['name', 'label', 'value', 'created_by',
             'updated_by', 'contract_attribute_guid']
    print(casres, sep='\n')
    print(pgres, sep='\n')
    global count, tcount
    tcount = tcount + len(casres)
    for i in range(len(casres)):
        if (ccres[i] in mylist):
            continue
        if isinstance(casres[i], str) and isinstance(pgres[i], str):
            if casres[i].casefold() != pgres[i].casefold():
                print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
        elif (isinstance(casres[i], bool) and isinstance(pgres[i], bool)):
            if bool(casres[i]) != bool(pgres[i]):
                print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
        elif (isinstance(casres[i], str) and isinstance(pgres[i], int)) or (
                isinstance(casres[i], int) and isinstance(pgres[i], str)):
            if str(casres[i]) != str(pgres[i]):
                print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
            elif int(casres[i]) != int(pgres[i]):
                print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
                count += 1
        elif casres[i] != pgres[i]:
            print("\nCA *VS* PG: Field difference ", ccres[i], "->", casres[i], "*VS*", pgres[i])
            count += 1

def getDataFromCassandraDB():
    prop = Properties()
    global cassResult, cassCommonResult, cascontract_attributesResult
    with open(
            r'C:\Users\gsubra871\Documents\Repo\karate-contract-management-service\contractmanagementservice\src\test\java\service\Regression\util\dbcompare.properties',
            'rb') as read_prop:
        prop.load(read_prop)
    casDbHost = prop.get("cassandra_db_host").data.split(',')
    # print(casDbHost)
    casDbPort = prop.get("cassandra_db_port").data
    casDbKeyspace = prop.get("cassandra_db_keyspace").data
    casDbUsername = prop.get("cassandra_db_username").data
    casDbPassword = prop.get("cassandra_db_password").data
    cluster = Cluster(casDbHost, port=int(casDbPort),
                      auth_provider=PlainTextAuthProvider(username=casDbUsername, password=casDbPassword),
                      protocol_version=3, connect_timeout=30, control_connection_timeout=10.0)
    session = cluster.connect(casDbKeyspace)
    session.row_factory = tuple_factory

    # for querying common fields
    casCommonQuery = prop.get("cassandra_common_query").data
    commonQuery = casCommonQuery.format(cassandraId)
    rows = session.execute(commonQuery)
    cassCommonResult = rows.one()

    # for querying based on json fields
    casQuery = ''
    casQuery = prop.get("cassandra_json_query").data
    query = casQuery.format(cassandraId)
    rows = session.execute(query)
    cassResult = rows.one()

    # for querying cassandra_contractAttributes_query
    cascontract_attributes = ''
    cascontract_attributes = prop.get("cassandra_contractAttributes_query").data
    query = cascontract_attributes.format(cassandraId)
    rows = session.execute(query)
    cascontract_attributesResult = rows.one()
    session.shutdown()
    cluster.shutdown()


def getDataFromPostgresDB():
    prop = Properties()
    global transactionType, pgResult, pgCommonResult, pgcontractAttributes_result
    with open(
            r'C:\Users\gsubra871\Documents\Repo\karate-contract-management-service\contractmanagementservice\src\test\java\service\Regression\util\dbcompare.properties',
            'rb') as read_prop:
        prop.load(read_prop)
    pgDbHost = prop.get("postgres_db_host").data
    pgDbPort = prop.get("postgres_db_port").data
    pgDbName = prop.get("postgres_db_name").data
    pgDbUsername = prop.get("postgres_db_username").data
    pgDbPassword = prop.get("postgres_db_password").data
    con = psycopg2.connect(database=pgDbName, user=pgDbUsername, password=pgDbPassword, host=pgDbHost, port=pgDbPort)
    cursor = con.cursor()
    # for querying common fields
    pgCommonQuery = prop.get("postgres_common_query").data
    commonQuery = pgCommonQuery.format(postgresId)
    cursor.execute(commonQuery)
    pgCommonResult = cursor.fetchone()

    # for querying based on json fields
    pgQuery = ''
    pgQuery = prop.get("postgres_json_query").data
    query = pgQuery.format(postgresId)
    cursor.execute(query)
    pgResult = cursor.fetchone()

    # for querying postgres_contractAttributes_query
    postgres_contractAttributes_query = ''
    postgres_contractAttributes_query = prop.get("postgres_contractAttributes_query").data
    query = postgres_contractAttributes_query.format(postgresId)
    cursor.execute(query)
    pgcontractAttributes_result = cursor.fetchone()
    con.close()


def callFromKarate(cassId, posId):
    global cassandraId, postgresId
    cassandraId = cassId
#     if posId.endswith("023"):
#         postgresId = posId
#         print("\n QA ID --> ", postgresId)
#     else:
#         postgresId = posId + "023"
#         print("\n POSTGRES ID After Adding 023 --> ", postgresId)
    postgresId = posId
    print("\n CMT Postgres ID --> ", postgresId)
    print("\n CMT POSTGRES CONTRACT INFO")
    getDataFromPostgresDB()
    print("\n CASSANDRA CONTRACT INFO")
    getDataFromCassandraDB()
    compareCommonResult(cassCommonResult, pgCommonResult)
    compareJsonQueryResult(cassResult, pgResult)
    compare_contractAttributes_Result(cascontract_attributesResult, pgcontractAttributes_result)
    if count == 0:
        print("Both the DBs are having same values for the Record")
    print("\n\nTotal Numbers of Fields having Mismatch == ", count, " out of ", tcount, " Fields")


print("\n Cassandra ID - ", sys.argv[1])
print("\n Postgres ID - ", sys.argv[2])
callFromKarate(sys.argv[1], sys.argv[2])

