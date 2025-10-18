<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String level = request.getParameter("level");
    if (level == null) level = "easy";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Timer Fix</title>
    <style>
        .timer {
            color: red;
            font-weight: bold;
            position: fixed;
            top: 10px;
            right: 20px;
        }
    </style>
</head>
<body>

<h2>Level: <%= level %></h2>
<div id="timer" class="timer">Time Left: --:--</div>

<script>
    window.onload = function () {
        const level = "<%= level %>";
        let totalSeconds = level === "easy" ? 300 : level === "intermediate" ? 600 : 900;

        const timerEl = document.getElementById("timer");

        function updateTimer() {
            const min = Math.floor(totalSeconds / 60);
            const sec = totalSeconds % 60;
            timerEl.textContent = `Time Left: ${min}m ${sec < 10 ? '0' : ''}${sec}s`;
            if (totalSeconds <= 0) {
                clearInterval(timer);
                alert("Time's up!");
            }
            totalSeconds--;
        }

        updateTimer();
        const timer = setInterval(updateTimer, 1000);
    };
</script>

</body>
</html>
