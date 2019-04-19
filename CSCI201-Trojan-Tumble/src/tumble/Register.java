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


@WebServlet("/Register")
public class Register extends HttpServlet {
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
		
		//hashing the password here
		String passwordToHash = servPW;
        String generatedPassword = null;
        try {
            // Create MessageDigest instance for MD5
            MessageDigest md = MessageDigest.getInstance("MD5");
            //Add password bytes to digest
            md.update(passwordToHash.getBytes());
            //Get the hash's bytes
            byte[] bytes = md.digest();
            //This bytes[] has bytes in decimal format;
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
		int score = 0;
		int coins = 0;
		String played = (String)session.getAttribute("played");
		
		if(played != null) {
			if(played.equals("true")) {
				score = (int)session.getAttribute("gameScore");
				coins = (int)session.getAttribute("coinsCollected");
			}
		}
		
		String jdbcUrl = "jdbc:mysql://aagurobfnidxze.cesazkri7ef1.us-east-2.rds.amazonaws.com:3306/game?user=user&password=password";					
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			System.out.println("Driver loaded");
			conn = DriverManager.getConnection(jdbcUrl);
			ps = conn.prepareStatement("SELECT * FROM Player WHERE username=?");
			ps.setString(1, servUsername);
			rs = ps.executeQuery();
			System.out.println("executed");
			
			boolean foundUser = false;
			while(rs.next()) {	//iterate through all rows
				String dataUsername = rs.getString("username").trim();
				if(dataUsername.equalsIgnoreCase(servUsername)) {
					foundUser = true;
				}
			}
			if(foundUser) {
				request.setAttribute("error", "This username is already taken.");
				RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/register.jsp");
				dispatch.forward(request, response);
				return;
			}
			ps = conn.prepareStatement("INSERT INTO Player(username,password,coins,score,avatarID) VALUES(?,?,?,?,1)");
			ps.setString(1, servUsername);
			ps.setString(2, servPW);
			ps.setInt(3, coins);
			ps.setInt(4, score);
			ps.execute();
			
			//get playerID from Player Table
			int player = 0;
			ps = conn.prepareStatement("SELECT * FROM Player WHERE username=?");
			ps.setString(1, servUsername);
			rs = ps.executeQuery();
			while(rs.next()) {
				String dataUsername = rs.getString("username").trim();
				int dataID = rs.getInt("playerID");
				if(dataUsername.equalsIgnoreCase(servUsername)) {
					player = dataID;
				}
			}
			
			// update ranking
			ps = conn.prepareStatement("SELECT p.playerID, p.score FROM Player p, Ranking r WHERE p.playerID=r.playerID ORDER BY p.score DESC");
			rs = ps.executeQuery();
			
			boolean onRanking = false;
			
			int[] scores = new int[10];
			int[] players = new int[10];
			int i=0;
			while(rs.next()){
				scores[i] = rs.getInt("score");
				players[i] = rs.getInt("playerID");
				if(players[i] == player){
					onRanking = true;
				}
				i++;
			}
			int min = 0;
			int j;
			for(j=1; j<10; j++){
				if(scores[j] < scores[min]){
					min = j;
				}
			}
			if(score > scores[min]){
				if(!onRanking){
					ps = conn.prepareStatement("UPDATE Ranking SET playerID=? WHERE playerID=?");
					ps.setInt(1, player);
					ps.setInt(2, players[min]);
					ps.execute();
				}
				else{//update score
					ps = conn.prepareStatement("UPDATE Ranking SET score=? WHERE playerID=?");
					ps.setInt(1, score);
					ps.setInt(2, player);
					ps.execute();
				}
			}		
			
			ps = conn.prepareStatement("INSERT INTO Purchased(playerID,hasSoldier,hasViking,hasSamurai) VALUES(?,0,0,0)");
			ps.setInt(1, player);
			ps.execute();
			request.setAttribute("currUsername", servUsername);
			loggedIn = "true";
			user = servUsername;
			session.setAttribute("loggedIn", loggedIn);
			session.setAttribute("user", user);
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/profile.jsp");
			dispatch.forward(request, response);
			
			//return;
		}catch(SQLException sqle) {
			System.out.println("sqle: " + sqle.getMessage());
		}catch(ClassNotFoundException cnfe) {
			System.out.println("cnfe: " + cnfe.getMessage());
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
