package Module2;



import Module4.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/courseDetail")
public class CourseDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = (String) req.getSession().getAttribute("username");
        if (username == null) { resp.sendRedirect("index.jsp"); return; }

        int courseId = Integer.parseInt(req.getParameter("courseId"));
        ProgressDAO dao = new ProgressDAO();
        try {
            dao.upsertBlankIfMissing(username, courseId);
            UserCourseProgress p = dao.getProgress(username, courseId);
            req.setAttribute("p", p);
            req.getRequestDispatcher("/course_detail.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
