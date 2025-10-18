/*package Module5	;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import Module1.*;

public class CertificateDAO {
    public static void saveCertificate(String username, int courseId, String path) {
        try (Connection conn = DbConnection.getConnection()) {
            String sql = "INSERT INTO certificates(username, course_id, certificate_path) VALUES(?,?,?) " +
                         "ON DUPLICATE KEY UPDATE certificate_path=?, issued_at=NOW()";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ps.setString(3, path);
            ps.setString(4, path);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
*/
package Module5;

import Module1.DbConnection;
import java.sql.*;

public class CertificateDAO {

    public static boolean saveUserCertificate(String username, int courseId, int certificateId, String relativeFilePath) {
        String sql = "INSERT INTO user_certificates(username, course_id, certificate_id, file_path) VALUES (?,?,?,?) " +
                     "ON DUPLICATE KEY UPDATE file_path=?, issued_at=NOW()";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, courseId);
            ps.setInt(3, certificateId);
            ps.setString(4, relativeFilePath);
            ps.setString(5, relativeFilePath);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
