<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
</style>
	<head>
		<meta charset="UTF-8">
		<title>Profile</title>
		<link href="https://fonts.googleapis.com/css?family=Germania+One" rel="stylesheet">
	</head>
	<body>
		<div id="header">
				<h1>USERNAME HERE</h1> 
		</div>
		<img id="coin" src="assets/goldcoin.png">
		<div id="highScore">High Score:
			<div id="score"></div>
		</div>
		
		<div class="container">
			  <div class="red flame"></div>
			  <div class="orange flame"></div>
			  <div class="yellow flame"></div>
		</div>
		
		<div id="store"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/store.jsp" style="text-decoration:none">
				<font style="color:white">Store</font></a>        	</div>
		<div id="rank"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/rank.jsp" style="text-decoration:none">
				<font style="color:white">Rank</font></a>        	</div>
		<div id="play"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/rank.jsp" style="text-decoration:none">
				<font style="color:white">PLAY</font></a>        	</div>
	</body>
</html>