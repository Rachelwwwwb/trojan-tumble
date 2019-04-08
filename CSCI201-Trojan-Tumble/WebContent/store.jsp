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
			color: #a51a1a;
			font-size: 60px;
			text-align: center;
		}
		#smoke{
			z-index: 1;
			top: 30%;
			left: 5%;
			position: absolute;
		}
		#avatars{
			background-color: #c1c5cc;
			position: absolute;
			z-index: 40;
			top: 10%;
			opacity: .9;
			color: black;
			font-size: 35px;
		}
		#coin{
			width: 7%;
			height: 1%;
		}
		#soldier, #samurai{
			width: 29%;
			height: 18%;
			opacity: .5;
		}
		#viking{
			width: 29%;
			height: 18%;
			opacity: .5;
		}
		#trojan{
			width: 29%;
			height: 18%;
		}
		#coins{
			position: absolute;
			height: 8%;
			width: 5%;
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
		#avatar{
			position: absolute;
			z-index: 20;
			height: 20%;
			width:20%;
			top: 10%;
			left: 10%;
		}
		#play{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 60px;
			top: 115%;
			left: 80%;
			text-shadow: 5px 5px black;
		}
		#profile{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 40px;
			top: 115%;
			left: 30%;
			text-shadow: 5px 5px black;
		}
		#coinCount{
			position: absolute;
			z-index: 20;
			font-family: 'Germania One', cursive;
			text-shadow: 5px 5px black;
			font-size: 45px;
			color: white;
			left: 6%;
			top: 38%;
		}
	</style>
<%
	String loggedIn = (String)session.getAttribute("loggedIn");
	String user = "";
	if(loggedIn.equals("true")){
		user = (String)session.getAttribute("user");
	} 
	
	//get user information from database
	int coins = 0;
	int avatar = 0;
	int player = 0;
	int soldier = 0, viking = 0, samurai = 0;
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/game?user=root&password=root");
		ps = conn.prepareStatement("SELECT p.playerID, p.coins, p.avatarID FROM Player p WHERE p.username=?");
		ps.setString(1, user);
		rs = ps.executeQuery();
	
		while(rs.next()){
			coins = rs.getInt("coins");
			avatar = rs.getInt("avatarID");
			player = rs.getInt("playerID");
		}
		ps = conn.prepareStatement("SELECT * FROM Purchased p WHERE p.playerID=?");
		ps.setInt(1, player);
		rs = ps.executeQuery();
	
		while(rs.next()){
			soldier = rs.getInt("hasSoldier");
			viking = rs.getInt("hasViking");
			samurai = rs.getInt("hasSamurai");
		}
	}catch(SQLException sqle) {
		System.out.println("sqle: " + sqle.getMessage());
	}catch(ClassNotFoundException cnfe) {
		System.out.println("cnfe: " + cnfe.getMessage());
	}finally {
		try {
			session.setAttribute("coins", coins);
			session.setAttribute("player", player);
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
			<title>Store</title>
			<link href="https://fonts.googleapis.com/css?family=Germania+One" rel="stylesheet">
		<script>
			var coins = <%=coins%>;
			var avatar = <%=avatar%>;
			function displayAffordable(){
				if(coins >= 10000 || <%=samurai%> == 1){
					document.getElementById("samurai").style.opacity = "1";
				}
				if(<%=samurai%> == 1){
					document.getElementById("samuraiPrice").innerHTML = "<img id='coin' src='assets/goldcoin.png'> 0";
				}
				if(coins >= 5000 || <%=viking%> == 1){
					document.getElementById("viking").style.opacity = "1";
				}
				if(<%=viking%> == 1){
					document.getElementById("vikingPrice").innerHTML = "<img id='coin' src='assets/goldcoin.png'> 0";
				}
				if(coins >= 2500 || <%=soldier%> == 1){
					document.getElementById("soldier").style.opacity = "1";
				}
				if(<%=soldier%> == 1){
					document.getElementById("sergeantPrice").innerHTML = "<img id='coin' src='assets/goldcoin.png'> 0";
				}
			}

			function checkCost(id){
				if(avatar == id){
					window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/profile.jsp");
				}
				if(id == 1){
					window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/TrojanTumble?update=true&id=1&cost=0");
				}
				else if(id == 2){ 
					if(<%=soldier%> != 1){	//don't have it: update profile avatar, profile coins, purchased
						//first check if they can afford it
						if(coins < 2500){
							window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/profile.jsp");
							return;
						}
						window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/TrojanTumble?update=true&id=2&cost=2500");
					}
					else{	//update profile avatar
						window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/TrojanTumble?update=true&id=2&cost=0");
					}
				}
				else if(id == 3){
					if(<%=viking%> != 1){
						if(coins < 5000){
							window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/profile.jsp");
							return;
						}
						window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/TrojanTumble?update=true&id=3&cost=5000");
					}
					else{
						window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/TrojanTumble?update=true&id=3&cost=0");
					}
				}
				else{
					if(<%=samurai%> != 1){
						if(coins < 10000){
							window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/profile.jsp");
							return;
						}
						window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/TrojanTumble?update=true&id=4&cost=10000");
					}
					else{
						window.location.replace("http://trojan-tumble.us-east-2.elasticbeanstalk.com/TrojanTumble?update=true&id=4&cost=0");
					}
				}
			} 

		</script>
		</head>
		<body onload="displayAffordable()">
			<div id="header">
				<h1> STORE </h1> 
			</div>
			<img id="smoke" src="assets/smoke.png"> 
			
			<div><img id="coins" src="assets/goldcoin.png"><div id="coinCount"><%=coins%></div></div>
			
			<table id="avatars" style="width:60%; padding: 3%; margin: 10%; border-radius: 15px; left:10%;">
				<tr>
					<td align="center">SAMURAI<br></td>
					<td align="center">VIKING<br></td>
				</tr>
				<tr>
					<td align="center">
						<img id="samurai" src="assets/samuraisprite.png" onclick="checkCost(4)"><br>
					</td>
					<td align="center">
						<img id="viking" src="assets/vikingsprite.png" onclick="checkCost(3)"><br>
					</td>
				</tr>
				<tr>
					<td align="center"><div id="samuraiPrice"><img id="coin" src="assets/goldcoin.png"> 10,000 </div><br></td>
					<td align="center"><div id="vikingPrice"><img id="coin" src="assets/goldcoin.png"> 5,000 </div><br></td>
				</tr>
				
				<tr>
					<td align="center">SERGEANT<br></td>
					<td align="center">TROJAN<br></td>
				</tr>
				<tr>
					<td align="center">
						<img id="soldier" src="assets/soldiersprite.png" onclick="checkCost(2)"><br>
					</td>
					<td align="center">
						<img id="trojan" src="assets/trojansprite.png" onclick="checkCost(1)"><br>
					</td>
				</tr>
				
				<tr>
					<td align="center"><div id="sergeantPrice"><img id="coin" src="assets/goldcoin.png"> 2,500</div></td>
					<td align="center"><img id="coin" src="assets/goldcoin.png"> 0</td>
				</tr>
			</table>
			<div id="play"><a href="http://trojan-tumble.us-east-2.elasticbeanstalk.com/game.html" style="text-decoration:none; color:white;">
				PLAY</a></div>
			<div id="profile"><a href="http://trojan-tumble.us-east-2.elasticbeanstalk.com/profile.jsp" style="text-decoration:none; color:white;">
				Profile</a>        	</div>
			
			<div class="container">
			  <div class="red flame"></div>
			  <div class="orange flame"></div>
			  <div class="yellow flame"></div>
		</div>
		</body>
</html>