<%-- --%<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.*, java.text.*, java.util.Calendar, Module1.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - LWI</title>
    <style>
        body {
            background-color: #040431;
            color: white;
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 30px;
        }
        .title h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }
        .color-change h2 {
            font-size: 24px;
            color: #FFD700;
            animation: fadein 2s ease-in;
        }
        @keyframes fadein {
            from { opacity: 0; }
            to   { opacity: 1; }
        }
        .badges-section {
    text-align: center;
    padding: 40px 20px;
}

.badges-title {
    font-size: 2rem;
    font-weight: 700;
    color: #fff;
    margin-bottom: 25px;
    letter-spacing: 1px;
    text-transform: uppercase;
}

.badges-grid {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 25px;
}

.badge-card {
    background: linear-gradient(145deg, #1a1c5d, #0d0e3f);
    border-radius: 18px;
    padding: 20px;
    width: 160px;
    height: 190px;
    box-shadow: 0 6px 14px rgba(0,0,0,0.4);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.badge-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 10px 20px rgba(0,0,0,0.6);
}

.badge-img {
    width: 90px;
    height: 90px;
    margin-bottom: 12px;
    border-radius: 50%;
    background: #fff;
    padding: 8px;
    box-shadow: inset 0 0 10px rgba(0,0,0,0.3);
}

.badge-label {
    color: #eee;
    font-size: 1rem;
    font-weight: 600;
    margin-top: 5px;
}

.no-badges {
    color: #aaa;
    font-size: 1.1rem;
    margin-top: 15px;
}
        
    </style>
</head>

<body>

<%
    // Retrieve user object from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = user.getName(); // safer than session.getAttribute("name")
    String greeting;
    Calendar calendar = Calendar.getInstance();
    int hour = calendar.get(Calendar.HOUR_OF_DAY);
    String[] quotes;
    String timeLabel;

    if (hour >= 5 && hour < 12) {
        greeting = "Good Morning";
        timeLabel = "morning";
        quotes = new String[] {
            "Start your day strong with LWI.",
            "Explore this morning with LWI.",
            "New knowledge, new you — make the morning count.",
            "Every morning is a fresh start. Let's begin with LWI!"
        };
    } else if (hour >= 12 && hour < 17) {
        greeting = "Good Afternoon";
        timeLabel = "afternoon";
        quotes = new String[] {
            "Power through the afternoon with LWI.",
            "Keep learning, keep growing this afternoon.",
            "Turn your break into brilliance with LWI.",
            "This afternoon, challenge yourself to grow with LWI!"
        };
    } else if (hour >= 17 && hour < 21) {
        greeting = "Good Evening";
        timeLabel = "evening";
        quotes = new String[] {
            "Reflect, recharge, and learn with LWI.",
            "Make your evening meaningful with knowledge.",
            "Light up your evening with learning on LWI.",
            "Learning never stops – not even this evening."
        };
    } else {
        greeting = "Hello";
        timeLabel = "night";
        quotes = new String[] {
            "A calm night to review and rise again tomorrow.",
            "Night is the best time to think deeply – LWI helps you do it.",
            "Quiet minds learn better – good night and good learning.",
            "Dreams are fueled by knowledge – sleep with LWI thoughts."
        };
    }

    Random rand = new Random();
    String randomQuote = quotes[rand.nextInt(quotes.length)];
%>

<%-- ✅ Navbar if needed --%><%-- --%
<%@ include file="navbar.jsp" %>

<div class="title">
    <h1><%= greeting %>, <%= name %></h1>
</div>

<div class="color-change">
    <h2><%= randomQuote %></h2>
</div>

<hr style="margin: 40px 0; border: 1px solid #555;">


<!-- 🔥 My Badges Section -->
<!-- 🔥 My Badges Section -->
<section class="badges-section">
    <h2 class="badges-title">🏆 My Badges</h2>

    <div class="badges-grid">
    <%
        List<Map<String, String>> badges = (List<Map<String, String>>) request.getAttribute("badges");
        if (badges == null || badges.isEmpty()) {
    %>
        <p class="no-badges">You haven’t earned any badges yet. Start learning to unlock them! 🌟</p>
    <%
        } else {
            for (Map<String, String> badge : badges) {
    %>
        <div class="badge-card">
            <img src="<%= badge.get("image") %>" 
                 alt="<%= badge.get("name") %>" 
                 class="badge-img" 
                 onclick="openBadgeModal('<%= badge.get("image") %>', '<%= badge.get("name") %>')">
            <p class="badge-label"><%= badge.get("name") %></p>
        </div>
    <%
            }
        }
    %>
    </div>
</section>

<!-- ⭐ Badge Modal -->
<div id="badgeModal" class="modal">
    <span class="close" onclick="closeBadgeModal()">&times;</span>
    <img class="modal-content" id="modalBadgeImg">
    <div id="modalCaption"></div>
</div>

<script>
function openBadgeModal(imgSrc, badgeName) {
    document.getElementById("badgeModal").style.display = "flex";
    document.getElementById("modalBadgeImg").src = imgSrc;
    document.getElementById("modalCaption").innerText = badgeName;
}
function closeBadgeModal() {
    document.getElementById("badgeModal").style.display = "none";
}
</script>
<hr style="margin: 40px 0; border: 1px solid #555;">

<hr style="margin: 40px 0; border: 1px solid #555;">

<!-- Certificates Section (embedded, no separate download link) -->
<section class="certificates-section">
    <h2>🎓 My Certificates</h2>

    <%
        List<Map<String, String>> certs = (List<Map<String, String>>) request.getAttribute("certs");
        if (certs == null || certs.isEmpty()) {
    %>
        <p>No certificates yet. Complete a course to get one.</p>
    <%
        } else {
            for (Map<String, String> cert : certs) {
                String pdfPath = request.getContextPath() + "/" + cert.get("file_path"); // e.g. /yourapp/certs/...
    %>
        <div class="certificate-card" style="margin-bottom:30px;">
            <h4>Course: <%= cert.get("course_id") %> <small>(Issued: <%= cert.get("issued_at") %>)</small></h4>
            <div style="border:1px solid #ddd;">
                <embed src="<%= pdfPath %>" width="100%" height="520px" type="application/pdf" />
                <!-- fallback message for browsers without native PDF embed support -->
                <div style="padding:10px; text-align:center;">
                    If the certificate doesn't display, <a href="<%= pdfPath %>" target="_blank">open it in a new tab</a>.
                </div>
            </div>
        </div>
    <%
            }
        }
    %>
</section>


<!-- 🎓 My Certificates Section --

<section class="certificates-section">
    <h2 class="certificates-title">🎓 My Certificates</h2>

    <div class="certificates-grid">
<%--    <%
        List<Map<String, String>> certs = (List<Map<String, String>>) request.getAttribute("certs");
        if (certs == null || certs.isEmpty()) {
    %>
        <p class="no-certificates">No certificates yet. Complete a course to earn one! 📜</p>
    <%
        } else {
            for (Map<String, String> cert : certs) {
    %>
        <div class="certificate-card">
            <p class="certificate-label">Course <%= cert.get("course_id") %></p>
            <a href="downloadCertificate?id=<%= cert.get("id") %>" 
               class="download-btn">⬇ Download</a>
        </div>
    <%
            }
        }
    %>--%
    </div>
</section>

<style>
.certificates-section {
    margin-top: 40px;
}
.certificates-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}
.certificate-card {
    background: #f7f7f7;
    border: 1px solid #ccc;
    border-radius: 10px;
    padding: 15px;
    text-align: center;
    width: 200px;
}
.download-btn {
    display: inline-block;
    margin-top: 10px;
    padding: 6px 12px;
    background: #4CAF50;
    color: white;
    text-decoration: none;
    border-radius: 6px;
}
.download-btn:hover {
    background: #45a049;
}
</style>-->


