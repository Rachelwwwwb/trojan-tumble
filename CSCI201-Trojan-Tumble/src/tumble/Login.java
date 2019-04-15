package tumble;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		
		String loggedIn = "false";
		String user = "";
		HttpSession session = request.getSession();
		session.setAttribute("loggedIn", loggedIn);
		session.setAttribute("user", user);
		
		String servUsername = request.getParameter("username").trim();
		servUsername = servUsername.toUpperCase();
		if(servUsername == null || servUsername.length() == 0) {
			request.setAttribute("loginError", "This user does not exist.");
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/login.jsp");
			dispatch.forward(request, response);
			return;
		}
		String servPW = request.getParameter("pw").trim();
		if(servPW == null || servPW.length() == 0) {
			request.setAttribute("loginError", "Incorrect password.");
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/login.jsp");
			dispatch.forward(request, response);
			return;
		}
		//hash the password
		//hashing the password here
		String passwordToHash = servPW;
		String generatedPassword = null;
		try {
		    MessageDigest md = MessageDigest.getInstance("MD5");
	        md.update(passwordToHash.getBytes());
	        byte[] bytes = md.digest();
	        StringBuilder sb = new StringBuilder();
	        for(int i=0; i< bytes.length ;i++)
	            {
	                sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
	            }
	            generatedPassword = sb.toString();
	            servPW = generatedPassword;
	        }
	        catch (NoSuchAlgorithmException e)
	        {
	            e.printStackTrace();
	        }
						
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String jdbcUrl = "jdbc:mysql://aagurobfnidxze.cesazkri7ef1.us-east-2.rds.amazonaws.com:3306/game?user=user&password=password";	
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl);
			ps = conn.prepareStatement("SELECT * FROM Player WHERE username=? AND password=?");
			ps.setString(1, servUsername);
			ps.setString(2, servPW);
			rs = ps.executeQuery();

			boolean foundUser = false;
			boolean foundPW = false;
			while(rs.next()) {	//iterate through all rows
				String dataUsername = rs.getString("username").trim();
				String dataPW = rs.getString("password").trim();
								
				if(dataUsername.equals(servUsername)) {
					foundUser = true;
					if(dataPW.equals(servPW)) {
						foundPW = true;
						request.setAttribute("currUsername", servUsername);
						loggedIn = "true";
						user = dataUsername;
						session.setAttribute("loggedIn", loggedIn);
						session.setAttribute("user", user);
						RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/profile.jsp");
						dispatch.forward(request, response);
						return;
					}
				}
			}
			if(!foundUser) {
				request.setAttribute("loginError", "This user does not exist.");
				RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/login.jsp");
				dispatch.forward(request, response);
				return;
			}
			else if(!foundPW) {
				request.setAttribute("loginError", "Incorrect password.");
				RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/login.jsp");
				dispatch.forward(request, response);
				return;
			}
		}catch(SQLException sqle) {
		}catch(ClassNotFoundException cnfe) {
		}finally {
			try {
				if(rs != null) rs.close();
				if(ps != null) ps.close();
				if(conn != null) conn.close();
			}catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
	}
}
