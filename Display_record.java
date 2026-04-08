package mypack;

import java.sql.*;

public class Display_record {
    public static void main(String[] args) {
        String driver = "org.postgresql.Driver";
        String url = "jdbc:postgresql://192.168.1.17/cse_db24";
        String username = "24bcsf53";
        String password = "24bcsf53";
        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, username, password);

            if (con != null) {
                System.out.println("Connection established successfully\n");

                String qry = "SELECT * FROM student1";
                PreparedStatement ps = con.prepareStatement(qry);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    System.out.println("Roll No: " + rs.getInt("rollno"));
                    System.out.println("Name: " + rs.getString("name"));
                    System.out.println("Age: " + rs.getInt("age"));
                    System.out.println("Department: " + rs.getString("department"));
                    System.out.println("CGPA: " + rs.getDouble("cgpa"));
                    System.out.println("---------------------------");
                }
                rs.close();
                ps.close();
                con.close();
            }
        } catch (ClassNotFoundException e) {
            System.out.println("PostgreSQL Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("General error: " + e.getMessage());
        }
    }
}
