package tumble;

import java.io.IOException;
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


@WebServlet("/Register")
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
	
	String servUsername = request.getParameter("username").trim();
	if(servUsername == null || servUsername.length() == 0) {
		request.setAttribute("error", "Enter a valid username.");
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/register.jsp");
		dispatch.forward(request, response);
		return;
	}
	String servPW = request.getParameter("pw").trim();
	String servCPW = request.getParameter("cpw").trim();
	
	if(servPW == null || servPW.length() == 0) {
		request.setAttribute("error", "Enter a valid password.");
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/register.jsp");
		dispatch.forward(request, response);
		return;
	}
	if(servCPW == null || servCPW.length() == 0) {
		request.setAttribute("error", "Confirm your password.");
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/register.jsp");
		dispatch.forward(request, response);
		return;
	}
	if(!servPW.equals(servCPW)) {
		request.setAttribute("error", "Passwords do not match.");
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/register.jsp");
		dispatch.forward(request, response);
		return;
	}
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login?user=root&password=root");
		ps = conn.prepareStatement("SELECT * FROM User WHERE username=?");
		ps.setString(1, servUsername);
		rs = ps.executeQuery();
		
		boolean foundUser = false;
		while(rs.next()) {	//iterate through all rows
			String dataUsername = rs.getString("username").trim();
			if(dataUsername.equals(servUsername)) {
				foundUser = true;
			}
		}
		if(foundUser) {
			request.setAttribute("error", "This username is already taken.");
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/register.jsp");
			dispatch.forward(request, response);
			return;
		}
		ps = conn.prepareStatement("INSERT INTO User(username,password) VALUES(?, ?)");
		ps.setString(1, servUsername);
		ps.setString(2, servPW);
		ps.execute();
		request.setAttribute("currUsername", servUsername);
	}catch(SQLException sqle) {
	}catch(ClassNotFoundException cnfe) {
	}finally {
		try {
			if(rs != null) rs.close();
			if(ps != null) ps.close();
			if(conn != null) conn.close();
		}catch (SQLException sqle) {
		}
	}
}

}
