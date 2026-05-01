package Assignment7;
import java.sql.*;
public class Question2 {
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
String qry = "create table student (roll_no numeric(8,0) , name
varchar(50) , age numeric(4,0) , department varchar(30) , cgpa numeric(5,2) )";
PreparedStatement ps = con.prepareStatement(qry);
int i = ps.executeUpdate();
if(i == 0)
{
System.out.println("Table Creation Successful");
}
ps.close();
con.close();
}
catch(Exception e)
{
System.out.println(e);
}
}
}