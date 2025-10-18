<%-- <%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <title>Explore Courses</title>
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
            color:white;
        }
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 30px;
        }
        .course-card {
            background-color: #1f1f2e;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 255, 255, 0.1);
            margin: 15px;
            padding: 20px;
            width: 300px;
            text-align: center;
        }
        .course-card img {
            width: 100%;
            height: 180px;
            object-fit: contain;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 0px 20px rgba(0, 255, 255, 0.3);
        }
        .course-card h3 {
            color: #00bcd4;
            margin-top: 0;
        }
        .course-card p {
            color: #ccc;
        }
        .course-card a {
            display: block;
            margin: 5px 0;
            text-decoration: none;
            color: #66e0ff;
        }
        .course-card form {
            margin-top: 10px;
        }
        .btn-add {
            background-color: #28a745;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-add:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <h2>Aptitude Courses</h2>

    <div class="container">
        <%
            List<Course> courses = (List<Course>) request.getAttribute("courses");
            if (courses != null && !courses.isEmpty()) {
                for (Course course : courses) {
        %>
            <div class="course-card">
                <img src="<%= request.getContextPath() + "/" + course.getImage() %>" 
     alt="<%= course.getTitle() %>">

                <h3><%= course.getTitle() %></h3>
                <p><%= course.getDescription() %></p>
                <a href="<%= course.getDocumentLink() %>" target="_blank">
    <i class="fa fa-file-alt"></i> Document
</a>
<a href="<%= course.getVideoLink() %>" target="_blank">
    <i class="fa fa-video"></i> Video Lesson
</a>

             <!--     <form action="AddCourseServlet" method="post">
                    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                    <button class="btn-add" type="submit">Add to My Courses</button>
                </form>-->
                <form action="AddCourseServlet" method="post">
    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
    <button class="btn-add" type="submit">Add to My Courses</button>
</form>
                
            </div>
        <%
                }
            } else {
        %>
            <p style="color:white; text-align:center;">No courses found.</p>
        <%
            }
        %>
    </div>
</body>
</html>--%>


<%-- <%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: rgba(11, 11, 43, 0.925);
            margin: 0;
            padding: 0;
        }

        /* Section Titles */
        .course-section {
            margin: 40px 0;
            text-align: center;
        }
        .course-section h2 {
            color: white;
            margin-bottom: 20px;
        }

        /* Search bar */
        .search-bar {
            text-align: center;
            margin: 20px;
        }
        .search-bar input {
            width: 50%;
            padding: 10px;
            border-radius: 8px;
            border: none;
            font-size: 16px;
        }

        /* Course cards */
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 20px;
        }
        .course-card {
            background-color: #1f1f2e;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 255, 255, 0.1);
            margin: 15px;
            padding: 20px;
            width: 280px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .course-card img {
            width: 100%;
            height: 180px;
            object-fit: contain;
            background: #fff;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 0px 20px rgba(0, 255, 255, 0.3);
        }
        .course-card h3 {
            color: #00bcd4;
            margin-top: 0;
        }
        .course-card p {
            color: #ccc;
            font-size: 14px;
        }
        .course-card a {
            display: block;
            margin: 5px 0;
            text-decoration: none;
            color: #66e0ff;
            font-size: 14px;
        }
        .btn-add, .btn-details {
            background-color: #28a745;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .btn-add:hover, .btn-details:hover {
            background-color: #218838;
        }

        /* Details section */
        #courseDetails {
            display: none;
            justify-content: space-between;
            align-items: center;
            background: #222;
            margin: 30px;
            padding: 20px;
            border-radius: 10px;
        }
        .details-text {
            flex: 1;
            padding: 20px;
            color: white;
        }
        .details-img {
            flex: 1;
            text-align: center;
        }
        .details-img img {
            width: 90%;
            border-radius: 10px;
        }
    </style>
</head>
<body>

    <!-- Search -->
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Search courses by title...">
    </div>

    <!-- Aptitude Courses Section -->
    <section class="course-section">
        <h2>Aptitude Courses</h2>
        <div class="container">
            <%
                List<Course> courses = (List<Course>) request.getAttribute("courses");
                if (courses != null && !courses.isEmpty()) {
                    for (Course course : courses) {
            %>
                <div class="course-card">
                    <img src="<%= request.getContextPath() + "/" + course.getImage() %>" alt="<%= course.getTitle() %>">
                    <h3><%= course.getTitle() %></h3>
                    <p><%= course.getDescription() %></p>
                    <a href="<%= course.getDocumentLink() %>" target="_blank">
                        <i class="fa fa-file-alt"></i> Document
                    </a>
                    <a href="<%= course.getVideoLink() %>" target="_blank">
                        <i class="fa fa-video"></i> Video Lesson
                    </a>
                    <form action="AddCourseServlet" method="post">
                        <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                        <button class="btn-add" type="submit">Add to My Courses</button>
                    </form>
                    <button class="btn-details" onclick="showDetails('<%= course.getTitle() %>', '<%= course.getDescription() %>', '<%= request.getContextPath() + "/" + course.getImage() %>')">Course Details</button>
                </div>
            <%
                    }
                } else {
            %>
                <p style="color:white; text-align:center;">No courses found.</p>
            <%
                }
            %>
        </div>
    </section>

    <!-- Placeholder for Programming Section -->
    <section class="course-section">
        <h2>Programming Courses</h2>
        <div class="container">
            <div class="course-card"><h3>Course 1</h3></div>
            <div class="course-card"><h3>Course 2</h3></div>
            <div class="course-card"><h3>Course 3</h3></div>
            <div class="course-card"><h3>Course 4</h3></div>
        </div>
    </section>

    <!-- Course Details Section -->
    <div id="courseDetails">
        <div class="details-text">
            <h2 id="detailsTitle"></h2>
            <p id="detailsDesc"></p>
        </div>
        <div class="details-img">
            <img id="detailsImage" src="" alt="Course Image">
        </div>
    </div>

    <script>
        // Search filter
        document.getElementById("searchInput").addEventListener("keyup", function() {
            let filter = this.value.toLowerCase();
            let cards = document.getElementsByClassName("course-card");
            for (let card of cards) {
                let title = card.querySelector("h3").innerText.toLowerCase();
                card.style.display = title.includes(filter) ? "block" : "none";
            }
        });

        // Show details
        function showDetails(title, desc, img) {
            document.getElementById("detailsTitle").innerText = title;
            document.getElementById("detailsDesc").innerText = desc;
            document.getElementById("detailsImage").src = img;
            document.getElementById("courseDetails").style.display = "flex";
        }
    </script>

</body>
</html>
<%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: rgba(11, 11, 43, 0.925);
            margin: 0;
            padding: 0;
        }

        /* Section Titles */
        .course-section {
            margin: 40px 0;
            text-align: center;
        }
        .course-section h2 {
            color: white;
            margin-bottom: 20px;
        }

        /* Search bar */
        .search-bar {
            text-align: center;
            margin: 20px;
        }
        .search-bar input {
            width: 50%;
            padding: 10px;
            border-radius: 8px;
            border: none;
            font-size: 16px;
        }

        /* Course cards */
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 20px;
        }
        .course-card {
            background-color: #1f1f2e;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 255, 255, 0.1);
            margin: 15px;
            padding: 20px;
            width: 280px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .course-card img {
            width: 100%;
            height: 180px;
            object-fit: contain;
            background: #fff;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 0px 20px rgba(0, 255, 255, 0.3);
        }
        .course-card h3 {
            color: #00bcd4;
            margin-top: 0;
        }
        .course-card p {
            color: #ccc;
            font-size: 14px;
        }
        .course-card a {
            display: block;
            margin: 5px 0;
            text-decoration: none;
            color: #66e0ff;
            font-size: 14px;
        }
        .btn-add, .btn-details {
            background-color: #28a745;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .btn-add:hover, .btn-details:hover {
            background-color: #218838;
        }

        /* Details section */
        #courseDetails {
            display: none;
            justify-content: space-between;
            align-items: flex-start;
            background: #222;
            margin: 30px;
            padding: 20px;
            border-radius: 10px;
        }
        .details-text {
            flex: 1;
            padding: 20px;
            color: white;
        }
        .details-text a {
            display: inline-block;
            margin-top: 10px;
            margin-right: 15px;
            color: #66e0ff;
            text-decoration: none;
            font-size: 15px;
        }
        .details-text a:hover {
            text-decoration: underline;
        }
        .details-img {
            flex: 1;
            text-align: center;
        }
        .details-img img {
            width: 90%;
            border-radius: 10px;
        }
    </style>
