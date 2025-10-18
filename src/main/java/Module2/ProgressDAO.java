/*package Module2;

import Module1.DbConnection;
import Module4.UserCourseProgress;

import java.sql.*;

public class ProgressDAO {

    public UserCourseProgress getProgress(String username, int courseId) throws Exception {
        String sql = "SELECT * FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public void upsertBlankIfMissing(String username, int courseId) throws Exception {
        String sql = "INSERT INTO user_course_progress (username, course_id) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE username = VALUES(username)";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ps.executeUpdate();
        }
    }

    // Insert a log entry and update aggregates
    public void logEvent(String username, int courseId, String activity, int value) throws Exception {
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            // ensure row exists
            upsertBlankIfMissing(username, courseId);

            // 1) Insert log
            String ins = "INSERT INTO progress_logs (username, course_id, activity_type, progress_value) VALUES (?,?,?,?)";
            try (PreparedStatement ps = con.prepareStatement(ins)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                ps.setString(3, activity);
                ps.setInt(4, value);
                ps.executeUpdate();
            }

            // 2) Update aggregates
            switch (activity) {
                case "DOC":
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE user_course_progress SET doc_progress = GREATEST(doc_progress, ?) WHERE username=? AND course_id=?")) {
                        ps.setInt(1, value);
                        ps.setString(2, username);
                        ps.setInt(3, courseId);
                        ps.executeUpdate();
                    }
                    break;
                case "VIDEO":
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE user_course_progress SET video_progress = GREATEST(video_progress, ?) WHERE username=? AND course_id=?")) {
                        ps.setInt(1, value);
                        ps.setString(2, username);
                        ps.setInt(3, courseId);
                        ps.executeUpdate();
                    }
                    break;
                case "AI":
                    // convert numeric to enum and escalate
                    escalateAI(con, username, courseId, value);
                    break;
                case "QUIZ":
                    escalateQuiz(con, username, courseId, value);
                    break;
                case "TIME":
                    // add seconds to time_spent
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE user_course_progress SET time_spent = time_spent + ? WHERE username=? AND course_id=?")) {
                        ps.setLong(1, Math.max(0, value));
                        ps.setString(2, username);
                        ps.setInt(3, courseId);
                        ps.executeUpdate();
                    }
                    break;
            }

            // 3) Recompute overall status
            recomputeOverall(con, username, courseId);

            con.commit();
        } catch (Exception e) {
            throw e;
        }
    }

    private void escalateAI(Connection con, String u, int c, int value) throws SQLException {
        // value expected numeric (0,50,100) or treat as percent
        String target = (value >= 100) ? "COMPLETED" : (value >= 50 ? "IN_PROGRESS" : "NOT_STARTED");
        // we will only increase (never downgrade)
        String sql = "UPDATE user_course_progress SET ai_check_progress = " +
                     "CASE WHEN ai_check_progress='COMPLETED' THEN 'COMPLETED' " +
                     "WHEN ai_check_progress='IN_PROGRESS' AND ? < 100 THEN 'IN_PROGRESS' " +
                     "ELSE ? END WHERE username=? AND course_id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, value);
            ps.setString(2, target);
            ps.setString(3, u);
            ps.setInt(4, c);
            ps.executeUpdate();
        }
    }

    private void escalateQuiz(Connection con, String u, int c, int value) throws SQLException {
        // value expected numeric (33,66,100)
        // read current
        String cur = null;
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT quiz_progress FROM user_course_progress WHERE username=? AND course_id=?")) {
            ps.setString(1, u);
            ps.setInt(2, c);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) cur = rs.getString(1);
            }
        }
        int curN = quizToNumeric(cur == null ? "NOT_STARTED" : cur);
        int newN = Math.max(curN, value);
        String target = (newN >= 100) ? "FULL_COMPLETED"
                : (newN >= 66) ? "INTERMEDIATE_COMPLETED"
                : (newN >= 33) ? "EASY_COMPLETED" : "NOT_STARTED";
        try (PreparedStatement ps = con.prepareStatement(
                "UPDATE user_course_progress SET quiz_progress=? WHERE username=? AND course_id=?")) {
            ps.setString(1, target);
            ps.setString(2, u);
            ps.setInt(3, c);
            ps.executeUpdate();
        }
    }

    private int aiToNumeric(String ai) {
        if ("COMPLETED".equals(ai)) return 100;
        if ("IN_PROGRESS".equals(ai)) return 50;
        return 0;
    }

    private int quizToNumeric(String q) {
        if (q == null) return 0;
        switch (q) {
            case "FULL_COMPLETED":
            case "HARD_COMPLETED": return 100;
            case "INTERMEDIATE_COMPLETED": return 66;
            case "EASY_COMPLETED": return 33;
            default: return 0;
        }
    }

    private void recomputeOverall(Connection con, String u, int c) throws SQLException {
        String q = "SELECT doc_progress, video_progress, ai_check_progress, quiz_progress FROM user_course_progress WHERE username=? AND course_id=?";
        int doc = 0, vid = 0, aiN = 0, qN = 0;
        try (PreparedStatement ps = con.prepareStatement(q)) {
            ps.setString(1, u);
            ps.setInt(2, c);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    doc = rs.getInt("doc_progress");
                    vid = rs.getInt("video_progress");
                    aiN = aiToNumeric(rs.getString("ai_check_progress"));
                    qN = quizToNumeric(rs.getString("quiz_progress"));
                }
            }
        }
        int overallPercent = Math.round(0.25f*doc + 0.25f*vid + 0.10f*aiN + 0.40f*qN);
        String status = (overallPercent >= 100) ? "COMPLETED" : (overallPercent <= 0 ? "NOT_STARTED" : "IN_PROGRESS");

        // update overall_status (and last_updated)
        try (PreparedStatement ps = con.prepareStatement(
                "UPDATE user_course_progress SET overall_status=?, last_updated=CURRENT_TIMESTAMP WHERE username=? AND course_id=?")) {
            ps.setString(1, status);
            ps.setString(2, u);
            ps.setInt(3, c);
            ps.executeUpdate();
        }
    }

    public boolean updateProgressFields(String username, int courseId,
                                        Integer doc, Integer vid,
                                        String aiEnum, String quizEnum,
                                        String overallEnum) throws Exception {
        StringBuilder sb = new StringBuilder("UPDATE user_course_progress SET ");
        boolean first = true;

        if (doc != null) { sb.append("doc_progress=?"); first=false; }
        if (vid != null) { sb.append(first?"":" ,").append("video_progress=?"); first=false; }
        if (aiEnum != null){ sb.append(first?"":" ,").append("ai_check_progress=?"); first=false; }
        if (quizEnum != null){ sb.append(first?"":" ,").append("quiz_progress=?"); first=false; }
        if (overallEnum != null){ sb.append(first?"":" ,").append("overall_status=?"); first=false; }
        sb.append(first?"":" ,").append("last_updated=CURRENT_TIMESTAMP ");
        sb.append("WHERE username=? AND course_id=?");

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {
            int i=1;
            if (doc != null) ps.setInt(i++, clamp(doc));
            if (vid != null) ps.setInt(i++, clamp(vid));
            if (aiEnum != null) ps.setString(i++, aiEnum);
            if (quizEnum != null) ps.setString(i++, quizEnum);
            if (overallEnum != null) ps.setString(i++, overallEnum);
            ps.setString(i++, username);
            ps.setInt(i, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean addTimeSpent(String username, int courseId, long seconds) throws Exception {
        String sql = "UPDATE user_course_progress SET time_spent = time_spent + ?, last_updated=CURRENT_TIMESTAMP WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, Math.max(0, seconds));
            ps.setString(2, username);
            ps.setInt(3, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    private int clamp(int v) { return Math.max(0, Math.min(100, v)); }

    private UserCourseProgress map(ResultSet rs) throws SQLException {
        UserCourseProgress p = new UserCourseProgress();
        p.setId(rs.getInt("id"));
        p.setUsername(rs.getString("username"));
        p.setCourseId(rs.getInt("course_id"));
        p.setDocProgress(rs.getInt("doc_progress"));
        p.setVideoProgress(rs.getInt("video_progress"));
        p.setAiCheckProgress(rs.getString("ai_check_progress"));
        p.setQuizProgress(rs.getString("quiz_progress"));
        p.setOverallStatus(rs.getString("overall_status"));
        p.setTimeSpent(rs.getLong("time_spent"));
        p.setLastUpdated(rs.getTimestamp("last_updated"));
        return p;
    }
}

  
  
  
  
  
  
  
package Module2;

import Module1.DbConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class ProgressDAO {

    // ensure row exists
    public void createIfNotExists(String username, int courseId) throws Exception {
        String check = "SELECT id FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(check)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
            	String sql = "INSERT INTO user_course_progress " +
                        "(username, course_id, doc_progress, video_progress, ai_check_progress,quiz_progress, overall_status, time_spent, last_updated) " +
                        "VALUES (?, ?, 'NOT_STARTED', 'NOT_STARTED', 'NOT_STARTED', 'LOCKED','NOT_STARTED', 0, NOW())";

           PreparedStatement ins = con.prepareStatement(sql);
           ins.setString(1, username);
           ins.setInt(2, courseId);
           ins.executeUpdate();
          
          
                }
            }
        catch(Exception e) {
        	e.printStackTrace();
        }
        }
    

    // set doc_progress to 25 or 0 and update totals
    public void updateDocProgress(String username, int courseId, boolean completed) throws Exception {
        int val = completed ? 25 : 0;
        String sql = "UPDATE user_course_progress SET doc_progress=?, total_progress=(doc_progress + video_progress + quiz_progress), percentage=(doc_progress + video_progress + quiz_progress) WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, val);
            ps.setString(2, username);
            ps.setInt(3, courseId);
            ps.executeUpdate();
        }
    }

    public void updateVideoProgress(String username, int courseId, boolean completed) throws Exception {
        int val = completed ? 25 : 0;
        String sql = "UPDATE user_course_progress SET video_progress=?, total_progress=(doc_progress + video_progress + quiz_progress), percentage=(doc_progress + video_progress + quiz_progress) WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, val);
            ps.setString(2, username);
            ps.setInt(3, courseId);
            ps.executeUpdate();
        }
    }

    // when quiz fully completed (meeting criteria), set quiz_progress = 50 and quiz_status = COMPLETED
    public void updateQuizProgressOnCompletion(String username, int courseId, boolean completed) throws Exception {
        int val = completed ? 50 : 0;
        String sql = "UPDATE user_course_progress SET quiz_progress=?, quiz_status=?, total_progress=(doc_progress + video_progress + quiz_progress), percentage=(doc_progress + video_progress + quiz_progress) WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, val);
            ps.setString(2, completed ? "COMPLETED" : "IN_PROGRESS");
            ps.setString(3, username);
            ps.setInt(4, courseId);
            ps.executeUpdate();
        }
    }

    // get progress map for AJAX/UI
    public Map<String, Object> getProgress(String username, int courseId) throws Exception {
        String sql = "SELECT doc_progress, video_progress, quiz_progress, total_progress, percentage, quiz_status FROM user_course_progress WHERE username=? AND course_id=?";
        Map<String, Object> out = new HashMap<>();
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                out.put("doc_progress", rs.getInt("doc_progress"));
                out.put("video_progress", rs.getInt("video_progress"));
                out.put("quiz_progress", rs.getInt("quiz_progress"));
                out.put("total_progress", rs.getInt("total_progress"));
                out.put("percentage", rs.getDouble("percentage"));
                out.put("quiz_status", rs.getString("quiz_status"));
            } else {
                out.put("doc_progress", 0);
                out.put("video_progress", 0);
                out.put("quiz_progress", 0);
                out.put("total_progress", 0);
                out.put("percentage", 0.0);
                out.put("quiz_status", "LOCKED");
            }
        }
        return out;
    }
}
*/


