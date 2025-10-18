package Module1;
import java.sql.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) {
        String userIdentifier = req.getParameter("userIdentifier").trim();
        String password = req.getParameter("password").trim();
     //   System.out.println("Reached login servlet");

        Connection con=DbConnection.getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM USERS WHERE username = ? OR email = ?");
            ps.setString(1, userIdentifier);
            ps.setString(2, userIdentifier);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
            	
            	                String storedHashedPwd = rs.getString("password");

                if (BCrypt.checkpw(password, storedHashedPwd)) {
                	int id=rs.getInt(1);
                	String name=rs.getString(2);
                	String email=rs.getString(3);
                	String username=rs.getString(4);
                	String gender=rs.getString(5);
                	String role=rs.getString(6);
                	User user = new User(id, name, email, username, gender, role);
                	HttpSession session = req.getSession();
                //	session.setAttribute("user", user);
                //	HttpSession session = request.getSession();
                //	session.setAttribute("username", username); // or use email if you prefer
                //	res.sendRedirect("home.jsp");

                
                	
                	session.setAttribute("user", user);
                	res.sendRedirect("UserDashboard");


                  //  RequestDispatcher rd = req.getRequestDispatcher("/UserDashboard");
                 //   rd.forward(req, res);
                } else {
                	req.setAttribute("message", "Invalid password.");
                    RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
                    rd.forward(req, res);
                }
            } else {
            	 req.setAttribute("message", "User not found. Please register first. To REGISTER GO TO SIGN UP");
                 RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
                 rd.forward(req, res);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


