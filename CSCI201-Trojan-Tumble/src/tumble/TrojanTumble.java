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
import javax.servlet.http.HttpSession;

@WebServlet("/TrojanTumble")
public class TrojanTumble extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		
		String update = request.getParameter("update");
		if(update!= null && update.equals("true")) {
			String ID = request.getParameter("id");
			int id = Integer.parseInt(ID);
			String Cost = request.getParameter("cost");
			int cost = Integer.parseInt(Cost);
			HttpSession session = request.getSession();
			int coins = (int)session.getAttribute("coins");
			int player = (int)session.getAttribute("player");
			updateData(id, cost, coins, player, session);
			session.setAttribute("avatar", id);
			
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/profile.jsp");
			dispatch.forward(request, response);
			return;
		}
		else if(update!= null && update.equals("results")){
			String coinCount = request.getParameter("coins");
			int coins = Integer.parseInt(coinCount);
			String scoreCount = request.getParameter("score");
			int score = Integer.parseInt(scoreCount);
			HttpSession session = request.getSession();
			session.setAttribute("coinsCollected", coins);
			session.setAttribute("gameScore", score);
			
			String user = (String)session.getAttribute("user");
			
			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			
			int prevScore = 0;
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://aagurobfnidxze.cesazkri7ef1.us-east-2.rds.amazonaws.com:3306/game?user=user&password=password");
				
				// get previous score
				ps = conn.prepareStatement("SELECT p.score FROM Player p WHERE p.username=?");
				ps.setString(1, user);
				rs = ps.executeQuery();
			
				while(rs.next()){
					prevScore = rs.getInt("score");
				}
				
				session.setAttribute("prevScore", prevScore);
				if(prevScore < score) {
					ps = conn.prepareStatement("UPDATE Player SET score=? WHERE username=?");
					ps.setInt(1, score);
					ps.setString(2, user);
					ps.execute();
				}				
			}catch(SQLException sqle) {
				System.out.println("sqle results: " + sqle.getMessage());
			}catch(ClassNotFoundException cnfe) {
				System.out.println("cnfe results: " + cnfe.getMessage());
			}finally {
				try {
					if(rs != null) rs.close();
					if(ps != null) ps.close();
					if(conn != null) conn.close();
				}catch (SQLException sqle) {
					System.out.println("Sqle: " + sqle.getMessage());
				}
			}
			
			
			
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/results.jsp");
			dispatch.forward(request, response);
			return;
		}
		else {
			String loggedIn = "false";
			String user = "";
			HttpSession session = request.getSession();
			
			session.setAttribute("loggedIn", loggedIn);
			session.setAttribute("user", user);
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/home.jsp");
			dispatch.forward(request, response);
			return;
		}
	}
	
	public void updateData(int id, int cost, int coins, int player, HttpSession session) {
		//id: new avatarID in player, change avatar to purchased
		//cost: amount to decrement coins
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String user = (String)session.getAttribute("user");
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://aagurobfnidxze.cesazkri7ef1.us-east-2.rds.amazonaws.com:3306/game?user=user&password=password");
			ps = conn.prepareStatement("UPDATE Player SET coins=?, avatarID=? WHERE username=?");
			ps.setInt(1, coins-cost);
			ps.setInt(2, id);
			ps.setString(3, user);
			ps.execute();
		
			if(id == 1) return;
			else if(id == 2)
				ps = conn.prepareStatement("UPDATE Purchased SET hasSoldier=? WHERE playerID=?");
			else if(id == 3)
				ps = conn.prepareStatement("UPDATE Purchased SET hasViking=? WHERE playerID=?");
			else if(id == 4)
				ps = conn.prepareStatement("UPDATE Purchased SET hasSamurai=? WHERE playerID=?");
			ps.setInt(1, 1);
			ps.setInt(2, player);
			ps.execute();
			
		}catch(SQLException sqle) {
			System.out.println("sqle: " + sqle.getMessage());
		}catch(ClassNotFoundException cnfe) {
			System.out.println("cnfe: " + cnfe.getMessage());
		}finally {
			try {
				if(ps != null) ps.close();
				if(conn != null) conn.close();
			}catch (SQLException sqle) {
				System.out.println("Sqle: " + sqle.getMessage());
			}
		}
	}

}
