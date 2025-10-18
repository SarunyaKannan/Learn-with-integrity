/*package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import Module1.User;

@WebServlet("/QuizAttemptServlet")
public class QuizAttemptServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

       

     // inside doGet
     User user = (User) request.getSession().getAttribute("user");
     if (user == null) {
         response.getWriter().write("{\"attempts\":0,\"questions\":[]}");
         return;
     }
     String username = user.getUsername();
     System.out.println("Username: " + username);
// session username
        String courseId = request.getParameter("courseId");
        String level = request.getParameter("level");
        
        
        
        int totalQuestions = 0;
        double perQuestionMark = 0;
        int freeAttempts = 0;

        switch(level.toUpperCase()) {
            case "EASY": totalQuestions=5; perQuestionMark=20; freeAttempts=2; break;
            case "INTERMEDIATE": totalQuestions=10; perQuestionMark=10; freeAttempts=3; break;
            case "HARD": totalQuestions=15; perQuestionMark=6.67; freeAttempts=4; break;
        }
        int attemptNumber = 1; // default 1 if no previous attempts
        try (PreparedStatement ps = con.prepareStatement(
            "SELECT COUNT(*) AS cnt FROM quiz_attempts WHERE username=? AND course_id=? AND level=?")) {
            ps.setString(1, username);
            ps.setString(2, courseId);
            ps.setString(3, level);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) attemptNumber = rs.getInt("cnt") + 1; // next attempt number
        }


        int attemptsMade = 0;
        List<Map<String, Object>> questionsInfo = new ArrayList<>();

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lms", "root", "");
             PreparedStatement ps = con.prepareStatement(
                     "SELECT COUNT(*) AS cnt FROM quiz_attempts WHERE username=? AND course_id=? AND level=?")) {

            ps.setString(1, username);
            ps.setString(2, courseId);
            ps.setString(3, level);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) attemptsMade = rs.getInt("cnt");

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch latest attempt to show marks per question
        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lms", "root", "");
             PreparedStatement ps = con.prepareStatement(
                     "SELECT id, total_questions, score FROM quiz_attempts WHERE username=? AND course_id=? AND level=? ORDER BY attempted_at DESC LIMIT 1")) {

            ps.setString(1, username);
            ps.setString(2, courseId);
            ps.setString(3, level);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int totalQuestions = rs.getInt("total_questions");
                int score = rs.getInt("score");
                for (int i = 1; i <= totalQuestions; i++) {
                    Map<String, Object> q = new HashMap<>();
                    q.put("questionNo", i);
                    // Simple average per question (score / total_questions)
                    q.put("marks", Math.round((score * 100.0 / totalQuestions) / 100.0));
                    questionsInfo.add(q);
                }
            }
            System.out.println("Username: " + username);
            System.out.println("CourseId: " + courseId);
            System.out.println("Level: " + level);
            System.out.println("Attempts Made: " + attemptsMade);
            System.out.println("Questions Info: " + questionsInfo);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Build JSON response
        StringBuilder json = new StringBuilder();
        json.append("{\"attempts\":").append(attemptsMade).append(",\"questions\":[");

        for (int i = 0; i < questionsInfo.size(); i++) {
            Map<String, Object> q = questionsInfo.get(i);
            json.append("{\"questionNo\":").append(q.get("questionNo"))
                .append(",\"marks\":").append(q.get("marks")).append("}");
            if (i != questionsInfo.size() - 1) json.append(",");
        }
        json.append("]}");

        response.getWriter().write(json.toString());
    }
}*
package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import Module1.User;

@WebServlet("/QuizAttemptServlet")
public class QuizAttemptServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        // 1️⃣ Get session user
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("{\"attempts\":0,\"questions\":[]}");
            return;
        }
        String username = user.getUsername();

        // 2️⃣ Get parameters
        String courseId = request.getParameter("courseId");
        String level = request.getParameter("level");

        // 3️⃣ Map level to total questions, per-question mark, free attempts
        int totalQuestions = 0;
        double perQuestionMark = 0;
        int freeAttempts = 0;

        switch(level.toUpperCase()) {
            case "EASY": totalQuestions=5; perQuestionMark=20; freeAttempts=2; break;
            case "INTERMEDIATE": totalQuestions=10; perQuestionMark=10; freeAttempts=3; break;
            case "HARD": totalQuestions=15; perQuestionMark=6.67; freeAttempts=4; break;
        }

        int attemptsMade = 0;

        // 4️⃣ Count attempts made
        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lms", "root", "");
             PreparedStatement ps = con.prepareStatement(
                     "SELECT COUNT(*) AS cnt FROM quiz_attempts WHERE username=? AND course_id=? AND level=?")) {

            ps.setString(1, username);
            ps.setString(2, courseId);
            ps.setString(3, level);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                attemptsMade = rs.getInt("cnt");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 5️⃣ Calculate current attempt number
        int currentAttemptNumber = attemptsMade + 1;

        // 6️⃣ Calculate per-question marks with attempt deduction
        double deductionPercent = 0.10; // 10% per extra attempt beyond freeAttempts
        double actualMarks = perQuestionMark;

        if (currentAttemptNumber > freeAttempts) {
            int extraAttempts = currentAttemptNumber - freeAttempts;
            actualMarks = perQuestionMark * Math.pow(1 - deductionPercent, extraAttempts);
        }
        // Round to 2 decimals
        actualMarks = Math.round(actualMarks * 100.0) / 100.0;

        // 7️⃣ Build questions info list
        List<Map<String, Object>> questionsInfo = new ArrayList<>();
        for (int i = 1; i <= totalQuestions; i++) {
            Map<String, Object> q = new HashMap<>();
            q.put("questionNo", i);
            q.put("marks", actualMarks);
            questionsInfo.add(q);
        }

        // 8️⃣ Build JSON response
        StringBuilder json = new StringBuilder();
        json.append("{\"attempts\":").append(attemptsMade)
            .append(",\"questions\":[");

        for (int i = 0; i < questionsInfo.size(); i++) {
            Map<String, Object> q = questionsInfo.get(i);
            json.append("{\"questionNo\":").append(q.get("questionNo"))
                .append(",\"marks\":").append(q.get("marks")).append("}");
            if (i != questionsInfo.size() - 1) json.append(",");
        }
        json.append("]}");

        // 9️⃣ Debug console
   //     System.out.println("Username: " + username);
     //   System.out.println("CourseId: " + courseId);
       // System.out.println("Level: " + level);
        //System.out.println("Attempts Made: " + attemptsMade);
        //System.out.println("Current Attempt Number: " + currentAttemptNumber);
    //    System.out.println("Marks per question: " + actualMarks);
    //    System.out.println("JSON response: " + json.toString());


        // 10️⃣ Return JSON
        response.getWriter().write(json.toString());
    }
}
*/