/*claude ai  *
package Module2;

import Module1.DbConnection;
import java.sql.*;
import Module4.*;

public class ProgressDAO {
    
    public UserCourseProgress getProgress(String username, int courseId) {
        String sql = "SELECT * FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserCourseProgress progress = new UserCourseProgress();
                    progress.setDocProgress(rs.getString("doc_progress"));
                    progress.setVideoProgress(rs.getString("video_progress"));
                    progress.setAiCheckProgress(rs.getString("ai_check_progress"));
                    progress.setQuizProgress(rs.getString("quiz_progress"));
                    progress.setOverallStatus(rs.getString("overall_status"));
                    progress.setTimeSpent(rs.getLong("time_spent"));
                    progress.setLastUpdated(rs.getTimestamp("last_updated"));
                    progress.setPercentage(rs.getDouble("percentage"));
                    progress.setTotalProgress(rs.getInt("total_progress"));
                    return progress;
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public int Checkprogress(String username, int courseId) throws Exception {
        String check_prg = "SELECT total_progress FROM user_course_progress WHERE username=? AND course_id=?";
        try(Connection con = DbConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(check_prg)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_progress");
            } else {
                return 0;
            }
        }
    }
    
    public static void createIfNotExists(String username, int courseId) throws Exception {
        String check = "SELECT id FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(check)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                String sql = "INSERT INTO user_course_progress " +
                        "(username, course_id, doc_progress, video_progress, ai_check_progress, " +
                        "quiz_progress, overall_status, time_spent, percentage, total_progress) " +
                        "VALUES (?, ?, 'NOT_STARTED','NOT_STARTED','NOT_STARTED','LOCKED','NOT_STARTED',0,0.00,0)";
                try (PreparedStatement ins = con.prepareStatement(sql)) {
                    ins.setString(1, username);
                    ins.setInt(2, courseId);
                    ins.executeUpdate();
                }
            }
        }
    }
    
    public void updateDocProgress(String username, int courseId) throws Exception {
        try (Connection con = DbConnection.getConnection()) {
            // 1. Mark DOC as reviewed
            String sql = "UPDATE user_course_progress SET doc_progress='REVIEWED', " +
                        "overall_status='IN_PROGRESS', last_updated=NOW() " +
                        "WHERE username=? AND course_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            }

            // 2. Recalculate total progress
            recalculateTotalProgress(username, courseId, con);
            
            // 3. Unlock quiz if both doc and video reviewed
            unlockQuizIfReady(username, courseId);
        }
    }
    
    
    
    
    // NEW: Update video watch percentage (tracks actual viewing)
    public void updateVideoWatchProgress(String username, int courseId, double watchPercent) throws Exception {
        String sql = "UPDATE user_course_progress SET percentage=?, last_updated=NOW() " +
                    "WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, watchPercent);
            ps.setString(2, username);
            ps.setInt(3, courseId);
            ps.executeUpdate();
        }
    }
    
    // NEW: Mark video as REVIEWED when 90%+ watched
    public void markVideoAsReviewed(String username, int courseId) throws Exception {
        try (Connection con = DbConnection.getConnection()) {
            // Mark VIDEO as REVIEWED
            String sql = "UPDATE user_course_progress SET video_progress='REVIEWED', " +
                        "overall_status='IN_PROGRESS', last_updated=NOW() " +
                        "WHERE username=? AND course_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            }
            
            // Recalculate total progress
            recalculateTotalProgress(username, courseId, con);
            
            // Unlock quiz if ready
            unlockQuizIfReady(username, courseId);
        }
    }
    
    // NEW: Get video watch percentage
    public double getVideoWatchPercent(String username, int courseId) throws Exception {
        String sql = "SELECT percentage FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("percentage");
            }
        }
        return 0.0;
    }
    
    // NEW: Get video status
    public String getVideoStatus(String username, int courseId) throws Exception {
        String sql = "SELECT video_progress FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("video_progress");
            }
        }
        return "NOT_STARTED";
    }
    
    // REFACTORED: Calculate total progress based on doc and video status
    private void recalculateTotalProgress(String username, int courseId, Connection con) throws Exception {
        String sqlCheck = "SELECT doc_progress, video_progress FROM user_course_progress " +
                         "WHERE username=? AND course_id=?";
        try (PreparedStatement ps = con.prepareStatement(sqlCheck)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int total = 0;
                    if ("REVIEWED".equals(rs.getString("doc_progress"))) total += 25;
                    if ("REVIEWED".equals(rs.getString("video_progress"))) total += 25;

                    // Update total_progress
                    String sqlUpdate = "UPDATE user_course_progress SET total_progress=? " +
                                      "WHERE username=? AND course_id=?";
                    try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                        psUpdate.setInt(1, total);
                        psUpdate.setString(2, username);
                        psUpdate.setInt(3, courseId);
                        psUpdate.executeUpdate();
                    }
                }
            }
        }
    }

    // Check doc + video reviewed, unlock quiz
    private void unlockQuizIfReady(String username, int courseId) throws Exception {
        String sql = "SELECT doc_progress, video_progress FROM user_course_progress " +
                    "WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String doc = rs.getString("doc_progress");
                String vid = rs.getString("video_progress");
                if ("REVIEWED".equals(doc) && "REVIEWED".equals(vid)) {
                    String update = "UPDATE user_course_progress SET quiz_progress='IN_PROGRESS', " +
                                   "last_updated=NOW() WHERE username=? AND course_id=?";
                    try (PreparedStatement ps2 = con.prepareStatement(update)) {
                        ps2.setString(1, username);
                        ps2.setInt(2, courseId);
                        ps2.executeUpdate();
                    }
                }
            }
        }
    }

    public String getCourseLink(int courseId, String activity) throws Exception {
        String field = activity.equals("DOC") ? "document_link" : "video_link";
        String sql = "SELECT " + field + " FROM courses_1 WHERE id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        }
        return null;
    }
}

*/


