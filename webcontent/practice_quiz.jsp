<%-- -%><%@ page import="java.util.*" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<%
    // Get quiz data from session
    List<Map<String,Object>> questions = (List<Map<String,Object>>) session.getAttribute("questions");
    Integer timeLimit = (Integer) session.getAttribute("timeLimit");
    Integer courseId = (Integer) session.getAttribute("courseId");
    String level = (String) session.getAttribute("level");

    if(questions == null || questions.isEmpty()){
%>
        <h2 style="color:white; text-align:center;">No questions available for this quiz.</h2>
<%
        return;
    }
%>

<html>
<head>
    <title>Practice Quiz</title>
    <style>
        body { font-family: Arial; background: #0b0b2b; color: white; padding: 20px; }
        .quiz-box { background: rgba(255,255,255,0.08); padding: 20px; border-radius: 10px; width: 70%; margin: auto; }
        .question {font-size: 20px; margin-bottom: 20px; padding: 15px; border: 1px solid rgba(255,255,255,0.3); border-radius: 8px; }
        .options label { display: block; margin: 5px 0; cursor: pointer; }
        .timer { text-align: right; font-size: 20px; margin-bottom: 15px; color: #ffcc00; }
        button { margin-top: 20px; padding: 10px 20px; border: none; background: #00c6ff; color: white; border-radius: 5px; cursor: pointer; }
        button:hover { background: #ffcc00; color: black; }
    </style>
    <script>
        // Countdown timer
        var timeLeft = <%= timeLimit %> * 60; // in seconds
        function startTimer() {
            var timerDisplay = document.getElementById("timer");
            var timer = setInterval(function() {
                var minutes = Math.floor(timeLeft / 60);
                var seconds = timeLeft % 60;
                timerDisplay.textContent = minutes + "m " + (seconds < 10 ? "0" : "") + seconds + "s ";
                timeLeft--;

                if(timeLeft < 0){
                    clearInterval(timer);
                    alert("Time is up! Submitting your quiz.");
                    document.getElementById("quizForm").submit();
                }
            }, 1000);
        }
        window.onload = startTimer;
    </script>
</head>
<body>
    <h2 align="center">Practice Quiz - <%= level %> Level</h2>
    <div class="quiz-box">
        <div class="timer">Time Remaining: <span id="timer"></span></div>

        <form id="quizForm" action="SubmitPracticeQuizServlet" method="post">
            <input type="hidden" name="courseId" value="<%= courseId %>">
            <input type="hidden" name="level" value="<%= level %>">
            <input type="hidden" name="timeLimit" value="<%= timeLimit %>">

            <%
                int qNo = 1;
                for(Map<String,Object> q : questions){
            %>
                <div class="question">
                    <p><b>Q<%=qNo++%>. <%=q.get("question_text")%></b></p>
                    <div class="options">
                        <label><input type="radio" name="q_<%=q.get("id")%>" value="A"> <%=q.get("option_a")%></label>
                        <label><input type="radio" name="q_<%=q.get("id")%>" value="B"> <%=q.get("option_b")%></label>
                        <label><input type="radio" name="q_<%=q.get("id")%>" value="C"> <%=q.get("option_c")%></label>
                        <label><input type="radio" name="q_<%=q.get("id")%>" value="D"> <%=q.get("option_d")%></label>
                    </div>
                </div>
            <%
                }
            %>

            <div style="text-align:center;">
                <button type="submit">Submit Quiz</button>
            </div>
        </form>
    </div>
</body>
</html>  --%>











<%@ page import="java.util.*" %>
<%@ page session="true" %>

<%
    // Retrieve data from session
    List<Map<String,Object>> questions = (List<Map<String,Object>>) session.getAttribute("questions");
    Integer timeLimit = (Integer) session.getAttribute("timeLimit");
    Integer courseId = (Integer) session.getAttribute("courseId");
    String level = (String) session.getAttribute("level");

    if (questions == null || questions.isEmpty()) {
%>
        <h2 style="color:white; text-align:center;">No questions available for this practice quiz.</h2>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Practice Quiz - <%= level %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        body { font-family: Arial, sans-serif; background: #0a002b; color: #fff; margin: 0; padding: 20px; }
        .container { max-width: 1000px; margin: 20px auto; background: #11134d; padding: 20px; border-radius: 12px; }
        h2 { text-align: center; color: #00e0ff; }
        #monitorVideo { width: 320px; height: 240px; border-radius: 8px; border: 2px solid #fff; display: block; margin-bottom: 10px; }
        #examTimer { font-size: 18px; color: #ffcc00; margin-bottom: 12px; text-align: center; }
        #beginBtn { background: #00e0ff; color: #000; padding: 12px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 700; }
        #beginBtn:disabled { opacity: 0.6; cursor: not-allowed; }
        #forceSubmitBtn { background: #ff4444; color: #fff; padding: 8px 12px; border: none; border-radius: 6px; cursor: pointer; display: none; }
        .question { background: #0b0d3a; padding: 12px; border-radius: 8px; margin-bottom: 10px; }
        .question label { display: block; margin: 4px 0; color: #ddd; }
        #quizForm { display: none; }
        button[type=submit] { background: #00e0ff; color: #000; padding: 10px 18px; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; }
        button[type=submit]:hover { background: #ffcc00; color: #000; }
    </style>

    <!-- Monitoring libraries -->
    <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
    <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
    <div class="container">
        <h2>Practice Quiz - <%= level %> Level</h2>

        <div id="examTimer">Timer will appear here</div>
        <video id="monitorVideo" autoplay muted playsinline></video>

        <div style="text-align:center; margin:12px 0;">
            <button id="beginBtn">Enable Camera & Start Practice Quiz</button>
            <button id="forceSubmitBtn">Force Submit</button>
        </div>

        <!-- Practice Quiz Form -->
        <form id="quizForm" method="post" action="SubmitPracticeQuizServlet">
            <input type="hidden" name="courseId" value="<%= courseId %>">
            <input type="hidden" name="level" value="<%= level %>">
            <input type="hidden" name="timeLimit" value="<%= timeLimit %>">

            <% int qNo = 1;
               for (Map<String,Object> q : questions) { %>
                <div class="question">
                    <p><b>Q<%= qNo++ %>. <%= q.get("question_text") %></b></p>
                    <label><input type="radio" name="q_<%= q.get("id") %>" value="A"> <%= q.get("option_a") %></label>
                    <label><input type="radio" name="q_<%= q.get("id") %>" value="B"> <%= q.get("option_b") %></label>
                    <label><input type="radio" name="q_<%= q.get("id") %>" value="C"> <%= q.get("option_c") %></label>
                    <label><input type="radio" name="q_<%= q.get("id") %>" value="D"> <%= q.get("option_d") %></label>
                </div>
            <% } %>

            <div style="text-align:center;">
                <button type="submit">Submit Practice Quiz</button>
            </div>
        </form>
    </div>

    <!-- Anti-cheating & Monitoring -->
    <script>
    document.addEventListener("fullscreenchange", function() {
        if (!document.fullscreenElement) {
            alert("⚠️ You must stay in fullscreen mode to continue the quiz.");
            document.documentElement.requestFullscreen();
        }
    });

    document.addEventListener("keydown", function(e){
        if((e.ctrlKey || e.metaKey) && ["c","v","x","a"].includes(e.key)){
            e.preventDefault();
            alert("❌ Copy / Paste / Select All is not allowed during the quiz!");
        }
    });

    document.addEventListener("contextmenu", function(e){
        e.preventDefault();
        alert("❌ Right-click is disabled!");
    });

    // Initialize Proctoring and Timer
    (async function(){
        while(!window.faceapi) await new Promise(r=>setTimeout(r,100));
        const beginBtn = document.getElementById('beginBtn');
        const forceSubmitBtn = document.getElementById('forceSubmitBtn');

        beginBtn.addEventListener('click', async function(){
            beginBtn.disabled = true;
            try { await document.documentElement.requestFullscreen(); } 
            catch(e){ alert('Fullscreen required'); beginBtn.disabled=false; return; }

            try {
                const controller = await window.initExam({
                    courseId: '<%= courseId %>',
                    level: '<%= level %>',
                    durationSeconds: <%= timeLimit * 60 %>,
                    maxTabSwitches: 3,
                    formId: 'quizForm',
                    modelsUri: '<%= request.getContextPath() %>/models'
                });

                document.getElementById('quizForm').style.display='block';
                forceSubmitBtn.style.display='inline-block';
                beginBtn.style.display='none';

                forceSubmitBtn.addEventListener('click',function(){
                    if(controller && controller.stop) controller.stop();
                    document.getElementById('quizForm').submit();
                });

            } catch(e){ 
                alert('Monitoring failed: '+e.message); 
                beginBtn.disabled=false; 
            }
        });
    })();
    </script>
</body>
</html>


<%--
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
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
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
</html>   --%>

