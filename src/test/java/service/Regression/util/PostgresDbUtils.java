package service.Regression.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import java.util.List;
import java.util.Map;

public class PostgresDbUtils {
    private static final Logger logger = LoggerFactory.getLogger(PostgresDbUtils.class);
    private final JdbcTemplate jdbc;

    public PostgresDbUtils(Map<String, Object> config) {
        String url = (String) config.get("url");
        String username = (String) config.get("username");
        String password = (String) config.get("password");
        String driver = (String) config.get("driverClassName");
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(driver);
        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        jdbc = new JdbcTemplate(dataSource);
        logger.info("init jdbc template: {}", url);
        System.out.println("Postgres - CMT Connected Successfully");
    }

    public List<Map<String, Object>> readRowsPostgres(String query) {
        System.out.println("\n You are in readRows Method - Postgres");
        System.out.println("Query: " + query + "\n");
        System.out.println(jdbc.queryForList(query));
        return jdbc.queryForList(query);
    }

    public void deleteRowsPostgres(String query) {
        System.out.println("\n You are in deleteRows Method - Postgres");
        System.out.println("Query: " + query + "\n");
        jdbc.execute(query);
    }

    public void updateRowsPostgres(String query) {
        System.out.println("\n You are in updateRows Method - Postgres");
        System.out.println("Query: " + query + "\n");
        jdbc.update(query);
    }

}
