
<!--

<!DOCTYPE html>
<html>
<head>
    <title>My Courses</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: rgba(11, 11, 43, 0.925);
            margin: 0;
            padding: 0;
        }
        h2 {
            text-align: center;
            margin-top: 30px;
            color: white;
        }
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 30px;
        }
        .course-card {
            background-color:#1f1f2e;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 255, 255, 0.1);
            margin: 15px;
            padding: 20px;
            width: 320px;
            text-align: center;
            transition: all 0.3s ease-in-out;
        }
        .course-card img {
            width: 100%;
            height: 180px;
            border-radius: 8px;
            object-fit: cover;
            margin-bottom: 10px;
        }
        .course-card h3 {
            margin-top: 0;
            color: #00bcd4;
        }
        .course-card p {
            color: #ccc;
            min-height: 60px;
        }
        .course-card a {
            display: block;
            margin: 8px 0;
            text-decoration: none;
            padding: 8px;
            border-radius: 5px;
            background: #00bcd4;
            color: white;
            font-weight: bold;
        }
        .course-card a:hover {
            background: #0097a7;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 0px 20px rgba(0, 255, 255, 0.3);
        }
    </style>
</head>
<body>
    <h2>My Enrolled Courses</h2>

    <div class="container">-->
    <%-- -- 
        <%
            List<Course> myCourses = (List<Course>) request.getAttribute("myCourses");
            if (myCourses != null && !myCourses.isEmpty()) {
                for (Course course : myCourses) {
        %>
            <div class="course-card">
                <% if (course.getImage() != null && !course.getImage().isEmpty()) { %>
                    <img src="<%= course.getImage() %>" alt="Course Image">
                <% } %>
                <h3><%= course.getTitle() %></h3>
                <p><%= course.getDescription() %></p>
                
                <% if (course.getDocumentLink() != null && !course.getDocumentLink().isEmpty()) { %>
                    <a href="<%= course.getDocumentLink() %>" target="_blank">📘 Open Document</a>
                <% } %>
                <% if (course.getVideoLink() != null && !course.getVideoLink().isEmpty()) { %>
                    <a href="<%= course.getVideoLink() %>" target="_blank">🎥 Watch Video</a>
                <% } %>
            </div>
        <%
                }
            } else {
        %>
            <p style="color:white; text-align:center;">You have not enrolled in any courses</p>
        <%
            }
        %>--%>
  <!--   </div>
</body>
</html>-->
<%--=========== 
<%@ page import="java.util.*, Module2.Course" %>

<!DOCTYPE html>
<html>
<head>
    <title>My Courses</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: rgba(11, 11, 43, 0.925);
            margin: 0;
            padding: 0;
        }
        h2 {
            text-align: center;
            margin-top: 30px;
            color: white;
        }
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 30px;
        }
        .course-card {
            background-color:#1f1f2e;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 255, 255, 0.1);
            margin: 15px;
            padding: 20px;
            width: 340px;
            text-align: center;
            transition: all 0.3s ease-in-out;
        }
        .course-card img {
            width: 100%;
            height: 180px;
            border-radius: 8px;
            object-fit: cover;
            margin-bottom: 10px;
        }
        .course-card h3 {
            margin-top: 0;
            color: #00bcd4;
        }
        .course-card p {
            color: #ccc;
            min-height: 60px;
        }
        .course-card a {
            display: block;
            margin: 8px 0;
            text-decoration: none;
            padding: 8px;
            border-radius: 5px;
            background: #00bcd4;
            color: white;
            font-weight: bold;
        }
        .course-card a:hover {
            background: #0097a7;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 0px 20px rgba(0, 255, 255, 0.3);
        }
        .progress {
            width: 100%;
            background: #444;
            border-radius: 8px;
            margin: 10px 0;
        }
        .progress-bar {
            height: 20px;
            border-radius: 8px;
            background: #00bcd4;
            text-align: center;
            color: white;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <h2>My Enrolled Courses</h2>

    <div class="container">
        <%
            List<Course> myCourses = (List<Course>) request.getAttribute("myCourses");
            if (myCourses != null && !myCourses.isEmpty()) {
                for (Course course : myCourses) {
                    int progress = (int)(Math.random() * 100); // TEMP: Replace with DB value
        %>
            <div class="course-card">
                <% if (course.getImage() != null && !course.getImage().isEmpty()) { %>
                    <img src="<%= course.getImage() %>" alt="Course Image">
                <% } %>
                <h3><%= course.getTitle() %></h3>
                <p><%= course.getDescription() %></p>

                <!-- Progress Bar -->
                <div class="progress">
                    <div class="progress-bar" style="width:<%=progress%>%;">
                        <%=progress%>%
                    </div>
                </div>

                <% if (course.getDocumentLink() != null && !course.getDocumentLink().isEmpty()) { %>
<!-- mycourses.jsp (anchor fixes only) -->
<a href="viewDocument?courseId=<%= course.getId() %>">📘 Open Document</a>

                <% } %>
                <% if (course.getVideoLink() != null && !course.getVideoLink().isEmpty()) { %>
                    <a href="watchVideo?courseId=<%= course.getId() %>">🎥 Watch Video</a>
                <% } %>

                <!-- Badge Link -->
                <a href="BadgeAwardServlet?courseId=<%= course.getId() %>">🏅 Claim Badge</a>
            </div>
        <%
                }
            } else {
        %>
            <p style="color:white; text-align:center;">You have not enrolled in any courses</p>
        <%
            }
        %>
    </div>
</body>
</html>--%>

<%-- --%====

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>

<%
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0a002b; color:white; margin:0; padding:0;}

        /* Search Bar */
        .search-bar { display:flex; justify-content:center; margin:20px; }
        .search-bar input { width:50%; padding:12px 20px; border-radius:30px; border:none; outline:none; font-size:16px; background:#11134d; color:white; }

        /* Section Titles */
        .course-section { margin:20px; }
        .course-section h2 { 
            font-size: 24px; 
            color: #00e0ff; 
            border-bottom: 2px solid #00e0ff; 
            padding-bottom: 5px; 
            margin-bottom: 15px; 
            font-weight: bold; 
            letter-spacing: 0.5px;
        }

        /* Horizontal Scroll Cards */
        .course-scroll { display:flex; overflow-x:auto; gap:20px; padding-bottom:10px; }
        .course-scroll::-webkit-scrollbar { height:8px; }
        .course-scroll::-webkit-scrollbar-thumb { background:#555; border-radius:4px; }
        .course-scroll::-webkit-scrollbar-track { background:#222; }

        /* Course Cards - KEEP EXACTLY AS ORIGINAL */
        .course-card { width:220px; background:#11134d; border-radius:12px; padding:10px; text-align:center; box-shadow:0 4px 6px rgba(0,0,0,0.3); flex-shrink:0; transition: transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:8px 0 5px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ddd; height:40px; overflow:hidden; }

        /* Button Styles */
        .btn { padding:8px 12px; border:none; border-radius:5px; cursor:pointer; font-size:14px; font-weight:bold; transition:all 0.3s ease; }
        .course-card .btn.add-btn { background:#28a745; color:white; margin-top:5px;}
        .course-card .btn.details-btn { background:#007bff; color:white; margin-top:5px; }

        /* Enhanced Modal */
        #courseModal { 
            display:none; 
            position:fixed; 
            z-index:9999; 
            left:0; 
            top:0; 
            width:100%; 
            height:100%; 
            background: rgba(10, 0, 43, 0.98);
            animation: modalFadeIn 0.3s ease-in-out;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        #courseModal .modal-content { 
            display:flex; 
            flex-direction:row; 
            background: linear-gradient(145deg, #1a1a4d, #0f0f2a);
            color:#fff; 
            border-radius:20px; 
            padding:30px; 
            max-width:85%; 
            max-height:90%; 
            margin: 2% auto;
            overflow:hidden;
            box-shadow: 0 20px 60px rgba(0, 224, 255, 0.3);
            border: 1px solid rgba(0, 224, 255, 0.2);
            position: relative;
        }

        #courseModal .modal-content::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #00e0ff, #0066cc);
            border-radius: 20px 20px 0 0;
        }

        #courseModal .modal-image-container {
            width: 40%;
            padding-right: 25px;
        }

        #courseModal .modal-content img { 
            width:100%; 
            height: 280px;
            border-radius:15px; 
            object-fit:cover; 
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            border: 2px solid rgba(0, 224, 255, 0.3);
        }

        #courseModal .modal-text { 
            width:60%; 
            overflow-y:auto; 
            padding-right: 10px;
        }

        #courseModal .modal-text::-webkit-scrollbar { width: 6px; }
        #courseModal .modal-text::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.1); border-radius: 3px; }
        #courseModal .modal-text::-webkit-scrollbar-thumb { background: #00e0ff; border-radius: 3px; }

        #courseModal .modal-text h2 { 
            font-size:28px; 
            color:#00e0ff; 
            margin-bottom:15px; 
            font-weight:bold;
            text-shadow: 0 2px 10px rgba(0, 224, 255, 0.3);
        }

        #courseModal .modal-description {
            font-size:16px; 
            color:#e0e0e0; 
            line-height:1.6em; 
            margin-bottom: 25px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            border-left: 4px solid #00e0ff;
        }

        #courseModal .modal-section {
            margin-bottom: 20px;
        }

        #courseModal .modal-text h3 { 
            font-size:18px; 
            color:#00e0ff; 
            margin: 20px 0 10px 0;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        #courseModal .modal-text h3::before {
            content: '';
            width: 4px;
            height: 18px;
            background: linear-gradient(180deg, #00e0ff, #0066cc);
            border-radius: 2px;
        }

        #courseModal .modal-text p { 
            font-size:14px; 
            color:#ddd; 
            line-height:1.5em; 
            margin-bottom: 15px;
            padding: 12px 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        #courseModal .close { 
            position: absolute;
            top: 15px;
            right: 20px;
            font-size:32px; 
            cursor:pointer; 
            color:#00e0ff;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        #courseModal .close:hover {
            background: rgba(0, 224, 255, 0.2);
            transform: rotate(90deg);
        }

        #courseModal .rating-section {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 15px 0;
            padding: 12px 15px;
            background: rgba(255, 215, 0, 0.1);
            border-radius: 8px;
            border: 1px solid rgba(255, 215, 0, 0.3);
        }

        #courseModal .rating-stars {
            color: #ffd700;
            font-size: 18px;
        }

        #courseModal .rating-text {
            color: #ffd700;
            font-weight: 600;
        }

        #courseModal .add-course-btn {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin: 20px 0;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        #courseModal .add-course-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        #courseModal .reviews-box { 
            max-height:200px; 
            overflow-y:auto; 
            border:1px solid rgba(0, 224, 255, 0.3); 
            padding:15px; 
            margin-top:15px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
        }

        #courseModal .reviews-box::-webkit-scrollbar { width: 6px; }
        #courseModal .reviews-box::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.1); border-radius: 3px; }
        #courseModal .reviews-box::-webkit-scrollbar-thumb { background: #00e0ff; border-radius: 3px; }

        /* Mobile Responsive - ONLY FOR MODAL */
        @media screen and (max-width:768px){ 
            .search-bar input{ width:90%; } 
            #courseModal .modal-content { 
                flex-direction:column;
                margin: 5% auto;
                max-width: 95%;
                max-height: 95%;
                padding: 20px;
            } 
            #courseModal .modal-image-container {
                width:100%; 
                padding-right: 0;
                margin-bottom:15px;
            }
            #courseModal .modal-content img {
                height: 200px;
            }
            #courseModal .modal-text{
                width:100%; 
            }
            #courseModal .modal-text h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

<!-- Search Bar -->
<div class="search-bar">
    <input type="text" id="searchInput" placeholder="🔍 Search courses by title..." onkeyup="filterCourses()">
</div>

<!-- Dynamic Sections -->
<% for(Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) { 
        String sectionName = entry.getKey();
        List<Course> courses = entry.getValue();
%>
<div class="course-section">
    <h2><%=sectionName%> Courses</h2>
    <div class="course-scroll">
        <% for(Course c : courses) { %>
            <div class="course-card">
                <img src="<%=c.getImage()%>" alt="Course Image">
                <h3><%=c.getTitle()%></h3>
                <p><%=c.getDescription()%></p>
                <button class="btn add-btn" onclick="addCourse(<%=c.getId()%>)">+ My Courses</button>
                <button class="btn details-btn"
                        onclick="openModal('<%=c.getId()%>','<%=c.getTitle().replace("'", "\\'")%>',
                        '<%=c.getDescription().replace("'", "\\'")%>','<%=c.getImage()%>',
                        '<%=c.getSyllabus().replace("'", "\\'")%>',
                        '<%=c.getDesign().replace("'", "\\'")%>',
                        '<%=c.getTopicsCovered().replace("'", "\\'")%>',
                        '<%=c.getTestDetails().replace("'", "\\'")%>')">Details</button>
            </div>
        <% } %>
    </div>
</div>
<hr>
<% } %>

<!-- Enhanced Modal -->
<div id="courseModal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    
    <div class="modal-image-container">
        <img id="modalImage" src="" alt="Course Image">
    </div>
    
    <div class="modal-text">
        <h2 id="modalTitle"></h2>
        <div class="modal-description" id="modalDescription"></div>

        <div class="modal-section">
            <h3>📚 Syllabus</h3>
            <p id="modalSyllabus"></p>
        </div>

        <div class="modal-section">
            <h3>🎨 Design</h3>
            <p id="modalDesign"></p>
        </div>

        <div class="modal-section">
            <h3>📖 Topics Covered</h3>
            <p id="modalTopics"></p>
        </div>

        <div class="modal-section">
            <h3>📝 Test Details</h3>
            <p id="modalTest"></p>
        </div>

        <div class="rating-section">
            <span class="rating-stars">⭐⭐⭐⭐⭐</span>
            <span class="rating-text">(4.5 / 5)</span>
        </div>

        <button id="addCourseBtn" class="add-course-btn">+ Add to My Courses</button>

        <div class="modal-section">
            <h3>💬 Reviews</h3>
            <div id="reviewsSection" class="reviews-box"></div>
        </div>
    </div>
  </div>
</div>

<script>
function filterCourses() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let cards = document.getElementsByClassName("course-card");
    for (let i = 0; i < cards.length; i++) {
        let title = cards[i].getElementsByTagName("h3")[0].innerText.toLowerCase();
        cards[i].style.display = title.includes(input) ? "block" : "none";
    }
}

function openModal(courseId, title, description, image, syllabus, design, topics, testDetails) {
    // Prevent any interference with existing elements
    event.stopPropagation();
    
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    // Load reviews via AJAX
    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; })
        .catch(err => console.log('Reviews loading failed:', err));

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}

function closeModal() { 
    document.getElementById("courseModal").style.display = "none";
}

// ✅ OPTION 1: Proper POST request using fetch API
function addCourse(courseId) {
    fetch("AddCourseServlet", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "courseId=" + courseId
    })
    .then(response => {
        if (response.redirected) {
            window.location.href = response.url;
        } else {
            // Handle successful addition
            window.location.href = "mycourses.jsp?status=success";
        }
    })
    .catch(err => {
        console.log("Error adding course:", err);
        alert("Failed to add course. Please try again.");
    });
}

// Prevent modal from closing when clicking inside the modal content
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('courseModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
});
</script>

</body>
</html>  --%
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>