<style>
/* ⭐ Badges Section *
.badges-section {
    text-align: center;
    margin: 30px auto 50px; /* reduced gap *
    max-width: 1000px;
}

.badges-title {
    font-size: 24px;
    font-weight: bold;
    color: #fff;
    margin-top: 15px; /* reduced gap from HR *
    margin-bottom: 25px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
}

/* ⭐ Responsive grid like My Courses *
.badges-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 25px;
    justify-items: center;
}

/* ⭐ Card style for each badge *
.badge-card {
    background: linear-gradient(145deg, #1c1f38, #0f1125);
    border-radius: 16px;
    padding: 15px 10px;
    width: 140px;
    text-align: center;
    box-shadow: 0 4px 15px rgba(0,0,0,0.4);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.badge-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.6);
}

/* ⭐ Badge image *
.badge-img {
    width: 70px;
    height: 70px;
    margin-bottom: 10px;
    border-radius: 50%;
    background: #fff;
    padding: 6px;
    cursor: pointer;
    transition: transform 0.2s;
}
.badge-img:hover {
    transform: scale(1.1);
}

/* ⭐ Badge label *
.badge-label {
    font-size: 14px;
    font-weight: 600;
    color: #FFD700;
    margin-top: 8px;
}










/* ⭐ Make badges smaller in grid */
.badge-img {
    width: 70px;
    height: 70px;
    margin-bottom: 10px;
    border-radius: 50%;
    background: #fff;
    padding: 6px;
    cursor: pointer;
    transition: transform 0.2s;
}
.badge-img:hover {
    transform: scale(1.1);
}

