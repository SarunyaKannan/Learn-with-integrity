/*package Module2;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import Module1.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.ArrayList;
import java.util.List;

/*@WebServlet("/MyCoursesServlet")
public class MyCoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String username = user.getUsername();

        List<Course> myCourses = new ArrayList<>();

        try (Connection conn = DbConnection.getConnection()) {
            // Step 1: Get course IDs for this user
            String sql = "SELECT c.id, c.title, c.description, c.link " +
                         "FROM user_courses uc JOIN courses c ON uc.course_id = c.id " +
                         "WHERE uc.username = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setLink(rs.getString("doc_link"));
                    myCourses.add(course);
                }
            }

            request.setAttribute("myCourses", myCourses);
            RequestDispatcher dispatcher = request.getRequestDispatcher("mycourses.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}


@WebServlet("/MyCoursesServlet")
public class MyCoursesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    	System.out.println("reahced mycourses servlet");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String username = user.getUsername();
       
        Map<String, List<Course>> sectionCourses = new HashMap<>();

        try (Connection conn = DbConnection.getConnection()) {
            String sql = "SELECT c.* FROM courses_1 c "
                       + "JOIN user_courses uc ON c.id = uc.course_id "
                       + "WHERE uc.username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                var rs = stmt.executeQuery();
                List<Course> allCourses = new ArrayList<>();
                while (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("id"));
                    c.setTitle(rs.getString("title"));
                    c.setDescription(rs.getString("description"));
                    c.setImage(rs.getString("image"));
                    c.setSyllabus(rs.getString("syllabus"));
                    c.setDesign(rs.getString("design"));
                    c.setTopicsCovered(rs.getString("topics_covered"));
                    c.setTestDetails(rs.getString("test_details"));
                    allCourses.add(c);
                }
                sectionCourses.put("My", allCourses); // simple category
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("sectionCourses", sectionCourses);
        request.getRequestDispatcher("mycourses.jsp").forward(request, response);
    }
}  */  /*  UPDATION FOR COURSE PROGRESS TO 25%
package Module2;

import Module1.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Module4.UserCourseProgress;

@WebServlet("/MyCoursesServlet")
public class MyCoursesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	HttpSession session = request.getSession(false);
    	
    //	request.getRequestDispatcher("mycourses.jsp").forward(request, response);

     //   HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        
    	    String msg = (String) session.getAttribute("msg");
    	    if (msg != null) {
    	        request.setAttribute("msg", msg);
    	        session.removeAttribute("msg"); 
    	   //     System.out.println("MESSage in mycourses servelt is "+msg);//🔑 prevent duplicate showing
    	    }
    	

        User user = (User) session.getAttribute("user");
        String username = user.getUsername();

        List<Course> enrolled = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.description, c.image, " +
                     "IFNULL(ucp.doc_progress,'NOT_STARTED') AS doc_progress, " +
                     "IFNULL(ucp.video_progress,'NOT_STARTED') AS video_progress, " +
                     "IFNULL(ucp.quiz_progress,'LOCKED') AS quiz_progress, " +
                     "IFNULL(ucp.overall_status,'NOT_STARTED') AS total_progress, " +
                     "IFNULL(ucp.percentage,0) AS percentage " +
                     "FROM courses_1 c " +
                     "JOIN user_courses uc ON c.id = uc.course_id " +
                     "LEFT JOIN user_course_progress ucp ON uc.username = ucp.username AND uc.course_id = ucp.course_id " +
                     "WHERE uc.username = ?";

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("id"));
                    c.setTitle(rs.getString("title"));
                    c.setDescription(rs.getString("description"));
                    c.setImage(rs.getString("image"));

                    // Convert enum status to integer progress
                    c.setDocProgress(rs.getString("doc_progress"));
                    c.setVideoProgress(convertDocVideoStatus(rs.getString("video_progress")));
                    c.setQuizProgress(convertQuizStatus(rs.getString("quiz_progress")));
                    c.setTotalProgress(convertOverallStatus(rs.getString("total_progress")));

                    c.setPercentage(rs.getDouble("percentage"));

                    enrolled.add(c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
        
     /*   String msg = (String) request.getAttribute("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
        }
     *
        Map<Integer, UserCourseProgress> progressMap = new HashMap<>();
        ProgressDAO progressDAO = new ProgressDAO();

        for (Course c : courses) {
            UserCourseProgress progress = progressDAO.getProgress(username, c.getId());
            if (progress != null) {
                progressMap.put(c.getId(), progress);
            }
        }

        request.setAttribute("progressMap", progressMap);
        request.setAttribute("sectionCourses", sectionCourses);


      /*  Map<String, List<Course>> sectionCourses = new HashMap<>();
        sectionCourses.put("My Courses", enrolled);
        request.setAttribute("sectionCourses", sectionCourses);*
        request.getRequestDispatcher("mycourses.jsp").forward(request, response);
    }

 /*   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }*

    // Map doc/video enum to int (NOT_STARTED=0, REVIEWED=100)
    private int convertDocVideoStatus(String status) {
        if (status == null) return 0;
        switch (status) {
            case "NOT_STARTED": return 0;
            case "REVIEWED": return 100;
            default: return 0;
        }
    }

    // Map quiz enum to int (LOCKED=0, IN_PROGRESS=50, COMPLETED=100)
    private int convertQuizStatus(String status) {
        if (status == null) return 0;
        switch (status) {
            case "LOCKED": return 0;
            case "IN_PROGRESS": return 50;
            case "COMPLETED": return 100;
            default: return 0;
        }
    }

    // Map overall_status enum to int (NOT_STARTED=0, IN_PROGRESS=50, COMPLETED=100)
    private int convertOverallStatus(String status) {
        if (status == null) return 0;
        switch (status) {
            case "NOT_STARTED": return 0;
            case "IN_PROGRESS": return 50;
            case "COMPLETED": return 100;
            default: return 0;
        }
    }
}
*package Module2;

import Module1.*; // Course, User
import Module4.*; 
// UserCourseProgress, ProgressDAO
import Module2.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/MyCoursesServlet")
public class MyCoursesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // handle msg forwarding
        String msg = (String) session.getAttribute("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
            session.removeAttribute("msg");
        }

        User user = (User) session.getAttribute("user");
        String username = user.getUsername();

        // 1️⃣ Get enrolled courses
        List<Course> enrolledCourses = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.description, c.image " +
                     "FROM courses_1 c " +
                     "JOIN user_courses uc ON c.id = uc.course_id " +
                     "WHERE uc.username = ?";

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("id"));
                    c.setTitle(rs.getString("title"));
                    c.setDescription(rs.getString("description"));
                    c.setImage(rs.getString("image"));
                    enrolledCourses.add(c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }

        // 2️⃣ Get progress for each course
        Map<Integer, UserCourseProgress> progressMap = new HashMap<>();
        ProgressDAO progressDAO = new ProgressDAO();

        for (Course c : enrolledCourses) {
            UserCourseProgress progress = progressDAO.getProgress(username, c.getId());
            if (progress != null) {
                progressMap.put(c.getId(), progress);
            }
        }

        // 3️⃣ Pass data to JSP
        Map<String, List<Course>> sectionCourses = new HashMap<>();
        sectionCourses.put("My Courses", enrolledCourses);

        request.setAttribute("progressMap", progressMap);
        request.setAttribute("sectionCourses", sectionCourses);

        request.getRequestDispatcher("mycourses.jsp").forward(request, response);
    }
}   */