<%
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Courses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0a002b; color:white; margin:0; padding:0;}

        .course-section { margin:20px; }
        .course-section h2 { 
            font-size: 24px; 
            color: #00e0ff; 
            border-bottom: 2px solid #00e0ff; 
            padding-bottom: 5px; 
            margin-bottom: 15px; 
            font-weight: bold; 
            letter-spacing: 0.5px;
        }

        .course-scroll { display:flex; flex-wrap:wrap; gap:20px; }
        .course-card { width:260px; background:#11134d; border-radius:12px; padding:15px; box-shadow:0 4px 6px rgba(0,0,0,0.3); transition: transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:10px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ccc; height:40px; overflow:hidden; }

        .links { margin-top:10px; }
        .links a { 
            display:block; 
            margin:5px 0; 
            padding:8px; 
            border-radius:6px; 
            text-align:center; 
            text-decoration:none; 
            background:#007bff; 
            color:white; 
            font-size:14px;
        }
        .links a:hover { background:#0056b3; }

        /* Progress bar */
        .progress-container { margin-top:10px; background:#222; border-radius:8px; height:20px; width:100%; }
        .progress-bar { height:100%; border-radius:8px; background:linear-gradient(90deg,#00e0ff,#0066cc); width:0%; transition:width 0.5s; }
        .progress-text { text-align:right; font-size:12px; margin-top:5px; color:#aaa; }
    </style>
</head>
<body>

<% for(Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) { 
       String sectionName = entry.getKey();
       List<Course> courses = entry.getValue();
%>
<div class="course-section">
    <h2><%=sectionName%> Courses</h2>
    <div class="course-scroll">
        <% for(Course c : courses) { %>
            <div class="course-card">
                <img src="<%=c.getImage()%>" alt="Course Image">
                <h3><%=c.getTitle()%></h3>
                <p><%=c.getDescription()%></p>

                <div class="links">
                    <a href="docs.jsp?courseId=<%=c.getId()%>">📄 Documents</a>
                    <a href="videos.jsp?courseId=<%=c.getId()%>">🎬 Videos</a>
                    <a href="quiz.jsp?courseId=<%=c.getId()%>">📝 Quiz</a>
                </div>

                <!-- Progress -->
                <div class="progress-container">
                    <div class="progress-bar" id="progress-<%=c.getId()%>"></div>
                </div>
                <div class="progress-text" id="progress-text-<%=c.getId()%>">Loading...</div>
            </div>
        <% } %>
    </div>
</div>
<hr>
<% } %>

<script>
// Load progress for each course from ProgressServlet
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".course-card").forEach(card => {
        let courseId = card.querySelector(".links a").href.split("=")[1]; // quick extract courseId
        fetch("progress?courseId=" + courseId)
            .then(res => res.json())
            .then(data => {
                let overall = data.overall_status || "NOT_STARTED";
                let percent = 0;
                if(overall === "IN_PROGRESS") percent = 50;
                if(overall === "COMPLETED") percent = 100;

                let bar = document.getElementById("progress-" + courseId);
                let text = document.getElementById("progress-text-" + courseId);
                if(bar) bar.style.width = percent + "%";
                if(text) text.innerText = overall + " (" + percent + "%)";
            })
            .catch(err => console.log("Error fetching progress for " + courseId, err));
    });
});
</script>

</body>
</html>  --
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>

<%
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Courses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0a002b; color:white; margin:0; padding:0;}
        .course-section { margin:20px; }
        .course-section h2 { font-size: 24px; color: #00e0ff; border-bottom: 2px solid #00e0ff; padding-bottom: 5px; margin-bottom: 15px; font-weight: bold; letter-spacing: 0.5px; }
        .course-scroll { display:flex; flex-wrap:wrap; gap:20px; }
        .course-card { width:260px; background:#11134d; border-radius:12px; padding:15px; box-shadow:0 4px 6px rgba(0,0,0,0.3); transition: transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:10px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ccc; height:40px; overflow:hidden; }

        .links { margin-top:10px; }
        .links a { display:block; margin:5px 0; padding:8px; border-radius:6px; text-align:center; text-decoration:none; background:#007bff; color:white; font-size:14px; }
        .links a:hover { background:#0056b3; }

        .progress-container { margin-top:10px; background:#222; border-radius:8px; height:20px; width:100%; }
        .progress-bar { height:100%; border-radius:8px; background:linear-gradient(90deg,#00e0ff,#0066cc); width:0%; transition:width 0.5s; }
        .progress-text { text-align:right; font-size:12px; margin-top:5px; color:#aaa; }
    </style>
</head>
<body>

<% for(Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) {
       String sectionName = entry.getKey();
       List<Course> courses = entry.getValue();
%>
<div class="course-section">
    <h2><%=sectionName%> Courses</h2>
    <div class="course-scroll">
        <% for(Course c : courses) { %>
            <div class="course-card">
                <img src="<%=c.getImage()%>" alt="Course Image">
                <h3><%=c.getTitle()%></h3>
                <p><%=c.getDescription()%></p>

                <div class="links">
                    <a href="docs.jsp?courseId=<%=c.getId()%>" target="_blank">📄 Documents</a>
                    <a href="videos.jsp?courseId=<%=c.getId()%>" target="_blank">🎬 Videos</a>
                    <a href="quiz.jsp?courseId=<%=c.getId()%>">📝 Quiz</a>
                </div>

                <div class="progress-container">
                    <div class="progress-bar" id="progress-<%=c.getId()%>"></div>
                </div>
                <div class="progress-text" id="progress-text-<%=c.getId()%>">Not started</div>
            </div>
        <% } %>
    </div>
</div>
<hr>
<% } %>

<script>
    // Simple: mark progress on click for Docs & Videos
    document.querySelectorAll(".links a").forEach(link => {
        link.addEventListener("click", function() {
            let url = new URL(this.href);
            let courseId = url.searchParams.get("courseId");
            let activity = this.innerText.includes("Documents") ? "DOC" : this.innerText.includes("Videos") ? "VIDEO" : null;
            if(activity) {
                fetch("UpdateProgressServlet", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: "courseId=" + courseId + "&activity=" + activity + "&value=100"
                }).then(() => {
                    // Optional: update progress bar immediately
                    let bar = document.getElementById("progress-" + courseId);
                    let text = document.getElementById("progress-text-" + courseId);
                    if(bar) bar.style.width = "100%";
                    if(text) text.innerText = activity + " Completed (100%)";
                });
            }
        });
    });
</script>

</body>
</html>
s--%>



<%--DECUG --%


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course" %>
<%-- --%
<%
// Debug: Check if this scriptlet runs multiple times
Integer debugCount = (Integer) request.getAttribute("debugExecutionCount");
if (debugCount == null) {
    debugCount = 1;
} else {
    debugCount++;
}
//request.setAttribute("debugExecutionCount", debugCount);

String msg = (String) request.getAttribute("msg");
//System.out.println("=== mycourses.jsp DEBUG ===");
//System.out.println("Execution count: " + debugCount);
//System.out.println("Message from request: " + msg);
//System.out.println("Message from session: " + session.getAttribute("msg"));
//System.out.println("========================");
%>

<%@ include file="navbar.jsp" %>

<%
// Only show message on first execution to prevent duplicates
if (msg != null && debugCount == 1) {
%>
    <div style="
        background:linear-gradient(145deg, #ffffff, #e6faff);
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

<%
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Courses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0a002b; color:white; margin:0; padding:0;}
        .course-section { margin:20px; }
        .course-section h2 { font-size: 24px; color: #00e0ff; border-bottom: 2px solid #00e0ff; padding-bottom: 5px; margin-bottom: 15px; font-weight: bold; letter-spacing: 0.5px; }
        .course-scroll { display:flex; flex-wrap:wrap; gap:20px; }
        .course-card { width:260px; background:#11134d; border-radius:12px; padding:15px; box-shadow:0 4px 6px rgba(0,0,0,0.3); transition: transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:10px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ccc; height:40px; overflow:hidden; }

        .links { margin-top:10px; display:flex; flex-direction:column; }
        .links a { display:block; margin:5px 0; padding:8px; border-radius:6px; text-align:center; text-decoration:none; background:#007bff; color:white; font-size:14px; }
        .links a.disabled { pointer-events:none; opacity:0.5; background:#555; }

        .progress-container { margin-top:10px; background:#222; border-radius:8px; height:20px; width:100%; overflow:hidden; }
        .progress-bar { height:100%; border-radius:8px; background:linear-gradient(90deg,#00e0ff,#0066cc); width:0%; transition:width 0.5s; }
        .progress-text { text-align:right; font-size:12px; margin-top:5px; color:#aaa; }
    </style>
</head>
<body>

<%
if (sectionCourses != null && !sectionCourses.get("My Courses").isEmpty()) {
    for (Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) {
        String sectionName = entry.getKey();
        List<Course> courses = entry.getValue();
%>
    <div class="course-section">
        <h2><%=sectionName%> Courses</h2>
        <div class="course-scroll">
            <% for(Course c : courses) { %>
                <div class="course-card" data-courseid="<%=c.getId()%>">
                    <img src="<%=c.getImage()%>" alt="Course Image">
                    <h3><%=c.getTitle()%></h3>
                    <p><%=c.getDescription()%></p>

                    <div class="links">
                     <%--   <a href="docs.jsp?courseId=<%=c.getId()%>" class="doc-link">📄 Documents</a>
                        <a href="videos.jsp?courseId=<%=c.getId()%>" class="video-link">🎬 Videos</a> --%
                      <a href="UpdateProgressServlet?courseId=<%=c.getId()%>&activity=DOC">📄 Documents</a>
<a href="UpdateProgressServlet?courseId=<%=c.getId()%>&activity=VIDEO">🎬 Videos</a>
                        

                        <% boolean enableQuiz = c.getDocProgress() >= 25 && c.getVideoProgress() >= 25; %>
                        <a href="<%= enableQuiz ? ("quiz_instruction.jsp?courseId=" + c.getId()) : "#" %>"
                           class="quiz-link <%= enableQuiz ? "" : "disabled" %>">
                           📝 Quiz
                        </a>
                    </div>

                    <div class="progress-container">
                        <div class="progress-bar" id="progress-<%=c.getId()%>" style="width:<%= c.getTotalProgress() %>%"></div>
                    </div>
                    <div class="progress-text" id="progress-text-<%=c.getId()%>"><%= c.getTotalProgress() > 0 ? (c.getTotalProgress() + "%") : "Not started" %></div>
                </div>
            <% } %>
        </div>
    </div>
    <hr>
<%
    }
} else {
%>
    <p>No courses found.</p>
<%
}
%>

<script>
    function postProgressAndOpen(courseId, activity, urlToOpen) {
        fetch('UpdateProgressServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'courseId=' + encodeURIComponent(courseId) + '&activity=' + encodeURIComponent(activity) + '&value=100'
        }).then(res => res.json())
          .then(data => {
              let bar = document.getElementById('progress-' + courseId);
              let text = document.getElementById('progress-text-' + courseId);
              if (bar) bar.style.width = data.total_progress + '%';
              if (text) text.innerText = data.total_progress + '%';

              let card = document.querySelector('[data-courseid=\"' + courseId + '\"]');
              if (card) {
                  let quizLink = card.querySelector('.quiz-link');
                  if (quizLink && data.doc_progress >= 25 && data.video_progress >= 25) {
                      quizLink.classList.remove('disabled');
                      quizLink.href = 'quiz_instruction.jsp?courseId=' + courseId;
                  }
              }

              if (urlToOpen) window.open(urlToOpen, '_blank');
        }).catch(err => {
            console.error(err);
            if (urlToOpen) window.open(urlToOpen, '_blank');
        });
    }

    // attach listeners
    document.querySelectorAll('.doc-link').forEach(a => {
        a.addEventListener('click', function(e) {
            e.preventDefault();
            const url = this.href;
            const courseId = new URL(this.href).searchParams.get('courseId');
            postProgressAndOpen(courseId, 'DOC', url);
        });
    });

    document.querySelectorAll('.video-link').forEach(a => {
        a.addEventListener('click', function(e) {
            e.preventDefault();
            const url = this.href;
            const courseId = new URL(this.href).searchParams.get('courseId');
            postProgressAndOpen(courseId, 'VIDEO', url);
        });
    });

    // init: fetch progress for each card (ensures UI reflects DB)
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.getAttribute('data-courseid');
        fetch('GetProgressServlet?courseId=' + courseId)
            .then(res => res.json())
            .then(data => {
                let bar = document.getElementById('progress-' + courseId);
                let text = document.getElementById('progress-text-' + courseId);
                if (bar) bar.style.width = data.total_progress + '%';
                if (text) text.innerText = data.total_progress > 0 ? (data.total_progress + '%') : 'Not started';
                let quizLink = card.querySelector('.quiz-link');
                if (quizLink && data.doc_progress >= 25 && data.video_progress >= 25) {
                    quizLink.classList.remove('disabled');
                    quizLink.href = 'quiz_instruction.jsp?courseId=' + courseId;
                }
            }).catch(err => console.error(err));
    });
</script>

</body>
</html><%-- --%
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>

<%
    String msg = (String) request.getAttribute("msg");
System.out.println("mycourses.jsp - msg = " + msg); 
    if (msg != null) {%>
    	<h1>hello</h1>
    	

    <div style="
        background:linear-gradient(145deg, #ffffff, #e6faff);
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



<%
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Courses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0a002b; color:white; margin:0; padding:0;}
        .course-section { margin:20px; }
        .course-section h2 { font-size: 24px; color: #00e0ff; border-bottom: 2px solid #00e0ff; padding-bottom: 5px; margin-bottom: 15px; font-weight: bold; letter-spacing: 0.5px; }
        .course-scroll { display:flex; flex-wrap:wrap; gap:20px; }
        .course-card { width:260px; background:#11134d; border-radius:12px; padding:15px; box-shadow:0 4px 6px rgba(0,0,0,0.3); transition: transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:10px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ccc; height:40px; overflow:hidden; }

        .links { margin-top:10px; display:flex; flex-direction:column; }
        .links a { display:block; margin:5px 0; padding:8px; border-radius:6px; text-align:center; text-decoration:none; background:#007bff; color:white; font-size:14px; }
        .links a.disabled { pointer-events:none; opacity:0.5; background:#555; }

        .progress-container { margin-top:10px; background:#222; border-radius:8px; height:20px; width:100%; overflow:hidden; }
        .progress-bar { height:100%; border-radius:8px; background:linear-gradient(90deg,#00e0ff,#0066cc); width:0%; transition:width 0.5s; }
        .progress-text { text-align:right; font-size:12px; margin-top:5px; color:#aaa; }
    </style>
</head>
<body>
<%
if (sectionCourses != null && !sectionCourses.get("My Courses").isEmpty()) {
    for (Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) {
        String sectionName = entry.getKey();
        List<Course> courses = entry.getValue();
%>
    <!-- your HTML rendering -->


<div class="course-section">
    <h2><%=sectionName%> Courses</h2>
    <div class="course-scroll">
        <% for(Course c : courses) { %>
            <div class="course-card" data-courseid="<%=c.getId()%>">
                <img src="<%=c.getImage()%>" alt="Course Image">
                <h3><%=c.getTitle()%></h3>
                <p><%=c.getDescription()%></p>

                <div class="links">
                    <a href="docs.jsp?courseId=<%=c.getId()%>" class="doc-link">📄 Documents</a>
                    <a href="videos.jsp?courseId=<%=c.getId()%>" class="video-link">🎬 Videos</a>

                    <% boolean enableQuiz = c.getDocProgress() >= 25 && c.getVideoProgress() >= 25; %>
                    <a href="<%= enableQuiz ? ("quiz_instruction.jsp?courseId=" + c.getId()) : "#" %>"
                       class="quiz-link <%= enableQuiz ? "" : "disabled" %>">
                       📝 Quiz
                    </a>
                </div>

                <div class="progress-container">
                    <div class="progress-bar" id="progress-<%=c.getId()%>" style="width:<%= c.getTotalProgress() %>%"></div>
                </div>
                <div class="progress-text" id="progress-text-<%=c.getId()%>"><%= c.getTotalProgress() > 0 ? (c.getTotalProgress() + "%") : "Not started" %></div>
            </div>
        <% } %>
    </div>
</div>
<hr>
<%
    }
} else {
%>
    <p>No courses found.</p>
<%
}
%>
<script>
    function postProgressAndOpen(courseId, activity, urlToOpen) {
        fetch('UpdateProgressServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'courseId=' + encodeURIComponent(courseId) + '&activity=' + encodeURIComponent(activity) + '&value=100'
        }).then(res => res.json())
          .then(data => {
              let bar = document.getElementById('progress-' + courseId);
              let text = document.getElementById('progress-text-' + courseId);
              if (bar) bar.style.width = data.total_progress + '%';
              if (text) text.innerText = data.total_progress + '%';

              let card = document.querySelector('[data-courseid=\"' + courseId + '\"]');
              if (card) {
                  let quizLink = card.querySelector('.quiz-link');
                  if (quizLink && data.doc_progress >= 25 && data.video_progress >= 25) {
                      quizLink.classList.remove('disabled');
                      quizLink.href = 'quiz_instruction.jsp?courseId=' + courseId;
                  }
              }

              if (urlToOpen) window.open(urlToOpen, '_blank');
        }).catch(err => {
            console.error(err);
            if (urlToOpen) window.open(urlToOpen, '_blank');
        });
    }

    // attach listeners
    document.querySelectorAll('.doc-link').forEach(a => {
        a.addEventListener('click', function(e) {
            e.preventDefault();
            const url = this.href;
            const courseId = new URL(this.href).searchParams.get('courseId');
            postProgressAndOpen(courseId, 'DOC', url);
        });
    });

    document.querySelectorAll('.video-link').forEach(a => {
        a.addEventListener('click', function(e) {
            e.preventDefault();
            const url = this.href;
            const courseId = new URL(this.href).searchParams.get('courseId');
            postProgressAndOpen(courseId, 'VIDEO', url);
        });
    });

    // init: fetch progress for each card (ensures UI reflects DB)
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.getAttribute('data-courseid');
        fetch('GetProgressServlet?courseId=' + courseId)
            .then(res => res.json())
            .then(data => {
                let bar = document.getElementById('progress-' + courseId);
                let text = document.getElementById('progress-text-' + courseId);
                if (bar) bar.style.width = data.total_progress + '%';
                if (text) text.innerText = data.total_progress > 0 ? (data.total_progress + '%') : 'Not started';
                let quizLink = card.querySelector('.quiz-link');
                if (quizLink && data.doc_progress >= 25 && data.video_progress >= 25) {
                    quizLink.classList.remove('disabled');
                    quizLink.href = 'quiz_instruction.jsp?courseId=' + courseId;
                }
            }).catch(err => console.error(err));
    });
</script>

</body>
</html>
--%>



<%--  AFTER UPDATING MYCOURSESSERVLET FOR PROGRESS 25% --%


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course, Module4.UserCourseProgress,java.io.*,Module1.*" %>
<%@ page import="java.net.URLEncoder" %>


<%@ include file="navbar.jsp" %>


<%
    String msg = (String) request.getAttribute("msg");
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
    Map<Integer, UserCourseProgress> progressMap = (Map<Integer, UserCourseProgress>) request.getAttribute("progressMap");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Courses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0a002b; color:white; margin:0; padding:0;}
        .course-section { margin:20px; }
        .course-section h2 { font-size: 24px; color: #00e0ff; border-bottom: 2px solid #00e0ff; padding-bottom: 5px; margin-bottom: 15px; font-weight: bold; letter-spacing: 0.5px; }
        .course-scroll { display:flex; flex-wrap:wrap; gap:20px; }
        .course-card { width:260px; background:#11134d; border-radius:12px; padding:15px; box-shadow:0 4px 6px rgba(0,0,0,0.3); transition: transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:10px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ccc; height:40px; overflow:hidden; }

        .links { margin-top:10px; display:flex; flex-direction:column; }
        .links a { display:block; margin:5px 0; padding:8px; border-radius:6px; text-align:center; text-decoration:none; background:#007bff; color:white; font-size:14px; }
        .links a.disabled { pointer-events:none; opacity:0.5; background:#555; }

        .progress-container { margin-top:10px; background:#222; border-radius:8px; height:20px; width:100%; overflow:hidden; }
       .progress-bar {
    height: 20px;
    border-radius: 10px;
    background: linear-gradient(to right, #ff9800, #ff5722); /* default orange-red */
}

.progress-bar.complete {
    background: linear-gradient(to right, #4caf50, #2e7d32); /* green gradient */
}
       


        .progress-text { text-align:right; font-size:12px; margin-top:5px; color:#aaa; }

        .msg-box {
            background:linear-gradient(145deg, #ffffff, #e6faff);
            color:#155724;
            padding:15px;
            margin:20px auto;
            border:1px solid #c3e6cb;
            border-radius:10px;
            width:80%;
            text-align:center;
            font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            box-shadow:0px 2px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

<% if (msg != null) { %>
    <div class="msg-box"><%= msg %></div>
<% } %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
String username = user.getUsername();
%>


<%
if (sectionCourses != null && sectionCourses.get("My Courses") != null && !sectionCourses.get("My Courses").isEmpty()) {
    for (Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) {
        String sectionName = entry.getKey();
        List<Course> courses = entry.getValue();
%>
    <div class="course-section">
        <h2><%=sectionName%> Courses</h2>
        <div class="course-scroll">
            <% for(Course c : courses) {
                   UserCourseProgress p = progressMap.get(c.getId());
                   int progressValue = (p != null) ? p.getTotalProgress() : 0;
                   String docStatus = (p != null) ? p.getDocProgress() : "NOT_STARTED";
                   String videoStatus = (p != null) ? p.getVideoProgress() : "NOT_STARTED";
                   String quizStatus = (p != null) ? p.getQuizProgress() : "LOCKED";
                   
                   int progress = progressValue; // from resultset
               

                   
            %>
                <div class="course-card" data-courseid="<%=c.getId()%>">
                    <img src="<%=c.getImage()%>" alt="Course Image">
                    <h3><%=c.getTitle()%></h3>
                    <p><%=c.getDescription()%></p>

                    <div class="links">
                        <a href="UpdateProgressServlet?courseId=<%=c.getId()%>&activity=DOC">📄 Documents</a>
                       <a href="#" onclick="openVideoModal('<%= c.getId() %>', '<%= c.getTitle() %>', '<%= c.getDescription().replace("'", "\\'") %>')" class="video-link">🎬 Videos</a>

                        
                        <%
    boolean enableQuiz = "IN_PROGRESS".equals(quizStatus) || "COMPLETED".equals(quizStatus);
%>
<%---------------- --%<a href="<%= enableQuiz ? ("quiz_instruction.jsp?courseId=" + c.getId() + "&title=" + URLEncoder.encode(c.getTitle(), "UTF-8")) : "#" %>"
   class="quiz-link <%= enableQuiz ? "" : "disabled" %>">
   📝 Start Quiz
</a>-----------------------%

<a href="<%= enableQuiz ? (
    "quiz_instruction.jsp?courseId=" + c.getId() + 
    "&title=" + URLEncoder.encode(c.getTitle(), "UTF-8") + 
    "&section=" + URLEncoder.encode(sectionName, "UTF-8")
) : "#" %>"
   class="quiz-link <%= enableQuiz ? "" : "disabled" %>">
   📝 Start Quiz
</a>
<%------------------- --%
<a href="<%= enableQuiz ? ("quiz_instruction.jsp?title=" + URLEncoder.encode(c.getTitle(), "UTF-8") + "&section=" + URLEncoder.encode(sectionName, "UTF-8")) : "#" %>"
   class="quiz-link <%= enableQuiz ? "" : "disabled" %>">
   📝 Start Quiz
</a>

                        

                <%-- -       <%
                            boolean enableQuiz = "IN_PROGRESS".equals(quizStatus) || "COMPLETED".equals(quizStatus);
                        %>
                        <a href="quiz_instruction.jsp?courseId=<%= c.getId() %>&title=<%= URLEncoder.encode(c.getTitle(), "UTF-8") %>">
   Start Quiz
</a>
                        
                     - --%   <a href="<%= enableQuiz ? ("quiz_instruction.jsp?courseId=" + c.getId()) : "#" %>"
                           class="quiz-link <%= enableQuiz ? "" : "disabled" %>">
                           📝 Quiz
                        </a>----------------%
                    
</div>
<%---for review  --%
<div class="progress-container">
    <div class="progress-bar <%= (progress == 100 ? "complete" : "") %>" 
         style="width:<%=progress%>%;"></div>
</div>
<p><%=progress%>% Completed</p>

<% if (progress == 100) { %>
    <div class="links">
        <a href="write_review.jsp?courseId=<%=c.getId()%>&title=<%=URLEncoder.encode(c.getTitle(), "UTF-8")%>"
           class="review-link">✍️ Write Review</a>
    </div>
<% } %>
<%-------------------- --%
<div class="progress-container">
    <div class="progress-bar <%= (progress == 100 ? "complete" : "") %>" 
         style="width:<%=progress%>%;">
    </div>
</div>
<p><%=progress%>% Completed</p>

               <%--     <div class="progress-container">
                        <div class="progress-bar" id="progress-<%=c.getId()%>" style="width:<%= progressValue %>%"></div>
                    </div>
                    <div class="progress-text" id="progress-text-<%=c.getId()%>">
                        <%= progressValue > 0 ? (progressValue + "%") : "Not started" %>
                    </div>-----------------%
                </div>
            <% } %>
        </div>
    </div>
    <hr>
<%
    }
} else {
%>
    <p>No courses found.</p>
<%
}
%>
<!-- Add this inside <body> of mycourses.jsp, near bottom -->
<div id="videoModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
    background:rgba(0,0,0,0.8); z-index:1000; justify-content:center; align-items:center;">
  <div style="background:#fff; color:#000; border-radius:10px; width:80%; height:80%; display:flex; overflow:hidden;">
    <div style="width:35%; padding:20px; overflow:auto;">
      <h2 id="videoTitle" style="color:#11134d;"></h2>
      <p id="videoDesc"></p>
    </div>
    <div style="flex:1; display:flex; justify-content:center; align-items:center;">
      <div id="player"></div>
    </div>
  </div>
</div>


<script>
    // update bar dynamically after servlet calls
    function updateProgressUI(courseId, data) {
        let bar = document.getElementById('progress-' + courseId);
        let text = document.getElementById('progress-text-' + courseId);
        if (bar) bar.style.width = data.total_progress + '%';
        if (text) text.innerText = data.total_progress > 0 ? (data.total_progress + '%') : 'Not started';

        let card = document.querySelector('[data-courseid="' + courseId + '"]');
        if (card) {
            let quizLink = card.querySelector('.quiz-link');
            if (quizLink && (data.quiz_progress === "IN_PROGRESS" || data.quiz_progress === "COMPLETED")) {
                quizLink.classList.remove('disabled');
                quizLink.href = 'quiz_instruction.jsp?courseId=' + courseId;
            }
        }
    }

    // fetch initial progress for each course card
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.getAttribute('data-courseid');
        fetch('GetProgressServlet?courseId=' + courseId)
            .then(res => res.json())
            .then(data => updateProgressUI(courseId, data))
            .catch(err => console.error(err));
    });
    <script src="https://www.youtube.com/iframe_api"></script>
    <script>
    let player;
    let currentCourseId = null;
    let videoWatched = false;

    function openVideoModal(courseId, title, desc) {
        currentCourseId = courseId;
        document.getElementById("videoTitle").innerText = title;
        document.getElementById("videoDesc").innerText = desc;
        document.getElementById("videoModal").style.display = "flex";

        // Fetch the YouTube link dynamically
        fetch("GetCourseVideoServlet?courseId=" + courseId)
          .then(res => res.json())
          .then(data => {
              if (player) player.destroy();
              const videoId = extractYouTubeId(data.video_link);
              player = new YT.Player('player', {
                  height: '100%',
                  width: '100%',
                  videoId: videoId,
                  playerVars: { 'controls': 1 },
                  events: { 'onStateChange': onPlayerStateChange }
              });
          });
    }

    function extractYouTubeId(url) {
        const match = url.match(/(?:youtube\.com.*v=|youtu\.be\/)([^&]+)/);
        return match ? match[1] : null;
    }

    function onPlayerStateChange(event) {
        if (event.data === YT.PlayerState.ENDED && !videoWatched) {
            videoWatched = true;
            // Send AJAX to mark video as reviewed
            fetch("UpdateProgressServlet?courseId=" + currentCourseId + "&activity=VIDEO_COMPLETE")
              .then(() => {
                  alert("✅ Video completed! Progress updated by 25%.");
                  document.getElementById("videoModal").style.display = "none";
                  location.reload(); // refresh progress bar
              });
        }
    }

    // close modal on background click
    document.getElementById("videoModal").addEventListener("click", e => {
        if (e.target.id === "videoModal") {
            document.getElementById("videoModal").style.display = "none";
        }
    });
    </script>

</script>

</body>
</html>   --%




<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Courses</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0a002b, #11134d);
            color: #fff;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            margin-top: 40px;
            color: #00e0ff;
        }

        .course-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            padding: 40px;
        }

        .course-card {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(0,224,255,0.3);
            border-radius: 16px;
            box-shadow: 0 0 15px rgba(0,224,255,0.2);
            transition: transform 0.3s, box-shadow 0.3s;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .course-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 0 25px rgba(0,224,255,0.6);
        }

        .course-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .course-info {
            padding: 15px;
        }

        .course-info h3 {
            color: #00e0ff;
            margin: 0 0 8px;
            font-size: 18px;
        }

        .course-info p {
            color: #ccc;
            font-size: 14px;
            line-height: 1.5;
        }

        .watch-btn {
            background: #00e0ff;
            color: #000;
            border: none;
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
            margin: 10px;
        }

        .watch-btn:hover {
            background: #00c8e0;
        }

        /* 🔹 Video Modal */
        .video-modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.85);
            z-index: 2000;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(4px);
        }

        .video-content {
            display: flex;
            width: 80%;
            height: 75%;
            border-radius: 20px;
            overflow: hidden;
            background: #11134d;
            box-shadow: 0 0 25px rgba(0,224,255,0.5);
            animation: popup 0.3s ease;
        }

        .video-left {
            width: 35%;
            padding: 30px;
            overflow-y: auto;
            color: #fff;
            background: linear-gradient(135deg, #11134d, #0a002b);
        }

        .video-left h2 {
            color: #00e0ff;
            font-size: 22px;
            margin-bottom: 10px;
        }

        .video-left p {
            color: #ccc;
            font-size: 14px;
            line-height: 1.5;
        }

        .video-right {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #000;
        }

        @keyframes popup {
            from {transform: scale(0.9); opacity: 0;}
            to {transform: scale(1); opacity: 1;}
        }
    </style>
</head>
<body>

<h1>🎓 My Courses</h1>

<div class="course-container">
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", ""); // change password if needed
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM courses_1");

        while (rs.next()) {
            String id = rs.getString("id");
            String title = rs.getString("title");
            String desc = rs.getString("description");
            String img = rs.getString("image");
            String video = rs.getString("video_link");
%>
    <div class="course-card">
        <img src="<%=img%>" alt="<%=title%>">
        <div class="course-info">
            <h3><%=title%></h3>
            <p><%=desc%></p>
        </div>
        <button class="watch-btn" onclick="openVideoModal('<%=id%>', '<%=title%>', '<%=desc%>', '<%=video%>')">▶ Watch</button>
    </div>
<%
        }
    } catch(Exception e) {
        out.println("<p>Error: "+e.getMessage()+"</p>");
    } finally {
        if(rs != null) rs.close();
        if(stmt != null) stmt.close();
        if(conn != null) conn.close();
    }
%>
</div>

<!-- 🎬 VIDEO MODAL -->
<div id="videoModal" class="video-modal">
  <div class="video-content">
    <div class="video-left">
      <h2 id="videoTitle"></h2>
      <p id="videoDesc"></p>
    </div>
    <div class="video-right">
      <div id="player"></div>
    </div>
  </div>
</div>

<!-- ✅ SCRIPTS -->
<script src="https://www.youtube.com/iframe_api"></script>
<script>
let player;
let currentCourseId = null;
let videoWatched = false;

function openVideoModal(courseId, title, desc, videoLink) {
  currentCourseId = courseId;
  document.getElementById("videoTitle").innerText = title;
  document.getElementById("videoDesc").innerText = desc;
  document.getElementById("videoModal").style.display = "flex";

  const videoId = extractYouTubeId(videoLink);
  if (player) player.destroy();
  player = new YT.Player('player', {
    height: '100%',
    width: '100%',
    videoId: videoId,
    playerVars: { controls: 1 },
    events: { onStateChange: onPlayerStateChange }
  });
}

function extractYouTubeId(url) {
  const match = url.match(/(?:youtube\.com.*v=|youtu\.be\/)([^&]+)/);
  return match ? match[1] : null;
}

function onPlayerStateChange(event) {
  if (event.data === YT.PlayerState.ENDED && !videoWatched) {
    videoWatched = true;
    alert("✅ Video completed! You can mark progress or load next module.");
    closeVideoModal();
  }
}

document.getElementById("videoModal").addEventListener("click", e => {
  if (e.target.id === "videoModal") closeVideoModal();
});

function closeVideoModal() {
  document.getElementById("videoModal").style.display = "none";
  if (player) player.stopVideo();
}
</script>

</body>
</html>  --%





<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course, Module4.UserCourseProgress,java.io.*,Module1.*,java.net.URLEncoder" %>
<%@ include file="navbar.jsp" %>

<%
    String msg = (String) request.getAttribute("msg");
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
    Map<Integer, UserCourseProgress> progressMap = (Map<Integer, UserCourseProgress>) request.getAttribute("progressMap");
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>My Courses</title>
<style>
body {
    font-family: Arial, sans-serif;
    background: #0a002b;
    color: white;
    margin: 0;
    padding: 0;
}
.course-section { margin: 20px; }
.course-section h2 {
    font-size: 24px;
    color: #00e0ff;
    border-bottom: 2px solid #00e0ff;
    padding-bottom: 5px;
    margin-bottom: 15px;
}
.course-scroll { display: flex; flex-wrap: wrap; gap: 20px; }
.course-card {
    width: 260px;
    background: #11134d;
    border-radius: 12px;
    padding: 15px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.3);
    transition: transform 0.3s;
    position: relative;
}
.course-card:hover { transform: translateY(-5px); }
.course-card img {
    width: 100%;
    height: 140px;
    border-radius: 10px;
    object-fit: cover;
}
.course-card h3 { font-size: 18px; margin: 10px 0; color: #00e0ff; }
.course-card p { font-size: 13px; color: #ccc; height: 40px; overflow: hidden; }
.links { margin-top: 10px; display: flex; flex-direction: column; }
.links a {
    display: block;
    margin: 5px 0;
    padding: 8px;
    border-radius: 6px;
    text-align: center;
    text-decoration: none;
    background: #007bff;
    color: white;
    font-size: 14px;
}
.links a.disabled { pointer-events: none; opacity: 0.5; background: #555; }

.progress-container { margin-top: 10px; background: #222; border-radius: 8px; height: 20px; width: 100%; overflow: hidden; }
.progress-bar { height: 20px; border-radius: 10px; background: linear-gradient(to right, #ff9800, #ff5722); }
.progress-bar.complete { background: linear-gradient(to right, #4caf50, #2e7d32); }

/* 🔹 Circular Progress */
.video-circle {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 40px;
    height: 40px;
}
.video-circle svg circle {
    fill: none;
    stroke-width: 4;
    stroke: #00e0ff;
    stroke-linecap: round;
    transform: rotate(-90deg);
    transform-origin: 50% 50%;
}
.video-circle svg circle.bg {
    stroke: rgba(255,255,255,0.1);
}

/* 🔹 Video Modal */
.video-modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.85);
    z-index: 2000;
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(4px);
}
.video-content {
    display: flex;
    width: 80%;
    height: 75%;
    border-radius: 20px;
    overflow: hidden;
    background: #11134d;
    box-shadow: 0 0 25px rgba(0,224,255,0.5);
    animation: popup 0.3s ease;
}
.video-left {
    width: 35%;
    padding: 30px;
    overflow-y: auto;
    color: #fff;
    background: linear-gradient(135deg, #11134d, #0a002b);
}
.video-right {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    background: #000;
}
@keyframes popup {
    from {transform: scale(0.9); opacity: 0;}
    to {transform: scale(1); opacity: 1;}
}
</style>
</head>
<body>

<% if (msg != null) { %>
    <div class="msg-box"><%= msg %></div>
<% } %>

<%
if (sectionCourses != null && !sectionCourses.isEmpty()) {
    for (Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) {
        String sectionName = entry.getKey();
        List<Course> courses = entry.getValue();
%>
<div class="course-section">
<h2><%=sectionName%> Courses</h2>
<div class="course-scroll">
<% for (Course c : courses) {
   UserCourseProgress p = progressMap.get(c.getId());
   int progressValue = (p != null) ? p.getTotalProgress() : 0;
   String quizStatus = (p != null) ? p.getQuizProgress() : "LOCKED";
%>
<div class="course-card" data-courseid="<%=c.getId()%>">
    <div class="video-circle" id="circle-<%=c.getId()%>">
        <svg width="40" height="40">
            <circle class="bg" cx="20" cy="20" r="18"></circle>
            <circle class="progress" cx="20" cy="20" r="18" stroke-dasharray="113" stroke-dashoffset="113"></circle>
        </svg>
    </div>

    <img src="<%=c.getImage()%>" alt="Course Image">
    <h3><%=c.getTitle()%></h3>
    <p><%=c.getDescription()%></p>

    <div class="links">
        <a href="UpdateProgressServlet?courseId=<%=c.getId()%>&activity=DOC">📄 Documents</a>
        <a href="#" onclick="console.log('Video Clicked'); openVideoModal('<%=c.getId()%>', '<%=c.getTitle()%>', '<%=c.getDescription()%>', '<%=c.getVideoLink()%>')">🎬 Videos</a>
        
    <%-- --%    <a href="#" onclick="openVideoModal('<%=c.getId()%>', '<%=c.getTitle()%>', '<%=c.getDescription()%>', '<%=c.getVideoLink()%>')">🎬 Videos</a>  --%
        <a href="<%= ("IN_PROGRESS".equals(quizStatus) || "COMPLETED".equals(quizStatus)) ? ("quiz_instruction.jsp?courseId=" + c.getId()) : "#" %>"
           class="quiz-link <%= ("IN_PROGRESS".equals(quizStatus) || "COMPLETED".equals(quizStatus)) ? "" : "disabled" %>">📝 Start Quiz</a>
    </div>

    <div class="progress-container">
        <div class="progress-bar <%= (progressValue == 100 ? "complete" : "") %>"
             style="width:<%=progressValue%>%"></div>
    </div>
    <p><%=progressValue%>% Completed</p>
</div>
<% } %>
</div>
</div>
<% } } %>

<!-- 🎬 Video Modal -->
<div id="videoModal" class="video-modal">
  <div class="video-content">
    <div class="video-left">
      <h2 id="videoTitle"></h2>
      <p id="videoDesc"></p>
    </div>
    <div class="video-right">
      <div id="player"></div>
    </div>
  </div>
</div>

<!-- ✅ Scripts -->
<script src="https://www.youtube.com/iframe_api"></script>
<script>
let player;
let currentCourseId = null;
let lastUpdateTime = 0;

function openVideoModal(courseId, title, desc, videoLink) {
  currentCourseId = courseId;
  document.getElementById("videoTitle").innerText = title;
  document.getElementById("videoDesc").innerText = desc;
  document.getElementById("videoModal").style.display = "flex";

  const videoId = extractYouTubeId(videoLink);
  if (player) player.destroy();
  player = new YT.Player('player', {
    height: '100%',
    width: '100%',
    videoId: videoId,
    playerVars: { controls: 1 },
    events: { onStateChange: onPlayerStateChange }
  });
}

function extractYouTubeId(url) {
  const match = url.match(/(?:youtube\\.com.*v=|youtu\\.be\\/)([^&]+)/);
  return match ? match[1] : null;
}

function onPlayerStateChange(event) {
  if (event.data === YT.PlayerState.PLAYING) {
    trackProgress();
  }
  if (event.data === YT.PlayerState.ENDED) {
    updateVideoProgress(100);
  }
}

function trackProgress() {
  if (!player || player.getDuration() === 0) return;
  setInterval(() => {
    const duration = player.getDuration();
    const current = player.getCurrentTime();
    const percent = Math.min(100, Math.round((current / duration) * 100));
    updateVideoCircle(currentCourseId, percent);
    if (percent - lastUpdateTime >= 10) { // update every 10%
      lastUpdateTime = percent;
      updateVideoProgress(percent);
    }
  }, 2000);
}

function updateVideoCircle(courseId, percent) {
  const circle = document.querySelector(`#circle-${courseId} circle.progress`);
  const circumference = 113; // 2πr
  const offset = circumference - (percent / 100) * circumference;
  if (circle) circle.style.strokeDashoffset = offset;
}

function updateVideoProgress(percent) {
  if (!currentCourseId) return;
  fetch(`UpdateProgressServlet?courseId=${currentCourseId}&activity=VIDEO&progress=${percent}`)
    .then(() => console.log("Progress updated: " + percent + "%"))
    .catch(err => console.error(err));
}

document.getElementById("videoModal").addEventListener("click", e => {
  if (e.target.id === "videoModal") closeVideoModal();
});

function closeVideoModal() {
  document.getElementById("videoModal").style.display = "none";
  if (player) player.stopVideo();
}
</script>

</body>
</html> --%>








<%--claude ai  --%



<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course, Module4.UserCourseProgress,java.io.*,Module1.*,java.net.URLEncoder" %>
<%@ include file="navbar.jsp" %>

<%
    String msg = (String) request.getAttribute("msg");
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
    Map<Integer, UserCourseProgress> progressMap = (Map<Integer, UserCourseProgress>) request.getAttribute("progressMap");
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = user.getUsername();
%>

<!DOCTYPE html>
<html>
<head>
<title>My Courses</title>
<style>
body {
    font-family: Arial, sans-serif;
    background: #0a002b;
    color: white;
    margin: 0;
    padding: 0;
}
.course-section { margin: 20px; }
.course-section h2 {
    font-size: 24px;
    color: #00e0ff;
    border-bottom: 2px solid #00e0ff;
    padding-bottom: 5px;
    margin-bottom: 15px;
    font-weight: bold;
    letter-spacing: 0.5px;
}
.course-scroll { display: flex; flex-wrap: wrap; gap: 20px; }
.course-card {
    width: 260px;
    background: #11134d;
    border-radius: 12px;
    padding: 15px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.3);
    transition: transform 0.3s;
    position: relative;
}
.course-card:hover { transform: translateY(-5px); }
.course-card img {
    width: 100%;
    height: 140px;
    border-radius: 10px;
    object-fit: cover;
}
.course-card h3 { font-size: 18px; margin: 10px 0; color: #00e0ff; }
.course-card p { font-size: 13px; color: #ccc; height: 40px; overflow: hidden; }

.links { margin-top: 10px; display: flex; flex-direction: column; }
.links a {
    display: block;
    margin: 5px 0;
    padding: 8px;
    border-radius: 6px;
    text-align: center;
    text-decoration: none;
    background: #007bff;
    color: white;
    font-size: 14px;
    cursor: pointer;
}
.links a.disabled { pointer-events: none; opacity: 0.5; background: #555; }

.progress-container { 
    margin-top: 10px; 
    background: #222; 
    border-radius: 8px; 
    height: 20px; 
    width: 100%; 
    overflow: hidden; 
}
.progress-bar { 
    height: 20px; 
    border-radius: 10px; 
    background: linear-gradient(to right, #ff9800, #ff5722);
    transition: width 0.3s ease;
}
.progress-bar.complete { 
    background: linear-gradient(to right, #4caf50, #2e7d32); 
}

.progress-text { 
    text-align: center; 
    font-size: 14px; 
    margin-top: 5px; 
    color: #aaa; 
    font-weight: bold;
}

/* 🔹 Circular Video Progress Indicator */
.video-circle {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 45px;
    height: 45px;
    background: rgba(0,0,0,0.7);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}
.video-circle svg {
    width: 40px;
    height: 40px;
    transform: rotate(-90deg);
}
.video-circle svg circle {
    fill: none;
    stroke-width: 4;
}
.video-circle svg circle.bg {
    stroke: rgba(255,255,255,0.2);
}
.video-circle svg circle.progress {
    stroke: #00e0ff;
    stroke-linecap: round;
    stroke-dasharray: 113;
    stroke-dashoffset: 113;
    transition: stroke-dashoffset 0.3s ease;
}
.video-circle .percent-text {
    position: absolute;
    font-size: 10px;
    font-weight: bold;
    color: #00e0ff;
}

/* 🔹 Video Modal */
.video-modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.9);
    z-index: 2000;
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(8px);
}
.video-content {
    display: flex;
    width: 90%;
    max-width: 1400px;
    height: 80vh;
    border-radius: 20px;
    overflow: hidden;
    background: #11134d;
    box-shadow: 0 0 40px rgba(0,224,255,0.6);
    animation: popup 0.3s ease;
}
.video-left {
    width: 35%;
    padding: 30px;
    overflow-y: auto;
    color: #fff;
    background: linear-gradient(135deg, #1a1a4d, #0a002b);
    border-right: 2px solid #00e0ff;
}
.video-left h2 {
    color: #00e0ff;
    margin-bottom: 20px;
    font-size: 26px;
}
.video-left p {
    line-height: 1.8;
    color: #ccc;
    font-size: 15px;
}
.video-right {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    background: #000;
    position: relative;
}
.close-modal-btn {
    position: absolute;
    top: 20px;
    right: 20px;
    background: rgba(255,0,0,0.8);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 16px;
    z-index: 10;
}
.close-modal-btn:hover {
    background: rgba(255,0,0,1);
}
.watch-status {
    margin-top: 20px;
    padding: 15px;
    background: rgba(0,224,255,0.1);
    border-radius: 10px;
    border: 1px solid #00e0ff;
}
.watch-status h3 {
    color: #00e0ff;
    margin-bottom: 10px;
    font-size: 18px;
}
.watch-status p {
    margin: 8px 0;
    font-size: 14px;
}

@keyframes popup {
    from {transform: scale(0.8); opacity: 0;}
    to {transform: scale(1); opacity: 1;}
}

.msg-box {
    background: linear-gradient(145deg, #ffffff, #e6faff);
    color: #155724;
    padding: 15px;
    margin: 20px auto;
    border: 1px solid #c3e6cb;
    border-radius: 10px;
    width: 80%;
    text-align: center;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    box-shadow: 0px 2px 8px rgba(0,0,0,0.1);
}
</style>
</head>
<body>

<% if (msg != null) { %>
    <div class="msg-box"><%= msg %></div>
<% } %>

<%
if (sectionCourses != null && !sectionCourses.isEmpty()) {
    for (Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) {
        String sectionName = entry.getKey();
        List<Course> courses = entry.getValue();
%>
<div class="course-section">
<h2><%=sectionName%></h2>
<div class="course-scroll">
<% for (Course c : courses) {
   UserCourseProgress p = progressMap.get(c.getId());
   int progressValue = (p != null) ? p.getTotalProgress() : 0;
   String docStatus = (p != null) ? p.getDocProgress() : "NOT_STARTED";
   String videoStatus = (p != null) ? p.getVideoProgress() : "NOT_STARTED";
   String quizStatus = (p != null) ? p.getQuizProgress() : "LOCKED";
   int videoPercent = 0; // Will be loaded via JS
%>


<div class="course-card" data-courseid="<%=c.getId()%>">
    <!-- Video Progress Circle -->
    <div class="video-circle" id="circle-<%=c.getId()%>">
        <svg>
            <circle class="bg" cx="20" cy="20" r="18"></circle>
            <circle class="progress" cx="20" cy="20" r="18"></circle>
        </svg>
        <span class="percent-text">0%</span>
    </div>

    <img src="<%=c.getImage()%>" alt="<%=c.getTitle()%>">
    <h3><%=c.getTitle()%></h3>
    <p><%=c.getDescription()%></p>

    <div class="links">
        <a href="UpdateProgressServlet?courseId=<%=c.getId()%>&activity=DOC">📄 Documents</a>
        
        <a href="#" class="video-link" 
           data-courseid="<%=c.getId()%>" 
           data-title="<%=c.getTitle()%>" 
           data-desc="<%=c.getDescription()%>" 
           data-video="<%=c.getVideoLink()%>">
           🎬 Videos
        </a>
        
        <a href="<%= ("IN_PROGRESS".equals(quizStatus) || "COMPLETED".equals(quizStatus)) ? 
                    ("quiz_instruction.jsp?courseId=" + c.getId() + 
                     "&title=" + URLEncoder.encode(c.getTitle(), "UTF-8") + 
                     "&section=" + URLEncoder.encode(sectionName, "UTF-8")) : "#" %>"
           class="quiz-link <%= ("IN_PROGRESS".equals(quizStatus) || "COMPLETED".equals(quizStatus)) ? "" : "disabled" %>">
           📝 Start Quiz
        </a>
    </div>

    <div class="progress-container">
        <div class="progress-bar <%= (progressValue == 100 ? "complete" : "") %>"
             id="progress-bar-<%=c.getId()%>"
             style="width:<%=progressValue%>%"></div>
    </div>
    <p class="progress-text" id="progress-text-<%=c.getId()%>"><%=progressValue%>% Completed</p>

    <% if (progressValue == 100) { %>
    <div class="links">
        <a href="write_review.jsp?courseId=<%=c.getId()%>&title=<%=URLEncoder.encode(c.getTitle(), "UTF-8")%>"
           class="review-link">✍️ Write Review</a>
    </div>
    <% } %>
</div>
<% } %>
</div>
</div>
<hr>
<% } } else { %>
    <p style="text-align:center; margin-top:50px;">No courses found.</p>
<% } %>

<!-- 🎬 Video Modal -->
<div id="videoModal" class="video-modal">
  <div class="video-content">
    <div class="video-left">
      <h2 id="videoTitle">Course Title</h2>
      <p id="videoDesc">Course Description</p>
      
      <div class="watch-status">
        <h3>📊 Watch Progress</h3>
        <p>⏱️ Time Watched: <span id="timeWatched">0:00</span></p>
        <p>📺 Total Duration: <span id="totalTime">0:00</span></p>
        <p>✅ Completion: <span id="completionPercent">0%</span></p>
        <p style="font-size:12px; color:#888; margin-top:10px;">
          💡 Watch at least 90% to earn progress credit
        </p>
      </div>
    </div>
    <div class="video-right">
      <button class="close-modal-btn" onclick="closeVideoModal()">✕ Close</button>
      <div id="player"></div>
    </div>
  </div>
</div>

<!-- ✅ YouTube API and Custom Scripts -->
<script src="https://www.youtube.com/iframe_api"></script>
<script>
let player;
let currentCourseId = null;
let watchedSeconds = 0;
let totalDuration = 0;
let progressInterval = null;
let lastSavedProgress = 0;

// Load initial video progress for all courses
document.addEventListener('DOMContentLoaded', function() {
    // Attach video link click handlers
    
    
    document.querySelectorAll('.video-link').forEach(link => {
    link.addEventListener('click', function(e) {
        e.preventDefault();
        const courseId = this.dataset.courseid;
        const title = this.dataset.title;
        const desc = this.dataset.desc;
        let videoLink = this.dataset.video;

        // ✅ Convert standard YouTube URL to embed URL
        if (videoLink && videoLink.includes("watch?v=")) {
            videoLink = videoLink.replace("watch?v=", "embed/");
        }

        openVideoModal(courseId, title, desc, videoLink);
    });
});

    
  //  document.querySelectorAll('.video-link').forEach(link => {
  //      link.addEventListener('click', function(e) {
 //           e.preventDefault();
   //         const courseId = this.dataset.courseid;
    //        const title = this.dataset.title;
     //       const desc = this.dataset.desc;
      //      const videoLink = this.dataset.video;
       //     openVideoModal(courseId, title, desc, videoLink);
       // });
    //});
    
    // Load video progress for each course
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.dataset.courseid;
        loadVideoProgress(courseId);
    });
});

function loadVideoProgress(courseId) {
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            updateVideoCircle(courseId, data.videoWatchPercent || 0);
        })
        .catch(err => console.error('Failed to load video progress:', err));
}

function openVideoModal(courseId, title, desc, videoLink) {
    currentCourseId = courseId;
    watchedSeconds = 0;
    lastSavedProgress = 0;
    
    document.getElementById("videoTitle").innerText = title;
    document.getElementById("videoDesc").innerText = desc;
    document.getElementById("videoModal").style.display = "flex";

    const videoId = extractYouTubeId(videoLink);
    if (!videoId) {
        alert('Invalid YouTube URL');
        closeVideoModal();
        return;
    }
    
    if (player) player.destroy();
    
    player = new YT.Player('player', {
        height: '100%',
        width: '100%',
        videoId: videoId,
        playerVars: { 
            controls: 1,
            rel: 0,
            modestbranding: 1,
            disablekb: 0,
            fs: 1
        },
        events: { 
            onReady: onPlayerReady,
            onStateChange: onPlayerStateChange 
        }
    });
}

function extractYouTubeId(url) {
    const patterns = [
        /(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&\s]+)/,
        /youtube\.com\/embed\/([^&\s]+)/
    ];
    for (let pattern of patterns) {
        const match = url.match(pattern);
        if (match) return match[1];
    }
    return null;
}

function onPlayerReady(event) {
    totalDuration = player.getDuration();
    document.getElementById('totalTime').innerText = formatTime(totalDuration);
    console.log('✅ Video ready. Duration:', totalDuration, 'seconds');
}

function onPlayerStateChange(event) {
    if (event.data === YT.PlayerState.PLAYING) {
        startTrackingProgress();
    } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
        stopTrackingProgress();
        if (event.data === YT.PlayerState.ENDED) {
            handleVideoComplete();
        }
    }
}

function startTrackingProgress() {
    if (progressInterval) return; // Already tracking
    
    progressInterval = setInterval(() => {
        if (!player || totalDuration === 0) return;
        
        const currentTime = player.getCurrentTime();
        watchedSeconds += 1; // Count actual seconds watched
        
        // Calculate percentages
        const seekPercent = Math.min(100, (currentTime / totalDuration) * 100);
        const actualPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        
        // Update UI
        updateWatchStatus(watchedSeconds, totalDuration, actualPercent);
        updateVideoCircle(currentCourseId, actualPercent);
        
        // Auto-save progress every 10% increment
        if (Math.floor(actualPercent / 10) > Math.floor(lastSavedProgress / 10)) {
            saveVideoProgress(actualPercent);
            lastSavedProgress = actualPercent;
        }
        
        console.log(`⏱️ Watched: ${actualPercent.toFixed(1)}% | Seek: ${seekPercent.toFixed(1)}%`);
        
    }, 1000); // Track every second
}

function stopTrackingProgress() {
    if (progressInterval) {
        clearInterval(progressInterval);
        progressInterval = null;
    }
}

function updateWatchStatus(watched, total, percent) {
    document.getElementById('timeWatched').innerText = formatTime(watched);
    document.getElementById('totalTime').innerText = formatTime(total);
    document.getElementById('completionPercent').innerText = Math.floor(percent) + '%';
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

function updateVideoCircle(courseId, percent) {
    const circle = document.querySelector(`#circle-${courseId} circle.progress`);
    const text = document.querySelector(`#circle-${courseId} .percent-text`);
    const circumference = 113; // 2πr where r=18
    const offset = circumference - (percent / 100) * circumference;
    
    if (circle) circle.style.strokeDashoffset = offset;
    if (text) text.innerText = Math.floor(percent) + '%';
}

function saveVideoProgress(percent) {
    if (!currentCourseId) return;
    
    const formData = new FormData();
    formData.append('courseId', currentCourseId);
    formData.append('watchPercent', percent);
    formData.append('action', 'update_video_watch');
    
    fetch('UpdateVideoProgressServlet', {
        method: 'POST',
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        console.log('✅ Progress saved:', data);
        // Update main progress bar if video is marked as REVIEWED
        if (data.videoStatus === 'REVIEWED') {
            updateMainProgressBar(currentCourseId, data.totalProgress);
        }
    })
    .catch(err => console.error('❌ Failed to save progress:', err));
}

function updateMainProgressBar(courseId, totalProgress) {
    const bar = document.getElementById('progress-bar-' + courseId);
    const text = document.getElementById('progress-text-' + courseId);
    
    if (bar) {
        bar.style.width = totalProgress + '%';
        if (totalProgress === 100) bar.classList.add('complete');
    }
    if (text) text.innerText = totalProgress + '% Completed';
    
    // Reload to show review button if 100%
    if (totalProgress === 100) {
        setTimeout(() => location.reload(), 1500);
    }
}

function handleVideoComplete() {
    const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
    console.log('🎬 Video ended. Final watch %:', finalPercent);
    
    if (finalPercent >= 90) {
        saveVideoProgress(100); // Mark as fully watched
        alert('🎉 Congratulations! You have completed this video.');
    } else {
        alert('⚠️ Please watch at least 90% of the video to earn progress credit.');
    }
}

function closeVideoModal() {
    stopTrackingProgress();
    
    // Save final progress
    if (watchedSeconds > 0 && totalDuration > 0) {
        const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        saveVideoProgress(finalPercent);
    }
    
    document.getElementById("videoModal").style.display = "none";
    if (player) {
        player.stopVideo();
        player.destroy();
        player = null;
    }
    
    // Reload progress after closing
    if (currentCourseId) {
        loadVideoProgress(currentCourseId);
    }
}

// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('videoModal');
    if (e.target === modal) {
        closeVideoModal();
    }
});
</script>

</body>
</html>  --%>








<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course, Module4.UserCourseProgress,java.io.*,Module1.*,java.net.URLEncoder" %>
<%@ include file="navbar.jsp" %>

<%
    String msg = (String) request.getAttribute("msg");
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");
    Map<Integer, UserCourseProgress> progressMap = (Map<Integer, UserCourseProgress>) request.getAttribute("progressMap");
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = user.getUsername();
%>

<!DOCTYPE html>
<html>
<head>
<title>My Courses</title>
<style>
body {
    font-family: Arial, sans-serif;
    background: #0a002b;
    color: white;
    margin: 0;
    padding: 0;
}
.course-section { margin: 20px; }
.course-section h2 {
    font-size: 24px;
    color: #00e0ff;
    border-bottom: 2px solid #00e0ff;
    padding-bottom: 5px;
    margin-bottom: 15px;
    font-weight: bold;
    letter-spacing: 0.5px;
}
.course-scroll { display: flex; flex-wrap: wrap; gap: 20px; }
.course-card {
    width: 260px;
    background: #11134d;
    border-radius: 12px;
    padding: 15px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.3);
    transition: transform 0.3s;
    position: relative;
}
.course-card:hover { transform: translateY(-5px); }
.course-card img {
    width: 100%;
    height: 140px;
    border-radius: 10px;
    object-fit: cover;
}
.course-card h3 { font-size: 18px; margin: 10px 0; color: #00e0ff; }
.course-card p { font-size: 13px; color: #ccc; height: 40px; overflow: hidden; }

.links { margin-top: 10px; display: flex; flex-direction: column; }
.links a {
    display: block;
    margin: 5px 0;
    padding: 8px;
    border-radius: 6px;
    text-align: center;
    text-decoration: none;
    background: #007bff;
    color: white;
    font-size: 14px;
    cursor: pointer;
}
.links a.disabled { pointer-events: none; opacity: 0.5; background: #555; }

.progress-container { 
    margin-top: 10px; 
    background: #222; 
    border-radius: 8px; 
    height: 20px; 
    width: 100%; 
    overflow: hidden; 
}
.progress-bar { 
    height: 20px; 
    border-radius: 10px; 
    background: linear-gradient(to right, #ff9800, #ff5722);
    transition: width 0.3s ease;
}
.progress-bar.complete { 
    background: linear-gradient(to right, #4caf50, #2e7d32); 
}

.progress-text { 
    text-align: center; 
    font-size: 14px; 
    margin-top: 5px; 
    color: #aaa; 
    font-weight: bold;
}

/* 🔹 Circular Video Progress Indicator */

.video-circle {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 45px;
    height: 45px;
    background: rgba(0,0,0,0.8);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 10;
}

.video-circle svg {
    width: 40px;
    height: 40px;
    transform: rotate(-90deg);
}

.video-circle circle.bg {
    fill: none;
    stroke: #e0e0e0;
    stroke-width: 3;
    stroke-dasharray: 113;
    stroke-dashoffset: 0;
}

.video-circle circle.progress {
    fill: none;
    stroke: #4CAF50;
    stroke-width: 3;
    stroke-dasharray: 113;
    stroke-dashoffset: 113; /* Start at 0% */
    transition: stroke-dashoffset 0.5s ease;
}

.video-circle .percent-text {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 10px;
    font-weight: bold;
}
/*
.video-circle {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 45px;
    height: 45px;
    background: rgba(0,0,0,0.7);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}
.video-circle svg {
    width: 40px;
    height: 40px;
    transform: rotate(-90deg);
}
.video-circle svg circle {
    fill: none;
    stroke-width: 4;
}
.video-circle svg circle.bg {
    stroke: rgba(255,255,255,0.2);
}
.video-circle svg circle.progress {
    stroke: #00e0ff;
    stroke-linecap: round;
    stroke-dasharray: 113;
    stroke-dashoffset: 113;
    transition: stroke-dashoffset 0.3s ease;
}
.video-circle .percent-text {
    position: absolute;
    font-size: 10px;
    font-weight: bold;
    color: #00e0ff;
}
*/
/* 🔹 Video Modal */
.video-modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.9);
    z-index: 2000;
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(8px);
}
.video-content {
    display: flex;
    width: 90%;
    max-width: 1400px;
    height: 80vh;
    border-radius: 20px;
    overflow: hidden;
    background: #11134d;
    box-shadow: 0 0 40px rgba(0,224,255,0.6);
    animation: popup 0.3s ease;
}
.video-left {
    width: 35%;
    padding: 30px;
    overflow-y: auto;
    color: #fff;
    background: linear-gradient(135deg, #1a1a4d, #0a002b);
    border-right: 2px solid #00e0ff;
}
.video-left h2 {
    color: #00e0ff;
    margin-bottom: 20px;
    font-size: 26px;
}
.video-left p {
    line-height: 1.8;
    color: #ccc;
    font-size: 15px;
}
.video-right {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    background: #000;
    position: relative;
}
.close-modal-btn {
    position: absolute;
    top: 20px;
    right: 20px;
    background: rgba(255,0,0,0.8);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 16px;
    z-index: 10;
}
.close-modal-btn:hover {
    background: rgba(255,0,0,1);
}
.watch-status {
    margin-top: 20px;
    padding: 15px;
    background: rgba(0,224,255,0.1);
    border-radius: 10px;
    border: 1px solid #00e0ff;
}
.watch-status h3 {
    color: #00e0ff;
    margin-bottom: 10px;
    font-size: 18px;
}
.watch-status p {
    margin: 8px 0;
    font-size: 14px;
}

@keyframes popup {
    from {transform: scale(0.8); opacity: 0;}
    to {transform: scale(1); opacity: 1;}
}

.msg-box {
    background: linear-gradient(145deg, #ffffff, #e6faff);
    color: #155724;
    padding: 15px;
    margin: 20px auto;
    border: 1px solid #c3e6cb;
    border-radius: 10px;
    width: 80%;
    text-align: center;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    box-shadow: 0px 2px 8px rgba(0,0,0,0.1);
}
</style>
</head>
<body>

<% if (msg != null) { %>
    <div class="msg-box"><%= msg %></div>
<% } %>

<%
if (sectionCourses != null && !sectionCourses.isEmpty()) {
    for (Map.Entry<String, List<Course>> entry : sectionCourses.entrySet()) {
        String sectionName = entry.getKey();
        List<Course> courses = entry.getValue();
%>
<div class="course-section">
<h2><%=sectionName%></h2>
<div class="course-scroll">
<% for (Course c : courses) {
   UserCourseProgress p = progressMap.get(c.getId());
   int progressValue = (p != null) ? p.getTotalProgress() : 0;
   String docStatus = (p != null) ? p.getDocProgress() : "NOT_STARTED";
   String videoStatus = (p != null) ? p.getVideoProgress() : "NOT_STARTED";
   String quizStatus = (p != null) ? p.getQuizProgress() : "LOCKED";
   int videoPercent = 0; // Will be loaded via JS
   
   // DEBUG: Check if video link is null
   String videoLink = c.getVideoLink();
   if (videoLink == null || videoLink.isEmpty()) {
       System.out.println("⚠️ WARNING: Course ID " + c.getId() + " has null/empty video_link!");
   }
%>
<div class="course-card" data-courseid="<%=c.getId()%>">
    <!-- Video Progress Circle -->
    
    <div class="video-circle" id="circle-<%=c.getId()%>">
    <svg>
        <circle class="bg" cx="20" cy="20" r="18"></circle>
        <circle class="progress" cx="20" cy="20" r="18"></circle>
    </svg>
    <span class="percent-text">0%</span>
</div>
 <!-- --   <div class="video-circle" id="circle-<%--<%=c.getId()%>--%>">
        <svg>
            <circle class="bg" cx="20" cy="20" r="18"></circle>
            <circle class="progress" cx="20" cy="20" r="18"></circle>
        </svg>
        <span class="percent-text">0%</span>
    </div> -->

    <img src="<%=c.getImage()%>" alt="<%=c.getTitle()%>">
    <h3><%=c.getTitle()%></h3>
    <p><%=c.getDescription()%></p>

    <div class="links">
        <a href="UpdateProgressServlet?courseId=<%=c.getId()%>&activity=DOC">📄 Documents</a>
        
        <a href="#" class="video-link" 
           data-courseid="<%=c.getId()%>" 
           data-title="<%=c.getTitle()%>" 
           data-desc="<%=c.getDescription()%>" 
           data-video="<%=c.getVideoLink()%>">
           🎬 Videos
        </a>
        
        <a href="<%= ("IN_PROGRESS".equals(quizStatus) || "COMPLETED".equals(quizStatus)) ? 
                    ("quiz_instruction.jsp?courseId=" + c.getId() + 
                     "&title=" + URLEncoder.encode(c.getTitle(), "UTF-8") + 
                     "&section=" + URLEncoder.encode(sectionName, "UTF-8")) : "#" %>"
           class="quiz-link <%= ("IN_PROGRESS".equals(quizStatus) || "COMPLETED".equals(quizStatus)) ? "" : "disabled" %>">
           📝 Start Quiz
        </a>
    </div>

    <div class="progress-container">
        <div class="progress-bar <%= (progressValue == 100 ? "complete" : "") %>"
             id="progress-bar-<%=c.getId()%>"
             style="width:<%=progressValue%>%"></div>
    </div>
    <p class="progress-text" id="progress-text-<%=c.getId()%>"><%=progressValue%>% Completed</p>

    <% if (progressValue == 100) { %>
    <div class="links">
        <a href="write_review.jsp?courseId=<%=c.getId()%>&title=<%=URLEncoder.encode(c.getTitle(), "UTF-8")%>"
           class="review-link">✍️ Write Review</a>
    </div>
    <% } %>
</div>
<% } %>
</div>
</div>
<hr>
<% } } else { %>
    <p style="text-align:center; margin-top:50px;">No courses found.</p>
<% } %>

<!-- 🎬 Video Modal -->
<div id="videoModal" class="video-modal">
  <div class="video-content">
    <div class="video-left">
      <h2 id="videoTitle">Course Title</h2>
      <p id="videoDesc">Course Description</p>
      
      <div class="watch-status">
        <h3>📊 Watch Progress</h3>
        <p>⏱️ Time Watched: <span id="timeWatched">0:00</span></p>
        <p>📺 Total Duration: <span id="totalTime">0:00</span></p>
        <p>✅ Completion: <span id="completionPercent">0%</span></p>
        <p style="font-size:12px; color:#888; margin-top:10px;">
          💡 Watch at least 90% to earn progress credit
        </p>
      </div>
    </div>
    <div class="video-right">
      <button class="close-modal-btn" onclick="closeVideoModal()">✕ Close</button>
      <div id="player"></div>
    </div>
  </div>
</div>

<!-- ✅ YouTube API and Custom Scripts -->
<script src="https://www.youtube.com/iframe_api"></script>


<%-- --%
<script>
let player;
let currentCourseId = null;
let watchedSeconds = 0;
let totalDuration = 0;
let progressInterval = null;
let lastSavedProgress = 0;

// Load initial video progress for all courses
document.addEventListener('DOMContentLoaded', function() {
    // Attach video link click handlers
    document.querySelectorAll('.video-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const courseId = this.dataset.courseid;
            const title = this.dataset.title;
            const desc = this.dataset.desc;
            const videoLink = this.dataset.video;
            openVideoModal(courseId, title, desc, videoLink);
        });
    });
    
    // Load video progress for each course
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.dataset.courseid;
        loadVideoProgress(courseId);
    });
});

function loadVideoProgress(courseId) {
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            updateVideoCircle(courseId, data.videoWatchPercent || 0);
        })
        .catch(err => console.error('Failed to load video progress:', err));
}

function openVideoModal(courseId, title, desc, videoLink) {
    console.log('🎬 Opening video modal...');
    console.log('Course ID:', courseId);
    console.log('Video Link from database:', videoLink);
    
    currentCourseId = courseId;
    watchedSeconds = 0;
    lastSavedProgress = 0;
    
    document.getElementById("videoTitle").innerText = title;
    document.getElementById("videoDesc").innerText = desc;
    document.getElementById("videoModal").style.display = "flex";

    const videoId = extractYouTubeId(videoLink);
    console.log('Extracted Video ID:', videoId);
    
    if (!videoId) {
        alert('Invalid YouTube URL: ' + videoLink + '\n\nPlease check the video_link in your database.');
        closeVideoModal();
        return;
    }
    
    if (player) player.destroy();
    
    player = new YT.Player('player', {
        height: '100%',
        width: '100%',
        videoId: videoId,
        playerVars: { 
            controls: 1,
            rel: 0,
            modestbranding: 1,
            disablekb: 0,
            fs: 1
        },
        events: { 
            onReady: onPlayerReady,
            onStateChange: onPlayerStateChange 
        }
    });
}

function extractYouTubeId(url) {
    // If it's already just the video ID (11 characters)
    if (url && url.length === 11 && !url.includes('/') && !url.includes('?')) {
        return url;
    }
    
    // Handle various YouTube URL formats
    const patterns = [
        /(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})/,           // watch?v=
        /(?:youtu\.be\/)([a-zA-Z0-9_-]{11})/,                       // youtu.be/
        /(?:youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,             // embed/
        /(?:youtube\.com\/v\/)([a-zA-Z0-9_-]{11})/,                 // v/
        /(?:youtube\.com\/.*[?&]v=)([a-zA-Z0-9_-]{11})/,            // any page with ?v=
        /^([a-zA-Z0-9_-]{11})$/                                      // just the ID
    ];
    
    for (let pattern of patterns) {
        const match = url.match(pattern);
        if (match && match[1]) {
            console.log('✅ Extracted video ID:', match[1], 'from URL:', url);
            return match[1];
        }
    }
    
    console.error('❌ Could not extract video ID from URL:', url);
    return null;
}

function onPlayerReady(event) {
    totalDuration = player.getDuration();
    document.getElementById('totalTime').innerText = formatTime(totalDuration);
    console.log('✅ Video ready. Duration:', totalDuration, 'seconds');
}

function onPlayerStateChange(event) {
    if (event.data === YT.PlayerState.PLAYING) {
        startTrackingProgress();
    } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
        stopTrackingProgress();
        if (event.data === YT.PlayerState.ENDED) {
            handleVideoComplete();
        }
    }
}

function startTrackingProgress() {
    if (progressInterval) return; // Already tracking
    
    progressInterval = setInterval(() => {
        if (!player || totalDuration === 0) return;
        
        const currentTime = player.getCurrentTime();
        watchedSeconds += 1; // Count actual seconds watched
        
        // Calculate percentages
        const seekPercent = Math.min(100, (currentTime / totalDuration) * 100);
        const actualPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        
        // Update UI
        updateWatchStatus(watchedSeconds, totalDuration, actualPercent);
        updateVideoCircle(currentCourseId, actualPercent);
        
        // Auto-save progress every 10% increment
        if (Math.floor(actualPercent / 10) > Math.floor(lastSavedProgress / 10)) {
            saveVideoProgress(actualPercent);
            lastSavedProgress = actualPercent;
        }
        
        console.log(`⏱️ Watched: ${actualPercent.toFixed(1)}% | Seek: ${seekPercent.toFixed(1)}%`);
        
    }, 1000); // Track every second
}

function stopTrackingProgress() {
    if (progressInterval) {
        clearInterval(progressInterval);
        progressInterval = null;
    }
}

function updateWatchStatus(watched, total, percent) {
    document.getElementById('timeWatched').innerText = formatTime(watched);
    document.getElementById('totalTime').innerText = formatTime(total);
    document.getElementById('completionPercent').innerText = Math.floor(percent) + '%';
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

function updateVideoCircle(courseId, percent) {
    const circle = document.querySelector(`#circle-${courseId} circle.progress`);
    const text = document.querySelector(`#circle-${courseId} .percent-text`);
    const circumference = 113; // 2πr where r=18
    const offset = circumference - (percent / 100) * circumference;
    
    if (circle) circle.style.strokeDashoffset = offset;
    if (text) text.innerText = Math.floor(percent) + '%';
}

function saveVideoProgress(percent) {
    if (!currentCourseId) return;
    
    const formData = new FormData();
    formData.append('courseId', currentCourseId);
    formData.append('watchPercent', percent);
    formData.append('action', 'update_video_watch');
    
    fetch('UpdateVideoProgressServlet', {
        method: 'POST',
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        console.log('✅ Progress saved:', data);
        // Update main progress bar if video is marked as REVIEWED
        if (data.videoStatus === 'REVIEWED') {
            updateMainProgressBar(currentCourseId, data.totalProgress);
        }
    })
    .catch(err => console.error('❌ Failed to save progress:', err));
}

function updateMainProgressBar(courseId, totalProgress) {
    const bar = document.getElementById('progress-bar-' + courseId);
    const text = document.getElementById('progress-text-' + courseId);
    
    if (bar) {
        bar.style.width = totalProgress + '%';
        if (totalProgress === 100) bar.classList.add('complete');
    }
    if (text) text.innerText = totalProgress + '% Completed';
    
    // Reload to show review button if 100%
    if (totalProgress === 100) {
        setTimeout(() => location.reload(), 1500);
    }
}

function handleVideoComplete() {
    const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
    console.log('🎬 Video ended. Final watch %:', finalPercent);
    
    if (finalPercent >= 90) {
        saveVideoProgress(100); // Mark as fully watched
        alert('🎉 Congratulations! You have completed this video.');
    } else {
        alert('⚠️ Please watch at least 90% of the video to earn progress credit.');
    }
}

function closeVideoModal() {
    stopTrackingProgress();
    
    // Save final progress
    if (watchedSeconds > 0 && totalDuration > 0) {
        const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        saveVideoProgress(finalPercent);
    }
    
    document.getElementById("videoModal").style.display = "none";
    if (player) {
        player.stopVideo();
        player.destroy();
        player = null;
    }
    
    // Reload progress after closing
    if (currentCourseId) {
        loadVideoProgress(currentCourseId);
    }
}

// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('videoModal');
    if (e.target === modal) {
        closeVideoModal();
    }
});
</script>  --%
<script>
let player;
let currentCourseId = null;
let watchedSeconds = 0;
let totalDuration = 0;
let progressInterval = null;
let lastSavedProgress = 0;
let startPosition = 0; // Resume position

// Load initial video progress for all courses
document.addEventListener('DOMContentLoaded', function() {
    // Attach video link click handlers
    document.querySelectorAll('.video-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const courseId = this.dataset.courseid;
            const title = this.dataset.title;
            const desc = this.dataset.desc;
            const videoLink = this.dataset.video;
            openVideoModal(courseId, title, desc, videoLink);
        });
    });
    
    // Load video progress for each course
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.dataset.courseid;
        loadVideoProgress(courseId);
    });
});

function loadVideoProgress(courseId) {
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            updateVideoCircle(courseId, data.videoWatchPercent || 0);
        })
        .catch(err => console.error('Failed to load video progress:', err));
}

function openVideoModal(courseId, title, desc, videoLink) {
    console.log('🎬 Opening video modal...');
    console.log('Course ID:', courseId);
    console.log('Video Link from database:', videoLink);
    
    currentCourseId = courseId;
    watchedSeconds = 0;
    lastSavedProgress = 0;
    startPosition = 0;
    
    document.getElementById("videoTitle").innerText = title;
    document.getElementById("videoDesc").innerText = desc;
    document.getElementById("videoModal").style.display = "flex";

    const videoId = extractYouTubeId(videoLink);
    console.log('Extracted Video ID:', videoId);
    
    if (!videoId) {
        alert('Invalid YouTube URL: ' + videoLink + '\n\nPlease check the video_link in your database.');
        closeVideoModal();
        return;
    }
    
    // Fetch saved progress before creating player
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            startPosition = data.lastPosition || 0;
            const savedPercent = data.videoWatchPercent || 0;
            
            console.log('📊 Loaded saved progress:', savedPercent + '%', 'Position:', startPosition + 's');
            
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1,
                    start: startPosition // Resume from last position
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, savedPercent);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        })
        .catch(err => {
            console.error('Failed to load progress:', err);
            // Create player anyway without resume
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, 0);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        });
}

function extractYouTubeId(url) {
    // If it's already just the video ID (11 characters)
    if (url && url.length === 11 && !url.includes('/') && !url.includes('?')) {
        return url;
    }
    
    // Handle various YouTube URL formats
    const patterns = [
        /(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})/,
        /(?:youtu\.be\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/v\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/.*[?&]v=)([a-zA-Z0-9_-]{11})/,
        /^([a-zA-Z0-9_-]{11})$/
    ];
    
    for (let pattern of patterns) {
        const match = url.match(pattern);
        if (match && match[1]) {
            console.log('✅ Extracted video ID:', match[1], 'from URL:', url);
            return match[1];
        }
    }
    
    console.error('❌ Could not extract video ID from URL:', url);
    return null;
}

function onPlayerReady(event, savedPercent) {
    totalDuration = player.getDuration();
    document.getElementById('totalTime').innerText = formatTime(totalDuration);
    
    // Initialize watched seconds based on saved progress
    watchedSeconds = Math.floor((savedPercent / 100) * totalDuration);
    
    // Update initial UI
    updateWatchStatus(watchedSeconds, totalDuration, savedPercent);
    
    console.log('✅ Video ready. Duration:', totalDuration, 'seconds');
    console.log('📍 Resuming from:', startPosition, 's (', savedPercent, '% watched)');
}

function onPlayerStateChange(event) {
    if (event.data === YT.PlayerState.PLAYING) {
        startTrackingProgress();
    } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
        stopTrackingProgress();
        if (event.data === YT.PlayerState.ENDED) {
            handleVideoComplete();
        }
    }
}

function startTrackingProgress() {
    if (progressInterval) return; // Already tracking
    
    progressInterval = setInterval(() => {
        if (!player || totalDuration === 0) return;
        
        const currentTime = player.getCurrentTime();
        watchedSeconds += 1; // Count actual seconds watched
        
        // Calculate percentages
        const actualPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        
        // Update UI
        updateWatchStatus(watchedSeconds, totalDuration, actualPercent);
        updateVideoCircle(currentCourseId, actualPercent);
        
        // Auto-save progress every 10 seconds
        if (watchedSeconds % 10 === 0) {
            saveVideoProgress(actualPercent, Math.floor(currentTime));
            lastSavedProgress = actualPercent;
        }
        
        console.log(`⏱️ Watched: ${actualPercent.toFixed(1)}% | Position: ${Math.floor(currentTime)}s`);
        
    }, 1000); // Track every second
}

function stopTrackingProgress() {
    if (progressInterval) {
        clearInterval(progressInterval);
        progressInterval = null;
    }
}

function updateWatchStatus(watched, total, percent) {
    document.getElementById('timeWatched').innerText = formatTime(watched);
    document.getElementById('totalTime').innerText = formatTime(total);
    document.getElementById('completionPercent').innerText = Math.floor(percent) + '%';
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

function updateVideoCircle(courseId, percent) {
    const circle = document.querySelector(`#circle-${courseId} circle.progress`);
    const text = document.querySelector(`#circle-${courseId} .percent-text`);
    const circumference = 113; // 2πr where r=18
    const offset = circumference - (percent / 100) * circumference;
    
    if (circle) circle.style.strokeDashoffset = offset;
    if (text) text.innerText = Math.floor(percent) + '%';
}

function saveVideoProgress(percent, currentPosition) {
    if (!currentCourseId) return;
    
    const formData = new FormData();
    formData.append('courseId', currentCourseId);
    formData.append('watchPercent', percent);
    formData.append('lastPosition', currentPosition);
    
    fetch('UpdateVideoProgressServlet', {
        method: 'POST',
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            console.log('✅ Progress saved:', data);
            // Update main progress bar if video is marked as REVIEWED
            if (data.videoStatus === 'REVIEWED') {
                updateMainProgressBar(currentCourseId, data.totalProgress);
            }
        } else {
            console.error('❌ Failed to save:', data.error);
        }
    })
    .catch(err => console.error('❌ Failed to save progress:', err));
}

function updateMainProgressBar(courseId, totalProgress) {
    const bar = document.getElementById('progress-bar-' + courseId);
    const text = document.getElementById('progress-text-' + courseId);
    
    if (bar) {
        bar.style.width = totalProgress + '%';
        if (totalProgress === 100) bar.classList.add('complete');
    }
    if (text) text.innerText = totalProgress + '% Completed';
    
    // Reload to show review button if 100%
    if (totalProgress === 100) {
        setTimeout(() => location.reload(), 1500);
    }
}

function handleVideoComplete() {
    const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
    console.log('🎬 Video ended. Final watch %:', finalPercent);
    
    if (finalPercent >= 90) {
        const currentTime = player ? Math.floor(player.getCurrentTime()) : Math.floor(totalDuration);
        saveVideoProgress(100, currentTime); // Mark as fully watched
        alert('🎉 Congratulations! You have completed this video.');
    } else {
        alert('⚠️ Please watch at least 90% of the video to earn progress credit.');
    }
}

function closeVideoModal() {
    stopTrackingProgress();
    
    // Save final progress when closing
    if (player && watchedSeconds > 0 && totalDuration > 0) {
        const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        const currentTime = Math.floor(player.getCurrentTime());
        saveVideoProgress(finalPercent, currentTime);
        console.log('💾 Saved on close: ' + finalPercent + '% at position ' + currentTime + 's');
    }
    
    document.getElementById("videoModal").style.display = "none";
    if (player) {
        player.stopVideo();
        player.destroy();
        player = null;
    }
    
    // Reload progress after closing
    if (currentCourseId) {
        setTimeout(() => loadVideoProgress(currentCourseId), 500);
    }
}

// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('videoModal');
    if (e.target === modal) {
        closeVideoModal();
    }
});


</script>

--%
<script>
let player;
let currentCourseId = null;
let watchedSeconds = 0;
let totalDuration = 0;
let progressInterval = null;
let lastSavedProgress = 0;
let startPosition = 0; // Resume position

// Load initial video progress for all courses
document.addEventListener('DOMContentLoaded', function() {
    console.log('🔧 DOM loaded, setting up video tracking...');
    
    // Attach video link click handlers
    document.querySelectorAll('.video-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const courseId = this.dataset.courseid;
            const title = this.dataset.title;
            const desc = this.dataset.desc;
            const videoLink = this.dataset.video;
            openVideoModal(courseId, title, desc, videoLink);
        });
    });
    
    // Load video progress for each course
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.dataset.courseid;
        loadVideoProgress(courseId);
    });
});

function loadVideoProgress(courseId) {
    console.log('🔍 Loading progress for course:', courseId);
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => {
            console.log('📡 Response status:', res.status);
            return res.json();
        })
        .then(data => {
            console.log('📊 Loaded progress data:', data);
            updateVideoCircle(courseId, data.videoWatchPercent || 0);
        })
        .catch(err => console.error('❌ Failed to load video progress:', err));
}

