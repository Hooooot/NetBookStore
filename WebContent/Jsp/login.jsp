<%@page import="java.sql.*"%>
<%@page import="javax.servlet.annotation.WebServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!DOCTYPE>
<html>

<head>
<script src="//apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="../CSS/styles.css" />
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='../Js/jquery.min.js' type='text/javascript'%3E%3C/script%3E"));
  }
</script>
<script type="text/javascript" src="../Js/scripts.js"></script>
<title>账号登录</title>
</head>

<body>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>

	<%
	String result;
	if(session.getAttribute("user") != null){
	%>
	    <jsp:forward page="home.jsp"/>
	<%
	}
	if(session.getAttribute("login") != null) {
		result = (String)session.getAttribute("login");
		session.removeAttribute("login");
	}else{
		result = "hidden";
	}
	%>

	<a style="float:right;font-size:20px;color:blue  ;" href="${path}/Jsp/admin_login.jsp">管理员入口&gt;&gt;&gt;</a>
	<div class="sign_box">
		<form action="${path}/LoginCheck" method="post" onsubmit="return input_check()"> 
			<img height="260px" width="300px" src="../Images/study.jpg">
			<br>
			<div style="border:1px solid #cccccc;height: 38px;visibility: <%=result%>;margin: 10px 0px;">
			    <img class="input_pic" style="float:left;" src="../Images/error.png">
			    <div style="font-size:20px;margin:5px 0px;">&nbsp;&nbsp;账号或密码错误！</div>
			</div>
			<div style="border:1px solid #cccccc;height: 38px;">
			    <img class="input_pic" src="../Images/user.png">
			    <input id="account_input" class="login_input" type="text" name="account" placeholder="请输入账号名称" />
			</div>
			<br>
			<div style="border:1px solid #cccccc; height: 38px">
			    <img class="input_pic" src="../Images/password.png">
			    <input id="password_input" class="login_input" type="password" name="password" placeholder="请输入密码" />
			</div>
			<a style="color: blue;font-size: 12px;float:left;" href="${path}/Jsp/home.jsp">&lt;&lt;&lt;暂不登录</a>
			<a style="color: blue;font-size: 12px;float:right;" href="${path}/Jsp/sign_up.jsp">没有账号？立即注册&gt;&gt;&gt;</a>
			<br>
			<input id="login_submit" class="btn_submit" type="submit" value="登录"/>
		</form>
	</div>
</body>

</html>