import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
public class AddPerson extends HttpServlet 
{
  private PreparedStatement pstmt;
  public void init() throws ServletException {
    initializeJdbc();
  }
  public void doPost(HttpServletRequest request, HttpServletResponse
      response) throws ServletException, IOException  
 {
	response.setContentType("text/html");
    PrintWriter out = response.getWriter();

    String PERSONID = request.getParameter("PERSONID");
    String NAME = request.getParameter("NAME");
    String SSN = request.getParameter("SSN");
    String DRIVERSLICENSENR = request.getParameter("DRIVERSLICENSENR");
    String BIRTHDATE= request.getParameter("BIRTHDATE");
	String BIRTHPLACE= request.getParameter("BIRTHPLACE");

    try 
	{
      if (PERSONID.length() == 0 || NAME.length() == 0) {
        out.println("Please: The person ID number and name are required");
        return; 
    }
    storePerson(PERSONID, NAME, SSN, DRIVERSLICENSENR, BIRTHDATE, BIRTHPLACE);
	out.println("<html><head><title>Person Registeration Report</title>");	 
	out.print( "<br /><b><center><font color=\"RED\"><H2>Person Registeration Report</H2></font>");
    out.println( "</center><br />" );
	out.println("</head><body>");
	out.println("<center><table border=\"1\">"); 
	out.println("<tr BGCOLOR=\"#cccccc\">");
    out.println("<td align = \"justify\"><font face =\"times new roman\"  size=\"4pt\">PERSON ID</td>");
    out.println("<td align = \"justify\"><font face =\"times new roman\"  size=\"4pt\">NAME</td>");
    out.println("</tr>");
	
	out.println("</table></center>");
		
    out.println(PERSONID + " " + NAME +
        " is now added to the PERSON table");
	out.println("</body></html>");
    }
    catch(Exception ex) 
	{
      out.println("\n Error: " + ex.getMessage());
    }
    finally 
	{
      out.close(); 
    }
 } 
  private void initializeJdbc() 
  {
    try 
	{
        String driver = "oracle.jdbc.driver.OracleDriver";  
        Class.forName(driver);
		// database URL is the unique identifier of the database on the Internet
		// thin is the oracle server
		String url = "jdbc:oracle:thin:@127.0.0.1:1521:orcl";
		String user = "CSIPROJECT";
		String password = "mohammed";  
		Connection conn = DriverManager.getConnection(url,user, password);  
		pstmt = conn.prepareStatement("insert into person " +
        "(PERSONID, NAME, SSN, DRIVERSLICENSENR, BIRTHDATE, BIRTHPLACE) values (?, ?, ?, ?, ?, ?)");
    }
    catch (Exception ex) 
	{
      ex.printStackTrace();
    }
  }

  
  private void storePerson(String PERSONID, String NAME,
      String SSN, String DRIVERSLICENSENR, String BIRTHDATE, String BIRTHPLACE) throws SQLException 
 {
    pstmt.setString(1, PERSONID);
    pstmt.setString(2, NAME);
    pstmt.setString(3, SSN);
    pstmt.setString(4, DRIVERSLICENSENR);
    pstmt.setString(5, BIRTHDATE);
    pstmt.setString(6, BIRTHPLACE);
    pstmt.executeUpdate();
 }
}
