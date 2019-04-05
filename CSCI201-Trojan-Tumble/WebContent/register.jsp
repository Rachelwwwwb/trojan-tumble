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
		#register{
			color: white;
			z-index: 15;
			position: absolute;
			font-family: 'Germania One', cursive;
			text-align: center;
			font-size: 40px;
			top: 75%;
			left: 45%;
			text-shadow: 5px 5px black;
		}
		::placeholder{
			color: white;
			opacity: .5;
			font-family: 'Germania One', cursive;
		}
		#username, #pw, #cpw{
			position: absolute;
			z-index: 40;
			color: white;
			width: 450px;
			height: 40px;
			font-size: 25px;
			border-radius: 15px;
			font-style: italic;
			padding: 15px;
			background-color: #606060;
			opacity: .9;
			margin-left: 33%;
			font-family: 'Germania One', cursive;
		}
		#username{
			top: 30%;
		}
		#pw{
			top: 42%;
		}
		#cpw{
			top: 54%;
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
		#error{
			position: absolute;
			z-index: 4;
			top: 63%;
			left: 38%;
			margin: 1%;
			text-align: center;
		}
		#trojan{
			position:absolute;
			height: 8%;
			width: 4%;
			left: 5%;
			top: 5%;
			animation: move 1s infinite alternate forwards;	
		}
		@keyframes move{
			0% {
				transform: translateX(-5px)
			}
			50% {
				transform: translateX(5px)
			}
		}
	</style>
<%
	String error = (String)request.getAttribute("error");
	if(error == null || error.trim().length() == 0){
		error = "";
	}
	String username = request.getParameter("username");
	if(username == null || username.trim().length() == 0){
		username = "";
	}
	String pw = request.getParameter("pw");
	if(pw == null || pw.trim().length() == 0){
		pw = "";
	}
	String cpw = request.getParameter("cpw");
	if(cpw == null || cpw.trim().length() == 0){
		cpw = "";
	}
%>
		<head>
			<title>Create An Account</title>
			<link href="https://fonts.googleapis.com/css?family=Germania+One" rel="stylesheet">
		<script>
			function submitForm(){
				document.getElementById("userForm").submit();
			}
		</script>
		</head>
		<body>
			<a href="http://localhost:8080/CSCI201-Trojan-Tumble/home.jsp" style="text-decoration:none"><img id="trojan" src="assets/trojansprite.png"></a>
			<div id="header">
				<h1>Create Account</h1> 
			</div>
			
			<form action="Register" method="POST" id="userForm">
				<div id="form">
					<input id="username" type="text" name="username" placeholder="Username" value="<%= username%>"><br/></div>
					<br/><br/>
					<input id="pw" type="password" name="pw" placeholder="Password" value="<%= pw%>"><br/></div><br/>
					<br/><br/>
					<input id="cpw" type="password" name="cpw" placeholder="Confirm Password" value="<%= cpw %>"><br/></div><br/>
					<div id="error" style="color: #a51a1a; font-family: 'Germania One', cursive; font-size: 26pt;"><font><%=error %></font></div>
				</div>
			  </form>
			<div id="register" onclick="submitForm()">Sign Up</div>
			<img id="smoke" src="assets/smoke.png">  

			<div class="container">
			  <div class="red flame"></div>
			  <div class="orange flame"></div>
			  <div class="yellow flame"></div>
			</div>
		</body>
</html>