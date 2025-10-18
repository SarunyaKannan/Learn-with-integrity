/*package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/SubmitPracticeQuizServlet")
public class SubmitPracticeQuizServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String level = req.getParameter("level");
        String courseId = req.getParameter("courseId");

        Map<String, String[]> params = req.getParameterMap();
        List<String> qids = new ArrayList<>();

        // Collect all question IDs
        for (String key : params.keySet()) {
            if (key.startsWith("q_")) {
                qids.add(key.substring(2)); // remove "q_" prefix
            }
        }

        int total = qids.size();
        int attempted = 0;
        int correct = 0;

        List<Map<String, String>> resultDetails = new ArrayList<>();

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "")) {
            for (String qid : qids) {
                String ans = req.getParameter("q_" + qid);

                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT question_text, option_a, option_b, option_c, option_d, correct_option, answer_text " +
                        "FROM question_bank WHERE id=?")) {
                    ps.setInt(1, Integer.parseInt(qid));
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String correctOpt = rs.getString("correct_option");
                        String questionText = rs.getString("question_text");

                        if (ans != null && !ans.isEmpty()) attempted++;
                        if (ans != null && correctOpt != null && ans.equalsIgnoreCase(correctOpt)) correct++;

                        Map<String, String> detail = new HashMap<>();
                        detail.put("question", questionText);
                        detail.put("optA", rs.getString("option_a"));
                        detail.put("optB", rs.getString("option_b"));
                        detail.put("optC", rs.getString("option_c"));
                        detail.put("optD", rs.getString("option_d"));
                        detail.put("correct", correctOpt);
                        detail.put("user", ans != null ? ans : "Not Answered");
                        detail.put("solution", rs.getString("answer_text"));
                        resultDetails.add(detail);
                    }
                    rs.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        int wrong = attempted - correct;

        // Calculate performance message
        String message;
        double percentage = total > 0 ? ((double) correct / total) * 100 : 0;
        if (percentage == 100) {
            message = "🌟 Excellent! Perfect score!";
        } else if (percentage >= 50) {
            message = "💪 Good work! Keep it up!";
        } else {
            message = "📘 Keep practicing — you'll get better!";
        }

        req.setAttribute("score", correct);
        req.setAttribute("total", total);
        req.setAttribute("attempted", attempted);
        req.setAttribute("correct", correct);
        req.setAttribute("wrong", wrong);
        req.setAttribute("message", message);
        req.setAttribute("resultDetails", resultDetails);
        
        
        
      //  req.setAttribute("score", score);
      //  req.setAttribute("total", total);
        
        req.setAttribute("quizType", "practice");
      //  request.setAttribute("resultDetails", resultDetailsList);
     //   RequestDispatcher rd = req.getRequestDispatcher("result.jsp");
      //  rd.forward(request, response);

        req.setAttribute("resultDetails", resultDetails);
        
        
        
        
     // Remove quiz session attributes to prevent back-button reload
      //  HttpSession session = req.getSession(false);
        
        
        req.setAttribute("total", total);
        req.setAttribute("attempted", attempted);
        req.setAttribute("correct", correct);
        req.setAttribute("wrong", wrong);
     //   req.setAttribute("notAttempted", notAttempted);

    //    if (session != null) {
      //      session.removeAttribute("questions");   // stored questions
       //     session.removeAttribute("startTime");   // quiz start time
         //   session.removeAttribute("quizStarted"); // flag that quiz started
        //}

     //   req.setAttribute("mode", "practice"); // 🔹 to tell JSP it's a practice quiz
     //   req.getRequestDispatcher("result.jsp").forward(req, resp);


        // Forward to result page
      //  req.getRequestDispatcher("result.jsp").forward(req, resp);
    }
}*/




package Module3;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import Module1.*;

@WebServlet("/SubmitPracticeQuizServlet")
public class SubmitPracticeQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        resp.setContentType("text/html;charset=UTF-8");
        HttpSession session = req.getSession();
        
        try {
            // Get quiz parameters
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            String level = req.getParameter("level");
            
            // Get questions from session
            List<Map<String, Object>> questions = 
                (List<Map<String, Object>>) session.getAttribute("questions");
            
            if (questions == null || questions.isEmpty()) {
                resp.sendRedirect("practice.jsp");
                return;
            }
            
            int totalQuestions = questions.size();
            int correctAnswers = 0;
            int wrongAnswers = 0;
            int attemptedQuestions = 0;
            int notAttemptedQuestions = 0;
            
            // List to store detailed results for each question
            List<Map<String, Object>> detailedResults = new ArrayList<>();
            
            // Process each question
            for (Map<String, Object> question : questions) {
                int questionId = (Integer) question.get("id");
                String correctOption = (String) question.get("correct_option");
                String userAnswer = req.getParameter("q_" + questionId);
                
                Map<String, Object> result = new HashMap<>();
                result.put("question_text", question.get("question_text"));
                result.put("option_a", question.get("option_a"));
                result.put("option_b", question.get("option_b"));
                result.put("option_c", question.get("option_c"));
                result.put("option_d", question.get("option_d"));
                result.put("correct_option", correctOption);
                result.put("user_answer", userAnswer);
                
                // Determine if answered
                if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                    attemptedQuestions++;
                    result.put("status", "attempted");
                    
                    // Check if correct
                    if (userAnswer.equalsIgnoreCase(correctOption)) {
                        correctAnswers++;
                        result.put("is_correct", true);
                    } else {
                        wrongAnswers++;
                        result.put("is_correct", false);
                    }
                } else {
                    notAttemptedQuestions++;
                    result.put("status", "not_attempted");
                    result.put("is_correct", false);
                }
                
                // Get answer explanation if available
                result.put("answer_text", question.get("answer_text"));
                
                detailedResults.add(result);
            }
            
            // Calculate percentage based on total questions (not attempted)
            double percentage = ((double) correctAnswers / totalQuestions) * 100;
            
            // Store results in session
            session.setAttribute("totalQuestions", totalQuestions);
            session.setAttribute("correctAnswers", correctAnswers);
            session.setAttribute("wrongAnswers", wrongAnswers);
            session.setAttribute("attemptedQuestions", attemptedQuestions);
            session.setAttribute("notAttemptedQuestions", notAttemptedQuestions);
            session.setAttribute("percentage", percentage);
            session.setAttribute("detailedResults", detailedResults);
            session.setAttribute("quizLevel", level);
            session.setAttribute("quizCourseId", courseId);
            
            // Clean up quiz session data
            session.removeAttribute("questions");
            session.removeAttribute("timeLimit");
            session.removeAttribute("startTime");
            session.removeAttribute("quizStarted");
            
            // Redirect to results page
            resp.sendRedirect("practice_result.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h2 style='color:red;'>Error: " + e.getMessage() + "</h2>");
        }
    }
}
