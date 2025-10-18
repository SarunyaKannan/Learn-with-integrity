package Module3;
//CSVImporter.java
import java.sql.*;
import java.io.*;
import com.opencsv.*;

public class CSVImporter {
 public static void main(String[] args) {
     String jdbcURL = "jdbc:mysql://localhost:3306/lms";
     String username = "root";
     String password = "";
     String csvFilePath = "lcm_questions.csv";

     try (Connection conn = DriverManager.getConnection(jdbcURL, username, password);
          CSVReader reader = new CSVReader(new FileReader("D:\\lms docx\\lcm_questions.csv"))) {

         String insertSQL = "INSERT INTO questions (topic_id, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty) VALUES (1, ?, ?, ?, ?, ?, ?, ?)";
         PreparedStatement stmt = conn.prepareStatement(insertSQL);

         String[] nextLine;
         reader.readNext(); // skip header

         while ((nextLine = reader.readNext()) != null) {
             stmt.setString(1, nextLine[0]); // question_text
             stmt.setString(2, nextLine[1]); // option_a
             stmt.setString(3, nextLine[2]); // option_b
             stmt.setString(4, nextLine[3]); // option_c
             stmt.setString(5, nextLine[4]); // option_d
             stmt.setString(6, nextLine[5]); // correct_option
             stmt.setString(7, nextLine[6]); // difficulty
             stmt.executeUpdate();
         }

         System.out.println("CSV data inserted successfully!");

     } catch (Exception e) {
         e.printStackTrace();
     }
 }
}