function openVideoModal(courseId, title, desc, videoLink) {
    console.log('🎬 Opening video modal...');
    console.log('Course ID:', courseId);
    console.log('Video Link from database:', videoLink);
    
    currentCourseId = courseId;
    watchedSeconds = 0;
    lastSavedProgress = 0;
    startPosition = 0;
    
    document.getElementById("videoTitle").innerText = title;
    document.getElementById("videoDesc").innerText = desc;
    document.getElementById("videoModal").style.display = "flex";

    const videoId = extractYouTubeId(videoLink);
    console.log('Extracted Video ID:', videoId);
    
    if (!videoId) {
        alert('Invalid YouTube URL: ' + videoLink + '\n\nPlease check the video_link in your database.');
        closeVideoModal();
        return;
    }
    
    // Fetch saved progress before creating player
    console.log('📡 Fetching saved progress for course:', courseId);
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            console.log('✅ Received progress data:', data);
            startPosition = data.lastPosition || 0;
            const savedPercent = data.videoWatchPercent || 0;
            
            console.log('📊 Loaded saved progress:', savedPercent + '%', 'Position:', startPosition + 's');
            
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1,
                    start: startPosition // Resume from last position
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, savedPercent);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        })
        .catch(err => {
            console.error('❌ Failed to load progress:', err);
            // Create player anyway without resume
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, 0);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        });
}

