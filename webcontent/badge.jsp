<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Badges</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: rgba(11, 11, 43, 0.925);
            color: white;
            margin: 0;
            padding: 0;
        }
        h2 {
            text-align: center;
            margin: 30px 0;
        }
        .badge-container {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            padding: 20px;
        }
        .badge-card {
            background: #1f1f2e;
            border-radius: 10px;
            margin: 10px;
            padding: 20px;
            text-align: center;
            width: 200px;
            box-shadow: 0px 0px 10px rgba(0,255,255,0.2);
        }
        .badge-card:hover {
            box-shadow: 0px 0px 20px rgba(0,255,255,0.4);
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
    <h2>🏅 My Badges</h2>
    <div class="badge-container">
        <%
            List<String> badges = (List<String>) request.getAttribute("badges");
            if (badges != null && !badges.isEmpty()) {
                for (String badge : badges) {
        %>
            <div class="badge-card">
                <h3><%= badge %></h3>
                <p>Well Done!</p>
            </div>
        <%
                }
            } else {
        %>
            <p style="text-align:center; color:white;">No badges earned yet.</p>
        <%
            }
        %>
    </div>
</body>
</html>
