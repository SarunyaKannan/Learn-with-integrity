package Module2;

public class Course {
    private int id;
    private String title;
    private String description;
    private String syllabus;
    private String design;
    private String topicsCovered;
    private String testDetails;
    private String image;
    private String documentLink;
    private String videoLink;
    private String section;
    
//    private int docProgress;   // 0 or 25
 //   private int videoProgress; // 0 or 25
 //   private int quizProgress;  // 0 or 50
 //   private int totalProgress; // sum => 0..100
   // private double percentage; // mirror of totalProgress


    // ✅ Full constructor with all fields
    public Course(int id, String title, String description, String syllabus, String design,
                  String topicsCovered, String testDetails, String image,
                  String documentLink, String videoLink, String section) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.syllabus = syllabus;
        this.design = design;
        this.topicsCovered = topicsCovered;
        this.testDetails = testDetails;
        this.image = image;
        this.documentLink = documentLink;
        this.videoLink = videoLink;
        this.section = section;
    }

    // ✅ Empty constructor
    public Course() {}

    // Getters
    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getSyllabus() {
        return syllabus;
    }

    public String getDesign() {
        return design;
    }

    public String getTopicsCovered() {
        return topicsCovered;
    }

    public String getTestDetails() {
        return testDetails;
    }

    public String getImage() {
        return image;
    }

    public String getDocumentLink() {
        return documentLink;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public String getSection() {
        return section;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setSyllabus(String syllabus) {
        this.syllabus = syllabus;
    }

    public void setDesign(String design) {
        this.design = design;
    }

    public void setTopicsCovered(String topicsCovered) {
        this.topicsCovered = topicsCovered;
    }

    public void setTestDetails(String testDetails) {
        this.testDetails = testDetails;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public void setDocumentLink(String documentLink) {
        this.documentLink = documentLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    public void setSection(String section) {
        this.section = section;
    }
//    public int getDocProgress() { return docProgress; }
  //  public void setDocProgress(int docProgress) { this.docProgress = docProgress; }
  //  public int getVideoProgress() { return videoProgress; }
   // public void setVideoProgress(int videoProgress) { this.videoProgress = videoProgress; }
/*    public int getQuizProgress() { return quizProgress; }
    public void setQuizProgress(int quizProgress) { this.quizProgress = quizProgress; }
    public int getTotalProgress() { return totalProgress; }
    public void setTotalProgress(int totalProgress) { this.totalProgress = totalProgress; }
    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }*/
}  /*
package Module2;

public class Course {
    private int id;
    private String title;
    private String description;
    private String image;

    // progress fields
    private int docProgress;   // 0 or 25
    private int videoProgress; // 0 or 25
    private int quizProgress;  // 0 or 50
    private int totalProgress; // sum => 0..100
    private double percentage; // mirror of totalProgress
    
    

    public Course() {}

    // getters / setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getDocProgress() { return docProgress; }
    public void setDocProgress(int docProgress) { this.docProgress = docProgress; }
    public int getVideoProgress() { return videoProgress; }
    public void setVideoProgress(int videoProgress) { this.videoProgress = videoProgress; }
    public int getQuizProgress() { return quizProgress; }
    public void setQuizProgress(int quizProgress) { this.quizProgress = quizProgress; }
    public int getTotalProgress() { return totalProgress; }
    public void setTotalProgress(int totalProgress) { this.totalProgress = totalProgress; }
    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }
}*/

