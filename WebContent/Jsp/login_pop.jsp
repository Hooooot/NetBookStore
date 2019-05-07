<%@page import="java.sql.*"%>
<%@page import="javax.servlet.annotation.WebServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!DOCTYPE>
<html>

<body>
	<!-- 登录弹出框 -->
		<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	
		<div class="login_pop_box">
			<div class="top_title">
				<span style="float:left;margin-top:5px;margin-left:10px;font-size:18px;color:dimgray;">账号登录</span>
				<img class="close_img close" style="float:right;margin-top:5px;margin-right:5px;width:24px;height:24px;" src="../Images/white.svg">
			</div>
			<div class="center_context">
				<ul style="text-align:center;list-style:none;margin:0px;padding:0px;">
					<li>
						<img height="150px" width="180px" style="margin-left:30px;" src="../Images/study.jpg">
						<a style="float:right;font-size:10px;color:blue;width:30px;" href="${path}/Jsp/admin_login.jsp">管理员入口</a>
					</li>		
					<li>
						<div class="pop_ipt" >
							<img style="height:38px;width: 38px;border: none;" src="../Images/user.png">
							<input class="pop_account_ipt" type="text" name="account" placeholder="请输入账号名称" maxlength="18"/>
						</div>
					</li>
					<li>
						<div class="pop_ipt">
							<img style="height:38px;width: 38px;border: none;" src="../Images/password.png">
							<input class="pop_pswd_ipt" type="password" name="pswd" placeholder="请输入密码" maxlength="18"/>
						</div>
						
					</li>
					<li>
						<a href="${path}/Jsp/forget_password.jsp" style="float:left;color:blue;">忘记密码？</a>
						<a href="${path}/Jsp/sign_up.jsp" style="float:right;color:blue;">没有账号？立即注册&gt;&gt;</a> 
					</li>
					<li style="line-height:50px;"> 
						<input class="pop_login_btn" type="button" data-path="${path}" value="登录"/>
					</li>
				</ul>
			</div>
		</div>
		<div class="full_mask"></div>
</body>
</html>