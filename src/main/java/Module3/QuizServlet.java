package Module3;


import java.sql.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.util.*;
import java.io.*;
import jakarta.servlet.*;
import Module1.DbConnection;
//QuizServlet.java
@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {
 protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {

     String level = request.getParameter("level"); // easy/intermediate/hard
     int limit = level.equals("easy") ? 5 : level.equals("intermediate") ? 10 : 15;

     List<Question> questions = new ArrayList<>();
     try (Connection conn = DbConnection.getConnection()) {
         String sql = "SELECT * FROM questions WHERE topic_id = 1 AND difficulty = ? ORDER BY RAND() LIMIT ?";
         PreparedStatement stmt = conn.prepareStatement(sql);
         stmt.setString(1, level);
         stmt.setInt(2, limit);
         ResultSet rs = stmt.executeQuery();

         while (rs.next()) {
             Question q = new Question(
                 rs.getInt("id"), rs.getString("question_text"),
                 rs.getString("option_a"), rs.getString("option_b"),
                 rs.getString("option_c"), rs.getString("option_d"),
                 rs.getString("correct_option").charAt(0)
             );
             questions.add(q);
         }
     } catch (Exception e) {
         e.printStackTrace();
     }

     request.setAttribute("questions", questions);
     RequestDispatcher rd = request.getRequestDispatcher("quiz_page.jsp");
     rd.forward(request, response);
 }
}
