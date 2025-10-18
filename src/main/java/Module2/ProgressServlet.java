package Module2;

import com.google.gson.Gson;
import Module4.*;
import Module1.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
/*
@WebServlet("/ProgressServlet")
public class ProgressServlet extends HttpServlet {
    private final Gson gson = new Gson();
    

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	System.out.println("reached progress servlet");
        HttpSession session = req.getSession(false);
        String username = null;
        if (session != null) {
            Object uObj = session.getAttribute("user");
            if (uObj instanceof User) username = ((User)uObj).getUsername();
            if (username == null) username = (String) session.getAttribute("username");
        }
        if (username == null) { resp.sendError(401, "Not logged in"); return; }

        int courseId = Integer.parseInt(req.getParameter("courseId"));
        try {
            UserCourseProgress p = new ProgressDAO().getProgress(username, courseId);
            resp.setContentType("application/json");
            resp.getWriter().write(gson.toJson(p));
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, e.getMessage());
        }
    }
}
@WebServlet("/ProgressServlet")
public class ProgressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String username = null;
        if (session != null) {
            Object uObj = session.getAttribute("user");
            if (uObj instanceof User) username = ((User)uObj).getName(); // use getName(), not getUsername()
            if (username == null) username = (String) session.getAttribute("username");
        }
        if (username == null) { resp.sendRedirect("login.jsp"); return; }

        int courseId = Integer.parseInt(req.getParameter("courseId"));
        try {
        	Map<String, Object> p = new ProgressDAO().getProgress(username, courseId);

        	// Example usage:
        	int doc = (int) p.get("doc_progress");
        	int vid = (int) p.get("video_progress");
        	double percentage = (double) p.get("percentage");
        	String quizStatus = (String) p.get("quiz_status");

            
            // store progress in request
            req.setAttribute("progress", p);
            
            // forward to MyCoursesServlet
            req.getRequestDispatcher("MyCoursesServlet").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("mycourses.jsp?status=progress_error");
        }
    }
}
*/




import Module1.DbConnection;
import Module2.Course;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ProgressServlet")
public class ProgressServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = session.getAttribute("username").toString();
        String type = request.getParameter("type"); // DOC or VIDEO
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr == null || type == null) {
            response.getWriter().println("Missing parameters");
            return;
        }

        int courseId = Integer.parseInt(courseIdStr);
        ProgressDAO progressDAO = new ProgressDAO();
        try {
            // Ensure progress row exists
            progressDAO.createIfNotExists(username, courseId);

            // Update progress
            if ("DOC".equalsIgnoreCase(type)) {
                progressDAO.updateDocProgress(username, courseId);
            } else if ("VIDEO".equalsIgnoreCase(type)) {
                progressDAO.updateVideoProgress(username, courseId);
            }

            // Fetch link from DB
            Course course = getCourseById(courseId);
            if (course == null) {
                response.getWriter().println("Course not found.");
                return;
            }

            String redirectLink = type.equalsIgnoreCase("DOC") ? course.getDocumentLink() : course.getVideoLink();
            response.sendRedirect(redirectLink);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating progress: " + e.getMessage());
        }
    }

    private Course getCourseById(int courseId) throws Exception {
        Course course = null;
        try (Connection conn = DbConnection.getConnection()) {
            String sql = "SELECT * FROM courses_1 WHERE id=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        course = new Course();
                        course.setId(rs.getInt("id"));
                        course.setTitle(rs.getString("title"));
                        course.setDocumentLink(rs.getString("document_link"));
                        course.setVideoLink(rs.getString("video_link"));
                    }
                }
            }
        }
        return course;
    }
}
