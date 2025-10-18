
 /*


@WebServlet("/QuizSubmitServlet")
public class QuizSubmitServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String level = req.getParameter("level");
        String courseId = req.getParameter("courseId");
        String courseTitle = req.getParameter("title"); // hidden field from quiz.jsp

        Map<String, String[]> params = req.getParameterMap();
        List<String> qids = new ArrayList<>();
        for (String key : params.keySet()) {
            if (key.startsWith("q")) {
                qids.add(key.substring(1));
            }
        }

        int total = qids.size();
        int marks = 0;
        int tabSwitches = 0;
        try { tabSwitches = Integer.parseInt(req.getParameter("tab_switches")); } catch(Exception e){}

        List<Map<String, String>> resultDetails = new ArrayList<>();

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms","root","")) {
            for (String qid : qids) {
                String ans = req.getParameter("q" + qid);

                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT question_text, option_a, option_b, option_c, option_d, correct_option, answer_text FROM question_bank WHERE id=?")) {
                    ps.setInt(1, Integer.parseInt(qid));
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        String correctOpt = rs.getString("correct_option");
                        if (correctOpt != null && correctOpt.equalsIgnoreCase(ans)) {
                            marks++;
                        }

                        Map<String, String> detail = new HashMap<>();
                        detail.put("question", rs.getString("question_text"));
                        detail.put("optA", rs.getString("option_a"));
                        detail.put("optB", rs.getString("option_b"));
                        detail.put("optC", rs.getString("option_c"));
                        detail.put("optD", rs.getString("option_d"));
                        detail.put("correct", correctOpt);
                        detail.put("user", ans != null ? ans : "Not Answered");
                        detail.put("solution", rs.getString("answer_text"));

                        resultDetails.add(detail);
                    }
                    rs.close();
                }
            }

            String username = ((Module1.User)session.getAttribute("user")).getUsername();

            try (PreparedStatement ins = con.prepareStatement(
                    "INSERT INTO quiz_attempts(username, course_id, level, total_questions, score, tab_switches, attempted_at) VALUES(?,?,?,?,?,?,NOW())")) {
                ins.setString(1, username);
                ins.setString(2, courseId);
                ins.setString(3, level.toUpperCase());
                ins.setInt(4, total);
                ins.setInt(5, marks);
                ins.setInt(6, tabSwitches);
                ins.executeUpdate();
            }

            int cid = Integer.parseInt(courseId);

            // --- Calculate quiz progress (ENUM) ---
            boolean attempted = false;
            boolean hardCompleted = false;

            String selectSql = "SELECT level, MAX(score) AS best_score " +
                               "FROM quiz_attempts WHERE username=? AND course_id=? GROUP BY level";

            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setString(1, username);
                ps.setInt(2, cid);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        attempted = true;
                        String lvl = rs.getString("level");
                        int bestScore = rs.getInt("best_score");

                        if ("HARD".equalsIgnoreCase(lvl) && bestScore >= 12) {
                            hardCompleted = true;
                        }
                    }
                }
            }

            // --- Map to ENUM value ---
            String quizStatus;
            if (!attempted) {
                quizStatus = "NOT_STARTED";
            } else if (hardCompleted) {
                quizStatus = "COMPLETED";
            } else {
                quizStatus = "IN_PROGRESS";
            }

            // --- Update quiz_progress (ENUM) ---
            String updateSql = "UPDATE user_course_progress " +
                               "SET quiz_progress=? " +
                               "WHERE username=? AND course_id=?";

            try (PreparedStatement ps2 = con.prepareStatement(updateSql)) {
                ps2.setString(1, quizStatus);
                ps2.setString(2, username);
                ps2.setInt(3, cid);
                ps2.executeUpdate();
            }

            // --- Incremental total_progress update ---
            int currentProgress = 0;
            String getProgressSql = "SELECT total_progress FROM user_course_progress WHERE username=? AND course_id=?";
            try (PreparedStatement ps3 = con.prepareStatement(getProgressSql)) {
                ps3.setString(1, username);
                ps3.setInt(2, cid);
                try (ResultSet rs = ps3.executeQuery()) {
                    if (rs.next()) {
                        currentProgress = rs.getInt("total_progress");
                    }
                }
            }

            int newProgress = currentProgress;
            switch (level.toUpperCase()) {
                
                    case "EASY":
                        if (marks >= 4 && currentProgress < 65) newProgress = 65;
                        break;
                    case "INTERMEDIATE":
                        if (marks >= 9 && currentProgress < 80) newProgress = 80;
                        break;
                    case "HARD":
                        if (marks >= 12 && currentProgress < 100) newProgress = 100;
                        break;
                }

                    
            

            // --- Only update if progress increased ---
            if (newProgress > currentProgress) {
                String updateProgressSql = "UPDATE user_course_progress " +
                                           "SET total_progress=?, " +
                                           "overall_status=CASE WHEN ?=100 THEN 'COMPLETED' ELSE overall_status END " +
                                           "WHERE username=? AND course_id=?";
                try (PreparedStatement ps4 = con.prepareStatement(updateProgressSql)) {
                    ps4.setInt(1, newProgress);
                    ps4.setInt(2, newProgress);
                    ps4.setString(3, username);
                    ps4.setInt(4, cid);
                    ps4.executeUpdate();
                }
            }
            
            
         // === If completed ===
            if (newProgress == 100) {
                int badgeId = -1;

                // 1. Find badge mapped for this course
                String badgeSql = "SELECT badge_id FROM course_badges WHERE course_id=? LIMIT 1";
                try (PreparedStatement ps = con.prepareStatement(badgeSql)) {
                    ps.setInt(1, cid);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) badgeId = rs.getInt("badge_id");
                    }
                }

                // 2. Insert into user_badges if not already awarded
                if (badgeId > 0) {
                    String ubSql = "INSERT IGNORE INTO user_badges(username, course_id, badge_id) VALUES(?,?,?)";
                    try (PreparedStatement ps = con.prepareStatement(ubSql)) {
                        ps.setString(1, username);
                        ps.setInt(2, cid);
                        ps.setInt(3, badgeId);
                        ps.executeUpdate();
                    }
                }
                if (pdfBytes != null) {
                    MimeBodyPart pdfPart = new MimeBodyPart();
                    DataSource source = new ByteArrayDataSource(pdfBytes, "application/pdf");
                    pdfPart.setDataHandler(new DataHandler(source));
                    pdfPart.setFileName("certificate.pdf");
                    multipart.addBodyPart(pdfPart);
                }

                // 3. Generate Certificate PDF
                byte[] pdfBytes = CertificateGenerator.generateCertificate(
                        userObj.getUsername(),
                        userObj.getEmail(),
                        courseTitle != null && !courseTitle.isEmpty() ? courseTitle : courseId,
                        newProgress
                );

                // 4. Send completion mail with badge + certificate
                RegisterServlet.sendCompletionMail(
                        userObj.getEmail(),
                        userObj.getUsername(),
                        courseTitle,
                        pdfBytes,
                        badgeId,
                        con
                );
            }


            if (pdfBytes != null) {
                MimeBodyPart pdfPart = new MimeBodyPart();
                DataSource source = new ByteArrayDataSource(pdfBytes, "application/pdf");
                pdfPart.setDataHandler(new DataHandler(source));
                pdfPart.setFileName("certificate.pdf");
                multipart.addBodyPart(pdfPart);
            }




            // Send result mail
            Module1.User userObj = (Module1.User) session.getAttribute("user");
            RegisterServlet.sendQuizResultMail(
                userObj.getEmail(), 
                userObj.getUsername(), 
                courseTitle != null && !courseTitle.isEmpty() ? courseTitle : courseId, 
                level, marks, total, resultDetails
            );

        } catch (Exception e) {
            e.printStackTrace();
        }
        

        req.setAttribute("score", marks);
        req.setAttribute("total", total);
        req.setAttribute("resultDetails", resultDetails);
        req.getRequestDispatcher("result.jsp").forward(req, resp);
    }
}*
package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import Module1.*;
import Module5.*;

@WebServlet("/QuizSubmitServlet")
public class QuizSubmitServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String level = req.getParameter("level");
        String courseId = req.getParameter("courseId");
        String courseTitle = req.getParameter("title"); // hidden field from quiz.jsp

        Map<String, String[]> params = req.getParameterMap();
        List<String> qids = new ArrayList<>();
        for (String key : params.keySet()) {
            if (key.startsWith("q")) {
                qids.add(key.substring(1));
            }
        }

        int total = qids.size();
        int marks = 0;
        int tabSwitches = 0;
        try { tabSwitches = Integer.parseInt(req.getParameter("tab_switches")); } catch(Exception e){}

        List<Map<String, String>> resultDetails = new ArrayList<>();

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms","root","")) {
            // --- Evaluate answers ---
            for (String qid : qids) {
                String ans = req.getParameter("q" + qid);

                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT question_text, option_a, option_b, option_c, option_d, correct_option, answer_text FROM question_bank WHERE id=?")) {
                    ps.setInt(1, Integer.parseInt(qid));
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        String correctOpt = rs.getString("correct_option");
                        if (correctOpt != null && correctOpt.equalsIgnoreCase(ans)) {
                            marks++;
                        }

                        Map<String, String> detail = new HashMap<>();
                        detail.put("question", rs.getString("question_text"));
                        detail.put("optA", rs.getString("option_a"));
                        detail.put("optB", rs.getString("option_b"));
                        detail.put("optC", rs.getString("option_c"));
                        detail.put("optD", rs.getString("option_d"));
                        detail.put("correct", correctOpt);
                        detail.put("user", ans != null ? ans : "Not Answered");
                        detail.put("solution", rs.getString("answer_text"));

                        resultDetails.add(detail);
                    }
                    rs.close();
                }
            }

            // --- Save quiz attempt ---
            Module1.User userObj = (Module1.User) session.getAttribute("user");
            String username = userObj.getUsername();

            try (PreparedStatement ins = con.prepareStatement(
                    "INSERT INTO quiz_attempts(username, course_id, level, total_questions, score, tab_switches, attempted_at) VALUES(?,?,?,?,?,?,NOW())")) {
                ins.setString(1, username);
                ins.setString(2, courseId);
                ins.setString(3, level.toUpperCase());
                ins.setInt(4, total);
                ins.setInt(5, marks);
                ins.setInt(6, tabSwitches);
                ins.executeUpdate();
            }

            int cid = Integer.parseInt(courseId);

            // --- Calculate quiz progress (ENUM) ---
            boolean attempted = false;
            boolean hardCompleted = false;

            String selectSql = "SELECT level, MAX(score) AS best_score " +
                               "FROM quiz_attempts WHERE username=? AND course_id=? GROUP BY level";

            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setString(1, username);
                ps.setInt(2, cid);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        attempted = true;
                        String lvl = rs.getString("level");
                        int bestScore = rs.getInt("best_score");

                        if ("HARD".equalsIgnoreCase(lvl) && bestScore >= 12) {
                            hardCompleted = true;
                        }
                    }
                }
            }

            String quizStatus;
            if (!attempted) {
                quizStatus = "NOT_STARTED";
            } else if (hardCompleted) {
                quizStatus = "COMPLETED";
            } else {
                quizStatus = "IN_PROGRESS";
            }

            // --- Update quiz_progress (ENUM) ---
            String updateSql = "UPDATE user_course_progress " +
                               "SET quiz_progress=? " +
                               "WHERE username=? AND course_id=?";

            try (PreparedStatement ps2 = con.prepareStatement(updateSql)) {
                ps2.setString(1, quizStatus);
                ps2.setString(2, username);
                ps2.setInt(3, cid);
                ps2.executeUpdate();
            }

            // --- Incremental total_progress update ---
            int currentProgress = 0;
            String getProgressSql = "SELECT total_progress FROM user_course_progress WHERE username=? AND course_id=?";
            try (PreparedStatement ps3 = con.prepareStatement(getProgressSql)) {
                ps3.setString(1, username);
                ps3.setInt(2, cid);
                try (ResultSet rs = ps3.executeQuery()) {
                    if (rs.next()) {
                        currentProgress = rs.getInt("total_progress");
                    }
                }
            }

            int newProgress = currentProgress;
            switch (level.toUpperCase()) {
                case "EASY":
                    if (marks >= 4 && currentProgress < 65) newProgress = 65;
                    break;
                case "INTERMEDIATE":
                    if (marks >= 9 && currentProgress < 80) newProgress = 80;
                    break;
                case "HARD":
                    if (marks >= 12 && currentProgress < 100) newProgress = 100;
                    break;
            }

            if (newProgress > currentProgress) {
                String updateProgressSql = "UPDATE user_course_progress " +
                                           "SET total_progress=?, " +
                                           "overall_status=CASE WHEN ?=100 THEN 'COMPLETED' ELSE overall_status END " +
                                           "WHERE username=? AND course_id=?";
                try (PreparedStatement ps4 = con.prepareStatement(updateProgressSql)) {
                    ps4.setInt(1, newProgress);
                    ps4.setInt(2, newProgress);
                    ps4.setString(3, username);
                    ps4.setInt(4, cid);
                    ps4.executeUpdate();
                }
            }

            // === If course completed ===
            if (newProgress == 100) {
                int badgeId = -1;

                // 1. Find badge mapped for this course
                String badgeSql = "SELECT badge_id FROM course_badges WHERE course_id=? LIMIT 1";
                try (PreparedStatement ps = con.prepareStatement(badgeSql)) {
                    ps.setInt(1, cid);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) badgeId = rs.getInt("badge_id");
                    }
                }

                // 2. Insert into user_badges if not already awarded
                if (badgeId > 0) {
                    String ubSql = "INSERT IGNORE INTO user_badges(username, course_id, badge_id) VALUES(?,?,?)";
                    try (PreparedStatement ps = con.prepareStatement(ubSql)) {
                        ps.setString(1, username);
                        ps.setInt(2, cid);
                        ps.setInt(3, badgeId);
                        ps.executeUpdate();
                    }
                }

                // 3. Generate Certificate PDF (must return byte[])
                byte[] pdfBytes = CertificateGenerator.generateCertificate(
                        userObj.getUsername(),
                        courseTitle != null && !courseTitle.isEmpty() ? courseTitle : courseId,
                        newProgress
                );

                // 4. Send completion mail with badge + certificate
                RegisterServlet.sendCompletionMail(
                        userObj.getEmail(),
                        userObj.getUsername(),
                        courseTitle,
                        pdfBytes,
                        badgeId,
                        con
                );
            }

            // --- Always send quiz result mail ---
            RegisterServlet.sendQuizResultMail(
                userObj.getEmail(),
                userObj.getUsername(),
                courseTitle != null && !courseTitle.isEmpty() ? courseTitle : courseId,
                level, marks, total, resultDetails
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("score", marks);
        req.setAttribute("total", total);
        req.setAttribute("resultDetails", resultDetails);
        req.getRequestDispatcher("result.jsp").forward(req, resp);
    }
}
*
package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;

import Module1.*;
import Module5.*;

@WebServlet("/QuizSubmitServlet")
public class QuizSubmitServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String level = req.getParameter("level");
        String courseId = req.getParameter("courseId");
        String courseTitle = req.getParameter("title"); // hidden field from quiz.jsp

        Map<String, String[]> params = req.getParameterMap();
        List<String> qids = new ArrayList<>();
        for (String key : params.keySet()) {
            if (key.startsWith("q")) qids.add(key.substring(1));
        }

        int total = qids.size();
        int marks = 0;
        int tabSwitches = 0;
        try { tabSwitches = Integer.parseInt(req.getParameter("tab_switches")); } catch(Exception e){}

        List<Map<String, String>> resultDetails = new ArrayList<>();

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms","root","")) {

            // === Evaluate answers ===
            for (String qid : qids) {
                String ans = req.getParameter("q" + qid);
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT question_text, option_a, option_b, option_c, option_d, correct_option, answer_text FROM question_bank WHERE id=?")) {
                    ps.setInt(1, Integer.parseInt(qid));
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        String correctOpt = rs.getString("correct_option");
                        if (correctOpt != null && correctOpt.equalsIgnoreCase(ans)) marks++;

                        Map<String, String> detail = new HashMap<>();
                        detail.put("question", rs.getString("question_text"));
                        detail.put("optA", rs.getString("option_a"));
                        detail.put("optB", rs.getString("option_b"));
                        detail.put("optC", rs.getString("option_c"));
                        detail.put("optD", rs.getString("option_d"));
                        detail.put("correct", correctOpt);
                        detail.put("user", ans != null ? ans : "Not Answered");
                        detail.put("solution", rs.getString("answer_text"));
                        resultDetails.add(detail);
                    }
                    rs.close();
                }
            }

            // === Save attempt ===
            Module1.User userObj = (Module1.User) session.getAttribute("user");
            String username = userObj.getUsername();

            try (PreparedStatement ins = con.prepareStatement(
                    "INSERT INTO quiz_attempts(username, course_id, level, total_questions, score, tab_switches, attempted_at) VALUES(?,?,?,?,?,?,NOW())")) {
                ins.setString(1, username);
                ins.setString(2, courseId);
                ins.setString(3, level.toUpperCase());
                ins.setInt(4, total);
                ins.setInt(5, marks);
                ins.setInt(6, tabSwitches);
                ins.executeUpdate();
            }

            int cid = Integer.parseInt(courseId);

            // (progress update logic … same as yours …)

            // === If course completed ===
            int newProgress = 100; // example
            if (newProgress == 100) {
                int badgeId = -1;
                String badgeSql = "SELECT badge_id FROM course_badges WHERE course_id=? LIMIT 1";
                try (PreparedStatement ps = con.prepareStatement(badgeSql)) {
                    ps.setInt(1, cid);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) badgeId = rs.getInt("badge_id");
                    }
                }

                if (badgeId > 0) {
                    String ubSql = "INSERT IGNORE INTO user_badges(username, course_id, badge_id) VALUES(?,?,?)";
                    try (PreparedStatement ps = con.prepareStatement(ubSql)) {
                        ps.setString(1, username);
                        ps.setInt(2, cid);
                        ps.setInt(3, badgeId);
                        ps.executeUpdate();
                    }
                }

                // Certificate PDF (2 args only!)
                byte[] pdfBytes = CertificateGenerator.generateCertificate(
                        userObj.getUsername(),
                        (courseTitle != null && !courseTitle.isEmpty()) ? courseTitle : courseId
                );

                // Send completion mail
                RegisterServlet.sendCompletionMail(
                        userObj.getEmail(),
                        userObj.getUsername(),
                        courseTitle,
                        pdfBytes,
                        badgeId,
                        con
                );
            }

            RegisterServlet.sendQuizResultMail(
                userObj.getEmail(),
                userObj.getUsername(),
                courseTitle,
                level, marks, total, resultDetails
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("score", marks);
        req.setAttribute("total", total);
        req.setAttribute("resultDetails", resultDetails);
        req.getRequestDispatcher("result.jsp").forward(req, resp);
    }
}

*
package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import Module1.*;
import Module5.*;

@WebServlet("/QuizSubmitServlet") 
public class QuizSubmitServlet extends HttpServlet {
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { 
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			resp.sendRedirect("login.jsp");
			return; 
			}
		String level = req.getParameter("level"); 
		String courseId = req.getParameter("courseId"); 
		String courseTitle = req.getParameter("title"); // hidden field from quiz.jsp
		Map<String, String[]> params = req.getParameterMap();
		
		
		
		
		
		List<String> qids = new ArrayList<>(); 
		for (String key : params.keySet())
		{
			if (key.startsWith("q")) {
			qids.add(key.substring(1)); 
			}
		} 
	//	int total = qids.size(); 
	//	int marks = 0;
	//	int tabSwitches = 0;
	//	try { 
	//		tabSwitches = Integer.parseInt(req.getParameter("tab_switches"));
	//		} catch(Exception e)
	//	{}
		
		
		
		
		
		//changing for correct result 
		
		List<Map<String, String>> resultDetails = new ArrayList<>();
		try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "")) {

		    // ✅ Get all question IDs shown in quiz (sent as hidden input or session)
		    String[] questionIds = req.getParameterValues("questionIds"); 
		    // If not sent, fall back to deriving from submitted keys (not recommended)
		    if (questionIds == null || questionIds.length == 0) {
		        Set<String> keys = req.getParameterMap().keySet();
		        List<String> qList = new ArrayList<>();
		        for (String key : keys) {
		            if (key.startsWith("q")) {
		                qList.add(key.substring(1));
		            }
		        }
		        questionIds = qList.toArray(new String[0]);
		    }

		    int total = questionIds.length;
		    int marks = 0;
	    int tabSwitches = 0;
		    try {
		        tabSwitches = Integer.parseInt(req.getParameter("tab_switches"));
		    } catch (Exception e) {}

		    for (String qid : questionIds) {
		        String userAns = req.getParameter("q" + qid); // null if not answered

		        try (PreparedStatement ps = con.prepareStatement(
		                "SELECT id, question_text, option_a, option_b, option_c, option_d, correct_option, answer_text FROM question_bank WHERE id=?")) {
		            ps.setInt(1, Integer.parseInt(qid));
		            ResultSet rs = ps.executeQuery();
		            if (rs.next()) {
		                String correctOpt = rs.getString("correct_option");
		                Map<String, String> detail = new HashMap<>();

		                detail.put("id", qid);
		                detail.put("question", rs.getString("question_text"));
		                detail.put("optA", rs.getString("option_a"));
		                detail.put("optB", rs.getString("option_b"));
		                detail.put("optC", rs.getString("option_c"));
		                detail.put("optD", rs.getString("option_d"));
		                detail.put("correct", correctOpt);
		                detail.put("solution", rs.getString("answer_text"));

		                // ✅ Handle not attempted
		                if (userAns == null || userAns.trim().isEmpty()) {
		                    detail.put("user", "Not Attempted");
		                } else {
		                    detail.put("user", userAns);
		                    if (userAns.equalsIgnoreCase(correctOpt)) {
		                        marks++;
		                    }
		                }
		                resultDetails.add(detail);
		            }
		        }
		    }

		    // ✅ Continue your insert and progress update logic as before
		    String username = ((Module1.User) session.getAttribute("user")).getUsername();
		    try (PreparedStatement ins = con.prepareStatement(
		            "INSERT INTO quiz_attempts(username, course_id, level, total_questions, score, tab_switches, attempted_at) VALUES(?,?,?,?,?,?,NOW())")) {
		        ins.setString(1, username);
		        ins.setString(2, courseId);
		        ins.setString(3, level.toUpperCase());
		        ins.setInt(4, total);
		        ins.setInt(5, marks);
		        ins.setInt(6, tabSwitches);
		        ins.executeUpdate();
		    }

		    // Keep all your progress update, badge, and certificate logic same here ✅

		    req.setAttribute("score", marks);
		    req.setAttribute("total", total);
		    req.setAttribute("resultDetails", resultDetails);
		    req.setAttribute("quizType", "real");

		    if (session != null) {
		        session.removeAttribute("questions");
		        session.removeAttribute("startTime");
		        session.removeAttribute("quizStarted");
		    }

		    req.getRequestDispatcher("result.jsp").forward(req, resp);

		} catch (Exception e) {
		    e.printStackTrace();
		}
	}
//	}

	/*	List<Map<String, String>> resultDetails = new ArrayList<>(); 
		try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms","root",""))
		{ for (String qid : qids) {
			String ans = req.getParameter("q" + qid);
			try (PreparedStatement ps = con.prepareStatement( "SELECT question_text, option_a, option_b, option_c, option_d, correct_option, answer_text FROM question_bank WHERE id=?")) 
			{ ps.setInt(1, Integer.parseInt(qid)); ResultSet rs = ps.executeQuery();
			if (rs.next()) { 
				String correctOpt = rs.getString("correct_option"); 
				if (correctOpt != null && correctOpt.equalsIgnoreCase(ans)) {
					marks++;
					}
				Map<String, String> detail = new HashMap<>(); 
				
				detail.put("question", rs.getString("question_text")); 
				detail.put("optA", rs.getString("option_a"));
				detail.put("optB", rs.getString("option_b"));
				detail.put("optC", rs.getString("option_c")); 
				detail.put("optD", rs.getString("option_d")); 
				detail.put("correct", correctOpt); 
				detail.put("user", ans != null ? ans : "Not Answered");
				detail.put("solution", rs.getString("answer_text"));
				resultDetails.add(detail); 
				}
			rs.close();
			}
			}
		String username = ((Module1.User)session.getAttribute("user")).getUsername();
		try (PreparedStatement ins = con.prepareStatement( "INSERT INTO quiz_attempts(username, course_id, level, total_questions, score, tab_switches, attempted_at) VALUES(?,?,?,?,?,?,NOW())")) {
			ins.setString(1, username);
			ins.setString(2, courseId);
			ins.setString(3, level.toUpperCase()); 
			ins.setInt(4, total); 
			ins.setInt(5, marks); 
			ins.setInt(6, tabSwitches); 
			ins.executeUpdate();
			}
		// Set completion flag to prevent back navigation
		session.setAttribute("quiz_completed_" + courseId + "_" + level, true);
		
		
		int cid = Integer.parseInt(courseId); // --- Calculate quiz progress (ENUM) ---
			boolean attempted = false;
			boolean hardCompleted = false; 
			String selectSql = "SELECT level, MAX(score) AS best_score " + "FROM quiz_attempts WHERE username=? AND course_id=? GROUP BY level";
			try (PreparedStatement ps = con.prepareStatement(selectSql)) {
				ps.setString(1, username); ps.setInt(2, cid);
				try (ResultSet rs = ps.executeQuery()) { 
					while (rs.next()) { 
						attempted = true;
						String lvl = rs.getString("level");
						int bestScore = rs.getInt("best_score"); 
						if ("HARD".equalsIgnoreCase(lvl) && bestScore >= 12) { 
							hardCompleted = true; } } } } // --- Map to ENUM value ---
			String quizStatus;
			if (!attempted) { quizStatus = "NOT_STARTED"; }
			else if (hardCompleted) { quizStatus = "COMPLETED"; } else
			{ quizStatus = "IN_PROGRESS"; } // --- Update quiz_progress (ENUM) ---
			String updateSql = "UPDATE user_course_progress " + "SET quiz_progress=? " + "WHERE username=? AND course_id=?";
			try (PreparedStatement ps2 = con.prepareStatement(updateSql)) {
				ps2.setString(1, quizStatus);
				ps2.setString(2, username);
				ps2.setInt(3, cid); ps2.executeUpdate(); } // --- Incremental total_progress update --- 
			int currentProgress = 0;
			String getProgressSql = "SELECT total_progress FROM user_course_progress WHERE username=? AND course_id=?";
			try (PreparedStatement ps3 = con.prepareStatement(getProgressSql)) {
				ps3.setString(1, username);
				ps3.setInt(2, cid);
				try (ResultSet rs = ps3.executeQuery()) 
				{ if (rs.next()) { currentProgress = rs.getInt("total_progress"); } } } 
			int newProgress = currentProgress; 
			
			switch (level.toUpperCase()) { 
			case "EASY": if (marks >= 4 && currentProgress < 65) newProgress = 65; break; 
			case "INTERMEDIATE": if (marks >= 9 && currentProgress < 80) newProgress = 80; break; 
			case "HARD": if (marks >= 12 && currentProgress < 100) newProgress = 100; break; } // --- Only update if progress increased ---
			if (newProgress > currentProgress) { String updateProgressSql = "UPDATE user_course_progress " + "SET total_progress=?, " + "overall_status=CASE WHEN ?=100 THEN 'COMPLETED' ELSE overall_status END " + "WHERE username=? AND course_id=?";
			try (PreparedStatement ps4 = con.prepareStatement(updateProgressSql)) {
				ps4.setInt(1, newProgress)
				; ps4.setInt(2, newProgress);
				ps4.setString(3, username);
				ps4.setInt(4, cid); ps4.executeUpdate(); } } 
			
			
			// --- Award badge if course is fully completed (100%) ---
			if (newProgress == 100 && currentProgress < 100) {
			    // Check if user already has a badge for this course
			    String checkBadgeSql = "SELECT 1 FROM user_badges WHERE username=? AND course_id=? LIMIT 1";
			    try (PreparedStatement psCheck = con.prepareStatement(checkBadgeSql)) {
			        psCheck.setString(1, username);
			        psCheck.setInt(2, cid);
			        try (ResultSet rs = psCheck.executeQuery()) {
			            if (!rs.next()) {
			                // Get badge info from course_badges + badges
			                String fetchBadgeSql =
			                    "SELECT b.badge_id, b.badge_name, b.description, b.image_path " +
			                    "FROM course_badges cb " +
			                    "JOIN badges b ON cb.badge_id = b.badge_id " +
			                    "WHERE cb.course_id=? LIMIT 1";
			                try (PreparedStatement psBadge = con.prepareStatement(fetchBadgeSql)) {
			                    psBadge.setInt(1, cid);
			                    try (ResultSet rsBadge = psBadge.executeQuery()) {
			                        if (rsBadge.next()) {
			                            int badgeId = rsBadge.getInt("badge_id");
			                            String badgeName = rsBadge.getString("badge_name");
			                            String badgeDesc = rsBadge.getString("description");
			                            String badgeImage = rsBadge.getString("image_path");

			                            // Insert into user_badges
			                            String insertUserBadgeSql =
			                                "INSERT INTO user_badges(username, course_id, badge_id, awarded_at) " +
			                                "VALUES(?,?,?,NOW())";
			                            try (PreparedStatement psInsert = con.prepareStatement(insertUserBadgeSql)) {
			                                psInsert.setString(1, username);
			                                psInsert.setInt(2, cid);
			                                psInsert.setInt(3, badgeId);
			                                psInsert.executeUpdate();
			                            }

			                            
			                            
			                            Module1.User userObj = (Module1.User) session.getAttribute("user");
			                            // Send badge mail (extend your RegisterServlet or create a helper)
			                            RegisterServlet.sendBadgeMail(
			                                userObj.getEmail(),
			                                userObj.getUsername(),
			                                courseTitle != null && !courseTitle.isEmpty() ? courseTitle : courseId,
			                                badgeName,
			                                badgeDesc,
			                                badgeImage
			                            );
			                        }
			                    }
			                }
			            }
			        }
			    }
			}

			if (newProgress == 100 && currentProgress < 100) {
			    try {
			        // If courseTitle is null/empty, fallback to "Course <id>"
			        String courseLabel = (courseTitle != null && !courseTitle.trim().isEmpty())
			                ? courseTitle
			                : "Course " + cid;

			        // Generate + save certificate under WebContent/certs/ 
			        // and insert record into user_certificates
			        String savedRelativePath = Module5.CertificateService.issueCertificate(
			                username,
			                cid,
			                courseLabel,
			                getServletContext()
			        );

			        // Debug log (can remove later)
			        System.out.println("✅ Certificate created for " + username + " at: " + savedRelativePath);

			    } catch (Exception e) {
			        e.printStackTrace();
			    }
			}

		/*	if (newProgress == 100 && currentProgress < 100) {
			    try {
			        String courseLabel = (courseTitle != null && !courseTitle.isEmpty())
			                ? courseTitle
			                : "Course " + cid;

			        Module5.CertificateService.issueCertificate(
			                username,
			                cid,
			                courseLabel,
			                getServletContext()
			        );
			    } catch (Exception e) {
			        e.printStackTrace();
			    }
			}*

			Module1.User userObj = (Module1.User) session.getAttribute("user");
RegisterServlet.sendQuizResultMail( userObj.getEmail(), userObj.getUsername(), courseTitle != null && !courseTitle.isEmpty() ? courseTitle : courseId, level, marks, total, resultDetails );
			} 
		catch (Exception e) { e.printStackTrace(); } 
		
		req.setAttribute("score", marks); req.setAttribute("total", total);
		req.setAttribute("resultDetails", resultDetails); 
		//req.setAttribute("quiz_" + courseId + "_" + level + "_completed", true);
		//HttpSession session = request.getSession(false);
	//	if (session != null) {
		//    session.removeAttribute("quizQuestions");
		  //  session.setAttribute("quizCompleted", true);
		//}
		
		req.setAttribute("quizType", "real");
		//req.setAttribute("resultDetails", resultDetailsList);


		
		
		
	//	if (session != null) {
	//	    session.removeAttribute("questions"); // if you stored them
	//	    session.removeAttribute("startTime"); 
	//	    session.removeAttribute("quizStarted");
	//	}

		req.getRequestDispatcher("result.jsp").forward(req, resp); 
		} 
		
	}  */








