<%-- -%><%@ page import="java.util.*, Module1.User" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<%
    // Get logged in user
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve results from session
    Integer totalQuestions = (Integer) session.getAttribute("totalQuestions");
    Integer correctAnswers = (Integer) session.getAttribute("correctAnswers");
    Integer wrongAnswers = (Integer) session.getAttribute("wrongAnswers");
    Integer attemptedQuestions = (Integer) session.getAttribute("attemptedQuestions");
    Integer notAttemptedQuestions = (Integer) session.getAttribute("notAttemptedQuestions");
    Double percentage = (Double) session.getAttribute("percentage");
    String level = (String) session.getAttribute("quizLevel");
    List<Map<String, Object>> detailedResults = 
        (List<Map<String, Object>>) session.getAttribute("detailedResults");

    // Redirect if no results found
    if (totalQuestions == null || detailedResults == null) {
        response.sendRedirect("practice.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Practice Quiz Results</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #0b0b2b 0%, #1a0033 100%);
            color: #fff;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #00e0ff;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header .level-badge {
            display: inline-block;
            background: rgba(255, 204, 0, 0.2);
            color: #ffcc00;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        /* Summary Cards */
        .summary-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .summary-card {
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            border: 2px solid rgba(0, 224, 255, 0.3);
            transition: transform 0.3s ease;
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
            border-color: #00e0ff;
        }
        
        .summary-card .label {
            font-size: 0.9em;
            color: #aaa;
            margin-bottom: 10px;
        }
        
        .summary-card .value {
            font-size: 2.5em;
            font-weight: bold;
            color: #00e0ff;
        }
        
        .summary-card.correct .value { color: #00ff88; }
        .summary-card.wrong .value { color: #ff4444; }
        .summary-card.attempted .value { color: #ffaa00; }
        .summary-card.not-attempted .value { color: #888; }
        
        /* Percentage Circle */
        .percentage-section {
            text-align: center;
            margin: 40px 0;
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 15px;
            padding: 30px;
            border: 2px solid rgba(0, 224, 255, 0.3);
        }
        
        .percentage-circle {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: conic-gradient(
                #00ff88 0% <%= (int)percentage.doubleValue() %>%,
                rgba(255, 255, 255, 0.1) <%= (int)percentage.doubleValue() %>% 100%
            );
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            position: relative;
        }
        
        .percentage-circle::before {
            content: '';
            position: absolute;
            width: 170px;
            height: 170px;
            background: #11134d;
            border-radius: 50%;
        }
        
        .percentage-value {
            position: relative;
            font-size: 3em;
            font-weight: bold;
            color: #00ff88;
        }
        
        .percentage-label {
            font-size: 1.2em;
            color: #aaa;
        }
        
        /* Questions Section */
        .questions-section {
            margin-top: 40px;
        }
        
        .section-title {
            font-size: 1.8em;
            color: #00e0ff;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(0, 224, 255, 0.3);
        }
        
        .question-card {
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            border-left: 5px solid #00e0ff;
        }
        
        .question-card.correct {
            border-left-color: #00ff88;
            background: linear-gradient(135deg, rgba(0, 255, 136, 0.1), rgba(11, 13, 58, 0.9));
        }
        
        .question-card.wrong {
            border-left-color: #ff4444;
            background: linear-gradient(135deg, rgba(255, 68, 68, 0.1), rgba(11, 13, 58, 0.9));
        }
        
        .question-card.not-attempted {
            border-left-color: #888;
            background: linear-gradient(135deg, rgba(136, 136, 136, 0.1), rgba(11, 13, 58, 0.9));
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .question-number {
            font-size: 1.1em;
            font-weight: bold;
            color: #00e0ff;
            margin-right: 10px;
        }
        
        .question-text {
            flex: 1;
            font-size: 1.1em;
            line-height: 1.6;
            color: #fff;
        }
        
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            white-space: nowrap;
        }
        
        .status-badge.correct {
            background: rgba(0, 255, 136, 0.2);
            color: #00ff88;
        }
        
        .status-badge.wrong {
            background: rgba(255, 68, 68, 0.2);
            color: #ff4444;
        }
        
        .status-badge.not-attempted {
            background: rgba(136, 136, 136, 0.2);
            color: #888;
        }
        
        .options-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 10px;
            margin: 15px 0;
        }
        
        .option {
            background: rgba(255, 255, 255, 0.05);
            padding: 12px;
            border-radius: 8px;
            border: 2px solid transparent;
        }
        
        .option.correct-answer {
            background: rgba(0, 255, 136, 0.15);
            border-color: #00ff88;
        }
        
        .option.user-answer {
            background: rgba(255, 170, 0, 0.15);
            border-color: #ffaa00;
        }
        
        .option.user-wrong {
            background: rgba(255, 68, 68, 0.15);
            border-color: #ff4444;
        }
        
        .option-label {
            font-weight: bold;
            color: #00e0ff;
            margin-right: 8px;
        }
        
        .answer-explanation {
            background: rgba(0, 224, 255, 0.1);
            border-left: 3px solid #00e0ff;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }
        
        .answer-explanation .explanation-label {
            font-weight: bold;
            color: #00e0ff;
            margin-bottom: 8px;
            display: block;
        }
        
        .answer-explanation .explanation-text {
            color: #ddd;
            line-height: 1.6;
        }
        
        /* Action Buttons */
        .action-buttons {
            text-align: center;
            margin: 40px 0;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 10px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1em;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #00e0ff, #0080ff);
            color: #000;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #00ffcc, #00e0ff);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 224, 255, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #ffcc00, #ff9900);
            color: #000;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #ffdd00, #ffaa00);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 204, 0, 0.4);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .summary-section {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .header h1 {
                font-size: 1.8em;
            }
            
            .percentage-circle {
                width: 150px;
                height: 150px;
            }
            
            .percentage-circle::before {
                width: 120px;
                height: 120px;
            }
            
            .percentage-value {
                font-size: 2em;
            }
            
            .options-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>🎓 Practice Quiz Results</h1>
            <div class="level-badge"><%= level %> Level</div>
        </div>
        
        <!-- Summary Cards -->
        <div class="summary-section">
            <div class="summary-card">
                <div class="label">Total Questions</div>
                <div class="value"><%= totalQuestions %></div>
            </div>
            
            <div class="summary-card correct">
                <div class="label">Correct</div>
                <div class="value"><%= correctAnswers %></div>
            </div>
            
            <div class="summary-card wrong">
                <div class="label">Wrong</div>
                <div class="value"><%= wrongAnswers %></div>
            </div>
            
            <div class="summary-card attempted">
                <div class="label">Attempted</div>
                <div class="value"><%= attemptedQuestions %></div>
            </div>
            
            <div class="summary-card not-attempted">
                <div class="label">Not Attempted</div>
                <div class="value"><%= notAttemptedQuestions %></div>
            </div>
        </div>
        
        <!-- Percentage Section -->
        <div class="percentage-section">
            <div class="percentage-circle">
                <div class="percentage-value"><%= String.format("%.1f", percentage) %>%</div>
            </div>
            <div class="percentage-label">Overall Score</div>
            <p style="color: #aaa; margin-top: 15px;">
                Based on <%= correctAnswers %> out of <%= totalQuestions %> questions
            </p>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="practice.jsp" class="btn btn-primary">Take Another Quiz</a>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
        
        <!-- Detailed Results -->
        <div class="questions-section">
            <h2 class="section-title">📝 Detailed Solutions</h2>
            
            <%
                int questionNumber = 1;
                for (Map<String, Object> result : detailedResults) {
                    String status = (String) result.get("status");
                    Boolean isCorrect = (Boolean) result.get("is_correct");
                    String userAnswer = (String) result.get("user_answer");
                    String correctOption = (String) result.get("correct_option");
                    
                    String cardClass = "";
                    String badgeClass = "";
                    String badgeText = "";
                    
                    if ("not_attempted".equals(status)) {
                        cardClass = "not-attempted";
                        badgeClass = "not-attempted";
                        badgeText = "Not Attempted";
                    } else if (isCorrect) {
                        cardClass = "correct";
                        badgeClass = "correct";
                        badgeText = "✓ Correct";
                    } else {
                        cardClass = "wrong";
                        badgeClass = "wrong";
                        badgeText = "✗ Wrong";
                    }
            %>
            
            <div class="question-card <%= cardClass %>">
                <div class="question-header">
                    <div style="flex: 1;">
                        <span class="question-number">Question <%= questionNumber++ %>:</span>
                        <span class="question-text"><%= result.get("question_text") %></span>
                    </div>
                    <div class="status-badge <%= badgeClass %>"><%= badgeText %></div>
                </div>
                
                <div class="options-grid">
                    <%
                        String[] options = {"A", "B", "C", "D"};
                        for (String opt : options) {
                            String optionText = (String) result.get("option_" + opt.toLowerCase());
                            String optionClass = "";
                            
                            if (opt.equals(correctOption)) {
                                optionClass = "correct-answer";
                            }
                            
                            if (userAnswer != null && opt.equals(userAnswer)) {
                                if (opt.equals(correctOption)) {
                                    optionClass = "correct-answer user-answer";
                                } else {
                                    optionClass = "user-wrong";
                                }
                            }
                    %>
                    <div class="option <%= optionClass %>">
                        <span class="option-label"><%= opt %>.</span>
                        <%= optionText %>
                        <% if (opt.equals(correctOption)) { %>
                            <span style="color: #00ff88; margin-left: 8px;">✓</span>
                        <% } %>
                        <% if (userAnswer != null && opt.equals(userAnswer) && !opt.equals(correctOption)) { %>
                            <span style="color: #ff4444; margin-left: 8px;">✗ Your Answer</span>
                        <% } %>
                        <% if (userAnswer != null && opt.equals(userAnswer) && opt.equals(correctOption)) { %>
                            <span style="color: #00ff88; margin-left: 8px;">(Your Answer)</span>
                        <% } %>
                    </div>
                    <% } %>
                </div>
                
                <% 
                    String answerText = (String) result.get("answer_text");
                    if (answerText != null && !answerText.trim().isEmpty()) {
                %>
                <div class="answer-explanation">
                    <span class="explanation-label">💡 Explanation:</span>
                    <div class="explanation-text"><%= answerText %></div>
                </div>
                <% } else { %>
                <div class="answer-explanation">
                    <span class="explanation-label">✅ Correct Answer:</span>
                    <div class="explanation-text">Option <%= correctOption %>: <%= result.get("option_" + correctOption.toLowerCase()) %></div>
                </div>
                <% } %>
            </div>
            
            <% } %>
        </div>
        
        <!-- Final Action Buttons -->
        <div class="action-buttons" style="margin-top: 50px;">
            <a href="practice.jsp" class="btn btn-primary">Take Another Quiz</a>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>
</body>
</html> --%




<%@ page import="java.util.*, Module1.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<%
    // Get logged in user
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve results from session
    Integer totalQuestions = (Integer) session.getAttribute("totalQuestions");
    Integer correctAnswers = (Integer) session.getAttribute("correctAnswers");
    Integer wrongAnswers = (Integer) session.getAttribute("wrongAnswers");
    Integer attemptedQuestions = (Integer) session.getAttribute("attemptedQuestions");
    Integer notAttemptedQuestions = (Integer) session.getAttribute("notAttemptedQuestions");
    Double percentage = (Double) session.getAttribute("percentage");
    String level = (String) session.getAttribute("quizLevel");
    List<Map<String, Object>> detailedResults = 
        (List<Map<String, Object>>) session.getAttribute("detailedResults");

    // Redirect if no results found
    if (totalQuestions == null || detailedResults == null) {
        response.sendRedirect("practice.jsp");
        return;
    }
    
    // Clear all quiz-related session attributes after displaying results
    // This prevents old answers from appearing if user goes back
    session.removeAttribute("questions");
    session.removeAttribute("timeLimit");
    session.removeAttribute("courseId");
    session.removeAttribute("level");
    session.removeAttribute("startTime");
    session.removeAttribute("quizStarted");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Practice Quiz Results</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #0b0b2b 0%, #1a0033 100%);
            color: #fff;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #00e0ff;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header .level-badge {
            display: inline-block;
            background: rgba(255, 204, 0, 0.2);
            color: #ffcc00;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        /* Summary Cards */
        .summary-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .summary-card {
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            border: 2px solid rgba(0, 224, 255, 0.3);
            transition: transform 0.3s ease;
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
            border-color: #00e0ff;
        }
        
        .summary-card .label {
            font-size: 0.9em;
            color: #aaa;
            margin-bottom: 10px;
        }
        
        .summary-card .value {
            font-size: 2.5em;
            font-weight: bold;
            color: #00e0ff;
        }
        
        .summary-card.correct .value { color: #00ff88; }
        .summary-card.wrong .value { color: #ff4444; }
        .summary-card.attempted .value { color: #ffaa00; }
        .summary-card.not-attempted .value { color: #888; }
        
        /* Percentage Circle */
        .percentage-section {
            text-align: center;
            margin: 40px 0;
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 15px;
            padding: 30px;
            border: 2px solid rgba(0, 224, 255, 0.3);
        }
        
        .percentage-circle {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: conic-gradient(
                #00ff88 0% <%= (int)percentage.doubleValue() %>%,
                rgba(255, 255, 255, 0.1) <%= (int)percentage.doubleValue() %>% 100%
            );
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            position: relative;
        }
        
        .percentage-circle::before {
            content: '';
            position: absolute;
            width: 170px;
            height: 170px;
            background: #11134d;
            border-radius: 50%;
        }
        
        .percentage-value {
            position: relative;
            font-size: 3em;
            font-weight: bold;
            color: #00ff88;
        }
        
        .percentage-label {
            font-size: 1.2em;
            color: #aaa;
        }
        
        /* Questions Section */
        .questions-section {
            margin-top: 40px;
        }
        
        .section-title {
            font-size: 1.8em;
            color: #00e0ff;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(0, 224, 255, 0.3);
        }
        
        .question-card {
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            border-left: 5px solid #00e0ff;
        }
        
        .question-card.correct {
            border-left-color: #00ff88;
            background: linear-gradient(135deg, rgba(0, 255, 136, 0.1), rgba(11, 13, 58, 0.9));
        }
        
        .question-card.wrong {
            border-left-color: #ff4444;
            background: linear-gradient(135deg, rgba(255, 68, 68, 0.1), rgba(11, 13, 58, 0.9));
        }
        
        .question-card.not-attempted {
            border-left-color: #888;
            background: linear-gradient(135deg, rgba(136, 136, 136, 0.1), rgba(11, 13, 58, 0.9));
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .question-number {
            font-size: 1.1em;
            font-weight: bold;
            color: #00e0ff;
            margin-right: 10px;
        }
        
        .question-text {
            flex: 1;
            font-size: 1.1em;
            line-height: 1.6;
            color: #fff;
        }
        
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            white-space: nowrap;
        }
        
        .status-badge.correct {
            background: rgba(0, 255, 136, 0.2);
            color: #00ff88;
        }
        
        .status-badge.wrong {
            background: rgba(255, 68, 68, 0.2);
            color: #ff4444;
        }
        
        .status-badge.not-attempted {
            background: rgba(136, 136, 136, 0.2);
            color: #888;
        }
        
        .options-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 10px;
            margin: 15px 0;
        }
        
        .option {
            background: rgba(255, 255, 255, 0.05);
            padding: 12px;
            border-radius: 8px;
            border: 2px solid transparent;
        }
        
        .option.correct-answer {
            background: rgba(0, 255, 136, 0.15);
            border-color: #00ff88;
        }
        
        .option.user-answer {
            background: rgba(255, 170, 0, 0.15);
            border-color: #ffaa00;
        }
        
        .option.user-wrong {
            background: rgba(255, 68, 68, 0.15);
            border-color: #ff4444;
        }
        
        .option-label {
            font-weight: bold;
            color: #00e0ff;
            margin-right: 8px;
        }
        
        .answer-explanation {
            background: rgba(0, 224, 255, 0.1);
            border-left: 3px solid #00e0ff;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }
        
        .answer-explanation .explanation-label {
            font-weight: bold;
            color: #00e0ff;
            margin-bottom: 8px;
            display: block;
        }
        
        .answer-explanation .explanation-text {
            color: #ddd;
            line-height: 1.6;
        }
        
        /* Action Buttons */
        .action-buttons {
            text-align: center;
            margin: 40px 0;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 10px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1em;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #00e0ff, #0080ff);
            color: #000;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #00ffcc, #00e0ff);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 224, 255, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #ffcc00, #ff9900);
            color: #000;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #ffdd00, #ffaa00);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 204, 0, 0.4);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .summary-section {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .header h1 {
                font-size: 1.8em;
            }
            
            .percentage-circle {
                width: 150px;
                height: 150px;
            }
            
            .percentage-circle::before {
                width: 120px;
                height: 120px;
            }
            
            .percentage-value {
                font-size: 2em;
            }
            
            .options-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>Practice Quiz Results</h1>
            <div class="level-badge"><%= level %> Level</div>
        </div>
        
        <!-- Summary Cards -->
        <div class="summary-section">
            <div class="summary-card">
                <div class="label">Total Questions</div>
                <div class="value"><%= totalQuestions %></div>
            </div>
            
            <div class="summary-card correct">
                <div class="label">Correct</div>
                <div class="value"><%= correctAnswers %></div>
            </div>
            
            <div class="summary-card wrong">
                <div class="label">Wrong</div>
                <div class="value"><%= wrongAnswers %></div>
            </div>
            
            <div class="summary-card attempted">
                <div class="label">Attempted</div>
                <div class="value"><%= attemptedQuestions %></div>
            </div>
            
            <div class="summary-card not-attempted">
                <div class="label">Not Attempted</div>
                <div class="value"><%= notAttemptedQuestions %></div>
            </div>
        </div>
        
        <!-- Percentage Section -->
        <div class="percentage-section">
            <div class="percentage-circle">
                <div class="percentage-value"><%= String.format("%.1f", percentage) %>%</div>
            </div>
            <div class="percentage-label">Overall Score</div>
            <p style="color: #aaa; margin-top: 15px;">
                Based on <%= correctAnswers %> out of <%= totalQuestions %> questions
            </p>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="practice.jsp" class="btn btn-primary">Take Another Quiz</a>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
        
        <!-- Detailed Results -->
        <div class="questions-section">
            <h2 class="section-title">Detailed Solutions</h2>
            
            <%
                int questionNumber = 1;
                for (Map<String, Object> result : detailedResults) {
                    String status = (String) result.get("status");
                    Boolean isCorrect = (Boolean) result.get("is_correct");
                    String userAnswer = (String) result.get("user_answer");
                    String correctOption = (String) result.get("correct_option");
                    
                    String cardClass = "";
                    String badgeClass = "";
                    String badgeText = "";
                    
                    if ("not_attempted".equals(status)) {
                        cardClass = "not-attempted";
                        badgeClass = "not-attempted";
                        badgeText = "Not Attempted";
                    } else if (isCorrect) {
                        cardClass = "correct";
                        badgeClass = "correct";
                        badgeText = "Correct";
                    } else {
                        cardClass = "wrong";
                        badgeClass = "wrong";
                        badgeText = "Wrong";
                    }
            %>
            
            <div class="question-card <%= cardClass %>">
                <div class="question-header">
                    <div style="flex: 1;">
                        <span class="question-number">Question <%= questionNumber++ %>:</span>
                        <span class="question-text"><%= result.get("question_text") %></span>
                    </div>
                    <div class="status-badge <%= badgeClass %>"><%= badgeText %></div>
                </div>
                
                <div class="options-grid">
                    <%
                        String[] options = {"A", "B", "C", "D"};
                        for (String opt : options) {
                            String optionText = (String) result.get("option_" + opt.toLowerCase());
                            String optionClass = "";
                            
                            if (opt.equals(correctOption)) {
                                optionClass = "correct-answer";
                            }
                            
                            if (userAnswer != null && opt.equals(userAnswer)) {
                                if (opt.equals(correctOption)) {
                                    optionClass = "correct-answer user-answer";
                                } else {
                                    optionClass = "user-wrong";
                                }
                            }
                    %>
                    <div class="option <%= optionClass %>">
                        <span class="option-label"><%= opt %>.</span>
                        <%= optionText %>
                        <% if (opt.equals(correctOption)) { %>
                            <span style="color: #00ff88; margin-left: 8px;">[Correct Answer]</span>
                        <% } %>
                        <% if (userAnswer != null && opt.equals(userAnswer) && !opt.equals(correctOption)) { %>
                            <span style="color: #ff4444; margin-left: 8px;">[Your Answer]</span>
                        <% } %>
                        <% if (userAnswer != null && opt.equals(userAnswer) && opt.equals(correctOption)) { %>
                            <span style="color: #00ff88; margin-left: 8px;">[Your Answer]</span>
                        <% } %>
                    </div>
                    <% } %>
                </div>
                
                <% 
                    String answerText = (String) result.get("answer_text");
                    if (answerText != null && !answerText.trim().isEmpty()) {
                %>
                <div class="answer-explanation">
                    <span class="explanation-label">Explanation:</span>
                    <div class="explanation-text"><%= answerText %></div>
                </div>
                <% } else { %>
                <div class="answer-explanation">
                    <span class="explanation-label">Correct Answer:</span>
                    <div class="explanation-text">Option <%= correctOption %>: <%= result.get("option_" + correctOption.toLowerCase()) %></div>
                </div>
                <% } %>
            </div>
            
            <% } %>
        </div>
        
        <!-- Final Action Buttons -->
        <div class="action-buttons" style="margin-top: 50px;">
            <a href="practice.jsp" class="btn btn-primary">Take Another Quiz</a>
            <a href="home.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>
    
    <script>
        // Prevent back button from showing old quiz
        window.history.pushState(null, "", window.location.href);        
        window.onpopstate = function() {
            window.history.pushState(null, "", window.location.href);
        };
    </script>
</body>
</html>
--%





<%@ page import="java.util.*, Module1.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<%
    // Get logged in user
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve results from session
    Integer totalQuestions = (Integer) session.getAttribute("totalQuestions");
    Integer correctAnswers = (Integer) session.getAttribute("correctAnswers");
    Integer wrongAnswers = (Integer) session.getAttribute("wrongAnswers");
    Integer attemptedQuestions = (Integer) session.getAttribute("attemptedQuestions");
    Integer notAttemptedQuestions = (Integer) session.getAttribute("notAttemptedQuestions");
    Double percentage = (Double) session.getAttribute("percentage");
    String level = (String) session.getAttribute("quizLevel");
    List<Map<String, Object>> detailedResults = 
        (List<Map<String, Object>>) session.getAttribute("detailedResults");

    // Redirect if no results found
    if (totalQuestions == null || detailedResults == null) {
        response.sendRedirect("practice.jsp");
        return;
    }
    
    // Clear all quiz-related session attributes after displaying results
    session.removeAttribute("questions");
    session.removeAttribute("timeLimit");
    session.removeAttribute("courseId");
    session.removeAttribute("level");
    session.removeAttribute("startTime");
    session.removeAttribute("quizStarted");

    double pctValue = (percentage != null) ? percentage.doubleValue() : 0.0;
    int pctInt = (int)Math.round(pctValue);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Practice Quiz Results</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #0b0b2b 0%, #1a0033 100%);
            color: #fff;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #00e0ff;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header .level-badge {
            display: inline-block;
            background: rgba(255, 204, 0, 0.2);
            color: #ffcc00;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        /* Summary Cards */
        .summary-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .summary-card {
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            border: 2px solid rgba(0, 224, 255, 0.3);
            transition: transform 0.3s ease;
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
            border-color: #00e0ff;
        }
        
        .summary-card .label {
            font-size: 0.9em;
            color: #aaa;
            margin-bottom: 10px;
        }
        
        .summary-card .value {
            font-size: 2.5em;
            font-weight: bold;
            color: #00e0ff;
        }
        
        .summary-card.correct .value { color: #00ff88; }
        .summary-card.wrong .value { color: #ff4444; }
        .summary-card.attempted .value { color: #ffaa00; }
        .summary-card.not-attempted .value { color: #888; }
        
        /* Percentage Circle */
        .percentage-section {
            text-align: center;
            margin: 40px 0;
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 15px;
            padding: 30px;
            border: 2px solid rgba(0, 224, 255, 0.3);
        }
        
        .percentage-circle {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: conic-gradient(
                #00ff88 0% <%= pctInt %>%, 
                rgba(255, 255, 255, 0.08) <%= pctInt %>% 100%
            );
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            position: relative;
        }
        
        .percentage-circle::before {
            content: '';
            position: absolute;
            width: 170px;
            height: 170px;
            background: #11134d;
            border-radius: 50%;
        }
        
        .percentage-value {
            position: relative;
            font-size: 3em;
            font-weight: bold;
            color: #00ff88;
        }
        
        .percentage-label {
            font-size: 1.2em;
            color: #aaa;
        }
        
        /* Questions Section */
        .questions-section {
            margin-top: 40px;
        }
        
        .section-title {
            font-size: 1.8em;
            color: #00e0ff;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(0, 224, 255, 0.3);
        }
        
        .question-card {
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            border-left: 5px solid #00e0ff;
        }
        
        .question-card.correct {
            border-left-color: #00ff88;
            background: linear-gradient(135deg, rgba(0, 255, 136, 0.06), rgba(11, 13, 58, 0.9));
        }
        
        .question-card.wrong {
            border-left-color: #ff4444;
            background: linear-gradient(135deg, rgba(255, 68, 68, 0.06), rgba(11, 13, 58, 0.9));
        }
        
        .question-card.not-attempted {
            border-left-color: #888;
            background: linear-gradient(135deg, rgba(136, 136, 136, 0.06), rgba(11, 13, 58, 0.9));
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .question-number {
            font-size: 1.1em;
            font-weight: bold;
            color: #00e0ff;
            margin-right: 10px;
        }
        
        .question-text {
            flex: 1;
            font-size: 1.1em;
            line-height: 1.6;
            color: #fff;
        }
        
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            white-space: nowrap;
        }
        
        .status-badge.correct {
            background: rgba(0, 255, 136, 0.2);
            color: #00ff88;
        }
        
        .status-badge.wrong {
            background: rgba(255, 68, 68, 0.2);
            color: #ff4444;
        }
        
        .status-badge.not-attempted {
            background: rgba(136, 136, 136, 0.2);
            color: #888;
        }
        
        .options-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 10px;
            margin: 15px 0;
        }
        
        .option {
            background: rgba(255, 255, 255, 0.03);
            padding: 12px;
            border-radius: 8px;
            border: 2px solid transparent;
            color: #ddd;
        }
        
        /* Default correct / user / wrong styles */
        .option.correct-answer {
            background: rgba(0, 255, 136, 0.15);
            border-color: #00ff88;
        }
        
        .option.user-answer {
            background: rgba(255, 170, 0, 0.15);
            border-color: #ffaa00;
        }
        
        .option.user-wrong {
            background: rgba(255, 68, 68, 0.15);
            border-color: #ff4444;
        }

        /* IMPORTANT: when user selects the correct option, keep it green */
        .option.correct-answer.user-answer {
            background: rgba(0, 255, 136, 0.22) !important;
            border-color: #00ff88 !important;
        }
        
        .option-label {
            font-weight: bold;
            color: #00e0ff;
            margin-right: 8px;
        }
        
        .answer-explanation {
            background: rgba(0, 224, 255, 0.06);
            border-left: 3px solid #00e0ff;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
            color: #ddd;
        }
        
        .answer-explanation .explanation-label {
            font-weight: bold;
            color: #00e0ff;
            margin-bottom: 8px;
            display: block;
        }
        
        /* Action Buttons */
        .action-buttons {
            text-align: center;
            margin: 40px 0;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 10px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1em;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #00e0ff, #0080ff);
            color: #000;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #00ffcc, #00e0ff);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 224, 255, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #ffcc00, #ff9900);
            color: #000;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #ffdd00, #ffaa00);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 204, 0, 0.4);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .summary-section {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .header h1 {
                font-size: 1.8em;
            }
            
            .percentage-circle {
                width: 150px;
                height: 150px;
            }
            
            .percentage-circle::before {
                width: 120px;
                height: 120px;
            }
            
            .percentage-value {
                font-size: 2em;
            }
            
            .options-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>Practice Quiz Results</h1>
            <div class="level-badge"><%= (level != null ? level : "Practice") %> Level</div>
        </div>
        
        <!-- Summary Cards -->
        <div class="summary-section">
            <div class="summary-card">
                <div class="label">Total Questions</div>
                <div class="value"><%= totalQuestions %></div>
            </div>
            
            <div class="summary-card correct">
                <div class="label">Correct</div>
                <div class="value"><%= correctAnswers %></div>
            </div>
            
            <div class="summary-card wrong">
                <div class="label">Wrong</div>
                <div class="value"><%= wrongAnswers %></div>
            </div>
            
            <div class="summary-card attempted">
                <div class="label">Attempted</div>
                <div class="value"><%= attemptedQuestions %></div>
            </div>
            
            <div class="summary-card not-attempted">
                <div class="label">Not Attempted</div>
                <div class="value"><%= notAttemptedQuestions %></div>
            </div>
        </div>
        
        <!-- Percentage Section -->
        <div class="percentage-section">
            <div class="percentage-circle">
                <div class="percentage-value"><%= String.format("%.1f", (percentage != null ? percentage : 0.0)) %>%</div>
            </div>
            <div class="percentage-label">Overall Score</div>
            <p style="color: #aaa; margin-top: 15px;">
                Based on <%= correctAnswers %> out of <%= totalQuestions %> questions
            </p>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="practice.jsp" class="btn btn-primary">Take Another Quiz</a>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
        
        <!-- Detailed Results -->
        <div class="questions-section">
            <h2 class="section-title">Detailed Solutions</h2>
            
            <%
                int questionNumber = 1;
                for (Map<String, Object> result : detailedResults) {
                    String status = (String) result.get("status");
                    Boolean isCorrect = (Boolean) result.get("is_correct");
                    String userAnswer = (String) result.get("user_answer");
                    String correctOption = (String) result.get("correct_option");
                    
                    String cardClass = "";
                    String badgeClass = "";
                    String badgeText = "";
                    
                    if ("not_attempted".equals(status)) {
                        cardClass = "not-attempted";
                        badgeClass = "not-attempted";
                        badgeText = "Not Attempted";
                    } else if (isCorrect != null && isCorrect) {
                        cardClass = "correct";
                        badgeClass = "correct";
                        badgeText = "Correct";
                    } else {
                        cardClass = "wrong";
                        badgeClass = "wrong";
                        badgeText = "Wrong";
                    }
            %>
            
            <div class="question-card <%= cardClass %>">
                <div class="question-header">
                    <div style="flex: 1;">
                        <span class="question-number">Question <%= questionNumber++ %>:</span>
                        <span class="question-text"><%= result.get("question_text") %></span>
                    </div>
                    <div class="status-badge <%= badgeClass %>"><%= badgeText %></div>
                </div>
                
                <div class="options-grid">
                    <%
                        String[] options = {"A", "B", "C", "D"};
                        for (String opt : options) {
                            String optionText = (String) result.get("option_" + opt.toLowerCase());
                            if (optionText == null) optionText = "-";
                            String optionClass = "";
                            
                            if (opt.equals(correctOption)) {
                                optionClass = "correct-answer";
                            }
                            
                            if (userAnswer != null && opt.equals(userAnswer)) {
                                if (opt.equals(correctOption)) {
                                    // user selected the correct option -> keep green + indicate user's selection
                                    optionClass = "correct-answer user-answer";
                                } else {
                                    optionClass = "user-wrong";
                                }
                            }
                    %>
                    <div class="option <%= optionClass %>">
                        <span class="option-label"><%= opt %>.</span>
                        <%= optionText %>
                        <% if (opt.equals(correctOption)) { %>
                            <span style="color: #00ff88; margin-left: 8px;">[Correct Answer]</span>
                        <% } %>
                        <% if (userAnswer != null && opt.equals(userAnswer) && !opt.equals(correctOption)) { %>
                            <span style="color: #ff4444; margin-left: 8px;">[Your Answer]</span>
                        <% } %>
                        <% if (userAnswer != null && opt.equals(userAnswer) && opt.equals(correctOption)) { %>
                            <span style="color: #00ff88; margin-left: 8px;">[Your Answer]</span>
                        <% } %>
                    </div>
                    <% } %>
                </div>
                
                <% 
                    String answerText = (String) result.get("answer_text");
                    if (answerText != null && !answerText.trim().isEmpty()) {
                %>
                <div class="answer-explanation">
                    <span class="explanation-label">Explanation:</span>
                    <div class="explanation-text"><%= answerText %></div>
                </div>
                <% } else { %>
                <div class="answer-explanation">
                    <span class="explanation-label">Correct Answer:</span>
                    <div class="explanation-text">Option <%= (result.get("correct_option") != null ? result.get("correct_option") : "-") %>: <%= (result.get("option_" + (result.get("correct_option") != null ? result.get("correct_option").toString().toLowerCase() : "a")) != null ? result.get("option_" + (result.get("correct_option") != null ? result.get("correct_option").toString().toLowerCase() : "a")) : "-") %></div>
                </div>
                <% } %>
            </div>
            
            <% } %>
        </div>
        
        <!-- Final Action Buttons -->
        <div class="action-buttons" style="margin-top: 50px;">
            <a href="practice.jsp" class="btn btn-primary">Take Another Quiz</a>
            <a href="home.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>
    
    <script>
        // Prevent back button showing old quiz
        window.history.pushState(null, "", window.location.href);        
        window.onpopstate = function() {
            window.history.pushState(null, "", window.location.href);
        };
    </script>
</body>
</html>--%>




<%-- --%
<%@ page import="java.util.*, Module1.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Integer totalQuestions = (Integer) session.getAttribute("totalQuestions");
    Integer correctAnswers = (Integer) session.getAttribute("correctAnswers");
    Integer wrongAnswers = (Integer) session.getAttribute("wrongAnswers");
    Integer attemptedQuestions = (Integer) session.getAttribute("attemptedQuestions");
    Integer notAttemptedQuestions = (Integer) session.getAttribute("notAttemptedQuestions");
    Double percentage = (Double) session.getAttribute("percentage");
    String level = (String) session.getAttribute("quizLevel");
    List<Map<String, Object>> detailedResults = (List<Map<String, Object>>) session.getAttribute("detailedResults");

    if (totalQuestions == null || detailedResults == null) {
        response.sendRedirect("practice.jsp");
        return;
    }

    session.removeAttribute("questions");
    session.removeAttribute("timeLimit");
    session.removeAttribute("courseId");
    session.removeAttribute("level");
    session.removeAttribute("startTime");
    session.removeAttribute("quizStarted");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Practice Quiz Results</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
    body { font-family:'Arial',sans-serif; background:linear-gradient(135deg,#0b0b2b 0%,#1a0033 100%); color:#fff; margin:0; padding:20px; min-height:100vh; }
    .container { max-width:1200px; margin:0 auto; }
    .header { text-align:center; margin-bottom:30px; }
    .header h1 { color:#00e0ff; font-size:2.5em; margin-bottom:10px; }
    .header .level-badge { display:inline-block; background:rgba(255,204,0,0.2); color:#ffcc00; padding:8px 20px; border-radius:20px; font-weight:bold; text-transform:uppercase; }

    /* Summary Cards */
    .summary-section { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px; margin-bottom:40px; }
    .summary-card { background: linear-gradient(135deg, rgba(17,19,77,0.9), rgba(11,13,58,0.9)); border-radius:15px; padding:20px; text-align:center; border:2px solid rgba(0,224,255,0.3); transition: transform 0.3s ease; }
    .summary-card:hover { transform: translateY(-5px); border-color:#00e0ff; }
    .summary-card .label { font-size:0.9em; color:#aaa; margin-bottom:10px; }
    .summary-card .value { font-size:2.5em; font-weight:bold; color:#00e0ff; }
    .summary-card.correct .value { color:#00ff88; }
    .summary-card.wrong .value { color:#ff4444; }
    .summary-card.attempted .value { color:#ffaa00; }
    .summary-card.not-attempted .value { color:#888; }

    /* Questions Section */
    .questions-section { margin-top:40px; }
    .section-title { font-size:1.8em; color:#00e0ff; margin-bottom:20px; padding-bottom:10px; border-bottom:2px solid rgba(0,224,255,0.3); }
    .question-card { background: linear-gradient(135deg, rgba(17,19,77,0.9), rgba(11,13,58,0.9)); border-radius:12px; padding:25px; margin-bottom:20px; border-left:5px solid #00e0ff; }
    .question-card.correct { border-left-color:#00ff88; background: linear-gradient(135deg, rgba(0,255,136,0.1), rgba(11,13,58,0.9)); }
    .question-card.wrong { border-left-color:#ff4444; background: linear-gradient(135deg, rgba(255,68,68,0.1), rgba(11,13,58,0.9)); }
    .question-card.not-attempted { border-left-color:#888; background: linear-gradient(135deg, rgba(136,136,136,0.1), rgba(11,13,58,0.9)); }

    .question-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:15px; }
    .question-number { font-size:1.1em; font-weight:bold; color:#00e0ff; margin-right:10px; }
    .question-text { flex:1; font-size:1.1em; line-height:1.6; color:#fff; }
    .status-badge { padding:5px 15px; border-radius:20px; font-size:0.85em; font-weight:bold; white-space:nowrap; }
    .status-badge.correct { background: rgba(0,255,136,0.2); color:#00ff88; }
    .status-badge.wrong { background: rgba(255,68,68,0.2); color:#ff4444; }
    .status-badge.not-attempted { background: rgba(136,136,136,0.2); color:#888; }

    .options-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(250px,1fr)); gap:10px; margin:15px 0; }
    .option { 
    background: rgba(255,255,255,0.05); 
    padding:12px; 
    border-radius:8px; 
    border:2px solid transparent; 
}

/* Correct option: green border */
.option.correct-answer { 
    border: 2px solid #00ff88; 
    background: rgba(0,255,136,0.05); 
}

/* User selected wrong option: red border */
.option.user-wrong { 
    border: 2px solid #ff4444; 
    background: rgba(255,68,68,0.05); 
}

    .option-label { font-weight:bold; color:#00e0ff; margin-right:8px; }

    .answer-explanation { background: rgba(0,224,255,0.1); border-left:3px solid #00e0ff; padding:15px; border-radius:8px; margin-top:15px; }
    .answer-explanation .explanation-label { font-weight:bold; color:#00e0ff; margin-bottom:8px; display:block; }
    .answer-explanation .explanation-text { color:#ddd; line-height:1.6; }
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Practice Quiz Results</h1>
        <div class="level-badge"><%= level %> Level</div>
    </div>

    <div class="summary-section">
        <div class="summary-card"><div class="label">Total Questions</div><div class="value"><%= totalQuestions %></div></div>
        <div class="summary-card correct"><div class="label">Correct</div><div class="value"><%= correctAnswers %></div></div>
        <div class="summary-card wrong"><div class="label">Wrong</div><div class="value"><%= wrongAnswers %></div></div>
        <div class="summary-card attempted"><div class="label">Attempted</div><div class="value"><%= attemptedQuestions %></div></div>
        <div class="summary-card not-attempted"><div class="label">Not Attempted</div><div class="value"><%= notAttemptedQuestions %></div></div>
    </div>

    <div class="questions-section">
        <h2 class="section-title">Detailed Solutions</h2>
        <%
            int questionNumber = 1;
            for(Map<String,Object> result : detailedResults){
                String status = (String) result.get("status");
                Boolean isCorrect = (Boolean) result.get("is_correct");
                String userAnswer = (String) result.get("user_answer");
                String correctOption = (String) result.get("correct_option");
                String answerText = (String) result.get("answer_text");

                String cardClass = "not-attempted";
                String badgeClass = "not-attempted";
                String badgeText = "Not Attempted";

                if(status.equals("not_attempted")){
                    cardClass="not-attempted"; badgeClass="not-attempted"; badgeText="Not Attempted";
                } else if(isCorrect){
                    cardClass="correct"; badgeClass="correct"; badgeText="Correct";
                } else {
                    cardClass="wrong"; badgeClass="wrong"; badgeText="Wrong";
                }
        %>
        <div class="question-card <%=cardClass%>">
            <div class="question-header">
                <span class="question-number">Q<%=questionNumber++%>:</span>
                <span class="question-text"><%= result.get("question_text") %></span>
                <div class="status-badge <%=badgeClass%>"><%=badgeText%></div>
            </div>
            <div class="options-grid">
            
            
            <%
    String[] options = {"A","B","C","D"};
    for(String opt : options){
        String optionText = (String) result.get("option_" + opt.toLowerCase());
        String optionClass = "";

        if(opt.equals(correctOption)) {
            optionClass = "correct-answer"; // always green border
        }
        if(userAnswer != null && opt.equals(userAnswer) && !opt.equals(correctOption)) {
            optionClass = "user-wrong"; // red border if user picked wrong
        }
%>
<div class="option <%=optionClass%>">
    <span class="option-label"><%=opt%>.</span> <%=optionText%>
</div>
<% } %>
            
           <%-- -->     <% String[] options={"A","B","C","D"};
                   for(String opt:options){
                       String optionText=(String)result.get("option_"+opt.toLowerCase());
                       String optionClass="";
                       if(opt.equals(correctOption)) optionClass="correct-answer";
                       if(userAnswer!=null && opt.equals(userAnswer) && !opt.equals(correctOption)) optionClass="user-wrong";
                %>
                <div class="option <%=optionClass%>">
                    <span class="option-label"><%=opt%>.</span> <%=optionText%>
                </div>
                <% } %>  --%
            </div>
            <div class="answer-explanation">
                <span class="explanation-label">Explanation:</span>
                <div class="explanation-text"><%= (answerText != null && !answerText.trim().isEmpty()) ? answerText : result.get("option_"+correctOption.toLowerCase()) %></div>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>  --%>





<%@ page import="java.util.*, Module1.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Integer total = (Integer) session.getAttribute("totalQuestions");
    Integer score = (Integer) session.getAttribute("correctAnswers");
    List<Map<String, Object>> resultDetails = (List<Map<String, Object>>) session.getAttribute("detailedResults");
    String level = (String) session.getAttribute("quizLevel");

    if(total == null || resultDetails == null){
        response.sendRedirect("practice.jsp");
        return;
    }

    int attemptedCount = (Integer) session.getAttribute("attemptedQuestions");
    int notAttemptedCount = (Integer) session.getAttribute("notAttemptedQuestions");
    int wrongCount = (Integer) session.getAttribute("wrongAnswers");

    // Optional: clear session data
    session.removeAttribute("questions");
    session.removeAttribute("timeLimit");
    session.removeAttribute("startTime");
    session.removeAttribute("quizStarted");
    session.removeAttribute("totalQuestions");
    session.removeAttribute("correctAnswers");
    session.removeAttribute("wrongAnswers");
    session.removeAttribute("attemptedQuestions");
    session.removeAttribute("notAttemptedQuestions");
    session.removeAttribute("detailedResults");
    session.removeAttribute("quizLevel");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Practice Quiz Results</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
    /* COPY EXACT CSS FROM result.jsp */
    body { font-family:'Arial',sans-serif; background:linear-gradient(135deg,#0b0b2b 0%,#1a0033 100%); color:#fff; margin:0; padding:20px; min-height:100vh; }
    .container { max-width:1200px; margin:0 auto; }
    .header { text-align:center; margin-bottom:30px; }
    .header h1 { color:#00e0ff; font-size:2.5em; margin-bottom:10px; }
    .summary-section { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px; margin-bottom:40px; }
    .summary-card { background: linear-gradient(135deg, rgba(17,19,77,0.9), rgba(11,13,58,0.9)); border-radius:15px; padding:20px; text-align:center; border:2px solid rgba(0,224,255,0.3); transition: transform 0.3s ease; }
    .summary-card:hover { transform: translateY(-5px); border-color:#00e0ff; }
    .summary-card .label { font-size:0.9em; color:#aaa; margin-bottom:10px; }
    .summary-card .value { font-size:2.5em; font-weight:bold; color:#00e0ff; }
    .summary-card.correct .value { color:#00ff88; }
    .summary-card.wrong .value { color:#ff4444; }
    .summary-card.attempted .value { color:#ffaa00; }
    .summary-card.not-attempted .value { color:#888; }

    .questions-section { margin-top:40px; }
    .section-title { font-size:1.8em; color:#00e0ff; margin-bottom:20px; padding-bottom:10px; border-bottom:2px solid rgba(0,224,255,0.3); }
    .question-card { background: linear-gradient(135deg, rgba(17,19,77,0.9), rgba(11,13,58,0.9)); border-radius:12px; padding:25px; margin-bottom:20px; border-left:5px solid #00e0ff; }
    .question-card.correct { border-left-color:#00ff88; background: linear-gradient(135deg, rgba(0,255,136,0.1), rgba(11,13,58,0.9)); }
    .question-card.wrong { border-left-color:#ff4444; background: linear-gradient(135deg, rgba(255,68,68,0.1), rgba(11,13,58,0.9)); }
    .question-card.not-attempted { border-left-color:#888; background: linear-gradient(135deg, rgba(136,136,136,0.1), rgba(11,13,58,0.9)); }

    .question-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:15px; }
    .question-number { font-size:1.1em; font-weight:bold; color:#00e0ff; margin-right:10px; }
    .question-text { flex:1; font-size:1.1em; line-height:1.6; color:#fff; }
    .status-badge { padding:5px 15px; border-radius:20px; font-size:0.85em; font-weight:bold; white-space:nowrap; }
    .status-badge.correct { background: rgba(0,255,136,0.2); color:#00ff88; }
    .status-badge.wrong { background: rgba(255,68,68,0.2); color:#ff4444; }
    .status-badge.not-attempted { background: rgba(136,136,136,0.2); color:#888; }

    .options-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(250px,1fr)); gap:10px; margin:15px 0; }
    .option { background: rgba(255,255,255,0.05); padding:12px; border-radius:8px; border:2px solid transparent; }
    .option.correct-answer { border:2px solid #00ff88; background: rgba(0,255,136,0.05); }
    .option.user-wrong { border:2px solid #ff4444; background: rgba(255,68,68,0.05); }
    .option-label { font-weight:bold; color:#00e0ff; margin-right:8px; }

    .answer-explanation { background: rgba(0,224,255,0.1); border-left:3px solid #00e0ff; padding:15px; border-radius:8px; margin-top:15px; }
    .answer-explanation .explanation-label { font-weight:bold; color:#00e0ff; margin-bottom:8px; display:block; }
    .answer-explanation .explanation-text { color:#ddd; line-height:1.6; }
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Practice Quiz Results</h1>
    </div>

    <div class="summary-section">
        <div class="summary-card"><div class="label">Total Questions</div><div class="value"><%= total %></div></div>
        <div class="summary-card correct"><div class="label">Correct</div><div class="value"><%= score %></div></div>
        <div class="summary-card wrong"><div class="label">Wrong</div><div class="value"><%= wrongCount %></div></div>
        <div class="summary-card attempted"><div class="label">Attempted</div><div class="value"><%= attemptedCount %></div></div>
        <div class="summary-card not-attempted"><div class="label">Not Attempted</div><div class="value"><%= notAttemptedCount %></div></div>
    </div>

    <div class="questions-section">
        <h2 class="section-title">Detailed Solutions</h2>
        <%
            int qNo = 1;
            for(Map<String,Object> r : resultDetails){
                String userAnswer = (String) r.get("user_answer");
                String correctOption = (String) r.get("correct_option");

                String cardClass="not-attempted";
                String badgeClass="not-attempted";
                String badgeText="Not Attempted";

                if(userAnswer == null || userAnswer.trim().isEmpty()){
                    cardClass="not-attempted"; badgeClass="not-attempted"; badgeText="Not Attempted";
                } else if(userAnswer.equalsIgnoreCase(correctOption)){
                    cardClass="correct"; badgeClass="correct"; badgeText="Correct";
                } else {
                    cardClass="wrong"; badgeClass="wrong"; badgeText="Wrong";
                }
        %>
        <div class="question-card <%=cardClass%>">
            <div class="question-header">
                <span class="question-number">Q<%=qNo++%>:</span>
                <span class="question-text"><%= r.get("question_text") %></span>
                <div class="status-badge <%=badgeClass%>"><%=badgeText%></div>
            </div>
            <div class="options-grid">
                <%
                    String[] opts = {"A","B","C","D"};
                    for(String opt : opts){
                        String optionText = (String) r.get("option_" + opt.toLowerCase());
                        String optionClass = "";
                        if(opt.equalsIgnoreCase(correctOption)) optionClass="correct-answer";
                        if(userAnswer != null && opt.equalsIgnoreCase(userAnswer) && !opt.equalsIgnoreCase(correctOption)) optionClass="user-wrong";
                %>
                <div class="option <%=optionClass%>">
                    <span class="option-label"><%=opt%>.</span> <%=optionText%>
                </div>
                <% } %>
            </div>
            <div class="answer-explanation">
                <span class="explanation-label">Explanation:</span>
                <div class="explanation-text"><%= (r.get("answer_text") != null && !((String)r.get("answer_text")).trim().isEmpty()) ? r.get("answer_text") : r.get("option_"+correctOption.toLowerCase()) %></div>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
