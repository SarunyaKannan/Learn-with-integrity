/*
package Module5;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Module1.*;

import Module1.DbConnection; // adjust if your DB helper class is in Module1

@WebServlet("/UserDashboard")
public class UserDashboard extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
    	

        HttpSession session = request.getSession(false);
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
   /*     String username = user.getUsername(); // depends on your User class getter

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }*
        String sql = "SELECT b.image_path, b.name FROM user_badges ub " +
                "JOIN badges b ON ub.badge_id = b.id WHERE ub.username = ?";


        String username = (String) session.getAttribute("username");
        List<Integer> badgeIds = new ArrayList<>();

        try {
            Connection conn = DbConnection.getConnection();
           // String sql = "SELECT badge_id FROM user_badges WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                badgeIds.add(rs.getInt("badge_id"));
            }
System.out.println(badgeIds);
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("badgeIds", badgeIds);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
*/
package Module5;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import Module1.DbConnection;
import Module1.*;
import java.util.*;

@WebServlet("/UserDashboard")
public class UserDashboard extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    	HttpSession session = request.getSession(false);
    	if (session == null || session.getAttribute("user") == null) {
    	    response.sendRedirect("login.jsp");
    	    return;
    	}

    	User user = (User) session.getAttribute("user");
    	String username = user.getUsername();   // safer than session.getAttribute("username")

    	
    	
     /*   HttpSession session = request.getSession(false);

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");*/

        // Badge holder class
        class Badge {
            String badgeName;
            String imagePath;
            String description;

            Badge(String badgeName, String imagePath, String description) {
                this.badgeName = badgeName;
                this.imagePath = imagePath;
                this.description = description;
            }
        }
        List<Map<String, String>> badges = new ArrayList<>();

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT b.badge_id, b.badge_name, b.image_path " +
                 "FROM user_badges ub " +
                 "JOIN badges b ON ub.badge_id = b.badge_id " +
                 "WHERE ub.username = ?")) {

            ps.setString(1, user.getUsername());
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> badge = new HashMap<>();
                badge.put("id", rs.getString("badge_id"));
                badge.put("name", rs.getString("badge_name"));
                badge.put("image", rs.getString("image_path"));
                badges.add(badge);
            }

            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
  //System.out.print(badges);
     // ===== existing code where you fetched badges =====
     // ...after badges list is created and request.setAttribute("badges", badges);

     // Now fetch user certificates:
     List<Map<String, String>> certs = new ArrayList<>();
     try (Connection conn = DbConnection.getConnection();
          PreparedStatement ps = conn.prepareStatement("SELECT id, course_id, file_path, issued_at FROM user_certificates WHERE username = ?")) {
         ps.setString(1, user.getUsername());
         try (ResultSet rs = ps.executeQuery()) {
             while (rs.next()) {
                 Map<String, String> m = new HashMap<>();
                 m.put("id", rs.getString("id"));
                 m.put("course_id", rs.getString("course_id"));
                 m.put("file_path", rs.getString("file_path")); // e.g. "certs/username_course_123.pdf"
                 m.put("issued_at", rs.getString("issued_at"));
                 certs.add(m);
             }
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     request.setAttribute("certs", certs);

     // then forward as before
  //   request.getRequestDispatcher("home.jsp").forward(request, response);

        request.setAttribute("badges", badges);
        request.getRequestDispatcher("home.jsp").forward(request, response);

     /*   List<Badge> badges = new ArrayList<>();

        String sql = "SELECT b.badge_name, b.image_path, b.description " +
                     "FROM user_badges ub " +
                     "JOIN badges b ON ub.badge_id = b.badge_id " +
                     "WHERE ub.username = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String badgeName = rs.getString("badge_name");
                String imagePath = rs.getString("image_path");
                String description = rs.getString("description");

                badges.add(new Badge(badgeName, imagePath, description));
            }

            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }*/

        // Pass the badges to JSP
     /*   request.setAttribute("badges", badges);
        request.getRequestDispatcher("home.jsp").forward(request, response);*/
    }
}