/*  fix to play youtube video */



package Module2;

import Module1.*;
import Module4.*;
import Module2.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/MyCoursesServlet")
public class MyCoursesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Handle msg forwarding
        String msg = (String) session.getAttribute("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
            session.removeAttribute("msg");
        }

        User user = (User) session.getAttribute("user");
        String username = user.getUsername();

        // 1️⃣ Get enrolled courses WITH video_link and document_link
        List<Course> enrolledCourses = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.description, c.image, " +
                     "c.document_link, c.video_link, c.section " +  // ✅ ADDED THESE!
                     "FROM courses_1 c " +
                     "JOIN user_courses uc ON c.id = uc.course_id " +
                     "WHERE uc.username = ?";

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("id"));
                    c.setTitle(rs.getString("title"));
                    c.setDescription(rs.getString("description"));
                    c.setImage(rs.getString("image"));
                    c.setDocumentLink(rs.getString("document_link"));  // ✅ SET THIS
                    c.setVideoLink(rs.getString("video_link"));        // ✅ SET THIS
                    c.setSection(rs.getString("section"));             // ✅ SET THIS
                    enrolledCourses.add(c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }

        // 2️⃣ Get progress for each course
        Map<Integer, UserCourseProgress> progressMap = new HashMap<>();
        ProgressDAO progressDAO = new ProgressDAO();

        for (Course c : enrolledCourses) {
            UserCourseProgress progress = progressDAO.getProgress(username, c.getId());
            if (progress != null) {
                progressMap.put(c.getId(), progress);
            }
        }

        // 3️⃣ Pass data to JSP
        Map<String, List<Course>> sectionCourses = new HashMap<>();
        sectionCourses.put("My Courses", enrolledCourses);

        request.setAttribute("progressMap", progressMap);
        request.setAttribute("sectionCourses", sectionCourses);

        request.getRequestDispatcher("mycourses.jsp").forward(request, response);
    }
}
