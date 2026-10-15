package service;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.BeforeClass;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.*;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import static org.junit.Assert.*;

//set JAVA_HOME=C:\Program Files\Java\jdk-17.0.5\
//PowerShell syntax: .\gradlew.bat test --% -Dkarate.coreTablesLocal=Y -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @COMMIT_VA"
//gradlew test -Dkarate.configpassword= -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @SubmitContract"
//gradlew test -Dkarate.configpassword= -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @REST"
//gradlew test -Dkarate.configpassword= -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @SMS_Marketing"
//gradlew test -Dkarate.configpassword= -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @CANCELLED"
//gradlew test -Dkarate.configpassword= -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @P2K"
//gradlew test -Dkarate.configpassword= -Dkarate.coreTablesLocal=Y -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @COMMIT_VA"
//gradlew test -Dkarate.configpassword= -Dkarate.coreTablesLocal=Y -Dkarate.servicename=cms -Dkarate.env=qa -Dkarate.options="--tags @CompleteDocusignContract"
//gradlew test -Dkarate.configpassword= -Dkarate.servicename=cms -Dkarate.env=wc-g2 -Dkarate.options="--tags @HITScripts"
//gradlew test -Dkarate.configpassword= -Dkarate.servicename=cms -Dkarate.env=wcg2 -Dkarate.options="--tags @HITScripts"
public class testRunner {
    static List<String> filesListInDir = new ArrayList<String>();

    @BeforeAll
    public static void cleanup() throws IOException {
        File file = new File(System.getProperty("user.dir") + "//generated");
        System.out.println("INSIDE Delete Folder Method");
        System.out.println(file.getAbsolutePath());
        if (file.exists()) {
            com.intuit.karate.FileUtils.deleteDirectory(file);
            file.delete();
            System.out.println("File Exists and Deleted");
        }
    }

    @BeforeClass
    public static void beforeClass() throws Exception {
        // System.setProperty("karate.env", "int");
        String env = System.getProperty("karate.env");
        System.out.println("environment is:" + env);
    }

    @Test
    public void testRunner() {
        Results results = Runner.path("classpath:").tags("")
                .outputCucumberJson(true).parallel(1);
        generateReport(results.getReportDir());
        assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] { "json" }, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "smoketests");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

    @AfterAll
    public static void reportScreenshot() throws Exception {
        zipReports();
    }

    private static void zipReports() {
        new File("./generated").mkdir();
        File dir = new File("./target");
        String zipDirName = "./generated/" + System.getProperty("karate.env") + "_cms_reports.zip";
        try {
            populateFilesList(dir);
            FileOutputStream fos = new FileOutputStream(zipDirName);
            ZipOutputStream zos = new ZipOutputStream(fos);
            for (String filePath : filesListInDir) {
                ZipEntry ze = new ZipEntry(filePath.substring(dir.getAbsolutePath().length() + 1, filePath.length()));
                zos.putNextEntry(ze);
                FileInputStream fis = new FileInputStream(filePath);
                byte[] buffer = new byte[1024];
                int len;
                while ((len = fis.read(buffer)) > 0) {
                    zos.write(buffer, 0, len);
                }
                zos.closeEntry();
                fis.close();
            }
            zos.close();
            fos.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void populateFilesList(File dir) throws IOException {
        File[] files = dir.listFiles();
        for (File file : files) {
            if (file.isFile())
                filesListInDir.add(file.getAbsolutePath());
            else
                populateFilesList(file);
        }
    }

}