package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import Module1.User;
/*
@WebServlet("/QuizAttemptServlet")
public class QuizAttemptServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("<tr><td colspan='2'>Not logged in</td></tr>");
            return;
        }
        String username = user.getUsername();
        String courseId = request.getParameter("courseId");
        String level = request.getParameter("level");

        int totalQuestions = 0;
        double perQuestionMark = 0;
        int freeAttempts = 0;

        switch(level.toUpperCase()) {
            case "EASY": totalQuestions=5; perQuestionMark=20; freeAttempts=2; break;
            case "INTERMEDIATE": totalQuestions=10; perQuestionMark=10; freeAttempts=3; break;
            case "HARD": totalQuestions=15; perQuestionMark=6.67; freeAttempts=4; break;
        }

        int attemptsMade = 0;
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
             PreparedStatement ps = con.prepareStatement(
                     "SELECT COUNT(*) AS cnt FROM quiz_attempts WHERE username=? AND course_id=? AND level=?")) {
            ps.setString(1, username);
            ps.setString(2, courseId);
            ps.setString(3, level);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) attemptsMade = rs.getInt("cnt");
        } catch (Exception e) { e.printStackTrace(); }

        int currentAttemptNumber = attemptsMade + 1;

        double deductionPercent = 0.10;
        double actualMarks = perQuestionMark;
        if (currentAttemptNumber > freeAttempts) {
            int extraAttempts = currentAttemptNumber - freeAttempts;
            actualMarks = perQuestionMark * Math.pow(1 - deductionPercent, extraAttempts);
        }
        actualMarks = Math.round(actualMarks * 100.0) / 100.0;

        // Build HTML table rows
        StringBuilder htmlRows = new StringBuilder();
        for (int i = 1; i <= totalQuestions; i++) {
            htmlRows.append("<tr>")
                    .append("<td>").append(i).append("</td>")
                    .append("<td>").append(actualMarks).append("</td>")
                    .append("</tr>");
        }

        response.getWriter().write(htmlRows.toString());
    }
}*/
/*
package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import Module1.User;

@WebServlet("/QuizAttemptServlet")
public class QuizAttemptServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("<tr><td colspan='2'>Not logged in</td></tr>");
            return;
        }
        String username = user.getUsername();
        String courseId = request.getParameter("courseId");
        String level = request.getParameter("level");

        int totalQuestions = 0;
        double perQuestionMark = 0;
        int freeAttempts = 0;

        switch(level.toUpperCase()) {
            case "EASY": totalQuestions=5; perQuestionMark=20; freeAttempts=2; break;
            case "INTERMEDIATE": totalQuestions=10; perQuestionMark=10; freeAttempts=3; break;
            case "HARD": totalQuestions=15; perQuestionMark=6.67; freeAttempts=4; break;
        }

        int attemptsMade = 0;
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
             PreparedStatement ps = con.prepareStatement(
                     "SELECT COUNT(*) AS cnt FROM quiz_attempts WHERE username=? AND course_id=? AND level=?")) {
            ps.setString(1, username);
            ps.setString(2, courseId);
            ps.setString(3, level);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) attemptsMade = rs.getInt("cnt");
        } catch (Exception e) { e.printStackTrace(); }

        int currentAttemptNumber = attemptsMade + 1;

        double deductionPercent = 0.10;
        double actualMarks = perQuestionMark;
        if (currentAttemptNumber > freeAttempts) {
            int extraAttempts = currentAttemptNumber - freeAttempts;
            actualMarks = perQuestionMark * Math.pow(1 - deductionPercent, extraAttempts);
        }
        actualMarks = Math.round(actualMarks * 100.0) / 100.0;

        // Build HTML for attempts count
        String attemptHtml = "<script>document.getElementById('attemptCount').innerText='" + attemptsMade + "';</script>";

        // Build HTML table rows for marks
        StringBuilder marksHtml = new StringBuilder();
        for (int i = 1; i <= totalQuestions; i++) {
            marksHtml.append("<tr>")
                    .append("<td>").append(i).append("</td>")
                    .append("<td>").append(actualMarks).append("</td>")
                    .append("</tr>");
        }

        // Combine both
        response.getWriter().write(attemptHtml + marksHtml.toString());
    }
}*/





