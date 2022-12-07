import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
public class UpdateName extends HttpServlet 
{
	private PreparedStatement pstmt;
	//public void init() throws ServletException {
	//	initializeJdbc();
	//}
    public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException,IOException
    {        
			Statement state4 = null;
			ResultSet result = null;
			String query="";        
			Connection con=null;           
		String PERSONID = request.getParameter("PERSONID");
		String NAME = request.getParameter("NAME");
            
		if (PERSONID.length() == 0 || NAME.length() == 0) {
		System.out.println("Please: Owner ID and Name are required");
		return;
		}
		
		try
		{	
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver()); 
            con = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "CSIPROJECT", "mohammed");
	       	System.out.println("Congratulations! You are connected successfully.");      
      
			
     	}
        catch(SQLException e)
		{	
			System.out.println("Error: "+e);
			
			
			
		}
		catch(Exception e) 
		{
			System.err.println("Exception while loading  driver");		
		}
	    try 
		{
        	state4 = con.createStatement();
		} 
		catch (SQLException e) 	
		{
			System.err.println("SQLException while creating statement");			
		}
		
		response.setContentType("text/html");
		PrintWriter out = null ;
		try
		{
			out =  response.getWriter();
		}
		catch (IOException e) 
		{
  			e.printStackTrace();
		}
		
		query = "update person set Name = '"+ NAME +"' where personID = '"+ PERSONID +"'";											
      
		
		out.println("<html><head><title>  Name has been updated</title>");	 
		out.println("</head><body>");
		
		
		out.print( "<br /><b><center><font color=\"RED\"><H2>The following name has been updated in the database:</H2></font>");
		
        out.print(PERSONID + " " + NAME);
		
        out.println( "</center><br />" );
       	try 
		{ 
			result=state4.executeQuery(query);
				
	  	}
		catch (SQLException e) 
		{
			System.err.println("SQLException while executing SQL Statement."); 
		}
		
		try 
		{ 
   			result.close(); 
			state4.close(); 	
			con.close();
    		System.out.println("Connection is closed successfully.");
 	   	}
		catch (SQLException e) 
		{
			e.printStackTrace();	
		}

  		out.println("</body></html>");
    } 
}