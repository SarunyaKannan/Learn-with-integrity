<%-- --%<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, String>> resultDetails = (List<Map<String, String>>) request.getAttribute("resultDetails");
%>
<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
<script>
  // Multi-layer back button protection
  history.pushState(null, null, location.href);
  
  window.onpopstate = function() {
    history.pushState(null, null, location.href);
    alert("Cannot return to quiz after submission.");
  };
  
  // Prevent bfcache
  window.addEventListener('pageshow', function(e) {
    if (e.persisted || performance.navigation.type === 2) {
      location.replace("MyCoursesServlet");
    }
  });
</script>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>
<script>
window.history.forward(); // disables back button
</script>


  <title>Quiz Result</title>
  <style>
    body { font-family: Arial, sans-serif; background:#0a002b; color:white; margin:0; padding:20px; }
    .container { max-width:1000px; margin:30px auto; background:#11134d; padding:30px; border-radius:15px; box-shadow:0 4px 20px rgba(0,0,0,0.5); }
    h1, h2 { color:#00e0ff; text-align:center; }
    .score { text-align:center; font-size:20px; margin:20px 0; }
    .question { background:#0b0d3a; padding:15px; border-radius:10px; margin-bottom:15px; }
    .question p { margin:0 0 8px 0; }
    .correct { color:#2ecc71; font-weight:bold; }
    .wrong { color:#e74c3c; font-weight:bold; }
    ul { list-style:none; padding:0; margin:0; }
    li { padding:4px 0; }
    .btn { display:inline-block; padding:12px 20px; background:#00e0ff; color:#000; border-radius:25px; text-decoration:none; font-weight:bold; text-align:center; margin-top:20px; }
    .btn:hover { background:#00c0dd; }
  </style>
</head>
<body>
  <div class="container">
    <h1>📊 Quiz Result</h1>
    <div class="score">
      Your Score: <strong><%= request.getAttribute("score") %></strong> / <strong><%= request.getAttribute("total") %></strong>
    </div>
    <hr style="border:0;border-top:1px solid #333;margin:20px 0;"/>

    <% if (resultDetails != null) {
        int qno = 1;
        for (Map<String, String> detail : resultDetails) {
            String userAns = detail.get("user");
            String correct = detail.get("correct");
    %>
      <div class="question">
        <p><strong>Q<%=qno++%>:</strong> <%= detail.get("question") %></p>
        <ul>
          <li <%= "A".equalsIgnoreCase(correct) ? "class='correct'" : "" %>>A) <%= detail.get("optA") %></li>
          <li <%= "B".equalsIgnoreCase(correct) ? "class='correct'" : "" %>>B) <%= detail.get("optB") %></li>
          <li <%= "C".equalsIgnoreCase(correct) ? "class='correct'" : "" %>>C) <%= detail.get("optC") %></li>
          <li <%= "D".equalsIgnoreCase(correct) ? "class='correct'" : "" %>>D) <%= detail.get("optD") %></li>
        </ul>
        
        <p>
  Your Answer: 
  <% if (userAns.equalsIgnoreCase(correct)) { %>
    <span class="correct"><%= userAns %></span>
  <% } else { %>
    <span class="wrong"><%= userAns %></span> 
    (Correct: <span class="correct"><%= correct %></span>)
  <% } %>
</p>
<p><strong>💡 Solution:</strong> <%= detail.get("solution") %></p>
        
      <%-- --%    Your Answer: 
          <% if (userAns.equalsIgnoreCase(correct)) { %>
            <span class="correct"><%= userAns %></span>
          <% } else { %>
            <span class="wrong"><%= userAns %></span> 
            (Correct: <span class="correct"><%= correct %></span>)
          <% } %>
        </p>  --%
      </div>
    <% }} %>
    

    <div style="text-align:center;">
      <a href="MyCoursesServlet" class="btn">⬅ Back to My Courses</a>
    </div>
  </div>
</body>
</html>  --%




<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, String>> resultDetails = (List<Map<String, String>>) request.getAttribute("resultDetails");
    String mode = (String) request.getAttribute("mode"); // 🔹 detect mode
    int score = (int) request.getAttribute("score");
    int total = (int) request.getAttribute("total");
    
    double percent = ((double) score / total) * 100;
    String message;
    if (percent == 100) {
        message = "🌟 Excellent! You got all correct!";
    } else if (percent >= 50) {
        message = "👍 Good job! Keep practicing!";
    } else {
        message = "💪 Keep it up! Practice makes perfect!";
    }
%>

<!DOCTYPE html>
<html>
<head>
  <title><%= "practice".equalsIgnoreCase(mode) ? "Practice Quiz Result" : "Quiz Result" %></title>
  <style>
    body { font-family: Arial, sans-serif; background:#0a002b; color:white; margin:0; padding:20px; }
    .container { max-width:1000px; margin:30px auto; background:#11134d; padding:30px; border-radius:15px; box-shadow:0 4px 20px rgba(0,0,0,0.5); }
    h1, h2 { color:#00e0ff; text-align:center; }
    .score { text-align:center; font-size:20px; margin:20px 0; }
    .message { text-align:center; font-size:18px; color:#ffea00; margin-bottom:25px; }
    .question { background:#0b0d3a; padding:15px; border-radius:10px; margin-bottom:15px; }
    .question p { margin:0 0 8px 0; }
    .correct { color:#2ecc71; font-weight:bold; }
    .wrong { color:#e74c3c; font-weight:bold; }
    ul { list-style:none; padding:0; margin:0; }
    li { padding:4px 0; }
    .btn { display:inline-block; padding:12px 20px; background:#00e0ff; color:#000; border-radius:25px; text-decoration:none; font-weight:bold; text-align:center; margin-top:20px; }
    .btn:hover { background:#00c0dd; }
  </style>
</head>
<body>
  <div class="container">
    <h1>
      <%= "practice".equalsIgnoreCase(mode) ? "🧠 Practice Quiz Result" : "📊 Quiz Result" %>
    </h1>
    
    <div class="score">
      Your Score: <strong><%= score %></strong> / <strong><%= total %></strong>
    </div>
    
    <div class="message">
      <%= message %>
    </div>
    
    <hr style="border:0;border-top:1px solid #333;margin:20px 0;"/>

    <% 
    if (resultDetails != null) {
        int qno = 1;
        for (Map<String, String> detail : resultDetails) {
            String userAns = detail.get("user");
            String correct = detail.get("correct");
    %>
      <div class="question">
        <p><strong>Q<%= qno++ %>:</strong> <%= detail.get("question") %></p>
        <ul>
          <li <%= "A".equalsIgnoreCase(correct) ? "class='correct'" : "" %>>A) <%= detail.get("optA") %></li>
          <li <%= "B".equalsIgnoreCase(correct) ? "class='correct'" : "" %>>B) <%= detail.get("optB") %></li>
          <li <%= "C".equalsIgnoreCase(correct) ? "class='correct'" : "" %>>C) <%= detail.get("optC") %></li>
          <li <%= "D".equalsIgnoreCase(correct) ? "class='correct'" : "" %>>D) <%= detail.get("optD") %></li>
        </ul>

        <p>
          Your Answer: 
          <% if (userAns.equalsIgnoreCase(correct)) { %>
            <span class="correct"><%= userAns %></span>
          <% } else { %>
            <span class="wrong"><%= userAns %></span> 
            (Correct: <span class="correct"><%= correct %></span>)
          <% } %>
        </p>

        <p><strong>💡 Solution:</strong> <%= detail.get("solution") %></p>
      </div>
    <% 
        } 
    } 
    %>

    <div style="text-align:center;">
      <% if ("practice".equalsIgnoreCase(mode)) { %>
        <a href="practice.jsp" class="btn">🔁 Try Another Practice Quiz</a>
      <% } else { %>
        <a href="MyCoursesServlet" class="btn">⬅ Back to My Courses</a>
      <% } %>
    </div>
  </div>
</body>
</html>   --%






<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, String>> resultDetails = (List<Map<String, String>>) request.getAttribute("resultDetails");

    // Calculate summary
    int totalQuestions = resultDetails != null ? resultDetails.size() : 0;
    int attempted = 0;
    int correct = 0;
    int wrong = 0;

    if (resultDetails != null) {
        for (Map<String, String> detail : resultDetails) {
            String userAns = detail.get("user");
            String correctAns = detail.get("correct");

            if (userAns != null && !userAns.trim().isEmpty()) {
                attempted++;
                if (userAns.equalsIgnoreCase(correctAns)) {
                    correct++;
                } else {
                    wrong++;
                }
            } else {
                detail.put("user", "Not Attempted"); // ensure Not Attempted shows
                wrong++;
            }
        }
    }
%>

<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
<script>
  // Multi-layer back button protection
  history.pushState(null, null, location.href);
  window.onpopstate = function() {
    history.pushState(null, null, location.href);
    alert("Cannot return to quiz after submission.");
  };
  window.addEventListener('pageshow', function(e) {
    if (e.persisted || performance.navigation.type === 2) {
      location.replace("MyCoursesServlet");
    }
  });
</script>
<script>
window.history.forward(); // disables back button
</script>

  <title>Quiz Result</title>
  <style>
    body { font-family: Arial, sans-serif; background:#0a002b; color:white; margin:0; padding:20px; }
    .container { max-width:1000px; margin:30px auto; background:#11134d; padding:30px; border-radius:15px; box-shadow:0 4px 20px rgba(0,0,0,0.5); }
    h1, h2 { color:#00e0ff; text-align:center; }
    .score { text-align:center; font-size:20px; margin:20px 0; }
    .summary { text-align:center; font-size:18px; margin:15px 0; }
    .question { background:#0b0d3a; padding:15px; border-radius:10px; margin-bottom:15px; }
    .question p { margin:0 0 8px 0; }
    .correct { color:#2ecc71; font-weight:bold; }
    .wrong { color:#e74c3c; font-weight:bold; }
    ul { list-style:none; padding:0; margin:0; }
    li { padding:4px 0; }
    .btn { display:inline-block; padding:12px 20px; background:#00e0ff; color:#000; border-radius:25px; text-decoration:none; font-weight:bold; text-align:center; margin-top:20px; }
    .btn:hover { background:#00c0dd; }
  </style>
</head>
<body>
  <div class="container">
    <h1>📊 Quiz Result</h1>

    <div class="score">
      Your Score: <strong><%= correct %></strong> / <strong><%= totalQuestions %></strong>
    </div>
    <div class="summary">
        Total Questions: <%= totalQuestions %> | 
        Attempted: <%= attempted %> | 
        Correct: <%= correct %> | 
        Wrong: <%= wrong %>
    </div>

    <div class="summary">
        <% 
            double percentage = totalQuestions > 0 ? ((double)correct / totalQuestions) * 100 : 0;
            if (percentage == 100) { %>
                Excellent! 🏆 All answers are correct.
        <% } else if (percentage >= 50) { %>
                Keep it up! 👍 You are improving.
        <% } else { %>
                Keep practicing! 💪 Don't give up.
        <% } %>
    </div>

    <hr style="border:0;border-top:1px solid #333;margin:20px 0;"/>

    <% if (resultDetails != null) {
        int qno = 1;
        for (Map<String, String> detail : resultDetails) {
            String userAns = detail.get("user");
            String correctAns = detail.get("correct");
    %>
      <div class="question">
        <p><strong>Q<%=qno++%>:</strong> <%= detail.get("question") %></p>
        <ul>
          <li <%= "A".equalsIgnoreCase(correctAns) ? "class='correct'" : "" %>>A) <%= detail.get("optA") %></li>
          <li <%= "B".equalsIgnoreCase(correctAns) ? "class='correct'" : "" %>>B) <%= detail.get("optB") %></li>
          <li <%= "C".equalsIgnoreCase(correctAns) ? "class='correct'" : "" %>>C) <%= detail.get("optC") %></li>
          <li <%= "D".equalsIgnoreCase(correctAns) ? "class='correct'" : "" %>>D) <%= detail.get("optD") %></li>
        </ul>
        
        <p>
          Your Answer: 
          <% if (userAns.equalsIgnoreCase(correctAns)) { %>
            <span class="correct"><%= userAns %></span>
          <% } else { %>
            <span class="wrong"><%= userAns %></span> 
            (Correct: <span class="correct"><%= correctAns %></span>)
          <% } %>
        </p>
        <p><strong>💡 Solution:</strong> <%= detail.get("solution") %></p>
      </div>
    <% }} %>

    <div style="text-align:center;">
      <a href="MyCoursesServlet" class="btn">⬅ Back to My Courses</a>
    </div>
  </div>
</body>
</html>
   --%>
   
   
   
   
   
   
   
   
   
   
   
   
   <%-- --%
   
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    // Quiz details passed from servlet
    List<Map<String, String>> resultDetails = (List<Map<String, String>>) request.getAttribute("resultDetails");
    String quizTitle = (String) request.getAttribute("quizTitle"); // dynamic topic/title

    // Initialize counters
    int totalQuestions = resultDetails != null ? resultDetails.size() : 0;
    int attempted = 0;
    int correct = 0;
    int wrong = 0;
    int notAttempted = 0;

    if (resultDetails != null) {
        for (Map<String, String> detail : resultDetails) {
            String userAns = detail.get("user");
            String correctAns = detail.get("correct");

            if (userAns == null || userAns.trim().isEmpty() || "Not Attempted".equalsIgnoreCase(userAns)) {
                detail.put("user", "Not Attempted");
                notAttempted++;
            } else {
                attempted++;
                if (userAns.equalsIgnoreCase(correctAns)) {
                    correct++;
                } else {
                    wrong++;
                }
            }
        }
    }

    double percentage = totalQuestions > 0 ? ((double) correct / totalQuestions) * 100 : 0;
%>
    <%-- --% Remove session attributes to prevent back-button reloading previous quiz
 //  HttpSession session = request.getSession(false);
   // if (session != null) {
     //   session.removeAttribute("questions");
      //  session.removeAttribute("startTime");
      //  session.removeAttribute("quizStarted");
    //}  --%


<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
<script>
  // Back button protection
  history.pushState(null, null, location.href);
  window.onpopstate = function() {
    history.pushState(null, null, location.href);
    alert("Cannot return to quiz after submission.");
  };
  window.addEventListener('pageshow', function(e) {
    if (e.persisted || performance.navigation.type === 2) {
      location.replace("MyCoursesServlet");
    }
  });
</script>
<script>
window.history.forward();
</script>

  <title>Quiz Result</title>
  <style>
    body { font-family: Arial, sans-serif; background:#0a002b; color:white; margin:0; padding:20px; }
    .container { max-width:1000px; margin:30px auto; background:#11134d; padding:30px; border-radius:15px; box-shadow:0 4px 20px rgba(0,0,0,0.5); }
    h1, h2 { color:#00e0ff; text-align:center; }
    .score, .summary { text-align:center; font-size:18px; margin:15px 0; }
    .question { background:#0b0d3a; padding:15px; border-radius:10px; margin-bottom:15px; }
    .question p { margin:0 0 8px 0; }
    .correct { color:#2ecc71; font-weight:bold; }
    .wrong { color:#e74c3c; font-weight:bold; }
    ul { list-style:none; padding:0; margin:0; }
    li { padding:4px 0; }
    .btn { display:inline-block; padding:12px 20px; background:#00e0ff; color:#000; border-radius:25px; text-decoration:none; font-weight:bold; text-align:center; margin-top:20px; }
    .btn:hover { background:#00c0dd; }
  </style>
</head>
<body>
  <div class="container">
    <h1>📊 Quiz Result</h1>
    <h2><%= quizTitle != null ? quizTitle : "Practice Quiz" %></h2>

    <div class="score">
      Your Score: <strong><%= correct %></strong> / <strong><%= totalQuestions %></strong>
    </div>
    <div class="summary">
      Total Questions: <%= totalQuestions %> | 
      Attempted: <%= attempted %> | 
      Correct: <%= correct %> | 
      Wrong: <%= wrong %> | 
      Not Attempted: <%= notAttempted %>
    </div>

    <div class="summary">
      <% if (percentage == 100) { %>
        Excellent! 🏆 All answers are correct.
      <% } else if (percentage >= 50) { %>
        Keep it up! 👍 You are improving.
      <% } else { %>
        Keep practicing! 💪 Don't give up.
      <% } %>
    </div>

    <hr style="border:0;border-top:1px solid #333;margin:20px 0;"/>

    <% if (resultDetails != null) {
        int qno = 1;
        for (Map<String, String> detail : resultDetails) {
            String userAns = detail.get("user");
            String correctAns = detail.get("correct");
    %>
      <div class="question">
        <p><strong>Q<%=qno++%>:</strong> <%= detail.get("question") %></p>
        <ul>
          <li <%= "A".equalsIgnoreCase(correctAns) ? "class='correct'" : "" %>>A) <%= detail.get("optA") %></li>
          <li <%= "B".equalsIgnoreCase(correctAns) ? "class='correct'" : "" %>>B) <%= detail.get("optB") %></li>
          <li <%= "C".equalsIgnoreCase(correctAns) ? "class='correct'" : "" %>>C) <%= detail.get("optC") %></li>
          <li <%= "D".equalsIgnoreCase(correctAns) ? "class='correct'" : "" %>>D) <%= detail.get("optD") %></li>
        </ul>
        
        <p>
          Your Answer: 
          <% if ("Not Attempted".equalsIgnoreCase(userAns)) { %>
            <span class="wrong">Not Attempted</span>
          <% } else if (userAns.equalsIgnoreCase(correctAns)) { %>
            <span class="correct"><%= userAns %></span>
          <% } else { %>
            <span class="wrong"><%= userAns %></span> 
            (Correct: <span class="correct"><%= correctAns %></span>)
          <% } %>
        </p>
        <p><strong>💡 Solution:</strong> <%= detail.get("solution") %></p>
      </div>
    <% }} %>

    <div style="text-align:center;">
      <a href="MyCoursesServlet" class="btn">⬅ Back to My Courses</a>
    </div>
  </div>
</body>
</html>
   
--%


















<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    // ✅ Prevent caching & back navigation
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // ✅ Fetch result data from servlet
    List<Map<String, String>> resultDetails = (List<Map<String, String>>) request.getAttribute("resultDetails");
    int score = (request.getAttribute("score") != null) ? (Integer) request.getAttribute("score") : 0;
    int total = (request.getAttribute("total") != null) ? (Integer) request.getAttribute("total") : 0;
    String quizType = (String) request.getAttribute("quizType");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Result</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #0a002b;
            color: #fff;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: #11134d;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 0 15px rgba(0,0,0,0.6);
        }
        h1, h2 {
            text-align: center;
            color: #00e0ff;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #333;
        }
        th {
            background: #1a1a7f;
            color: #fff;
            text-align: center;
        }
        tr.correct {
            background-color: rgba(0, 255, 0, 0.15);
        }
        tr.wrong {
            background-color: rgba(255, 0, 0, 0.15);
        }
        tr.unattempted {
            background-color: rgba(255, 255, 0, 0.15);
        }
        .score-box {
            text-align: center;
            margin-top: 20px;
            padding: 15px;
            border-radius: 10px;
            background: linear-gradient(90deg, #00e0ff, #0044ff);
            color: #000;
            font-weight: bold;
            font-size: 20px;
        }
        .btn {
            display: inline-block;
            background: #00e0ff;
            color: #000;
            font-weight: bold;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            margin: 15px 5px;
            transition: 0.3s;
        }
        .btn:hover {
            background: #00bfff;
            transform: scale(1.05);
        }
        .summary {
            margin-top: 20px;
            background: #0b0d3a;
            border-radius: 10px;
            padding: 20px;
        }
        .summary p {
            font-size: 16px;
            line-height: 1.6;
        }
    </style>
    <script>
        // ✅ Disable back navigation after quiz submission
        window.history.pushState(null, "", window.location.href);
        window.onpopstate = function() {
            window.history.pushState(null, "", window.location.href);
        };
    </script>
</head>
<body>
<div class="container">
    <h1>🎯 Quiz Result</h1>

    <div class="score-box">
        Your Score: <%= score %> / <%= total %>
    </div>

    <div class="summary">
        <h2>Performance Summary</h2>
        <%
            double percent = (total > 0) ? ((double) score / total * 100.0) : 0;
            String performance;
            if (percent >= 80) performance = "Excellent! Keep up the great work 💪";
            else if (percent >= 60) performance = "Good Job! You’re improving 👍";
            else if (percent >= 40) performance = "Fair Attempt — Review and try again 👀";
            else performance = "Needs Improvement — Revise and retry 💡";
        %>
        <p>Accuracy: <%= String.format("%.2f", percent) %>%</p>
        <p><b>Feedback:</b> <%= performance %></p>
    </div>

    <h2>📋 Question-wise Feedback</h2>
    <table>
        <thead>
        <tr>
            <th>#</th>
            <th>Question</th>
            <th>Your Answer</th>
            <th>Correct Answer</th>
            <th>Solution / Explanation</th>
        </tr>
        </thead>
        <tbody>
        <%
            int index = 1;
            if (resultDetails != null && !resultDetails.isEmpty()) {
                for (Map<String, String> r : resultDetails) {
                    String user = r.get("user");
                    String correct = r.get("correct");
                    String rowClass;

                    if (user == null || "Not Attempted".equalsIgnoreCase(user)) {
                        rowClass = "unattempted";
                    } else if (user.equalsIgnoreCase(correct)) {
                        rowClass = "correct";
                    } else {
                        rowClass = "wrong";
                    }
        %>
        <tr class="<%= rowClass %>">
            <td style="text-align:center;"><%= index++ %></td>
            <td><%= r.get("question") %></td>
            <td style="text-align:center;"><%= user %></td>
            <td style="text-align:center;"><%= correct %></td>
            <td><%= r.get("solution") != null ? r.get("solution") : "-" %></td>
        </tr>
        <% 
                }
            } else { 
        %>
        <tr><td colspan="5" style="text-align:center;">No question details found.</td></tr>
        <% } %>
        </tbody>
    </table>

    <div style="text-align:center; margin-top:30px;">
        <a href="MyCoursesServlet" class="btn">🏠 Back to My Courses</a>
        <a href="explore" class="btn">📚 Explore More Courses</a>
    </div>
</div>
</body>
</html>  --%







<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    // ✅ Prevent caching & back navigation
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // ✅ Fetch result data from servlet
    List<Map<String, String>> resultDetails = (List<Map<String, String>>) request.getAttribute("resultDetails");
    int score = (request.getAttribute("score") != null) ? (Integer) request.getAttribute("score") : 0;
    int total = (request.getAttribute("total") != null) ? (Integer) request.getAttribute("total") : 0;
    String quizType = (String) request.getAttribute("quizType");

    // compute attempted / not attempted / wrong
    int attempted = 0;
    int notAttempted = 0;
    if (resultDetails != null) {
        for (Map<String, String> r : resultDetails) {
            String user = r.get("user");
            if (user == null || "Not Attempted".equalsIgnoreCase(user.trim())) notAttempted++;
            else attempted++;
        }
    }
    int correctAnswers = score;
    int wrongAnswers = attempted - correctAnswers;
    double percent = (total > 0) ? ((double) score / total * 100.0) : 0.0;
    int pctInt = (int)Math.round(percent);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Result</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        /* reused/pruned styles from practice_result.jsp for consistent look */
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
        .header { text-align:center; margin-bottom:30px; }
        .header h1 { color:#00e0ff; font-size:2.5em; margin-bottom:10px; }
        .header .level-badge { display:inline-block; background:rgba(255,204,0,0.2); color:#ffcc00; padding:8px 20px; border-radius:20px; font-weight:bold; text-transform:uppercase; }

        .summary-section {
            display:grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap:20px; margin-bottom:40px;
        }
        .summary-card {
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius:15px; padding:20px; text-align:center; border:2px solid rgba(0,224,255,0.2);
        }
        .summary-card .label { font-size:0.9em; color:#aaa; margin-bottom:10px; }
        .summary-card .value { font-size:2.2em; font-weight:bold; color:#00e0ff; }
        .summary-card.correct .value { color:#00ff88; }
        .summary-card.wrong .value { color:#ff4444; }
        .summary-card.attempted .value { color:#ffaa00; }
        .summary-card.not-attempted .value { color:#888; }

        .percentage-section {
            text-align:center; margin:40px 0; background: linear-gradient(135deg, rgba(17,19,77,0.9), rgba(11,13,58,0.9)); border-radius:15px; padding:30px; border:2px solid rgba(0,224,255,0.3);
        }
        .percentage-circle { width:160px; height:160px; border-radius:50%;
            background: conic-gradient(#00ff88 0% <%= pctInt %>%, rgba(255,255,255,0.08) <%= pctInt %>% 100%);
            display:flex; align-items:center; justify-content:center; margin:0 auto 12px; position:relative;
        }
        .percentage-circle::before { content:''; position:absolute; width:132px; height:132px; background:#11134d; border-radius:50%; }
        .percentage-value { position:relative; font-size:2em; font-weight:bold; color:#00ff88; }
        .percentage-label { font-size:1.1em; color:#aaa; }

        .questions-section { margin-top:30px; }
        .section-title { font-size:1.6em; color:#00e0ff; margin-bottom:20px; padding-bottom:6px; border-bottom:2px solid rgba(0,224,255,0.3); }

        .question-card {
            background: linear-gradient(135deg, rgba(17, 19, 77, 0.9), rgba(11, 13, 58, 0.9));
            border-radius:12px; padding:20px; margin-bottom:16px; border-left:5px solid #00e0ff;
        }
        .question-card.correct { border-left-color:#00ff88; background: linear-gradient(135deg, rgba(0,255,136,0.06), rgba(11,13,58,0.9)); }
        .question-card.wrong { border-left-color:#ff4444; background: linear-gradient(135deg, rgba(255,68,68,0.06), rgba(11,13,58,0.9)); }
        .question-card.not-attempted { border-left-color:#888; background: linear-gradient(135deg, rgba(136,136,136,0.06), rgba(11,13,58,0.9)); }

        .question-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:10px; }
        .question-number { font-weight:bold; color:#00e0ff; margin-right:10px; }
        .question-text { color:#fff; font-size:1.05em; line-height:1.5; }

        .small-grid { display:flex; gap:12px; flex-wrap:wrap; margin-top:12px; }
        .small-box { padding:12px; border-radius:8px; border:2px solid transparent; min-width:140px; background:rgba(255,255,255,0.02); color:#ddd; }
        .small-box.correct { background: rgba(0,255,136,0.12); border-color:#00ff88; color:#eafff0; }
        .small-box.user { background: rgba(255,170,0,0.12); border-color:#ffaa00; color:#fff6e6; }
        .small-box.wrong { background: rgba(255,68,68,0.12); border-color:#ff4444; color:#fff0f0; }

        .answer-explanation { background: rgba(0,224,255,0.06); border-left:3px solid #00e0ff; padding:12px; border-radius:8px; margin-top:12px; color:#ddd; }

        .action-buttons { text-align:center; margin-top:30px; }
        .btn { display:inline-block; padding:10px 20px; margin:6px; border-radius:8px; text-decoration:none; font-weight:bold; border:none; cursor:pointer; }
        .btn-primary { background:linear-gradient(135deg,#00e0ff,#0080ff); color:#000; }
        .btn-secondary { background:linear-gradient(135deg,#ffcc00,#ff9900); color:#000; }

        @media (max-width:768px) {
            .percentage-circle { width:140px; height:140px; }
            .percentage-circle::before { width:118px; height:118px; }
        }
    </style>

    <script>
        // Disable back navigation
        window.history.pushState(null, "", window.location.href);
        window.onpopstate = function() { window.history.pushState(null, "", window.location.href); };
    </script>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Quiz Results</h1>
        <div class="level-badge"><%= (quizType != null ? quizType : "Quiz") %></div>
    </div>

    <div class="summary-section">
        <div class="summary-card">
            <div class="label">Total Questions</div>
            <div class="value"><%= total %></div>
        </div>

        <div class="summary-card correct">
            <div class="label">Correct</div>
            <div class="value"><%= correctAnswers %></div>
        </div>

        <div class="summary-card wrong">
            <div class="label">Wrong</div>
            <div class="value"><%= (wrongAnswers >= 0 ? wrongAnswers : 0) %></div>
        </div>

        <div class="summary-card attempted">
            <div class="label">Attempted</div>
            <div class="value"><%= attempted %></div>
        </div>

        <div class="summary-card not-attempted">
            <div class="label">Not Attempted</div>
            <div class="value"><%= notAttempted %></div>
        </div>
    </div>

    <div class="percentage-section">
        <div class="percentage-circle">
            <div class="percentage-value"><%= String.format("%.1f", percent) %>%</div>
        </div>
        <div class="percentage-label">Overall Score</div>
        <p style="color:#aaa; margin-top:12px;">You scored <strong><%= score %></strong> out of <strong><%= total %></strong></p>
    </div>

    <div class="questions-section">
        <h2 class="section-title">Question-wise Feedback</h2>

        <%
            int idx = 1;
            if (resultDetails != null && !resultDetails.isEmpty()) {
                for (Map<String, String> r : resultDetails) {
                    String user = r.get("user");
                    String correct = r.get("correct");
                    String solution = r.get("solution");
                    String question = r.get("question");
                    String rowClass;
                    boolean isNotAttempted = (user == null || "Not Attempted".equalsIgnoreCase(user.trim()));
                    boolean isCorrect = (!isNotAttempted && user.equalsIgnoreCase(correct));
                    if (isNotAttempted) rowClass = "not-attempted";
                    else if (isCorrect) rowClass = "correct";
                    else rowClass = "wrong";
        %>

        <div class="question-card <%= rowClass %>">
            <div class="question-header">
                <div style="flex:1;">
                    <span class="question-number">Q<%= idx++ %>:</span>
                    <span class="question-text"><%= (question != null ? question : "-") %></span>
                </div>
                <div style="min-width:140px; text-align:right;">
                    <span style="font-weight:bold; color:#aaa;"><%= (isNotAttempted ? "Not Attempted" : (isCorrect ? "Correct" : "Wrong")) %></span>
                </div>
            </div>

            <div class="small-grid">
                <div class="small-box correct">
                    <div style="font-weight:bold;">Correct Answer</div>
                    <div style="margin-top:6px;"><%= (correct != null ? correct : "-") %></div>
                </div>

                <div class="small-box <%= (isNotAttempted ? "" : (isCorrect ? "user" : "wrong")) %>">
                    <div style="font-weight:bold;">Your Answer</div>
                    <div style="margin-top:6px;"><%= (user != null ? user : "Not Attempted") %></div>
                </div>
            </div>

            <div class="answer-explanation">
                <div style="font-weight:bold; color:#00e0ff; margin-bottom:6px;">Solution / Explanation</div>
                <div><%= (solution != null && !solution.trim().isEmpty() ? solution : "-") %></div>
            </div>
        </div>

        <%      }
            } else {
        %>
            <div class="question-card">
                <div class="question-text">No question details found.</div>
            </div>
        <% } %>
    </div>

    <div class="action-buttons">
        <a href="MyCoursesServlet" class="btn btn-primary">🏠 Back to My Courses</a>
        <a href="explore" class="btn btn-secondary">📚 Explore More Courses</a>
    </div>
</div>
</body>
</html>
--%>






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

    Integer total = (Integer) request.getAttribute("total");
    Integer score = (Integer) request.getAttribute("score");
    List<Map<String, String>> resultDetails = (List<Map<String, String>>) request.getAttribute("resultDetails");
    String quizType = (String) request.getAttribute("quizType"); // real quiz type

    if (total == null || resultDetails == null) {
        response.sendRedirect("home.jsp");
        return;
    }
%>
<%
    int attemptedCount = 0;
    int notAttemptedCount = 0;
    for(Map<String,String> r : resultDetails){
        String ua = r.get("user");
        if(ua == null || ua.equalsIgnoreCase("Not Attempted")){
            notAttemptedCount++;
        } else {
            attemptedCount++;
        }
    }
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz Results</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
    body { font-family:'Arial',sans-serif; background:linear-gradient(135deg,#0b0b2b 0%,#1a0033 100%); color:#fff; margin:0; padding:20px; min-height:100vh; }
    .container { max-width:1200px; margin:0 auto; }
    .header { text-align:center; margin-bottom:30px; }
    .header h1 { color:#00e0ff; font-size:2.5em; margin-bottom:10px; }

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
        <h1>Quiz Results</h1>
    </div>

    <div class="summary-section">
        <div class="summary-card"><div class="label">Total Questions</div><div class="value"><%= total %></div></div>
        <div class="summary-card correct"><div class="label">Correct</div><div class="value"><%= score %></div></div>
        <div class="summary-card wrong"><div class="label">Wrong</div><div class="value"><%= total - score %></div></div>
        <div class="summary-card attempted"><div class="label">Attempted</div><div class="value"><%= attemptedCount %></div></div>
<div class="summary-card not-attempted"><div class="label">Not Attempted</div><div class="value"><%= notAttemptedCount %></div></div>
  </div>

    <div class="questions-section">
        <h2 class="section-title">Detailed Solutions</h2>
        <%
            int qNo = 1;
            for(Map<String,String> result : resultDetails){
                String userAnswer = result.get("user");
                String correctOption = result.get("correct");

                // Determine status
                String cardClass="not-attempted";
                String badgeClass="not-attempted";
                String badgeText="Not Attempted";

                if(userAnswer == null || userAnswer.equalsIgnoreCase("Not Attempted")){
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
                <span class="question-text"><%= result.get("question") %></span>
                <div class="status-badge <%=badgeClass%>"><%=badgeText%></div>
            </div>
            <div class="options-grid">
                <%
                    String[] opts = {"A","B","C","D"};
                    for(String opt : opts){
                        String optionText = result.get("opt"+opt);
                        String optionClass = "";
                        if(opt.equalsIgnoreCase(correctOption)) optionClass="correct-answer";
                        if(userAnswer != null && !userAnswer.equalsIgnoreCase("Not Attempted") 
                           && opt.equalsIgnoreCase(userAnswer) && !opt.equalsIgnoreCase(correctOption)) optionClass="user-wrong";
                %>
                <div class="option <%=optionClass%>">
                    <span class="option-label"><%=opt%>.</span> <%=optionText%>
                </div>
                <% } %>
            </div>
            <div class="answer-explanation">
                <span class="explanation-label">Explanation:</span>
                <div class="explanation-text"><%= (result.get("solution") != null && !result.get("solution").trim().isEmpty()) ? result.get("solution") : result.get("opt"+correctOption) %></div>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>






<%--

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

    List<Map<String, String>> resultDetails = (List<Map<String, String>>) request.getAttribute("resultDetails");
    Integer score = (Integer) request.getAttribute("score");
    Integer total = (Integer) request.getAttribute("total");

    if(resultDetails == null || score == null || total == null){
        response.sendRedirect("home.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz Results</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body { font-family:'Arial',sans-serif; background:linear-gradient(135deg,#0b0b2b 0%,#1a0033 100%); color:#fff; margin:0; padding:20px; min-height:100vh; }
.container { max-width:1200px; margin:0 auto; }
.header { text-align:center; margin-bottom:30px; }
.header h1 { color:#00e0ff; font-size:2.5em; margin-bottom:10px; }

.summary-section { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px; margin-bottom:40px; }
.summary-card { background: linear-gradient(135deg, rgba(17,19,77,0.9), rgba(11,13,58,0.9)); border-radius:15px; padding:20px; text-align:center; border:2px solid rgba(0,224,255,0.3); }
.summary-card .label { font-size:0.9em; color:#aaa; margin-bottom:10px; }
.summary-card .value { font-size:2.5em; font-weight:bold; color:#00e0ff; }
.summary-card.correct .value { color:#00ff88; }
.summary-card.wrong .value { color:#ff4444; }
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
.option.correct-answer { border: 2px solid #00ff88; background: rgba(0,255,136,0.05); }
.option.user-wrong { border: 2px solid #ff4444; background: rgba(255,68,68,0.05); }
.option-label { font-weight:bold; color:#00e0ff; margin-right:8px; }

.answer-explanation { background: rgba(0,224,255,0.1); border-left:3px solid #00e0ff; padding:15px; border-radius:8px; margin-top:15px; }
.answer-explanation .explanation-label { font-weight:bold; color:#00e0ff; margin-bottom:8px; display:block; }
.answer-explanation .explanation-text { color:#ddd; line-height:1.6; }
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Quiz Results</h1>
        <div class="level-badge">Score: <%= score %> / <%= total %></div>
    </div>

    <div class="questions-section">
        <h2 class="section-title">Detailed Solutions</h2>
        <%
            int questionNumber = 1;
            for(Map<String,String> result : resultDetails){
                String status = result.get("status");
                String userAnswer = result.get("user_answer");
                String correctOption = result.get("correct_option");
                String answerText = result.get("answer_text");

                String cardClass="not-attempted";
                String badgeClass="not-attempted";
                String badgeText="Not Attempted";

                if(status.equals("not_attempted")){
                    cardClass="not-attempted"; badgeClass="not-attempted"; badgeText="Not Attempted";
                } else if(status.equals("correct")){
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
                    for(String opt:options){
                        String optionText = result.get("option_" + opt.toLowerCase());
                        String optionClass = "";
                        if(opt.equals(correctOption)) optionClass="correct-answer";
                        if(userAnswer != null && opt.equals(userAnswer) && !opt.equals(correctOption)) optionClass="user-wrong";
                %>
                <div class="option <%=optionClass%>">
                    <span class="option-label"><%=opt%>.</span> <%=optionText%>
                </div>
                <% } %>
            </div>
            <div class="answer-explanation">
                <span class="explanation-label">Answer:</span>
                <div class="explanation-text"><%= (answerText != null && !answerText.trim().isEmpty()) ? answerText : result.get("option_"+correctOption.toLowerCase()) %></div>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>


--%>

