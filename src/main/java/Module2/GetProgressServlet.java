package Module2;

import Module4.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import jakarta.servlet.*;


@WebServlet("/GetProgressServlet")
public class GetProgressServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        if (username == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        try {
            ProgressDAO pdao = new ProgressDAO();
            UserCourseProgress prog = pdao.getProgress(username, courseId);
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{"
                    + "\"doc_progress\":" + prog.getDocProgress() + ","
                    + "\"video_progress\":" + prog.getVideoProgress() + ","
                    + "\"quiz_progress\":\"" + prog.getQuizProgress() + "\","  // string, so wrap in quotes
                    + "\"ai_check_progress\":\"" + prog.getAiCheckProgress() + "\","  // add this too
                    + "\"overall_status\":\"" + prog.getOverallStatus() + "\"," 
                    + "\"time_spent\":" + prog.getTimeSpent() + ","
                    + "\"percentage\":" + prog.getPercentage()
                    + "}");

            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
