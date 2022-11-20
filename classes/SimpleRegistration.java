import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class SimpleRegistration extends HttpServlet {
  // Use a prepared statement to store a student into the database
  private PreparedStatement pstmt;

  /** Initialize global variables */
  /** Invoked for every servlet constructed. The init method is called when the servlet is first created, and is not called again as long as the servlet is not destroyed. */

  public void init() throws ServletException {
    initializeJdbc();
  }

  /** Process the HTTP Post request */
  /** Invoked to respond to incoming requests. The service method is invoked each time the server receives a request for the servlet. The server spawns (produce) a new thread and invokes service. */

  public void doPost(HttpServletRequest request, HttpServletResponse
      response) throws ServletException, IOException {
    response.setContentType("text/html");
    PrintWriter out = response.getWriter();

    // Obtain parameters from the client
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String mi = request.getParameter("mi");
    String phone = request.getParameter("telephone");
    String email = request.getParameter("email");
    String address = request.getParameter("street");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String zip = request.getParameter("zip");

    try {

		//out.println("First Name: " + firstName );
      if (lastName.length() == 0 || firstName.length() == 0) {
        out.println("<center>Please: Last Name and First Name are required</center>");
        return; // End the method
      }

      storeStudent(lastName, firstName, mi, phone, email, address,
        city, state, zip);
	  out.println("<center>");
      out.println(firstName + " " + lastName +
        " is now registered in the database");
		out.println("</center>");
    }
    catch(Exception ex) {
      out.println("\n Error: " + ex.getMessage());
    }
    finally {
      out.close(); // Close stream
    }
  }

  /** Initialize database connection */
  private void initializeJdbc() {
    try {
      // Declare driver and connection string
     // String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
     // String connectionString = "jdbc:odbc:exampleMDBDataSource";
      // For MySQL
      // String driver = "com.mysql.jdbc.Driver";
      // String connectionString = "jdbc:mysql://localhost/test";
      // For Oracle
       String driver = "oracle.jdbc.driver.OracleDriver";
       
      // Load the driver
      Class.forName(driver);

    String url = "jdbc:oracle:thin:@127.0.0.1:1521:orcl";
    String user = "CSIPROJECT";
    String password = "mohammed";

      // Connect to the sample database
      Connection conn = DriverManager.getConnection
        (url,user, password);
		
	//Disable auto-commit mode
	//conn.setAutoCommit(false);


      // Create a Statement
      pstmt = conn.prepareStatement("insert into Address " +
        "(lastName, firstName, mi, telephone, email, street, city, "
         + "state, zip) values (?, ?, ?, ?, ?, ?, ?, ?, ?)");
		 
		 // Commit the effect of all both the INSERT and UPDATE 
   // statements together 
   conn.commit();
   //conn.close();
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  /** Store a student record to the database */
  private void storeStudent(String lastName, String firstName,
      String mi, String phone, String email, String address,
      String city, String state, String zip) throws SQLException {
    pstmt.setString(1, lastName);
    pstmt.setString(2, firstName);
    pstmt.setString(3, mi);
    pstmt.setString(4, phone);
    pstmt.setString(5, email);
    pstmt.setString(6, address);
    pstmt.setString(7, city);
    pstmt.setString(8, state);
    pstmt.setString(9, zip);
    pstmt.executeUpdate();
	
	

  }
}
