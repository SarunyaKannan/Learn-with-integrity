package Module4;



import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebFilter("/MyCoursesServlet")  // filter applied whenever MyCoursesServlet is hit
public class TimeTrackerFilter implements Filter {

    private Connection conn;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", ""); 
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession();

        long startTime = System.currentTimeMillis();

        chain.doFilter(request, response);  // pass request to servlet

        long endTime = System.currentTimeMillis();
        long duration = (endTime - startTime) / 1000; // seconds spent

        try {
            String userId = (String) session.getAttribute("userId");  
            String courseId = request.getParameter("courseId");

            if (userId != null && courseId != null) {
                String sql = "INSERT INTO progress(user_id, course_id, time_spent, status) " +
                             "VALUES (?, ?, ?, 'IN_PROGRESS') " +
                             "ON DUPLICATE KEY UPDATE time_spent = time_spent + VALUES(time_spent)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, userId);
                ps.setString(2, courseId);
                ps.setLong(3, duration);
                ps.executeUpdate();
                ps.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void destroy() {
        try {
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
