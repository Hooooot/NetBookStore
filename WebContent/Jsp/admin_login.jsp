<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../CSS/styles.css"/>
<script src="//apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='../Js/jquery.min.js' type='text/javascript'%3E%3C/script%3E"));
  }
</script>
<script type="text/javascript" src="../Js/scripts.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>管理员登录</title>
</head>

<body>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>

	<%
	String result;
	if(session.getAttribute("admin")!=null) {
	%>
		<jsp:forward page="management.jsp"/>
	<%
	}
	
	if(session.getAttribute("login") != null) {
		result = (String)session.getAttribute("login");
		session.removeAttribute("login");
	}else{
		result = "hidden";
	}
	%>

	<a href="${path}/Jsp/login.jsp" style="float:right;font-size:20px;color:blue;">普通用户入口&gt;&gt;&gt;</a>

	<div class="sign_box">
		<form action="${path}/AdminLoginCheck" method="post" onsubmit="return input_check()">
			<img src="../Images/admin.jpg" height="260px" width="300px">
			<br>
			<div style="border:1px solid #cccccc;height: 38px;visibility: <%=result%>;margin: 10px 0px;">
			    <img class="input_pic" src="../Images/error.png" style="float:left;">
			    <div style="font-size:20px;margin:5px 0px;">&nbsp;&nbsp;账号或密码错误！</div>
			</div>
			<div style="border:1px solid #cccccc;height: 39px;">
			    <img class="input_pic" src="../Images/user.png" style="height: 39px;" >
			    <input id="admin_account_input" class="login_input" style="width:252px;" type="text" name="account" placeholder="账号：king"/>
			</div>
			<br>
			<div style="border:1px solid #cccccc; height: 39px">
			    <img class="input_pic" src="../Images/password.png" style="height: 39px;">
			    <input id="admin_password_input" class="login_input" style="width:252px;" type="password" name="password" placeholder="密码：123" />
			</div>
			<br>
			<input id="admin_submit" class="btn_submit" type="submit" value="登录"/>
		</form>
	</div>
</body>

</html>