<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.io.IOException" import="java.sql.Connection" import="java.sql.DriverManager"
	import="java.sql.PreparedStatement" import="java.sql.ResultSet" import="java.sql.SQLException" import="java.sql.*"%>
<!DOCTYPE html>
	<html>
	<style>
		body{
			background-image: url("assets/dungeon.png");
			font-family: 'Germania One', cursive;
		}
		h1{
			z-index: 20;
			font-family: 'Germania One', cursive;
			text-shadow: 5px 5px black;
		}
		#header{
			z-index: 20;
			color: #a51a1a;
			font-size: 50px;
			text-align: center;
		}
		#smoke{
			z-index: 1;
			top: 30%;
			left: 5%;
			position: absolute;
		}
		#ranks{
			background-color: #c1c5cc;
			position: absolute;
			z-index: 40;
			top: 5%;
			opacity: .9;
			color: black;
			font-size: 30px;
		}
		tr{
			height: 50px;

		}
		.container{
		  margin:80px auto;
		  width: 60px;
		  height: 60px;
		  position:absolute;
		  left: 80%;
		  top: 35%;
		  transform-origin:center bottom;
		  animation-name: flicker;
		  animation-duration:3ms;
		  animation-delay:200ms;
		  animation-timing-function: ease-in;
		  animation-iteration-count: infinite;
		  animation-direction: alternate;
		}
		.flame{
		  bottom:0;
		  position:absolute;
		  border-bottom-right-radius: 50%;
		  border-bottom-left-radius: 50%;
		  border-top-left-radius: 50%;
		  transform:rotate(-45deg) scale(1.5,1.5);
		}
		.yellow{
		  left:15px; 
		  width: 30px;
		  height: 30px;
		  background:gold;
		  box-shadow: 0px 0px 9px 4px gold;
		}
		.orange{
		  left:10px; 
		  width: 40px;
		  height: 40px;
		  background:orange;
		  box-shadow: 0px 0px 9px 4px orange;
		}		
		.red{
		  left:5px;
		  width: 50px;
		  height: 50px;
		  background:OrangeRed;
		  box-shadow: 0px 0px 5px 4px OrangeRed;
		}		
		@keyframes flicker{
		  0%   {transform: rotate(-1deg);}
		  20%  {transform: rotate(1deg);}
		  40%  {transform: rotate(-1deg);}
		  60%  {transform: rotate(1deg) scaleY(1.04);}
		  80%  {transform: rotate(-2deg) scaleY(0.92);}
		  100% {transform: rotate(1deg);}
		}
		#play{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 60px;
			top: 88%;
			left: 80%;
			text-shadow: 5px 5px black;
		}
		#store{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 40px;
			top: 90%;
			left: 50%;
			text-shadow: 5px 5px black;
		}
		#profile{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 40px;
			top: 90%;
			left: 30%;
			text-shadow: 5px 5px black;
		}
	</style>
<%	
	String loggedIn = (String)session.getAttribute("loggedIn");
%>
		<head>
			<meta charset="UTF-8">
			<title>Rank</title>
			<link href="https://fonts.googleapis.com/css?family=Germania+One" rel="stylesheet">
			<script>
				function fillRanks(){
					<%
					String jdbcUrl = "jdbc:mysql://aagurobfnidxze.cesazkri7ef1.us-east-2.rds.amazonaws.com:3306/ebdb?user=user&password=password";					
					
					String[] players = new String[10];
					int[] score = new int[10];
					Connection conn = null;
					PreparedStatement ps = null;
					ResultSet rs = null;
					
					try {
						Class.forName("com.mysql.cj.jdbc.Driver");
						System.out.println("Driver loaded");
						conn = DriverManager.getConnection(jdbcUrl); //"jdbc:mysql://localhost:3306/game?user=root&password=root"
						System.out.println("connected");
						ps = conn.prepareStatement("SELECT p.username, p.score FROM Ranking r, Player p WHERE r.playerID=p.playerID ORDER BY p.score DESC");
						rs = ps.executeQuery();
						System.out.println("executed");
						int i=0;
						while(rs.next()) {	//iterate through all rows
							String p = rs.getString("username");
							int s = rs.getInt("score");
							players[i] = p.toUpperCase();
							score[i] = s;
							i++;
						} 
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
							System.out.println("sqle: " + sqle.getMessage());
						}
					}
					%>
					logInDisplay();
				}
				
				function logInDisplay(){
					var loggedIn = <%=loggedIn%>;
					if(loggedIn == true){
						document.getElementById("profile").style.visibility = "visible";
						document.getElementById("store").style.visibility = "visible";
					}
				}
			</script>
		</head>
		<body onload="fillRanks()">
			<div id="header">
				<h1> LEADERBOARD </h1> 
			</div>
			<img id="smoke" src="assets/smoke.png"> 
			
			<table id="ranks" style="width:60%; margin: 10%; border-radius: 15px; left:10%;">
<%
			for(int i=1; i<=10; i++){
				out.println("<tr>");
				out.println("<td align='center' width='100px'>" + i + "</td>");
				out.println("<td width='200px'></td>");
				out.println("<td align='left'>" + players[i-1]  + "</td>");
				out.println("<td align='left'>" + score[i-1] + "</td>");
				out.println("</tr>");
			}
%>
		</table>
			<div id="play">
				<a href="http://trojan-tumble.us-east-2.elasticbeanstalk.com/game.html" style="text-decoration:none; color: white;">
					PLAY </a>
			</div>
			<div id="profile" style="position: absolute; visibility: hidden;">
				<a href="http://trojan-tumble.us-east-2.elasticbeanstalk.com/profile.jsp" style="text-decoration:none; color: white;">
				Profile</a>        	</div>
			<div id="store" style="position: absolute; visibility: hidden;">
				<a href="http://trojan-tumble.us-east-2.elasticbeanstalk.com/store.jsp" style="text-decoration:none; color: white;">
				Store</a>        	</div>
			<div class="container">
			  <div class="red flame"></div>
			  <div class="orange flame"></div>
			  <div class="yellow flame"></div>
			</div>
		</body>
</html>