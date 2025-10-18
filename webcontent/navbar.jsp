 <%-- <%@ page session="true" %>

<style>
body {
    background-color: rgba(11, 11, 43, 0.925);
    margin: 0;
    padding: 0;
}
.titleback {
    background-color: rgba(11, 11, 43, 0.925);
    color: white;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
}
.title {
    font-family: cursive;
    margin-left: 20px;
}
a {
    text-decoration: none;
    color: white;
}
h1 {
    color: white;
}
.nav {
    padding-top: 25px;
    padding-right: 20px;
    font-size: 25px;
}
.color-change {
    animation: changecolor 2s infinite alternate;
}
@keyframes changecolor {
    0% { color: #2c3e50; }
    100% { color: #00bcd4; }
}
</style>

<div class="titleback">
    <div class="title">
        <h1>Learn With Integrity</h1>
    </div>
    <div class="nav">
        <a href="home.jsp">Home |</a>
        <a href="MyCoursesServlet">My Courses |</a>
        <a href="explore">Explore |</a>
        <a href="logout">Logout</a>
    </div>
</div>
<hr>
<%@ page session="true" %>

<style>
body {
    background-color: rgba(11, 11, 43, 0.925);
    margin: 0;
    padding: 0;
}
.titleback {
    background-color: rgba(11, 11, 43, 0.925);
    color: white;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    box-shadow: 0px 2px 6px rgba(0,0,0,0.4);
}
.title h1 {
    font-family: cursive;
    font-size: 30px;
    margin: 0;
}
.nav {
    font-size: 20px;
    display: flex;
    gap: 25px;
}
.nav a {
    text-decoration: none;
    color: white;
    padding: 8px 14px;
    border-radius: 8px;
    transition: all 0.3s ease-in-out;
    font-family: Arial, sans-serif;
    display: flex;
    align-items: center;
    gap: 6px;
}
.nav a:hover {
    background-color: #00bcd4;
    color: #0b0b2b;
    transform: scale(1.05);
}
.nav a:active, .nav a:focus {
    background-color: #ffcc00;
    color: #0b0b2b;
}
</style>

<div class="titleback">
    <div class="title">
        <h1>Learn With Integrity</h1>
    </div>
    <div class="nav">
        <a href="home.jsp">🏠 Home</a>
        <a href="MyCoursesServlet">📖 My Courses</a>
        <a href="explore">🔍 Explore</a>
        <a href="logout">🚪 Logout</a>
    </div>
</div>
<hr>
<%@ page session="true" %>

<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
body {
    background-color: rgba(11, 11, 43, 0.925);
    margin: 0;
    padding: 0;
}

/* Header container */
.titleback {
    background-color: rgba(11, 11, 43, 0.925);
    color: white;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    box-shadow: 0px 2px 6px rgba(0,0,0,0.4);
}

/* Title with gradient + dark pink border */
.title h1 {
    font-family: cursive;
    font-size: 38px;
    margin: 0;

    /* Gradient text fill */
    background: linear-gradient(270deg, #ffffff, #ffb6c1, #ffffff);
    background-size: 300% 300%;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    animation: gradientShift 8s ease infinite;

    /* Dark pink outline */
    -webkit-text-stroke: 2px #c71585;
    text-stroke: 2px #c71585;
}

/* Gradient animation */
@keyframes gradientShift {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* Nav bar */
.nav {
    font-size: 18px;
    display: flex;
    gap: 25px;
}

/* Nav links */
.nav a {
    text-decoration: none;
    color: #f1f1f1;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.35s ease-in-out;
    font-family: Arial, sans-serif;
    display: flex;
    align-items: center;
    gap: 8px;
    position: relative;
}

/* Separator lines between items */
.nav a:not(:last-child)::after {
    content: "";
    position: absolute;
    right: -15px;
    top: 20%;
    height: 60%;
    width: 1px;
    background: rgba(255,255,255,0.3);
}

/* Hover effect */
.nav a:hover {
    background: linear-gradient(135deg, #00c6ff, #0072ff);
    color: #ffffff;
    transform: translateY(-2px);
    box-shadow: 0px 4px 10px rgba(0,0,0,0.3);
}

/* Active/Focus state */
.nav a:active, .nav a:focus {
    background: linear-gradient(135deg, #ffcc00, #ff9900);
    color: #0b0b2b;
}
</style>

<!-- HEADER -->
<div class="titleback">
    <div class="title">
        <h1>Learn With Integrity</h1>
    </div>
    <div class="nav">
        <a href="home.jsp"><i class="fas fa-home"></i> Home</a>
        <a href="MyCoursesServlet"><i class="fas fa-book"></i> My Courses</a>
        <a href="explore"><i class="fas fa-search"></i> Explore</a>
        <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</div>
<hr>--%
<%@ page session="true" %>

<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
body {
    background-color: rgba(11, 11, 43, 0.925);
    margin: 0;
    padding: 0;
}

/* Header container */
.titleback {
    background-color: rgba(11, 11, 43, 0.925);
    color: white;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    box-shadow: 0px 2px 6px rgba(0,0,0,0.4);
}

/* Title – simple clean white */
.title h1 {
    font-family: cursive;
    font-size: 38px;
    margin: 0;
    color: #ffffff;
}

/* Nav bar */
.nav {
    font-size: 18px;
    display: flex;
    gap: 25px;
}
/* Logo inside header title */
.logo {
    height: 45px;
    margin-right: 12px;
    vertical-align: middle;
}

/* Small logo inside nav */
.nav-logo {
    height: 22px;
    margin-right: 6px;
}


/* Nav links */
.nav a {
    text-decoration: none;
    color: #f1f1f1;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.35s ease-in-out;
    font-family: Arial, sans-serif;
    display: flex;
    align-items: center;
    gap: 8px;
    position: relative;
}

/* Separator lines between items */
.nav a:not(:last-child)::after {
    content: "";
    position: absolute;
    right: -15px;
    top: 20%;
    height: 60%;
    width: 1px;
    background: rgba(255,255,255,0.3);
}

/* Hover effect */
.nav a:hover {
    background: linear-gradient(135deg, #00c6ff, #0072ff);
    color: #ffffff;
    transform: translateY(-2px);
    box-shadow: 0px 4px 10px rgba(0,0,0,0.3);
}

/* Active/Focus state */
.nav a:active, .nav a:focus {
    background: linear-gradient(135deg, #ffcc00, #ff9900);
    color: #0b0b2b;
}
</style>

<!-- HEADER -->
<div class="titleback">
    <div class="title">
    <img src="images/LWI_transparent.png" alt="LWI Logo" class="logo">
        <h1>Learn With Integrity</h1>
    </div>
    <div class="nav">
        <a href="UserDashboard"><i class="fas fa-home"></i> Home</a>
        <a href="MyCoursesServlet"><i class="fas fa-book"></i> My Courses</a>
        <a href="explore"><i class="fas fa-search"></i> Explore</a>
        <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</div>
<hr>--%>











<%--for new navigation --%>
<%@ page session="true" %>

<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
body {
    background-color: rgba(11, 11, 43, 0.925);
    margin: 0;
    padding: 0;
}

/* Header container */
.titleback {
    background-color: rgba(11, 11, 43, 0.925);
    color: white;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    box-shadow: 0px 2px 6px rgba(0,0,0,0.4);
}

/* Title – simple clean white */
.title h1 {
    font-family: cursive;
    font-size: 38px;
    margin: 0;
    color: #ffffff;
}

/* Nav bar */
.nav {
    font-size: 18px;
    display: flex;
    gap: 25px;
}
/* Logo inside header title */
.logo {
    height: 45px;
    margin-right: 12px;
    vertical-align: middle;
}

/* Small logo inside nav */
.nav-logo {
    height: 22px;
    margin-right: 6px;
}

/* Nav links */
.nav a {
    text-decoration: none;
    color: #f1f1f1;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.35s ease-in-out;
    font-family: Arial, sans-serif;
    display: flex;
    align-items: center;
    gap: 8px;
    position: relative;
}

/* Separator lines between items */
.nav a:not(:last-child)::after {
    content: "";
    position: absolute;
    right: -15px;
    top: 20%;
    height: 60%;
    width: 1px;
    background: rgba(255,255,255,0.3);
}

/* Hover effect */
.nav a:hover {
    background: linear-gradient(135deg, #00c6ff, #0072ff);
    color: #ffffff;
    transform: translateY(-2px);
    box-shadow: 0px 4px 10px rgba(0,0,0,0.3);
}

/* Active/Focus state */
.nav a:active, .nav a:focus {
    background: linear-gradient(135deg, #ffcc00, #ff9900);
    color: #0b0b2b;
}
</style>

<!-- HEADER -->
<div class="titleback">
   <div class="title">
       <!--  -- <img src="images/LWI_transparent.png" alt="LWI Logo" class="logo">-->
        <h1>Learn With Integrity</h1>
    </div>
    <div class="nav">
        <a href="UserDashboard"><i class="fas fa-home"></i> Home</a>
        <a href="MyCoursesServlet"><i class="fas fa-book"></i> My Courses</a>
        <!-- New Nav Item -->
        <a href="practice.jsp"><i class="fas fa-edit"></i> Practice Quiz</a>
        <a href="explore"><i class="fas fa-search"></i> Explore</a>
        <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</div>
<hr>

