package Module1;

import java.sql.*;
public class DbConnection {
	public static Connection getConnection() {
		Connection con=null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/lms","root","");
			//System.out.println("Reached Dbconnection");	
			}
		catch(Exception e) {
			e.printStackTrace();
		}
		return con;
	}

}