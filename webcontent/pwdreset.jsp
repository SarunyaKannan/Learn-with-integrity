<%-- --<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
    </head>
    <style>
    * {
        box-sizing: border-box;
    }

    body, html {
        margin: 0;
        padding: 0;
        height: 100%; /* Needed for flex centering */
    }

    .all {
        background-color: rgba(11, 11, 43, 0.925);
        color: black;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
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

    .title {
        display: flex;
        align-items: center;
        gap: 15px;
        line-height: 1;
    }

    .title .logo {
        height: 75px;
        width: 200px;
        display: block;
    }

    .title h1 {
        font-family: cursive;
        font-weight: bold;
        margin: 0;
        font-size: 2rem;
    }

    /* Buttons */
    button {
        background-color: transparent;
        color: white;
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
        color: black;
    }

    a {
        text-decoration: none;
    }
    
        body{
            background-color:rgb(4, 4, 49);
        }
     .box{
        width:220px;
        height:300px;
        border:2px solid black;
        background-color:white;
    
    
        border-radius:25px;
        margin-top: 150px;
        margin-left:550px;
     }
     h2{
        font-weight: bold;
        font-family:Georgia, 'Times New Roman', Times, serif;
        color:red;
     }
     input{
        border-width: 2px;
     }
     .submit{
        border-radius:25px;
        
        display:flex;
        justify-content:space-between;
        font-size:20px;
        color:white;

     }
     a{
        text-decoration: none;
     }
         .footer {
        background-color: rgba(11, 11, 43, 0.925);
        color: aqua;
        text-align: center;
        padding: 15px;
    }

    .footer a {
        color: aqua;
    }
     
    </style>
    <body>
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
                    <div class="box" align="center">
        <form action="PwdReset" method="post">
            <h2>Password Reset</h2>
             
             <p>Enter your registered mail id. Password will be sent to your mail id!</p>
        
            
            <input type="email" name="email" placeholder="Enter email"><br>
            
            <br>
        
            <input  type="submit" value="Submit">
           
            

        
        
        </form>
         <br><br><br>
         <br>
         <br>
         <br>
    <!-- Footer -->
    <div class="footer">
        <h2>Contact us: &#128231; 
            <a href="mailto:learnwithintegrity@gmail.com">learnwithintegrity@gmail.com</a>
        </h2>
    </div>

        </div>
        
    </body>
</html>  --%>
<!DOCTYPE html>
<html>
<head>
    <title>Password Reset</title>
    <style>
    * { box-sizing: border-box; }
    body, html { margin: 0; padding: 0; height: 100%; }

    .all {
        background-color: rgba(11, 11, 43, 0.925);
        color: white;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    /* Header */
    .titleback {
        background-color: rgba(11, 11, 43, 0.925);
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 30px;
    }

    .title {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .title .logo {
        height: 75px;
        width: 200px;
    }

    .title h1 {
        font-family: cursive;
        font-weight: bold;
        margin: 0;
        font-size: 2rem;
    }

    button {
        background-color: transparent;
        color: white;
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
        color: black;
    }

    a { text-decoration: none; }

    /* Main Content */
    .main-content {
        flex: 1;
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
        margin-bottom: 15px;
    }

    input[type="email"] {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px;
        border: 2px solid #ccc;
        border-radius: 10px;
        font-size: 16px;
    }

    input[type="submit"] {
        background-color: transparent;
        color: #0b0b2b;
        border: rgba(11, 11, 43, 0.925);
        border-radius: 25px;
        padding: 8px 20px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
    }

    input[type="submit"]:hover {
        background-color: rgba(11, 11, 43, 0.925);
        color: white;
    }

    /* Footer */
    .footer {
        background-color: rgba(11, 11, 43, 0.925);
        color: aqua;
        text-align: center;
        padding: 15px;
    }
    .footer a { color: aqua; }
    </style>
</head>
<body>
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

    <!-- Message Box -->
    <%
        String msg = (String) request.getAttribute("message");
        if (msg != null) {
    %>
        <div style="
            background:linear-gradient(145deg, #ffffff, #e6faff);
            color:#0b0b2b;
            padding:15px;
            margin:20px auto;
            border:1px solid #c3e6cb;
            border-radius:10px;
            width:80%;
            text-align:center;
            font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
            box-shadow:0px 2px 8px rgba(0,0,0,0.1);">
            <%= msg %>
        </div>
    <%
        }
    %>

    <!-- Reset Form -->
    <div class="main-content">
        <div class="box">
            <form action="PwdReset" method="post">
                <h2>Password Reset</h2>
                <p style="color:black;">Enter your registered mail id. Password will be sent to your mail.</p>
                <input type="email" name="email" placeholder="Enter email" required>
                <input type="submit" value="Submit">
            </form>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <h2>Contact us: &#128231;
            <a href="mailto:learnwithintegrity@gmail.com">learnwithintegrity@gmail.com</a>
        </h2>
    </div>
</div>
</body>
</html>

