/*package Module3;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import Module1.*;
import jakarta.servlet.annotation.*;


@WebServlet("/StartPracticeQuizServlet")
public class StartPracticeQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        HttpSession session = req.getSession();

        
        
        System.out.println("Reached servelt");
        try {
            // Get selected values from form
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            String level = req.getParameter("level");
            int numQuestions = Integer.parseInt(req.getParameter("numQuestions"));
            int timeLimit = Integer.parseInt(req.getParameter("timeLimit"));

            // DB connection from your helper class
            Connection con = DbConnection.getConnection();

            String sql = "";
            PreparedStatement ps = null;

            // If dynamic → get random questions without difficulty filter
            if("DYNAMIC".equalsIgnoreCase(level)) {
                sql = "SELECT * FROM question_bank WHERE topic_id = ? ORDER BY RAND() LIMIT ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, courseId); // Assuming topic_id == course_id
                ps.setInt(2, numQuestions);
            } else {
                sql = "SELECT * FROM question_bank WHERE topic_id = ? AND difficulty = ? ORDER BY RAND() LIMIT ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, courseId); 
                ps.setString(2, level.toLowerCase()); // DB stores lowercase
                ps.setInt(3, numQuestions);
            }

            ResultSet rs = ps.executeQuery();

            // Store questions in a list
            List<Map<String, Object>> questions = new ArrayList<>();
            while(rs.next()) {
                Map<String, Object> q = new HashMap<>();
                q.put("id", rs.getInt("id"));
                q.put("question_text", rs.getString("question_text"));
                q.put("option_a", rs.getString("option_a"));
                q.put("option_b", rs.getString("option_b"));
                q.put("option_c", rs.getString("option_c"));
                q.put("option_d", rs.getString("option_d"));
                q.put("correct_option", rs.getString("correct_option"));
                questions.add(q);
            }

            rs.close();
            ps.close();
            con.close();

            // Put data into session
            session.setAttribute("questions", questions);
            session.setAttribute("timeLimit", timeLimit);
            session.setAttribute("courseId", courseId);
            session.setAttribute("level", level);
         // Remove quiz session attributes to prevent back-button reload
           // HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("questions");   // stored questions
                session.removeAttribute("startTime");   // quiz start time
                session.removeAttribute("quizStarted"); // flag that quiz started
            }

            // Forward to quiz page
            RequestDispatcher rd = req.getRequestDispatcher("practice_quiz.jsp");
            rd.forward(req, resp);

        } catch(Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}*/




package Module3;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import Module1.*;
import jakarta.servlet.annotation.*;

@WebServlet("/StartPracticeQuizServlet")
public class StartPracticeQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        resp.setContentType("text/html;charset=UTF-8");
        HttpSession session = req.getSession();

        //System.out.println("Reached servlet");
        
        try {
            // Get selected values from form
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            String level = req.getParameter("level");
            int numQuestions = Integer.parseInt(req.getParameter("numQuestions"));
            int timeLimit = Integer.parseInt(req.getParameter("timeLimit"));

            /*System.out.println("Parameters - courseId: " + courseId + 
                             ", level: " + level + 
                             ", numQuestions: " + numQuestions + 
                             ", timeLimit: " + timeLimit); */

            // DB connection
            Connection con = DbConnection.getConnection();

            String sql = "";
            PreparedStatement ps = null;

            // If dynamic → get random questions without difficulty filter
            if("DYNAMIC".equalsIgnoreCase(level)) {
                sql = "SELECT * FROM question_bank WHERE topic_id = ? ORDER BY RAND() LIMIT ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, courseId);
                ps.setInt(2, numQuestions);
            } else {
                sql = "SELECT * FROM question_bank WHERE topic_id = ? AND difficulty = ? ORDER BY RAND() LIMIT ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, courseId);
                ps.setString(2, level.toLowerCase());
                ps.setInt(3, numQuestions);
            }

          //  System.out.println("Executing SQL: " + sql);
            ResultSet rs = ps.executeQuery();

            // Store questions in a list
            List<Map<String, Object>> questions = new ArrayList<>();
            while(rs.next()) {
                Map<String, Object> q = new HashMap<>();
                q.put("id", rs.getInt("id"));
                q.put("question_text", rs.getString("question_text"));
                q.put("option_a", rs.getString("option_a"));
                q.put("option_b", rs.getString("option_b"));
                q.put("option_c", rs.getString("option_c"));
                q.put("option_d", rs.getString("option_d"));
                q.put("correct_option", rs.getString("correct_option"));
                q.put("answer_text", rs.getString("answer_text")); // Include answer explanation
                questions.add(q);
            }

       //     System.out.println("Questions fetched: " + questions.size());

            rs.close();
            ps.close();
            con.close();

            // Check if questions were found
            if(questions.isEmpty()) {
                resp.getWriter().println("<h2 style='color:red; text-align:center;'>" +
                    "No questions found for this course and level. " +
                    "Please check your question bank.</h2>");
                resp.getWriter().println("<p style='text-align:center;'>" +
                    "<a href='practice.jsp'>Go Back</a></p>");
                return;
            }

            // ✅ FIXED: Put data into session (and DON'T remove them!)
            session.setAttribute("questions", questions);
            session.setAttribute("timeLimit", timeLimit);
            session.setAttribute("courseId", courseId);
            session.setAttribute("level", level);

            System.out.println("Session attributes set. Forwarding to practice_quiz.jsp");

            // Forward to quiz page
            RequestDispatcher rd = req.getRequestDispatcher("practice_quiz.jsp");
            rd.forward(req, resp);

        } catch(NumberFormatException e) {
            e.printStackTrace();
            resp.getWriter().println("<h2 style='color:red;'>Error: Invalid input parameters</h2>");
            resp.getWriter().println("<p>Details: " + e.getMessage() + "</p>");
            resp.getWriter().println("<p><a href='practice.jsp'>Go Back</a></p>");
        } catch(SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<h2 style='color:red;'>Database Error: " + e.getMessage() + "</h2>");
            resp.getWriter().println("<p><a href='practice.jsp'>Go Back</a></p>");
        } catch(Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h2 style='color:red;'>Error: " + e.getMessage() + "</h2>");
            resp.getWriter().println("<p><a href='practice.jsp'>Go Back</a></p>");
        }
    }
}
