package mypack;
import java.sql.*;
public class table_student{
	public static void main(String args[]) {
		try {
			String driver="org.postgresql.Driver";
			String url="jdbc:postgresql://192.168.1.17/cse_db24";
			String username="24bcsf53";
			String password="24bcsf53";
			Class.forName(driver);
			Connection con = DriverManager.getConnection(url, username, password);
			if(con!=null) {
				System.out.println("Connection established successfully");
			}
			String query = "CREATE TABLE STUDENT1("
					+ "rollno INT PRIMARY KEY,"
					+ "name VARCHAR(50),"
					+ "age INT,"
					+ "department VARCHAR(30),"
					+ "cgpa NUMERIC(4,2))";
			Statement stmt = con.createStatement();
            stmt.executeUpdate(query);       
            System.out.println("Table 'student2' created successfully!");
               
            stmt.close();
            con.close();
           
		}
		catch(Exception e) {
			System.out.println(e);
		}
	}
}
