/*package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import org.json.JSONObject;
import Module1.User;

@WebServlet("/UpdateVideoProgressServlet")
public class UpdateVideoProgressServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            double watchPercent = Double.parseDouble(request.getParameter("watchPercent"));
            
            ProgressDAO pdao = new ProgressDAO();
            pdao.createIfNotExists(username, courseId);
            
            // Update video watch percentage
            pdao.updateVideoWatchProgress(username, courseId, watchPercent);
            
            // If watched >= 90%, mark video as REVIEWED and add 25% to total
            if (watchPercent >= 90.0) {
                pdao.markVideoAsReviewed(username, courseId);
            }
            
            // Get updated progress
            int totalProgress = pdao.Checkprogress(username, courseId);
            String videoStatus = pdao.getVideoStatus(username, courseId);
            
            // Return JSON response
            JSONObject json = new JSONObject();
            json.put("success", true);
            json.put("watchPercent", watchPercent);
            json.put("totalProgress", totalProgress);
            json.put("videoStatus", videoStatus);
            
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}  *





package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import Module1.User;

@WebServlet("/UpdateVideoProgressServlet")
public class UpdateVideoProgressServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            // ✅ Add null checks for parameters
            String courseIdStr = request.getParameter("courseId");
            String watchPercentStr = request.getParameter("watchPercent");
            
            if (courseIdStr == null || watchPercentStr == null) {
                out.print("{\"error\": \"Missing courseId or watchPercent parameter\"}");
                System.err.println("❌ Missing parameters - courseId: " + courseIdStr + ", watchPercent: " + watchPercentStr);
                return;
            }
            
            int courseId = Integer.parseInt(courseIdStr);
            double watchPercent = Double.parseDouble(watchPercentStr);
            
            System.out.println("📊 Updating video progress - Course: " + courseId + ", Watch%: " + watchPercent);
            
            ProgressDAO pdao = new ProgressDAO();
            pdao.createIfNotExists(username, courseId);
            
            // Update video watch percentage
            pdao.updateVideoWatchProgress(username, courseId, watchPercent);
            
            // If watched >= 90%, mark video as REVIEWED and add 25% to total
            if (watchPercent >= 90.0) {
                pdao.markVideoAsReviewed(username, courseId);
                System.out.println("✅ Video marked as REVIEWED (90%+ watched)");
            }
            
            // Get updated progress
            int totalProgress = pdao.Checkprogress(username, courseId);
            String videoStatus = pdao.getVideoStatus(username, courseId);
            
            // Return JSON response
            String json = "{" +
                "\"success\": true," +
                "\"watchPercent\": " + watchPercent + "," +
                "\"totalProgress\": " + totalProgress + "," +
                "\"videoStatus\": \"" + videoStatus + "\"" +
                "}";
            
            out.print(json);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            out.print("{\"error\": \"Invalid number format: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
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

@WebServlet("/UpdateVideoProgressServlet")
public class UpdateVideoProgressServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            out.print("{\"success\": false, \"error\": \"Not logged in\"}");
            return;
        }

        String username = user.getUsername();

        try {
            // Get parameters
            String courseIdStr = request.getParameter("courseId");
            String watchPercentStr = request.getParameter("watchPercent");
            String lastPositionStr = request.getParameter("lastPosition");

            // Validate parameters
            if (courseIdStr == null || watchPercentStr == null || lastPositionStr == null) {
                out.print("{\"success\": false, \"error\": \"Missing required parameters\"}");
                System.err.println("❌ Missing parameters - courseId: " + courseIdStr + 
                                 ", watchPercent: " + watchPercentStr + 
                                 ", lastPosition: " + lastPositionStr);
                return;
            }

            int courseId = Integer.parseInt(courseIdStr);
            double watchPercent = Double.parseDouble(watchPercentStr);
            int lastPosition = Integer.parseInt(lastPositionStr);

            System.out.println("📊 Updating video progress - Course: " + courseId + 
                             ", Watch%: " + watchPercent + ", Position: " + lastPosition + "s");

            ProgressDAO pdao = new ProgressDAO();
            
            // Create progress record if doesn't exist
            ProgressDAO.createIfNotExists(username, courseId);

            // Update video watch percentage and last position
            pdao.updateVideoWatchProgress(username, courseId, watchPercent, lastPosition);

            // If watched >= 90%, mark video as REVIEWED
            boolean isReviewed = false;
            if (watchPercent >= 90.0) {
                pdao.markVideoAsReviewed(username, courseId);
                isReviewed = true;
                System.out.println("✅ Video marked as REVIEWED (90%+ watched)");
            }

            // Get updated progress
            int totalProgress = pdao.Checkprogress(username, courseId);
            String videoStatus = pdao.getVideoStatus(username, courseId);

            // Build JSON response
            String json = String.format(
                "{\"success\": true, \"watchPercent\": %.2f, \"lastPosition\": %d, " +
                "\"totalProgress\": %d, \"videoStatus\": \"%s\", \"isReviewed\": %b}",
                watchPercent, lastPosition, totalProgress, videoStatus, isReviewed
            );

            System.out.println("✅ Progress saved successfully - Total: " + totalProgress + "%");

            out.print(json);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"Invalid number format: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
} */