</head>
<body>

    <!-- Search -->
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Search courses by title...">
    </div>

    <!-- Aptitude Courses Section -->
    <section class="course-section">
        <h2>Aptitude Courses</h2>
        <div class="container">
            <%
                List<Course> courses = (List<Course>) request.getAttribute("courses");
                if (courses != null && !courses.isEmpty()) {
                    for (Course course : courses) {
            %>
                <div class="course-card">
                    <img src="<%= request.getContextPath() + "/" + course.getImage() %>" alt="<%= course.getTitle() %>">
                    <h3><%= course.getTitle() %></h3>
                    <p><%= course.getDescription() %></p>
                    <form action="AddCourseServlet" method="post">
                        <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                        <button class="btn-add" type="submit">Add to My Courses</button>
                    </form>
                    <button class="btn-details" 
                        onclick="showDetails(
                            '<%= course.getTitle() %>', 
                            '<%= course.getDescription() %>', 
                            '<%= request.getContextPath() + "/" + course.getImage() %>',
                            '<%= course.getDocumentLink() %>',
                            '<%= course.getVideoLink() %>'
                        )">Course Details</button>
                </div>
            <%
                    }
                } else {
            %>
                <p style="color:white; text-align:center;">No courses found.</p>
            <%
                }
            %>
        </div>
    </section>

    <!-- Programming Section (placeholder) -->
    <section class="course-section">
        <h2>Programming Courses</h2>
        <div class="container">
            <div class="course-card"><h3>Course 1</h3></div>
            <div class="course-card"><h3>Course 2</h3></div>
            <div class="course-card"><h3>Course 3</h3></div>
            <div class="course-card"><h3>Course 4</h3></div>
        </div>
    </section>

    <!-- Course Details Section -->
    <div id="courseDetails">
        <div class="details-text">
            <h2 id="detailsTitle"></h2>
            <p id="detailsDesc"></p>
            <a id="detailsDoc" href="" target="_blank"><i class="fa fa-file-alt"></i> Document</a>
            <a id="detailsVid" href="" target="_blank"><i class="fa fa-video"></i> Video Lesson</a>
        </div>
        <div class="details-img">
            <img id="detailsImage" src="" alt="Course Image">
        </div>
    </div>

    <script>
        // Search filter
        document.getElementById("searchInput").addEventListener("keyup", function() {
            let filter = this.value.toLowerCase();
            let cards = document.getElementsByClassName("course-card");
            for (let card of cards) {
                let title = card.querySelector("h3").innerText.toLowerCase();
                card.style.display = title.includes(filter) ? "block" : "none";
            }
        });

        // Show details
        function showDetails(title, desc, img, doc, vid) {
            document.getElementById("detailsTitle").innerText = title;
            document.getElementById("detailsDesc").innerText = desc;
            document.getElementById("detailsImage").src = img;
            document.getElementById("detailsDoc").href = doc;
            document.getElementById("detailsVid").href = vid;
            document.getElementById("courseDetails").style.display = "flex";
        }
    </script>

</body>
</html>
<%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: rgba(11, 11, 43, 0.925);
            margin: 0;
            padding: 0;
        }

        /* Section Titles */
        .course-section {
            margin: 30px 0;
        }
        .course-section h2 {
            color: white;
            margin-left: 20px;
        }

        /* Horizontal scroll */
        .scroll-container {
            display: flex;
            overflow-x: auto;
            padding: 20px;
            gap: 20px;
        }
        .scroll-container::-webkit-scrollbar {
            height: 8px;
        }
        .scroll-container::-webkit-scrollbar-thumb {
            background: #444;
            border-radius: 5px;
        }

        /* Course card */
        .course-card {
            flex: 0 0 260px;
            background-color: #1f1f2e;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 255, 255, 0.1);
            padding: 15px;
            text-align: center;
        }
        .course-card img {
            width: 100%;
            height: 160px;
            object-fit: contain;
            background: #fff;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .course-card h3 {
            color: #00bcd4;
            margin: 10px 0;
        }
        .course-card p {
            color: #ccc;
            font-size: 14px;
        }
        .btn-add, .btn-details {
            background-color: #28a745;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .btn-add:hover, .btn-details:hover {
            background-color: #218838;
        }

        /* Modal overlay */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.8);
            justify-content: center;
            align-items: flex-start;
            padding: 40px;
            overflow-y: auto;
        }
        .modal-content {
            background: #222;
            border-radius: 12px;
            width: 90%;
            max-width: 1000px;
            display: flex;
            flex-direction: row;
            position: relative;
            padding: 20px;
        }
        .modal-close {
            position: absolute;
            top: 10px; right: 15px;
            font-size: 28px;
            color: white;
            cursor: pointer;
        }
        .details-img, .details-text {
            flex: 1;
            padding: 15px;
            color: white;
        }
        .details-img img {
            width: 100%;
            border-radius: 8px;
        }
        .details-text h2 {
            color: #00e5ff;
        }
        .doc-btn, .vid-btn {
            display: inline-block;
            margin: 10px 5px;
            padding: 8px 12px;
            border-radius: 5px;
            background: #007bff;
            color: white;
            text-decoration: none;
        }

        /* Reviews */
        .reviews-section {
            margin-top: 20px;
            background: #111;
            border-radius: 8px;
            padding: 10px;
            max-height: 200px;
            overflow-y: auto;
        }
        .review {
            border-bottom: 1px solid #333;
            padding: 8px 0;
            color: #ccc;
        }
        .review strong {
            color: #fff;
        }
        .stars {
            color: gold;
        }
        .review-form {
            margin-top: 15px;
        }
        .review-form textarea {
            width: 100%;
            padding: 8px;
            border-radius: 6px;
            border: none;
            resize: vertical;
            margin: 8px 0;
        }
        .review-form button {
            background: #28a745;
            border: none;
            padding: 8px 15px;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <!-- Aptitude Courses Section -->
    <section class="course-section">
        <h2>Aptitude Courses</h2>
        <div class="scroll-container">
            <%
                List<Course> courses = (List<Course>) request.getAttribute("courses");
                if (courses != null && !courses.isEmpty()) {
                    for (Course course : courses) {
            %>
                <div class="course-card">
                    <img src="<%= request.getContextPath() + "/" + course.getImage() %>" alt="<%= course.getTitle() %>">
                    <h3><%= course.getTitle() %></h3>
                    <p><%= course.getDescription() %></p>
                    <form action="AddCourseServlet" method="post">
                        <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                        <button class="btn-add" type="submit">Add to My Courses</button>
                    </form>
                    <button class="btn-details"
                        onclick="showDetails('<%= course.getCourseId() %>',
                                            '<%= course.getTitle() %>',
                                            '<%= course.getDescription() %>',
                                            '<%= course.getCourseDetails() %>',
                                            '<%= request.getContextPath() + "/" + course.getImage() %>',
                                            '<%= course.getDocumentLink() %>',
                                            '<%= course.getVideoLink() %>')">
                        Course Details
                    </button>
                </div>
            <%
                    }
                } else {
            %>
                <p style="color:white;">No courses found.</p>
            <%
                }
            %>
        </div>
        <hr>
        <!-- Repeat another 5 horizontally scrollable sections as needed -->
    </section>

    <!-- Modal -->
    <div id="courseModal" class="modal">
        <div class="modal-content">
            <span class="modal-close" onclick="closeModal()">&times;</span>
            <div class="details-img">
                <img id="modalImage" src="">
            </div>
            <div class="details-text">
                <h2 id="modalTitle"></h2>
                <p id="modalShort"></p>
                <p id="modalDetails"></p>
                <a id="modalDoc" class="doc-btn" target="_blank"><i class="fa fa-file-alt"></i> Document</a>
                <a id="modalVid" class="vid-btn" target="_blank"><i class="fa fa-video"></i> Video Lesson</a>
                <form action="AddCourseServlet" method="post">
                    <input type="hidden" id="modalCourseId" name="courseId">
                    <button class="btn-add" type="submit">Add to My Courses</button>
                </form>
                <!-- Reviews -->
                <div class="reviews-section" id="reviewsContainer">
                    <h3>Reviews</h3>
                    <!-- Reviews will be loaded here dynamically -->
                </div>
                <!-- Add Review Form -->
                <form class="review-form" action="AddReviewServlet" method="post">
                    <input type="hidden" id="reviewCourseId" name="courseId">
                    <label>Rate this course: </label>
                    <select name="rating">
                        <option value="5">⭐⭐⭐⭐⭐</option>
                        <option value="4">⭐⭐⭐⭐</option>
                        <option value="3">⭐⭐⭐</option>
                        <option value="2">⭐⭐</option>
                        <option value="1">⭐</option>
                    </select>
                    <textarea name="reviewText" placeholder="Write your review..."></textarea>
                    <button type="submit">Submit Review</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function showDetails(id, title, desc, details, img, doc, vid) {
            document.getElementById("modalTitle").innerText = title;
            document.getElementById("modalShort").innerText = desc;
            document.getElementById("modalDetails").innerText = details;
            document.getElementById("modalImage").src = img;
            document.getElementById("modalDoc").href = doc;
            document.getElementById("modalVid").href = vid;
            document.getElementById("modalCourseId").value = id;
            document.getElementById("reviewCourseId").value = id;
            document.getElementById("courseModal").style.display = "flex";

            // Fetch reviews dynamically via AJAX
            fetch('GetReviewsServlet?courseId=' + id)
                .then(res => res.json())
                .then(data => {
                    let reviewsHtml = "";
                    data.forEach(r => {
                        reviewsHtml += `
                          <div class="review">
                            <strong>${r.username}</strong> 
                            <span class="stars">${'⭐'.repeat(r.rating)}</span><br>
                            ${r.reviewText}
                          </div>`;
                    });
                    document.getElementById("reviewsContainer").innerHTML =
                        "<h3>Reviews</h3>" + reviewsHtml;
                });
        }
        function closeModal() {
            document.getElementById("courseModal").style.display = "none";
        }
    </script>