/* evening correction  *
@WebServlet("/QuizAttemptServlet")
public class QuizAttemptServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("{\"error\":\"Not logged in\"}");
            return;
        }
        String username = user.getUsername();
        String courseId = request.getParameter("courseId");
        String level = request.getParameter("level");

        int totalQuestions = 0;
        double perQuestionMark = 0;
        int freeAttempts = 0;

        switch(level.toUpperCase()) {
            case "EASY": totalQuestions=5; perQuestionMark=20; freeAttempts=2; break;
            case "INTERMEDIATE": totalQuestions=10; perQuestionMark=10; freeAttempts=3; break;
            case "HARD": totalQuestions=15; perQuestionMark=6.67; freeAttempts=4; break;
        }

        int attemptsMade = 0;
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
             PreparedStatement ps = con.prepareStatement(
                     "SELECT COUNT(*) AS cnt FROM quiz_attempts WHERE username=? AND course_id=? AND level=?")) {
            ps.setString(1, username);
            ps.setString(2, courseId);
            ps.setString(3, level);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) attemptsMade = rs.getInt("cnt");
        } catch (Exception e) { e.printStackTrace(); }

        int currentAttemptNumber = attemptsMade + 1;

        double deductionPercent = 0.10;
        double actualMarks = perQuestionMark;
        if (currentAttemptNumber > freeAttempts) {
            int extraAttempts = currentAttemptNumber - freeAttempts;
            actualMarks = perQuestionMark - (perQuestionMark * deductionPercent * extraAttempts);
            if (actualMarks < 0) actualMarks = 0;
        }
        actualMarks = Math.round(actualMarks * 100.0) / 100.0;

        
        
     // Build JSON
     // Build JSON properly
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"attemptCount\":").append(attemptsMade).append(",");
        json.append("\"freeAttempts\":").append(freeAttempts).append(",");
        json.append("\"currentAttempt\":").append(currentAttemptNumber).append(",");
        json.append("\"marks\":[");
        for (int i = 1; i <= totalQuestions; i++) {
            json.append("{\"q\":").append(i)
                .append(",\"mark\":").append(actualMarks).append("}");
            if (i < totalQuestions) json.append(","); // ✅ avoids trailing comma
        }
        json.append("]}");

        response.getWriter().write(json.toString());

    /*    // Build JSON
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"attemptCount\":").append(attemptsMade).append(",");
        json.append("\"freeAttempts\":").append(freeAttempts).append(",");
        json.append("\"currentAttempt\":").append(currentAttemptNumber).append(",");
        json.append("\"marks\":[");
        for (int i = 1; i <= totalQuestions; i++) {
            json.append("{\"q\":").append(i).append(",\"mark\":").append(actualMarks).append("}");
            if (i < totalQuestions) json.append(",");
        }
        json.append("]}"); *

        response.getWriter().write(json.toString());
        
        
        
        
        
        
        
        
        
        
        *
    }
}
*/



