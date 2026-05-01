package Assignment7;
import java.sql.*;
public class Question1 {
public static void main(String[] args) {
try
{
String driver = "org.postgresql.Driver";
String url = "jdbc:postgresql://192.168.1.17/cse_db24";
String username= "24bcsa09";
String password = "24bcsa09";
Connection con =
DriverManager.getConnection(url,username,password);
if(con != null)
{
System.out.println("Connection Successful");
}
}
catch(Exception e)
{
System.out.println("e");
}}}
