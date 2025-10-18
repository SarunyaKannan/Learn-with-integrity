package Module1;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
//import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.util.*;
import jakarta.mail.*;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.activation.*;               // For DataSource
import jakarta.mail.util.ByteArrayDataSource;  // For byte[] PDF attachment

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet{
	public  String generatePassword() {
		
		String chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%";
		StringBuilder sb=new StringBuilder();
		Random rd=new Random();
		for(int i=0;i<8;i++) {
			sb.append(chars.charAt(rd.nextInt(chars.length())));
		}
		return sb.toString();
	}
	static void sendEmail(String name,String to,String password,boolean isExist) {
		             // Replace with the receiver's email
	   
	   final  String from = "learnwithintegrity1@gmail.com";             // Replace with your Gmail address
	   final  String apppassword = "oqgj ehav ytjm vrpq";           // App password generated from Google

	     // 2. Set up mail server properties for Gmail
	     Properties props = new Properties();

	     // Enable authentication
	     props.put("mail.smtp.auth", "true");

	     // Enable STARTTLS (secure communication)
	     props.put("mail.smtp.starttls.enable", "true");

	     // Gmail SMTP server address
	     props.put("mail.smtp.host", "smtp.gmail.com");

	     // Gmail SMTP port (587 for TLS)
	     props.put("mail.smtp.port", "587");

	     // 3. Create a mail session with authentication
	     Session session = Session.getInstance(props, new Authenticator() {
	         protected PasswordAuthentication getPasswordAuthentication() {
	             // Authenticate using your Gmail and app password
	             return new PasswordAuthentication(from, apppassword);
	         }
	     });
	     try {
	         // 4. Create a MimeMessage (email message)
	         Message message = new MimeMessage(session);

	         // Set the sender's email address
	         message.setFrom(new InternetAddress(from));

	         // Set the recipient's email address
	         message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

	         // Set the subject of the email
	         if(!isExist) {
	         message.setSubject("Welcome to LMS - Your login password ");

	         // Set the actual email message text
	         message.setText("Dear "+name+"\nYour account has been created successfully! \n"
	         		+ "\n your password :"+password+"\n\n Login with this password and after first login change password");
	         }
	         else {
	        	 message.setSubject("Password Reset - LWI!");

		         // Set the actual email message text
		         message.setText("Dear "+name+"\nYour password has been reseted successfully! \n"
		         		+ "\n your password :"+password+"\n\n Login with this password and after first login change password");
		         
	        	 
	         }
	         // 5. Send the email using Transport
	         Transport.send(message);

	         // If everything is successful
	      //   System.out.println("Email sent successfully!");

	     } catch (MessagingException e) {
	         // Handle errors during sending
	         e.printStackTrace();
	     }
	}
	
	
	// 📌 New method for course registration mail
	public static void sendCourseRegistrationMail(String to, String username, String courseName, String link) {
	    final String from = "learnwithintegrity1@gmail.com";
	    final String apppassword = "oqgj ehav ytjm vrpq"; // Gmail App Password

	    Properties props = new Properties();
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");
	    props.put("mail.smtp.host", "smtp.gmail.com");
	    props.put("mail.smtp.port", "587");

	    Session session = Session.getInstance(props, new Authenticator() {
	        protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(from, apppassword);
	        }
	    });

	    try {
	        Message message = new MimeMessage(session);
	        message.setFrom(new InternetAddress(from));
	        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
	        message.setSubject("🎓 Course Registration Successful!");
	        message.setText("Hello " + username + ",\n\n"
	                + "You have successfully enrolled in the course: " + courseName + ".\n\n"
	                + "👉 Access your course here: " + link + "\n\n"
	                + "Best regards,\nLearn With Integrity Team");

	        Transport.send(message);
	    } catch (MessagingException e) {
	        e.printStackTrace();
	    }
	}

	protected void doPost(HttpServletRequest req,HttpServletResponse res) {
		String name=req.getParameter("name");
		String email=req.getParameter("email");
		String username=req.getParameter("username");
		//String password=req.getParameter("password");
		
		
		System.out.println("Reached Register servlet");
	

	    // Step 2: Define a regular expression for valid email format
	    String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";

	    
	    try {
	    // Step 3: Check if the email matches the regex pattern
	    if (email == null || !email.matches(emailRegex)) {
	        // Step 4: If invalid, send error response
	        res.setContentType("text/html");
	        PrintWriter out = res.getWriter();
	        out.println("<html><body>");
	        out.println("<h3 style='color:red;'>Invalid email format. Please enter a valid email.</h3>");
	        out.println("</body></html>");
	         // Stop further processing
	        return;
	    }

		
		String password=generatePassword();
		String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
		String gender=req.getParameter("gender");
		String role=req.getParameter("role");
		
		
		
	
			PrintWriter pw=res.getWriter();
			res.setContentType("text/html");
			
			System.out.print("reached register servlet");
			
			Connection con=DbConnection.getConnection();
			
			
			
			
			
			PreparedStatement emailchk=con.prepareStatement("SELECT * FROM USERS WHERE email=? OR username=?");
			emailchk.setString(1,email);
			emailchk.setString(2, username);
			ResultSet rs=emailchk.executeQuery();
			if(rs.next()) {
				req.setAttribute("error", "❌ User already exists. Please try with a different email or username.");
				RequestDispatcher rd = req.getRequestDispatcher("register.jsp");
				rd.forward(req, res);
				return;

			}
			
			
			PreparedStatement st =con.prepareStatement("INSERT INTO USERS(NAME,EMAIL,USERNAME,PASSWORD,GENDER,ROLE) VALUES(?,?,?,?,?,?)");
			st.setString(1,name);
			st.setString(2, email);
			
			st.setString(3, username);
			st.setString(4, hashedPassword);
			st.setString(5, gender);
			st.setString(6,role);
			int result=st.executeUpdate();
			
			if(result>0) {
				sendEmail(name,email,password,false);
				PreparedStatement pst=con.prepareStatement("INSERT INTO PWD(USERNAME,EMAIL,PWD) VALUES(?,?,?)");
				pst.setString(1, username);
				pst.setString(2, email);
				pst.setString(3,password);
				pst.executeUpdate();
				
				req.setAttribute("message", "🎉 Registration successful! Login credentials have been sent to your mail.");
				RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
				

				rd.include(req, res);
				
			}
			else {
				req.setAttribute("error", "⚠️ Registration failed due to a system error. Please try again later.");
				RequestDispatcher rd = req.getRequestDispatcher("register.jsp");
				rd.forward(req, res);

		
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
				
		
	}
	public static void sendQuizResultMail(String to, String username, String courseName, 
            String level, int score, int total, 
            List<Map<String,String>> resultDetails) {
final String from = "learnwithintegrity1@gmail.com";
final String apppassword = "oqgj ehav ytjm vrpq"; // Gmail App Password

Properties props = new Properties();
props.put("mail.smtp.auth", "true");
props.put("mail.smtp.starttls.enable", "true");
props.put("mail.smtp.host", "smtp.gmail.com");
props.put("mail.smtp.port", "587");

Session session = Session.getInstance(props, new Authenticator() {
protected PasswordAuthentication getPasswordAuthentication() {
return new PasswordAuthentication(from, apppassword);
}
});

try {
Message message = new MimeMessage(session);
message.setFrom(new InternetAddress(from));
message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
message.setSubject("📊 Quiz Result - " + courseName);

StringBuilder body = new StringBuilder();
body.append("Hello ").append(username).append(",\n\n")
.append("You have completed the quiz for course: ").append(courseName).append("\n")
.append("Level: ").append(level).append("\n")
.append("Your Score: ").append(score).append("/").append(total).append("\n\n");

body.append("📌 Detailed Results:\n");
for (Map<String,String> detail : resultDetails) {
body.append("Q: ").append(detail.get("question")).append("\n")
.append("A) ").append(detail.get("optA")).append("\n")
.append("B) ").append(detail.get("optB")).append("\n")
.append("C) ").append(detail.get("optC")).append("\n")
.append("D) ").append(detail.get("optD")).append("\n")
.append("✅ Correct: ").append(detail.get("correct").toUpperCase()).append("\n")
.append("❌ Your Answer: ").append(detail.get("user")).append("\n")
.append("💡 Solution: ").append(detail.get("solution")).append("\n\n");

}

body.append("Keep learning with integrity!\n\n")
.append("Best regards,\nLearn With Integrity Team");

message.setText(body.toString());

Transport.send(message);
} catch (MessagingException e) {
e.printStackTrace();
}
}
	public static void sendBadgeMail(String toEmail, String username, String courseTitle,
            String badgeName, String badgeDesc, String badgeImage) {
String subject = "🎉 Congratulations! You earned a new badge in " + courseTitle;
String body = "<h2>Hi " + username + ",</h2>"
+ "<p>Great job! You have completed the course <b>" + courseTitle + "</b> "
+ "and earned a new badge:</p>"
+ "<h3>" + badgeName + "</h3>"
+ "<p>" + badgeDesc + "</p>"
+ "<img src='" + badgeImage + "' alt='Badge' style='width:120px;height:120px;'/>"
+ "<p>Keep learning and earning more badges!</p>";

try {
// ---- SMTP properties (reuse same as in sendQuizResultMail) ----
Properties props = new Properties();
props.put("mail.smtp.host", "smtp.gmail.com"); // or your SMTP host
props.put("mail.smtp.port", "587");
props.put("mail.smtp.auth", "true");
props.put("mail.smtp.starttls.enable", "true");

// ---- Auth session ----
Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
protected PasswordAuthentication getPasswordAuthentication() {
return new PasswordAuthentication("learnwithintegrity1@gmail.com", "oqgj ehav ytjm vrpq");
}
});

// ---- Compose message ----
Message message = new MimeMessage(session);
message.setFrom(new InternetAddress("yourEmail@gmail.com"));
message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
message.setSubject(subject);
message.setContent(body, "text/html");

// ---- Send ----
Transport.send(message);

//System.out.println("✅ Badge mail sent successfully to " + toEmail);
} catch (Exception e) {
e.printStackTrace();
}
}


