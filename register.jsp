<!DOCTYPE html>
<html>
<head>
  <title>User Registration</title>
  <style>
  * {
        box-sizing: border-box;
    }

    body, html {
        margin: 0;
        padding: 0;
    }

    .all {
        background-color: rgba(11, 11, 43, 0.925);
        color: rgba(11, 11, 43, 0.925);
    }

    /* Header (Logo + Title + Buttons) */
    .titleback {
        background-color: rgba(11, 11, 43, 0.925);
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 30px;
    }

    /* Align logo and title */
    .title {
    display: flex;
    align-items: center;   /* ensures vertical centering */
    gap: 15px;
    line-height: 1;             /* spacing between logo and text */
}
    

    .title .logo {
   height: 75px;          /* larger than before */
    width: 200px;
    display: block;
}

    .title h1 {
        font-family: cursive;
        font-weight: normal;
        margin: 0;
        font-size: 2rem;
    }
    
    

    /* Buttons */
   button {
    background-color: transparent;
    color:WHITE ;
    border: 2px solid aqua;

      
        border-radius: 25px;
        cursor: pointer;
        font-size: 18px;
        padding: 10px 20px;
        margin-left: 10px;
        font-family: cursive;
        font-weight: bold;
    }
    button:hover {
    background-color: aqua;
    color: WHITE;
}
    

    a {
        text-decoration: none;
    }

    /* Hover box */
    .hover-box {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        border-radius: 15px;
    }

    .hover-box:hover {
        transform: scale(1.02);
        box-shadow: 0 0 25px rgba(255, 255, 255, 0.2);
        background-color: rgba(255, 255, 255, 0.02);
    }
    body {
      background-color:rgb(4, 4, 49);
      margin: 0;
      padding: 0;
    }

    .container {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .box {
      border-radius: 25px;
      border: solid 2px rgb(104, 204, 221);
      background-color: white;
      width: 500px;
      padding: 20px;
    }

    table {
      width: 100%;
    }

    td {
      padding: 10px;
    }

    h2 {
      color: red;
      text-align: center;
    }
  </style>

  <script>
    function checkEmail() {
      const email = document.getElementById("email").value;
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

      if (!emailPattern.test(email)) {
        alert("Invalid email address format!");
        return false; // Stop form submission
      }

      return true; // Allow submission
    }
  </script>
</head>

<body>
<%
    String errorMsg = (String) request.getAttribute("error");
    if (errorMsg != null) {
%>
    <div style="
        background-color: #f8d7da;
        color: #721c24;
        padding: 15px;
        margin-bottom: 20px;
        border: 1px solid #f5c6cb;
        border-radius: 10px;
        text-align: center;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        box-shadow: 0px 2px 8px rgba(0,0,0,0.1);
    ">
        <%= errorMsg %>
    </div>
<%
    }
%>
<div class="all">
        <!-- Header -->
        <div class="titleback">
            <div class="title">
                <img src="images/LWI_transparent.png" alt="LWI Logo" class="logo">
                <h1>Learn With Integrity</h1>
            </div>
            <div>
                <a href="login.jsp"><button>Login</button></a>
                <a href="register.jsp"><button>Sign Up</button></a>
            </div>
        </div>

        <hr>


  <div class="container">
    <div class="box">
      <form action="RegisterServlet" method="post" onsubmit="return checkEmail()">
        <table>
          <tr>
            <td colspan="2"><h2>Registration Form</h2></td>
          </tr>

          <tr>
            <td><h3>Name</h3></td>
            <td><input type="text" id="name" name="name" required></td>
          </tr>

          <tr>
            <td><h3>Mail ID</h3></td>
            <td><input type="email" id="email" name="email" required></td>
          </tr>

          <tr>
            <td><h3>Username</h3></td>
            <td><input type="text" id="username" name="username" required></td>
          </tr>

          <tr>
            <td><h3>Age</h3></td>
            <td>
              <select id="role" name="role" required>
                <option value="Student">7-17</option>
                <option value="Worker">18-30</option>
                <option value="Learner">30 & above</option>
              </select>
            </td>
          </tr>

          <tr>
            <td><h3>Gender</h3></td>
            <td>
              <input type="radio" name="gender" value="Male" required> Male
              <input type="radio" name="gender" value="Female"> Female
              <input type="radio" name="gender" value="Transgender"> Transgender
            </td>
          </tr>

          <tr>
            <td colspan="2" align="center">
              <input type="submit" value="Submit">
            </td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</body>
</html>
