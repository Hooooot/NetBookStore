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
<link rel="icon" href="../Images/shopping_cart.ico" type="image/x-icon" />
<link rel="shortcut icon" href="../Images/shopping_cart.ico" type="image/x-icon" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>购物车</title>
</head>
<body>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	<%-- 判断是否已登录 --%>
	<c:if test="${empty user}">
		<jsp:forward page="login.jsp"></jsp:forward>
	</c:if>
	
	<!-- 用户名与退出 -->
	<div id="top_body" style="height: 100px;"> 		
		<div id="login_register" style="margin-top:30px;">
			<span>欢迎<a class="user_nm" style="color:blue;text-decoration:none;" href="javascript:void(0);">${user.name}</a>&nbsp;!</span>&nbsp;&nbsp;
			<span>&nbsp;&nbsp;<a class="log_out" data-path="${path }" href="javascrpit:void(0);">退出</a></span>
			<div class="user_panel" style="margin-left:-80px;">
				<br>
				用户名：${user.name}<br>
				账户余额：&yen;${user.balance}<br>
				<a style="display:block;width:75px;margin:10px auto;color:blue;" href="${path}/Jsp/deposit.jsp">充值&gt;&gt;</a>
			</div>
		</div>
	</div>
	
	<!-- 订单 -->
	<div class="cart_table">
		<a style="color:blue;margin-left:-50px;font-size:20px;" href="${path}/Jsp/cart.jsp">&lt;&lt;返回购物车</a>
		<sql:setDataSource var="dataSource" driver="com.mysql.cj.jdbc.Driver"
			url="jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true" user="member" password="123456" />
		<sql:query dataSource="${dataSource}" var="result">
		select * from orders where(user_id=?);
		<sql:param value="${user.id}"></sql:param>
		</sql:query>
		
		<table style="border-collapse:collapse;width:1100px;margin-left:-50px;">
			<tr>
				<th style="width:50px;"></th>	
				<th style="width:300px;">商品</th>
				<th>单价（/元）</th>
				<th>数量（/本）</th>
				<th>总价（/元）</th>
				<th>提交时间</th>
				<th class="cart_op">订单状态</th>
			</tr>		
			<c:set var="total_price" value="0" scope="page"/>
			<c:forEach var="row" items="${result.rows}">
				<tr>
					<td><input class="choose_one" type="checkbox" name="${row.order_id}" /></td>
					<td class="cart_td">
						<ul style="list-style:none;">
							<li class="li_img">
								<img class="cart_img" src="../Images/${row.book_name}.jpg" name="img_${row.ISBN}" />
							</li>
							<li class="book_name">
								${row.book_name}
							</li>
							<li class="book_name">
							</li>
							<li class="book_name">
								订单号：${row.order_id}
							</li>
						</ul>
					</td>
					<td>&yen;${row.book_price}</td>
					<td>
						${row.amount}本
				    </td>
				    <td>
				    	<span>&yen;${row.total_price}</span>
				    </td>
				    <td>
				    	<fmt:formatDate value="${row.create_time}" pattern="yyyy-MM-dd HH:mm:ss"/>
				    </td>
				    <td class="cart_op">
				    	${row.state}
				    	<c:if test="${row.state eq '未支付'}">
				    		<br><a style="color:blue;" href="${path}/Pay?orderid=${row.order_id}&userid=${user.id}">去支付&gt;&gt;</a>
				    		<c:set var="total_price" value="${total_price + row.total_price}" scope="page"/>
				    	</c:if>
				    	
				    </td>
				</tr>
			</c:forEach>
			<c:choose>
				<c:when test="${result.rowCount > 0}">	
					<tr>
						<td colspan="7" height="100px">
							<input class="choose_all" style="float:left; margin:6px 10px 0px 15px;" value="${result.rowCount}" type="checkbox" />
							<span style="float:left;">全选</span>
							<a class="del_choose_order" data-path="${path}" href="javascript:void(0);">删除选中的订单</a>
							<span class="all_total" >未支付订单总价为：<span><span id="all_total" data-path="${path}">${total_price}</span></span></span>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="7" height="100px">
							<div class="empty_cart">
								<img src="../Images/shopping_cart.png" height="100px" width="100px"/>
								<div>
									<span>您尚未购买任何书籍~</span><br>
									<a class="gotobuy" href="${path}/Jsp/home.jsp">快去选购吧！</a>
								</div>
							</div>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>
		<a class="rtn_home" style="margin-right:-50px;" href="javascript:void(0);"></a>
	</div>
</body>
</html>