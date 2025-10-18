// Question.java (in Model package)
package Module3;

public class Question {
    int id;
    String questionText, optionA, optionB, optionC, optionD;
    char correctOption;

    public Question(int id, String qt, String a, String b, String c, String d, char correct) {
        this.id = id; this.questionText = qt;
        this.optionA = a; this.optionB = b;
        this.optionC = c; this.optionD = d;
        this.correctOption = correct;
    }

    // Getters here ...
    
    public int getId() {
    	return id;
    }
    public String getQuestionText() {
    	return questionText;
    }
    public String getOptionA() {
    	return optionA;
    }
    public String getOptionB() {
    	return optionB;
    }
    public String getOptionC() {
    	return optionC;
    }
    public String getOptionD() {
    	return optionD;
    }
}
