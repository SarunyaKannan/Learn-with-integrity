package Module4;

import Module1.DbConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BadgeDAO {

    public boolean hasBadge(String username, int courseId, String badgeName) throws Exception {
        String sql = "SELECT 1 FROM user_badges WHERE username=? AND course_id=? AND badge_name=? LIMIT 1";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ps.setString(3, badgeName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void awardBadge(UserBadge badge) throws Exception {
        String sql = "INSERT INTO user_badges (username, course_id, badge_name) VALUES (?,?,?)";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, badge.getUsername());
            ps.setInt(2, badge.getCourseId());
            ps.setString(3, badge.getBadgeName());
            ps.executeUpdate();
        }
    }

    public List<UserBadge> getUserBadges(String username) throws Exception {
        String sql = "SELECT * FROM user_badges WHERE username=? ORDER BY date_awarded DESC";
        List<UserBadge> list = new ArrayList<>();
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserBadge b = new UserBadge();
                    b.setId(rs.getInt("id"));
                    b.setUsername(rs.getString("username"));
                    b.setCourseId(rs.getInt("course_id"));
                    b.setBadgeName(rs.getString("badge_name"));
                    b.setDateAwarded(rs.getTimestamp("date_awarded"));
                    list.add(b);
                }
            }
        }
        return list;
    }
}

