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
<script src="../Js/VerifyCode.js"></script>
<script src="../Js/scripts.js"></script>
<script>
layui.use(["layer","form","laypage","element"],function(){
	var laypage = layui.laypage;
	var layer = layui.layer;
	var $ = jQuery = layui.jquery;
	var form =layui.form;
	var verifyCode = new GVerify("verifycode_container");
	
	form.on("submit(forget_next)",function(data){
		var input = verifyCode.validate($(".code").val())
		if(!input){
			layer.alert("验证码错误！");
			return false;
		}
		$.post("../ResetPswdToNext",
				{"username":$(".username").val()},
				function(data){
					if($.trim(data) == "true"){
						location.replace("./forget_question.jsp")
					}else{
						layer.alert(data);
					}
					    
				})
		
		return true; 
	});
});
</script>
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
	<!-- import login pop page -->
	<jsp:include page="login_pop.jsp"/>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	<div class="head_body" style="position:absolute;background:RGB(250,250,250);width:100%;height:100px;">
		<h1 style="width:300px;margin-left:600px;margin-top:50px;">密码找回</h1>
		<div id="login_register" style="margin:-50px 5px;">
			<c:choose>
				<c:when test="${empty user}">
					<a class="loginpop" href="javascript:;">登录</a>&nbsp;|&nbsp; 
					<a style="color:blue;" href="${path}/Jsp/sign_up.jsp">注册</a>
				</c:when>
				<c:otherwise>
					<span>欢迎<a class="user_nm" style="color:blue;text-decoration:none;" href="javascript:void(0);">${user.name}</a>&nbsp;!</span>&nbsp;&nbsp;
					<span>我的<a style="color:blue;" href="${path}/Jsp/cart.jsp">购物车</a></span>
					<span>&nbsp;|&nbsp;【<a class="log_out" data-path="${path }" href="javascrpit:void(0);">退出</a>】</span>
					<div class="user_panel" style="margin-left:-80px;">
						<br>
						用户名：${user.name}<br>
						账户余额：&yen;${user.balance}<br>
						<a style="display:block;width:75px;margin:0px auto;color:blue;" href="${path}/Jsp/deposit.jsp">充值&gt;&gt;</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	<div class="center_body">
		<div class="layui-progress" lay-showpercent="true">
			<div class="layui-progress-bar" lay-percent="1/3"></div>
		</div>
		<div style="margin-top:80px;">
			<div class="layui-form" >
				<blockquote class="layui-elem-quote layui-text">
					<label class="layui-text">请填写要找回账号的用户名</label>
				</blockquote>
				<input class="layui-input username" style="width:320px;margin:20px 0px;" lay-verify="required" name="account" type="text" autocomplete="off" placeholder="请输入用户名"/>
				<div>
					<input class="layui-input code" style="width:150px;display:inline-block;float:left;" lay-verify="required" type="text" placeholder="请输入验证码"/>
					<div id="verifycode_container" style="width:120px;height:40px;display:inline-block;margin-left:50px;"></div>
				</div>
				<input class="layui-btn verify_code" type="submit" style="margin-top:20px;margin-left:90px;width:150px;" lay-submit="" lay-filter="forget_next" value="下一步">
			</div>
		</div>
	</div>
	<div id="page"></div>

</body>
</html>