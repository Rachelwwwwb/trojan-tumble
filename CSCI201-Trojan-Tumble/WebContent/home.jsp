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
		#fire{
			z-index: 15;
			position: absolute;
			z-index: 5;
			left: 37%;
			top: 67%;
			width: 30%;
		}
		#playGuest{
			z-index: 20;
			text-align: center;
			position: absolute;
			left: 40%;
			top: 65%;
			vertical-align: middle;
		}
		h3{
			color: white;
			font-size: 60px;
			text-shadow: 5px 5px black;
			font-family: 'Germania One', cursive;
		}
		#login{
			z-index: 15;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 60px;
			position: absolute;
			top: 85%;
			left: 33%;
			text-shadow: 5px 5px black;
		}
		#rank{
			z-index: 15;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 60px;
			position: absolute;
			top: 85%;
			left: 60%;
			text-shadow: 5px 5px black;
		}
		#trojan{
			z-index: 40;
			height: 40%;
			width: 20%;
			position:absolute;
			left: 40%;
			top: 30%;
			animation: move 1s infinite alternate forwards;	
		}
		@keyframes move{
			0% {
				transform: translateX(-25px)
				}
			50% {
				transform: translateX(25px)
				}
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
	</style>
		<head>
			<title>Home</title>
			<link href="https://fonts.googleapis.com/css?family=Germania+One" rel="stylesheet">

		</head>
		<body>
			<div id="header">
				<h1> Trojan Tumble</h1> 
			</div>
			<img id="trojan" src="assets/trojansprite.png">
			<img id="smoke" src="assets/smoke.png"> 
			<img id="fire" src="assets/fire.png"> 
			<div id="playGuest"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/game.html" style="text-decoration:none">
				<h3>Play As Guest</h3></a></div> 
			<div id="login"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/login.jsp" style="text-decoration:none">
				<font style="color:white">Login</font></a>        	</div>
			<div id="rank"><a href="http://localhost:8080/CSCI201-Trojan-Tumble/rank.jsp" style="text-decoration:none">
				<font style="color:white">Rank</font></a>        	</div>
			<div class="container">
			  <div class="red flame"></div>
			  <div class="orange flame"></div>
			  <div class="yellow flame"></div>
			</div>
		</body>
</html>