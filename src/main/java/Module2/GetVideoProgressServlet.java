/*package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import org.json.JSONObject;
import Module1.User;

@WebServlet("/GetVideoProgressServlet")
public class GetVideoProgressServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            out.print("{\"error\": \"Not logged in\"}");
            return;
        }
        
        String username = user.getUsername();
        
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            
            ProgressDAO pdao = new ProgressDAO();
            double watchPercent = pdao.getVideoWatchPercent(username, courseId);
            
            JSONObject json = new JSONObject();
            json.put("courseId", courseId);
            json.put("videoWatchPercent", watchPercent);
            
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}  *




package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import Module1.User;

@WebServlet("/GetVideoProgressServlet")
public class GetVideoProgressServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            out.print("{\"error\": \"Not logged in\"}");
            return;
        }
        
        String username = user.getUsername();
        
        try {
            String courseIdStr = request.getParameter("courseId");
            
            if (courseIdStr == null) {
                out.print("{\"error\": \"Missing courseId parameter\"}");
                return;
            }
            
            int courseId = Integer.parseInt(courseIdStr);
            
            ProgressDAO pdao = new ProgressDAO();
            double watchPercent = pdao.getVideoWatchPercent(username, courseId);
            
            String json = "{" +
                "\"courseId\": " + courseId + "," +
                "\"videoWatchPercent\": " + watchPercent +
                "}";
            
            out.print(json);
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
} */



// video time updation  


/*
package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import Module1.User;
import Module2.ProgressDAO;

@WebServlet("/GetVideoProgressServlet")
public class GetVideoProgressServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            out.print("{\"error\": \"Not logged in\"}");
            return;
        }

        String username = user.getUsername();

        try {
            String courseIdStr = request.getParameter("courseId");

            if (courseIdStr == null) {
                out.print("{\"error\": \"Missing courseId parameter\"}");
                return;
            }

            int courseId = Integer.parseInt(courseIdStr);

            ProgressDAO pdao = new ProgressDAO();
            
            // Create progress record if doesn't exist
            ProgressDAO.createIfNotExists(username, courseId);
            
            // Get video watch percentage and last position
            double watchPercent = pdao.getVideoWatchPercent(username, courseId);
            int lastPosition = pdao.getVideoLastPosition(username, courseId);

            // Build JSON response
            String json = String.format(
                "{\"courseId\": %d, \"videoWatchPercent\": %.2f, \"lastPosition\": %d}",
                courseId, watchPercent, lastPosition
            );

            System.out.println("📊 Get Video Progress - Course: " + courseId + 
                             ", Watch%: " + watchPercent + ", Position: " + lastPosition + "s");

            out.print(json);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            out.print("{\"error\": \"Invalid courseId format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}  */



package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import Module1.User;
import Module2.ProgressDAO;

@WebServlet("/GetVideoProgressServlet")
public class GetVideoProgressServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            out.print("{\"error\": \"Not logged in\"}");
            return;
        }

        String username = user.getUsername();

        try {
            String courseIdStr = request.getParameter("courseId");

            if (courseIdStr == null) {
                out.print("{\"error\": \"Missing courseId parameter\"}");
                return;
            }

            int courseId = Integer.parseInt(courseIdStr);

            ProgressDAO pdao = new ProgressDAO();
            
            // Create progress record if doesn't exist
            ProgressDAO.createIfNotExists(username, courseId);
            
            // Get video watch percentage and last position
            double watchPercent = pdao.getVideoWatchPercent(username, courseId);
            int lastPosition = pdao.getVideoLastPosition(username, courseId);

            System.out.println("📊 Retrieved from database:");
            System.out.println("   video_watch_percent: " + watchPercent);
            System.out.println("   video_last_position: " + lastPosition);

            // Build JSON response
            String json = String.format(
                "{\"courseId\": %d, \"videoWatchPercent\": %.2f, \"lastPosition\": %d}",
                courseId, watchPercent, lastPosition
            );

            System.out.println("📊 Get Video Progress - Course: " + courseId + 
                             ", Watch%: " + watchPercent + ", Position: " + lastPosition + "s");
            System.out.println("📤 Sending JSON: " + json);

            out.print(json);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            out.print("{\"error\": \"Invalid courseId format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}