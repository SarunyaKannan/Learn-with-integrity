package Module2;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/GetReviewsServlet")
public class GetReviewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            int courseId = Integer.parseInt(req.getParameter("courseId"));

            ReviewDAO dao = new ReviewDAO();
            List<Review> reviews = dao.getReviewsByCourseId(courseId);

            if (reviews.isEmpty()) {
                out.println("<p>No reviews yet. Be the first to review this course!</p>");
            } else {
                for (Review r : reviews) {
                    out.println("<div style='margin-bottom:12px; padding:10px; border-bottom:1px solid rgba(255,255,255,0.1)'>");
                    out.println("<strong style='color:#00e0ff'>" + r.getUsername() + "</strong> ");
                    out.println("<span style='color:gold'>(" + r.getRating() + "★)</span><br>");
                    out.println("<em style='color:#ddd'>" + r.getReviewText() + "</em><br>");
                    out.println("<small style='color:gray'>" + r.getCreatedAt() + "</small>");
                    out.println("</div>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red'>Failed to load reviews.</p>");
        }
    }
}
