/*package Module2;

import Module2.Course;
import Module1.DbConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.util.*;

import Module1.*;
@WebServlet("/explore")
public class ExploreCoursesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<Course> courses = new ArrayList<>();
        try (Connection con = DbConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM courses_1");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course(
                		rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("syllabus"),
                        rs.getString("design"),
                        rs.getString("topics_covered"),
                        rs.getString("test_details"),
                        rs.getString("image"),
                        rs.getString("document_link"),
                        rs.getString("video_link"),
                        rs.getString("section")
                );
                courses.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.setAttribute("courses", courses);
        req.getRequestDispatcher("newexplore.jsp").forward(req, res);
    }
}package Module2;

import Module1.DbConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/explore")
public class ExploreCoursesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<Course> aptitudeCourses = new ArrayList<>();
        List<Course> programmingCourses = new ArrayList<>();
        List<Course> logicalCourses = new ArrayList<>();

        try (Connection con = DbConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM courses_1");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("syllabus"),
                        rs.getString("design"),
                        rs.getString("topics_covered"),
                        rs.getString("test_details"),
                        rs.getString("image"),
                        rs.getString("document_link"),
                        rs.getString("video_link"),
                        rs.getString("section")
                );

                // Group courses based on the section
                String section = rs.getString("section").toLowerCase();
                switch (section) {
                    case "aptitude":
                        aptitudeCourses.add(c);
                        break;
                    case "programming":
                        programmingCourses.add(c);
                        break;
                    case "logical reasoning":
                        logicalCourses.add(c);
                        break;
                    default:
                        // Optional: handle other sections if needed
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set separate attributes for JSP
        req.setAttribute("aptitudeCourses", aptitudeCourses);
        req.setAttribute("programmingCourses", programmingCourses);
        req.setAttribute("logicalCourses", logicalCourses);

        // Forward to JSP
        req.getRequestDispatcher("newexplore.jsp").forward(req, res);
    }
}*/
package Module2;

import Module1.DbConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/explore")
public class ExploreCoursesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        // Map to hold section name -> list of courses
        Map<String, List<Course>> sectionCourses = new LinkedHashMap<>();
      //  System.out.println("REached Explore courses servlet");

        try (Connection con = DbConnection.getConnection()) {

            // Fetch all courses ordered by section for consistency
            PreparedStatement ps = con.prepareStatement("SELECT * FROM courses_1 ORDER BY section, id");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("syllabus"),
                        rs.getString("design"),
                        rs.getString("topics_covered"),
                        rs.getString("test_details"),
                        rs.getString("image"),
                        rs.getString("document_link"),
                        rs.getString("video_link"),
                        rs.getString("section")
                );

                String section = rs.getString("section");
                sectionCourses.putIfAbsent(section, new ArrayList<>());
                sectionCourses.get(section).add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set the map as a request attribute
        req.setAttribute("sectionCourses", sectionCourses);

        // Forward to JSP
        req.getRequestDispatcher("newexplore.jsp").forward(req, res);
    }
}


