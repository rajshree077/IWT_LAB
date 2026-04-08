package mypack;

import java.sql.*;
import java.util.Scanner;

public class Insert_records_scanner {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.println("Rollno:");
        int rollno = sc.nextInt();
        sc.nextLine(); 

        System.out.println("Name:");
        String name = sc.nextLine();

        System.out.println("Age:");
        int age = sc.nextInt();
        sc.nextLine(); 

        System.out.println("Department:");
        String department = sc.nextLine();

        System.out.println("CGPA:");
        double cgpa = sc.nextDouble();

        try {
            String driver = "org.postgresql.Driver";
            String url = "jdbc:postgresql://192.168.1.17/cse_db24";
            String username = "24bcsf53";
            String password = "24bcsf53";

            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, username, password);

            if (con != null) {
                System.out.println("Connection established successfully");
            }

            String qry = "INSERT INTO student1(rollno, name, age, department, cgpa) VALUES(?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(qry);

            ps.setInt(1, rollno);
            ps.setString(2, name);
            ps.setInt(3, age);
            ps.setString(4, department);
            ps.setDouble(5, cgpa);

            int i = ps.executeUpdate();
            if (i == 1) {
                System.out.println("Record Inserted successfully");
            }

            ps.close();
            con.close();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
