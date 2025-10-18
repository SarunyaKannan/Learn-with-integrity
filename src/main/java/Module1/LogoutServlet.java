/*package Module1;


import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.*;
import java.io.*;
import jakarta.servlet.annotation.*;
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException{
		HttpSession session=req.getSession(false);
		User user=(User)session.getAttribute("user");
//		System.out.println("reached logout servlet");
		user=null;
		session.invalidate();
		RequestDispatcher rd=req.getRequestDispatcher("index.html");
		rd.forward(req, res);
	}

}  */


package Module1;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        // Get the existing session, don't create new one
        HttpSession session = req.getSession(false);

        if (session != null) {
            // Invalidate the session safely
            session.invalidate();
        }

        // Always redirect to home.jsp (public page)
        res.sendRedirect("home.jsp");
    }
}
