<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Ekele's Project- Home page</title>
<link href="images/my-pic.png" rel="icon">
</head>
</head>
<body>
<h1 align="center">Hello World!.</h1>
<h1 align="center">EKELE ENENCHE JAMES is an adept DevOps Engineer with a government-sponsored transition into the field during university.
	With over four years of expertise, James specializes in crafting robust CI/CD pipelines and cloud infrastructure.</h1>
<hr>
<br>
	<h1><h3> Server Side IP Address </h3><br>

<% 
String ip = "";
InetAddress inetAddress = InetAddress.getLocalHost();
ip = inetAddress.getHostAddress();
out.println("Server Host Name :: "+inetAddress.getHostName()); 
%>
<br>
<%out.println("Server IP Address :: "+ip);%>
		
</h1>
	
<hr>
<div style="text-align: center;">
	<span>
		<img src="images/my-pic.png" alt="" width="150">
	</span>
	<span style="font-weight: bold;">
                Ekele Enenche, 
		Zaria, Kaduna, Nigeria,
		+234 810 4278 421,
		ekeleejames@gmail.com
		https://www.linkedin.com/in/ekele-enenche-james-214b43294/
		<br>
		<a href="mailto:ekeleejames@gmail.com">Mail to James</a>
	</span>
</div>
<hr>
	<p> Service : <a href="services/employee/getEmployeeDetails">Get Personal Details </p>
<hr>
<hr>
<p align=center>Ekele Enenche James - DevOps / Site Reliability Engineer</p>
<p align=center><small>Copyrights 2023 by <a href="https://www.linkedin.com/in/ekele-enenche-james-214b43294/">Oxdit Technologies</a> </small></p>

</body>
</html>
