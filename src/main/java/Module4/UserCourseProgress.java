/*package Module4;

import java.sql.Timestamp;

public class UserCourseProgress {
    private int id;
    private String username;
    private int courseId;
    private String docProgress;             // 0..100
    private String videoProgress;           // 0..100
    private String aiCheckProgress;      // ENUM text
    private String quizProgress;         // ENUM text
    private String overallStatus;        // ENUM text
    private long timeSpent;   
    private int totalProgress;// total seconds
    private Timestamp lastUpdated;
    private double percentage;
    private double videoWatchPercent = 0.0;
    private int videoLastPosition = 0;


    // Getters & Setters
    public int getId() { return id; }
    public double getPercentage(){
    	return percentage;
    }
    public void setPercentage(double percentage) {
    	this.percentage=percentage;
    }
  /*  public int getTotalProgress() {
        return (int) Math.round((docProgress + videoProgress + percentage) / 3.0);
    }
*/
   // public int getTotalProgress() {
      /*  int progress = 0;

        // Doc contributes 25%
        if (docProgress >= 100) {
            progress += 25;
        } else if (docProgress > 0) {
            progress += (docProgress * 25) / 100;
        }

        // Video contributes 25%
        if (videoProgress >= 100) {
            progress += 25;
        } else if (videoProgress > 0) {
            progress += (videoProgress * 25) / 100;
        }

        // Percentage field contributes remaining 50%
        progress += (int) Math.round((percentage * 50) / 100); */

/*        return totalProgress;
    }
    public void setTotalProgress(int totalProgress) { this.totalProgress = totalProgress; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public String getDocProgress() { return docProgress; }
    public void setDocProgress(String docProgress) { this.docProgress = docProgress; }
    public String getVideoProgress() { return videoProgress; }
    public void setVideoProgress(String videoProgress) { this.videoProgress = videoProgress; }
    public String getAiCheckProgress() { return aiCheckProgress; }
    public void setAiCheckProgress(String aiCheckProgress) { this.aiCheckProgress = aiCheckProgress; }
    public String getQuizProgress() { return quizProgress; }
    public void setQuizProgress(String quizProgress) { this.quizProgress = quizProgress; }
    public String getOverallStatus() { return overallStatus; }
    public void setOverallStatus(String overallStatus) { this.overallStatus = overallStatus; }
    public long getTimeSpent() { return timeSpent; }
    public void setTimeSpent(long timeSpent) { this.timeSpent = Math.max(0, timeSpent); }
    public Timestamp getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Timestamp lastUpdated) { this.lastUpdated = lastUpdated; }
 // Add these fields
    
    // Add getters and setters
    public double getVideoWatchPercent() {
        return videoWatchPercent;
    }

    public void setVideoWatchPercent(double videoWatchPercent) {
        this.videoWatchPercent = videoWatchPercent;
    }

    public int getVideoLastPosition() {
        return videoLastPosition;
    }

    public void setVideoLastPosition(int videoLastPosition) {
        this.videoLastPosition = videoLastPosition;
    }
}*/





package Module4;

import java.sql.Timestamp;

public class UserCourseProgress {
    private String username;
    private int courseId;
    private String docProgress;
    private String videoProgress;
    private String aiCheckProgress;
    private String quizProgress;
    private String overallStatus;
    private long timeSpent;
    private Timestamp lastUpdated;
    private double percentage;
    private int totalProgress;
    
    // NEW: Video tracking fields
    private double videoWatchPercent = 0.0;
    private int videoLastPosition = 0;

    // Constructors
    public UserCourseProgress() {}

    public UserCourseProgress(String username, int courseId) {
        this.username = username;
        this.courseId = courseId;
    }

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getDocProgress() {
        return docProgress;
    }

    public void setDocProgress(String docProgress) {
        this.docProgress = docProgress;
    }

    public String getVideoProgress() {
        return videoProgress;
    }

    public void setVideoProgress(String videoProgress) {
        this.videoProgress = videoProgress;
    }

    public String getAiCheckProgress() {
        return aiCheckProgress;
    }

    public void setAiCheckProgress(String aiCheckProgress) {
        this.aiCheckProgress = aiCheckProgress;
    }

    public String getQuizProgress() {
        return quizProgress;
    }

    public void setQuizProgress(String quizProgress) {
        this.quizProgress = quizProgress;
    }

    public String getOverallStatus() {
        return overallStatus;
    }

    public void setOverallStatus(String overallStatus) {
        this.overallStatus = overallStatus;
    }

    public long getTimeSpent() {
        return timeSpent;
    }

    public void setTimeSpent(long timeSpent) {
        this.timeSpent = timeSpent;
    }

    public Timestamp getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public double getPercentage() {
        return percentage;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }

    public int getTotalProgress() {
        return totalProgress;
    }

    public void setTotalProgress(int totalProgress) {
        this.totalProgress = totalProgress;
    }

    // NEW: Video watch percent getter/setter
    public double getVideoWatchPercent() {
        return videoWatchPercent;
    }

    public void setVideoWatchPercent(double videoWatchPercent) {
        this.videoWatchPercent = videoWatchPercent;
    }

    // NEW: Video last position getter/setter
    public int getVideoLastPosition() {
        return videoLastPosition;
    }

    public void setVideoLastPosition(int videoLastPosition) {
        this.videoLastPosition = videoLastPosition;
    }

    @Override
    public String toString() {
        return "UserCourseProgress{" +
                "username='" + username + '\'' +
                ", courseId=" + courseId +
                ", docProgress='" + docProgress + '\'' +
                ", videoProgress='" + videoProgress + '\'' +
                ", aiCheckProgress='" + aiCheckProgress + '\'' +
                ", quizProgress='" + quizProgress + '\'' +
                ", overallStatus='" + overallStatus + '\'' +
                ", timeSpent=" + timeSpent +
                ", lastUpdated=" + lastUpdated +
                ", percentage=" + percentage +
                ", totalProgress=" + totalProgress +
                ", videoWatchPercent=" + videoWatchPercent +
                ", videoLastPosition=" + videoLastPosition +
                '}';
    }
}
