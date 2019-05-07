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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
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
	<c:if test="${empty fd}">
		<script>location.replace("forget_password.jsp")</script>
	</c:if>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	<div class="head_body" style="position:absolute;background:RGB(250,250,250);width:100%;height:100px;">
		<h1 style="width:300px;margin-left:600px;margin-top:50px;">密码找回</h1>
	</div>
	<div class="center_body">
		<div class="layui-progress" lay-showpercent="true">
			<div class="layui-progress-bar" lay-percent="2/3"></div>
		</div>
		<div style="margin-top:80px;">
			<div class="layui-form">
				<blockquote class="layui-elem-quote layui-text">
					<label class="layui-text">填写您设置过的密保问题以及答案：</label>
				</blockquote>
				<div class="layui-form-item">
					<label class="layui-form-label">问题：</label>
					<div class="layui-input-block" style="width:300px;">
					    <select class="question" lay-verify="required" >
					        <option value=""></option>
					        <option value="1">您父亲的姓名？</option>
					        <option value="2">您母亲的姓名？</option>
					        <option value="3">您的生日是什么时候？</option>
					        <option value="4">您毕业于哪所小学？</option>
					        <option value="5">您高中班主任的名字？</option>
					        <option value="6">您的宠物叫什么？</option>
					    </select>
					    <input class="layui-input answer" style="margin-top:20px;" lay-verify="required" name="answer" autocomplete="off" placeholder="请输入答案"/>
					    <div class="layui-form-mid" style="color:red;">&nbsp;*&nbsp;连续失败三次将会冻结账号1小时</div>
					</div>
				</div>
				<input class="layui-btn next" type="submit" style="margin-left:110px;width:150px;" lay-submit="" lay-filter="get_question" value="下一步">
			</div>
		</div>
	</div>
</body>
</html>