function extractYouTubeId(url) {
    // If it's already just the video ID (11 characters)
    if (url && url.length === 11 && !url.includes('/') && !url.includes('?')) {
        return url;
    }
    
    // Handle various YouTube URL formats
    const patterns = [
        /(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})/,
        /(?:youtu\.be\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/v\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/.*[?&]v=)([a-zA-Z0-9_-]{11})/,
        /^([a-zA-Z0-9_-]{11})$/
    ];
    
    for (let pattern of patterns) {
        const match = url.match(pattern);
        if (match && match[1]) {
            console.log('✅ Extracted video ID:', match[1], 'from URL:', url);
            return match[1];
        }
    }
    
    console.error('❌ Could not extract video ID from URL:', url);
    return null;
}

function onPlayerReady(event, savedPercent) {
    totalDuration = player.getDuration();
    document.getElementById('totalTime').innerText = formatTime(totalDuration);
    
    // Initialize watched seconds based on saved progress
    watchedSeconds = Math.floor((savedPercent / 100) * totalDuration);
    
    // Update initial UI
    updateWatchStatus(watchedSeconds, totalDuration, savedPercent);
    
    console.log('✅ Video ready. Duration:', totalDuration, 'seconds');
    console.log('📍 Resuming from:', startPosition, 's (', savedPercent, '% watched)');
    console.log('⏱️ Initial watchedSeconds:', watchedSeconds);
}