/* ⭐ Modal styles */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    padding-top: 80px;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.8);
    justify-content: center;
    align-items: center;
    flex-direction: column;
}
.modal-content {
    max-width: 350px;
    max-height: 350px;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.6);
}
#modalCaption {
    margin-top: 15px;
    color: #fff;
    font-size: 18px;
    font-weight: bold;
}
.close {
    position: absolute;
    top: 25px;
    right: 40px;
    color: #fff;
    font-size: 36px;
    font-weight: bold;
    cursor: pointer;
    transition: 0.2s;
}
.close:hover {
    color: #FFD700;
}
</style>











<%-- --%
<section class="badges-section">
    <h2 class="badges-title">🏆 My Badges</h2>

    <div class="badges-grid">
    
    <%
    List<Map<String, String>> badges = (List<Map<String, String>>) request.getAttribute("badges");
    if (badges == null || badges.isEmpty()) {
%>
    <p class="no-badges">You haven’t earned any badges yet. Start learning to unlock them! 🌟</p>
<%
    } else {
        for (Map<String, String> badge : badges) {
%>
    <div class="badge-card">
        <img src="<%= badge.get("image") %>" alt="<%= badge.get("name") %>" class="badge-img">
        <p class="badge-label"><%= badge.get("name") %></p>
    </div>
<%
        }
    }
%>
    
    
    
    
    <%-- --%    <%
            List<Integer> badgeIds = (List<Integer>) request.getAttribute("badgeIds");
            if (badgeIds == null || badgeIds.isEmpty()) {
        %>
            <p class="no-badges">You haven’t earned any badges yet. Start learning to unlock them! 🌟</p>
        <%
            } else {
                for (Integer badgeId : badgeIds) {
        %>
            <div class="badge-card">
                <img src="badges/<%=badgeId%>.png" alt="Badge <%=badgeId%>" class="badge-img">
                <p class="badge-label">Badge #<%=badgeId%></p>
            </div>
        <%
                }
            }
        %>   --%
    </div>
</section>