</body>
</html>
<%@ page import="java.util.*, Module2.Course, Module2.Review" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: rgba(11, 11, 43, 0.925);
            margin: 0;
            padding: 0;
        }

        /* Section Titles */
        .course-section {
            margin: 40px 0;
        }
        .course-section h2 {
            color: white;
            margin-left: 20px;
        }

        /* Search */
        .search-bar {
            text-align: center;
            margin: 20px;
        }
        .search-bar input {
            width: 50%;
            padding: 10px;
            border-radius: 8px;
            border: none;
            font-size: 16px;
        }

        /* Horizontal scroll row */
        .scroll-container {
            display: flex;
            overflow-x: auto;
            padding: 20px;
            gap: 15px;
        }
        .scroll-container::-webkit-scrollbar {
            height: 8px;
        }
        .scroll-container::-webkit-scrollbar-thumb {
            background: #555;
            border-radius: 10px;
        }

        /* Course Card */
        .course-card {
            background-color: #1f1f2e;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 255, 255, 0.1);
            flex: 0 0 250px;
            padding: 15px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 0px 20px rgba(0, 255, 255, 0.3);
        }
        .course-card img {
            width: 100%;
            height: 150px;
            object-fit: contain;
            background: #fff;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .course-card h3 {
            color: #00bcd4;
            margin-top: 0;
        }
        .course-card p {
            color: #ccc;
            font-size: 13px;
            height: 40px;
            overflow: hidden;
        }
        .course-card a {
            display: inline-block;
            margin: 3px;
            text-decoration: none;
            color: #66e0ff;
            font-size: 14px;
        }
        .btn-add, .btn-details {
            background-color: #28a745;
            color: white;
            padding: 7px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .btn-add:hover, .btn-details:hover {
            background-color: #218838;
        }

        /* Modal Overlay */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; right:0; bottom:0;
            background: rgba(0,0,0,0.8);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: #222;
            width: 80%;
            max-height: 90%;
            overflow-y: auto;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }
        .modal-header {
            display: flex;
            justify-content: flex-end;
        }
        .close-btn {
            color: white;
            font-size: 22px;
            cursor: pointer;
        }
        .modal-body {
            display: flex;
            gap: 20px;
            margin-top: 10px;
        }
        .details-img {
            flex: 1;
        }
        .details-img img {
            width: 100%;
            border-radius: 10px;
        }
        .details-text {
            flex: 1;
            color: white;
        }
        .details-text h2 {
            color: #00bcd4;
        }

        /* Reviews */
        .reviews {
            margin-top: 20px;
            background: #111;
            padding: 15px;
            border-radius: 10px;
            color: white;
        }
        .review-item {
            border-bottom: 1px solid #333;
            padding: 8px 0;
        }
        .review-item:last-child {
            border: none;
        }
        .review-stars {
            color: gold;
        }
        .review-form textarea {
            width: 100%;
            min-height: 60px;
            border-radius: 8px;
            border: none;
            padding: 8px;
        }
        .review-form button {
            background: #007bff;
            color: white;
            border: none;
            padding: 6px 12px;
            margin-top: 8px;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <!-- Search -->
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Search courses by title...">
    </div>

    <!-- Aptitude Section -->
    <section class="course-section">
        <h2>Aptitude Courses</h2>
        <%
            List<Course> courses = (List<Course>) request.getAttribute("courses");
            if (courses != null && !courses.isEmpty()) {
                for (int i = 0; i < courses.size(); i += 5) {
        %>
            <div class="scroll-container">
                <%
                    for (int j = i; j < i+5 && j < courses.size(); j++) {
                        Course c = courses.get(j);
                %>
                    <div class="course-card">
                        <img src="<%= request.getContextPath() + "/" + c.getImage() %>" alt="<%= c.getTitle() %>">
                        <h3><%= c.getTitle() %></h3>
                        <p><%= c.getDescription() %></p>
                        <a href="<%= c.getDocumentLink() %>" target="_blank"><i class="fa fa-file-alt"></i> Document</a>
                        <a href="<%= c.getVideoLink() %>" target="_blank"><i class="fa fa-video"></i> Video</a>
                        <form action="AddCourseServlet" method="post">
                            <input type="hidden" name="courseId" value="<%= c.getId() %>">
                            <button class="btn-add" type="submit">Add to My Courses</button>
                        </form>
                        <button class="btn-details" onclick="showDetails('<%= c.getId() %>', '<%= c.getTitle() %>', '<%= c.getDescription() %>', '<%= c.getCourseDetails() %>', '<%= request.getContextPath() + "/" + c.getImage() %>', '<%= c.getDocumentLink() %>', '<%= c.getVideoLink() %>')">Course Details</button>
                    </div>
                <%
                    }
                %>
            </div>
            <hr style="border-color:#444;">
        <%
                }
            } else {
        %>
            <p style="color:white; text-align:center;">No courses found.</p>
        <%
            }
        %>
    </section>

    <!-- Modal -->
    <div id="courseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <span class="close-btn" onclick="closeModal()">✖</span>
            </div>
            <div class="modal-body">
                <div class="details-img">
                    <img id="modalImage" src="">
                </div>
                <div class="details-text">
                    <h2 id="modalTitle"></h2>
                    <p id="modalDesc"></p>
                    <p id="modalDetails"></p>
                    <a id="modalDoc" href="#" target="_blank" class="btn-add"><i class="fa fa-file-alt"></i> Document</a>
                    <a id="modalVid" href="#" target="_blank" class="btn-add"><i class="fa fa-video"></i> Video</a>
                    <form action="AddCourseServlet" method="post">
                        <input type="hidden" id="modalCourseId" name="courseId">
                        <button type="submit" class="btn-add">Add to My Courses</button>
                    </form>
                </div>
            </div>
            <!-- Reviews -->
            <div class="reviews">
                <h3>Reviews</h3>
                <div id="reviewsList" style="max-height:150px; overflow-y:auto;"></div>
                <form action="AddReviewServlet" method="post" class="review-form">
                    <input type="hidden" name="courseId" id="reviewCourseId">
                    <label>Rating:</label>
                    <select name="rating">
                        <option value="5">⭐⭐⭐⭐⭐</option>
                        <option value="4">⭐⭐⭐⭐</option>
                        <option value="3">⭐⭐⭐</option>
                        <option value="2">⭐⭐</option>
                        <option value="1">⭐</option>
                    </select>
                    <textarea name="reviewText" placeholder="Write your review..."></textarea>
                    <button type="submit">Submit</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Search filter
        document.getElementById("searchInput").addEventListener("keyup", function() {
            let filter = this.value.toLowerCase();
            let cards = document.getElementsByClassName("course-card");
            for (let card of cards) {
                let title = card.querySelector("h3").innerText.toLowerCase();
                card.style.display = title.includes(filter) ? "block" : "none";
            }
        });

        // Show modal
        function showDetails(id, title, desc, details, img, doc, vid) {
            document.getElementById("modalCourseId").value = id;
            document.getElementById("reviewCourseId").value = id;
            document.getElementById("modalTitle").innerText = title;
            document.getElementById("modalDesc").innerText = desc;
            document.getElementById("modalDetails").innerText = details;
            document.getElementById("modalImage").src = img;
            document.getElementById("modalDoc").href = doc;
            document.getElementById("modalVid").href = vid;

            // Clear old reviews
            document.getElementById("reviewsList").innerHTML = "";

            // Fetch reviews via AJAX
            fetch("GetReviewsServlet?courseId=" + id)
                .then(res => res.json())
                .then(data => {
                    let reviewsHtml = "";
                    data.forEach(r => {
                        reviewsHtml += `
                          <div class="review-item">
                            <span class="review-stars">${"⭐".repeat(r.rating)}</span>
                            <strong>${r.username}</strong>: ${r.reviewText}
                          </div>`;
                    });
                    document.getElementById("reviewsList").innerHTML = reviewsHtml || "<p>No reviews yet.</p>";
                });

            document.getElementById("courseModal").style.display = "flex";
        }

        function closeModal() {
            document.getElementById("courseModal").style.display = "none";
        }
    </script>

</body>
</html>
<%@ page import="java.util.*, Module2.Course, Module2.Review" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #0b0b2b;
            margin: 0;
            padding: 0;
        }

        /* Section Titles */
        .course-section {
            margin: 40px 0;
        }
        .course-section h2 {
            color: #00e6e6;
            margin-left: 20px;
            font-size: 28px;
            border-left: 5px solid #00e6e6;
            padding-left: 10px;
        }

        /* Search */
        .search-bar {
            text-align: center;
            margin: 20px;
        }
        .search-bar input {
            width: 50%;
            padding: 12px;
            border-radius: 25px;
            border: none;
            font-size: 16px;
            outline: none;
        }

        /* Horizontal scroll row */
        .scroll-container {
            display: flex;
            overflow-x: auto;
            padding: 20px;
            gap: 15px;
        }
        .scroll-container::-webkit-scrollbar {
            height: 8px;
        }
        .scroll-container::-webkit-scrollbar-thumb {
            background: #00e6e6;
            border-radius: 10px;
        }

        /* Course Card */
        .course-card {
            background-color: #1f1f3d;
            border-radius: 12px;
            box-shadow: 0px 0px 15px rgba(0, 255, 255, 0.2);
            flex: 0 0 250px;
            padding: 15px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 0px 25px rgba(0, 255, 255, 0.5);
        }
        .course-card img {
            width: 100%;
            height: 150px;
            object-fit: contain;
            background: #fff;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .course-card h3 {
            color: #00e6e6;
            margin-top: 0;
        }
        .course-card p {
            color: #ccc;
            font-size: 13px;
            height: 40px;
            overflow: hidden;
        }
        .btn-add, .btn-details {
            background-color: #28a745;
            color: white;
            padding: 7px 12px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            margin: 5px;
            transition: 0.3s;
        }
        .btn-add:hover, .btn-details:hover {
            background-color: #1e7e34;
        }

        /* Modal Overlay */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; right:0; bottom:0;
            background: rgba(0,0,0,0.9);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: #1a1a3a;
            width: 85%;
            max-height: 95%;
            overflow-y: auto;
            border-radius: 12px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            animation: zoomIn 0.3s ease;
        }
        @keyframes zoomIn {
            from {transform: scale(0.8); opacity: 0;}
            to {transform: scale(1); opacity: 1;}
        }
        .modal-header {
            display: flex;
            justify-content: flex-end;
        }
        .close-btn {
            color: white;
            font-size: 24px;
            cursor: pointer;
        }
        .modal-body {
            display: flex;
            gap: 20px;
            margin-top: 10px;
            flex-wrap: wrap;
        }
        .details-img {
            flex: 1;
            min-width: 250px;
        }
        .details-img img {
            width: 100%;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0,255,255,0.3);
        }
        .details-text {
            flex: 2;
            color: white;
            min-width: 300px;
        }
        .details-text h2 {
            color: #00e6e6;
        }
        .details-text p {
            line-height: 1.6;
        }

        .syllabus {
            margin-top: 15px;
            background: #111;
            padding: 12px;
            border-radius: 10px;
            color: #eee;
        }
        .syllabus h4 {
            margin: 0 0 10px 0;
            color: #00e6e6;
        }
        .syllabus ul {
            margin: 0;
            padding: 0 20px;
        }

        /* Reviews */
        .reviews {
            margin-top: 20px;
            background: #111;
            padding: 15px;
            border-radius: 10px;
            color: white;
        }
        .review-item {
            border-bottom: 1px solid #333;
            padding: 8px 0;
        }
        .review-item:last-child {
            border: none;
        }
        .review-stars {
            color: gold;
        }
        .review-form textarea {
            width: 100%;
            min-height: 60px;
            border-radius: 8px;
            border: none;
            padding: 8px;
        }
        .review-form button {
            background: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            margin-top: 8px;
            border-radius: 25px;
            cursor: pointer;
            transition: 0.3s;
        }
        .review-form button:hover {
            background: #0056b3;
        }

        .btn-test {
            display: inline-block;
            margin-top: 10px;
            background: #ff9800;
            padding: 8px 15px;
            border-radius: 25px;
            color: white;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-test:hover {
            background: #e68900;
        }
    </style>
</head>
<body>

    <!-- Search -->
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="🔍 Search courses by title...">
    </div>

    <!-- Aptitude Section -->
    <section class="course-section">
        <h2>Aptitude Courses</h2>
        <%
            List<Course> courses = (List<Course>) request.getAttribute("courses");
            if (courses != null && !courses.isEmpty()) {
                for (int i = 0; i < courses.size(); i += 5) {
        %>
            <div class="scroll-container">
                <%
                    for (int j = i; j < i+5 && j < courses.size(); j++) {
                        Course c = courses.get(j);
                %>
                    <div class="course-card">
                        <img src="<%= request.getContextPath() + "/" + c.getImage() %>" alt="<%= c.getTitle() %>">
                        <h3><%= c.getTitle() %></h3>
                        <p><%= c.getDescription() %></p>
                        <a href="<%= c.getDocumentLink() %>" target="_blank"><i class="fa fa-file-alt"></i> Doc</a>
                        <a href="<%= c.getVideoLink() %>" target="_blank"><i class="fa fa-video"></i> Video</a>
                        <form action="AddCourseServlet" method="post">
                            <input type="hidden" name="courseId" value="<%= c.getId() %>">
                            <button class="btn-add" type="submit">+ My Courses</button>
                        </form>
                        <button class="btn-details" onclick="showDetails('<%= c.getId() %>', '<%= c.getTitle() %>', '<%= c.getDescription() %>', '<%= c.getSyllabus() %>', '<%= request.getContextPath() + "/" + c.getImage() %>', '<%= c.getDocumentLink() %>', '<%= c.getVideoLink() %>'')">Details</button>
                    </div>
                <%
                    }
                %>
            </div>
            <hr style="border-color:#444;">
        <%
                }
            } else {
        %>
            <p style="color:white; text-align:center;">No courses found.</p>
        <%
            }
        %>
    </section>

    <!-- Modal -->
    <div id="courseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <span class="close-btn" onclick="closeModal()">✖</span>
            </div>
            <div class="modal-body">
                <div class="details-img">
                    <img id="modalImage" src="">
                </div>
                <div class="details-text">
                    <h2 id="modalTitle"></h2>
                    <p id="modalDesc"></p>
                    <p id="modalDetails"></p>

                    <div class="syllabus">
                        <h4>Syllabus</h4>
                        <ul id="modalSyllabus"></ul>
                    </div>

                    <a id="modalDoc" href="#" target="_blank" class="btn-add"><i class="fa fa-file-alt"></i> Document</a>
                    <a id="modalVid" href="#" target="_blank" class="btn-add"><i class="fa fa-video"></i> Video</a>
                    <a id="modalTest" href="#" target="_blank" class="btn-test"><i class="fa fa-pencil-alt"></i> Take Test</a>

                    <form action="AddCourseServlet" method="post" style="margin-top:10px;">
                        <input type="hidden" id="modalCourseId" name="courseId">
                        <button type="submit" class="btn-add">+ My Courses</button>
                    </form>
                </div>
            </div>
            <!-- Reviews -->
            <div class="reviews">
                <h3>Reviews</h3>
                <div id="reviewsList" style="max-height:150px; overflow-y:auto;"></div>
                <form action="AddReviewServlet" method="post" class="review-form">
                    <input type="hidden" name="courseId" id="reviewCourseId">
                    <label>Rating:</label>
                    <select name="rating">
                        <option value="5">⭐⭐⭐⭐⭐</option>
                        <option value="4">⭐⭐⭐⭐</option>
                        <option value="3">⭐⭐⭐</option>
                        <option value="2">⭐⭐</option>
                        <option value="1">⭐</option>
                    </select>
                    <textarea name="reviewText" placeholder="Write your review..."></textarea>
                    <button type="submit">Submit Review</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Search filter
        document.getElementById("searchInput").addEventListener("keyup", function() {
            let filter = this.value.toLowerCase();
            let cards = document.getElementsByClassName("course-card");
            for (let card of cards) {
                let title = card.querySelector("h3").innerText.toLowerCase();
                card.style.display = title.includes(filter) ? "block" : "none";
            }
        });

        // Show modal
        function showDetails(id, title, desc, details, syllabus, img, doc, vid, test) {
            document.getElementById("modalCourseId").value = id;
            document.getElementById("reviewCourseId").value = id;
            document.getElementById("modalTitle").innerText = title;
            document.getElementById("modalDesc").innerText = desc;
            document.getElementById("modalDetails").innerText = details;
            document.getElementById("modalImage").src = img;
            document.getElementById("modalDoc").href = doc;
            document.getElementById("modalVid").href = vid;
            document.getElementById("modalTest").href = test;

            // Fill syllabus (comma-separated -> list items)
            let syllabusList = document.getElementById("modalSyllabus");
            syllabusList.innerHTML = "";
            if (syllabus) {
                syllabus.split(",").forEach(item => {
                    syllabusList.innerHTML += `<li>${item.trim()}</li>`;
                });
            } else {
                syllabusList.innerHTML = "<li>No syllabus available</li>";
            }

            // Clear old reviews
            document.getElementById("reviewsList").innerHTML = "";

            // Fetch reviews via AJAX
            fetch("GetReviewsServlet?courseId=" + id)
                .then(res => res.json())
                .then(data => {
                    let reviewsHtml = "";
                    data.forEach(r => {
                        reviewsHtml += `
                          <div class="review-item">
                            <span class="review-stars">${"⭐".repeat(r.rating)}</span>
                            <strong>${r.username}</strong>: ${r.reviewText}
                          </div>`;
                    });
                    document.getElementById("reviewsList").innerHTML = reviewsHtml || "<p>No reviews yet.</p>";
                });

            document.getElementById("courseModal").style.display = "flex";
        }

        function closeModal() {
            document.getElementById("courseModal").style.display = "none";
        }
    </script>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,Module2.Course" %>
<%@ include file="navbar.jsp" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #0a002b;
            color: white;
            margin: 0;
            padding: 0;
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 40px;
            background: #0a002b;
            color: #fff;
            font-size: 22px;
            font-weight: bold;
        }
        header nav a {
            color: white;
            margin-left: 20px;
            text-decoration: none;
        }
        .search-bar {
            display: flex;
            justify-content: center;
            margin: 20px;
        }
        .search-bar input {
            width: 50%;
            padding: 10px;
            border-radius: 30px;
            border: none;
            outline: none;
            font-size: 16px;
        }
        .course-container {
            display: grid;
            grid-template-columns: repeat(auto-fill,minmax(280px,1fr));
            gap: 20px;
            padding: 20px;
        }
        .course-card {
            background: #11134d;
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }
        .course-card img {
            width: 100%;
            height: 180px;
            border-radius: 10px;
            object-fit: cover;
        }
        .course-card h3 {
            margin: 10px 0;
            color: #00e0ff;
        }
        .course-card p {
            font-size: 14px;
            color: #ddd;
        }
        .btn {
            display: inline-block;
            padding: 8px 15px;
            background: green;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            margin-top: 10px;
            cursor: pointer;
        }
        .btn:hover {
            background: darkgreen;
        }
        .details-btn {
            background: #007bff;
            margin-left: 10px;
        }
        .details-btn:hover {
            background: #0056b3;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.7);
        }
        .modal-content {
            background: #fff;
            color: #000;
            margin: 3% auto;
            padding: 20px;
            border-radius: 12px;
            width: 70%;
            max-height: 85%;
            overflow-y: auto;
        }
        .modal-content h2 {
            color: #11134d;
        }
        .modal-content img {
            width: 100%;
            border-radius: 10px;
            margin-bottom: 15px;
        }
        .close {
            float: right;
            font-size: 28px;
            cursor: pointer;
            color: #333;
        }
        .reviews-box {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #ccc;
            padding: 10px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<header>
    
</header>

<div class="search-bar">
    <input type="text" id="searchInput" placeholder="🔍 Search courses by title..." onkeyup="filterCourses()">
</div>

<h2 style="margin-left:20px; color:#00e0ff;">| Aptitude Courses</h2>

<div class="course-container" id="courseContainer">
    <% if (courses != null) {
        for (Course course : courses) { %>
            <div class="course-card">
                <img src="<%=course.getImage()%>" alt="Course Image">
                <h3><%=course.getTitle()%></h3>
                <p><%=course.getDescription()%></p>
                <div>
                    <button class="btn" onclick="addCourse(<%=course.getId()%>)">+ My Courses</button>
                    <button class="btn details-btn"
                            onclick="openModal(
                                '<%=course.getId()%>',
                                '<%=course.getTitle().replace("'", "\\'")%>',
                                '<%=course.getDescription().replace("'", "\\'")%>',
                                '<%=course.getImage()%>',
                                '<%=course.getSyllabus().replace("'", "\\'")%>',
                                '<%=course.getDesign().replace("'", "\\'")%>',
                                '<%=course.getTopicsCovered().replace("'", "\\'")%>',
                                '<%=course.getTestDetails().replace("'", "\\'")%>'
                            )">
                        Details
                    </button>
                </div>
            </div>
    <%  } } %>
