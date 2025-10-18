package Module1;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class SendMailTest {
    public static void main(String[] args) {

        // Replace with your Gmail address and app password
        final String from = "sarunyakannan@gmail.com"; // your Gmail
        final String appPassword = "svae irtf daqn yakk"; // from Google App Passwords

        // Recipient's email
        final String to = "23ucs34@tcarts.in";

        // SMTP configuration
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Create a session with auth
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, appPassword);
            }
        });

        try {
            // Create email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(
                Message.RecipientType.TO, InternetAddress.parse(to)
            );
            message.setSubject("Test Mail from Java");
            message.setText("This is a test mail sent using Jakarta Mail API.");

            // Send email
            Transport.send(message);
            System.out.println("Email sent successfully!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
