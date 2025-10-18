<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Module2.Review, Module2.ReviewDAO, Module1.User" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="navbar.jsp" %>
<%--<%



User user = (User) session.getAttribute("user");
if(user == null){
    response.sendRedirect("login.jsp");
    return;
}

int userId = user.getId();      // ✅ use getId() here
String username = user.getUsername();
--%>

<!--  --<input type="hidden" name="userId" value="--><%--<%= userId %>">--%>

<%-- --%   // Check if user is logged in
 //   User user = (User) session.getAttribute("user");
   // if (user == null) {
     //   response.sendRedirect("login.jsp");
       // return;
  //  }

    int userId = user.getUserId();
    String username = user.getUsername()--%

 <%    // Get courseId from query string
    String courseIdParam = request.getParameter("courseId");
    if (courseIdParam == null) {
        response.sendRedirect("mycourses.jsp");
        return;
    }
    int courseId = Integer.parseInt(courseIdParam);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Write Review</title>
    <style>
        body { font-family: Arial, sans-serif; background:#0a002b; color:white; margin:0; padding:0;}
        .container { max-width:600px; margin:50px auto; background:#11134d; padding:30px; border-radius:12px; box-shadow:0 4px 10px rgba(0,0,0,0.5);}
        h2 { color:#00e0ff; text-align:center; margin-bottom:20px; }
        label { display:block; margin:10px 0 5px; }
        select, textarea { width:100%; padding:10px; border-radius:6px; border:none; outline:none; font-size:14px; background:#222; color:white; }
        button { margin-top:20px; width:100%; padding:12px; font-size:16px; background:#28a745; color:white; border:none; border-radius:25px; cursor:pointer; }
        button:hover { background:#20c997; }
    </style>
</head>
<body>

<div class="container">
    <h2>Write a Review</h2>
    <form method="post" action="AddReviewServlet">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        <input type="hidden" name="userId" value="<%= userId %>">

        <label for="rating">Rating:</label>
        <select name="rating" id="rating">
            <option value="5">⭐⭐⭐⭐⭐</option>
            <option value="4">⭐⭐⭐⭐</option>
            <option value="3">⭐⭐⭐</option>
            <option value="2">⭐⭐</option>
            <option value="1">⭐</option>
        </select>

        <label for="reviewText">Review:</label>
        <textarea name="reviewText" id="reviewText" rows="5" placeholder="Write your review..."></textarea>

        <button type="submit">Submit Review</button>
    </form>
</div>

</body>
</html>  --%>
<%
User user = (User) session.getAttribute("user");
int userId = user.getId();
int courseId = Integer.parseInt(request.getParameter("courseId"));

ReviewDAO dao = new ReviewDAO();
Review existingReview = dao.getReviewByUserAndCourse(userId, courseId);
%>
<!DOCTYPE html>
<html>
<head>
<div class="container">
    <title>Write Review</title>
    <style>
        body { font-family: Arial, sans-serif; background:#0a002b; color:white; margin:0; padding:0;}
        .container { max-width:600px; margin:50px auto; background:#11134d; padding:30px; border-radius:12px; box-shadow:0 4px 10px rgba(0,0,0,0.5);}
        h2 { color:#00e0ff; text-align:center; margin-bottom:20px; }
        label { display:block; margin:10px 0 5px; }
        select, textarea { width:100%; padding:10px; border-radius:6px; border:none; outline:none; font-size:14px; background:#222; color:white; }
        button { margin-top:20px; width:100%; padding:12px; font-size:16px; background:#28a745; color:white; border:none; border-radius:25px; cursor:pointer; }
        button:hover { background:#20c997; }
    </style>
</head>
<body>

<div class="modal-section">
   <h3>✍️ Write a Review</h3>
   <form id="reviewForm" method="post" action="AddReviewServlet">
       <input type="hidden" name="courseId" value="<%= courseId %>">
       <label>Rating: 
           <select name="rating">
               <option value="5" <%= existingReview != null && existingReview.getRating() == 5 ? "selected" : "" %>>⭐⭐⭐⭐⭐</option>
               <option value="4" <%= existingReview != null && existingReview.getRating() == 4 ? "selected" : "" %>>⭐⭐⭐⭐</option>
               <option value="3" <%= existingReview != null && existingReview.getRating() == 3 ? "selected" : "" %>>⭐⭐⭐</option>
               <option value="2" <%= existingReview != null && existingReview.getRating() == 2 ? "selected" : "" %>>⭐⭐</option>
               <option value="1" <%= existingReview != null && existingReview.getRating() == 1 ? "selected" : "" %>>⭐</option>
           </select>
       </label><br><br>
       <textarea name="reviewText" rows="3" style="width:100%;" placeholder="Write your review..."><%= existingReview != null ? existingReview.getReviewText() : "" %></textarea><br>
       <button type="submit"><%= existingReview != null ? "Update Review" : "Submit Review" %></button>
   </form>
</div>
</body>
</html>