// updation worked here 
/*

package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import Module1.User;
import Module2.ProgressDAO;

@WebServlet("/UpdateVideoProgressServlet")
public class UpdateVideoProgressServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Debug: Print all parameters
        System.out.println("🔔 UpdateVideoProgressServlet called!");
        System.out.println("📝 All parameters:");
        request.getParameterMap().forEach((key, value) -> {
            System.out.println("   " + key + " = " + (value != null && value.length > 0 ? value[0] : "null"));
        });

        HttpSession session = request.getSession(false);
        if (session == null) {
            out.print("{\"success\": false, \"error\": \"No session\"}");
            System.err.println("❌ No session found");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.print("{\"success\": false, \"error\": \"Not logged in\"}");
            System.err.println("❌ User not logged in");
            return;
        }

        String username = user.getUsername();
        System.out.println("👤 User: " + username);

        try {
            // Get parameters - try both ways
            String courseIdStr = request.getParameter("courseId");
            String watchPercentStr = request.getParameter("watchPercent");
            String lastPositionStr = request.getParameter("lastPosition");

            System.out.println("📥 Received parameters:");
            System.out.println("   courseId: " + courseIdStr);
            System.out.println("   watchPercent: " + watchPercentStr);
            System.out.println("   lastPosition: " + lastPositionStr);

            // Validate parameters
            if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"Missing courseId parameter\"}");
                System.err.println("❌ courseId is null or empty");
                return;
            }

            if (watchPercentStr == null || watchPercentStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"Missing watchPercent parameter\"}");
                System.err.println("❌ watchPercent is null or empty");
                return;
            }

            if (lastPositionStr == null || lastPositionStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"Missing lastPosition parameter\"}");
                System.err.println("❌ lastPosition is null or empty");
                return;
            }

            int courseId = Integer.parseInt(courseIdStr.trim());
            double watchPercent = Double.parseDouble(watchPercentStr.trim());
            int lastPosition = Integer.parseInt(lastPositionStr.trim());

            System.out.println("📊 Updating video progress:");
            System.out.println("   Course: " + courseId);
            System.out.println("   Watch%: " + watchPercent);
            System.out.println("   Position: " + lastPosition + "s");

            ProgressDAO pdao = new ProgressDAO();
            
            // Create progress record if doesn't exist
            ProgressDAO.createIfNotExists(username, courseId);
            System.out.println("✅ Progress record ensured");

            // Update video watch percentage and last position
            pdao.updateVideoWatchProgress(username, courseId, watchPercent, lastPosition);
            System.out.println("✅ Video progress updated in database");

            // If watched >= 90%, mark video as REVIEWED
            boolean isReviewed = false;
            if (watchPercent >= 90.0) {
                pdao.markVideoAsReviewed(username, courseId);
                isReviewed = true;
                System.out.println("✅ Video marked as REVIEWED (90%+ watched)");
            }

            // Get updated progress
            int totalProgress = pdao.Checkprogress(username, courseId);
            String videoStatus = pdao.getVideoStatus(username, courseId);

            System.out.println("📈 Total progress now: " + totalProgress + "%");
            System.out.println("🎥 Video status: " + videoStatus);

            // Build JSON response
            String json = String.format(
                "{\"success\": true, \"watchPercent\": %.2f, \"lastPosition\": %d, " +
                "\"totalProgress\": %d, \"videoStatus\": \"%s\", \"isReviewed\": %b}",
                watchPercent, lastPosition, totalProgress, videoStatus, isReviewed
            );

            System.out.println("✅ Sending success response");
            out.print(json);

        } catch (NumberFormatException e) {
            String errorMsg = "Invalid number format: " + e.getMessage();
            System.err.println("❌ " + errorMsg);
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"" + errorMsg + "\"}");
            
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            System.err.println("❌ Exception: " + errorMsg);
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"" + errorMsg + "\"}");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}*/



