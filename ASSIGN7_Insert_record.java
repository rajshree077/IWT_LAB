package mypack;

import java.sql.*;

public class Insert_record {

    public static void main(String[] args) {
        String driver = "org.postgresql.Driver";
        String url = "jdbc:postgresql://192.168.1.17/cse_db24";
        String username = "24bcsf53";
        String password = "24bcsf53";

        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, username, password);
            
            if (con != null) {
                System.out.println("Connection established successfully");
                Statement stmt = con.createStatement();
                String qry1 = "INSERT INTO student1 " +
                              "VALUES (101, 'Rajshree Panda', 20, 'CSE', 8.50)";
                String qry2 = "INSERT INTO student1 " +
                              "VALUES (102, 'Anmisha Dash', 21, 'IT', 9.10)";
                stmt.executeUpdate(qry1);
                stmt.executeUpdate(qry2);
                System.out.println("Two records inserted successfully (hard-coded).");
                stmt.close();
                con.close();
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    }
}