<button><a href="pwdchange.jsp">Change Password</a></button>
<br>
<br>
<a href="quiz.jsp">attempt quiz</a>
</body>
</html>--%
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.*, java.text.*, java.util.Calendar, Module1.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - LWI</title>
    <style>
        body {
            background-color: #040431;
            color: white;
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 30px;
        }
        .title h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }
        .color-change h2 {
            font-size: 24px;
            color: #FFD700;
            animation: fadein 2s ease-in;
        }
        @keyframes fadein {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        /* Badges */
        .badges-section, .certificates-section {
            text-align: center;
            padding: 40px 20px;
        }
        .badges-title, .certificates-title {
            font-size: 2rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 25px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .badges-grid, .certificates-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 25px;
        }
        .badge-card, .certificate-card {
            background: linear-gradient(145deg, #1a1c5d, #0d0e3f);
            border-radius: 18px;
            padding: 20px;
            width: 160px;
            height: 200px;
            box-shadow: 0 6px 14px rgba(0,0,0,0.4);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .badge-card:hover, .certificate-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.6);
        }
        .badge-img, .certificate-img {
            width: 90px;
            height: 90px;
            margin-bottom: 12px;
            border-radius: 50%;
            background: #fff;
            padding: 8px;
            box-shadow: inset 0 0 10px rgba(0,0,0,0.3);
            cursor: pointer;
        }
        .certificate-img {
            border-radius: 12px;
            width: 120px;
            height: auto;
            padding: 0;
        }
        .badge-label, .certificate-label {
            color: #eee;
            font-size: 1rem;
            font-weight: 600;
            margin-top: 5px;
        }
        .no-badges, .no-certificates {
            color: #aaa;
            font-size: 1.1rem;
            margin-top: 15px;
        }

        /* Modal Common */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.9);
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            max-width: 90%;
            max-height: 90%;
            margin: auto;
        }
        .close {
            position: absolute;
            top: 20px;
            right: 30px; /* closer and visible */
            color: white;
            font-size: 36px;
            font-weight: bold;
            cursor: pointer;
            z-index: 1100;
        }
        .close:hover {
            color: #FFD700;
        }
    </style>
</head>

<body>

<%
    // Retrieve user object from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = user.getName();
    String greeting;
    Calendar calendar = Calendar.getInstance();
    int hour = calendar.get(Calendar.HOUR_OF_DAY);
    String[] quotes;
    String timeLabel;

    if (hour >= 5 && hour < 12) {
        greeting = "Good Morning";
        timeLabel = "morning";
        quotes = new String[] {
            "Start your day strong with LWI.",
            "Explore this morning with LWI.",
            "New knowledge, new you — make the morning count.",
            "Every morning is a fresh start. Let's begin with LWI!"
        };
    } else if (hour >= 12 && hour < 17) {
        greeting = "Good Afternoon";
        timeLabel = "afternoon";
        quotes = new String[] {
            "Power through the afternoon with LWI.",
            "Keep learning, keep growing this afternoon.",
            "Turn your break into brilliance with LWI.",
            "This afternoon, challenge yourself to grow with LWI!"
        };
    } else if (hour >= 17 && hour < 21) {
        greeting = "Good Evening";
        timeLabel = "evening";
        quotes = new String[] {
            "Reflect, recharge, and learn with LWI.",
            "Make your evening meaningful with knowledge.",
            "Light up your evening with learning on LWI.",
            "Learning never stops – not even this evening."
        };
    } else {
        greeting = "Hello";
        timeLabel = "night";
        quotes = new String[] {
            "A calm night to review and rise again tomorrow.",
            "Night is the best time to think deeply – LWI helps you do it.",
            "Quiet minds learn better – good night and good learning.",
            "Dreams are fueled by knowledge – sleep with LWI thoughts."
        };
    }

    Random rand = new Random();
    String randomQuote = quotes[rand.nextInt(quotes.length)];
%>

<%@ include file="navbar.jsp" %>

<div class="title">
    <h1><%= greeting %>, <%= name %></h1>
</div>

<div class="color-change">
    <h2><%= randomQuote %></h2>
</div>

<hr style="margin: 40px 0; border: 1px solid #555;">

<!-- 🏆 Badges Section -->
<section class="badges-section">
    <h2 class="badges-title">🏆 My Badges</h2>

    <div class="badges-grid">
    <%
        List<Map<String, String>> badges = (List<Map<String, String>>) request.getAttribute("badges");
        if (badges == null || badges.isEmpty()) {
    %>
        <p class="no-badges">You haven’t earned any badges yet. Start learning to unlock them! 🌟</p>
    <%
        } else {
            for (Map<String, String> badge : badges) {
    %>
        <div class="badge-card">
            <img src="<%= badge.get("image") %>" 
                 alt="<%= badge.get("name") %>" 
                 class="badge-img" 
                 onclick="openBadgeModal('<%= badge.get("image") %>', '<%= badge.get("name") %>')">
            <p class="badge-label"><%= badge.get("name") %></p>
        </div>
    <%
            }
        }
    %>
    </div>