//progressdao for watch time updation


package Module2;

import java.sql.*;
import Module1.DbConnection;
import Module4.*;

public class ProgressDAO {
    
    public UserCourseProgress getProgress(String username, int courseId) {
        String sql = "SELECT * FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserCourseProgress progress = new UserCourseProgress();
                    progress.setDocProgress(rs.getString("doc_progress"));
                    progress.setVideoProgress(rs.getString("video_progress"));
                    progress.setAiCheckProgress(rs.getString("ai_check_progress"));
                    progress.setQuizProgress(rs.getString("quiz_progress"));
                    progress.setOverallStatus(rs.getString("overall_status"));
                    progress.setTimeSpent(rs.getLong("time_spent"));
                    progress.setLastUpdated(rs.getTimestamp("last_updated"));
                    progress.setPercentage(rs.getDouble("percentage"));
                    progress.setTotalProgress(rs.getInt("total_progress"));
                    
                    // NEW: Add video watch percent and last position
                    progress.setVideoWatchPercent(rs.getDouble("video_watch_percent"));
                    progress.setVideoLastPosition(rs.getInt("video_last_position"));
                    
                    return progress;
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 // Replace your Checkprogress() method in ProgressDAO.java with this:

    public int Checkprogress(String username, int courseId) throws Exception {
        String sql = "SELECT doc_progress, video_progress, quiz_progress FROM user_course_progress " +
                     "WHERE username=? AND course_id=?";
        try(Connection con = DbConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int total = 0;
                
                String docStatus = rs.getString("doc_progress");
                String videoStatus = rs.getString("video_progress");
                String quizStatus = rs.getString("quiz_progress");
                
                // Doc: 25%
                if ("REVIEWED".equals(docStatus)) {
                    total += 25;
                }
                
                // Video: 25%
                if ("REVIEWED".equals(videoStatus)) {
                    total += 25;
                }
                
                // Quiz: 50%
                if ("COMPLETED".equals(quizStatus)) {
                    total += 50;
                }
                
                // Update total_progress in database
                String updateSql = "UPDATE user_course_progress SET total_progress=? WHERE username=? AND course_id=?";
                try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                    psUpdate.setInt(1, total);
                    psUpdate.setString(2, username);
                    psUpdate.setInt(3, courseId);
                    psUpdate.executeUpdate();
                }
                
                System.out.println("📊 Total Progress: " + total + "% (Doc:" + docStatus + 
                                 ", Video:" + videoStatus + ", Quiz:" + quizStatus + ")");
                return total;
            } else {
                return 0;
            }
        }
    }
    
  /*  public int Checkprogress(String username, int courseId) throws Exception {
        String check_prg = "SELECT total_progress FROM user_course_progress WHERE username=? AND course_id=?";
        try(Connection con = DbConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(check_prg)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_progress");
            } else {
                return 0;
            }
        }
    }*/
    
    public static void createIfNotExists(String username, int courseId) throws Exception {
        String check = "SELECT id FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(check)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                String sql = "INSERT INTO user_course_progress " +
                        "(username, course_id, doc_progress, video_progress, ai_check_progress, " +
                        "quiz_progress, overall_status, time_spent, percentage, total_progress, " +
                        "video_watch_percent, video_last_position) " +
                        "VALUES (?, ?, 'NOT_STARTED','NOT_STARTED','NOT_STARTED','LOCKED','NOT_STARTED',0,0.00,0,0.00,0)";
                try (PreparedStatement ins = con.prepareStatement(sql)) {
                    ins.setString(1, username);
                    ins.setInt(2, courseId);
                    ins.executeUpdate();
                }
            }
        }
    }
    
    public void updateDocProgress(String username, int courseId) throws Exception {
        try (Connection con = DbConnection.getConnection()) {
            // 1. Mark DOC as reviewed
            String sql = "UPDATE user_course_progress SET doc_progress='REVIEWED', " +
                        "overall_status='IN_PROGRESS', last_updated=NOW() " +
                        "WHERE username=? AND course_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            }

            // 2. Recalculate total progress
            recalculateTotalProgress(username, courseId, con);
            
            // 3. Unlock quiz if both doc and video reviewed
            unlockQuizIfReady(username, courseId);
        }
    }
    
    // NEW: Update video watch percentage AND last position
    public void updateVideoWatchProgress(String username, int courseId, double watchPercent, int lastPosition) throws Exception {
        String sql = "UPDATE user_course_progress SET " +
                    "video_watch_percent=?, " +
                    "video_last_position=?, " +
                    "percentage=?, " +
                    "last_updated=NOW() " +
                    "WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, watchPercent);
            ps.setInt(2, lastPosition);
            ps.setDouble(3, watchPercent); // Keep percentage for backward compatibility
            ps.setString(4, username);
            ps.setInt(5, courseId);
            
            int rows = ps.executeUpdate();
            System.out.println("✅ Updated video progress: " + rows + " rows affected");
        }
    }
    
    // NEW: Mark video as REVIEWED when 90%+ watched
    public void markVideoAsReviewed(String username, int courseId) throws Exception {
        try (Connection con = DbConnection.getConnection()) {
            // Mark VIDEO as REVIEWED
            String sql = "UPDATE user_course_progress SET video_progress='REVIEWED', " +
                        "overall_status='IN_PROGRESS', last_updated=NOW() " +
                        "WHERE username=? AND course_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            }
            
            // Recalculate total progress
            recalculateTotalProgress(username, courseId, con);
            
            // Unlock quiz if ready
            unlockQuizIfReady(username, courseId);
        }
    }
    
    // NEW: Get video watch percentage
    public double getVideoWatchPercent(String username, int courseId) throws Exception {
        String sql = "SELECT video_watch_percent FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("video_watch_percent");
            }
        }
        return 0.0;
    }
    
    // NEW: Get video last position
    public int getVideoLastPosition(String username, int courseId) throws Exception {
        String sql = "SELECT video_last_position FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("video_last_position");
            }
        }
        return 0;
    }
    
    // NEW: Get video status
    public String getVideoStatus(String username, int courseId) throws Exception {
        String sql = "SELECT video_progress FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("video_progress");
            }
        }
        return "NOT_STARTED";
    }
    
    // REFACTORED: Calculate total progress based on doc and video status
    private void recalculateTotalProgress(String username, int courseId, Connection con) throws Exception {
        String sqlCheck = "SELECT doc_progress, video_progress FROM user_course_progress " +
                         "WHERE username=? AND course_id=?";
        try (PreparedStatement ps = con.prepareStatement(sqlCheck)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int total = 0;
                    if ("REVIEWED".equals(rs.getString("doc_progress"))) total += 25;
                    if ("REVIEWED".equals(rs.getString("video_progress"))) total += 25;

                    // Update total_progress
                    String sqlUpdate = "UPDATE user_course_progress SET total_progress=? " +
                                      "WHERE username=? AND course_id=?";
                    try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                        psUpdate.setInt(1, total);
                        psUpdate.setString(2, username);
                        psUpdate.setInt(3, courseId);
                        psUpdate.executeUpdate();
                    }
                }
            }
        }
    }

    // Check doc + video reviewed, unlock quiz
    private void unlockQuizIfReady(String username, int courseId) throws Exception {
        String sql = "SELECT doc_progress, video_progress FROM user_course_progress " +
                    "WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String doc = rs.getString("doc_progress");
                String vid = rs.getString("video_progress");
                if ("REVIEWED".equals(doc) && "REVIEWED".equals(vid)) {
                    String update = "UPDATE user_course_progress SET quiz_progress='IN_PROGRESS', " +
                                   "last_updated=NOW() WHERE username=? AND course_id=?";
                    try (PreparedStatement ps2 = con.prepareStatement(update)) {
                        ps2.setString(1, username);
                        ps2.setInt(2, courseId);
                        ps2.executeUpdate();
                    }
                }
            }
        }
    }

    public String getCourseLink(int courseId, String activity) throws Exception {
        String field = activity.equals("DOC") ? "document_link" : "video_link";
        String sql = "SELECT " + field + " FROM courses_1 WHERE id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        }
        return null;
    }
}





