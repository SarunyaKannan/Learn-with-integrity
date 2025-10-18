<%-- --%<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Module1.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Password Change</title>
    <style>
    
        body {
            font-family: Arial, sans-serif;
            background: #f5f6fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 350px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        label {
            font-size: 14px;
            color: #555;
        }
        .input-group {
            position: relative;
            margin-bottom: 15px;
        }
        input[type="password"], input[type="text"] {
            width: 100%;
            padding: 10px 40px 10px 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            outline: none;
        }
        .toggle-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 14px;
            color: #888;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #4CAF50;
            border: none;
            color: white;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
        }
        button:hover {
            background: #45a049;
        }
    </style>
    <script>
        function togglePassword(id, toggleId) {
            const input = document.getElementById(id);
            const toggle = document.getElementById(toggleId);
            if (input.type === "password") {
                input.type = "text";
                toggle.innerText = "🙈";
            } else {
                input.type = "password";
                toggle.innerText = "👁️";
            }
        }

        // check password match before submitting
        function validateForm() {
            const newPwd = document.getElementById("newPwd").value;
            const confirmPwd = document.getElementById("confirmPwd").value;

            if (newPwd !== confirmPwd) {
                alert("Passwords do not match!");
                return false; // prevent form submit
            }
            return true; // submit to servlet
        }
    </script>
</head>
<body>
<%
    // Retrieve user object from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

 String email=user.getEmail();
 %>
<div class="container">
    <h2>Password Change</h2>
    <!-- form now points directly to PwdReset servlet -->
    <form method="post" action="PwdReset" onsubmit="return validateForm()">
        <label>Enter your new Password</label>
        <div class="input-group">
            <input type="password" id="newPwd" name="newPwd" required>
            <span class="toggle-btn" id="toggle1" onclick="togglePassword('newPwd','toggle1')">👁️</span>
        </div>

        <label>Confirm new Password</label>
        <div class="input-group">
            <input type="password" id="confirmPwd" name="confirmPwd" required>
            <span class="toggle-btn" id="toggle2" onclick="togglePassword('confirmPwd','toggle2')">👁️</span>
        </div>

        <!-- hidden email field (can be set from session or request) -->
        <input type="hidden" name="email" value="<%=email %>">

        <button type="submit">Save</button>
    </form>
</div>
</body>
</html>
--%
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="Module1.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password - LWI</title>
    <style>
    body, html {
        margin: 0;
        padding: 0;
        height: 100%;
        background-color: rgba(11, 11, 43, 0.925);
        font-family: Arial, sans-serif;
    }

    .main-content {
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .box {
        width: 350px;
        padding: 30px;
        background: linear-gradient(145deg, #ffffff, #e6faff);
        border-radius: 20px;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0,0,0,0.4);
    }

    .box h2 {
        font-family: Arial, sans-serif;
        font-size: 20px;
        color: red;
        margin-bottom: 8px;
        text-align: left;
    }

    input[type="password"] {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px;
        border: 2px solid #ccc;
        border-radius: 10px;
        font-size: 16px;
        transition: border-color 0.3s ease;
    }

    input[type="password"]:focus {
        border-color: rgba(11, 11, 43, 0.925);
        outline: none;
    }

    .submit {
        display: flex;
        justify-content: center;
        margin-top: 15px;
    }

    .submit input[type="submit"] {
        background-color: transparent;
        color: #0b0b2b;
        border: 2px solid aqua;
        border-radius: 25px;
        padding: 8px 20px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
    }

    .submit input[type="submit"]:hover {
        background-color: rgba(11, 11, 43, 0.925);
        color: white;
    }
    </style>

    <script>
        function validateForm() {
            const newPwd = document.getElementById("newPwd").value;
            const confirmPwd = document.getElementById("confirmPwd").value;

            if (newPwd !== confirmPwd) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = user.getEmail();
%>

<div class="main-content">
    <div class="box">
        <form method="post" action="PwdReset" onsubmit="return validateForm()">
            <h2>New Password</h2>
            <input type="password" id="newPwd" name="newPwd" required>

            <h2>Confirm Password</h2>
            <input type="password" id="confirmPwd" name="confirmPwd" required>

            <input type="hidden" name="email" value="<%=email %>">

            <div class="submit">
                <input type="submit" value="Save">
            </div>
        </form>
    </div>
</div>
</body>
</html>
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="Module1.User" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password - LWI</title>
    <style>
    body, html {
        margin: 0;
        padding: 0;
        height: 100%;
        background-color: rgba(11, 11, 43, 0.925);
        font-family: Arial, sans-serif;
    }

    .main-content {
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .box {
        width: 350px;
        padding: 30px;
        background: linear-gradient(145deg, #ffffff, #e6faff);
        border-radius: 20px;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0,0,0,0.4);
    }

    .box h2 {
        font-family: Arial, sans-serif;
        font-size: 20px;
        color: red;
        margin-bottom: 8px;
        text-align: left;
    }

    .input-group {
        position: relative;
        margin-bottom: 20px;
    }

    input[type="password"], input[type="text"] {
        width: 100%;
        padding: 10px 40px 10px 10px;
        border: 2px solid #ccc;
        border-radius: 10px;
        font-size: 16px;
        transition: border-color 0.3s ease;
    }

    input:focus {
        border-color: rgba(11, 11, 43, 0.925);
        outline: none;
    }

    .toggle-btn {
        position: absolute;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
        cursor: pointer;
        font-size: 18px;
        color: #555;
    }

    .submit {
        display: flex;
        justify-content: center;
        margin-top: 15px;
    }

    .submit input[type="submit"] {
        background-color: transparent;
        color: #0b0b2b;
        border: 2px solid aqua;
        border-radius: 25px;
        padding: 8px 20px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
    }

    .submit input[type="submit"]:hover {
        background-color: rgba(11, 11, 43, 0.925);
        color: white;
    }
    </style>

    <script>
        function togglePassword(id, toggleId) {
            const input = document.getElementById(id);
            const toggle = document.getElementById(toggleId);
            if (input.type === "password") {
                input.type = "text";
                toggle.innerText = "🙈";
            } else {
                input.type = "password";
                toggle.innerText = "👁️";
            }
        }

        function validateForm() {
            const newPwd = document.getElementById("newPwd").value;
            const confirmPwd = document.getElementById("confirmPwd").value;

            if (newPwd !== confirmPwd) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = user.getEmail();
%>

<div class="main-content">
    <div class="box">
        <form method="post" action="PwdReset" onsubmit="return validateForm()">
            <h2>New Password</h2>
            <div class="input-group">
                <input type="password" id="newPwd" name="newPwd" required>
                <span class="toggle-btn" id="toggle1" onclick="togglePassword('newPwd','toggle1')">👁️</span>
            </div>

            <h2>Confirm Password</h2>
            <div class="input-group">
                <input type="password" id="confirmPwd" name="confirmPwd" required>
                <span class="toggle-btn" id="toggle2" onclick="togglePassword('confirmPwd','toggle2')">👁️</span>
            </div>

            <input type="hidden" name="email" value="<%=email %>">

            <div class="submit">
                <input type="submit" value="Save">
            </div>
        </form>
    </div>
</div>
</body>
</html>
