/*package Module2;



import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import Module1.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    	System.out.println("REached addcourse servlet");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        
        User user=(User) session.getAttribute("user");
        String username=user.getName();
        String courseIdStr = request.getParameter("courseId");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            response.sendRedirect("explore.jsp?error=missing_course");
            return;
        }

        int courseId = Integer.parseInt(courseIdStr);

        try (Connection conn = DbConnection.getConnection()) {
            // Check if already added
            String checkSql = "SELECT COUNT(*) FROM user_courses WHERE username=? AND course_id=?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                checkStmt.setInt(2, courseId);
                var rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    response.sendRedirect("mycourses.jsp?status=already_added");
                    return;
                }
            }

            // Insert into user_courses
         // Insert into user_courses
         // Insert into user_courses
            String insertSql = "INSERT INTO user_courses (username, course_id) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                stmt.setString(1, username);
                stmt.setInt(2, courseId);
                stmt.executeUpdate();
            }
            String progressSql = "INSERT INTO user_course_progress (username, course_id, doc_progress, video_progress, ai_check_progress, quiz_progress, overall_status, time_spent, last_updated) VALUES (?, ?, 0, 0, 'NOT_STARTED', 'NOT_STARTED', 'NOT_STARTED', 0, NOW())";
            PreparedStatement ps2 = conn.prepareStatement(progressSql);
            ps2.setString(1, username);
            ps2.setInt(2, courseId);
            ps2.executeUpdate();

            // Redirect to ProgressServlet
            response.sendRedirect("ProgressServlet?courseId=" + courseId);

            // ✅ Redirect to MyCoursesServlet (not directly to JSP)
          //  response.sendRedirect("MyCoursesServlet?status=success");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("mycourses.jsp?status=error");
        }
    }
}  */
package Module2;

import Module1.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;
import Module2.*;
@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession(false);
    	if (session == null || session.getAttribute("user") == null) {
    	    response.sendRedirect("login.jsp");
    	    return;
    	}
    	

    	User user = (User) session.getAttribute("user");
    	
    	int courseId = Integer.parseInt(request.getParameter("courseId"));
    	String username = user.getUsername();

    	try (Connection con = DbConnection.getConnection()) {
    	    // 1️⃣ Check if already enrolled
    	    String checkSql = "SELECT 1 FROM user_courses WHERE username=? AND course_id=?";
    	    PreparedStatement ps = con.prepareStatement(checkSql);
    	    ps.setString(1, username);
    	    ps.setInt(2, courseId);
    	    ResultSet rs = ps.executeQuery();

    	    if (rs.next()) {
    	        // already exists → set message
    	    	session.setAttribute("msg", "Course already added to My Courses!");
    	        response.sendRedirect("MyCoursesServlet");
    	    } else {
    	        // 2️⃣ Insert new enrollment
    	        String insertSql = "INSERT INTO user_courses (username, course_id, enrolled_at) VALUES (?, ?, NOW())";
    	        PreparedStatement ps2 = con.prepareStatement(insertSql);
    	        ps2.setString(1, username);
    	        ps2.setInt(2, courseId);
    	        ps2.executeUpdate();

    	        // 3️⃣ Also create progress record
    	        ProgressDAO dao = new ProgressDAO();
    	        dao.createIfNotExists(username, courseId);
    	        
    	        
    	         String getCourseName = "SELECT * FROM courses_1 WHERE id=?";
    	         PreparedStatement ps3 = con.prepareStatement(getCourseName);
     	    //    ps2.setString(1, username);
     	        ps3.setInt(1, courseId);
        	  ResultSet rs1 = ps3.executeQuery();
    	        
        	  String courseName=null;
    	        String userEmail = user.getEmail(); 
    	        if(rs1.next()){// make sure User class has getEmail()
    	         courseName = rs1.getString("title"); 
    	        }// later you can fetch from DB
    	        String courseLink = "http://localhost:8080/Demo/MyCoursesServlet";

    	        RegisterServlet.sendCourseRegistrationMail(userEmail, username, courseName, courseLink);

    	        
    	     // AddCourseServlet
    	    /*    HttpSession session = request.getSession();
    	        session.setAttribute("msg", "Course added successfully!");
    	        response.sendRedirect("MyCoursesServlet");

    	        
    	        request.setAttribute("msg", "Course successfully added!");
    	        request.getRequestDispatcher("MyCoursesServlet").forward(request, response);*/
    	        session.setAttribute("msg", "Course added successfully!");
                response.sendRedirect("MyCoursesServlet");
    	    }

    	    // 4️⃣ Forward to MyCourses JSP
    	   // request.getRequestDispatcher("mycourses.jsp").forward(request, response);

    	} catch (Exception e) {
    	    e.printStackTrace();
    	    session.setAttribute("msg", "Something went wrong while adding the course.");
    	    request.getRequestDispatcher("mycourses.jsp").forward(request, response);
    	}
    }

 /*       int courseId = Integer.parseInt(request.getParameter("courseId"));
        System.out.println("Reached addcourse servlet "+courseId);
        try (Connection con = DbConnection.getConnection()) {
            String ins = "INSERT IGNORE INTO user_courses (username, course_id, enrolled_at) VALUES (?, ?, NOW())";
            try (PreparedStatement ps = con.prepareStatement(ins)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            }
            // ensure progress row
            ProgressDAO pdao = new ProgressDAO();
            pdao.createIfNotExists(username, courseId);

           

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }*/
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}

