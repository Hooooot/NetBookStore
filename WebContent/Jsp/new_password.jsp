<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="../CSS/styles.css" />
<link rel="stylesheet" type="text/css" href="../Layui/css/layui.css" />
<script src="//apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='../Js/jquery.min.js' type='text/javascript'%3E%3C/script%3E"));
  }
</script>
<script src="../Layui/layui.js"></script>
<script src="../Js/scripts.js"></script>
<script src="../Js/layscript.js"></script>
<style>
.center_body{
	padding-top:100px;
	margin:0px auto;
	width:1000px;
}
</style>
<title>忘记密码</title>
</head>
<body>
	<c:if test="${empty checkok}">
		<script>location.replace("forget_question.jsp")</script>
	</c:if>
	<c:remove var="checkok" scope="session"></c:remove>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	<div class="head_body" style="position:absolute;background:RGB(250,250,250);width:100%;height:100px;">
		<h1 style="width:300px;margin-left:600px;margin-top:50px;">密码找回</h1>
	</div>
	<div class="center_body">
		<div class="layui-progress" lay-showpercent="true">
			<div class="layui-progress-bar" lay-percent="3/3"></div>
		</div>
		<div style="margin-top:80px;">
			<form class="layui-form" action="${path}/SetNewPswd" method="post">
				<blockquote class="layui-elem-quote layui-text">
					<label class="layui-text">设置新密码：</label>
				</blockquote>
				<div id="pswd_tip" style="height:15px;visibility:hidden;margin: 10px 10px;">
				    <img src="../Images/error.png" style="float:left;height:25px;width:25px;">
				    <span style="font-size:16px;margin-top:10px;">&nbsp;&nbsp;密码两次输入不一致或密码为空！</span> 
				</div>
				<div class="layui-form-item">
					<div style="border:1px solid #cccccc; height: 38px;width:300px;margin-top:20px;">
			    		<img src="../Images/password.png" class="input_pic">
			    		<input id="password_inputs" class="login_input newpswd" type="password" name="password" 
			    			oninput="value=value.replace(/[^\d^_^a-z^A-Z\^]/g,'').slice(0,18)" lay-verify="required" placeholder="请输入密码（只允许英文字符、数字、_）" onblur="same_password()"/>
					</div>
					<div style="border:1px solid #cccccc; height: 38px;width:300px;margin-top:20px;">
			  		   <img src="../Images/password.png" class="input_pic">
			    	   <input id="password_inputs_again" class="login_input" type="password" name="password_a" lay-verify="required" placeholder="请再次输入密码（密码不能超过18位）" onblur="same_password()"/>
			        </div>
				</div>
				<input id="reset_pswd_submit" class="layui-btn layui-btn-disabled" style="width:150px;margin-left:75px;"
						  title="密码输入需一致且不为空" lay-submit="" type="submit" value="提交" disabled="disabled" />
			</form>
		</div>
	</div>
</body>
</html>