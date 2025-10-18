/*package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import Module1.*;

@WebServlet("/QuizUnlockServlet")
public class QuizUnlockServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null) {
            out.print("Please login first");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.print("Please login first");
            return;
        }

        String username = user.getUsername();
        String courseId = req.getParameter("courseId");
        String level = req.getParameter("level");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
             PreparedStatement ps = null) {

            if ("EASY".equalsIgnoreCase(level)) {
                out.print("ALLOWED");
                return;
            } else if ("INTERMEDIATE".equalsIgnoreCase(level)) {
                // check last EASY attempt
                PreparedStatement p = con.prepareStatement(
                    "SELECT score, tab_switches FROM quiz_attempts WHERE username=? AND course_id=? AND level='EASY' ORDER BY attempted_at DESC LIMIT 1");
                p.setString(1, username);
                p.setString(2, courseId);
                ResultSet rs = p.executeQuery();
                if (rs.next() && rs.getInt("score") >= 4 && rs.getInt("tab_switches") <= 3) {
                    out.print("ALLOWED");
                } else {
                    out.print("❌ Unlock Intermediate only after passing Easy with ≥4/5 and ≤3 tab switches.");
                }
                rs.close();
                p.close();
                return;
            } else if ("HARD".equalsIgnoreCase(level)) {
                // check last INTERMEDIATE attempt
                PreparedStatement p = con.prepareStatement(
                    "SELECT score, tab_switches FROM quiz_attempts WHERE username=? AND course_id=? AND level='INTERMEDIATE' ORDER BY attempted_at DESC LIMIT 1");
                p.setString(1, username);
                p.setString(2, courseId);
                ResultSet rs = p.executeQuery();
                if (rs.next() && rs.getInt("score") >= 9 && rs.getInt("tab_switches") <= 3) {
                    out.print("ALLOWED");
                } else {
                    out.print("❌ Unlock Hard only after passing Intermediate with ≥9/10 and ≤3 tab switches.");
                }
                rs.close();
                p.close();
                return;
            } else {
                out.print("Invalid level");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("Error checking quiz unlock.");
        }
    }
}*/
package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import Module1.*;

@WebServlet("/QuizUnlockServlet")
public class QuizUnlockServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null) {
            out.print("Please login first");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.print("Please login first");
            return;
        }

        String username = user.getUsername();
        String courseId = req.getParameter("courseId");
        String level = req.getParameter("level");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "")) {

            if ("EASY".equalsIgnoreCase(level)) {
                // Easy is always allowed
                out.print("ALLOWED");
                return;
            } 
            else if ("INTERMEDIATE".equalsIgnoreCase(level)) {
                // Check if user ever passed EASY
                PreparedStatement p = con.prepareStatement(
                    "SELECT MAX(score) AS best_score, MIN(tab_switches) AS min_switches " +
                    "FROM quiz_attempts WHERE username=? AND course_id=? AND level='EASY'"
                );
                p.setString(1, username);
                p.setString(2, courseId);
                ResultSet rs = p.executeQuery();
                if (rs.next() && rs.getInt("best_score") >= 4 && rs.getInt("min_switches") <= 3) {
                    out.print("ALLOWED");
                } else {
                    out.print("❌ Unlock Intermediate only after passing Easy with ≥4/5 and ≤3 tab switches.");
                }
                rs.close();
                p.close();
                return;
            } 
            else if ("HARD".equalsIgnoreCase(level)) {
                // Check if user ever passed INTERMEDIATE
                PreparedStatement p = con.prepareStatement(
                    "SELECT MAX(score) AS best_score, MIN(tab_switches) AS min_switches " +
                    "FROM quiz_attempts WHERE username=? AND course_id=? AND level='INTERMEDIATE'"
                );
                p.setString(1, username);
                p.setString(2, courseId);
                ResultSet rs = p.executeQuery();
                if (rs.next() && rs.getInt("best_score") >= 9 && rs.getInt("min_switches") <= 3) {
                    out.print("ALLOWED");
                } else {
                    out.print("❌ Unlock Hard only after passing Intermediate with ≥9/10 and ≤3 tab switches.");
                }
                rs.close();
                p.close();
                return;
            } 
            else {
                out.print("Invalid level");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("Error checking quiz unlock.");
        }
    }
}

