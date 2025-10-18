package Module4;



import java.sql.Timestamp;

public class UserBadge {
    private int id;
    private String username;
    private int courseId;
    private String badgeName;
    private Timestamp dateAwarded;

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public String getBadgeName() { return badgeName; }
    public void setBadgeName(String badgeName) { this.badgeName = badgeName; }
    public Timestamp getDateAwarded() { return dateAwarded; }
    public void setDateAwarded(Timestamp dateAwarded) { this.dateAwarded = dateAwarded; }
}
