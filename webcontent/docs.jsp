<%-- --><%@ page import="java.sql.*, Module1.DbConnection, Module2.Course,Module2.ProgressDAO, Module4.UserCourseProgress" %>
<%@ page session="true" %>
<%
    String courseIdStr = request.getParameter("courseId");
    if (courseIdStr == null) {
        out.println("Course ID missing.");
        return;
    }

    int courseId = Integer.parseInt(courseIdStr);
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
                } else {
                    out.println("Course not found.");
                    return;
                }
            }
        }
    }

    String username = session.getAttribute("username").toString();

    ProgressDAO progressDAO = new ProgressDAO();
    UserCourseProgress progress = progressDAO.getProgress(username, courseId);

    if (progress == null) {
        // Create empty progress row if missing
        progressDAO.upsertBlankIfMissing(username, courseId);
        progress = progressDAO.getProgress(username, courseId);
    }

    // Set doc progress to 25% if not already higher
    int newDocProgress = Math.max(progress.getDocProgress(), 25);
    progressDAO.logEvent(username, courseId, "DOC", newDocProgress);

    // Redirect to the actual document
    response.sendRedirect(course.getDocumentLink());
%>
--%>
<%-- SAturday updation--%
<%@ page import="java.sql.*, Module1.DbConnection, Module2.Course, Module2.ProgressDAO, Module4.UserCourseProgress" %>
<%@ page session="true" %>
<%
    String courseIdStr = request.getParameter("courseId");
    if (courseIdStr == null) {
        out.println("Course ID missing.");
        return;
    }

    int courseId = Integer.parseInt(courseIdStr);
    Course course = null;

    // Fetch course details
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
                } else {
                    out.println("Course not found.");
                    return;
                }
            }
        }
    }

    String username = session.getAttribute("username").toString();
    ProgressDAO progressDAO = new ProgressDAO();

    // Ensure progress row exists
    progressDAO.createIfNotExists(username, courseId);

    // Update Doc progress (25%)
    progressDAO.updateDocProgress(username, courseId, true);

    // Redirect to actual document
    response.sendRedirect(course.getDocumentLink());
--%>
<%@ page import="java.sql.*,Module1.DbConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String docLink = "#";

    if (courseId != null) {
        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT document_link FROM courses_1 WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(courseId));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    docLink = rs.getString("document_link");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Redirect directly
    response.sendRedirect(docLink != null ? docLink : "mycourses.jsp");
%>
