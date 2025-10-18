/*package Module2;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/AddReviewServlet")
public class AddReviewServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Get logged-in user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Module1.User user = (Module1.User) session.getAttribute("user");
        int userId = user.getId();   // ✅ get ID from session User object

        // 2️⃣ Get courseId, rating, and reviewText from form
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String reviewText = request.getParameter("reviewText");

        // 3️⃣ Save review using DAO
        ReviewDAO dao = new ReviewDAO();
        boolean success = dao.addReview(courseId, userId, rating, reviewText);

        // 4️⃣ Redirect back to course page or show message
        if(success){
            session.setAttribute("msg", "Review submitted successfully!");
        } else {
            session.setAttribute("msg", "Failed to submit review. Try again.");
        }
        response.sendRedirect("mycourses.jsp"); // redirect to user's courses
    }
}  */
package Module2;

import Module1.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AddReviewServlet")
public class AddReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        
        

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String reviewText = request.getParameter("reviewText");

        ReviewDAO dao = new ReviewDAO();

        // Check if user already submitted a review
        Review existing = dao.getReviewByUserAndCourse(userId, courseId);

        if (existing != null) {
            dao.updateReview(existing.getReviewId(), rating, reviewText);
        } else {
            dao.addReview(courseId, userId, rating, reviewText);
        }

        // Set success message in session
        session.setAttribute("msg", "Thanks for your review!");

        response.sendRedirect("MyCoursesServlet"); // redirect to mycourses.jsp
    }
}

