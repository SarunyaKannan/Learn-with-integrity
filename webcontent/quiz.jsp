<!-- index.jsp --
<html>
<head><title>LCM Quiz</title></head>
<body>
<h2>Select Difficulty Level</h2>
<form action="quiz" method="post">
    <button name="level" value="easy">Attempt Easy Quiz</button>
    <button name="level" value="intermediate">Attempt Intermediate Quiz</button>
    <button name="level" value="hard">Attempt Hard Quiz</button>
</form>
</body>
</html>
-->
<%-- --%<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="Module1.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");

 //   if (username == null || email == null) {
   //     response.sendRedirect("login.jsp");
   //     return;
   // }

    int numQuestions = level.equals("EASY") ? 5 : (level.equals("INTERMEDIATE") ? 10 : 15);
    int timeLimit = level.equals("EASY") ? 5 : (level.equals("INTERMEDIATE") ? 10 : 15);

    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM question_bank WHERE topic_id=? AND level=? ORDER BY RAND() LIMIT ?")) {
        ps.setString(1, courseId);
        ps.setString(2, level);
        ps.setInt(3, numQuestions);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("question", rs.getString("question"));
            q.put("optionA", rs.getString("optionA"));
            q.put("optionB", rs.getString("optionB"));
            q.put("optionC", rs.getString("optionC"));
            q.put("optionD", rs.getString("optionD"));
            q.put("answer", rs.getString("answer"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= level %> Quiz</title>
    <script>
        let timeLeft = <%= timeLimit %> * 60;
        function startTimer() {
            let timer = setInterval(function() {
                let minutes = Math.floor(timeLeft / 60);
                let seconds = timeLeft % 60;
                document.getElementById("timer").innerText = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                timeLeft--;
                if (timeLeft < 0) {
                    clearInterval(timer);
                    document.getElementById("quizForm").submit();
                }
            }, 1000);
        }
    </script>
</head>
<body onload="startTimer()">
    <h1><%= level %> Quiz</h1>
    <p>Time Left: <span id="timer"></span></p>
    <form id="quizForm" method="post" action="QuizSubmitServlet">
        <input type="hidden" name="level" value="<%= level %>">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        <% int i=1; for(Map<String,String> q : questions) { %>
            <div>
                <p><b>Q<%=i%>. <%= q.get("question") %></b></p>
                <input type="radio" name="q<%=q.get("id")%>" value="A"> <%= q.get("optionA") %><br>
                <input type="radio" name="q<%=q.get("id")%>" value="B"> <%= q.get("optionB") %><br>
                <input type="radio" name="q<%=q.get("id")%>" value="C"> <%= q.get("optionC") %><br>
                <input type="radio" name="q<%=q.get("id")%>" value="D"> <%= q.get("optionD") %><br>
            </div>
            <hr>
        <% i++; } %>
        <button type="submit">Submit Quiz</button>
    </form>
</body>
</html>  --
<%@ page import="java.sql.*, java.util.*, Module1.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");

    int numQuestions = 0;
    if ("EASY".equals(level)) numQuestions = 5;
    else if ("INTERMEDIATE".equals(level)) numQuestions = 10;
    else if ("HARD".equals(level)) numQuestions = 15;

    List<Map<String, String>> questions = new ArrayList<>();

    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM question_bank WHERE topic_id=? AND difficulty=? ORDER BY RAND() LIMIT ?")) {
        ps.setString(1, courseId);
        ps.setString(2, level.toLowerCase()); // db stores as 'easy','intermediate','hard'
        ps.setInt(3, numQuestions);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("question_text", rs.getString("question_text"));
            q.put("option_a", rs.getString("option_a"));
            q.put("option_b", rs.getString("option_b"));
            q.put("option_c", rs.getString("option_c"));
            q.put("option_d", rs.getString("option_d"));
            q.put("correct_option", rs.getString("correct_option"));
            questions.add(q);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<video id="webcam" width="250" height="200" autoplay muted playsinline style="border:2px solid red;"></video>
<script>
window.onload = () => {
    startTimer();
    initWebcam();
}
</script>

<div style="position: fixed; top: 10px; right: 20px; font-size: 20px; font-weight: bold;">
    Time Left: <span id="timer"></span>
</div>

<h1>Quiz - <%= level %> Level</h1>
<form method="post" action="SubmitQuizServlet">
    <input type="hidden" name="courseId" value="<%= courseId %>">
    <input type="hidden" name="level" value="<%= level %>">

    <ol>
    <%
        int qNo = 1;
        for (Map<String, String> q : questions) {
    %>
        <li>
            <p><%= q.get("question_text") %></p>
            <label><input type="radio" name="q<%=qNo%>" value="A"> <%= q.get("option_a") %></label><br>
            <label><input type="radio" name="q<%=qNo%>" value="B"> <%= q.get("option_b") %></label><br>
            <label><input type="radio" name="q<%=qNo%>" value="C"> <%= q.get("option_c") %></label><br>
            <label><input type="radio" name="q<%=qNo%>" value="D"> <%= q.get("option_d") %></label>
            <input type="hidden" name="qid<%=qNo%>" value="<%= q.get("id") %>">
        </li>
    <%
            qNo++;
        }
    %>
    </ol>

    <button type="submit">Submit Quiz</button>
</form>
<script>
let totalSeconds = 
    "<%= "EASY".equals(level) ? 5*60 : ("INTERMEDIATE".equals(level) ? 10*60 : 15*60) %>";

function startTimer() {
    let timerDisplay = document.getElementById("timer");
    let form = document.getElementById("quizForm");

    let countdown = setInterval(function() {
        let minutes = Math.floor(totalSeconds / 60);
        let seconds = totalSeconds % 60;
        timerDisplay.textContent = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;

        if (totalSeconds <= 0) {
            clearInterval(countdown);
            alert("⏰ Time is up! Submitting quiz...");
            form.submit();
        }
        totalSeconds--;
    }, 1000);
}
window.onload = startTimer;
</script>
<script defer src="https://unpkg.com/face-api.js"></script>
<script>
let warningCount = 0;

async function initWebcam() {
    const video = document.getElementById("webcam");
    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;
        });

    await faceapi.nets.tinyFaceDetector.loadFromUri('/models'); // need models folder
    detectFaces();
}