package Module3;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import Module1.*;
import Module5.*;

@WebServlet("/QuizSubmitServlet")
public class QuizSubmitServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String level = req.getParameter("level");
        String courseId = req.getParameter("courseId");
        String courseTitle = req.getParameter("title"); // hidden field from quiz.jsp
        int tabSwitches = 0;

        try {
            tabSwitches = Integer.parseInt(req.getParameter("tab_switches"));
        } catch (Exception e) {
            tabSwitches = 0;
        }

        List<Map<String, String>> resultDetails = new ArrayList<>();

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "")) {

            // ✅ Retrieve question IDs
            String[] questionIds = req.getParameterValues("questionIds");
            if (questionIds == null || questionIds.length == 0) {
                Set<String> keys = req.getParameterMap().keySet();
                List<String> qList = new ArrayList<>();
                for (String key : keys) {
                    if (key.startsWith("q")) {
                        qList.add(key.substring(1));
                    }
                }
                questionIds = qList.toArray(new String[0]);
            }

            int total = questionIds.length;
            int marks = 0;

            for (String qid : questionIds) {
                String userAns = req.getParameter("q" + qid); // null if not answered

                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT id, question_text, option_a, option_b, option_c, option_d, correct_option, answer_text FROM question_bank WHERE id=?")) {
                    ps.setInt(1, Integer.parseInt(qid));
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String correctOpt = rs.getString("correct_option");

                        Map<String, String> detail = new HashMap<>();
                        detail.put("id", qid);
                        detail.put("question", rs.getString("question_text"));
                        detail.put("optA", rs.getString("option_a"));
                        detail.put("optB", rs.getString("option_b"));
                        detail.put("optC", rs.getString("option_c"));
                        detail.put("optD", rs.getString("option_d"));
                        detail.put("correct", correctOpt);
                        detail.put("solution", rs.getString("answer_text"));

                        if (userAns == null || userAns.trim().isEmpty()) {
                            detail.put("user", "Not Attempted");
                        } else {
                            detail.put("user", userAns);
                            if (userAns.equalsIgnoreCase(correctOpt)) {
                                marks++;
                            }
                        }
                        resultDetails.add(detail);
                    }
                }
            }

            // ✅ Record quiz attempt
            String username = ((Module1.User) session.getAttribute("user")).getUsername();
            try (PreparedStatement ins = con.prepareStatement(
                    "INSERT INTO quiz_attempts(username, course_id, level, total_questions, score, tab_switches, attempted_at) VALUES(?,?,?,?,?,?,NOW())")) {
                ins.setString(1, username);
                ins.setString(2, courseId);
                ins.setString(3, level.toUpperCase());
                ins.setInt(4, total);
                ins.setInt(5, marks);
                ins.setInt(6, tabSwitches);
                ins.executeUpdate();
            }

            // ✅ Mark completion to prevent back navigation
            session.setAttribute("quiz_completed_" + courseId + "_" + level, true);

            // === QUIZ PROGRESS UPDATE ===
            int cid = Integer.parseInt(courseId);
            boolean attempted = false;
            boolean hardCompleted = false;

            String selectSql = """
                SELECT level, MAX(score) AS best_score 
                FROM quiz_attempts WHERE username=? AND course_id=? GROUP BY level
            """;
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setString(1, username);
                ps.setInt(2, cid);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        attempted = true;
                        String lvl = rs.getString("level");
                        int bestScore = rs.getInt("best_score");
                        if ("HARD".equalsIgnoreCase(lvl) && bestScore >= 12) {
                            hardCompleted = true;
                        }
                    }
                }
            }

            String quizStatus;
            if (!attempted) quizStatus = "NOT_STARTED";
            else if (hardCompleted) quizStatus = "COMPLETED";
            else quizStatus = "IN_PROGRESS";

            String updateSql = "UPDATE user_course_progress SET quiz_progress=? WHERE username=? AND course_id=?";
            try (PreparedStatement ps2 = con.prepareStatement(updateSql)) {
                ps2.setString(1, quizStatus);
                ps2.setString(2, username);
                ps2.setInt(3, cid);
                ps2.executeUpdate();
            }

            // === TOTAL PROGRESS UPDATE ===
            int currentProgress = 0;
            String getProgressSql = "SELECT total_progress FROM user_course_progress WHERE username=? AND course_id=?";
            try (PreparedStatement ps3 = con.prepareStatement(getProgressSql)) {
                ps3.setString(1, username);
                ps3.setInt(2, cid);
                try (ResultSet rs = ps3.executeQuery()) {
                    if (rs.next()) {
                        currentProgress = rs.getInt("total_progress");
                    }
                }
            }

            int newProgress = currentProgress;
            switch (level.toUpperCase()) {
                case "EASY":
                    if (marks >= 4 && currentProgress < 65) newProgress = 65;
                    break;
                case "INTERMEDIATE":
                    if (marks >= 9 && currentProgress < 80) newProgress = 80;
                    break;
                case "HARD":
                    if (marks >= 12 && currentProgress < 100) newProgress = 100;
                    break;
            }

            if (newProgress > currentProgress) {
                String updateProgressSql = """
                    UPDATE user_course_progress
                    SET total_progress=?, 
                        overall_status=CASE WHEN ?=100 THEN 'COMPLETED' ELSE overall_status END
                    WHERE username=? AND course_id=?
                """;
                try (PreparedStatement ps4 = con.prepareStatement(updateProgressSql)) {
                    ps4.setInt(1, newProgress);
                    ps4.setInt(2, newProgress);
                    ps4.setString(3, username);
                    ps4.setInt(4, cid);
                    ps4.executeUpdate();
                }
            }

            // === BADGE ISSUE ===
            if (newProgress == 100 && currentProgress < 100) {
                String checkBadgeSql = "SELECT 1 FROM user_badges WHERE username=? AND course_id=? LIMIT 1";
                try (PreparedStatement psCheck = con.prepareStatement(checkBadgeSql)) {
                    psCheck.setString(1, username);
                    psCheck.setInt(2, cid);
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (!rs.next()) {
                            String fetchBadgeSql = """
                                SELECT b.badge_id, b.badge_name, b.description, b.image_path 
                                FROM course_badges cb 
                                JOIN badges b ON cb.badge_id = b.badge_id 
                                WHERE cb.course_id=? LIMIT 1
                            """;
                            try (PreparedStatement psBadge = con.prepareStatement(fetchBadgeSql)) {
                                psBadge.setInt(1, cid);
                                try (ResultSet rsBadge = psBadge.executeQuery()) {
                                    if (rsBadge.next()) {
                                        int badgeId = rsBadge.getInt("badge_id");
                                        String badgeName = rsBadge.getString("badge_name");
                                        String badgeDesc = rsBadge.getString("description");
                                        String badgeImage = rsBadge.getString("image_path");

                                        try (PreparedStatement psInsert = con.prepareStatement(
                                                "INSERT INTO user_badges(username, course_id, badge_id, awarded_at) VALUES(?,?,?,NOW())")) {
                                            psInsert.setString(1, username);
                                            psInsert.setInt(2, cid);
                                            psInsert.setInt(3, badgeId);
                                            psInsert.executeUpdate();
                                        }

                                        // Send badge mail
                                        Module1.User userObj = (Module1.User) session.getAttribute("user");
                                        RegisterServlet.sendBadgeMail(
                                                userObj.getEmail(),
                                                userObj.getUsername(),
                                                courseTitle != null && !courseTitle.isEmpty() ? courseTitle : courseId,
                                                badgeName,
                                                badgeDesc,
                                                badgeImage
                                        );
                                    }
                                }
                            }
                        }
                    }
                }

                // === CERTIFICATE ISSUE ===
                try {
                    String courseLabel = (courseTitle != null && !courseTitle.trim().isEmpty())
                            ? courseTitle
                            : "Course " + cid;

                    String savedRelativePath = Module5.CertificateService.issueCertificate(
                            username,
                            cid,
                            courseLabel,
                            getServletContext()
                    );

                    System.out.println("✅ Certificate created for " + username + " at: " + savedRelativePath);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // === SEND QUIZ RESULT MAIL ===
            Module1.User userObj = (Module1.User) session.getAttribute("user");
            RegisterServlet.sendQuizResultMail(
                    userObj.getEmail(),
                    userObj.getUsername(),
                    courseTitle != null && !courseTitle.isEmpty() ? courseTitle : courseId,
                    level,
                    marks,
                    total,
                    resultDetails
            );

            // === Set attributes for result.jsp ===
            req.setAttribute("score", marks);
            req.setAttribute("total", total);
            req.setAttribute("resultDetails", resultDetails);
            req.setAttribute("quizType", "real");

            // Cleanup session quiz data
            session.removeAttribute("questions");
            session.removeAttribute("startTime");
            session.removeAttribute("quizStarted");

            req.getRequestDispatcher("result.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


