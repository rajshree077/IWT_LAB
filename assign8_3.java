package Assignment7;
import java.sql.*;
public class Question3 {
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
values(?,?,?,?,?)";
String qry = "insert into student(roll_no , name, age,department, cgpa)
PreparedStatement ps = con.prepareStatement(qry);
ps.setInt(1,34);
ps.setString(2,"Arpit");
ps.setInt(3, 21);
ps.setString(4, "cse");
ps.setFloat(5, 8);
int i = ps.executeUpdate();
ps.setInt(1,3);
ps.setString(2,"purav");
ps.setInt(3, 21);
ps.setString(4, "ece");
ps.setFloat(5, 9);
i = ps.executeUpdate();
if(i == 1)
{
System.out.println("Record Insertion Successful");
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