function onPlayerStateChange(event) {
    console.log('🎮 Player state changed:', event.data);
    if (event.data === YT.PlayerState.PLAYING) {
        console.log('▶️ Video started playing, tracking progress...');
        startTrackingProgress();
    } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
        console.log('⏸️ Video paused/ended, stopping tracking...');
        stopTrackingProgress();
        if (event.data === YT.PlayerState.ENDED) {
            handleVideoComplete();
        }
    }
}

function startTrackingProgress() {
    if (progressInterval) {
        console.log('⚠️ Already tracking progress');
        return; // Already tracking
    }
    
    console.log('🚀 Started tracking progress');
    
    progressInterval = setInterval(() => {
        if (!player || totalDuration === 0) return;
        
        // Get current time - with fallback
        let currentTime = 0;
        try {
            currentTime = player.getCurrentTime() || 0;
        } catch (e) {
            console.error('Error getting current time:', e);
            return;
        }
        
        watchedSeconds += 1; // Count actual seconds watched
        
        // Calculate percentages
        const actualPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        
        // Update UI
        updateWatchStatus(watchedSeconds, totalDuration, actualPercent);
        updateVideoCircle(currentCourseId, actualPercent);
        
        // Auto-save progress every 10 seconds
        if (watchedSeconds % 10 === 0) {
            const positionToSave = Math.floor(currentTime);
            console.log('💾 Auto-saving progress at ' + watchedSeconds + 's, position: ' + positionToSave + 's');
            saveVideoProgress(actualPercent, positionToSave);
            lastSavedProgress = actualPercent;
        }
        
        // Log every 5 seconds for debugging
        if (watchedSeconds % 5 === 0) {
            console.log(`⏱️ Watched: ${actualPercent.toFixed(1)}% | Position: ${Math.floor(currentTime)}s`);
        }
        
    }, 1000); // Track every second
}