</div>

<!-- Modal -->
<div id="courseModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modalImage" src="" alt="Course Image">
    <h2 id="modalTitle"></h2>
    <p id="modalDescription"></p>

    <h3>Syllabus</h3>
    <p id="modalSyllabus"></p>

    <h3>Design</h3>
    <p id="modalDesign"></p>

    <h3>Topics Covered</h3>
    <p id="modalTopics"></p>

    <h3>Test Details</h3>
    <p id="modalTest"></p>

    <h3>⭐ Rating</h3>
    <p id="modalRating">(4.5 / 5)</p>

    <button id="addCourseBtn" class="btn">+ Add to My Courses</button>

    <h3>Reviews</h3>
    <div id="reviewsSection" class="reviews-box">
        <!-- Reviews will load dynamically -->
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
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    // Fetch reviews dynamically
    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => {
            document.getElementById("reviewsSection").innerHTML = data;
        });

    document.getElementById("courseModal").style.display = "block";

    // set button action
    document.getElementById("addCourseBtn").onclick = function() {
        addCourse(courseId);
    };
}

function closeModal() {
    document.getElementById("courseModal").style.display = "none";
}

function addCourse(courseId) {
    // simple redirect (or AJAX post if you prefer)
    window.location.href = "AddCourseServlet?courseId=" + courseId;
}
</script>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,Module2.Course" %>
<%@ include file="navbar.jsp" %>
<%
    List<Course> aptitudeCourses = (List<Course>) request.getAttribute("aptitudeCourses");
    List<Course> programmingCourses = (List<Course>) request.getAttribute("programmingCourses");
    List<Course> logicalCourses = (List<Course>) request.getAttribute("logicalCourses");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #0a002b;
            color: white;
            margin: 0;
            padding: 0;
        }

        /* Search Bar */
        .search-bar {
            display: flex;
            justify-content: center;
            margin: 20px;
        }
        .search-bar input {
            width: 50%;
            padding: 12px 20px;
            border-radius: 30px;
            border: none;
            outline: none;
            font-size: 16px;
            background: #11134d;
            color: white;
        }

        /* Section */
        .course-section {
            margin: 20px;
        }
        .course-section h2 {
            color: #00e0ff;
            margin-bottom: 10px;
        }

        /* Horizontal scroll container */
        .course-scroll {
            display: flex;
            overflow-x: auto;
            gap: 20px;
            padding-bottom: 10px;
        }
        .course-scroll::-webkit-scrollbar {
            height: 8px;
        }
        .course-scroll::-webkit-scrollbar-thumb {
            background: #555;
            border-radius: 4px;
        }
        .course-scroll::-webkit-scrollbar-track {
            background: #222;
        }

        /* Course Card */
        .course-card {
            min-width: 250px;
            background: #11134d;
            border-radius: 12px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            flex-shrink: 0;
            transition: transform 0.3s;
        }
        .course-card:hover {
            transform: translateY(-5px);
        }
        .course-card img {
            width: 100%;
            height: 150px;
            border-radius: 10px;
            object-fit: cover;
        }
        .course-card h3 {
            margin: 10px 0;
            color: #00e0ff;
        }
        .course-card p {
            font-size: 14px;
            color: #ddd;
        }
        .course-card .btn {
            margin-top: 10px;
            padding: 8px 15px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
        }
        .course-card .btn.add-btn {
            background: #28a745;
            color: white;
        }
        .course-card .btn.details-btn {
            background: #007bff;
            color: white;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.7);
        }
        .modal-content {
            background: #fff;
            color: #000;
            margin: 3% auto;
            padding: 20px;
            border-radius: 12px;
            width: 70%;
            max-height: 85%;
            overflow-y: auto;
        }
        .modal-content h2 {
            color: #11134d;
        }
        .modal-content img {
            width: 100%;
            border-radius: 10px;
            margin-bottom: 15px;
        }
        .modal-content h3 {
            margin-top: 20px;
            color: #007bff;
        }
        .close {
            float: right;
            font-size: 28px;
            cursor: pointer;
            color: #333;
        }

        /* Reviews Box */
        .reviews-box {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #ccc;
            padding: 10px;
            margin-top: 10px;
        }

        /* Responsive */
        @media screen and (max-width: 600px) {
            .search-bar input {
                width: 90%;
            }
        }
    </style>
