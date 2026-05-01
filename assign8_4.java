import java.sql.*;
import java.util.*;;
public class Question4 {
public static void main(String[] args) {
Scanner ins = new Scanner(System.in);
System.out.print("Enter the roll_no: ");
int roll_no = ins.nextInt();
ins.nextLine();
System.out.print("Enter the name: ");
String name = ins.nextLine();
System.out.print("Enter your age: ");
int age = ins.nextInt();
ins.nextLine();
System.out.print("Enter the department: ");
String department = ins.nextLine();
System.out.print("Enter your cgpa: ");
double cgpa = ins.nextDouble();
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
ps.setInt(1,roll_no);
ps.setString(2,name);
ps.setInt(3, age);
ps.setString(4, department);
ps.setDouble(5, cgpa);
int i = ps.executeUpdate();
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