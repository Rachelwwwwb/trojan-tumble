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
			font-size: 50px;
			left: 15%;
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
			top: 25%;
		}
		#coins{
			position: absolute;
			z-index: 20;
			font-family: 'Germania One', cursive;
			text-shadow: 5px 5px black;
			font-size: 55px;
			color: white;
			left: 58%;
			top: 27%;
		}
		#Score{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-shadow: 5px 5px black;
			font-size: 40px;
			top: 45%;
			left: 50%;
			color: white;
		}
		#collected{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-shadow: 5px 5px black;
			font-size: 30px;
			top: 35%;
			left: 58%;
			color: white;
		}
		#next{
			color: white;
			z-index: 15;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 60px;
			top: 77%;
			left: 40%;
			text-shadow: 5px 5px black;
		}
		#store{
			color: white;
			z-index: 15;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 60px;
			top: 77%;
			left: 20%;
			text-shadow: 5px 5px black;
		}
		#save{
			color: white;
			z-index: 15;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 50px;
			top: 75%;
			left: 53%;
			text-shadow: 5px 5px black;
		}
		#avatar{
			z-index: 20;
			position: absolute;
			top: 17%;
			left: 10%;
			height: 400px;
			width: 330px;
		}
		#confetti{
			z-index: 40;
			position: absolute;
			top: 29%;
			left: 7%;
		}
		#confettiPNG{
			height: 40%;
			width: 40%;

		}
		#highScore{
			z-index: 20;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-shadow: 5px 5px black;
			font-size: 55px;
			top: 55%;
			left: 50%;
			color: #a51a1a;
		}
</style>
<%
	String loggedIn = (String)session.getAttribute("loggedIn");
	int gameScore = (int)session.getAttribute("gameScore"); 
	int coinsCollected = (int)session.getAttribute("coinsCollected");
	int prevScore = (int)session.getAttribute("prevScore");
	String played = "true";
	session.setAttribute("played", played);
	int score = 0;
	int coins = 0;
	int avatar = 1;
	int player = 0;
	String user = "";
	if(loggedIn.equals("true")){
		user = (String)session.getAttribute("user"); 
	
		//get user information from database
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://aagurobfnidxze.cesazkri7ef1.us-east-2.rds.amazonaws.com:3306/game?user=user&password=password");
			ps = conn.prepareStatement("SELECT p.playerID, p.coins, p.score, p.avatarID FROM Player p WHERE p.username=?");
			ps.setString(1, user);
			rs = ps.executeQuery();
		
			while(rs.next()){
				player = rs.getInt("playerID");
				coins = rs.getInt("coins");
				score = rs.getInt("score");
				avatar = rs.getInt("avatarID");
			}
			
			ps = conn.prepareStatement("UPDATE Player SET coins=? WHERE username=?");
			ps.setInt(1, coins+coinsCollected);
			ps.setString(2, user);
			ps.execute();
			
			if(gameScore > prevScore){	//check ranking table
				ps = conn.prepareStatement("SELECT p.playerID, p.score FROM Player p, Ranking r WHERE p.playerID=r.playerID ORDER BY p.score DESC");
				rs = ps.executeQuery();
				
				/*
				ps = conn.prepareStatement("UPDATE Player SET score=? WHERE username=?");
				ps.setInt(1, gameScore);
				ps.setString(2, user);
				ps.execute();*/
				
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
				if(gameScore > scores[min]){
					if(!onRanking){
						ps = conn.prepareStatement("UPDATE Ranking SET playerID=? WHERE playerID=?");
						ps.setInt(1, player);
						ps.setInt(2, players[min]);
						ps.execute();
					}
					else{//update score
						ps = conn.prepareStatement("UPDATE Ranking SET score=? WHERE playerID=?");
						ps.setInt(1, gameScore);
						ps.setInt(2, player);
						ps.execute();
					}
				}
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
	}
%>
	<head>
		<meta charset="UTF-8">
		<title>Results</title>
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
				//if logged in 
				if(<%=loggedIn%> == true){
					document.getElementById("header").innerHTML = "<h1>" + "<%=user.toUpperCase()%>" + "</h1>";
					newHighScore();
					displayButtons();
				}
				else{
					document.getElementById("header").innerHTML = "<h1>RESULTS</h1>";
				}
			}
			function newHighScore(){
				console.log("newHighScore");
				console.log("scores: " + <%=gameScore %> + " " + <%=prevScore %>);
				if(<%=gameScore %> > <%= prevScore %>){
					//display confetti and message
					document.getElementById("confetti").style.visibility = "visible";
					document.getElementById("highScore").style.visibility = "visible";
				}
			}
			function displayButtons(){
				console.log("displayButtons");
				document.getElementById("store").style.visibility = "visible";
				document.getElementById("save").style.visibility = "hidden";
			}
		</script>
	</head>
	<body onload="userData()">
		<div id="header"></div>
		<div id="avatar"></div>
		<div id="confetti" style="visibility:hidden;"><img id="confettiPNG" src="assets/confetti.png"></div>
		
		<img id="coin" src="assets/goldcoin.png"> <div id="coins"><%=coinsCollected %></div><br>
		<div id="collected">COINS COLLECTED</div>
		<div id="Score">SCORE: <%=gameScore%> </div>
		<div id="highScore" style="visibility:hidden;">NEW HIGH SCORE!</div>
		
		<div class="container">
			  <div class="red flame"></div>
			  <div class="orange flame"></div>
			  <div class="yellow flame"></div>
		</div>
		
		<div id="store"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/store.jsp" style="text-decoration:none; visibility:hidden;">
				<font style="color:white">Store</font></a>        	</div>
		<div id="next"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/rank.jsp" style="text-decoration:none">
				<font style="color:white">Next</font></a>    	</div>
		<div id="save"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/register.jsp" style="text-decoration:none">
				<font style="color:white">Save My Game</font></a>  </div>
	</body>
</html>