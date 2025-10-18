package Module1; // use your package name

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

@WebListener
public class MySqlCleanupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Do nothing on startup
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // This will stop the MySQL cleanup thread when the app stops
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("MySQL cleanup thread stopped successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
