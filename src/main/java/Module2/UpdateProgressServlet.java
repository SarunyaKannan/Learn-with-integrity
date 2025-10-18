/*package Module2;

import com.google.gson.Gson;
import Module4.*;
import Module1.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/updateProgress")
public class UpdateProgressServlet extends HttpServlet {
    private final ProgressDAO progressDAO = new ProgressDAO();
    private final ProgressService progressService = new ProgressService();
    private final BadgeAwardService badgeAwardService = new BadgeAwardService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Support both "user" object and legacy "username" string in session
    	System.out.println("reached update progress servlet");
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendError(401, "Not logged in"); return; }

        String username = null;
        Object uObj = session.getAttribute("user");
        if (uObj instanceof User) username = ((User)uObj).getUsername();
        if (username == null) username = (String) session.getAttribute("username"); // fallback
        if (username == null) { resp.sendError(401, "Not logged in"); return; }

        int courseId = Integer.parseInt(req.getParameter("courseId"));
        String action = req.getParameter("action"); // doc, video, ai, quiz, time
        String valueStr = req.getParameter("value");

        try {
            // ensure row exists
            progressDAO.upsertBlankIfMissing(username, courseId);

            // Normalize to activity + numeric value
            String activity = null;
            int value = 0;
            switch (action.toLowerCase()) {
                case "doc":
                    activity = "DOC";
                    value = Integer.parseInt(valueStr);
                    break;
                case "video":
                    activity = "VIDEO";
                    value = Integer.parseInt(valueStr);
                    break;
                case "ai":
                    activity = "AI";
                    // accept either numeric or enum string
                    value = parseAIValue(valueStr);
                    break;
                case "quiz":
                    activity = "QUIZ";
                    value = parseQuizValue(valueStr);
                    break;
                case "time":
                    activity = "TIME";
                    value = Integer.parseInt(valueStr); // seconds
                    break;
                default:
                    resp.sendError(400, "Invalid action"); return;
            }

            // log event and update aggregates
            progressDAO.logEvent(username, courseId, activity, value);

            // return updated progress
            UserCourseProgress p = progressDAO.getProgress(username, courseId);

            // If overall changed to COMPLETED -> maybe award badge
            String newStatus = progressService.calculateOverallStatus(p);
            if (!newStatus.equals(p.getOverallStatus())) {
                progressDAO.updateProgressFields(username, courseId, null, null, null, null, newStatus);
                p.setOverallStatus(newStatus);
            }
            badgeAwardService.maybeAwardCompletionBadge(p);

            resp.setContentType("application/json");
            resp.getWriter().write(gson.toJson(p));
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, e.getMessage());
        }
    }

    private int parseAIValue(String v) {
        if (v == null) return 0;
        v = v.trim().toUpperCase();
        if (v.equals("COMPLETED")) return 100;
        if (v.equals("IN_PROGRESS")) return 50;
        try { return Integer.parseInt(v); } catch (Exception e) { return 0; }
    }

    private int parseQuizValue(String v) {
        if (v == null) return 0;
        v = v.trim().toUpperCase();
        switch (v) {
            case "FULL_COMPLETED":
            case "HARD_COMPLETED": return 100;
            case "INTERMEDIATE_COMPLETED": return 66;
            case "EASY_COMPLETED": return 33;
            default:
                try { return Integer.parseInt(v); } catch (Exception e) { return 0; }
        }
    }
}  
package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/UpdateProgressServlet")
public class UpdateProgressServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        if (username == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String activity = request.getParameter("activity"); // "DOC" | "VIDEO" | "QUIZ"
        String valueParam = request.getParameter("value");
        boolean completed = "100".equals(valueParam) || "true".equalsIgnoreCase(valueParam);

        try {
            ProgressDAO pdao = new ProgressDAO();
            pdao.createIfNotExists(username, courseId);

            switch (activity) {
                case "DOC":
                    pdao.updateDocProgress(username, courseId, completed);
                    break;
                case "VIDEO":
                    pdao.updateVideoProgress(username, courseId, completed);
                    break;
                case "QUIZ":
                    pdao.updateQuizProgressOnCompletion(username, courseId, completed);
                    break;
                default:
                    break;
            }

            Map<String, Object> prog = pdao.getProgress(username, courseId);

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{"
                    + "\"doc_progress\":" + prog.get("doc_progress") + ","
                    + "\"video_progress\":" + prog.get("video_progress") + ","
                    + "\"quiz_progress\":" + prog.get("quiz_progress") + ","
                    + "\"total_progress\":" + prog.get("total_progress") + ","
                    + "\"percentage\":" + prog.get("percentage")
                    + "}");
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
*//*
package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import Module1.User;

@WebServlet("/UpdateProgressServlet")
public class UpdateProgressServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    //	System.out.println("REached Updateprogressservlet");

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
      //  String username = (session != null) ? (String) session.getAttribute("username") : null;
        String username=user.getUsername();
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }
     //   System.out.println("username is "+username);
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String activity = request.getParameter("activity"); // DOC or VIDEO

        try {
            ProgressDAO pdao = new ProgressDAO();
            pdao.createIfNotExists(username, courseId);

            String redirectUrl = "mycourses.jsp"; // fallback

            if ("DOC".equals(activity)) {
                pdao.updateDocProgress(username, courseId);
                redirectUrl = pdao.getCourseLink(courseId, "DOC");
            } else if ("VIDEO".equals(activity)) {
                pdao.updateVideoProgress(username, courseId);
                redirectUrl = pdao.getCourseLink(courseId, "VIDEO");
            }
            else if ("VIDEO_COMPLETE".equals(activity)) {
                pdao.updateVideoProgress(username, courseId);
                response.getWriter().write("success");
                return; // avoid redirect
            }


            if (redirectUrl == null || redirectUrl.isEmpty()) {
                redirectUrl = "mycourses.jsp";
            }

            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
*/




// claude ai 


package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import Module1.User;

@WebServlet("/UpdateProgressServlet")
public class UpdateProgressServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String username = user.getUsername();
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String activity = request.getParameter("activity"); // DOC only now

        try {
            ProgressDAO pdao = new ProgressDAO();
            pdao.createIfNotExists(username, courseId);

            String redirectUrl = "mycourses.jsp"; // fallback

            if ("DOC".equals(activity)) {
                pdao.updateDocProgress(username, courseId);
                redirectUrl = pdao.getCourseLink(courseId, "DOC");
            }
            // VIDEO activity is now handled by UpdateVideoProgressServlet

            if (redirectUrl == null || redirectUrl.isEmpty()) {
                redirectUrl = "mycourses.jsp";
            }

            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