</section>

<!-- Badge Modal -->
<div id="badgeModal" class="modal">
    <span class="close" onclick="closeBadgeModal()">&times;</span>
    <img class="modal-content" id="modalBadgeImg">
    <div id="modalCaption"></div>
</div>

<!-- 🎓 Certificates Section -->
<section class="certificates-section">
    <h2 class="certificates-title">🎓 My Certificates</h2>

    <div class="certificates-grid">
    <%
        List<Map<String, String>> certs = (List<Map<String, String>>) request.getAttribute("certs");
        if (certs == null || certs.isEmpty()) {
    %>
        <p class="no-certificates">No certificates yet. Complete a course to earn one! 📜</p>
    <%
        } else {
            for (Map<String, String> cert : certs) {
                String pdfPath = request.getContextPath() + "/" + cert.get("file_path");
    %>
        <div class="certificate-card">
            <img src="<%= request.getContextPath() %>/certs/Certificate_of_Completion.png" 
                 alt="Certificate" 
                 class="certificate-img"
                 onclick="openCertificateModal('<%= pdfPath %>')">
            <p class="certificate-label">Course <%= cert.get("course_id") %></p>
        </div>
    <%
            }
        }
    %>
    </div>
</section>

<!-- Certificate Modal -->
<div id="certificateModal" class="modal">
    <span class="close" onclick="closeCertificateModal()">&times;</span>
    <iframe id="certificateFrame" class="modal-content" frameborder="0"></iframe>
</div>

<script>
function openBadgeModal(imgSrc, badgeName) {
    document.getElementById("badgeModal").style.display = "flex";
    document.getElementById("modalBadgeImg").src = imgSrc;
    document.getElementById("modalCaption").innerText = badgeName;
}
function closeBadgeModal() {
    document.getElementById("badgeModal").style.display = "none";
    document.getElementById("modalBadgeImg").src = "";
}

function openCertificateModal(pdfSrc) {
    document.getElementById("certificateModal").style.display = "flex";
    document.getElementById("certificateFrame").src = pdfSrc;
}
function closeCertificateModal() {
    document.getElementById("certificateModal").style.display = "none";
    document.getElementById("certificateFrame").src = "";
}
</script>