/*


package Module2;

import Module1.DbConnection;
import java.sql.*;
import Module4.*;

public class ProgressDAO {
	public  UserCourseProgress getProgress(String username, int courseId)  {
        String sql = "SELECT * FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserCourseProgress progress = new UserCourseProgress();
                    progress.setDocProgress(rs.getString("doc_progress"));
                    progress.setVideoProgress(rs.getString("video_progress"));
                    progress.setAiCheckProgress(rs.getString("ai_check_progress"));
                    progress.setQuizProgress(rs.getString("quiz_progress"));
                    progress.setOverallStatus(rs.getString("overall_status"));
                    progress.setTimeSpent(rs.getLong("time_spent"));
                    progress.setLastUpdated(rs.getTimestamp("last_updated"));
                    progress.setPercentage(rs.getDouble("percentage"));
                    progress.setTotalProgress(rs.getInt("total_progress"));  // <-- new line

                    return progress;
                }
            }
        }
        catch(Exception e ) {
        	e.printStackTrace();
        }
        return null; // No row found
    }
	
	public int Checkprogress(String username,int courseId)throws Exception {
		String check_prg="Select * from user_course_progress where username=? and course_id=?";
		try(Connection con = DbConnection.getConnection();
	             PreparedStatement ps = con.prepareStatement(check_prg)){
			ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { // ✅ Move to first row
                return rs.getInt("total_progress");
            } else {
                return 0; // No row found → assume 0%
            }
			
		}
		
	}
    // Ensure row exists
    public static void createIfNotExists(String username, int courseId) throws Exception {
        String check = "SELECT id FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(check)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                String sql = "INSERT INTO user_course_progress " +
                        "(username, course_id, doc_progress, video_progress, ai_check_progress, quiz_progress, overall_status, time_spent, percentage) " +
                        "VALUES (?, ?, 'NOT_STARTED','NOT_STARTED','NOT_STARTED','LOCKED','NOT_STARTED',0,0.00)";
                try (PreparedStatement ins = con.prepareStatement(sql)) {
                    ins.setString(1, username);
                    ins.setInt(2, courseId);
                    ins.executeUpdate();
                }
            }
        }
    }
    public void updateDocProgress(String username, int courseId) throws Exception {
        try (Connection con = DbConnection.getConnection()) {
            // 1. Mark DOC as reviewed
            String sql = "UPDATE user_course_progress SET doc_progress='REVIEWED', overall_status='IN_PROGRESS', last_updated=NOW() WHERE username=? AND course_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            }

            // 2. Recalculate total progress
            String sqlCheck = "SELECT doc_progress, video_progress FROM user_course_progress WHERE username=? AND course_id=?";
            try (PreparedStatement ps = con.prepareStatement(sqlCheck)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int total = 0;
                        if ("REVIEWED".equals(rs.getString("doc_progress"))) total += 25;
                        if ("REVIEWED".equals(rs.getString("video_progress"))) total += 25;

                        // Update total_progress
                        String sqlUpdate = "UPDATE user_course_progress SET total_progress=? WHERE username=? AND course_id=?";
                        try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                            psUpdate.setInt(1, total);
                            psUpdate.setString(2, username);
                            psUpdate.setInt(3, courseId);
                            psUpdate.executeUpdate();
                        }
                    }
                }
            }

            unlockQuizIfReady(username, courseId); // optional, if both reviewed
        }
    }


  /*  public void updateDocProgress(String username, int courseId) throws Exception {
        String sql = "UPDATE user_course_progress SET doc_progress='REVIEWED', overall_status='IN_PROGRESS', last_updated=NOW() WHERE username=? AND course_id=? AND total_progress=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            if(Checkprogress(username,courseId)<25) {
            	
                int prg=Checkprogress(username,courseId);
             	ps.setInt(3, prg+25);
             }
             else
             	ps.setInt(3,Checkprogress(username,courseId) );
            ps.executeUpdate();
        }
        unlockQuizIfReady(username, courseId);
    }*/

 /*   public void updateVideoProgress(String username, int courseId) throws Exception {
        try (Connection con = DbConnection.getConnection()) {
            // 1️⃣ Mark VIDEO as reviewed
            String sql = "UPDATE user_course_progress SET video_progress='REVIEWED', overall_status='IN_PROGRESS', last_updated=NOW() WHERE username=? AND course_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            }

            // 2️⃣ Recalculate total progress based on doc and video
            String sqlCheck = "SELECT doc_progress, video_progress FROM user_course_progress WHERE username=? AND course_id=?";
            try (PreparedStatement ps = con.prepareStatement(sqlCheck)) {
                ps.setString(1, username);
                ps.setInt(2, courseId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int total = 0;
                        if ("REVIEWED".equals(rs.getString("doc_progress"))) total += 25;
                        if ("REVIEWED".equals(rs.getString("video_progress"))) total += 25;

                        // 3️⃣ Update total_progress
                        String sqlUpdate = "UPDATE user_course_progress SET total_progress=? WHERE username=? AND course_id=?";
                        try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                            psUpdate.setInt(1, total);
                            psUpdate.setString(2, username);
                            psUpdate.setInt(3, courseId);
                            psUpdate.executeUpdate();
                        }
                    }
                }
            }

            // 4️⃣ Unlock quiz if both activities reviewed
            unlockQuizIfReady(username, courseId);
        }
    }


    // check doc + video reviewed, unlock quiz
    private void unlockQuizIfReady(String username, int courseId) throws Exception {
        String sql = "SELECT doc_progress, video_progress FROM user_course_progress WHERE username=? AND course_id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String doc = rs.getString("doc_progress");
                String vid = rs.getString("video_progress");
                if ("REVIEWED".equals(doc) && "REVIEWED".equals(vid)) {
                    String update = "UPDATE user_course_progress SET quiz_progress='IN_PROGRESS', last_updated=NOW() WHERE username=? AND course_id=?";
                    try (PreparedStatement ps2 = con.prepareStatement(update)) {
                        ps2.setString(1, username);
                        ps2.setInt(2, courseId);
                        ps2.executeUpdate();
                    }
                }
            }
        }
    }

    public String getCourseLink(int courseId, String activity) throws Exception {
        String field = activity.equals("DOC") ? "document_link" : "video_link";
        String sql = "SELECT " + field + " FROM courses_1 WHERE id=?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        }
        return null;
    }
}
*/

