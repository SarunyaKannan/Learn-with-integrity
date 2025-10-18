<%@ page import="java.sql.*, java.util.*, Module1.DbConnection,Module1.User" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<%
    // Get logged in user from session
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> courses = new ArrayList<>();

    try {
        Connection con = DbConnection.getConnection();

        // Get user courses
        String sql = "SELECT c.id, c.title FROM user_courses uc " +
                     "JOIN courses_1 c ON uc.course_id = c.id " +
                     "WHERE uc.username = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, user.getUsername());
        ResultSet rs = ps.executeQuery();

        while(rs.next()){
            Map<String,Object> course = new HashMap<>();
            course.put("id", rs.getInt("id"));
            course.put("title", rs.getString("title"));
            courses.add(course);
        }

        rs.close();
        ps.close();
        con.close();
    } catch(Exception e){
        e.printStackTrace();
    }
%>
<%--
<html>
<head>
    <title>Practice Quiz</title>
    <style>
        body { font-family: Arial; background: #0b0b2b; color: white; padding: 20px; }
        .form-box { background: rgba(255,255,255,0.07); padding: 20px; border-radius: 10px; width: 400px; margin: auto; }
        label { display: block; margin-top: 10px; }
        select, input { width: 100%; padding: 8px; margin-top: 5px; border-radius: 5px; border: none; }
        button { margin-top: 20px; padding: 10px 20px; border: none; background: #00c6ff; color: white; border-radius: 5px; cursor: pointer; }
        button:hover { background: #ffcc00; color: black; }
    </style>
    <script>
        function updateOptions() {
            var level = document.getElementById("level").value;
            var numQ = document.getElementById("numQuestions");
            var time = document.getElementById("timeLimit");

            if(level === "EASY") {
                numQ.value = 5;
                time.value = 5;
                numQ.readOnly = true;
                time.readOnly = false; // user can pick 1–5
                time.min = 1;
                time.max = 5;
            } else if(level === "INTERMEDIATE") {
                numQ.value = 10;
                time.value = 10;
                numQ.readOnly = true;
                time.readOnly = false;
                time.min = 1;
                time.max = 10;
            } else if(level === "HARD") {
                numQ.value = 15;
                time.value = 15;
                numQ.readOnly = true;
                time.readOnly = false;
                time.min = 1;
                time.max = 15;
            } else if(level === "DYNAMIC") {
                numQ.value = "";
                time.value = "";
                numQ.readOnly = false;
                time.readOnly = false;
                time.min = 1;
                time.removeAttribute("max");
            }
        }
    </script>
</head>
<body>
    <h2 align="center">Start Practice Quiz</h2>
    <div class="form-box">
        <form action="StartPracticeQuizServlet" method="post">

           <!-- Course -->
<label for="courseId">Select Course:</label>
<select name="courseId" id="courseId" required>
    <%
        if(courses.isEmpty()) {
    %>
        <option value="" disabled selected>No enrolled courses</option>
    <%
        } else {
    %>
        <option value="">-- Select Course --</option>
        <%
            for(Map<String,Object> c : courses){
        %>
            <option value="<%=c.get("id")%>"><%=c.get("title")%></option>
        <%
            }
        }
    %>
</select>

<!-- Level -->
<label for="level">Select Level:</label>
<select name="level" id="level" onchange="updateOptions()" required <%= courses.isEmpty() ? "disabled" : "" %>>
    <option value="">-- Select Level --</option>
    <option value="EASY">Easy</option>
    <option value="INTERMEDIATE">Intermediate</option>
    <option value="HARD">Hard</option>
    <option value="DYNAMIC">Dynamic</option>
</select>

<!-- Number of Questions -->
<label for="numQuestions">Number of Questions:</label>
<input type="number" name="numQuestions" id="numQuestions" required readonly <%= courses.isEmpty() ? "disabled" : "" %>>

<!-- Time Limit -->
<label for="timeLimit">Time Limit (minutes):</label>
<input type="number" name="timeLimit" id="timeLimit" required readonly <%= courses.isEmpty() ? "disabled" : "" %>>

<!-- Button -->
<button type="submit" <%= courses.isEmpty() ? "disabled" : "" %>>Start Quiz</button>

        </form>
    </div>
</body>
</html>  --%>




<html>
<head>
    <title>Practice Quiz</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background: linear-gradient(135deg,#0b0b2b 0%,#1a0033 100%); 
            color: white; 
            padding: 20px; 
        }
        .form-box { 
            background: rgba(255,255,255,0.05); 
            padding: 25px; 
            border-radius: 12px; 
            width: 400px; 
            margin: 20px auto; 
            border: 2px solid rgba(0,224,255,0.3);
            box-shadow: 0 5px 20px rgba(0,224,255,0.2);
            transition: box-shadow 0.3s ease, border 0.3s ease;
        }
        .form-box:hover {
            box-shadow: 0 10px 30px rgba(0,224,255,0.4);
            border-color: #00e0ff;
        }
        h2 { 
            text-align: center; 
            color: #00e0ff; 
            margin-bottom: 20px; 
            text-shadow: 0 0 10px rgba(0,224,255,0.5);
        }
        label { 
            display: block; 
            margin-top: 10px; 
            font-weight: bold; 
            color: #00e0ff;
        }
        select, input { 
    width: 100%; 
    padding: 8px; 
    margin-top: 5px; 
    border-radius: 5px; 
    border: 1px solid rgba(255,255,255,0.2); 
    background: #111;          /* Dark black background */
    color: white;              /* White text */
    font-size: 1em;
    transition: border 0.3s ease, background 0.3s ease, color 0.3s ease;
}

/* Focus effect for select and input */
select:focus, input:focus {
    outline: none;
    border-color: #00e0ff;
    background: #222;         /* Slightly lighter on focus */
}

/* Disabled state */
select:disabled, input:disabled {
    background: #111;
    color: #777;
    cursor: not-allowed;
}
        
        
        button { 
            margin-top: 20px; 
            padding: 10px 20px; 
            border: none; 
            background: linear-gradient(45deg,#00c6ff,#0072ff); 
            color: white; 
            border-radius: 5px; 
            cursor: pointer; 
            font-weight: bold;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        button:hover { 
            background: linear-gradient(45deg,#ffcc00,#ff9900); 
            color: black;
            transform: scale(1.05);
        }
        select:disabled, input:disabled, button:disabled {
            background: rgba(255,255,255,0.02);
            color: #777;
            cursor: not-allowed;
        }
    </style>
    <script>
        function updateOptions() {
            var level = document.getElementById("level").value;
            var numQ = document.getElementById("numQuestions");
            var time = document.getElementById("timeLimit");

            if(level === "EASY") {
                numQ.value = 5;
                time.value = 5;
                numQ.readOnly = true;
                time.readOnly = false;
                time.min = 1;
                time.max = 5;
            } else if(level === "INTERMEDIATE") {
                numQ.value = 10;
                time.value = 10;
                numQ.readOnly = true;
                time.readOnly = false;
                time.min = 1;
                time.max = 10;
            } else if(level === "HARD") {
                numQ.value = 15;
                time.value = 15;
                numQ.readOnly = true;
                time.readOnly = false;
                time.min = 1;
                time.max = 15;
            } else if(level === "DYNAMIC") {
                numQ.value = "";
                time.value = "";
                numQ.readOnly = false;
                time.readOnly = false;
                time.min = 1;
                time.removeAttribute("max");
            }
        }
    </script>
</head>
<body>
    <h2 align="center">Start Practice Quiz</h2>
    <div class="form-box">
        <form action="StartPracticeQuizServlet" method="post">

           <!-- Course -->
           <label for="courseId">Select Course:</label>
           <select name="courseId" id="courseId" required>
               <%
                   if(courses.isEmpty()) {
               %>
                   <option value="" disabled selected>No enrolled courses</option>
               <%
                   } else {
               %>
                   <option value="">-- Select Course --</option>
                   <%
                       for(Map<String,Object> c : courses){
                   %>
                       <option value="<%=c.get("id")%>"><%=c.get("title")%></option>
                   <%
                       }
                   }
               %>
           </select>

           <!-- Level -->
           <label for="level">Select Level:</label>
           <select name="level" id="level" onchange="updateOptions()" required <%= courses.isEmpty() ? "disabled" : "" %>>
               <option value="">-- Select Level --</option>
               <option value="EASY">Easy</option>
               <option value="INTERMEDIATE">Intermediate</option>
               <option value="HARD">Hard</option>
               <option value="DYNAMIC">Dynamic</option>
           </select>

           <!-- Number of Questions -->
           <label for="numQuestions">Number of Questions:</label>
           <input type="number" name="numQuestions" id="numQuestions" required readonly <%= courses.isEmpty() ? "disabled" : "" %>>

           <!-- Time Limit -->
           <label for="timeLimit">Time Limit (minutes):</label>
           <input type="number" name="timeLimit" id="timeLimit" required readonly <%= courses.isEmpty() ? "disabled" : "" %>>

           <!-- Button -->
           <button type="submit" <%= courses.isEmpty() ? "disabled" : "" %>>Start Quiz</button>

        </form>
    </div>
</body>
</html>

