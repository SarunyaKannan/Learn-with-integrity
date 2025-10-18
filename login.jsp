<!--  <!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
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
        color: white;
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

    /* Section contents */
    .contents {
        display: flex;
        justify-content: space-around;
        align-items: center;
        flex-wrap: wrap;
        gap: 30px;
        padding: 40px 20px;
        position: relative;
    }

    .divider {
    width: 0;
    min-height: 250px;
    border-left: 3px dotted #ccc;
    margin: 0 15px;
}

    /* Fade section card */
    .fade-section {
    background-color: #f9ffff; /* lighter than azure */
    color: #0b0b2b;           /* dark navy */


        width: 400px;
        padding: 20px;
        border-radius: 10px;
        opacity: 0;
        animation: fadeInUp 1.8s ease-out forwards;
        transform: translateY(30px);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .fade-section:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    /* Image container */
    .img-container {
        opacity: 0;
        animation: fadeFromSide 1.8s ease-out forwards;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .img-left {
    animation: fadeInLeft 1.8s ease-out forwards;
}
.img-right {
    animation: fadeInRight 1.8s ease-out forwards;
}


    .img-container img {
        height: 300px;
        width: 400px;
        border-radius: 25px;
        display: block;
        margin-bottom: 10px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .img-container:hover img {
        transform: scale(1.05);
        box-shadow: 0 8px 20px rgba(255, 255, 255, 0.3);
    }

    p {
        font-size: 20px;
        line-height: 1.6;
    }

    /* Footer */
    .footer {
        background-color: rgba(11, 11, 43, 0.925);
        text-decoration: none;
        color: aqua;
        text-align: center;
        padding: 15px;
    }

    .footer a {
        color: aqua;
    }

    /* Animations */
    @keyframes fadeInUp {
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes fadeInLeft {
        to {
            opacity: 1;
            transform: translateX(0);
        }
        from {
            transform: translateX(-50px);
        }
    }

    @keyframes fadeInRight {
        to {
            opacity: 1;
            transform: translateX(0);
        }
        from {
            transform: translateX(50px);
        }
    }

        .box {
            width: 220px;
            height: 300px;
            border: 2px solid black;
            background-color: white;
            border-radius: 25px;
            margin-top: 150px;
            margin-left: 550px;
        }

        h2 {
            font-weight: bold;
            font-family: Georgia, 'Times New Roman', Times, serif;
            color: red;
        }

        input {
            border-width: 2px;
        }

        .submit {
            border-radius: 25px;
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            color: white;
        }

        a {
            text-decoration: none;
        }
        .footer {
        background-color: rgba(11, 11, 43, 0.925);
        text-decoration: none;
        color: aqua;
        text-align: center;
        padding: 15px;
    }
    </style>
</head>
<body>
 <div class="all">
        <!-- Header --
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

        <hr>  -->
        <%-- --%

<%
    String msg = (String) request.getAttribute("message");
    if (msg != null) {
%>
    <div style="
        background-color: #d4edda;
        color: #155724;
        padding: 15px;
        margin: 20px auto;
        border: 1px solid #c3e6cb;
        border-radius: 10px;
        width: 80%;
        text-align: center;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        box-shadow: 0px 2px 8px rgba(0,0,0,0.1);
    ">
        <%= msg %>
    </div>
<%
    }
%>


    <div class="box" align="center">
        <form action="LoginServlet" method="post">
            <h2>Username</h2>
            <input type="text" name="userIdentifier" placeholder="Enter username or email"><br>

            <h2>Password</h2>
            <input type="password" name="password" id="password"><br>
            <input type="checkbox" id="togglePassword">
            <label for="togglePassword" style="color:black;">Show Password</label>

            <br><br><br>
            <div class="submit">
                <input type="submit" value="Login">
                <a href="pwdreset.jsp">forgot password</a>
            </div>
        </form>
    </div>
    
     <div class="footer">
            <h2>Contact us: 📩 <a href="mailto:learnwithintegrity@gmail.com">learnwithintegrity@gmail.com</a></h2>
        </div>
    </div>

    <script>
        document.getElementById('togglePassword').addEventListener('change', function () {
            const passwordField = document.getElementById('password');
            passwordField.type = this.checked ? 'text' : 'password';
        });
    </script>
</body>
</html>  --%>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
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
        color: white;
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

    /* Main Content → centers login box */
    .main-content {
        flex: 1; /* take up remaining height */
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

input[type="text"],
input[type="password"] {
    width: 100%;
    padding: 10px;
    margin-bottom: 20px;
    border: 2px solid #ccc;
    border-radius: 10px;
    font-size: 16px;
    transition: border-color 0.3s ease;
}

input[type="text"]:focus,
input[type="password"]:focus {
    border-color: rgba(11, 11, 43, 0.925);
    outline: none;
}

.submit {
    display: flex;
    justify-content: space-between;
    align-items: center;
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
    background-color:rgba(11, 11, 43, 0.925) ;
    color: White;
}

.submit a {
    font-size: 17px;
    color: blueviolet;
    text-decoration: none;
}

.submit a:hover {
    text-decoration: underline;
}


    /* Footer */
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

<%
    String msg = (String) request.getAttribute("message");
    if (msg != null) {
%>
    <div style="
        background:linear-gradient(145deg, #ffffff, #e6faff);;
        color: #155724;
        padding: 15px;
        margin: 20px auto;
        border: 1px solid #c3e6cb;
        border-radius: 10px;
        width: 80%;
        text-align: center;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        box-shadow: 0px 2px 8px rgba(0,0,0,0.1);
    ">
        <%= msg %>
    </div>
<%
    }
%>

    <!-- Login Box (Centered) -->
   <div class="main-content">
    <div class="box">
        <form action="LoginServlet" method="post">
            <h2>Username</h2>
            <input type="text" name="userIdentifier" placeholder="Enter username or email">

            <h2>Password</h2>
            <input type="password" name="password" id="password">
            <div style="text-align:left; margin-bottom:15px;">
                <input type="checkbox" id="togglePassword">
                <label for="togglePassword" style="color:black; font-size:17px;">Show Password</label>
            </div>

            <div class="submit">
                <input type="submit" value="Login">
                <a href="pwdreset.jsp">Forgot password?</a>
            </div>
        </form>
    </div>
</div>

    <br><br>
    <!-- Footer -->
    <div class="footer">
        <h2>Contact us: &#128231; 
            <a href="mailto:learnwithintegrity@gmail.com">learnwithintegrity@gmail.com</a>
        </h2>
    </div>
</div>

<script>
    document.getElementById('togglePassword').addEventListener('change', function () {
        const passwordField = document.getElementById('password');
        passwordField.type = this.checked ? 'text' : 'password';
    });
</script>
</body>
</html>
