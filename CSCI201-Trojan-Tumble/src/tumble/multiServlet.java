package tumble;

import java.io.IOException;
import java.io.PrintWriter;
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

/**
* Servlet implementation class servlet
*/
@WebServlet("/multiServlet")
public class multiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

   /**
    * @see HttpServlet#HttpServlet()
    */
   public multiServlet() {
       super();
       // TODO Auto-generated constructor stub
   }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        
        
        String currID = request.getParameter("currentID");
        int currentID = Integer.parseInt(currID);
        String start = request.getParameter("start");
        String name = request.getParameter("name");

        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        String jdbcUrl = "jdbc:mysql://aagurobfnidxze.cesazkri7ef1.us-east-2.rds.amazonaws.com:3306/game?user=user&password=password";    
        String returnVal = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcUrl);
            //if (start.trim() != null) {
                //insert and find the player’s id
                //ps = conn.prepareStatement("INSERT INTO Threads (username) VALUES (‘"+ name+ "’);");
                //rs = ps.executeQuery();
                //System.out.println("here”);
                //find out the id
//                ps = conn.prepareStatement("SELECT COUNT (username) FROM Threads”);
//                rs = ps.executeQuery();
                //while(rs.next()) {    //if found any
                //    returnVal = "1”;
                //}

            //.conn.}
            //else {
                ps = conn.prepareStatement("SELECT * FROM Threads WHERE threadID=?");
                
                ps.setInt(1, currentID+1);
                rs = ps.executeQuery();
    
                while(rs.next()) {    //if found any
                    returnVal = rs.getString("username").trim();
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

        response.setContentType("text/html");
        out.print(returnVal);
        out.flush();
        out.close();
        
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doGet(request, response);
    }

}