</head>
<body>

<!-- Search Bar -->
<div class="search-bar">
    <input type="text" id="searchInput" placeholder="🔍 Search courses by title..." onkeyup="filterCourses()">
</div>

<!-- Aptitude Courses Section -->
<div class="course-section">
    <h2>Aptitude Courses</h2>
    <div class="course-scroll">
        <% if (aptitudeCourses != null) {
            for (Course c : aptitudeCourses) { %>
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
        <%  } } %>
    </div>
</div>
<hr>

<!-- Programming Courses Section -->
<div class="course-section">
    <h2>Programming Courses</h2>
    <div class="course-scroll">
        <% if (programmingCourses != null) {
            for (Course c : programmingCourses) { %>
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
        <%  } } %>
    </div>
</div>
<hr>

<!-- Logical Reasoning Courses Section -->
<div class="course-section">
    <h2>Logical Reasoning Courses</h2>
    <div class="course-scroll">
        <% if (logicalCourses != null) {
            for (Course c : logicalCourses) { %>
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
        <%  } } %>
    </div>
</div>

<!-- Modal -->
<div id="courseModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modalImage" src="" alt="Course Image">
    <h2 id="modalTitle"></h2>
    <p id="modalDescription"></p>

    <h3>Syllabus</h3>
    <p id="modalSyllabus"></p>

    <h3>Design</h3>
    <p id="modalDesign"></p>

    <h3>Topics Covered</h3>
    <p id="modalTopics"></p>

    <h3>Test Details</h3>
    <p id="modalTest"></p>

    <h3>⭐ Rating</h3>
    <p id="modalRating">(4.5 / 5)</p>

    <button id="addCourseBtn" class="btn add-btn">+ Add to My Courses</button>

    <h3>Reviews</h3>
    <div id="reviewsSection" class="reviews-box"></div>
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
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; });

    document.getElementById("courseModal").style.display = "block";

    document.getElementById("addCourseBtn").onclick = function() {
        addCourse(courseId);
    };
}

function closeModal() {
    document.getElementById("courseModal").style.display = "none";
}

function addCourse(courseId) {
    window.location.href = "AddCourseServlet?courseId=" + courseId;
}
</script>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,Module2.Course" %>
<%@ include file="navbar.jsp" %>

