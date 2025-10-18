<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page session="true" %>
<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
%>
<% 
    Boolean quizCompleted = (Boolean) session.getAttribute("quizCompleted");
    if (quizCompleted != null && quizCompleted) {
        response.sendRedirect("MyCoursesServlet");
        return;
    }
%>


<%
    // Check if user is logged in
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");
    
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get course/topic ID from request
    String topicId = request.getParameter("topic_id");
    String courseId = request.getParameter("course_id");
    
    // Database connection for fetching questions
    List<Map<String, Object>> questions = new ArrayList<>();
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
        
        String sql = "SELECT * FROM quiz_questions WHERE topic_id = ? ORDER BY RAND() LIMIT 10";
        PreparedStatement pst = conn.prepareStatement(sql);
        pst.setString(1, topicId);
        ResultSet rs = pst.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> question = new HashMap<>();
            question.put("id", rs.getInt("id"));
            question.put("question_text", rs.getString("question_text"));
            question.put("option_a", rs.getString("option_a"));
            question.put("option_b", rs.getString("option_b"));
            question.put("option_c", rs.getString("option_c"));
            question.put("option_d", rs.getString("option_d"));
            question.put("correct_option", rs.getString("correct_option"));
            question.put("difficulty", rs.getString("difficulty"));
            questions.add(question);
        }
        
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proctored Quiz - Learn with Integrity</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 1200px;
            width: 95%;
            min-height: 600px;
            margin: 20px auto;
        }

        .header {
            background: linear-gradient(45deg, #2196F3, #1976D2);
            color: white;
            padding: 20px;
            text-align: center;
        }

        .user-info {
            background: rgba(255,255,255,0.1);
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 14px;
        }

        .content {
            display: flex;
            min-height: 500px;
        }

        .left-panel {
            flex: 1;
            padding: 30px;
        }

        .right-panel {
            width: 350px;
            background: #f8f9fa;
            padding: 20px;
            border-left: 1px solid #e0e0e0;
        }

        .permission-screen {
            text-align: center;
        }

        .permission-screen h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .permission-list {
            text-align: left;
            margin: 20px 0;
            padding: 20px;
            background: #f0f8ff;
            border-radius: 10px;
        }

        .permission-list li {
            margin: 10px 0;
            color: #555;
        }

        .btn {
            background: linear-gradient(45deg, #4CAF50, #45a049);
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 16px;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .btn-danger {
            background: linear-gradient(45deg, #f44336, #d32f2f);
        }

        .webcam-container {
            position: relative;
            margin: 20px 0;
        }

        #videoElement {
            width: 100%;
            max-width: 300px;
            border-radius: 10px;
            border: 3px solid #4CAF50;
        }

        .status-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .status-good { background: #4CAF50; }
        .status-warning { background: #FF9800; }
        .status-error { background: #F44336; }

        .alert {
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            font-weight: bold;
        }

        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeaa7; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .quiz-container {
            display: none;
        }

        .question-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .timer {
            background: #FF5722;
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            font-weight: bold;
        }

        .options {
            list-style: none;
        }

        .options li {
            margin: 10px 0;
        }

        .options input[type="radio"] {
            margin-right: 10px;
        }

        .options label {
            cursor: pointer;
            padding: 10px;
            border-radius: 5px;
            display: block;
            transition: background 0.3s;
        }

        .options label:hover {
            background: #f0f8ff;
        }

        .violation-log {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            max-height: 200px;
            overflow-y: auto;
            padding: 10px;
        }

        .violation-item {
            padding: 5px 0;
            border-bottom: 1px solid #eee;
            font-size: 12px;
            color: #666;
        }

        .hidden { display: none; }
        
        .fullscreen-warning {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,0,0,0.9);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            z-index: 9999;
        }

        .navigation-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }

        .quiz-info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔒 Proctored Quiz System</h1>
            <p>Learn with Integrity - Ensuring Fair Assessment</p>
            <div class="user-info">
                <span>👤 User: <%= username %> | Role: <%= userRole %> | Course: <%= courseId %></span>
            </div>
        </div>
        
        <div class="content">
            <div class="left-panel">
                <!-- Permission Screen -->
                <div id="permissionScreen" class="permission-screen">
                    <h2>Quiz Proctoring Setup</h2>
                    <div class="quiz-info">
                        <h3>Quiz Information:</h3>
                        <ul>
                            <li><strong>Total Questions:</strong> <%= questions.size() %></li>
                            <li><strong>Time Limit:</strong> 30 minutes</li>
                            <li><strong>Topic ID:</strong> <%= topicId %></li>
                        </ul>
                    </div>
                    <div class="permission-list">
                        <h3>Required Permissions & Rules:</h3>
                        <ul>
                            <li>📹 Webcam access for identity verification</li>
                            <li>🎯 Face detection for continuous monitoring</li>
                            <li>🔍 Tab switch detection</li>
                            <li>⚠️ Alert system for violations</li>
                            <li>🚫 Fullscreen mode enforcement</li>
                            <li>⏰ Auto-submission when time expires</li>
                        </ul>
                        <p><strong>Note:</strong> You must remain visible to the camera throughout the quiz. Any violations will be logged and may affect your score.</p>
                    </div>
                    <button class="btn" onclick="startProctoring()">Start Proctored Quiz</button>
                    <button class="btn btn-danger" onclick="goBack()" style="margin-left: 10px;">Cancel</button>
                </div>

                <!-- Quiz Screen -->
                <div id="quizContainer" class="quiz-container">
                    <form id="quizForm" method="post" action="SubmitQuizServlet">
                        <input type="hidden" name="topic_id" value="<%= topicId %>">
                        <input type="hidden" name="course_id" value="<%= courseId %>">
                        <input type="hidden" name="username" value="<%= username %>">
                        <input type="hidden" name="violations" id="violationsInput">
                        <input type="hidden" name="quiz_start_time" id="quizStartTime">
                        <input type="hidden" name="quiz_end_time" id="quizEndTime">
                        
                        <div class="question-card">
                            <div class="question-header">
                                <h3 id="questionCounter">Question 1 of <%= questions.size() %></h3>
                                <div class="timer" id="timer">Time: 30:00</div>
                            </div>
                            <div id="questionContent">
                                <!-- Questions will be loaded dynamically -->
                            </div>
                            <div class="navigation-buttons">
                                <button type="button" class="btn" id="prevBtn" onclick="previousQuestion()" disabled>Previous</button>
                                <button type="button" class="btn" id="nextBtn" onclick="nextQuestion()">Next</button>
                                <button type="button" class="btn btn-danger" id="submitBtn" onclick="submitQuiz()" style="display: none;">Submit Quiz</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="right-panel">
                <h3>Proctoring Status</h3>
                
                <div class="webcam-container">
                    <video id="videoElement" autoplay muted></video>
                    <canvas id="canvasElement" style="display: none;"></canvas>
                </div>

                <div id="statusPanel">
                    <div style="margin: 10px 0;">
                        <span class="status-indicator status-error" id="cameraStatus"></span>
                        <span>Camera: <span id="cameraText">Disconnected</span></span>
                    </div>
                    <div style="margin: 10px 0;">
                        <span class="status-indicator status-error" id="faceStatus"></span>
                        <span>Face Detection: <span id="faceText">Not Started</span></span>
                    </div>
                    <div style="margin: 10px 0;">
                        <span class="status-indicator status-good" id="tabStatus"></span>
                        <span>Tab Focus: <span id="tabText">Active</span></span>
                    </div>
                </div>

                <div style="margin-top: 20px;">
                    <h4>Violation Log</h4>
                    <div class="violation-log" id="violationLog">
                        <div class="violation-item">System initialized - Ready for monitoring</div>
                    </div>
                </div>

                <div style="margin-top: 20px;">
                    <h4>Progress</h4>
                    <div id="progressInfo">
                        <div>Questions Answered: <span id="answeredCount">0</span>/<%= questions.size() %></div>
                        <div>Current Question: <span id="currentQuestionNum">1</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Fullscreen Warning -->
    <div id="fullscreenWarning" class="fullscreen-warning hidden">
        <div>
            <h2>⚠️ QUIZ VIOLATION DETECTED</h2>
            <p>You have exited fullscreen mode. Click to continue the quiz.</p>
        </div>
    </div>

    <!-- Face-API.js CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/face-api.js/0.22.2/face-api.min.js"></script>

    <script>
        let video, canvas, ctx;
        let faceDetectionInterval;
        let violations = [];
        let quizStarted = false;
        let currentQuestion = 0;
        let totalQuestions = <%= questions.size() %>;
        let timeRemaining = 1800; // 30 minutes in seconds
        let timerInterval;
        let isFullscreen = false;
        let answeredQuestions = new Set();

        // Questions from JSP
        const questions = [
            <% for (int i = 0; i < questions.size(); i++) { 
                Map<String, Object> q = questions.get(i);
            %>
            {
                id: <%= q.get("id") %>,
                question: "<%= q.get("question_text").toString().replace("\"", "\\\"") %>",
                options: [
                    "<%= q.get("option_a").toString().replace("\"", "\\\"") %>",
                    "<%= q.get("option_b").toString().replace("\"", "\\\"") %>",
                    "<%= q.get("option_c").toString().replace("\"", "\\\"") %>",
                    "<%= q.get("option_d").toString().replace("\"", "\\\"") %>"
                ],
                correct: "<%= q.get("correct_option") %>",
                difficulty: "<%= q.get("difficulty") %>"
            }<%= i < questions.size() - 1 ? "," : "" %>
            <% } %>
        ];

        async function startProctoring() {
            try {
                // Set quiz start time
                document.getElementById('quizStartTime').value = new Date().toISOString();
                
                // Request camera permission
                const stream = await navigator.mediaDevices.getUserMedia({ 
                    video: { width: 640, height: 480 } 
                });
                
                video = document.getElementById('videoElement');
                canvas = document.getElementById('canvasElement');
                ctx = canvas.getContext('2d');
                
                video.srcObject = stream;
                video.play();

                // Update status
                updateStatus('camera', 'good', 'Connected');
                logViolation('Camera access granted');

                // Load face detection models
                await loadFaceModels();
                
                // Hide permission screen and show quiz
                document.getElementById('permissionScreen').style.display = 'none';
                document.getElementById('quizContainer').style.display = 'block';
                
                // Enter fullscreen mode
                enterFullscreen();
                
                // Start monitoring
                startMonitoring();
                startTimer();
                loadQuestion(0);
                quizStarted = true;

            } catch (error) {
                console.error('Error accessing camera:', error);
                alert('Camera access is required for this proctored quiz. Please allow camera access and try again.');
                logViolation('Camera access denied');
            }
        }

        async function loadFaceModels() {
            try {
                logViolation('Loading face detection models...');
                
                // Load face detection models from CDN
                await faceapi.nets.tinyFaceDetector.loadFromUri('https://cdnjs.cloudflare.com/ajax/libs/face-api.js/0.22.2');
                
                updateStatus('face', 'good', 'Models Loaded');
                logViolation('Face detection models loaded successfully');
            } catch (error) {
                console.error('Error loading face models:', error);
                updateStatus('face', 'error', 'Model Load Failed');
                logViolation('Error: Failed to load face detection models');
            }
        }

        function startMonitoring() {
            // Face detection monitoring
            faceDetectionInterval = setInterval(async () => {
                if (!video || !quizStarted) return;

                try {
                    const detections = await faceapi.detectAllFaces(video, 
                        new faceapi.TinyFaceDetectorOptions({ 
                            inputSize: 416, 
                            scoreThreshold: 0.5 
                        })
                    );

                    if (detections.length === 0) {
                        updateStatus('face', 'error', 'No Face Detected');
                        logViolation('VIOLATION: No face detected in camera');
                        showAlert('⚠️ No face detected! Please stay in front of the camera.', 'warning');
                    } else if (detections.length > 1) {
                        updateStatus('face', 'error', 'Multiple Faces');
                        logViolation('VIOLATION: Multiple faces detected');
                        showAlert('⚠️ Multiple faces detected! Only one person is allowed.', 'error');
                    } else {
                        updateStatus('face', 'good', 'Face Detected');
                    }
                } catch (error) {
                    console.error('Face detection error:', error);
                    updateStatus('face', 'warning', 'Detection Error');
                }
            }, 3000); // Check every 3 seconds

            // Tab switch detection
            document.addEventListener('visibilitychange', handleTabSwitch);
            
            // Prevent right-click and key combinations
            document.addEventListener('contextmenu', e => e.preventDefault());
            document.addEventListener('keydown', handleKeyDown);

            // Fullscreen monitoring
            document.addEventListener('fullscreenchange', handleFullscreenChange);
        }

        function loadQuestion(index) {
            if (index >= questions.length || index < 0) return;

            currentQuestion = index;
            const q = questions[index];
            
            document.getElementById('questionCounter').textContent = 
                `Question ${index + 1} of ${totalQuestions}`;
            
            const questionHTML = `
                <h4>${q.question}</h4>
                <ul class="options">
                    ${q.options.map((option, i) => `
                        <li>
                            <input type="radio" id="q${q.id}_${i}" 
                                   name="question_${q.id}" 
                                   value="${String.fromCharCode(97+i)}"
                                   ${getSelectedAnswer(q.id) === String.fromCharCode(97+i) ? 'checked' : ''}>
                            <label for="q${q.id}_${i}">${option}</label>
                        </li>
                    `).join('')}
                </ul>
            `;
            
            document.getElementById('questionContent').innerHTML = questionHTML;
            updateNavigationButtons();
            updateProgress();
        }

        function getSelectedAnswer(questionId) {
            const radios = document.getElementsByName(`question_${questionId}`);
            for (let radio of radios) {
                if (radio.checked) {
                    return radio.value;
                }
            }
            return '';
        }

        function updateNavigationButtons() {
            document.getElementById('prevBtn').disabled = currentQuestion === 0;
            
            if (currentQuestion === totalQuestions - 1) {
                document.getElementById('nextBtn').style.display = 'none';
                document.getElementById('submitBtn').style.display = 'inline-block';
            } else {
                document.getElementById('nextBtn').style.display = 'inline-block';
                document.getElementById('submitBtn').style.display = 'none';
            }
        }

        function updateProgress() {
            const answered = countAnsweredQuestions();
            document.getElementById('answeredCount').textContent = answered;
            document.getElementById('currentQuestionNum').textContent = currentQuestion + 1;
        }

        function countAnsweredQuestions() {
            let count = 0;
            questions.forEach(q => {
                if (getSelectedAnswer(q.id) !== '') {
                    count++;
                }
            });
            return count;
        }

        function nextQuestion() {
            if (currentQuestion < totalQuestions - 1) {
                loadQuestion(currentQuestion + 1);
            }
        }

        function previousQuestion() {
            if (currentQuestion > 0) {
                loadQuestion(currentQuestion - 1);
            }
        }

        function handleTabSwitch() {
            if (document.hidden && quizStarted) {
                updateStatus('tab', 'error', 'Tab Switched');
                logViolation('VIOLATION: User switched tabs or minimized window');
                showAlert('⚠️ Tab switching detected! This is a violation.', 'error');
            } else {
                updateStatus('tab', 'good', 'Active');
            }
        }

        function handleKeyDown(e) {
            // Prevent common shortcuts
            if (e.key === 'F12' || 
                (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'C')) ||
                (e.ctrlKey && e.key === 'u') ||
                (e.altKey && e.key === 'Tab')) {
                e.preventDefault();
                logViolation('VIOLATION: Attempted to use forbidden keyboard shortcut');
                showAlert('⚠️ Keyboard shortcut blocked!', 'warning');
            }
        }

        function enterFullscreen() {
            if (document.documentElement.requestFullscreen) {
                document.documentElement.requestFullscreen();
            }
            isFullscreen = true;
        }

        function handleFullscreenChange() {
            if (!document.fullscreenElement && quizStarted) {
                isFullscreen = false;
                document.getElementById('fullscreenWarning').classList.remove('hidden');
                logViolation('VIOLATION: Exited fullscreen mode');
            } else {
                isFullscreen = true;
                document.getElementById('fullscreenWarning').classList.add('hidden');
            }
        }

        function startTimer() {
            timerInterval = setInterval(() => {
                timeRemaining--;
                const minutes = Math.floor(timeRemaining / 60);
                const seconds = timeRemaining % 60;
                document.getElementById('timer').textContent = 
                    `Time: ${minutes}:${seconds.toString().padStart(2, '0')}`;

                if (timeRemaining <= 0) {
                    logViolation('Quiz auto-submitted due to time expiry');
                    submitQuiz();
                }
            }, 1000);
        }

        function submitQuiz() {
            // Set end time
            document.getElementById('quizEndTime').value = new Date().toISOString();
            
            // Set violations data
            document.getElementById('violationsInput').value = JSON.stringify(violations);
            
            // Stop monitoring
            clearInterval(faceDetectionInterval);
            clearInterval(timerInterval);
            quizStarted = false;

            // Stop video stream
            if (video && video.srcObject) {
                video.srcObject.getTracks().forEach(track => track.stop());
            }

            // Exit fullscreen
            if (document.exitFullscreen) {
                document.exitFullscreen();
            }

            // Submit the form
            document.getElementById('quizForm').submit();
        }

        function updateStatus(type, status, text) {
            const statusElement = document.getElementById(type + 'Status');
            const textElement = document.getElementById(type + 'Text');
            
            statusElement.className = `status-indicator status-${status}`;
            textElement.textContent = text;
        }

        function logViolation(message) {
            const timestamp = new Date().toLocaleTimeString();
            violations.push({ timestamp, message });
            
            const logElement = document.getElementById('violationLog');
            const violationItem = document.createElement('div');
            violationItem.className = 'violation-item';
            violationItem.textContent = `${timestamp}: ${message}`;
            logElement.appendChild(violationItem);
            
            // Scroll to bottom
            logElement.scrollTop = logElement.scrollHeight;
        }

        function showAlert(message, type) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.alert');
            existingAlerts.forEach(alert => alert.remove());

            // Create new alert
            const alert = document.createElement('div');
            alert.className = `alert alert-${type}`;
            alert.textContent = message;
            
            document.querySelector('.left-panel').insertBefore(alert, 
                document.querySelector('.left-panel').firstChild);

            // Remove alert after 5 seconds
            setTimeout(() => {
                alert.remove();
            }, 5000);
        }

        function goBack() {
            window.location.href = 'mycourses.jsp';
        }

        // Click to dismiss fullscreen warning
        document.getElementById('fullscreenWarning').addEventListener('click', () => {
            enterFullscreen();
        });

        // Prevent page unload without confirmation
        window.addEventListener('beforeunload', function(e) {
            if (quizStarted) {
                e.preventDefault();
                e.returnValue = '';
                logViolation('VIOLATION: Attempted to leave page during quiz');
            }
        });

        // Initialize
        document.addEventListener('DOMContentLoaded', () => {
            console.log('Quiz Proctor System initialized for <%= username %>');
        });
    </script>
</body>
</html>