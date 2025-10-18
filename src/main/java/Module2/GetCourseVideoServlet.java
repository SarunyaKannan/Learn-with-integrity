package Module2;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import org.json.JSONObject;
import Module1.DbConnection;

@WebServlet("/GetCourseVideoServlet")
public class GetCourseVideoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        response.setContentType("application/json");
        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT video_link FROM courses_1 WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, courseId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    JSONObject obj = new JSONObject();
                    obj.put("video_link", rs.getString("video_link"));
                    response.getWriter().write(obj.toString());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