/*	public static void sendCompletionMail(String toEmail, String username, String course, byte[] pdfBytes, int badgeId, Connection con) {
	    try {
	        String badgePath = null;
	        try (PreparedStatement ps = con.prepareStatement("SELECT image_path FROM badges WHERE badge_id=?")) {
	            ps.setInt(1, badgeId);
	            try (ResultSet rs = ps.executeQuery()) {
	                if (rs.next()) badgePath = rs.getString("image_path");
	            }
	        }

	        String subject = "Congratulations! You've completed " + course;
	        String body = "Dear " + username + ",\n\n" +
	                      "Congratulations on completing the course: " + course + "!\n\n" +
	                      "Certificate and badge are attached.\n\nKeep learning with integrity!\n\n- Team LWI";

	        jakarta.mail.Session mailSession = MailUtil.getSession();
	        MimeMessage message = new MimeMessage(mailSession);
	        message.setFrom(new InternetAddress("noreply@lwi.com"));
	        message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
	        message.setSubject(subject);

	        MimeMultipart multipart = new MimeMultipart();

	        // Text
	        MimeBodyPart textPart = new MimeBodyPart();
	        textPart.setText(body);
	        multipart.addBodyPart(textPart);

	        // Badge
	        if (badgePath != null) {
	            MimeBodyPart imagePart = new MimeBodyPart();
	            imagePart.attachFile(badgePath);
	            multipart.addBodyPart(imagePart);
	        }

	        // Certificate (use DataHandler)
	        if (pdfBytes != null) {
	            MimeBodyPart pdfPart = new MimeBodyPart();
	            DataSource source = new ByteArrayDataSource(pdfBytes, "application/pdf");
	            pdfPart.setDataHandler(new DataHandler(source));
	            pdfPart.setFileName("certificate.pdf");
	            multipart.addBodyPart(pdfPart);
	        }

	        message.setContent(multipart);
	        Transport.send(message);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
/*
	public static void sendCompletionMail(String toEmail, String username, String course, byte[] pdfBytes, int badgeId, Connection con) {
	    try {
	        // Fetch badge path
	        String badgePath = null;
	        try (PreparedStatement ps = con.prepareStatement("SELECT image_path FROM badges WHERE badge_id=?")) {
	            ps.setInt(1, badgeId);
	            try (ResultSet rs = ps.executeQuery()) {
	                if (rs.next()) badgePath = rs.getString("image_path");
	            }
	        }

	        // Build mail
	        String subject = "Congratulations! You've completed " + course;
	        String body = "Dear " + username + ",\n\n" +
	                      "Congratulations on successfully completing the course: " + course + "!\n\n" +
	                      "Attached is your certificate of completion.\n" +
	                      "You have also earned a badge for your achievement.\n\n" +
	                      "Keep learning with integrity!\n\nBest Regards,\nTeam LWI";

	        // Send with Jakarta Mail
	        javax.mail.Session mailSession = MailUtil.getSession();
	        MimeMessage message = new MimeMessage(mailSession);
	        message.setFrom(new InternetAddress("noreply@lwi.com"));
	        message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
	        message.setSubject(subject);

	        // Multipart (text + badge + pdf)
	        MimeMultipart multipart = new MimeMultipart();

	        // Body
	        MimeBodyPart textPart = new MimeBodyPart();
	        textPart.setText(body);
	        multipart.addBodyPart(textPart);

	        // Badge image
	        if (badgePath != null) {
	            MimeBodyPart imagePart = new MimeBodyPart();
	            imagePart.attachFile(badgePath);
	            multipart.addBodyPart(imagePart);
	        }

	        // Certificate PDF
	        if (pdfBytes != null) {
	            MimeBodyPart pdfPart = new MimeBodyPart();
	            pdfPart.setFileName("certificate.pdf");
	            pdfPart.setContent(pdfBytes, "application/pdf");
	            multipart.addBodyPart(pdfPart);
	        }

	        message.setContent(multipart);
	        Transport.send(message);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
*/


}