async function detectFaces() {
    const video = document.getElementById("webcam");

    setInterval(async () => {
        const detections = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions());
        
        if (detections.length !== 1) { 
            warningCount++;
            alert("⚠️ Face not detected properly! Warning " + warningCount + "/3");
            
            if (warningCount >= 3) {
                alert("🚨 Multiple violations! Submitting quiz.");
                document.getElementById("quizForm").submit();
            }
        }
    }, 5000); // check every 5s
}
</script>
<script>
let tabWarnings = 0;
document.addEventListener("visibilitychange", function() {
    if (document.hidden) {
        tabWarnings++;
        alert("⚠️ Tab switch detected! " + tabWarnings + "/3");
        if (tabWarnings >= 3) {
            alert("🚨 Auto-submitting due to tab switch.");
            document.getElementById("quizForm").submit();
        }
    }
});
</script>
  --
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Page</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; margin: 0; padding: 0; }
        .quiz-container { max-width: 900px; margin: auto; background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px #ccc; }
        #timer { font-size: 18px; font-weight: bold; margin-bottom: 15px; color: red; }
        video { border: 2px solid #333; border-radius: 8px; width: 300px; height: 200px; }
        .question { margin: 15px 0; }
        button { background: green; color: #fff; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background: darkgreen; }
    </style>

    <!-- Load TF.js + face-api.js + coco-ssd for object detection -->
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@3.9.0"></script>
    <script src="https://cdn.jsdelivr.net/npm/face-api.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd"></script>

    <!-- Monitoring Script -->
    <script src="JS/exam-monitor.js"></script>
</head>
<body>
<div class="quiz-container">
    <h2>Quiz in Progress</h2>
    <div id="timer">Loading timer...</div>

    <!-- Webcam -->
    <video id="webcam" autoplay muted></video>

    <!-- Quiz Form -->
    <form id="quizForm" method="post" action="SubmitQuizServlet">
        <div class="question">
            <p>Q1. 5 + 7 = ?</p>
            <input type="radio" name="q1" value="10"> 10 <br>
            <input type="radio" name="q1" value="12"> 12 <br>
            <input type="radio" name="q1" value="14"> 14 <br>
        </div>

        <div class="question">
            <p>Q2. Capital of India?</p>
            <input type="radio" name="q2" value="Mumbai"> Mumbai <br>
            <input type="radio" name="q2" value="Delhi"> Delhi <br>
            <input type="radio" name="q2" value="Kolkata"> Kolkata <br>
        </div>

        <button type="submit">Submit Quiz</button>
    </form>
</div>
</body>
</html>
  --
  <%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");

    int questionLimit = level.equals("EASY") ? 5 : level.equals("INTERMEDIATE") ? 10 : 15;

    List<Map<String, String>> questions = new ArrayList<>();

    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question_bank WHERE difficulty=? ORDER BY RAND() LIMIT ?")) {
        ps.setString(1, level.toLowerCase());
        ps.setInt(2, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Quiz</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f9f9f9; }
        .quiz-container { max-width:900px; margin:auto; background:#fff; padding:20px; border-radius:10px; box-shadow:0 0 10px #ccc; }
        #timer { font-size:18px; color:red; margin-bottom:15px; }
        video { width:300px; height:200px; border:2px solid #333; border-radius:8px; margin-bottom:10px; }
        .question { margin:15px 0; }
    </style>

    <!-- TF.js + face-api.js + coco-ssd -->
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@3.9.0"></script>
    <script src="https://cdn.jsdelivr.net/npm/face-api.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd"></script>

    <!-- Monitoring Script -->
    <script src="JS/exam-monitor.js"></script>
</head>
<body>
<div class="quiz-container">
    <h2>Quiz: <%= level %> Level</h2>
    <div id="timer">Loading timer...</div>

    <!-- Webcam -->
    <video id="webcam" autoplay muted></video>

    <!-- Quiz Form -->
    <form id="quizForm" method="post" action="QuizSubmitServlet">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        <input type="hidden" name="level" value="<%= level %>">

        <% int qNo = 1; for (Map<String, String> q : questions) { %>
            <div class="question">
                <p><%= qNo++ %>. <%= q.get("text") %></p>
                <label><input type="radio" name="q<%= q.get("id") %>" value="A"> <%= q.get("a") %></label><br>
                <label><input type="radio" name="q<%= q.get("id") %>" value="B"> <%= q.get("b") %></label><br>
                <label><input type="radio" name="q<%= q.get("id") %>" value="C"> <%= q.get("c") %></label><br>
                <label><input type="radio" name="q<%= q.get("id") %>" value="D"> <%= q.get("d") %></label>
            </div>
        <% } %>

        <button type="submit">Submit</button>
    </form>
</div>

<script>
    // Timer setup
    let totalSeconds = <%= level.equals("EASY") ? 5*60 : level.equals("INTERMEDIATE") ? 10*60 : 15*60 %>;
    const timerElem = document.getElementById("timer");
    const interval = setInterval(() => {
        let minutes = Math.floor(totalSeconds / 60);
        let seconds = totalSeconds % 60;
        timerElem.textContent = `${minutes}:${seconds < 10 ? '0'+seconds : seconds}`;
        totalSeconds--;
        if (totalSeconds < 0) {
            clearInterval(interval);
            alert("Time's up!");
            document.getElementById("quizForm").submit();
        }
    }, 1000);
</script>
</body>
</html>  --%>



<%--For full quiz 2nd hour change  --%

<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;

    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question_bank WHERE difficulty=? ORDER BY RAND() LIMIT ?")) {
        ps.setString(1, level.toLowerCase());
        ps.setInt(2, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Quiz - <%= level %></title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
    .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
    #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
    #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
    #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
    #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
    .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
    .question p{margin:0 0 8px 0}
    .question label{display:block;margin:4px 0;color:#ddd}
    #quizForm{display:none}
    #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer}
  </style>

  <!-- libs -->
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@3.9.0"></script>
  <script src="https://cdn.jsdelivr.net/npm/face-api.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd"></script>

  <!-- your monitoring script -->
  <script src="JS/exam-monitor.js"></script>
</head>
<body>
  <%@ include file="navbar.jsp" %>

  <div class="container">
    <h2>Quiz: <%= level %> level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <!-- Timer element used by exam-monitor.js if present -->
    <div id="examTimer">Timer will appear here</div>

    <!-- video element used by exam-monitor.js (it will use it if present) -->
    <video id="monitorVideo" autoplay muted playsinline></video>

    <!-- user must click this button to start camera + fullscreen + monitoring -->
    <div style="margin:12px 0;">
      <button id="beginBtn">Enable Camera & Start Quiz</button>
      <button id="forceSubmitBtn" style="display:none">Force Submit</button>
    </div>

    <!-- quiz form (hidden until monitoring started). exam-monitor will auto-submit this form on violations/time -->
    <form id="quizForm" method="post" action="QuizSubmitServlet">
      <input type="hidden" name="courseId" value="<%= courseId %>">
      <input type="hidden" name="level" value="<%= level %>">
      <!-- tab_switches & autoSubmitted will be appended by exam-monitor.js when needed -->

      <% int qNo=1;
         for (Map<String,String> q : questions) { %>
        <div class="question">
          <p><strong>Q<%= qNo++ %>. </strong><%= q.get("text") %></p>
          <label><input type="radio" name="q<%= q.get("id") %>" value="A"> <%= q.get("a") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="B"> <%= q.get("b") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="C"> <%= q.get("c") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="D"> <%= q.get("d") %></label>
        </div>
      <% } %>

      <div style="margin-top:10px;">
         <button type="submit" id="manualSubmitBtn">Submit Quiz</button>
      </div>
    </form>
  </div>

<script>
  const MODELS_URI = '<%= request.getContextPath() %>/models';
  const COURSE_ID = '<%= courseId %>';
  const LEVEL = '<%= level %>';
  const DURATION = <%= durationSec %>;

  const beginBtn = document.getElementById('beginBtn');
  const forceSubmitBtn = document.getElementById('forceSubmitBtn');

  beginBtn.addEventListener('click', async function() {
    beginBtn.disabled = true;
    try {
      // 1) Ask camera permission (user gesture)
      await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' }, audio: false });
    } catch (err) {
      alert('Camera permission is required to start the quiz. Please allow camera access.');
      beginBtn.disabled = false;
      return;
    }

    // 2) Enter fullscreen (still inside user gesture)
    try {
      if (document.documentElement.requestFullscreen) await document.documentElement.requestFullscreen();
      else if (document.documentElement.webkitRequestFullscreen) document.documentElement.webkitRequestFullscreen();
      else if (document.documentElement.msRequestFullscreen) document.documentElement.msRequestFullscreen();
    } catch (err) {
      alert('Failed entering fullscreen. Please allow fullscreen mode.');
      beginBtn.disabled = false;
      return;
    }

    // 3) Initialize monitoring (initExam returns a controller object)
    try {
      // initExam will request models from MODELS_URI and attach stream to #monitorVideo
      const controller = await initExam({
        courseId: COURSE_ID,
        level: LEVEL,
        durationSeconds: DURATION,
        maxTabSwitches: 3,
        formId: 'quizForm',
        modelsUri: MODELS_URI
      });

      // show quiz form and Force Submit button
      document.getElementById('quizForm').style.display = 'block';
      forceSubmitBtn.style.display = 'inline-block';
      beginBtn.style.display = 'none';

      // Wire manual force submit (will be handled by exam-monitor if violations occur)
      forceSubmitBtn.addEventListener('click', function() {
        // call controller stop + submit
        if (controller && typeof controller.stop === 'function') controller.stop();
        document.getElementById('quizForm').submit();
      });

    } catch (e) {
      console.error(e);
      alert('Failed to start monitoring: ' + (e.message || e));
      beginBtn.disabled = false;
    }
  });
  
  
  <
  document.addEventListener("DOMContentLoaded", function() {
      initExam({
          courseId: "<%= courseId %>",
          level: "<%= request.getParameter("level") %>",
          durationSeconds: 300,
          maxTabSwitches: 3,
          formId: "quizForm",
          modelsUri: "models/"   // folder where you put face-api models
      });
  });
  </script>

</script>
</body>
</html>

  --%><%--Thursday  --%>
  <%-- --%
  <%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;

    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question_bank WHERE difficulty=? ORDER BY RAND() LIMIT ?")) {
        ps.setString(1, level.toLowerCase());
        ps.setInt(2, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Quiz - <%= level %></title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
    .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
    #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
    #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
    #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
    #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
    .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
    .question p{margin:0 0 8px 0}
    .question label{display:block;margin:4px 0;color:#ddd}
    #quizForm{display:none}
    #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
  </style>

  <!-- libs -->
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@3.9.0"></script>
  <script src="https://cdn.jsdelivr.net/npm/face-api.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd"></script>

  <!-- monitoring script -->
  <script src="JS/exam-monitor.js"></script>
</head>
<body>
  <%@ include file="navbar.jsp" %>

  <div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
      <button id="beginBtn">Enable Camera & Start Quiz</button>
      <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <form id="quizForm" method="post" action="QuizSubmitServlet">
      <input type="hidden" name="courseId" value="<%= courseId %>">
      <input type="hidden" name="level" value="<%= level %>">
      <% int qNo=1;
         for (Map<String,String> q : questions) { %>
        <div class="question">
          <p><strong>Q<%= qNo++ %>. </strong><%= q.get("text") %></p>
          <label><input type="radio" name="q<%= q.get("id") %>" value="A"> <%= q.get("a") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="B"> <%= q.get("b") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="C"> <%= q.get("c") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="D"> <%= q.get("d") %></label>
        </div>
      <% } %>
      <div style="margin-top:10px;">
        <button type="submit" id="manualSubmitBtn">Submit Quiz</button>
      </div>
    </form>
  </div>

<script>
  const MODELS_URI = '<%= request.getContextPath() %>/models';
  const COURSE_ID = '<%= courseId %>';
  const LEVEL = '<%= level %>';
  const DURATION = <%= durationSec %>;

  const beginBtn = document.getElementById('beginBtn');
  const forceSubmitBtn = document.getElementById('forceSubmitBtn');

  beginBtn.addEventListener('click', async function() {
    beginBtn.disabled = true;
    try {
      // 1) Ask camera permission
    //  await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' } });
    } catch (err) {
      alert('Camera permission is required.');
      beginBtn.disabled = false;
      return;
    }

    // 2) Enter fullscreen
    try {
      if (document.documentElement.requestFullscreen) await document.documentElement.requestFullscreen();
    } catch (err) {
      alert('Fullscreen required.');
      beginBtn.disabled = false;
      return;
    }

    // 3) Init monitoring
    try {
      const controller = await initExam({
        courseId: COURSE_ID,
        level: LEVEL,
        durationSeconds: DURATION,
        maxTabSwitches: 3,
        formId: 'quizForm',
        modelsUri: MODELS_URI
      });

      document.getElementById('quizForm').style.display = 'block';
      forceSubmitBtn.style.display = 'inline-block';
      beginBtn.style.display = 'none';

      forceSubmitBtn.addEventListener('click', function() {
        if (controller && typeof controller.stop === 'function') controller.stop();
        document.getElementById('quizForm').submit();
      });

    } catch (e) {
      alert('Monitoring failed: ' + (e.message || e));
      beginBtn.disabled = false;
    }
  });
</script>
</body>
</html>  --%><%-- --
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;

    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question WHERE difficulty=? ORDER BY RAND() LIMIT ?")) {
        ps.setString(1, level.toLowerCase());
        ps.setInt(2, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Quiz - <%= level %></title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
    .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
    #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
    #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
    #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
    #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
    .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
    .question p{margin:0 0 8px 0}
    .question label{display:block;margin:4px 0;color:#ddd}
    #quizForm{display:none}
    #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
  </style>

  <!-- libs (order matters) -->
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@3.9.0"></script>
  <script src="https://cdn.jsdelivr.net/npm/face-api.js" defer></script>
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>

  <!-- monitoring script must load AFTER face-api.js -->
  <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
  <%@ include file="navbar.jsp" %>

  <div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
      <button id="beginBtn">Enable Camera & Start Quiz</button>
      <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <form id="quizForm" method="post" action="QuizSubmitServlet">
      <input type="hidden" name="courseId" value="<%= courseId %>">
      <input type="hidden" name="level" value="<%= level %>">
      <% int qNo=1;
         for (Map<String,String> q : questions) { %>
        <div class="question">
          <p><strong>Q<%= qNo++ %>. </strong><%= q.get("text") %></p>
          <label><input type="radio" name="q<%= q.get("id") %>" value="A"> <%= q.get("a") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="B"> <%= q.get("b") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="C"> <%= q.get("c") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="D"> <%= q.get("d") %></label>
        </div>
      <% } %>
      <div style="margin-top:10px;">
        <button type="submit" id="manualSubmitBtn">Submit Quiz</button>
      </div>
    </form>
  </div>

<script>
  // Models folder path (copy your webcontent/models into WAR root)
  const MODELS_URI = '<%= request.getContextPath() %>/models';
  const COURSE_ID = '<%= courseId %>';
  const LEVEL = '<%= level %>';
  const DURATION = <%= durationSec %>;

  const beginBtn = document.getElementById('beginBtn');
  const forceSubmitBtn = document.getElementById('forceSubmitBtn');

  beginBtn.addEventListener('click', async function() {
    beginBtn.disabled = true;
    try {
      // 1) Enter fullscreen (must be user gesture)
      if (document.documentElement.requestFullscreen) await document.documentElement.requestFullscreen();
    } catch (err) {
      alert('Fullscreen required.');
      beginBtn.disabled = false;
      return;
    }

    // 2) Init monitoring (initExam will request camera permission ONCE)
    try {
      const controller = await window.initExam({
        courseId: COURSE_ID,
        level: LEVEL,
        durationSeconds: DURATION,
        maxTabSwitches: 3,
        formId: 'quizForm',
        modelsUri: MODELS_URI
      });

      // show form after monitoring started
      document.getElementById('quizForm').style.display = 'block';
      forceSubmitBtn.style.display = 'inline-block';
      beginBtn.style.display = 'none';

      forceSubmitBtn.addEventListener('click', function() {
        if (controller && typeof controller.stop === 'function') controller.stop();
        document.getElementById('quizForm').submit();
      });

    } catch (e) {
      alert('Monitoring failed: ' + (e.message || e));
      beginBtn.disabled = false;
    }
  });
</script>
</body>
</html>
--%><%-- --updating parllarly the tab switch according to the exam monitor  --%
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;

    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question_bank WHERE difficulty=? ORDER BY RAND() LIMIT ?")) {
        ps.setString(1, level.toLowerCase());
        ps.setInt(2, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Quiz - <%= level %></title>
  <style>
    body{font-family:Arial,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
    .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
    #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
    #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
    #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
    #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
    .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
    .question label{display:block;margin:4px 0;color:#ddd}
    #quizForm{display:none}
    #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
  </style>

  <!-- libs -->
  <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
  <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
 <%@ include file="navbar.jsp" %>
  <div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
      <button id="beginBtn">Enable Camera & Start Quiz</button>
      <button id="forceSubmitBtn">Force Submit</button>
    </div>
    <div>
    <form id="quizForm" method="post" action="QuizSubmitServlet">
  <input type="hidden" name="courseId" value="<%= courseId %>">
  <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
  <input type="hidden" name="level" value="<%= level %>">
  <% for(Map<String,String> q : questions){ %>
    <div class="question">
      <p><%= q.get("text") %></p>
      <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
      <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
      <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
      <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
    </div>
  <% } %>
</form>
    
    

  <%-- --<form id="quizForm" method="post" action="QuizSubmitServlet">
      <input type="hidden" name="courseId" value="<%= courseId %>">
      <input type="hidden" name="level" value="<%= level %>">  --%>
<%-- --%  <%     String courseTitle = "";
try (PreparedStatement cps = con.prepareStatement("SELECT title FROM courses WHERE id=?")) {
    cps.setString(1, courseId);
    ResultSet crs = cps.executeQuery();
    if (crs.next()) {
        courseTitle = crs.getString("title");
    }
    crs.close();
}
    %>  
      <% for(Map<String,String> q : questions){ %>
        <div class="question">
          <p><%= q.get("text") %></p>
          <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
        </div>
      <% } %>
    </form>  --%
  </div>

<script>

document.addEventListener("keydown", function (e) {
  if ((e.ctrlKey || e.metaKey) && (e.key === "c" || e.key === "v" || e.key === "x" || e.key === "a")) {
    e.preventDefault();
    alert("❌ Copy / Paste / Select All is not allowed during the quiz!");
  }
});

// Block right-click
document.addEventListener("contextmenu", function (e) {
  e.preventDefault();
  alert("❌ Right click is disabled during the quiz!");
});


(async function() {
  while (!window.faceapi) {
    await new Promise(r => setTimeout(r, 100));
  }

  const beginBtn = document.getElementById('beginBtn');
  const forceSubmitBtn = document.getElementById('forceSubmitBtn');

  beginBtn.addEventListener('click', async function() {
    beginBtn.disabled = true;
    try { await document.documentElement.requestFullscreen(); } catch(e){ alert('Fullscreen required'); beginBtn.disabled=false; return; }

    try {
      const controller = await window.initExam({
        courseId: '<%= courseId %>',
        level: '<%= level %>',
        durationSeconds: <%= durationSec %>,
        maxTabSwitches: 3,
        formId: 'quizForm',
        modelsUri: '<%= request.getContextPath() %>/models'
      });

      document.getElementById('quizForm').style.display = 'block';
      forceSubmitBtn.style.display = 'inline-block';
      beginBtn.style.display = 'none';

      forceSubmitBtn.addEventListener('click', function() {
        if (controller && controller.stop) controller.stop();
        document.getElementById('quizForm').submit();
      });

    } catch(e){
      alert('Monitoring failed: ' + e.message);
      beginBtn.disabled = false;
    }
  });
})();
</script>
</body>
</html>
<%--



<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;

    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question_bank WHERE difficulty=? ORDER BY RAND() LIMIT ?")) {
        ps.setString(1, level.toLowerCase());
        ps.setInt(2, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Quiz - <%= level %></title>
  <style>
    body{font-family:Arial,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
    .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
    #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
    #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
    #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
    #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
    .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
    .question label{display:block;margin:4px 0;color:#ddd}
    #quizForm{display:none;pointer-events:none;opacity:0.6} /* disabled initially */
    #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
    #examWarning{position:fixed;left:50%;top:50%;transform:translate(-50%,-50%);z-index:10000;
                 padding:12px 18px;background:rgba(255,255,0,0.95);color:#000;display:none;font-weight:bold}
  </style>

  <!-- libs -->
  <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
  <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
  <div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>
    <div id="examWarning"></div>

    <div style="margin:12px 0;">
      <button id="beginBtn">Enable Camera & Start Quiz</button>
      <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <form id="quizForm" method="post" action="QuizSubmitServlet">
      <input type="hidden" name="courseId" value="<%= courseId %>">
      <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
      <input type="hidden" name="level" value="<%= level %>">
      <% for(Map<String,String> q : questions){ %>
        <div class="question">
          <p><%= q.get("text") %></p>
          <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
        </div>
      <% } %>
    </form>
  </div>
</body>
</html>  --%
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get parameters or attributes
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");

    if (courseId == null && request.getAttribute("courseId") != null) {
        courseId = (String) request.getAttribute("courseId");
    }
    if (level == null && request.getAttribute("level") != null) {
        level = (String) request.getAttribute("level");
    }

    // Questions list (must be set by servlet)
    List<Map<String,String>> questions = (List<Map<String,String>>) request.getAttribute("questions");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Page</title>
    <script src="https://cdn.jsdelivr.net/npm/face-api.js"></script>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { max-width: 900px; margin: auto; padding: 20px; }
        .question { margin-bottom: 20px; }
        video { width: 300px; border: 1px solid #ccc; margin: 10px 0; }
        #examTimer { font-weight: bold; margin: 15px 0; color: red; }
    </style>
</head>
<body>
    <%-- <%@ include file="navbar.jsp" %> --%>
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
<%-- --%    
    
    
    <%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;
    int cid=Integer.parseInt(courseId);
    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question_bank WHERE topic_id =? and difficulty=? ORDER BY RAND() LIMIT ?")) {
      ps.setInt(1,cid);
    	ps.setString(2, level.toLowerCase());
        ps.setInt(3, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Quiz - <%= level %></title>
  <style>
    body{font-family:Arial,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
    .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
    #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
    #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
    #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
    #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
    .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
    .question label{display:block;margin:4px 0;color:#ddd}
    #quizForm{display:none}
    #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
  </style>

  <!-- libs -->
  <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
  <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
<%-- --% -<%@ include file="navbar.jsp" %>--%
  <div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
      <button id="beginBtn">Enable Camera & Start Quiz</button>
      <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <!-- ✅ only ONE quizForm -->
    <form id="quizForm" method="post" action="QuizSubmitServlet">
      <input type="hidden" name="courseId" value="<%= courseId %>">
      <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
      <input type="hidden" name="level" value="<%= level %>">
      <% for(Map<String,String> q : questions){ %>
        <div class="question">
          <p><%= q.get("text") %></p>
          <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
        </div>
      <% } %>
    </form>
    
    
    
    
    
  <div id="attemptBox" style="margin:15px 0; padding:10px; background:#0b0d3a; border-radius:8px;">
  <h3>📑 Your Attempts & Question Marks</h3>
  <table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse; background:#11134d; color:white;">
    <thead>
      <tr>
        <th>Level</th>
        <th>Attempts Made</th>
        <th>Free Attempts Allowed</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><%= level %></td>
        <td id="attemptCount">Loading...</td>
        <td>
          <%= "EASY".equalsIgnoreCase(level) ? 2 : 
              "INTERMEDIATE".equalsIgnoreCase(level) ? 3 : 4 %>
        </td>
      </tr>
    </tbody>
  </table>

  <h4 style="margin-top:15px;">✅ Marks per Question (Latest Attempt)</h4>
  <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse; background:#11134d; color:white;" id="questionMarksTable">
    <thead>
      <tr>
        <th>Question No.</th>
        <th>Marks</th>
      </tr>
    </thead>
    <tbody>
      <tr><td colspan="2">Loading...</td></tr>
    </tbody>
  </table>
</div>


 
    
  </div>

<script>

document.addEventListener("fullscreenchange", function() {
    if (!document.fullscreenElement) {
        // User exited fullscreen
        showFullscreenWarning();
    }
});

function showFullscreenWarning() {
    // Create a custom alert box with a button
    let warningBox = document.createElement("div");
    warningBox.id = "fullscreenWarning";
    warningBox.style.position = "fixed";
    warningBox.style.top = "0";
    warningBox.style.left = "0";
    warningBox.style.width = "100%";
    warningBox.style.height = "100%";
    warningBox.style.backgroundColor = "rgba(0,0,0,0.7)";
    warningBox.style.display = "flex";
    warningBox.style.flexDirection = "column";
    warningBox.style.justifyContent = "center";
    warningBox.style.alignItems = "center";
    warningBox.style.zIndex = "9999";

    warningBox.innerHTML = `
        <div style="background: white; padding: 20px; border-radius: 10px; text-align:center;">
            <h2>⚠️ Warning!</h2>
            <p>You must stay in fullscreen mode to continue the quiz.</p>
            <button onclick="goBackToFullscreen()" style="padding:10px 20px; font-size:16px; background:#007bff; color:white; border:none; border-radius:5px;">Go to Fullscreen</button>
        </div>
    `;

    document.body.appendChild(warningBox);
}

function goBackToFullscreen() {
    let elem = document.documentElement;
    if (elem.requestFullscreen) {
        elem.requestFullscreen();
    }
    // Remove warning box after going fullscreen
    let warningBox = document.getElementById("fullscreenWarning");
    if (warningBox) {
        warningBox.remove();
    }
}


document.addEventListener("keydown", function (e) {
  if ((e.ctrlKey || e.metaKey) && (["c","v","x","a"].includes(e.key))) {
    e.preventDefault();
    alert("❌ Copy / Paste / Select All is not allowed during the quiz!");
  }
});

// Block right-click
document.addEventListener("contextmenu", function (e) {
  e.preventDefault();
  alert("❌ Right click is disabled during the quiz!");
});

(async function() {
  while (!window.faceapi) {
    await new Promise(r => setTimeout(r, 100));
  }

  const beginBtn = document.getElementById('beginBtn');
  const forceSubmitBtn = document.getElementById('forceSubmitBtn');

  beginBtn.addEventListener('click', async function() {
    beginBtn.disabled = true;
    try { await document.documentElement.requestFullscreen(); } catch(e){ alert('Fullscreen required'); beginBtn.disabled=false; return; }

    try {
      const controller = await window.initExam({
        courseId: '<%= courseId %>',
        level: '<%= level %>',
        durationSeconds: <%= durationSec %>,
        maxTabSwitches: 3,
        formId: 'quizForm',
        modelsUri: '<%= request.getContextPath() %>/models'
      });

      document.getElementById('quizForm').style.display = 'block';
      forceSubmitBtn.style.display = 'inline-block';
      beginBtn.style.display = 'none';

      forceSubmitBtn.addEventListener('click', function() {
        if (controller && controller.stop) controller.stop();
        document.getElementById('quizForm').submit();
      });

    } catch(e){
      alert('Monitoring failed: ' + e.message);
      beginBtn.disabled = false;
    }
  });
})();
//Fetch attempt count and per-question marks
fetch(`QuizAttemptServlet?courseId=<%= courseId %>&level=<%= level %>`)
  .then(res => res.json())
  .then(data => {
    document.getElementById("attemptCount").innerText = data.attempts;

    const tbody = document.querySelector("#questionMarksTable tbody");
    tbody.innerHTML = ""; // clear loading row

    data.questions.forEach(q => {
      const tr = document.createElement("tr");
      tr.innerHTML = `<td>${q.questionNo}</td><td>${q.marks}</td>`;
      tbody.appendChild(tr);
    });
  })
  .catch(err => {
    document.getElementById("attemptCount").innerText = "Error";
    console.error(err);
  });

</script>
</body>
</html>--%




















<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;
    int cid = Integer.parseInt(courseId);

    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM question_bank WHERE topic_id = ? AND difficulty = ? ORDER BY RAND() LIMIT ?")) {
        ps.setInt(1, cid);
        ps.setString(2, level.toLowerCase());
        ps.setInt(3, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Quiz - <%= level %></title>
  <style>
    body{font-family:Arial,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
    .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
    #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
    #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
    #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
    #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
    .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
    .question label{display:block;margin:4px 0;color:#ddd}
    #quizForm{display:none}
    #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
  </style>

  <!-- libs -->
  <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
  <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
  <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
  <div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
      <button id="beginBtn">Enable Camera & Start Quiz</button>
      <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <!-- Quiz Form -->
    <form id="quizForm" method="post" action="QuizSubmitServlet">
      <input type="hidden" name="courseId" value="<%= courseId %>">
      <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
      <input type="hidden" name="level" value="<%= level %>">
      <% for(Map<String,String> q : questions){ %>
        <div class="question">
          <p><%= q.get("text") %></p>
          <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
          <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
        </div>
      <% } %>
    </form>

    <!-- Attempts & Marks -->
    <div id="attemptBox" style="margin:15px 0; padding:10px; background:#0b0d3a; border-radius:8px;">
  <h3>📑 Your Attempts & Question Marks</h3>
  <table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse; background:#11134d; color:white;">
    <thead>
      <tr>
        <th>Level</th>
        <th>Attempts Made</th>
        <th>Free Attempts Allowed</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><%= level %></td>
        <td id="attemptCount">Loading...</td>
        <td>
          <%= "EASY".equalsIgnoreCase(level) ? 2 : "INTERMEDIATE".equalsIgnoreCase(level) ? 3 : 4 %>
        </td>
      </tr>
    </tbody>
  </table>

  <h4 style="margin-top:15px;">✅ Marks per Question (Latest Attempt)</h4>
  <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse; background:#11134d; color:white;" id="questionMarksTable">
    <thead>
      <tr>
        <th>Question No.</th>
        <th>Marks</th>
      </tr>
    </thead>
    <tbody>
      <tr><td colspan="2">Loading...</td></tr>
    </tbody>
  </table>
</div>

  </div>

<script>
document.addEventListener("fullscreenchange", function() {
    if (!document.fullscreenElement) showFullscreenWarning();
});

function showFullscreenWarning() {
    let warningBox = document.createElement("div");
    warningBox.id = "fullscreenWarning";
    warningBox.style.position = "fixed";
    warningBox.style.top = "0"; warningBox.style.left = "0";
    warningBox.style.width = "100%"; warningBox.style.height = "100%";
    warningBox.style.backgroundColor = "rgba(0,0,0,0.7)";
    warningBox.style.display = "flex"; warningBox.style.flexDirection = "column";
    warningBox.style.justifyContent = "center"; warningBox.style.alignItems = "center";
    warningBox.style.zIndex = "9999";

    warningBox.innerHTML = `
        <div style="background: white; padding: 20px; border-radius: 10px; text-align:center;">
            <h2>⚠️ Warning!</h2>
            <p>You must stay in fullscreen mode to continue the quiz.</p>
            <button onclick="goBackToFullscreen()" style="padding:10px 20px; font-size:16px; background:#007bff; color:white; border:none; border-radius:5px;">Go to Fullscreen</button>
        </div>
    `;
    document.body.appendChild(warningBox);
}

function goBackToFullscreen() {
    let elem = document.documentElement;
    if (elem.requestFullscreen) elem.requestFullscreen();
    let warningBox = document.getElementById("fullscreenWarning");
    if (warningBox) warningBox.remove();
}

document.addEventListener("keydown", function(e) {
  if ((e.ctrlKey || e.metaKey) && ["c","v","x","a"].includes(e.key)) {
    e.preventDefault(); alert("❌ Copy / Paste / Select All is not allowed during the quiz!");
  }
});

document.addEventListener("contextmenu", function(e) {
  e.preventDefault(); alert("❌ Right click is disabled during the quiz!");
});

// Quiz start & monitoring
(async function() {
  while (!window.faceapi) await new Promise(r => setTimeout(r, 100));
  const beginBtn = document.getElementById('beginBtn');
  const forceSubmitBtn = document.getElementById('forceSubmitBtn');

  beginBtn.addEventListener('click', async function() {
    beginBtn.disabled = true;
    try { await document.documentElement.requestFullscreen(); } catch(e){ alert('Fullscreen required'); beginBtn.disabled=false; return; }

    try {
      const controller = await window.initExam({
        courseId: '<%= courseId %>',
        level: '<%= level %>',
        durationSeconds: <%= durationSec %>,
        maxTabSwitches: 3,
        formId: 'quizForm',
        modelsUri: '<%= request.getContextPath() %>/models'
      });

      document.getElementById('quizForm').style.display = 'block';
      forceSubmitBtn.style.display = 'inline-block';
      beginBtn.style.display = 'none';

      forceSubmitBtn.addEventListener('click', function() {
        if (controller && controller.stop) controller.stop();
        document.getElementById('quizForm').submit();
      });
    } catch(e){
      alert('Monitoring failed: ' + e.message);
      beginBtn.disabled = false;
    }
  });
})();

// Fetch attempts & per-question marks
fetch('<%= request.getContextPath() %>/QuizAttemptServlet?courseId=<%= courseId %>&level=<%= level %>')
  .then(res => res.json())
  .then(data => {
    document.getElementById("attemptCount").innerText = data.attempts;

    const tbody = document.querySelector("#questionMarksTable tbody");
    tbody.innerHTML = ""; // clear loading row

    if (data.questions && data.questions.length > 0) {
      data.questions.forEach(q => {
        const tr = document.createElement("tr");
        tr.innerHTML = `<td>${q.questionNo}</td><td>${q.marks}</td>`;
        tbody.appendChild(tr);
      });
    } else {
      const tr = document.createElement("tr");
      tr.innerHTML = `<td colspan="2">No data</td>`;
      tbody.appendChild(tr);
    }
  })
  .catch(err => {
    document.getElementById("attemptCount").innerText = "Error";
    console.error(err);
  });

</script>
</body>
</html>--%




















<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;
    int cid = Integer.parseInt(courseId);

    List<Map<String, String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question_bank WHERE topic_id =? and difficulty=? ORDER BY RAND() LIMIT ?")) {
        ps.setInt(1, cid);
        ps.setString(2, level.toLowerCase());
        ps.setInt(3, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Quiz - <%= level %></title>
    <style>
        body {font-family: Arial,sans-serif; background:#0a002b; color:#fff; margin:0; padding:20px;}
        .container {max-width:1000px; margin:20px auto; background:#11134d; padding:20px; border-radius:12px;}
        #beginBtn {background:#00e0ff; color:#000; padding:12px 20px; border:none; border-radius:8px; cursor:pointer; font-weight:700;}
        #beginBtn:disabled {opacity:0.6; cursor:not-allowed;}
        #monitorVideo {width:320px; height:240px; border-radius:8px; border:2px solid #fff; display:block; margin-bottom:10px;}
        #examTimer {font-size:18px; color:#ffcc00; margin-bottom:12px;}
        .question {background:#0b0d3a; padding:12px; border-radius:8px; margin-bottom:10px;}
        .question label {display:block; margin:4px 0; color:#ddd;}
        #quizForm {display:none;}
        #forceSubmitBtn {background:#ff4444; color:#fff; padding:8px 12px; border:none; border-radius:6px; cursor:pointer; display:none;}
        table {border-collapse:collapse;}
        th, td {padding:6px 12px;}
    </style>

    <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
    <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
<div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
        <button id="beginBtn">Enable Camera & Start Quiz</button>
        <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <form id="quizForm" method="post" action="QuizSubmitServlet">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
        <input type="hidden" name="level" value="<%= level %>">
        <% for(Map<String,String> q : questions){ %>
            <div class="question">
                <p><%= q.get("text") %></p>
                <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
            </div>
        <% } %>
    </form>

    <!-- Attempt & Marks Table -->
    <div id="attemptBox" style="margin:15px 0; padding:10px; background:#0b0d3a; border-radius:8px;">
        <h3>📑 Your Attempts & Question Marks</h3>
        <table border="1" style="background:#11134d; color:white;">
            <thead>
                <tr>
                    <th>Level</th>
                    <th>Attempts Made</th>
                    <th>Free Attempts Allowed</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= level %></td>
                    <td id="attemptCount">Loading...</td>
                    <td><%= "EASY".equalsIgnoreCase(level) ? 2 : "INTERMEDIATE".equalsIgnoreCase(level) ? 3 : 4 %></td>
                </tr>
            </tbody>
        </table>

        <h4 style="margin-top:15px;">✅ Marks per Question (Latest Attempt)</h4>
        <table border="1" style="background:#11134d; color:white;" id="questionMarksTable">
            <thead>
                <tr>
                    <th>Question No.</th>
                    <th>Marks</th>
                </tr>
            </thead>
            <tbody>
                <tr><td colspan="2">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>

<script>
window.onload = function() {
    // Fetch attempt count and marks
    fetch('<%= request.getContextPath() %>/QuizAttemptServlet?courseId=<%= courseId %>&level=<%= level %>')
        .then(res => res.json())
        .then(data => {
            document.getElementById("attemptCount").innerText = data.attempts;

            const tbody = document.querySelector("#questionMarksTable tbody");
            tbody.innerHTML = ""; // clear loading

            data.questions.forEach(q => {
                const tr = document.createElement("tr");
                tr.innerHTML = `<td>${q.questionNo}</td><td>${q.marks}</td>`;
                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            document.getElementById("attemptCount").innerText = "Error";
            console.error(err);
        });

    // Quiz monitoring logic
    (async function() {
        while (!window.faceapi) {
            await new Promise(r => setTimeout(r, 100));
        }

        const beginBtn = document.getElementById('beginBtn');
        const forceSubmitBtn = document.getElementById('forceSubmitBtn');

        beginBtn.addEventListener('click', async function() {
            beginBtn.disabled = true;
            try { await document.documentElement.requestFullscreen(); } catch(e){ alert('Fullscreen required'); beginBtn.disabled=false; return; }

            try {
                const controller = await window.initExam({
                    courseId: '<%= courseId %>',
                    level: '<%= level %>',
                    durationSeconds: <%= durationSec %>,
                    maxTabSwitches: 3,
                    formId: 'quizForm',
                    modelsUri: '<%= request.getContextPath() %>/models'
                });

                document.getElementById('quizForm').style.display = 'block';
                forceSubmitBtn.style.display = 'inline-block';
                beginBtn.style.display = 'none';

                forceSubmitBtn.addEventListener('click', function() {
                    if (controller && controller.stop) controller.stop();
                    document.getElementById('quizForm').submit();
                });

            } catch(e){
                alert('Monitoring failed: ' + e.message);
                beginBtn.disabled = false;
            }
        });
    })();
};
</script>
</body>
</html>--%















<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 : "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;
    int cid=Integer.parseInt(courseId);

    List<Map<String,String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM question_bank WHERE topic_id=? AND difficulty=? ORDER BY RAND() LIMIT ?")) {

        ps.setInt(1, cid);
        ps.setString(2, level.toLowerCase());
        ps.setInt(3, questionLimit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Quiz - <%= level %></title>
<style>
body{font-family:Arial,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
.container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
#beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
#beginBtn:disabled{opacity:0.6;cursor:not-allowed}
#monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
#examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
.question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
.question label{display:block;margin:4px 0;color:#ddd}
#quizForm{display:none}
#forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
</style>

<script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
<script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>

<div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
        <button id="beginBtn">Enable Camera & Start Quiz</button>
        <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <!-- Quiz Form -->
    <form id="quizForm" method="post" action="QuizSubmitServlet">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
        <input type="hidden" name="level" value="<%= level %>">
        <% for(Map<String,String> q : questions){ %>
            <div class="question">
                <p><%= q.get("text") %></p>
                <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
            </div>
        <% } %>
    </form>

    <!-- Attempts & Marks Table -->
    <div id="attemptBox" style="margin:15px 0; padding:10px; background:#0b0d3a; border-radius:8px;">
        <h3>📑 Your Attempts & Question Marks</h3>
        <table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse; background:#11134d; color:white;">
            <thead>
                <tr>
                    <th>Level</th>
                    <th>Attempts Made</th>
                    <th>Free Attempts Allowed</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= level %></td>
                    <td id="attemptCount">Loading...</td>
                    <td>
                        <%= "EASY".equalsIgnoreCase(level) ? 2 : "INTERMEDIATE".equalsIgnoreCase(level) ? 3 : 4 %>
                    </td>
                </tr>
            </tbody>
        </table>

        <h4 style="margin-top:15px;">✅ Marks per Question (Latest Attempt)</h4>
        <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse; background:#11134d; color:white;" id="questionMarksTable">
            <thead>
                <tr>
                    <th>Question No.</th>
                    <th>Marks</th>
                </tr>
            </thead>
            <tbody>
                <tr><td colspan="2">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>

<script>
document.addEventListener("fullscreenchange", function() {
    if (!document.fullscreenElement) {
        alert("⚠️ You must stay in fullscreen mode to continue the quiz!");
    }
});

// Start Quiz & Camera
(async function() {
    const beginBtn = document.getElementById('beginBtn');
    const forceSubmitBtn = document.getElementById('forceSubmitBtn');

    beginBtn.addEventListener('click', async function() {
        beginBtn.disabled = true;
        try { await document.documentElement.requestFullscreen(); } catch(e){ alert('Fullscreen required'); beginBtn.disabled=false; return; }

        try {
            const controller = await window.initExam({
                courseId: '<%= courseId %>',
                level: '<%= level %>',
                durationSeconds: <%= durationSec %>,
                maxTabSwitches: 3,
                formId: 'quizForm',
                modelsUri: '<%= request.getContextPath() %>/models'
            });

            document.getElementById('quizForm').style.display = 'block';
            forceSubmitBtn.style.display = 'inline-block';
            beginBtn.style.display = 'none';

            forceSubmitBtn.addEventListener('click', function() {
                if (controller && controller.stop) controller.stop();
                document.getElementById('quizForm').submit();
            });

        } catch(e){
            alert('Monitoring failed: ' + e.message);
            beginBtn.disabled = false;
        }
    });
})();

// Fetch attempts & marks and inject HTML rows
fetch('<%= request.getContextPath() %>/QuizAttemptServlet?courseId=<%= courseId %>&level=<%= level %>')
    .then(res => res.text())
    .then(html => {
        document.querySelector("#questionMarksTable tbody").innerHTML = html;
    })
    .catch(err => console.error(err));
</script>
</body>
</html>
--%>











<%-- --%
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 :
                        "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 :
                      "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;
    int cid = Integer.parseInt(courseId);

    List<Map<String,String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement(
             "SELECT * FROM question_bank WHERE topic_id=? AND difficulty=? ORDER BY RAND() LIMIT ?")) {

        ps.setInt(1, cid);
        ps.setString(2, level.toLowerCase());
        ps.setInt(3, questionLimit);

        ResultSet rs = ps.executeQuery();
        while(rs.next()){
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch(Exception e){ e.printStackTrace(); }
%>
<%
    // Example values (replace with real values from DB/servlet)
    //String level = request.getParameter("level");  
    int attemptCount = Integer.parseInt(request.getAttribute("attemptCount").toString());

    int perQuestionMark = 0, freeAttempts = 0, totalQuestions = 0;

    if ("EASY".equalsIgnoreCase(level)) {
        perQuestionMark = 20;
        freeAttempts = 2;
        totalQuestions = 5;
    } else if ("INTERMEDIATE".equalsIgnoreCase(level)) {
        perQuestionMark = 10;
        freeAttempts = 3;
        totalQuestions = 10;
    } else if ("HARD".equalsIgnoreCase(level)) {
        perQuestionMark = 7;  // approx 6.67
        freeAttempts = 4;
        totalQuestions = 15;
    }

    // Calculate actual mark per question for this attempt
    double actualMarks = perQuestionMark;
    if (attemptCount > freeAttempts) {
        int extra = attemptCount - freeAttempts;
        actualMarks = perQuestionMark - (perQuestionMark * 0.10 * extra);
        if (actualMarks < 0) actualMarks = 0;
    }
    actualMarks = Math.round(actualMarks * 100.0) / 100.0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quiz - <%= level %></title>
    <style>
        body{font-family:Arial,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
        .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
        #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
        #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
        #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
        #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
        .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
        .question label{display:block;margin:4px 0;color:#ddd}
        #quizForm{display:none}
        #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
        table{border-collapse:collapse;width:100%;margin-top:10px;}
        th, td{border:1px solid #fff;padding:8px;text-align:center;}
        th{background:#1a1a7f;}
    </style>

    <!-- libs -->
    <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
    <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
<div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
        <button id="beginBtn">Enable Camera & Start Quiz</button>
        <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <form id="quizForm" method="post" action="QuizSubmitServlet">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
        <input type="hidden" name="level" value="<%= level %>">
        <% for(Map<String,String> q : questions){ %>
            <div class="question">
                <p><%= q.get("text") %></p>
                <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
            </div>
        <% } %>
    </form>

    <!-- Attempts & Marks Table -->
    <div id="attemptBox">
        <h3>📑 Your Attempts & Question Marks</h3>
        <table>
            <thead>
                <tr>
                    <th>Level</th>
                    <th>Attempts Made</th>
                    <th>Free Attempts Allowed</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= level %></td>
                    <td id="attemptCount">Loading...</td>
                    <td><%= "EASY".equalsIgnoreCase(level) ? 2 : "INTERMEDIATE".equalsIgnoreCase(level) ? 3 : 4 %></td>
                </tr>
            </tbody>
        </table>

        <h4>✅ Marks per Question (Latest Attempt)</h4>
        
        
        
        
        <table border="1" style="width: 100%; text-align:center;">
    <thead>
        <tr>
            <th>Question No.</th>
            <th>Marks</th>
        </tr>
    </thead>
    <tbody>
        <%
            for (int i = 1; i <= totalQuestions; i++) {
        %>
            <tr>
                <td><%= i %></td>
                <td><%= actualMarks %></td>
            </tr>
        <%
            }
        %>
    </tbody>
</table>
        
        
        
        
        
        
        <table id="questionMarksTable">
            <thead>
                <tr><th>Question No.</th><th>Marks</th></tr>
            </thead>
            <tbody>
                <tr><td colspan="2">Loading...</td></tr>
            </tbody>
        </table>
    </div>
</div>

<script>
document.addEventListener("fullscreenchange", function() {
    if (!document.fullscreenElement) {
        alert("⚠️ You must stay in fullscreen mode to continue the quiz.");
        document.documentElement.requestFullscreen();
    }
});

document.addEventListener("keydown", function(e){
    if((e.ctrlKey||e.metaKey) && ["c","v","x","a"].includes(e.key)){
        e.preventDefault();
        alert("❌ Copy / Paste / Select All is not allowed during the quiz!");
    }
});

document.addEventListener("contextmenu", function(e){ e.preventDefault(); alert("❌ Right click is disabled!"); });

// Initialize Exam
(async function(){
    while(!window.faceapi) await new Promise(r=>setTimeout(r,100));
    const beginBtn = document.getElementById('beginBtn');
    const forceSubmitBtn = document.getElementById('forceSubmitBtn');

    beginBtn.addEventListener('click', async function(){
        beginBtn.disabled = true;
        try { await document.documentElement.requestFullscreen(); } catch(e){ alert('Fullscreen required'); beginBtn.disabled=false; return; }

        try {
            const controller = await window.initExam({
                courseId: '<%= courseId %>',
                level: '<%= level %>',
                durationSeconds: <%= durationSec %>,
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

        } catch(e){ alert('Monitoring failed: '+e.message); beginBtn.disabled=false; }
    });
})();



//Fetch attempts and marks
fetch(`QuizAttemptServlet?courseId=<%= courseId %>&level=<%= level %>`)
.then(res => res.json())
.then(data => {
    console.log("Response JSON:", data);   // ✅ Debugging: see JSON in console

    if (data.error) {
        document.getElementById("attemptCount").innerText = data.error;
        return;
    }

    // Show attempts info
    document.getElementById("attemptCount").innerText =
        data.attemptCount + " (Current: " + data.currentAttempt + ")";

    // Fill marks table
    const tbody = document.querySelector("#questionMarksTable tbody");
    tbody.innerHTML = '';
    data.marks.forEach(m => {
        const tr = document.createElement("tr");
        tr.innerHTML = `<td>${m.q}</td><td>${m.mark}</td>`;
        tbody.appendChild(tr);
    });
})
.catch(err => {
    document.getElementById("attemptCount").innerText = "Error";
    document.querySelector("#questionMarksTable tbody").innerHTML = "<tr><td colspan='2'>Error</td></tr>";
    console.error(err);
});



//Fetch attempts and marks
fetch(`QuizAttemptServlet?courseId=<%= courseId %>&level=<%= level %>`)
.then(data => {
    console.log("Response JSON:", data);   // 🔍 Debug
    if (data.error) {
        document.getElementById("attemptCount").innerText = data.error;
        return;
    }

    document.getElementById("attemptCount").innerText =
        data.attemptCount + " (Current: " + data.currentAttempt + ")";

    const tbody = document.querySelector("#questionMarksTable tbody");
    tbody.innerHTML = '';
    data.marks.forEach(m => {
        const tr = document.createElement("tr");
        tr.innerHTML = `<td>${m.q}</td><td>${m.mark}</td>`;
        tbody.appendChild(tr);
    });
})

.then(res => res.json())
.then(data => {
    if (data.error) {
        document.getElementById("attemptCount").innerText = data.error;
        return;
    }

    // Show attempt count
    document.getElementById("attemptCount").innerText = data.attemptCount + " (Current: " + data.currentAttempt + ")";

    // Fill marks table
    const tbody = document.querySelector("#questionMarksTable tbody");
    tbody.innerHTML = '';
    data.marks.forEach(m => {
        const tr = document.createElement("tr");
        tr.innerHTML = `<td>${m.q}</td><td>${m.mark}</td>`;
        tbody.appendChild(tr);
    });
})
.catch(err => {
    document.getElementById("attemptCount").innerText = "Error";
    document.querySelector("#questionMarksTable tbody").innerHTML = "<tr><td colspan='2'>Error</td></tr>";
    console.error(err);
});




<%--




//Fetch attempts and marks
fetch(`QuizAttemptServlet?courseId=<%= courseId %>&level=<%= level %>`)
.then(res => res.text())
.then(html => {
    // Split the response: first <script> sets attemptCount, rest is table rows
    const attemptScriptEnd = html.indexOf("</script>") + 9;
    const attemptScript = html.substring(0, attemptScriptEnd);
    const marksHtml = html.substring(attemptScriptEnd);

    // Execute the attempt script
    eval(attemptScript);

    // Insert table rows directly
    document.querySelector("#questionMarksTable tbody").innerHTML = marksHtml;
})
.catch(err => {
    document.getElementById("attemptCount").innerText = "Error";
    document.querySelector("#questionMarksTable tbody").innerHTML = "<tr><td colspan='2'>Error</td></tr>";
    console.error(err);
});
--%














// Fetch attempts and marks
fetch(`QuizAttemptServlet?courseId=<%= courseId %>&level=<%= level %>`)
.then(res => res.text())
.then(html => {
    // Insert attempts + marks rows
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');

    // Extract and execute <script> for attempts
    const scripts = doc.querySelectorAll('script');
    scripts.forEach(s => eval(s.innerText));

    // Extract table rows for marks
    const rows = doc.querySelectorAll('tr');
    const tbody = document.querySelector("#questionMarksTable tbody");
    tbody.innerHTML = '';
    rows.forEach(r => tbody.appendChild(r));
})
.catch(err => {
    document.getElementById("attemptCount").innerText="Error";
    console.error(err);
});   --
</script>
</body>
</html>  --%













<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 :
                        "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 :
                      "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;
    int cid = Integer.parseInt(courseId);

    List<Map<String,String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement(
             "SELECT * FROM question_bank WHERE topic_id=? AND difficulty=? ORDER BY RAND() LIMIT ?")) {

        ps.setInt(1, cid);
        ps.setString(2, level.toLowerCase());
        ps.setInt(3, questionLimit);

        ResultSet rs = ps.executeQuery();
        while(rs.next()){
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch(Exception e){ e.printStackTrace(); }
%>
<%
















<%
int attemptCount = (request.getAttribute("attemptCount") != null) 
                    ? (Integer) request.getAttribute("attemptCount") 
                    : 0;

int freeAttempts = (request.getAttribute("freeAttempts") != null) 
                    ? (Integer) request.getAttribute("freeAttempts") 
                    : 0;

int currentAttempt = (request.getAttribute("currentAttempt") != null) 
                    ? (Integer) request.getAttribute("currentAttempt") 
                    : 1;

double actualMarks = (request.getAttribute("actualMarks") != null) 
                    ? (Double) request.getAttribute("actualMarks") 
                    : 0.0;

int totalQuestions = (request.getAttribute("totalQuestions") != null) 
                    ? (Integer) request.getAttribute("totalQuestions") 
                    : 0;
%>

<h3>Marks Per Question</h3>
<table border="1" style="width: 100%; text-align:center;">
<thead>
    <tr><th>Question No.</th><th>Marks</th></tr>
</thead>
<tbody>
    <%
        for (int i = 1; i <= totalQuestions; i++) {
    %>
        <tr>
            <td><%= i %></td>
            <td><%= actualMarks %></td>
        </tr>
    <%
        }
    %>
</tbody>
</table>

    // ⚡ Get attemptCount from request attribute (must be set in servlet before forwarding here)
    int attemptCount = Integer.parseInt(request.getAttribute("attemptCount").toString());

    int perQuestionMark = 0, freeAttempts = 0, totalQuestions = 0;

    if ("EASY".equalsIgnoreCase(level)) {
        perQuestionMark = 20;
        freeAttempts = 2;
        totalQuestions = 5;
    } else if ("INTERMEDIATE".equalsIgnoreCase(level)) {
        perQuestionMark = 10;
        freeAttempts = 3;
        totalQuestions = 10;
    } else if ("HARD".equalsIgnoreCase(level)) {
        perQuestionMark = 7;  // approx 6.67
        freeAttempts = 4;
        totalQuestions = 15;
    }

    // Calculate actual mark per question for this attempt
    double actualMarks = perQuestionMark;
    if (attemptCount > freeAttempts) {
        int extra = attemptCount - freeAttempts;
        actualMarks = perQuestionMark - (perQuestionMark * 0.10 * extra);
        if (actualMarks < 0) actualMarks = 0;
    }
    actualMarks = Math.round(actualMarks * 100.0) / 100.0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quiz - <%= level %></title>
    <style>
        body{font-family:Arial,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
        .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
        #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
        #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
        #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
        #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
        .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
        .question label{display:block;margin:4px 0;color:#ddd}
        #quizForm{display:none}
        #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
        table{border-collapse:collapse;width:100%;margin-top:10px;}
        th, td{border:1px solid #fff;padding:8px;text-align:center;}
        th{background:#1a1a7f;}
    </style>

    <!-- libs -->
    <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
    <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
<div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
        <button id="beginBtn">Enable Camera & Start Quiz</button>
        <button id="forceSubmitBtn">Force Submit</button>
    </div>

    <form id="quizForm" method="post" action="QuizSubmitServlet">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
        <input type="hidden" name="level" value="<%= level %>">
        <% for(Map<String,String> q : questions){ %>
            <div class="question">
                <p><%= q.get("text") %></p>
                <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
            </div>
        <% } %>
    </form>

    <!-- Attempts & Marks Table -->
    <div id="attemptBox">
        <h3>📑 Your Attempts & Question Marks</h3>
        <table>
            <thead>
                <tr>
                    <th>Level</th>
                    <th>Attempts Made</th>
                    <th>Free Attempts Allowed</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= level %></td>
                    <td><%= attemptCount %></td>
                    <td><%= freeAttempts %></td>
                </tr>
            </tbody>
        </table>

        <h4>✅ Marks per Question (Latest Attempt)</h4>
        <table border="1" style="width: 100%; text-align:center;">
            <thead>
                <tr>
                    <th>Question No.</th>
                    <th>Marks</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (int i = 1; i <= totalQuestions; i++) {
                %>
                    <tr>
                        <td><%= i %></td>
                        <td><%= actualMarks %></td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<script>
document.addEventListener("fullscreenchange", function() {
    if (!document.fullscreenElement) {
        alert("⚠️ You must stay in fullscreen mode to continue the quiz.");
        document.documentElement.requestFullscreen();
    }
});

document.addEventListener("keydown", function(e){
    if((e.ctrlKey||e.metaKey) && ["c","v","x","a"].includes(e.key)){
        e.preventDefault();
        alert("❌ Copy / Paste / Select All is not allowed during the quiz!");
    }
});

document.addEventListener("contextmenu", function(e){ e.preventDefault(); alert("❌ Right click is disabled!"); });

// Initialize Exam
(async function(){
    while(!window.faceapi) await new Promise(r=>setTimeout(r,100));
    const beginBtn = document.getElementById('beginBtn');
    const forceSubmitBtn = document.getElementById('forceSubmitBtn');

    beginBtn.addEventListener('click', async function(){
        beginBtn.disabled = true;
        try { await document.documentElement.requestFullscreen(); } catch(e){ alert('Fullscreen required'); beginBtn.disabled=false; return; }

        try {
            const controller = await window.initExam({
                courseId: '<%= courseId %>',
                level: '<%= level %>',
                durationSeconds: <%= durationSec %>,
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

        } catch(e){ alert('Monitoring failed: '+e.message); beginBtn.disabled=false; }
    });
})();
</script>
</body>
</html>  --%>






<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security: Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Security: Check if quiz was already submitted
    String checkCourseId = request.getParameter("courseId");
    String checkLevel = request.getParameter("level");
    
    if (checkCourseId != null && checkLevel != null) {
        Boolean wasCompleted = (Boolean) session.getAttribute("quiz_completed_" + checkCourseId + "_" + checkLevel);
        if (wasCompleted != null && wasCompleted) {
            response.sendRedirect("MyCoursesServlet");
            return;
        }
    }
%>
<%@ page import="java.sql.*, java.util.*" %>
<%-- Rest of your existing code continues here --%>







<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Input params
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    int questionLimit = "EASY".equalsIgnoreCase(level) ? 5 :
                        "INTERMEDIATE".equalsIgnoreCase(level) ? 10 : 15;
    int durationSec = "EASY".equalsIgnoreCase(level) ? 5*60 :
                      "INTERMEDIATE".equalsIgnoreCase(level) ? 10*60 : 15*60;
    int cid = Integer.parseInt(courseId);
    
    String completedKey = "quiz_" + courseId + "_" + level + "_completed";
    if (request.getAttribute(completedKey) != null) {
        response.sendRedirect("MyCoursesServlet");
        return;
    }
    %>
<% 
    // Fetch questions from DB
    List<Map<String,String>> questions = new ArrayList<>();
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "");
         PreparedStatement ps = con.prepareStatement(
             "SELECT * FROM question_bank WHERE topic_id=? AND difficulty=? ORDER BY RAND() LIMIT ?")) {

        ps.setInt(1, cid);
        ps.setString(2, level.toLowerCase());
        ps.setInt(3, questionLimit);

        ResultSet rs = ps.executeQuery();
        while(rs.next()){
            Map<String,String> q = new HashMap<>();
            q.put("id", rs.getString("id"));
            q.put("text", rs.getString("question_text"));
            q.put("a", rs.getString("option_a"));
            q.put("b", rs.getString("option_b"));
            q.put("c", rs.getString("option_c"));
            q.put("d", rs.getString("option_d"));
            questions.add(q);
        }
    } catch(Exception e){ e.printStackTrace(); }

    // Fetch servlet attributes (from QuizAttemptServlet)
    int attemptCount = (request.getAttribute("attemptCount") != null) 
                        ? (Integer) request.getAttribute("attemptCount") : 0;

    int freeAttempts = (request.getAttribute("freeAttempts") != null) 
                        ? (Integer) request.getAttribute("freeAttempts") : 0;

    int currentAttempt = (request.getAttribute("currentAttempt") != null) 
                        ? (Integer) request.getAttribute("currentAttempt") : 1;

    double actualMarks = (request.getAttribute("actualMarks") != null) 
                        ? (Double) request.getAttribute("actualMarks") : 0.0;

    int totalQuestions = (request.getAttribute("totalQuestions") != null) 
                        ? (Integer) request.getAttribute("totalQuestions") : questionLimit;
%>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quiz - <%= level %></title>
    <style>
        body{font-family:Arial,sans-serif;background:#0a002b;color:#fff;margin:0;padding:20px}
        .container{max-width:1000px;margin:20px auto;background:#11134d;padding:20px;border-radius:12px}
        #beginBtn{background:#00e0ff;color:#000;padding:12px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:700}
        #beginBtn:disabled{opacity:0.6;cursor:not-allowed}
        #monitorVideo{width:320px;height:240px;border-radius:8px;border:2px solid #fff;display:block;margin-bottom:10px}
        #examTimer{font-size:18px;color:#ffcc00;margin-bottom:12px}
        .question{background:#0b0d3a;padding:12px;border-radius:8px;margin-bottom:10px}
        .question label{display:block;margin:4px 0;color:#ddd}
        #quizForm{display:none}
        #forceSubmitBtn{background:#ff4444;color:#fff;padding:8px 12px;border:none;border-radius:6px;cursor:pointer;display:none}
        table{border-collapse:collapse;width:100%;margin-top:10px;}
        th, td{border:1px solid #fff;padding:8px;text-align:center;}
        th{background:#1a1a7f;}
    </style>

    <!-- libs -->
    <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd" defer></script>
    <script src="<%= request.getContextPath() %>/JS/exam-monitor.js" defer></script>
</head>
<body>
<div class="container">
    <h2>Quiz: <%= level %> Level</h2>
    <p>Course: <%= request.getParameter("title") != null ? request.getParameter("title") : courseId %></p>

    <div id="examTimer">Timer will appear here</div>
    <video id="monitorVideo" autoplay muted playsinline></video>

    <div style="margin:12px 0;">
        <button id="beginBtn">Enable Camera & Start Quiz</button>
        <button id="forceSubmitBtn">Force Submit</button>
    </div>



<form id="quizForm" method="post" action="QuizSubmitServlet">
    <input type="hidden" name="courseId" value="<%= courseId %>">
    <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
    <input type="hidden" name="level" value="<%= level %>">

    <% for(Map<String,String> q : questions){ %>
        <!-- ✅ Hidden questionId field for each question -->
        <input type="hidden" name="questionIds" value="<%= q.get("id") %>">

        <div class="question">
            <p><%= q.get("text") %></p>
            <label><input type="radio" name="q<%= q.get("id") %>" value="A"> <%= q.get("a") %></label>
            <label><input type="radio" name="q<%= q.get("id") %>" value="B"> <%= q.get("b") %></label>
            <label><input type="radio" name="q<%= q.get("id") %>" value="C"> <%= q.get("c") %></label>
            <label><input type="radio" name="q<%= q.get("id") %>" value="D"> <%= q.get("d") %></label>
        </div>
    <% } %>
</form>








    <!-- Quiz Form -->
 <%-- --% --   <form id="quizForm" method="post" action="QuizSubmitServlet">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        <input type="hidden" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
        <input type="hidden" name="level" value="<%= level %>">
        <% for(Map<String,String> q : questions){ %>
            <div class="question">
                <p><%= q.get("text") %></p>
                <label><input type="radio" name="q<%= q.get("id") %>" value="a"> <%= q.get("a") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="b"> <%= q.get("b") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="c"> <%= q.get("c") %></label>
                <label><input type="radio" name="q<%= q.get("id") %>" value="d"> <%= q.get("d") %></label>
            </div>
        <% } %>
    </form>  --%>

    <!-- Attempts & Marks Table -->
    <div id="attemptBox">
        <h3>📑 Your Attempts & Question Marks</h3>
        <table>
            <thead>
                <tr>
                    <th>Level</th>
                    <th>Attempts Made</th>
                    <th>Free Attempts Allowed</th>
                    <th>Current Attempt</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= level %></td>
                    <td><%= attemptCount %></td>
                    <td><%= freeAttempts %></td>
                    <td><%= currentAttempt %></td>
                </tr>
            </tbody>
        </table>

        <h4>✅ Marks per Question (Latest Attempt)</h4>
        <table>
            <thead>
                <tr>
                    <th>Question No.</th>
                    <th>Marks</th>
                </tr>
            </thead>
            <tbody>
                <% for (int i = 1; i <= totalQuestions; i++) { %>
                    <tr>
                        <td><%= i %></td>
                        <td><%= actualMarks %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Fullscreen warning overlay -->
<div id="fullscreenWarning" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.95);z-index:9999;justify-content:center;align-items:center;">
    <div style="text-align:center;padding:40px;background:#1a1a7f;border-radius:12px;max-width:500px;">
        <h2 style="color:#ff4444;margin-bottom:20px;">⚠️ Fullscreen Required!</h2>
        <p style="font-size:18px;margin-bottom:30px;">You must stay in fullscreen mode to continue the quiz.</p>
        <button id="returnFullscreenBtn" style="background:#00e0ff;color:#000;padding:15px 30px;border:none;border-radius:8px;cursor:pointer;font-weight:700;font-size:16px;">
            Return to Fullscreen
        </button>
    </div>
</div>

<!-- Anti-cheating & exam monitor -->
<script>
const fullscreenWarning = document.getElementById('fullscreenWarning');
const returnFullscreenBtn = document.getElementById('returnFullscreenBtn');

document.addEventListener("fullscreenchange", function() {
    if (!document.fullscreenElement) {
        fullscreenWarning.style.display = 'flex';
    }
});

returnFullscreenBtn.addEventListener('click', async function() {
    try {
        await document.documentElement.requestFullscreen();
        fullscreenWarning.style.display = 'none';
    } catch(e) {
        alert('Unable to enter fullscreen: ' + e.message);
    }
});

// Initialize Exam
(async function(){
    while(!window.faceapi) await new Promise(r=>setTimeout(r,100));
    const beginBtn = document.getElementById('beginBtn');
    const forceSubmitBtn = document.getElementById('forceSubmitBtn');

    beginBtn.addEventListener('click', async function(){
        beginBtn.disabled = true;
        try { await document.documentElement.requestFullscreen(); } catch(e){ 
            alert('Fullscreen required'); beginBtn.disabled=false; return; 
        }

        try {
            const controller = await window.initExam({
                courseId: '<%= courseId %>',
                level: '<%= level %>',
                durationSeconds: <%= durationSec %>,
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




    
    