@WebServlet("/QuizAttemptServlet")
public class QuizAttemptServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String username = user.getUsername();
        String courseId = request.getParameter("courseId");
        String level = request.getParameter("level");

        int totalQuestions = 0;
        double perQuestionMark = 0;
        int freeAttempts = 0;

        switch(level.toUpperCase()) {
            case "EASY": totalQuestions=5; perQuestionMark=20; freeAttempts=2; break;
            case "INTERMEDIATE": totalQuestions=10; perQuestionMark=10; freeAttempts=3; break;
            case "HARD": totalQuestions=15; perQuestionMark=6.67; freeAttempts=4; break;
        }

        int attemptsMade = 0;
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
             PreparedStatement ps = con.prepareStatement(
                     "SELECT COUNT(*) AS cnt FROM quiz_attempts WHERE username=? AND course_id=? AND level=?")) {
            ps.setString(1, username);
            ps.setString(2, courseId);
            ps.setString(3, level);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) attemptsMade = rs.getInt("cnt");
        } catch (Exception e) { e.printStackTrace(); }

        int currentAttemptNumber = attemptsMade + 1;

        double deductionPercent = 0.10;
        double actualMarks = perQuestionMark;
        if (currentAttemptNumber > freeAttempts) {
            int extraAttempts = currentAttemptNumber - freeAttempts;
            actualMarks = perQuestionMark - (perQuestionMark * deductionPercent * extraAttempts);
            if (actualMarks < 0) actualMarks = 0;
        }
        actualMarks = Math.round(actualMarks * 100.0) / 100.0;

        // ✅ Set attributes so JSP can read them
        request.setAttribute("attemptCount", attemptsMade);
        request.setAttribute("freeAttempts", freeAttempts);
        request.setAttribute("currentAttempt", currentAttemptNumber);
        request.setAttribute("actualMarks", actualMarks);
        request.setAttribute("totalQuestions", totalQuestions);
        request.setAttribute("level", level);

        // ✅ Forward to quiz.jsp
        
    //    System.out.print(attemptsMade);
     // Clear completion flag when starting new attempt
        HttpSession sess = request.getSession();
        sess.removeAttribute("quiz_completed_" + courseId + "_" + level);

        request.getRequestDispatcher("quiz.jsp").forward(request, response);
    }
}

