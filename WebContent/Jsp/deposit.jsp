<%@ page import="java.sql.*"%>
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
<!-- <link rel="icon" href="../Images/shopping_cart.ico" type="image/x-icon" />
<link rel="shortcut icon" href="../Images/shopping_cart.ico" type="image/x-icon" /> -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>充值</title>
</head>
<body>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	<%-- 判断是否已登录 --%>
	<c:if test="${empty user}">
		<jsp:forward page="login.jsp"></jsp:forward>
	</c:if>
	
	<div>
		<sql:setDataSource var="dataSource" driver="com.mysql.cj.jdbc.Driver"
			url="jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true" user="member" password="123456" />
		
		<sql:query dataSource="${dataSource}" var="result">
		select * from users where user_id=? limit 1;
		<sql:param value="${user.id}"></sql:param>
		</sql:query>
		
		<c:forEach var="row" items="${result.rows}">
			<div class="deposit_context">
				<form action="${path}/UpdateBalance" method="post">
					<ul style="list-style:none;line-height:35px;">
						<li>
							会员&nbsp;<font color="blue">${row.user_name}</font>&nbsp;您好：
						</li>
						<li>
							您的会员ID为：<font color="blue">${row.user_id}</font><br>
						</li>
						<li>
							您当前账号余额为：<font color="blue">${row.balance}&yen;</font><br>
						</li>
						<li style="text-align:left;color:green;">
							请选择充值数额：<br>
						</li>
						<li style="text-align:left;">
							<input class="money" type="radio" name="money" checked="checked" value="10">10&yen;
							<input class="money" type="radio" name="money" value="20">20&yen;
							<input class="money" type="radio" name="money" value="30">30&yen;
							<input class="money" type="radio" name="money" value="50">50&yen;
							<input class="money" type="radio" name="money" value="100">100&yen;
							<input class="money" type="radio" name="money" value="200">200&yen;
							<input class="money" type="radio" name="money" value="500">500&yen;
						</li>
						<li style="text-align:left;">
							<input class="money" type="radio" name="money" value="其他">
							其他：&yen;
							<input class="deposit_text" disabled="disabled" style="margin-top:5px;width:250px;height:25px;font-size:18px;"
								type="text" oninput="value=value.replace(/[^\d]/g,'').slice(0,10)" placeholder="请输入数额（1元的整数倍）"  name="deposit">
						</li>
						<li>
							<a class="showQRcode" style="color:blue;" href="javascript:void(0);">点击查看充值二维码</a>
						</li>
					</ul>
					<div class="QRcode">
						<ul style="list-style:none;line-height:35px;">
							<li>
								<img alt="支付二维码" src="../Images/deposit.png">
							</li>
							<li>
								<input class="btn_submit" style="margin-left:20px;" type="submit" value="已充值">
							</li>
						</ul>
					</div>
				</form>
			</div>
		</c:forEach>
	</div>
	<div class="full_mask deposit_close"></div>
</body>
</html>