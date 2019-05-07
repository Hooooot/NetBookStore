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
	
	<!-- 搜索框 -->
	<div id="top_body" style="height: 100px;">
<!-- 		<div id="search">
			<form action="http://localhost:8080/NetBook/Search" method="post" onsubmit="return search()">
				<div id="search_input_pic_div">
					<img id="search_pic" src="../Images/search.jpg"/> 
					<input id="search_input" class="inpt" type="text" name="input_text" maxlength="255" autocomplete="off" placeholder="时间简史" />
				</div>
				<input id="search_button" type="submit" value="搜索"	name="submit_button" />
			</form>
		</div>
 -->
		<div id="login_register" style="margin-top:50px;">
			<span>欢迎<a class="user_nm" style="color:blue;text-decoration:none;" href="javascript:void(0);">${user.name}</a>&nbsp;!</span>&nbsp;&nbsp;

			<a style="color:blue;" href="${path}/Jsp/order.jsp">查看订单</a>
			<span>&nbsp;&nbsp;<a class="log_out"  data-path="${path }" href="javascrpit:void(0);">退出</a></span>
			<div class="user_panel" >
				<br>
				用户名：${user.name}<br>
				账户余额：&yen;${user.balance}<br>
				<a style="display:block;width:75px;margin:10px auto;color:blue;" href="${path}/Jsp/deposit.jsp">充值&gt;&gt;</a>
			</div>
		</div>
	</div>
	
	<!-- 购物车 -->
	<div class="cart_table">
		<sql:setDataSource var="dataSource" driver="com.mysql.cj.jdbc.Driver"
			url="jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true" user="member" password="123456" />
		
		<sql:query dataSource="${dataSource}" var="result">
		SELECT * from shopping_cart where(user_id=?);
		<sql:param value="${user.id}"></sql:param>
		</sql:query>
		<div>
			<span style="color:#E64347;font-size:32px;">全<span style="font-size:30px;">部商品&nbsp;</span><span style="font-size:25px;">${result.rowCount}</span></span>
		</div>
		<table style="border-collapse:collapse;">
			<tr>
				<th style="width:50px;"></th>	
				<th style="width:300px;">商品</th>
				<th>单价（/元）</th>
				<th>数量（/本）</th>
				<th>总价（/元）</th>
				<th class="cart_op">操作</th>
			</tr>		
			<c:set var="total_price" value="0" scope="page"/>
			<c:forEach var="row" items="${result.rows}">
				<c:set var="total_price" value="${total_price + row.book_price * row.amount}" />
				<tr>
					<td>
						<input class="choose_one" type="checkbox" name="${row.cart_id}"/>
						<input class="${row.cart_id}" name="${row.book_name}" value="${row.ISBN}" type="hidden"/>
					</td>
					<td class="cart_td">
						<ul style="list-style:none;">
							<li class="li_img">
								<img class="cart_img" src="../Images/${row.book_name}.jpg" name="img_${row.ISBN}"/>
							</li>
							<li class="book_name">
								${row.book_name}
							</li>
						</ul>
					</td>
					<td>&yen;${row.book_price}</td>
					<td>
						<input class="incre_decre" type="button" 
							onclick="incre_decre('-','amount_${row.ISBN}', '${row.book_price}','single_total_${row.ISBN}')" value="-"/>
																									<!-- cart_ID -->
						<input id="amount_${row.ISBN}" type="text" class="num" value="${row.amount}" name="${row.cart_id}"
						    oninput="value=value.replace(/[^\d^\.]/g,'').slice(0,10)"
						    onchange="changed('${row.book_price}','amount_${row.ISBN}','single_total_${row.ISBN}')"/> 
						<input class="incre_decre" type="button"
						onclick="incre_decre('+','amount_${row.ISBN}', '${row.book_price}','single_total_${row.ISBN}')" value="+"/>
				    </td>
				    <td>
				    <span>&yen;<span id="single_total_${row.ISBN}">
				   		<fmt:formatNumber type="number" value="${row.book_price * row.amount}" maxFractionDigits="2"/>
				    </span></span>
				    </td>
				    <td class="cart_op">
				    <input id="${row.cart_id}" class="cart_del" data-path="${path}" type="button" value="删除"/>
				    </td>
				</tr>
			</c:forEach>
			<c:choose>
				<c:when test="${result.rowCount > 0}">	
					<tr>
						<td colspan="6" height="100px">
							<input class="choose_all" style="float:left; margin:6px 10px 0px 15px;" value="${result.rowCount}" type="checkbox" />
							<span style="float:left;">全选</span>
							<a class="del_choose" data-path="${path}" href="javascript:void(0);">删除选中的物品</a>
							<span class="all_total">总价为：<span><span id="all_total">
							<fmt:formatNumber type="number" value="${total_price}" maxFractionDigits="2"/>
							</span></span></span>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="6" height="100px">
							<div class="empty_cart">
								<img src="../Images/shopping_cart.png" height="100px" width="100px"/>
								<div>
									<span>您的购物车中空空如也~</span><br>
									<a class="gotobuy" href="${path}/Jsp/home.jsp">快去选购吧！</a>
								</div>
							</div>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>
		<c:if test="${result.rowCount > 0}">
			<a class="settlement" style="margin-left:15px;" href="javascript:void(0);">&yen;结算</a>
		</c:if>
		<a class="rtn_home" data-path="${path }" style="margin-right:-1px;" href="javascript:void(0);"></a>
	</div>
	
	<div class="settlement_page">
		<div style="height:35px;background:RGB(240,240,240);border-radius:10px 10px 0px 0px;">
			<img class="close" style="float:right;margin-top:5px;margin-right:5px;" src="../Images/white.svg">
		</div>
		<div style="margin-left:10px;">
			您将购买以下物品：<br>
			<div class="context_book" style="color:red;">
			</div>
			<br>
			共计：
			<div class="context_price" style="color:red;">
			</div>
		</div>
		<input class="settlement_btn" style="margin:10px 0px 10px 140px;" data-path="${path}" type="button" value="提交" />
	</div>
	<div class="mask"></div>
	
</body>
</html>