package Module2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import Module1.User;
import Module2.ProgressDAO;

@WebServlet("/UpdateVideoProgressServlet")
public class UpdateVideoProgressServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Debug: Print all parameters
        System.out.println("🔔 UpdateVideoProgressServlet called!");
        System.out.println("📝 All parameters:");
        request.getParameterMap().forEach((key, value) -> {
            System.out.println("   " + key + " = " + (value != null && value.length > 0 ? value[0] : "null"));
        });

        HttpSession session = request.getSession(false);
        if (session == null) {
            out.print("{\"success\": false, \"error\": \"No session\"}");
            System.err.println("❌ No session found");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.print("{\"success\": false, \"error\": \"Not logged in\"}");
            System.err.println("❌ User not logged in");
            return;
        }

        String username = user.getUsername();
        System.out.println("👤 User: " + username);

        try {
            // Get parameters - try both ways
            String courseIdStr = request.getParameter("courseId");
            String watchPercentStr = request.getParameter("watchPercent");
            String lastPositionStr = request.getParameter("lastPosition");

            System.out.println("📥 Received parameters:");
            System.out.println("   courseId: " + courseIdStr);
            System.out.println("   watchPercent: " + watchPercentStr);
            System.out.println("   lastPosition: " + lastPositionStr);

            // Validate parameters
            if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"Missing courseId parameter\"}");
                System.err.println("❌ courseId is null or empty");
                return;
            }

            if (watchPercentStr == null || watchPercentStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"Missing watchPercent parameter\"}");
                System.err.println("❌ watchPercent is null or empty");
                return;
            }

            if (lastPositionStr == null || lastPositionStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"Missing lastPosition parameter\"}");
                System.err.println("❌ lastPosition is null or empty");
                return;
            }

            int courseId = Integer.parseInt(courseIdStr.trim());
            double watchPercent = Double.parseDouble(watchPercentStr.trim());
            int lastPosition = Integer.parseInt(lastPositionStr.trim());

            System.out.println("📊 Updating video progress:");
            System.out.println("   Course: " + courseId);
            System.out.println("   Watch%: " + watchPercent);
            System.out.println("   Position: " + lastPosition + "s");

            ProgressDAO pdao = new ProgressDAO();
            
            // Create progress record if doesn't exist
            ProgressDAO.createIfNotExists(username, courseId);
            System.out.println("✅ Progress record ensured");

            // Update video watch percentage and last position
            pdao.updateVideoWatchProgress(username, courseId, watchPercent, lastPosition);
            System.out.println("✅ Video progress updated in database");
            System.out.println("   video_watch_percent = " + watchPercent);
            System.out.println("   video_last_position = " + lastPosition);

            // If watched >= 90%, mark video as REVIEWED
            boolean isReviewed = false;
            String videoStatus = "NOT_STARTED";
            
            if (watchPercent >= 90.0) {
                System.out.println("🎯 Watch percent >= 90%, marking as REVIEWED...");
                pdao.markVideoAsReviewed(username, courseId);
                isReviewed = true;
                videoStatus = "REVIEWED";
                System.out.println("✅ Video marked as REVIEWED (90%+ watched)");
            } else {
                // Get current video status from database
                videoStatus = pdao.getVideoStatus(username, courseId);
                System.out.println("📊 Current video status: " + videoStatus);
            }

            // Get updated progress
            int totalProgress = pdao.Checkprogress(username, courseId);

            System.out.println("📈 Total progress now: " + totalProgress + "%");
            System.out.println("🎥 Video status: " + videoStatus);

            // Build JSON response
            String json = String.format(
                "{\"success\": true, \"watchPercent\": %.2f, \"lastPosition\": %d, " +
                "\"totalProgress\": %d, \"videoStatus\": \"%s\", \"isReviewed\": %b}",
                watchPercent, lastPosition, totalProgress, videoStatus, isReviewed
            );

            System.out.println("✅ Sending success response");
            out.print(json);

        } catch (NumberFormatException e) {
            String errorMsg = "Invalid number format: " + e.getMessage();
            System.err.println("❌ " + errorMsg);
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"" + errorMsg + "\"}");
            
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            System.err.println("❌ Exception: " + errorMsg);
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"" + errorMsg + "\"}");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}