<%
    // Fetch course lists from servlet
    List<Course> aptitudeCourses = (List<Course>) request.getAttribute("aptitudeCourses");
    List<Course> programmingCourses = (List<Course>) request.getAttribute("programmingCourses");
    List<Course> logicalCourses = (List<Course>) request.getAttribute("logicalCourses");

    // Fallback dummy data if null (for testing UI)
    if (aptitudeCourses == null) {
        aptitudeCourses = new ArrayList<>();
        aptitudeCourses.add(new Course(1, "Aptitude 1", "Basic Aptitude skills", "Syllabus 1", "Design 1", "Topics 1", "Test 1", "https://via.placeholder.com/250"));
        aptitudeCourses.add(new Course(2, "Aptitude 2", "Advanced Aptitude skills", "Syllabus 2", "Design 2", "Topics 2", "Test 2", "https://via.placeholder.com/250"));
    }
    if (programmingCourses == null) {
        programmingCourses = new ArrayList<>();
        programmingCourses.add(new Course(3, "Java Basics", "Learn Java from scratch", "Syllabus J1", "Design J1", "Topics J1", "Test J1", "https://via.placeholder.com/250"));
    }
    if (logicalCourses == null) {
        logicalCourses = new ArrayList<>();
        logicalCourses.add(new Course(4, "Logical Reasoning 1", "Learn logical reasoning", "Syllabus L1", "Design L1", "Topics L1", "Test L1", "https://via.placeholder.com/250"));
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #0a002b;
            color: white;
            margin: 0;
            padding: 0;
        }

        /* Search Bar */
        .search-bar { display: flex; justify-content: center; margin: 20px; }
        .search-bar input {
            width: 50%;
            padding: 12px 20px;
            border-radius: 30px;
            border: none;
            outline: none;
            font-size: 16px;
            background: #11134d;
            color: white;
        }

        /* Section */
        .course-section { margin: 20px; }
        .course-section h2 { color: #00e0ff; margin-bottom: 10px; }

        /* Horizontal scroll container */
        .course-scroll {
            display: flex;
            overflow-x: auto;
            gap: 20px;
            padding-bottom: 10px;
        }
        .course-scroll::-webkit-scrollbar { height: 8px; }
        .course-scroll::-webkit-scrollbar-thumb { background: #555; border-radius: 4px; }
        .course-scroll::-webkit-scrollbar-track { background: #222; }

        /* Course Card */
        .course-card {
            min-width: 250px;
            background: #11134d;
            border-radius: 12px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            flex-shrink: 0;
            transition: transform 0.3s;
        }
        .course-card:hover { transform: translateY(-5px); }
        .course-card img { width: 100%; height: 150px; border-radius: 10px; object-fit: cover; }
        .course-card h3 { margin: 10px 0; color: #00e0ff; }
        .course-card p { font-size: 14px; color: #ddd; }
        .course-card .btn {
            margin-top: 10px;
            padding: 8px 15px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
        }
        .course-card .btn.add-btn { background: #28a745; color: white; }
        .course-card .btn.details-btn { background: #007bff; color: white; }

        /* Modal */
        .modal { display: none; position: fixed; z-index: 1000; left:0; top:0; width:100%; height:100%; background-color: rgba(0,0,0,0.7);}
        .modal-content {
            background: #fff;
            color: #000;
            margin: 3% auto;
            padding: 20px;
            border-radius: 12px;
            width: 70%;
            max-height: 85%;
            overflow-y: auto;
        }
        .modal-content h2 { color: #11134d; }
        .modal-content img { width: 100%; border-radius: 10px; margin-bottom: 15px; }
        .modal-content h3 { margin-top: 20px; color: #007bff; }
        .close { float: right; font-size: 28px; cursor: pointer; color: #333; }

        /* Reviews Box */
        .reviews-box { max-height: 200px; overflow-y: auto; border:1px solid #ccc; padding:10px; margin-top:10px; }

        /* Responsive */
        @media screen and (max-width:600px){ .search-bar input{ width:90%; } }
    </style>
</head>
<body>

<!-- Search Bar -->
<div class="search-bar">
    <input type="text" id="searchInput" placeholder="🔍 Search courses by title..." onkeyup="filterCourses()">
</div>

<!-- Sections -->
<%-- Aptitude Courses
<div class="course-section">
    <h2>Aptitude Courses</h2>
    <div class="course-scroll">
        <% for (Course c : aptitudeCourses) { %>
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

<%-- Programming Courses 
<div class="course-section">
    <h2>Programming Courses</h2>
    <div class="course-scroll">
        <% for (Course c : programmingCourses) { %>
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

<%-- Logical Reasoning Courses 
<div class="course-section">
    <h2>Logical Reasoning Courses</h2>
    <div class="course-scroll">
        <% for (Course c : logicalCourses) { %>
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

<!-- Modal -->
<div id="courseModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modalImage" src="" alt="Course Image">
    <h2 id="modalTitle"></h2>
    <p id="modalDescription"></p>
    <h3>Syllabus</h3><p id="modalSyllabus"></p>
    <h3>Design</h3><p id="modalDesign"></p>
    <h3>Topics Covered</h3><p id="modalTopics"></p>
    <h3>Test Details</h3><p id="modalTest"></p>
    <h3>⭐ Rating</h3><p id="modalRating">(4.5 / 5)</p>
    <button id="addCourseBtn" class="btn add-btn">+ Add to My Courses</button>
    <h3>Reviews</h3><div id="reviewsSection" class="reviews-box"></div>
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
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; });

    document.getElementById("courseModal").style.display = "block";

    document.getElementById("addCourseBtn").onclick = function() {
        addCourse(courseId);
    };
}

function closeModal() { document.getElementById("courseModal").style.display = "none"; }
function addCourse(courseId) { window.location.href = "AddCourseServlet?courseId=" + courseId; }
</script>

</body>
</html>--%>
<%-- <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Module2.Course" %>
<%@ include file="navbar.jsp" %>

<%
    Map<String, List<Course>> sectionCourses = (Map<String, List<Course>>) request.getAttribute("sectionCourses");

    // Fallback dummy data if null (for testing)
    if (sectionCourses == null || sectionCourses.isEmpty()) {
        sectionCourses = new LinkedHashMap<>();
        List<Course> dummyApt = new ArrayList<>();
        dummyApt.add(new Course(1,"Aptitude 1","Basic Aptitude skills","Syllabus 1","Design 1","Topics 1","Test 1","https://via.placeholder.com/250","doc","video","Aptitude"));
        dummyApt.add(new Course(2,"Aptitude 2","Advanced Aptitude","Syllabus 2","Design 2","Topics 2","Test 2","https://via.placeholder.com/250","doc","video","Aptitude"));
        sectionCourses.put("Aptitude", dummyApt);

        List<Course> dummyProg = new ArrayList<>();
        dummyProg.add(new Course(3,"Java Basics","Learn Java","Syllabus J","Design J","Topics J","Test J","https://via.placeholder.com/250","doc","video","Programming"));
        sectionCourses.put("Programming", dummyProg);

        List<Course> dummyLogic = new ArrayList<>();
        dummyLogic.add(new Course(4,"Logical Reasoning 1","Learn logic","Syllabus L","Design L","Topics L","Test L","https://via.placeholder.com/250","doc","video","Logical Reasoning"));
        sectionCourses.put("Logical Reasoning", dummyLogic);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0a002b; color:white; margin:0; padding:0;}
        .search-bar { display:flex; justify-content:center; margin:20px; }
        .search-bar input { width:50%; padding:12px 20px; border-radius:30px; border:none; outline:none; font-size:16px; background:#11134d; color:white; }
        .course-section { margin:20px; }
        .course-section h2 { color:#00e0ff; margin-bottom:10px; }
        .course-scroll { display:flex; overflow-x:auto; gap:20px; padding-bottom:10px; }
        .course-scroll::-webkit-scrollbar { height:8px; }
        .course-scroll::-webkit-scrollbar-thumb { background:#555; border-radius:4px; }
        .course-scroll::-webkit-scrollbar-track { background:#222; }
        .course-card { min-width:250px; background:#11134d; border-radius:12px; padding:15px; text-align:center; box-shadow:0 4px 8px rgba(0,0,0,0.3); flex-shrink:0; transition:transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:150px; border-radius:10px; object-fit:cover; }
        .course-card h3 { margin:10px 0; color:#00e0ff; }
        .course-card p { font-size:14px; color:#ddd; }
        .course-card .btn { margin-top:10px; padding:8px 15px; border-radius:8px; border:none; cursor:pointer; }
        .course-card .btn.add-btn { background:#28a745; color:white; }
        .course-card .btn.details-btn { background:#007bff; color:white; }
        .modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background-color: rgba(0,0,0,0.7);}
        .modal-content { background:#fff; color:#000; margin:3% auto; padding:20px; border-radius:12px; width:70%; max-height:85%; overflow-y:auto; }
        .modal-content h2 { color:#11134d; }
        .modal-content img { width:100%; border-radius:10px; margin-bottom:15px; }
        .modal-content h3 { margin-top:20px; color:#007bff; }
        .close { float:right; font-size:28px; cursor:pointer; color:#333; }
        .reviews-box { max-height:200px; overflow-y:auto; border:1px solid #ccc; padding:10px; margin-top:10px; }
        @media screen and (max-width:600px){ .search-bar input{ width:90%; } }
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

<!-- Modal -->
<div id="courseModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modalImage" src="" alt="Course Image">
    <h2 id="modalTitle"></h2>
    <p id="modalDescription"></p>
    <h3>Syllabus</h3><p id="modalSyllabus"></p>
    <h3>Design</h3><p id="modalDesign"></p>
    <h3>Topics Covered</h3><p id="modalTopics"></p>
    <h3>Test Details</h3><p id="modalTest"></p>
    <h3>⭐ Rating</h3><p id="modalRating">(4.5 / 5)</p>
    <button id="addCourseBtn" class="btn add-btn">+ Add to My Courses</button>
    <h3>Reviews</h3><div id="reviewsSection" class="reviews-box"></div>
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
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; });

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}
function closeModal() { document.getElementById("courseModal").style.display = "none"; }
function addCourse(courseId) { window.location.href = "AddCourseServlet?courseId=" + courseId; }
</script>

</body>
</html>--
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
        .search-bar { display:flex; justify-content:center; margin:20px; }
        .search-bar input { width:50%; padding:12px 20px; border-radius:30px; border:none; outline:none; font-size:16px; background:#11134d; color:white; }
        .course-section { margin:20px; }
        .course-section h2 { color:#00e0ff; margin-bottom:10px; }
        .course-scroll { display:flex; overflow-x:auto; gap:20px; padding-bottom:10px; }
        .course-scroll::-webkit-scrollbar { height:8px; }
        .course-scroll::-webkit-scrollbar-thumb { background:#555; border-radius:4px; }
        .course-scroll::-webkit-scrollbar-track { background:#222; }
        .course-card { min-width:250px; background:#11134d; border-radius:12px; padding:15px; text-align:center; box-shadow:0 4px 8px rgba(0,0,0,0.3); flex-shrink:0; transition:transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:150px; border-radius:10px; object-fit:cover; }
        .course-card h3 { margin:10px 0; color:#00e0ff; }
        .course-card p { font-size:14px; color:#ddd; }
        .course-card .btn { margin-top:10px; padding:8px 15px; border-radius:8px; border:none; cursor:pointer; }
        .course-card .btn.add-btn { background:#28a745; color:white; }
        .course-card .btn.details-btn { background:#007bff; color:white; }
        .modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background-color: rgba(0,0,0,0.7);}
        .modal-content { background:#fff; color:#000; margin:3% auto; padding:20px; border-radius:12px; width:70%; max-height:85%; overflow-y:auto; }
        .modal-content h2 { color:#11134d; }
        .modal-content img { width:100%; border-radius:10px; margin-bottom:15px; }
        .modal-content h3 { margin-top:20px; color:#007bff; }
        .close { float:right; font-size:28px; cursor:pointer; color:#333; }
        .reviews-box { max-height:200px; overflow-y:auto; border:1px solid #ccc; padding:10px; margin-top:10px; }
        @media screen and (max-width:600px){ .search-bar input{ width:90%; } }
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

<!-- Modal (same as before) -->
<div id="courseModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modalImage" src="" alt="Course Image">
    <h2 id="modalTitle"></h2>
    <p id="modalDescription"></p>
    <h3>Syllabus</h3><p id="modalSyllabus"></p>
    <h3>Design</h3><p id="modalDesign"></p>
    <h3>Topics Covered</h3><p id="modalTopics"></p>
    <h3>Test Details</h3><p id="modalTest"></p>
    <h3>⭐ Rating</h3><p id="modalRating">(4.5 / 5)</p>
    <button id="addCourseBtn" class="btn add-btn">+ Add to My Courses</button>
    <h3>Reviews</h3><div id="reviewsSection" class="reviews-box"></div>
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
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; });

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}
function closeModal() { document.getElementById("courseModal").style.display = "none"; }
function addCourse(courseId) { window.location.href = "AddCourseServlet?courseId=" + courseId; }
</script>

</body>
</html>
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

        /* Course Cards */
        .course-card { width:220px; background:#11134d; border-radius:12px; padding:10px; text-align:center; box-shadow:0 4px 6px rgba(0,0,0,0.3); flex-shrink:0; transition: transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:8px 0 5px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ddd; height:40px; overflow:hidden; }

        /* Buttons */
        .course-card .btn.add-btn { background:#28a745; color:white; margin-top:5px;}
        .course-card .btn.details-btn { background:#007bff; color:white; margin-top:5px; }

        /* Modal */
        .modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background-color: rgba(0,0,0,0.7);}
        .modal-content { display:flex; flex-direction:row; background:#fff; color:#000; border-radius:12px; padding:20px; max-width:80%; max-height:85%; overflow-y:auto; }
        .modal-content img { width:40%; border-radius:10px; object-fit:cover; }
        .modal-text { width:60%; padding-left:20px; }
        .modal-text h2 { font-size:24px; color:#11134d; margin-bottom:10px; font-weight:bold; }
        .modal-text h3 { font-size:18px; color:#007bff; margin-top:15px; }
        .modal-text p { font-size:14px; color:#333; line-height:1.4em; }
        .close { float:right; font-size:28px; cursor:pointer; color:#333; }
        .reviews-box { max-height:200px; overflow-y:auto; border:1px solid #ccc; padding:10px; margin-top:10px; }

        @media screen and (max-width:600px){ .search-bar input{ width:90%; } .modal-content { flex-direction:column;} .modal-content img{width:100%; margin-bottom:10px;} .modal-text{width:100%; padding-left:0;} }
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

<!-- Modal -->
<div id="courseModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modalImage" src="" alt="Course Image">
    <div class="modal-text">
        <h2 id="modalTitle"></h2>
        <p id="modalDescription"></p>

        <h3>Syllabus</h3>
        <p id="modalSyllabus"></p>

        <h3>Design</h3>
        <p id="modalDesign"></p>

        <h3>Topics Covered</h3>
        <p id="modalTopics"></p>

        <h3>Test Details</h3>
        <p id="modalTest"></p>

        <h3>⭐ Rating</h3>
        <p id="modalRating">(4.5 / 5)</p>

        <button id="addCourseBtn" class="btn add-btn">+ Add to My Courses</button>

        <h3>Reviews</h3>
        <div id="reviewsSection" class="reviews-box"></div>
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
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; });

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}
function closeModal() { document.getElementById("courseModal").style.display = "none"; }
function addCourse(courseId) { window.location.href = "AddCourseServlet?courseId=" + courseId; }
</script>

</body>
</html>--
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

        /* Course Cards */
        .course-card { width:220px; background:#11134d; border-radius:12px; padding:10px; text-align:center; box-shadow:0 4px 6px rgba(0,0,0,0.3); flex-shrink:0; transition: transform 0.3s; }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:8px 0 5px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ddd; height:40px; overflow:hidden; }

        /* Buttons */
        .course-card .btn.add-btn { background:#28a745; color:white; margin-top:5px;}
        .course-card .btn.details-btn { background:#007bff; color:white; margin-top:5px; }

        /* Enhanced Modal */
        .modal { 
            display:none; 
            position:fixed; 
            z-index:1000; 
            left:0; 
            top:0; 
            width:100%; 
            height:100%; 
            background: rgba(10, 0, 43, 0.95);
            backdrop-filter: blur(10px);
            animation: fadeIn 0.3s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content { 
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

        .modal-content::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #00e0ff, #0066cc);
            border-radius: 20px 20px 0 0;
        }

        .modal-image-container {
            width: 40%;
            padding-right: 25px;
        }

        .modal-content img { 
            width:100%; 
            height: 280px;
            border-radius:15px; 
            object-fit:cover; 
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            border: 2px solid rgba(0, 224, 255, 0.3);
        }

        .modal-text { 
            width:60%; 
            overflow-y:auto; 
            padding-right: 10px;
        }

        .modal-text::-webkit-scrollbar { width: 6px; }
        .modal-text::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.1); border-radius: 3px; }
        .modal-text::-webkit-scrollbar-thumb { background: #00e0ff; border-radius: 3px; }

        .modal-text h2 { 
            font-size:28px; 
            color:#00e0ff; 
            margin-bottom:15px; 
            font-weight:bold;
            text-shadow: 0 2px 10px rgba(0, 224, 255, 0.3);
        }

        .modal-description {
            font-size:16px; 
            color:#e0e0e0; 
            line-height:1.6em; 
            margin-bottom: 25px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            border-left: 4px solid #00e0ff;
        }

        .modal-section {
            margin-bottom: 20px;
        }

        .modal-text h3 { 
            font-size:18px; 
            color:#00e0ff; 
            margin: 20px 0 10px 0;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .modal-text h3::before {
            content: '';
            width: 4px;
            height: 18px;
            background: linear-gradient(180deg, #00e0ff, #0066cc);
            border-radius: 2px;
        }

        .modal-text p { 
            font-size:14px; 
            color:#ddd; 
            line-height:1.5em; 
            margin-bottom: 15px;
            padding: 12px 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .close { 
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

        .close:hover {
            background: rgba(0, 224, 255, 0.2);
            transform: rotate(90deg);
        }

        .rating-section {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 15px 0;
            padding: 12px 15px;
            background: rgba(255, 215, 0, 0.1);
            border-radius: 8px;
            border: 1px solid rgba(255, 215, 0, 0.3);
        }

        .rating-stars {
            color: #ffd700;
            font-size: 18px;
        }

        .rating-text {
            color: #ffd700;
            font-weight: 600;
        }

        .add-course-btn {
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

        .add-course-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        .reviews-box { 
            max-height:200px; 
            overflow-y:auto; 
            border:1px solid rgba(0, 224, 255, 0.3); 
            padding:15px; 
            margin-top:15px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
        }

        .reviews-box::-webkit-scrollbar { width: 6px; }
        .reviews-box::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.1); border-radius: 3px; }
        .reviews-box::-webkit-scrollbar-thumb { background: #00e0ff; border-radius: 3px; }

        /* Mobile Responsive */
        @media screen and (max-width:768px){ 
            .search-bar input{ width:90%; } 
            .modal-content { 
                flex-direction:column;
                margin: 5% auto;
                max-width: 95%;
                max-height: 95%;
                padding: 20px;
            } 
            .modal-image-container {
                width:100%; 
                padding-right: 0;
                margin-bottom:15px;
            }
            .modal-content img {
                height: 200px;
            }
            .modal-text{
                width:100%; 
            }
            .modal-text h2 {
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
<div id="courseModal" class="modal">
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
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; });

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}

function closeModal() { 
    document.getElementById("courseModal").style.display = "none"; 
}

function addCourse(courseId) { 
    window.location.href = "AddCourseServlet?courseId=" + courseId; 
}
</script>

</body>
</html>-
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

        /* Course Cards */
        .course-card { 
            width:220px; 
            background:#11134d; 
            border-radius:12px; 
            padding:10px; 
            text-align:center; 
            box-shadow:0 4px 6px rgba(0,0,0,0.3); 
            flex-shrink:0; 
            transition: transform 0.3s ease; 
        }
        .course-card:hover { transform:translateY(-5px); }
        .course-card img { width:100%; height:140px; border-radius:10px; object-fit:cover; }
        .course-card h3 { font-size:18px; margin:8px 0 5px 0; color:#00e0ff; }
        .course-card p { font-size:13px; color:#ddd; height:40px; overflow:hidden; }

        /* Buttons */
        .btn { 
            padding: 8px 15px; 
            margin: 3px; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 12px; 
            font-weight: 600; 
            transition: all 0.3s ease; 
        }
        .btn.add-btn { background:#28a745; color:white; }
        .btn.add-btn:hover { background:#218838; transform: translateY(-1px); }
        .btn.details-btn { background:#007bff; color:white; }
        .btn.details-btn:hover { background:#0056b3; transform: translateY(-1px); }

        /* Enhanced Modal */
        .modal { 
            display:none; 
            position:fixed; 
            z-index:1000; 
            left:0; 
            top:0; 
            width:100%; 
            height:100%; 
            background: rgba(10, 0, 43, 0.95);
            backdrop-filter: blur(10px);
            animation: fadeIn 0.3s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content { 
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

        .modal-content::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #00e0ff, #0066cc);
            border-radius: 20px 20px 0 0;
        }

        .modal-image-container {
            width: 40%;
            padding-right: 25px;
        }

        .modal-content img { 
            width:100%; 
            height: 280px;
            border-radius:15px; 
            object-fit:cover; 
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            border: 2px solid rgba(0, 224, 255, 0.3);
        }

        .modal-text { 
            width:60%; 
            overflow-y:auto; 
            padding-right: 10px;
        }

        .modal-text::-webkit-scrollbar { width: 6px; }
        .modal-text::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.1); border-radius: 3px; }
        .modal-text::-webkit-scrollbar-thumb { background: #00e0ff; border-radius: 3px; }

        .modal-text h2 { 
            font-size:28px; 
            color:#00e0ff; 
            margin-bottom:15px; 
            font-weight:bold;
            text-shadow: 0 2px 10px rgba(0, 224, 255, 0.3);
        }

        .modal-description {
            font-size:16px; 
            color:#e0e0e0; 
            line-height:1.6em; 
            margin-bottom: 25px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            border-left: 4px solid #00e0ff;
        }

        .modal-section {
            margin-bottom: 20px;
        }

        .modal-text h3 { 
            font-size:18px; 
            color:#00e0ff; 
            margin: 20px 0 10px 0;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .modal-text h3::before {
            content: '';
            width: 4px;
            height: 18px;
            background: linear-gradient(180deg, #00e0ff, #0066cc);
            border-radius: 2px;
        }

        .modal-text p { 
            font-size:14px; 
            color:#ddd; 
            line-height:1.5em; 
            margin-bottom: 15px;
            padding: 12px 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .close { 
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

        .close:hover {
            background: rgba(0, 224, 255, 0.2);
            transform: rotate(90deg);
        }

        .rating-section {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 15px 0;
            padding: 12px 15px;
            background: rgba(255, 215, 0, 0.1);
            border-radius: 8px;
            border: 1px solid rgba(255, 215, 0, 0.3);
        }

        .rating-stars {
            color: #ffd700;
            font-size: 18px;
        }

        .rating-text {
            color: #ffd700;
            font-weight: 600;
        }

        .add-course-btn {
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

        .add-course-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        .reviews-box { 
            max-height:200px; 
            overflow-y:auto; 
            border:1px solid rgba(0, 224, 255, 0.3); 
            padding:15px; 
            margin-top:15px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
        }

        .reviews-box::-webkit-scrollbar { width: 6px; }
        .reviews-box::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.1); border-radius: 3px; }
        .reviews-box::-webkit-scrollbar-thumb { background: #00e0ff; border-radius: 3px; }

        /* Mobile Responsive */
        @media screen and (max-width:768px){ 
            .search-bar input{ width:90%; } 
            .modal-content { 
                flex-direction:column;
                margin: 5% auto;
                max-width: 95%;
                max-height: 95%;
                padding: 20px;
            } 
            .modal-image-container {
                width:100%; 
                padding-right: 0;
                margin-bottom:15px;
            }
            .modal-content img {
                height: 200px;
            }
            .modal-text{
                width:100%; 
            }
            .modal-text h2 {
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
<div id="courseModal" class="modal">
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
    document.getElementById("modalTitle").innerText = title;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalImage").src = image;
    document.getElementById("modalSyllabus").innerText = syllabus;
    document.getElementById("modalDesign").innerText = design;
    document.getElementById("modalTopics").innerText = topics;
    document.getElementById("modalTest").innerText = testDetails;

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; });

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}

function closeModal() { 
    document.getElementById("courseModal").style.display = "none"; 
}

function addCourse(courseId) { 
    window.location.href = "AddCourseServlet?courseId=" + courseId; 
}
</script>

</body>
</html>--<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        /* Original Button Styles - KEEP EXACTLY AS IS */
        .course-card .btn.add-btn { background:#28a745; color:white; margin-top:5px;}
        .course-card .btn.details-btn { background:#007bff; color:white; margin-top:5px; }

        /* Enhanced Modal - COMPLETELY ISOLATED */
        #courseModal { 
            display:none; 
            position:fixed; 
            z-index:9999; 
            left:0; 
            top:0; 
            width:100%; 
            height:100%; 
            background: rgba(10, 0, 43, 0.95);
            backdrop-filter: blur(10px);
            animation: modalFadeIn 0.3s ease-in-out;
            isolation: isolate;
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
<% }--

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

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; })
        .catch(err => console.log('Reviews loading failed:', err));

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}

function closeModal() { 
    const modal = document.getElementById("courseModal");
    modal.style.display = "none";
    
    // Force refresh of background elements to remove any residual effects
    document.body.style.transform = "translateZ(0)";
    setTimeout(() => {
        document.body.style.transform = "";
    }, 1);
}

function addCourse(courseId) { 
    window.location.href = "AddCourseServlet?courseId=" + courseId; 
}

// Prevent modal from closing when clicking inside the modal content
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('courseModal');
    
    modal.addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
    
    // Ensure no backdrop effects persist
    modal.addEventListener('transitionend', function() {
        if (this.style.display === 'none') {
            // Clean up any potential CSS artifacts
            document.body.classList.remove('modal-open');
            document.documentElement.style.removeProperty('backdrop-filter');
        }
    });
});
</script>

</body>
</html>
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

        /* Original Button Styles - KEEP EXACTLY AS IS */
        .course-card .btn.add-btn { background:#28a745; color:white; margin-top:5px;}
        .course-card .btn.details-btn { background:#007bff; color:white; margin-top:5px; }

        /* Enhanced Modal - ONLY AFFECTS MODAL */
        #courseModal { 
            display:none; 
            position:fixed; 
            z-index:9999; 
            left:0; 
            top:0; 
            width:100%; 
            height:100%; 
            background: rgba(10, 0, 43, 0.95);
            backdrop-filter: blur(10px);
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

function addCourse(courseId) { 
    window.location.href = "AddCourseServlet?courseId=" + courseId; 
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
</html>--
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

        /* Original Button Styles - KEEP EXACTLY AS IS */
        .course-card .btn.add-btn { background:#28a745; color:white; margin-top:5px;}
        .course-card .btn.details-btn { background:#007bff; color:white; margin-top:5px; }

        /* Enhanced Modal - COMPLETELY ISOLATED */
        #courseModal { 
            display:none; 
            position:fixed; 
            z-index:9999; 
            left:0; 
            top:0; 
            width:100%; 
            height:100%; 
            background: rgba(10, 0, 43, 0.95);
            backdrop-filter: blur(10px);
            animation: modalFadeIn 0.3s ease-in-out;
            isolation: isolate;
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

    fetch("GetReviewsServlet?courseId=" + courseId)
        .then(res => res.text())
        .then(data => { document.getElementById("reviewsSection").innerHTML = data; })
        .catch(err => console.log('Reviews loading failed:', err));

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}

function closeModal() { 
    const modal = document.getElementById("courseModal");
    modal.style.display = "none";
    
    // Force refresh of background elements to remove any residual effects
    document.body.style.transform = "translateZ(0)";
    setTimeout(() => {
        document.body.style.transform = "";
    }, 1);
}

function addCourse(courseId) { 
    window.location.href = "AddCourseServlet?courseId=" + courseId; 
}

// Prevent modal from closing when clicking inside the modal content
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('courseModal');
    
    modal.addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
    
    // Ensure no backdrop effects persist
    modal.addEventListener('transitionend', function() {
        if (this.style.display === 'none') {
            // Clean up any potential CSS artifacts
            document.body.classList.remove('modal-open');
            document.documentElement.style.removeProperty('backdrop-filter');
        }
    });
});
</script>

</body>
</html>--%>


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

        /* Original Button Styles - KEEP EXACTLY AS IS */
        .course-card .btn.add-btn { background:#28a745; color:white; margin-top:5px;}
        .course-card .btn.details-btn { background:#007bff; color:white; margin-top:5px; }

        /* Enhanced Modal - NO BACKDROP FILTER */
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
    fetch("GetReviewsServlet?courseId=" + courseId)
    .then(res => res.text())
    .then(data => { document.getElementById("reviewsSection").innerHTML = data; })


  //  fetch("GetReviewServlet?courseId=" + courseId)
    //    .then(res => res.text())
      //  .then(data => { document.getElementById("reviewsSection").innerHTML = data; })
        .catch(err => console.log('Reviews loading failed:', err));

    document.getElementById("courseModal").style.display = "block";
    document.getElementById("addCourseBtn").onclick = function() { addCourse(courseId); };
}

function closeModal() { 
    document.getElementById("courseModal").style.display = "none";
}


function addCourse(courseId) {
    fetch("AddCourseServlet", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "courseId=" + courseId
    })
    .then(response => {
        // Let the servlet redirect handle everything
        window.location.href = "MyCoursesServlet";
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
</html>
<%--
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

        /* Original Button Styles - KEEP EXACTLY AS IS */
        .course-card .btn.add-btn { background:#28a745; color:white; margin-top:5px;}
        .course-card .btn.details-btn { background:#007bff; color:white; margin-top:5px; }

        /* Simple Modal - NO INTERFERENCE */
        #courseModal { 
            display: none; 
            position: fixed; 
            z-index: 1000; 
            left: 0; 
            top: 0; 
            width: 100%; 
            height: 100%; 
            background-color: rgba(0,0,0,0.8);
        }

        #courseModal .modal-content { 
            background-color: #1a1a4d;
            color: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 10px;
            width: 80%;
            max-width: 900px;
            max-height: 80%;
            overflow-y: auto;
            position: relative;
            display: flex;
            gap: 20px;
        }

        #courseModal .modal-image-container {
            flex: 0 0 300px;
        }

        #courseModal .modal-image-container img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }

        #courseModal .modal-text {
            flex: 1;
        }

        #courseModal .modal-text h2 {
            color: #00e0ff;
            margin-top: 0;
            margin-bottom: 15px;
        }

        #courseModal .modal-text h3 {
            color: #00e0ff;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        #courseModal .modal-text p {
            line-height: 1.5;
            margin-bottom: 15px;
        }

        #courseModal .close {
            position: absolute;
            top: 10px;
            right: 15px;
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        #courseModal .close:hover {
            color: #00e0ff;
        }

        #courseModal .add-course-btn {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin: 15px 0;
        }

        #courseModal .reviews-box {
            border: 1px solid #555;
            padding: 10px;
            margin-top: 10px;
            max-height: 150px;
            overflow-y: auto;
            border-radius: 5px;
        }

        @media (max-width: 768px) {
            #courseModal .modal-content {
                width: 95%;
                margin: 2% auto;
                flex-direction: column;
            }
            
            #courseModal .modal-image-container {
                flex: none;
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
        <p id="modalDescription"></p>

        <h3>Syllabus</h3>
        <p id="modalSyllabus"></p>

        <h3>Design</h3>
        <p id="modalDesign"></p>

        <h3>Topics Covered</h3>
        <p id="modalTopics"></p>

        <h3>Test Details</h3>
        <p id="modalTest"></p>

        <h3>⭐ Rating</h3>
        <p>(4.5 / 5)</p>

        <button id="addCourseBtn" class="add-course-btn">+ Add to My Courses</button>

        <h3>Reviews</h3>
        <div id="reviewsSection" class="reviews-box"></div>
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

function addCourse(courseId) { 
    window.location.href = "AddCourseServlet?courseId=" + courseId; 
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
</html>
--%>