function stopTrackingProgress() {
    if (progressInterval) {
        console.log('🛑 Stopped tracking progress');
        clearInterval(progressInterval);
        progressInterval = null;
    }
}

function updateWatchStatus(watched, total, percent) {
    document.getElementById('timeWatched').innerText = formatTime(watched);
    document.getElementById('totalTime').innerText = formatTime(total);
    document.getElementById('completionPercent').innerText = Math.floor(percent) + '%';
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

function updateVideoCircle(courseId, percent) {
    const circle = document.querySelector(`#circle-${courseId} circle.progress`);
    const text = document.querySelector(`#circle-${courseId} .percent-text`);
    const circumference = 113; // 2πr where r=18
    const offset = circumference - (percent / 100) * circumference;
    
    if (circle) circle.style.strokeDashoffset = offset;
    if (text) text.innerText = Math.floor(percent) + '%';
}

function saveVideoProgress(percent, currentPosition) {
    if (!currentCourseId) {
        console.error('❌ Cannot save: currentCourseId is null');
        return;
    }
    
    console.log('💾 Saving progress:', {
        courseId: currentCourseId,
        watchPercent: percent,
        lastPosition: currentPosition
    });
    
    const formData = new FormData();
    formData.append('courseId', currentCourseId);
    formData.append('watchPercent', percent);
    formData.append('lastPosition', currentPosition);
    
    console.log('📡 Sending to UpdateVideoProgressServlet...');
    
    fetch('UpdateVideoProgressServlet', {
        method: 'POST',
        body: formData
    })
    .then(res => {
        console.log('📡 Response status:', res.status);
        return res.text();
    })
    .then(text => {
        console.log('📡 Response text:', text);
        try {
            const data = JSON.parse(text);
            if (data.success) {
                console.log('✅ Progress saved successfully:', data);
                // Update main progress bar if video is marked as REVIEWED
                if (data.videoStatus === 'REVIEWED') {
                    console.log('🎉 Video marked as REVIEWED!');
                    updateMainProgressBar(currentCourseId, data.totalProgress);
                }
            } else {
                console.error('❌ Server returned error:', data.error);
                alert('Failed to save progress: ' + data.error);
            }
        } catch (e) {
            console.error('❌ Failed to parse JSON:', e);
            console.error('Response was:', text);
        }
    })
    .catch(err => {
        console.error('❌ Network error while saving progress:', err);
    });
}

function updateMainProgressBar(courseId, totalProgress) {
    const bar = document.getElementById('progress-bar-' + courseId);
    const text = document.getElementById('progress-text-' + courseId);
    
    if (bar) {
        bar.style.width = totalProgress + '%';
        if (totalProgress === 100) bar.classList.add('complete');
    }
    if (text) text.innerText = totalProgress + '% Completed';
    
    // Reload to show review button if 100%
    if (totalProgress === 100) {
        console.log('🎊 Course 100% complete! Reloading page...');
        setTimeout(() => location.reload(), 1500);
    }
}

function handleVideoComplete() {
    const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
    console.log('🎬 Video ended. Final watch %:', finalPercent);
    
    if (finalPercent >= 90) {
        const currentTime = player ? Math.floor(player.getCurrentTime()) : Math.floor(totalDuration);
        saveVideoProgress(100, currentTime); // Mark as fully watched
        alert('🎉 Congratulations! You have completed this video.');
    } else {
        alert('⚠️ Please watch at least 90% of the video to earn progress credit.');
    }
}

function closeVideoModal() {
    console.log('🚪 Closing video modal...');
    stopTrackingProgress();
    
    // Save final progress when closing
    if (player && watchedSeconds > 0 && totalDuration > 0) {
        const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        const currentTime = Math.floor(player.getCurrentTime());
        console.log('💾 Final save on close:', finalPercent + '% at position ' + currentTime + 's');
        saveVideoProgress(finalPercent, currentTime);
    }
    
    document.getElementById("videoModal").style.display = "none";
    if (player) {
        player.stopVideo();
        player.destroy();
        player = null;
    }
    
    // Reload progress after closing
    if (currentCourseId) {
        console.log('🔄 Reloading progress for course:', currentCourseId);
        setTimeout(() => loadVideoProgress(currentCourseId), 500);
    }
}

// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('videoModal');
    if (e.target === modal) {
        closeVideoModal();
    }
});</script>  --%

<script>
let player;
let currentCourseId = null;
let watchedSeconds = 0;
let totalDuration = 0;
let progressInterval = null;
let lastSavedProgress = 0;
let startPosition = 0; // Resume position

// Load initial video progress for all courses
document.addEventListener('DOMContentLoaded', function() {
    console.log('🔧 DOM loaded, setting up video tracking...');
    
    // Attach video link click handlers
    document.querySelectorAll('.video-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const courseId = this.dataset.courseid;
            const title = this.dataset.title;
            const desc = this.dataset.desc;
            const videoLink = this.dataset.video;
            openVideoModal(courseId, title, desc, videoLink);
        });
    });
    
    // Load video progress for each course
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.dataset.courseid;
        loadVideoProgress(courseId);
    });
});

function loadVideoProgress(courseId) {
    console.log('🔍 Loading progress for course:', courseId);
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => {
            console.log('📡 Response status:', res.status);
            return res.json();
        })
        .then(data => {
            console.log('📊 Loaded progress data:', data);
            updateVideoCircle(courseId, data.videoWatchPercent || 0);
        })
        .catch(err => console.error('❌ Failed to load video progress:', err));
}

function openVideoModal(courseId, title, desc, videoLink) {
    console.log('🎬 Opening video modal...');
    console.log('Course ID:', courseId);
    console.log('Video Link from database:', videoLink);
    
    currentCourseId = courseId;
    watchedSeconds = 0;
    lastSavedProgress = 0;
    startPosition = 0;
    
    document.getElementById("videoTitle").innerText = title;
    document.getElementById("videoDesc").innerText = desc;
    document.getElementById("videoModal").style.display = "flex";

    const videoId = extractYouTubeId(videoLink);
    console.log('Extracted Video ID:', videoId);
    
    if (!videoId) {
        alert('Invalid YouTube URL: ' + videoLink + '\n\nPlease check the video_link in your database.');
        closeVideoModal();
        return;
    }
    
    // Fetch saved progress before creating player
    console.log('📡 Fetching saved progress for course:', courseId);
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            console.log('✅ Received progress data:', data);
            startPosition = data.lastPosition || 0;
            const savedPercent = data.videoWatchPercent || 0;
            
            console.log('📊 Loaded saved progress:', savedPercent + '%', 'Position:', startPosition + 's');
            
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1,
                    start: startPosition // Resume from last position
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, savedPercent);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        })
        .catch(err => {
            console.error('❌ Failed to load progress:', err);
            // Create player anyway without resume
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, 0);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        });
}

function extractYouTubeId(url) {
    // If it's already just the video ID (11 characters)
    if (url && url.length === 11 && !url.includes('/') && !url.includes('?')) {
        return url;
    }
    
    // Handle various YouTube URL formats
    const patterns = [
        /(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})/,
        /(?:youtu\.be\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/v\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/.*[?&]v=)([a-zA-Z0-9_-]{11})/,
        /^([a-zA-Z0-9_-]{11})$/
    ];
    
    for (let pattern of patterns) {
        const match = url.match(pattern);
        if (match && match[1]) {
            console.log('✅ Extracted video ID:', match[1], 'from URL:', url);
            return match[1];
        }
    }
    
    console.error('❌ Could not extract video ID from URL:', url);
    return null;
}

function onPlayerReady(event, savedPercent) {
    totalDuration = player.getDuration();
    document.getElementById('totalTime').innerText = formatTime(totalDuration);
    
    // Initialize watched seconds based on saved progress
    watchedSeconds = Math.floor((savedPercent / 100) * totalDuration);
    
    // Update initial UI
    updateWatchStatus(watchedSeconds, totalDuration, savedPercent);
    
    console.log('✅ Video ready. Duration:', totalDuration, 'seconds');
    console.log('📍 Resuming from:', startPosition, 's (', savedPercent, '% watched)');
    console.log('⏱️ Initial watchedSeconds:', watchedSeconds);
}

function onPlayerStateChange(event) {
    console.log('🎮 Player state changed:', event.data);
    if (event.data === YT.PlayerState.PLAYING) {
        console.log('▶️ Video started playing, tracking progress...');
        startTrackingProgress();
    } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
        console.log('⏸️ Video paused/ended, stopping tracking...');
        stopTrackingProgress();
        if (event.data === YT.PlayerState.ENDED) {
            handleVideoComplete();
        }
    }
}

function startTrackingProgress() {
    if (progressInterval) {
        console.log('⚠️ Already tracking progress');
        return; // Already tracking
    }
    
    console.log('🚀 Started tracking progress');
    
    progressInterval = setInterval(() => {
        if (!player || totalDuration === 0) return;
        
        // Get current time - with fallback
        let currentTime = 0;
        try {
            currentTime = player.getCurrentTime() || 0;
        } catch (e) {
            console.error('Error getting current time:', e);
            return;
        }
        
        watchedSeconds += 1; // Count actual seconds watched
        
        // Calculate percentages
        const actualPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        
        // Update UI
        updateWatchStatus(watchedSeconds, totalDuration, actualPercent);
        updateVideoCircle(currentCourseId, actualPercent);
        
        // Auto-save progress every 10 seconds
        if (watchedSeconds % 10 === 0) {
            const positionToSave = Math.floor(currentTime);
            console.log('💾 Auto-saving progress at ' + watchedSeconds + 's, position: ' + positionToSave + 's');
            saveVideoProgress(actualPercent, positionToSave);
            lastSavedProgress = actualPercent;
        }
        
        // Log every 5 seconds for debugging
        if (watchedSeconds % 5 === 0) {
            console.log(`⏱️ Watched: ${actualPercent.toFixed(1)}% | Position: ${Math.floor(currentTime)}s`);
        }
        
    }, 1000); // Track every second
}

function stopTrackingProgress() {
    if (progressInterval) {
        console.log('🛑 Stopped tracking progress');
        clearInterval(progressInterval);
        progressInterval = null;
    }
}