</body>
</html>--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.*, java.text.*, java.util.Calendar, Module1.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - LWI</title>
    <style>
        body {
            background-color: #040431;
            color: white;
            font-family: "Segoe UI", sans-serif;
            margin: 0;
            padding: 30px;
            text-align: center;
        }

        /* Greeting */
        .title h1 { font-size: 36px; margin-bottom: 10px; }
        .color-change h2 { font-size: 20px; color: #FFD700; }

        /* Section titles */
        .section-title {
            font-size: 26px;
            font-weight: 700;
            margin: 40px 0 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Certificates Grid */
        .certificates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
            justify-items: center;
        }
        .certificate-card {
            background: #fff;
            color: #000;
            border-radius: 16px;
            padding: 15px;
            width: 240px;
            box-shadow: 0 6px 14px rgba(0,0,0,0.4);
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .certificate-card:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0,0,0,0.6);
        }
        .certificate-img {
            width: 100%;
            border-radius: 12px;
        }
        .certificate-label {
            margin-top: 12px;
            font-size: 1rem;
            font-weight: 600;
            color: #222;
        }

        /* Badges Grid */
        .badges-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 25px;
            justify-items: center;
        }
        .badge-card {
            text-align: center;
            cursor: pointer;
        }
        .badge-img {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: #fff;
            padding: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            transition: transform 0.3s ease;
        }
        .badge-img:hover { transform: scale(1.1); }
        .badge-label {
            margin-top: 8px;
            font-size: 0.95rem;
            color: #eee;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.85);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            max-width: 90%;
            max-height: 85%;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.5);
            animation: zoomIn 0.3s ease;
        }
        @keyframes zoomIn { from { transform: scale(0.6); opacity: 0; } to { transform: scale(1); opacity: 1; } }

        .modal-caption {
            margin-top: 15px;
            font-size: 1rem;
            color: #fff;
            text-align: center;
        }

        .close {
            position: absolute;
            top: 15px;
            right: 25px;
            font-size: 36px;
            font-weight: bold;
            color: white;
            cursor: pointer;
        }
        .close:hover { color: #FFD700; }
    </style>
</head>

<body>
<%
    // Retrieve user object from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String name = user.getName();
    String greeting;
    Calendar calendar = Calendar.getInstance();
    int hour = calendar.get(Calendar.HOUR_OF_DAY);
    String[] quotes;
    if (hour >= 5 && hour < 12) quotes = new String[]{"Start your day strong with LWI.","Explore this morning with LWI.","New knowledge, new you.","Every morning is a fresh start."};
    else if (hour >= 12 && hour < 17) quotes = new String[]{"Power through the afternoon.","Keep learning, keep growing.","Turn your break into brilliance.","Challenge yourself this afternoon."};
    else if (hour >= 17 && hour < 21) quotes = new String[]{"Reflect, recharge, and learn.","Make your evening meaningful.","Light up your evening with LWI.","Learning never stops this evening."};
    else quotes = new String[]{"A calm night to review.","Night is the best time to think.","Quiet minds learn better.","Dreams are fueled by knowledge."};
    greeting = (hour < 12) ? "Good Morning" : (hour < 17) ? "Good Afternoon" : (hour < 21) ? "Good Evening" : "Hello";
    Random rand = new Random();
    String randomQuote = quotes[rand.nextInt(quotes.length)];
%>

<%@ include file="navbar.jsp" %>

<div class="title">
    <h1><%= greeting %>, <%= name %></h1>
</div>
<div class="color-change">
    <h2><%= randomQuote %></h2>
</div>

<!-- Certificates -->
<h2 class="section-title">🎓 My Certificates</h2>
<div class="certificates-grid">
<%
    List<Map<String,String>> certs = (List<Map<String,String>>) request.getAttribute("certs");
    if (certs == null || certs.isEmpty()) {
%>
    <p>No certificates yet. Complete a course to earn one! 📜</p>
<%
    } else {
        for (Map<String,String> cert : certs) {
            String pdfPath = request.getContextPath() + "/" + cert.get("file_path");
%>
    <div class="certificate-card" onclick="openModal('<%= pdfPath %>', 'certificate')">
        <img src="<%= request.getContextPath() %>/certs/Certificate_of_Completion.png" class="certificate-img" alt="Certificate">
        <p class="certificate-label">Course <%= cert.get("course_id") %></p>
    </div>
<%
        }
    }
%>
</div>

<!-- Badges -->
<h2 class="section-title">🏆 My Badges</h2>
<div class="badges-grid">
<%
    List<Map<String,String>> badges = (List<Map<String,String>>) request.getAttribute("badges");
    if (badges == null || badges.isEmpty()) {
%>
    <p>You haven’t earned any badges yet. Start learning to unlock them! 🌟</p>
<%
    } else {
        for (Map<String,String> badge : badges) {
%>
    <div class="badge-card" onclick="openModal('<%= badge.get("image") %>', '<%= badge.get("name") %>')">
        <img src="<%= badge.get("image") %>" class="badge-img" alt="<%= badge.get("name") %>">
        <p class="badge-label"><%= badge.get("name") %></p>
    </div>
<%
        }
    }
%>
</div>

<!-- Modal (shared for both) -->
<div id="modal" class="modal">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modalImg" class="modal-content">
    <div id="modalCaption" class="modal-caption"></div>
</div>

<a href="pwdchange.jsp">Change Password</a>

<script>
function openModal(src, caption) {
    document.getElementById("modal").style.display = "flex";
    document.getElementById("modalImg").src = src;
    document.getElementById("modalCaption").innerText = caption;
}
function closeModal() {
    document.getElementById("modal").style.display = "none";
    document.getElementById("modalImg").src = "";
    document.getElementById("modalCaption").innerText = "";
}
</script>
</body>
</html>


