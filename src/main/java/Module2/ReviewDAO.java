package Module2;

import java.sql.*;
import java.util.*;
import Module1.DbConnection;

import Module1.DbConnection;

public class ReviewDAO {

   /* private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdb", "root", "password");
    }*/

    // Fetch reviews for a course
    public List<Review> getReviewsByCourseId(int courseId) {
        List<Review> reviews = new ArrayList<>();
        try (Connection con = DbConnection.getConnection()){
            String sql = "SELECT r.*, u.username FROM reviews r " +
                         "JOIN users u ON r.user_id = u.id " +
                         "WHERE r.course_id = ? ORDER BY r.created_at DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review rev = new Review();
                rev.setReviewId(rs.getInt("review_id"));
                rev.setCourseId(rs.getInt("course_id"));
                rev.setUserId(rs.getInt("user_id"));
                rev.setRating(rs.getInt("rating"));
                rev.setReviewText(rs.getString("review_text"));
                rev.setUsername(rs.getString("username"));
                rev.setCreatedAt(rs.getString("created_at"));
                reviews.add(rev);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return reviews;
    }

    // Add review
    public boolean addReview(int courseId, int userId, int rating, String text) {
        try (Connection con = DbConnection.getConnection()) {
            String sql = "INSERT INTO reviews (course_id, user_id, rating, review_text) VALUES (?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, courseId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, text);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace();
        return false;}
    }public Review getReviewByUserAndCourse(int userId, int courseId) {
        Review review = null;
        String sql = "SELECT * FROM reviews WHERE user_id = ? AND course_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setCourseId(rs.getInt("course_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewText(rs.getString("review_text"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return review;
    }

    public void updateReview(int reviewId, int rating, String reviewText) {
        String sql = "UPDATE reviews SET rating = ?, review_text = ?, created_at = NOW() WHERE review_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, reviewText);
            ps.setInt(3, reviewId);
            ps.executeUpdate();
            System.out.println("Updating review_id=" + reviewId + " rating=" + rating + " text=" + reviewText);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // Get average rating
    public double getAverageRating(int courseId) {
        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT AVG(rating) as avgRating FROM reviews WHERE course_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avgRating");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }
}