function updateWatchStatus(watched, total, percent) {
    document.getElementById('timeWatched').innerText = formatTime(watched);
    document.getElementById('totalTime').innerText = formatTime(total);
    document.getElementById('completionPercent').innerText = Math.floor(percent) + '%';
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

function updateVideoCircle(courseId, percent) {
    const circle = document.querySelector(`#circle-${courseId} circle.progress`);
    const text = document.querySelector(`#circle-${courseId} .percent-text`);
    const circumference = 113; // 2πr where r=18
    const offset = circumference - (percent / 100) * circumference;
    
    if (circle) circle.style.strokeDashoffset = offset;
    if (text) text.innerText = Math.floor(percent) + '%';
}

function saveVideoProgress(percent, currentPosition) {
    if (!currentCourseId) {
        console.error('❌ Cannot save: currentCourseId is null');
        return;
    }
    
    console.log('💾 Saving progress:', {
        courseId: currentCourseId,
        watchPercent: percent,
        lastPosition: currentPosition
    });
    
    const formData = new FormData();
    formData.append('courseId', currentCourseId);
    formData.append('watchPercent', percent);
    formData.append('lastPosition', currentPosition);
    
    console.log('📡 Sending to UpdateVideoProgressServlet...');
    
    fetch('UpdateVideoProgressServlet', {
        method: 'POST',
        body: formData
    })
    .then(res => {
        console.log('📡 Response status:', res.status);
        return res.text();
    })
    .then(text => {
        console.log('📡 Response text:', text);
        try {
            const data = JSON.parse(text);
            if (data.success) {
                console.log('✅ Progress saved successfully:', data);
                // Update main progress bar if video is marked as REVIEWED
                if (data.videoStatus === 'REVIEWED') {
                    console.log('🎉 Video marked as REVIEWED!');
                    updateMainProgressBar(currentCourseId, data.totalProgress);
                }
            } else {
                console.error('❌ Server returned error:', data.error);
                alert('Failed to save progress: ' + data.error);
            }
        } catch (e) {
            console.error('❌ Failed to parse JSON:', e);
            console.error('Response was:', text);
        }
    })
    .catch(err => {
        console.error('❌ Network error while saving progress:', err);
    });
}

function updateMainProgressBar(courseId, totalProgress) {
    const bar = document.getElementById('progress-bar-' + courseId);
    const text = document.getElementById('progress-text-' + courseId);
    
    if (bar) {
        bar.style.width = totalProgress + '%';
        if (totalProgress === 100) bar.classList.add('complete');
    }
    if (text) text.innerText = totalProgress + '% Completed';
    
    // Reload to show review button if 100%
    if (totalProgress === 100) {
        console.log('🎊 Course 100% complete! Reloading page...');
        setTimeout(() => location.reload(), 1500);
    }
}

function handleVideoComplete() {
    const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
    console.log('🎬 Video ended. Final watch %:', finalPercent);
    
    if (finalPercent >= 90) {
        const currentTime = player ? Math.floor(player.getCurrentTime()) : Math.floor(totalDuration);
        saveVideoProgress(100, currentTime); // Mark as fully watched
        alert('🎉 Congratulations! You have completed this video.');
    } else {
        alert('⚠️ Please watch at least 90% of the video to earn progress credit.');
    }
}

function closeVideoModal() {
    console.log('🚪 Closing video modal...');
    stopTrackingProgress();
    
    // Save final progress when closing
    if (player && watchedSeconds > 0 && totalDuration > 0) {
        const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        const currentTime = Math.floor(player.getCurrentTime());
        console.log('💾 Final save on close:', finalPercent + '% at position ' + currentTime + 's');
        saveVideoProgress(finalPercent, currentTime);
    }
    
    document.getElementById("videoModal").style.display = "none";
    if (player) {
        player.stopVideo();
        player.destroy();
        player = null;
    }
    
    // Reload progress after closing
    if (currentCourseId) {
        console.log('🔄 Reloading progress for course:', currentCourseId);
        setTimeout(() => loadVideoProgress(currentCourseId), 500);
    }
}

// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('videoModal');
    if (e.target === modal) {
        closeVideoModal();
    }
});</script>  --%

updation worked here
<%-- --%
<script>
let player;
let currentCourseId = null;
let watchedSeconds = 0;
let totalDuration = 0;
let progressInterval = null;
let lastSavedProgress = 0;
let startPosition = 0; // Resume position

// Load initial video progress for all courses
document.addEventListener('DOMContentLoaded', function() {
    console.log('🔧 DOM loaded, setting up video tracking...');
    
    // Attach video link click handlers
    document.querySelectorAll('.video-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const courseId = this.dataset.courseid;
            const title = this.dataset.title;
            const desc = this.dataset.desc;
            const videoLink = this.dataset.video;
            openVideoModal(courseId, title, desc, videoLink);
        });
    });
    
    // Load video progress for each course
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.dataset.courseid;
        loadVideoProgress(courseId);
    });
});

function loadVideoProgress(courseId) {
    console.log('🔍 Loading progress for course:', courseId);
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => {
            console.log('📡 Response status:', res.status);
            return res.json();
        })
        .then(data => {
            console.log('📊 Loaded progress data:', data);
            updateVideoCircle(courseId, data.videoWatchPercent || 0);
        })
        .catch(err => console.error('❌ Failed to load video progress:', err));
}

function openVideoModal(courseId, title, desc, videoLink) {
    console.log('🎬 Opening video modal...');
    console.log('Course ID:', courseId);
    console.log('Video Link from database:', videoLink);
    
    currentCourseId = courseId;
    watchedSeconds = 0;
    lastSavedProgress = 0;
    startPosition = 0;
    
    document.getElementById("videoTitle").innerText = title;
    document.getElementById("videoDesc").innerText = desc;
    document.getElementById("videoModal").style.display = "flex";

    const videoId = extractYouTubeId(videoLink);
    console.log('Extracted Video ID:', videoId);
    
    if (!videoId) {
        alert('Invalid YouTube URL: ' + videoLink + '\n\nPlease check the video_link in your database.');
        closeVideoModal();
        return;
    }
    
    // Fetch saved progress before creating player
    console.log('📡 Fetching saved progress for course:', courseId);
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            console.log('✅ Received progress data:', data);
            startPosition = data.lastPosition || 0;
            const savedPercent = data.videoWatchPercent || 0;
            
            console.log('📊 Loaded saved progress:', savedPercent + '%', 'Position:', startPosition + 's');
            
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1,
                    start: startPosition // Resume from last position
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, savedPercent);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        })
        .catch(err => {
            console.error('❌ Failed to load progress:', err);
            // Create player anyway without resume
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, 0);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        });
}

function extractYouTubeId(url) {
    // If it's already just the video ID (11 characters)
    if (url && url.length === 11 && !url.includes('/') && !url.includes('?')) {
        return url;
    }
    
    // Handle various YouTube URL formats
    const patterns = [
        /(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})/,
        /(?:youtu\.be\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/v\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/.*[?&]v=)([a-zA-Z0-9_-]{11})/,
        /^([a-zA-Z0-9_-]{11})$/
    ];
    
    for (let pattern of patterns) {
        const match = url.match(pattern);
        if (match && match[1]) {
            console.log('✅ Extracted video ID:', match[1], 'from URL:', url);
            return match[1];
        }
    }
    
    console.error('❌ Could not extract video ID from URL:', url);
    return null;
}

function onPlayerReady(event, savedPercent) {
    totalDuration = player.getDuration();
    document.getElementById('totalTime').innerText = formatTime(totalDuration);
    
    // Initialize watched seconds based on saved progress
    watchedSeconds = Math.floor((savedPercent / 100) * totalDuration);
    
    // Update initial UI
    updateWatchStatus(watchedSeconds, totalDuration, savedPercent);
    
    console.log('✅ Video ready. Duration:', totalDuration, 'seconds');
    console.log('📍 Resuming from:', startPosition, 's (', savedPercent, '% watched)');
    console.log('⏱️ Initial watchedSeconds:', watchedSeconds);
}

function onPlayerStateChange(event) {
    console.log('🎮 Player state changed:', event.data);
    if (event.data === YT.PlayerState.PLAYING) {
        console.log('▶️ Video started playing, tracking progress...');
        startTrackingProgress();
    } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
        console.log('⏸️ Video paused/ended, stopping tracking...');
        stopTrackingProgress();
        if (event.data === YT.PlayerState.ENDED) {
            handleVideoComplete();
        }
    }
}

function startTrackingProgress() {
    if (progressInterval) {
        console.log('⚠️ Already tracking progress');
        return; // Already tracking
    }
    
    console.log('🚀 Started tracking progress');
    
    progressInterval = setInterval(() => {
        if (!player || totalDuration === 0) return;
        
        // Get current time - with fallback
        let currentTime = 0;
        try {
            currentTime = player.getCurrentTime() || 0;
        } catch (e) {
            console.error('Error getting current time:', e);
            return;
        }
        
        watchedSeconds += 1; // Count actual seconds watched
        
        // Calculate percentages
        const actualPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        
        // Update UI
        updateWatchStatus(watchedSeconds, totalDuration, actualPercent);
        updateVideoCircle(currentCourseId, actualPercent);
        
        // Auto-save progress every 10 seconds
        if (watchedSeconds % 10 === 0) {
            const positionToSave = Math.floor(currentTime);
            console.log('💾 Auto-saving progress at ' + watchedSeconds + 's, position: ' + positionToSave + 's');
            saveVideoProgress(actualPercent, positionToSave);
            lastSavedProgress = actualPercent;
        }
        
        // Log every 5 seconds for debugging
        if (watchedSeconds % 5 === 0) {
            console.log(`⏱️ Watched: ${actualPercent.toFixed(1)}% | Position: ${Math.floor(currentTime)}s`);
        }
        
    }, 1000); // Track every second
}

function stopTrackingProgress() {
    if (progressInterval) {
        console.log('🛑 Stopped tracking progress');
        clearInterval(progressInterval);
        progressInterval = null;
    }
}

function updateWatchStatus(watched, total, percent) {
    document.getElementById('timeWatched').innerText = formatTime(watched);
    document.getElementById('totalTime').innerText = formatTime(total);
    document.getElementById('completionPercent').innerText = Math.floor(percent) + '%';
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

function updateVideoCircle(courseId, percent) {
    const circle = document.querySelector(`#circle-${courseId} circle.progress`);
    const text = document.querySelector(`#circle-${courseId} .percent-text`);
    const circumference = 113; // 2πr where r=18
    const offset = circumference - (percent / 100) * circumference;
    
    if (circle) circle.style.strokeDashoffset = offset;
    if (text) text.innerText = Math.floor(percent) + '%';
}

function saveVideoProgress(percent, currentPosition) {
    if (!currentCourseId) {
        console.error('❌ Cannot save: currentCourseId is null');
        return;
    }
    
    // Validate parameters
    if (percent === undefined || percent === null || isNaN(percent)) {
        console.error('❌ Invalid percent:', percent);
        return;
    }
    
    if (currentPosition === undefined || currentPosition === null || isNaN(currentPosition)) {
        console.error('❌ Invalid currentPosition:', currentPosition);
        currentPosition = 0; // Fallback
    }
    
    console.log('💾 Saving progress:', {
        courseId: currentCourseId,
        watchPercent: percent,
        lastPosition: currentPosition
    });
    
    // Use URLSearchParams instead of FormData for better compatibility
    const params = new URLSearchParams();
    params.append('courseId', String(currentCourseId));
    params.append('watchPercent', String(percent));
    params.append('lastPosition', String(currentPosition));
    
    // Debug: log what we're sending
    console.log('📦 Request parameters:');
    console.log('  courseId: ' + currentCourseId);
    console.log('  watchPercent: ' + percent);
    console.log('  lastPosition: ' + currentPosition);
    console.log('📦 URL params string:', params.toString());
    
    console.log('📡 Sending to UpdateVideoProgressServlet...');
    
    fetch('UpdateVideoProgressServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(res => {
        console.log('📡 Response status:', res.status);
        return res.text();
    })
    .then(text => {
        console.log('📡 Response text:', text);
        try {
            const data = JSON.parse(text);
            if (data.success) {
                console.log('✅ Progress saved successfully:', data);
                // Update main progress bar if video is marked as REVIEWED
                if (data.videoStatus === 'REVIEWED') {
                    console.log('🎉 Video marked as REVIEWED!');
                    updateMainProgressBar(currentCourseId, data.totalProgress);
                }
            } else {
                console.error('❌ Server returned error:', data.error);
            }
        } catch (e) {
            console.error('❌ Failed to parse JSON:', e);
            console.error('Response was:', text);
        }
    })
    .catch(err => {
        console.error('❌ Network error while saving progress:', err);
    });
}

function updateMainProgressBar(courseId, totalProgress) {
    const bar = document.getElementById('progress-bar-' + courseId);
    const text = document.getElementById('progress-text-' + courseId);
    
    if (bar) {
        bar.style.width = totalProgress + '%';
        if (totalProgress === 100) bar.classList.add('complete');
    }
    if (text) text.innerText = totalProgress + '% Completed';
    
    // Reload to show review button if 100%
    if (totalProgress === 100) {
        console.log('🎊 Course 100% complete! Reloading page...');
        setTimeout(() => location.reload(), 1500);
    }
}

function handleVideoComplete() {
    const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
    console.log('🎬 Video ended. Final watch %:', finalPercent);
    
    if (finalPercent >= 90) {
        const currentTime = player ? Math.floor(player.getCurrentTime()) : Math.floor(totalDuration);
        saveVideoProgress(100, currentTime); // Mark as fully watched
        alert('🎉 Congratulations! You have completed this video.');
    } else {
        alert('⚠️ Please watch at least 90% of the video to earn progress credit.');
    }
}

function closeVideoModal() {
    console.log('🚪 Closing video modal...');
    stopTrackingProgress();
    
    // Save final progress when closing
    if (player && watchedSeconds > 0 && totalDuration > 0) {
        const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        let currentTime = 0;
        try {
            currentTime = Math.floor(player.getCurrentTime() || 0);
        } catch (e) {
            console.warn('Could not get current time on close:', e);
            currentTime = watchedSeconds; // Use watched seconds as fallback
        }
        console.log('💾 Final save on close:', finalPercent + '% at position ' + currentTime + 's');
        saveVideoProgress(finalPercent, currentTime);
    }
    
    document.getElementById("videoModal").style.display = "none";
    if (player) {
        player.stopVideo();
        player.destroy();
        player = null;
    }
    
    // Reload progress after closing
    if (currentCourseId) {
        console.log('🔄 Reloading progress for course:', currentCourseId);
        setTimeout(() => loadVideoProgress(currentCourseId), 500);
    }
}

// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('videoModal');
    if (e.target === modal) {
        closeVideoModal();
    }
});</script>  --%

<script>
let player;
let currentCourseId = null;
let watchedSeconds = 0;
let totalDuration = 0;
let progressInterval = null;
let lastSavedProgress = 0;
let startPosition = 0; // Resume position

// Load initial video progress for all courses
document.addEventListener('DOMContentLoaded', function() {
    console.log('🔧 DOM loaded, setting up video tracking...');
    
    // Attach video link click handlers
    document.querySelectorAll('.video-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const courseId = this.dataset.courseid;
            const title = this.dataset.title;
            const desc = this.dataset.desc;
            const videoLink = this.dataset.video;
            openVideoModal(courseId, title, desc, videoLink);
        });
    });
    
    // Load video progress for each course
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.dataset.courseid;
        loadVideoProgress(courseId);
    });
});

function loadVideoProgress(courseId) {
    console.log('🔍 Loading progress for course:', courseId);
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => {
            console.log('📡 Response status:', res.status);
            return res.json();
        })
        .then(data => {
            console.log('📊 Loaded progress data:', data);
            updateVideoCircle(courseId, data.videoWatchPercent || 0);
        })
        .catch(err => console.error('❌ Failed to load video progress:', err));
}

function openVideoModal(courseId, title, desc, videoLink) {
    console.log('🎬 Opening video modal...');
    console.log('Course ID:', courseId);
    console.log('Video Link from database:', videoLink);
    
    currentCourseId = courseId;
    watchedSeconds = 0;
    lastSavedProgress = 0;
    startPosition = 0;
    
    document.getElementById("videoTitle").innerText = title;
    document.getElementById("videoDesc").innerText = desc;
    document.getElementById("videoModal").style.display = "flex";

    const videoId = extractYouTubeId(videoLink);
    console.log('Extracted Video ID:', videoId);
    
    if (!videoId) {
        alert('Invalid YouTube URL: ' + videoLink + '\n\nPlease check the video_link in your database.');
        closeVideoModal();
        return;
    }
    
    // Fetch saved progress before creating player
    console.log('📡 Fetching saved progress for course:', courseId);
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            console.log('✅ Received progress data:', data);
            startPosition = data.lastPosition || 0;
            const savedPercent = data.videoWatchPercent || 0;
            
            console.log('📊 Loaded saved progress:', savedPercent + '%', 'Position:', startPosition + 's');
            
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1,
                    start: startPosition // Resume from last position
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, savedPercent);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        })
        .catch(err => {
            console.error('❌ Failed to load progress:', err);
            // Create player anyway without resume
            if (player) player.destroy();
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    fs: 1
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, 0);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        });
}

function extractYouTubeId(url) {
    // If it's already just the video ID (11 characters)
    if (url && url.length === 11 && !url.includes('/') && !url.includes('?')) {
        return url;
    }
    
    // Handle various YouTube URL formats
    const patterns = [
        /(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})/,
        /(?:youtu\.be\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/v\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/.*[?&]v=)([a-zA-Z0-9_-]{11})/,
        /^([a-zA-Z0-9_-]{11})$/
    ];
    
    for (let pattern of patterns) {
        const match = url.match(pattern);
        if (match && match[1]) {
            console.log('✅ Extracted video ID:', match[1], 'from URL:', url);
            return match[1];
        }
    }
    
    console.error('❌ Could not extract video ID from URL:', url);
    return null;
}

function onPlayerReady(event, savedPercent) {
    totalDuration = player.getDuration();
    document.getElementById('totalTime').innerText = formatTime(totalDuration);
    
    // Initialize watched seconds based on saved progress
    watchedSeconds = Math.floor((savedPercent / 100) * totalDuration);
    
    // Update initial UI
    updateWatchStatus(watchedSeconds, totalDuration, savedPercent);
    
    console.log('✅ Video ready. Duration:', totalDuration, 'seconds');
    console.log('📍 Resuming from:', startPosition, 's (', savedPercent, '% watched)');
    console.log('⏱️ Initial watchedSeconds:', watchedSeconds);
}

function onPlayerStateChange(event) {
    console.log('🎮 Player state changed:', event.data);
    if (event.data === YT.PlayerState.PLAYING) {
        console.log('▶️ Video started playing, tracking progress...');
        startTrackingProgress();
    } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
        console.log('⏸️ Video paused/ended, stopping tracking...');
        stopTrackingProgress();
        if (event.data === YT.PlayerState.ENDED) {
            handleVideoComplete();
        }
    }
}

