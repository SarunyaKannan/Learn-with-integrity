package Module1;



import java.util.*;
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

/*
@WebServlet("/PwdReset")
public class PwdReset extends HttpServlet {
	protected void doPost(HttpServletRequest req,HttpServletResponse res) {
		String email=req.getParameter("email");
		
		try {
			Connection con=DbConnection.getConnection();
			PreparedStatement ps=con.prepareStatement("SELECT * FROM USERS WHERE EMAIL=?");
			ps.setString(1, email);
			ResultSet rs=ps.executeQuery();
			
			PrintWriter pw=res.getWriter();
			
			
			
			
			
			if(rs.next()) {
				
				String username=rs.getString("username");
				String pwd;
			    if((req.getParameter("confirmPwd"))==null) { 
				RegisterServlet regser=new RegisterServlet();
				 pwd = regser.generatePassword();
			    }
			    else
			    {
			    	pwd=req.getParameter("confirmPwd");
			    }
				String hashedPwd = BCrypt.hashpw(pwd, BCrypt.gensalt());
				PreparedStatement update = con.prepareStatement("UPDATE USERS SET PASSWORD=? WHERE email=?");
				update.setString(1, hashedPwd); // hashed password
				update.setString(2, email);
				int i = update.executeUpdate();
				
				PreparedStatement pwdup=con.prepareStatement("UPDATE PWD SET PWD=? WHERE email=?");
				pwdup.setString(1,pwd);
				pwdup.setString(2, email);
		        int j=pwdup.executeUpdate();
				
				
				

			/*	String pwd=regser.generatePassword();
				PreparedStatement update=con.prepareStatement("UPDATE USERS SET PASSWORD=? where Email=? ");
				update.setString(1,pwd);
				update.setString(2, email);
				int i=update.executeUpdate();*
				if(i==1) {
					String name=rs.getString("name");
					RegisterServlet.sendEmail(name, email, pwd,true);
					req.setAttribute("message", "Your password reset has been successful! Password has been sent to your mail.");
					RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
					rd.forward(req, res); // Use forward instead of include

					
				}
				else {
					pw.print("<h1>something went wrong</h1>");
				}
				
				
				
			}
			else {
				pw.println("<h1>User does not exist...Enter valid mail id");
				RequestDispatcher rd=req.getRequestDispatcher("pwdreset.html");
				rd.include(req, res);
			}
			
			
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

} */
@WebServlet("/PwdReset")
public class PwdReset extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) {
        String email = req.getParameter("email");
       // System.out.println("Reached Pwd reset servlet");

        try (Connection con = DbConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM USERS WHERE EMAIL=?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String pwd;
                if (req.getParameter("confirmPwd") == null) { 
                    RegisterServlet regser = new RegisterServlet();
                    pwd = regser.generatePassword();
                } else {
                    pwd = req.getParameter("confirmPwd");
                }

                String hashedPwd = BCrypt.hashpw(pwd, BCrypt.gensalt());

                // update USERS table
                PreparedStatement update = con.prepareStatement("UPDATE USERS SET PASSWORD=? WHERE email=?");
                update.setString(1, hashedPwd);
                update.setString(2, email);
                int i = update.executeUpdate();

                // store plain password separately (not recommended in real apps!)
                PreparedStatement pwdup = con.prepareStatement("UPDATE PWD SET PWD=? WHERE email=?");
                pwdup.setString(1, pwd);
                pwdup.setString(2, email);
                int j = pwdup.executeUpdate();

                if (i == 1) {
                    String name = rs.getString("name");
                    RegisterServlet.sendEmail(name, email, pwd, true);
                    req.setAttribute("message", "✅ Password reset successful! Check your mail.");
                    RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
                    rd.forward(req, res);
                } else {
                    req.setAttribute("message", "❌ Something went wrong. Try again.");
                }
            } else {
                req.setAttribute("message", "❌ User does not exist. Enter a valid email.");
            }

            // always forward back to pwdreset.jsp
            RequestDispatcher rd = req.getRequestDispatcher("pwdreset.jsp");
            rd.forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                req.setAttribute("message", "⚠️ Error occurred: " + e.getMessage());
                req.getRequestDispatcher("pwdreset.jsp").forward(req, res);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}


