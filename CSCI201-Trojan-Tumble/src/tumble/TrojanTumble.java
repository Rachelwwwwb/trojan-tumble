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

@WebServlet("/TrojanTumble")
public class TrojanTumble extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");

		String servUsername = request.getParameter("username").trim();
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

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login?user=root&password=root");
			ps = conn.prepareStatement("SELECT * FROM User WHERE username=? AND password=?");
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
			}
			
		}
		
	}
}
