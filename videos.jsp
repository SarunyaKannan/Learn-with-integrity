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
                    course.setVideoLink(rs.getString("video_link")); // assume column video_link
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
        progressDAO.upsertBlankIfMissing(username, courseId);
        progress = progressDAO.getProgress(username, courseId);
    }

    // Set video progress to 25% if not already higher
    int newVideoProgress = Math.max(progress.getVideoProgress(), 25);
    progressDAO.logEvent(username, courseId, "VIDEO", newVideoProgress);

    // Redirect to video URL
    response.sendRedirect(course.getVideoLink());
%>  --%
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
                    course.setVideoLink(rs.getString("video_link"));
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

    // Update Video progress (25%)
    progressDAO.updateVideoProgress(username, courseId, true);

    // Redirect to video link
    response.sendRedirect(course.getVideoLink());
--%>
<%@ page import="java.sql.*,Module1.DbConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String videoLink = "#";

    if (courseId != null) {
        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT video_link FROM courses_1 WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(courseId));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    videoLink = rs.getString("video_link");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Redirect directly
    response.sendRedirect(videoLink != null ? videoLink : "mycourses.jsp");
%>