function startTrackingProgress() {
    if (progressInterval) {
        console.log('⚠️ Already tracking progress');
        return; // Already tracking
    }
    
    console.log('🚀 Started tracking progress');
    
    progressInterval = setInterval(() => {
        if (!player || totalDuration === 0) return;
        
        // Get current time - with fallback
        let currentTime = 0;
        try {
            currentTime = player.getCurrentTime() || 0;
        } catch (e) {
            console.error('Error getting current time:', e);
            return;
        }
        
        watchedSeconds += 1; // Count actual seconds watched
        
        // Calculate percentages
        const actualPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        
        // Update UI
        updateWatchStatus(watchedSeconds, totalDuration, actualPercent);
        updateVideoCircle(currentCourseId, actualPercent);
        
        // Auto-save progress every 10 seconds
        if (watchedSeconds % 10 === 0) {
            const positionToSave = Math.floor(currentTime);
            console.log('💾 Auto-saving progress at ' + watchedSeconds + 's, position: ' + positionToSave + 's');
            saveVideoProgress(actualPercent, positionToSave);
            lastSavedProgress = actualPercent;
        }
        
        // Log every 5 seconds for debugging
        if (watchedSeconds % 5 === 0) {
            console.log(`⏱️ Watched: ${actualPercent.toFixed(1)}% | Position: ${Math.floor(currentTime)}s`);
        }
        
    }, 1000); // Track every second
}

function stopTrackingProgress() {
    if (progressInterval) {
        console.log('🛑 Stopped tracking progress');
        clearInterval(progressInterval);
        progressInterval = null;
    }
}

function updateWatchStatus(watched, total, percent) {
    document.getElementById('timeWatched').innerText = formatTime(watched);
    document.getElementById('totalTime').innerText = formatTime(total);
    document.getElementById('completionPercent').innerText = Math.floor(percent) + '%';
}

function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

function updateVideoCircle(courseId, percent) {
    const circleContainer = document.querySelector(`#circle-${courseId}`);
    const circle = document.querySelector(`#circle-${courseId} circle.progress`);
    const text = document.querySelector(`#circle-${courseId} .percent-text`);
    
    console.log(`🔵 Updating circle for course ${courseId}: ${percent.toFixed(2)}%`);
    console.log('  Circle container found:', !!circleContainer);
    console.log('  Progress circle found:', !!circle);
    console.log('  Text element found:', !!text);
    
    if (!circle || !text) {
        console.error(`❌ Circle elements not found for course ${courseId}`);
        return;
    }
    
    const circumference = 113; // 2πr where r=18
    const offset = circumference - (percent / 100) * circumference;
    
    circle.style.strokeDashoffset = offset;
    text.innerText = Math.floor(percent) + '%';
    
    console.log(`✅ Circle updated: offset=${offset.toFixed(2)}, text="${text.innerText}"`);
}

function saveVideoProgress(percent, currentPosition) {
    if (!currentCourseId) {
        console.error('❌ Cannot save: currentCourseId is null');
        return;
    }
    
    // Validate parameters
    if (percent === undefined || percent === null || isNaN(percent)) {
        console.error('❌ Invalid percent:', percent);
        return;
    }
    
    if (currentPosition === undefined || currentPosition === null || isNaN(currentPosition)) {
        console.error('❌ Invalid currentPosition:', currentPosition);
        currentPosition = 0; // Fallback
    }
    
    console.log('💾 Saving progress:', {
        courseId: currentCourseId,
        watchPercent: percent,
        lastPosition: currentPosition
    });
    
    // Use URLSearchParams instead of FormData for better compatibility
    const params = new URLSearchParams();
    params.append('courseId', String(currentCourseId));
    params.append('watchPercent', String(percent));
    params.append('lastPosition', String(currentPosition));
    
    // Debug: log what we're sending
    console.log('📦 Request parameters:');
    console.log('  courseId: ' + currentCourseId);
    console.log('  watchPercent: ' + percent);
    console.log('  lastPosition: ' + currentPosition);
    console.log('📦 URL params string:', params.toString());
    
    console.log('📡 Sending to UpdateVideoProgressServlet...');
    
    fetch('UpdateVideoProgressServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(res => {
        console.log('📡 Response status:', res.status);
        return res.text();
    })
    .then(text => {
        console.log('📡 Response text:', text);
        try {
            const data = JSON.parse(text);
            if (data.success) {
                console.log('✅ Progress saved successfully:', data);
                // Update main progress bar if video is marked as REVIEWED
                if (data.videoStatus === 'REVIEWED') {
                    console.log('🎉 Video marked as REVIEWED!');
                    updateMainProgressBar(currentCourseId, data.totalProgress);
                }
            } else {
                console.error('❌ Server returned error:', data.error);
            }
        } catch (e) {
            console.error('❌ Failed to parse JSON:', e);
            console.error('Response was:', text);
        }
    })
    .catch(err => {
        console.error('❌ Network error while saving progress:', err);
    });
}

function updateMainProgressBar(courseId, totalProgress) {
    const bar = document.getElementById('progress-bar-' + courseId);
    const text = document.getElementById('progress-text-' + courseId);
    
    if (bar) {
        bar.style.width = totalProgress + '%';
        if (totalProgress === 100) bar.classList.add('complete');
    }
    if (text) text.innerText = totalProgress + '% Completed';
    
    // Reload to show review button if 100%
    if (totalProgress === 100) {
        console.log('🎊 Course 100% complete! Reloading page...');
        setTimeout(() => location.reload(), 1500);
    }
}

function handleVideoComplete() {
    const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
    console.log('🎬 Video ended. Final watch %:', finalPercent);
    
    if (finalPercent >= 90) {
        const currentTime = player ? Math.floor(player.getCurrentTime()) : Math.floor(totalDuration);
        saveVideoProgress(100, currentTime); // Mark as fully watched
        alert('🎉 Congratulations! You have completed this video.');
    } else {
        alert('⚠️ Please watch at least 90% of the video to earn progress credit.');
    }
}

function closeVideoModal() {
    console.log('🚪 Closing video modal...');
    stopTrackingProgress();
    
    // Save final progress when closing
    if (player && watchedSeconds > 0 && totalDuration > 0) {
        const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        let currentTime = 0;
        try {
            currentTime = Math.floor(player.getCurrentTime() || 0);
        } catch (e) {
            console.warn('Could not get current time on close:', e);
            currentTime = watchedSeconds; // Use watched seconds as fallback
        }
        console.log('💾 Final save on close:', finalPercent + '% at position ' + currentTime + 's');
        saveVideoProgress(finalPercent, currentTime);
    }
    
    document.getElementById("videoModal").style.display = "none";
    if (player) {
        player.stopVideo();
        player.destroy();
        player = null;
    }
    
    // Reload progress after closing
    if (currentCourseId) {
        console.log('🔄 Reloading progress for course:', currentCourseId);
        setTimeout(() => loadVideoProgress(currentCourseId), 500);
    }
}

// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('videoModal');
    if (e.target === modal) {
        closeVideoModal();
    }
});</script> --%>
<!-- Replace the entire <script> section at the bottom of mycourses.jsp with this -->
<script>
let player;
let currentCourseId = null;
let watchedSeconds = 0;
let totalDuration = 0;
let progressInterval = null;
let lastSavedProgress = 0;
let startPosition = 0;
let isTracking = false;

// ========================================
// 1. INITIALIZE ON PAGE LOAD
// ========================================
document.addEventListener('DOMContentLoaded', function() {
    console.log('🔧 Initializing video progress tracking...');
    
    // Attach click handlers to video links
    document.querySelectorAll('.video-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const courseId = this.dataset.courseid;
            const title = this.dataset.title;
            const desc = this.dataset.desc;
            const videoLink = this.dataset.video;
            
            if (!videoLink || videoLink === 'null' || videoLink.trim() === '') {
                alert('❌ No video available for this course');
                return;
            }
            
            openVideoModal(courseId, title, desc, videoLink);
        });
    });
    
    // Load progress for all course cards
    document.querySelectorAll('.course-card').forEach(card => {
        const courseId = card.dataset.courseid;
        if (courseId) {
            loadVideoProgress(courseId);
        }
    });
    
    console.log('✅ Initialization complete');
});

// ========================================
// 2. LOAD VIDEO PROGRESS FROM SERVER
// ========================================
function loadVideoProgress(courseId) {
    console.log('📡 Loading progress for course:', courseId);
    
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(response => {
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            console.log('✅ Received data for course ' + courseId + ':', data);
            
            if (data.error) {
                console.error('❌ Server error:', data.error);
                return;
            }
            
            const percent = parseFloat(data.videoWatchPercent) || 0;
            console.log('🎯 Setting circle to ' + percent.toFixed(2) + '%');
            updateVideoCircle(courseId, percent);
        })
        .catch(error => {
            console.error('❌ Failed to load progress for course ' + courseId + ':', error);
        });
}

// ========================================
// 3. UPDATE CIRCULAR PROGRESS INDICATOR
// ========================================
function updateVideoCircle(courseId, percent) {
    const circleProgress = document.querySelector('#circle-' + courseId + ' circle.progress');
    const percentText = document.querySelector('#circle-' + courseId + ' .percent-text');
    
    if (!circleProgress || !percentText) {
        console.warn('⚠️ Circle elements not found for course ' + courseId);
        return;
    }
    
    // Circle with radius 18: circumference = 2πr = 2 * 3.14159 * 18 = 113.097
    const circumference = 113.097;
    const offset = circumference - (percent / 100) * circumference;
    
    // Update circle
    circleProgress.style.strokeDashoffset = offset;
    percentText.innerText = Math.floor(percent) + '%';
    
    // Change color based on progress
    if (percent >= 90) {
        circleProgress.style.stroke = '#4CAF50'; // Green
    } else if (percent >= 50) {
        circleProgress.style.stroke = '#FFC107'; // Yellow
    } else if (percent > 0) {
        circleProgress.style.stroke = '#2196F3'; // Blue
    }
    
    console.log('✅ Circle updated: ' + percent.toFixed(2) + '% (offset: ' + offset.toFixed(2) + ')');
}

// ========================================
// 4. OPEN VIDEO MODAL
// ========================================
function openVideoModal(courseId, title, desc, videoLink) {
    console.log('🎬 Opening video modal...');
    console.log('   Course ID:', courseId);
    console.log('   Video Link:', videoLink);
    
    currentCourseId = courseId;
    watchedSeconds = 0;
    lastSavedProgress = 0;
    startPosition = 0;
    isTracking = false;
    
    document.getElementById("videoTitle").innerText = title;
    document.getElementById("videoDesc").innerText = desc;
    document.getElementById("videoModal").style.display = "flex";

    const videoId = extractYouTubeId(videoLink);
    console.log('   YouTube ID:', videoId);
    
    if (!videoId) {
        alert('❌ Invalid YouTube URL: ' + videoLink);
        closeVideoModal();
        return;
    }
    
    // Fetch saved progress
    fetch('GetVideoProgressServlet?courseId=' + courseId)
        .then(res => res.json())
        .then(data => {
            console.log('✅ Progress loaded:', data);
            
            startPosition = data.lastPosition || 0;
            const savedPercent = data.videoWatchPercent || 0;
            
            console.log('   Resume from: ' + startPosition + 's (' + savedPercent + '%)');
            
            // Destroy existing player
            if (player) {
                try {
                    player.destroy();
                } catch (e) {
                    console.warn('Could not destroy player:', e);
                }
                player = null;
            }
            
            // Create YouTube player
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1,
                    start: startPosition
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, savedPercent);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        })
        .catch(err => {
            console.error('❌ Failed to load progress:', err);
            
            // Create player without resume
            if (player) {
                try {
                    player.destroy();
                } catch (e) {}
                player = null;
            }
            
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: videoId,
                playerVars: { 
                    controls: 1,
                    rel: 0,
                    modestbranding: 1
                },
                events: { 
                    onReady: function(event) {
                        onPlayerReady(event, 0);
                    },
                    onStateChange: onPlayerStateChange 
                }
            });
        });
}

// ========================================
// 5. EXTRACT YOUTUBE VIDEO ID
// ========================================
function extractYouTubeId(url) {
    if (!url) return null;
    
    url = url.trim();
    
    // If it's already just the video ID (11 chars, alphanumeric + _ -)
    if (/^[a-zA-Z0-9_-]{11}$/.test(url)) {
        return url;
    }
    
    // Various YouTube URL patterns
    const patterns = [
        /(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})/,
        /(?:youtu\.be\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,
        /(?:youtube\.com\/v\/)([a-zA-Z0-9_-]{11})/
    ];
    
    for (let pattern of patterns) {
        const match = url.match(pattern);
        if (match && match[1]) {
            console.log('✅ Extracted ID:', match[1]);
            return match[1];
        }
    }
    
    console.error('❌ Could not extract video ID from:', url);
    return null;
}

// ========================================
// 6. PLAYER READY EVENT
// ========================================
function onPlayerReady(event, savedPercent) {
    totalDuration = player.getDuration();
    document.getElementById('totalTime').innerText = formatTime(totalDuration);
    
    // Calculate watched seconds from saved percentage
    watchedSeconds = Math.floor((savedPercent / 100) * totalDuration);
    
    // Update UI
    updateWatchStatus(watchedSeconds, totalDuration, savedPercent);
    
    console.log('✅ Player ready');
    console.log('   Duration: ' + totalDuration + 's');
    console.log('   Previously watched: ' + watchedSeconds + 's (' + savedPercent + '%)');
}

// ========================================
// 7. PLAYER STATE CHANGE
// ========================================
function onPlayerStateChange(event) {
    if (event.data === YT.PlayerState.PLAYING) {
        console.log('▶️ Playing');
        startTrackingProgress();
    } else if (event.data === YT.PlayerState.PAUSED) {
        console.log('⏸️ Paused');
        stopTrackingProgress();
    } else if (event.data === YT.PlayerState.ENDED) {
        console.log('🏁 Ended');
        stopTrackingProgress();
        handleVideoComplete();
    }
}

// ========================================
// 8. START TRACKING PROGRESS
// ========================================
function startTrackingProgress() {
    if (isTracking) {
        return;
    }
    
    isTracking = true;
    console.log('🚀 Started tracking');
    
    progressInterval = setInterval(() => {
        if (!player || totalDuration === 0) return;
        
        try {
            const currentTime = player.getCurrentTime() || 0;
            
            // Increment watched time
            watchedSeconds += 1;
            
            // Don't exceed total duration
            if (watchedSeconds > totalDuration) {
                watchedSeconds = totalDuration;
            }
            
            // Calculate percentage
            const watchPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
            
            // Update UI
            updateWatchStatus(watchedSeconds, totalDuration, watchPercent);
            updateVideoCircle(currentCourseId, watchPercent);
            
            // Auto-save every 10 seconds
            if (watchedSeconds % 10 === 0) {
                const positionToSave = Math.floor(currentTime);
                console.log('💾 Auto-save: ' + watchPercent.toFixed(1) + '% at ' + positionToSave + 's');
                saveVideoProgress(watchPercent, positionToSave);
                lastSavedProgress = watchPercent;
            }
            
        } catch (e) {
            console.error('❌ Tracking error:', e);
        }
        
    }, 1000);
}

// ========================================
// 9. STOP TRACKING PROGRESS
// ========================================
function stopTrackingProgress() {
    if (!isTracking) return;
    
    isTracking = false;
    console.log('🛑 Stopped tracking');
    
    if (progressInterval) {
        clearInterval(progressInterval);
        progressInterval = null;
    }
}

// ========================================
// 10. UPDATE WATCH STATUS UI
// ========================================
function updateWatchStatus(watched, total, percent) {
    document.getElementById('timeWatched').innerText = formatTime(watched);
    document.getElementById('totalTime').innerText = formatTime(total);
    document.getElementById('completionPercent').innerText = Math.floor(percent) + '%';
}

// ========================================
// 11. FORMAT TIME (seconds to MM:SS)
// ========================================
function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return mins + ':' + (secs < 10 ? '0' : '') + secs;
}

// ========================================
// 12. SAVE VIDEO PROGRESS TO SERVER
// ========================================
function saveVideoProgress(percent, currentPosition) {
    if (!currentCourseId) {
        console.error('❌ No courseId');
        return;
    }
    
    if (isNaN(percent) || isNaN(currentPosition)) {
        console.error('❌ Invalid data:', { percent, currentPosition });
        return;
    }
    
    console.log('💾 Saving: ' + percent.toFixed(2) + '% at ' + currentPosition + 's');
    
    const params = new URLSearchParams();
    params.append('courseId', String(currentCourseId));
    params.append('watchPercent', String(percent));
    params.append('lastPosition', String(currentPosition));
    
    fetch('UpdateVideoProgressServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            console.log('✅ Saved successfully');
            
            // Update main progress bar if video marked as REVIEWED
            if (data.videoStatus === 'REVIEWED' && data.totalProgress !== undefined) {
                console.log('🎉 Video REVIEWED! Total progress: ' + data.totalProgress + '%');
                updateMainProgressBar(currentCourseId, data.totalProgress);
            }
        } else {
            console.error('❌ Save failed:', data.error);
        }
    })
    .catch(err => {
        console.error('❌ Network error:', err);
    });
}

// ========================================
// 13. UPDATE MAIN PROGRESS BAR
// ========================================
function updateMainProgressBar(courseId, totalProgress) {
    const bar = document.getElementById('progress-bar-' + courseId);
    const text = document.getElementById('progress-text-' + courseId);
    
    if (bar) {
        bar.style.width = totalProgress + '%';
        if (totalProgress === 100) {
            bar.classList.add('complete');
        }
    }
    
    if (text) {
        text.innerText = totalProgress + '% Completed';
    }
    
    // Reload page if 100% complete
    if (totalProgress === 100) {
        console.log('🎊 Course 100% complete!');
        setTimeout(() => location.reload(), 2000);
    }
}

// ========================================
// 14. HANDLE VIDEO COMPLETION
// ========================================
function handleVideoComplete() {
    const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
    console.log('🎬 Video ended. Final: ' + finalPercent.toFixed(2) + '%');
    
    if (finalPercent >= 90) {
        const currentTime = player ? Math.floor(player.getCurrentTime()) : Math.floor(totalDuration);
        saveVideoProgress(100, currentTime);
        alert('🎉 Congratulations! You completed this video.');
    } else {
        alert('⚠️ Please watch at least 90% of the video to earn credit.');
    }
}

// ========================================
// 15. CLOSE VIDEO MODAL
// ========================================
function closeVideoModal() {
    console.log('🚪 Closing modal...');
    stopTrackingProgress();
    
    // Final save before closing
    if (player && watchedSeconds > 0 && totalDuration > 0) {
        const finalPercent = Math.min(100, (watchedSeconds / totalDuration) * 100);
        let currentTime = 0;
        
        try {
            currentTime = Math.floor(player.getCurrentTime() || 0);
        } catch (e) {
            currentTime = watchedSeconds;
        }
        
        console.log('💾 Final save: ' + finalPercent.toFixed(2) + '% at ' + currentTime + 's');
        saveVideoProgress(finalPercent, currentTime);
    }
    
    // Hide modal
    document.getElementById("videoModal").style.display = "none";
    
    // Destroy player
    if (player) {
        try {
            player.stopVideo();
            player.destroy();
        } catch (e) {
            console.warn('Error destroying player:', e);
        }
        player = null;
    }
    
    // Reload circle progress
    if (currentCourseId) {
        setTimeout(() => {
            console.log('🔄 Reloading circle...');
            loadVideoProgress(currentCourseId);
        }, 500);
    }
    
    currentCourseId = null;
}

// ========================================
// 16. CLOSE ON OUTSIDE CLICK
// ========================================
document.addEventListener('click', function(e) {
    const modal = document.getElementById('videoModal');
    if (e.target === modal) {
        closeVideoModal();
    }
});
</script>
</body>
</html>








