<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.io.IOException" import="java.sql.Connection" import="java.sql.DriverManager"
	import="java.sql.PreparedStatement" import="java.sql.ResultSet" import="java.sql.SQLException"%>
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
			position: absolute;
			color: #a51a1a;
			font-size: 35px;
			left: 5%;
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
		#coin{
			width: 7%;
			height: 10%;
			position: absolute;
			left: 50%;
			top: 15%;
		}
		#coins{
			position: absolute;
			z-index: 20;
			font-family: 'Germania One', cursive;
			text-shadow: 5px 5px black;
			font-size: 55px;
			color: white;
			left: 58%;
			top: 17%;
		}
		#highScore{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-shadow: 5px 5px black;
			font-size: 35px;
			top: 30%;
			left: 48%;
			color: white;
		}
		#store{
			color: white;
			z-index: 15;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 50px;
			top: 48%;
			left: 55%;
			text-shadow: 5px 5px black;
		}
		#rank{
			color: white;
			z-index: 15;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 50px;
			top: 63%;
			left: 55%;
			text-shadow: 5px 5px black;
		}
		#play{
			color: white;
			z-index: 15;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 60px;
			top: 73%;
			left: 20%;
			text-shadow: 5px 5px black;
		}
		#avatar{
			z-index: 20;
			position: absolute;
			top: 17%;
			left: 7%;
			height: 350px;
			width: 280px;
		}
</style>
<%
	String loggedIn = (String)session.getAttribute("loggedIn");
	String user = "";
	if(loggedIn.equals("true")){
		user = (String)session.getAttribute("user");
	} 
	
	//get user information from database
	int score = 0;
	int coins = 0;
	int avatar = 0;
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/game?user=root&password=root");
		ps = conn.prepareStatement("SELECT p.coins, p.score, p.avatarID FROM Player p WHERE p.username=?");
		ps.setString(1, user);
		rs = ps.executeQuery();
	
		while(rs.next()){
			coins = rs.getInt("coins");
			score = rs.getInt("score");
			avatar = rs.getInt("avatarID");
		}
	}catch(SQLException sqle) {
	}catch(ClassNotFoundException cnfe) {
	}finally {
		try {
			if(rs != null) rs.close();
			if(ps != null) ps.close();
			if(conn != null) conn.close();
		}catch (SQLException sqle) {
			System.out.println("Sqle: " + sqle.getMessage());
		}
	}
%>
	<head>
		<meta charset="UTF-8">
		<title>Profile</title>
		<link href="https://fonts.googleapis.com/css?family=Germania+One" rel="stylesheet">
		
		<script>
			function userData(){
				var avatar = <%=avatar%>;
				if(avatar == 1){
					document.getElementById("avatar").innerHTML = "<img id='avatar' src='assets/trojansprite.png'>";
				}
				else if(avatar ==2){
					document.getElementById("avatar").innerHTML = "<img id='avatar' src='assets/soldiersprite.png'>";
				}
				else if(avatar == 3){
					document.getElementById("avatar").innerHTML = "<img id='avatar' src='assets/vikingsprite.png'>";
				}
				else{
					document.getElementById("avatar").innerHTML = "<img id='avatar' src='assets/samuraisprite.png'>";
				}
			}
		</script>
	</head>
	<body onload="userData()">
		<div id="header">
				<h1><%=user.toUpperCase()%></h1> 
		</div>
		<div id="avatar"></div>
		
		<img id="coin" src="assets/goldcoin.png"> <div id="coins"><%=coins %></div>
		<div id="highScore">High Score: <%=score %>	</div>
		
		<div class="container">
			  <div class="red flame"></div>
			  <div class="orange flame"></div>
			  <div class="yellow flame"></div>
		</div>
		
		<div id="store"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/store.jsp" style="text-decoration:none">
				<font style="color:white">Store</font></a>        	</div>
		<div id="rank"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/rank.jsp" style="text-decoration:none">
				<font style="color:white">Rank</font></a>        	</div>
		<div id="play"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/game.html" style="text-decoration:none">
				<font style="color:white">PLAY</font></a>        	</div>
	</body>
</html>