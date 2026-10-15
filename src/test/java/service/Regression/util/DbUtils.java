package service.Regression.util;

import com.datastax.driver.core.*;
import org.testng.log4testng.Logger;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DbUtils {
    private static Session session;

    public DbUtils(Map<String, Object> config) {
        String url = (String) config.get("url");
        String username = (String) config.get("username");
        String password = (String) config.get("password");
        Cluster cluster = Cluster.builder().withCredentials(username, password).addContactPoints(url).build();
        session = cluster.connect("crms");
        System.out.println("Cassandra Connected Successfully");

    }


    public String readRowsCassandra(String query) {
        String str = "select contract_guid from cms.contract where solr_query='{\"q\":\"party_reference_id:8919100012890084\", \"sort\":\"created_dt asc\", \"paging\":\"driver\"}';";
        System.out.println("Cassandra - Executing the query: " + query + "\n");
        ResultSet rs = session.execute(query);
        if (rs.all().size() == 1)
            return "[]";
        List<String> entries = new ArrayList<String>();
        int sizeOfList = rs.all().size();
        System.out.println("Size of List " + sizeOfList);
        int i = 0;
        while (i < sizeOfList) {
            entries.add(rs.one().getString(i));
            i++;
        }
        System.out.println("Contract Table Contents in ArrayList" + entries);
        return rs.one().getString(0);
    }

    public String readRowsCassandraContractGUID(String query) {
        System.out.println("Cassandra - Executing the query: \n" + query + "\n");
        ResultSet rs = session.execute(query);
        System.out.println("SOUT_1 :" + rs.all().toString());
//        System.out.println("SOUT_2 :" + rs.one().getString(0));
        System.out.println("SOUT_2 :" + rs.one().getUUID(0).toString());
//        System.out.println("SOUT_2 :" + rs.one().getObject(0));
        int sizeOfList = rs.all().size();
        System.out.println("Size of List \n" + sizeOfList);
        if (sizeOfList == 1)
            return "[]";
        List<String> entries = new ArrayList<String>();


        int i = 0;
        while (i < sizeOfList - 1) {
            System.out.println("Next step is to add --> " + rs.one().getUUID(i).toString() + " in the ArrayList of String");
            entries.add(rs.one().getUUID(i).toString());
            i++;
        }
        System.out.println("Contract Table Contents in ArrayList" + entries);
        return rs.one().getUUID(0).toString();
    }

    public String readRowsCassandraWithRow(String query) {
        System.out.println("Cassandra - Executing the query: " + query + "\n");
        ResultSet rs = session.execute(query);
        String Contract = rs.all().toString().replaceAll("Row", "").replaceAll("\\[", "").replaceAll("\\]", "");
        System.out.println("Contract after removing Row and Brackets: \n" + Contract);
        if (Contract.contains("-"))
            return Contract;
        else
            return "Nil";
    }

    public String deleteRowsCassandra(String query) {
        System.out.println("Cassandra - Executing the query: " + query + "\n");
        ResultSet rs = session.execute(query);
        System.out.println(query + " ---> Execution Successful. Data Deleted");
        return rs.all().toString();
    }

    public String readARecordCassandra(String query) {
        System.out.println("Cassandra - Executing the query: " + query + "\n");
        ResultSet rs = session.execute(query);
        return rs.all().toString();
    }

    public String ReplaceAllNeededValues(String value) {
        System.out.println("Before Replacing: \n");
        System.out.println(value);
        String AfterReplaceValue = value.replaceAll("\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12},", "IGNORE_COMPARE,").replaceAll("contract_attribute_guid:'\\w{32}'", "contract_attribute_guid:IGNORE_COMPARE").replaceAll("_ts:\\d{13}", "_ts:IGNORE_COMPARE");
        System.out.println(AfterReplaceValue);
        return AfterReplaceValue;

    }
}