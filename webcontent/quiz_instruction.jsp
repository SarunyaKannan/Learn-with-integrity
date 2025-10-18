<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="navbar.jsp" %>
<% 
    %>
    <%@ page import="Module1.User" %>
    <%@ page import="Module1.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = user.getUsername();
    String email = user.getEmail();

    String courseId = request.getParameter("courseId"); 
    String courseTitle = request.getParameter("title");
    String sectionName = request.getParameter("section");
    
    


%>



<!DOCTYPE html>
<html>
<head>
    <title>Quiz Instructions</title>
    <style>
        body { font-family: Arial, sans-serif; background:#0a002b; color:white; margin:0; padding:0; }
        .container { max-width: 1000px; margin:30px auto; background:#11134d; padding:30px; border-radius:15px; box-shadow:0 4px 20px rgba(0,0,0,0.5); }
        h1 { color:#00e0ff; text-align:center; }
        .rules, .levels { margin:20px 0; padding:20px; background:#1a1a4d; border-radius:10px; }
        .rules h2, .levels h2 { color:#00e0ff; margin-bottom:15px; }
        ul { line-height:1.8em; }
        table { width:100%; border-collapse:collapse; margin-top:15px; }
        th, td { border:1px solid #444; padding:12px; text-align:center; }
        th { background:#007bff; color:white; }
        .btn { border:none; padding:12px 20px; border-radius:25px; cursor:pointer; margin:10px; font-size:15px; }
        .easy { background:#2ecc71; color:white; }
        .intermediate { background:#f39c12; color:white; }
        .hard { background:#e74c3c; color:white; }
        .btn:hover { opacity:0.9; }
    </style>
</head>
<body>
<div class="container">
    <h1>📘 Quiz Instructions</h1>
    <h1 style="color:pink";>Course: <%= courseTitle %></h1>
<p>Section: <%= sectionName %></p>
    
 <%-- --%   <p><strong>Course:</strong> <%= courseId %> | <strong>User:</strong> <%= username %></p>  --%>

    <div class="rules">
    <div style="text-align: right;">
    <a href="MyCoursesServlet" 
       style="text-decoration: none; color: #fff; background: #f44336; padding: 8px 12px; border-radius: 5px;">
       ✖ Close
    </a>
</div>
    
        <h2>⚠️ Rules & Regulations</h2>
        <ul>
            <li>📹 Webcam monitoring is mandatory</li>
            <li>⏰ Timing is enforced for each level</li>
            <li>🔍 Maximum 3 tab switches allowed</li>
            <li>🚫 Fullscreen mode is required</li>
            <li>🏆 Certificate & badges awarded on successful completion of all levels</li>
        </ul>
    </div>

    <div class="levels">
        <h2>🎯 Levels & Timing</h2>
        <table>
            <tr>
                <th>Level</th>
                <th>Questions</th>
                <th>Time (minutes)</th>
                <th>Unlock Criteria</th>
            </tr>
            <tr><td>Easy</td><td>5</td><td>5</td><td>Available</td></tr>
            <tr><td>Intermediate</td><td>10</td><td>10</td><td>Easy ≥ 4/5 and ≤3 tab switches</td></tr>
            <tr><td>Hard</td><td>15</td><td>15</td><td>Intermediate ≥ 9/10 and ≤3 tab switches</td></tr>
        </table>
    </div>

    <div style="text-align:center;">
        <button class="btn easy" onclick="startQuiz('EASY')">Start Easy</button>
        <button class="btn intermediate" onclick="startQuiz('INTERMEDIATE')">Start Intermediate</button>
        <button class="btn hard" onclick="startQuiz('HARD')">Start Hard</button>
    </div>
        <div class="rules">
        <h2>📊 Marks & Attempt Policy</h2>
        <ul>
            <li>✅ <b>Easy Level:</b> 5 questions × 20 marks each = 100 marks total</li>
            <li>✅ <b>Intermediate Level:</b> 10 questions × 10 marks each = 100 marks total</li>
            <li>✅ <b>Hard Level:</b> 15 questions × 6.67 marks each ≈ 100 marks total</li>
        </ul>

        <h3 style="color:#00e0ff;">🎯 Attempt Rules</h3>
        <ul>
            <li>🟢 Easy: First <b>2 attempts</b> have no penalty</li>
            <li>🟡 Intermediate: First <b>3 attempts</b> have no penalty</li>
            <li>🔴 Hard: First <b>4 attempts</b> have no penalty</li>
        </ul>

        <h3 style="color:#00e0ff;">📉 Mark Reduction After Free Attempts</h3>
        <ul>
            <li>❌ From the next attempt onwards, <b>10% of that question’s marks</b> will be reduced per extra attempt</li>
            <li>Example: Hard question (6.67 marks)<br>
                • Attempt 1–4: Full 6.67 marks<br>
                • Attempt 5: 6.00 marks<br>
                • Attempt 6: 5.33 marks<br>
                • Attempt 7: 4.67 marks ...</li>
        </ul>

        <p style="margin-top:10px; color:#ffcc00;">
            📌 Final result will show <b>percentage for each level</b> and overall percentage across Easy, Intermediate, and Hard.
        </p>
    </div>
    
</div>



<!-- Load face-api.js -->
<script defer src="https://cdn.jsdelivr.net/npm/face-api.js"></script>
<!-- Your exam monitor script -->
<script defer src="js/exam-monitor.js"></script>

<script>



function startQuiz(level) {
    fetch("QuizUnlockServlet?courseId=<%= courseId %>&level=" + level)
        .then(res => res.text())
        .then(data => {
            if (data.trim() === "ALLOWED") {
                // ✅ Go to QuizAttemptServlet, not directly to quiz.jsp
                window.location.href =
                  "QuizAttemptServlet?courseId=<%= courseId %>&title=<%= courseTitle %>&section=<%= sectionName %>&level=" + level;
            } else {
                alert(data);
            }
        })
        .catch(err => alert("Error checking unlock rules"));
}
<%--
function startQuiz(level) {
    fetch("QuizUnlockServlet?courseId=<%= courseId %>&level=" + level)
        .then(res => res.text())
        .then(data => {
            if (data.trim() === "ALLOWED") {
                // redirect to quiz.jsp with params
                window.location.href =
                  "quiz.jsp?courseId=<%= courseId %>&title=<%= courseTitle %>&section=<%= sectionName %>&level=" + level;
            } else {
                alert(data);
            }
        })
        .catch(err => alert("Error checking unlock rules"));
}--%>
</script>

</body>
</html> 
