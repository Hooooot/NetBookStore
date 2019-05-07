<%@page import="java.sql.*"%>
<%@page import="javax.servlet.annotation.WebServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="../CSS/styles.css" />
<script src="//apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='../Js/jquery.min.js' type='text/javascript'%3E%3C/script%3E"));
  }
</script>
<script type="text/javascript" src="../Js/scripts.js"></script>
<title>商品详情</title>
</head>
<body>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>

	<div id="login_register" style="margin-top:-150px;">
			<c:choose>
				<c:when test="${empty user}">
					<a href="${path}/Jsp/login.jsp">登录</a>&nbsp;|&nbsp; 
					<a href="${path}/Jsp/sign_up.jsp">注册</a>
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
	
	<div style="width:750px;margin:0px auto;margin-top:200px;">
		<sql:setDataSource  var="dataSource" driver="com.mysql.cj.jdbc.Driver"
			url="jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true" user="member" password="123456"/>
		<sql:query dataSource="${dataSource}" var="book">
			select * from books where ISBN =? limit 1;
			<sql:param value="${param.ISBN}"></sql:param>
		</sql:query>

		<c:forEach var="row" items="${book.rows}">
			<table >
				<tr>
					<td>
			   			<img alt="${row.book_name}" src="../Images/${row.book_name}.jpg" width="250px" height="300px">
					</td>
					<td>
						<ul style="list-style-type: none;line-height:40px;">
							<li>
								<span style="text-decoration: none; color: blue; font-size: 25px;">${row.book_name}</span>
								<hr>
							</li>
							<li id="book_msg" style="font-size: 16px;">
								${row.author}（著）|&nbsp;ISBN:${row.ISBN}&nbsp;|&nbsp;出版社：${row.publisher}&nbsp;|&nbsp;出版时间：${row.pub_date}
							</li>
							<li style="font-size: 20px;">
								售价：&yen;${row.price}
								<span style="float:right;">
								剩余库存：	${row.amount}本</span>
							</li>
							<li>
							<span>购买数量：</span>
								<input class="decre" style="width: 30px;height: 25px;font-size:20px;border:1px solid #cccccc;" type="button" 
									  data-isbn="${row.ISBN}" data-price="${row.price}" data-available="${row.amount}" value="-"/>
								<input id="amount_${row.ISBN}" type="text" class="num" value="1"
					  				  oninput="value=value.replace(/[^\d^\.]/g,'').slice(0,10)" data-available="${row.amount}"
					  				  onchange="changed('${row.price}','amount_${row.ISBN}','single_total_${row.ISBN}', '${row.amount}')"/> 
								<input class="incre" style="width: 30px;height: 25px;font-size:20px;border:1px solid #cccccc;" type="button"
									  data-isbn="${row.ISBN}" data-price="${row.price}" data-available="${row.amount}" value="+"/>
								<span style="float:right;font-size:20px;">总价为：&yen;<span id="single_total_${row.ISBN}">${row.price}</span></span>
							</li>
							<li>	
								<hr>
								<a href="${path}/Jsp/home.jsp">&lt;&lt;&lt;回到首页</a>
								<input class="neworder" style="float:right;margin-top: 10px;" data-path="${path}" type="button" value="立即购买" data-isbn="${row.ISBN}" onclick="neworder('amount_${row.ISBN}')"/>
							</li>
						</ul>
					</td>
				</tr>
			</table>
		</c:forEach>
		</div>
</body>
</html>