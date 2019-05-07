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
<script src="//apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='../Js/jquery.min.js' type='text/javascript'%3E%3C/script%3E"));
  }
</script>
<script src="../Layui/layui.js"></script>
<script src="../Js/scripts.js"></script>
<link rel="icon" href="../Images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="../Images/favicon.ico" type="image/x-icon" />
<title>网上书店</title>
</head>
<body>
	<jsp:include page="login_pop.jsp"/>
	<%-- <c:set var="path" value="${pageContext.request.scheme +'://' + pageContext.request.serverName +
				 ':' + pageContext.request.serverPort + pageContext.request.contextPath}"/> --%>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	<!-- 搜索框 -->
	<div id="top_body" style="height: 150px;">
		<div id="search">
			<form action="${path}/Search" method="post" onsubmit="return search()">
				<div id="search_input_pic_div">
					<img id="search_pic" src="../Images/search.jpg"/> 
					<input id="search_input" class="inpt" type="text" name="input_text" maxlength="255" autocomplete="off" placeholder="时间简史" />
				</div>
				<input id="search_button" type="submit" value="搜索"	name="submit_button" />
			</form>
		</div>
		
		<div id="login_register" >
			<c:choose>
				<c:when test="${empty user}">
					<a class="loginpop" href="javascript:;">登录</a>&nbsp;|&nbsp; 
					<a style="color:blue;" href="${path}/Jsp/sign_up.jsp">注册</a>
				</c:when>
				<c:otherwise>
					<span>欢迎<a class="user_nm" style="color:blue;text-decoration:none;" href="javascript:void(0);">${user.name}</a>&nbsp;!</span>&nbsp;&nbsp;
					<span>我的<a style="color:blue;" href="${path}/Jsp/cart.jsp">购物车</a></span>
					<span>&nbsp;|&nbsp;【<a class="log_out" data-path="${path }" href="javascrpit:void(0);">退出</a>】</span>
					<div class="user_panel" style="margin-left:-50px;">
						<br>
						用户名：${user.name}<br>
						账户余额：&yen;${user.balance}<br>
						<a style="display:block;width:75px;margin:10px auto;color:blue;" href="${path}/Jsp/deposit.jsp">充值&gt;&gt;</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	
	<div id="main_body">
		<c:set var="pagesize" value="${1}" scope="page"/>

		<sql:setDataSource  var="dataSource" driver="com.mysql.cj.jdbc.Driver"
				url="jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true" user="member" password="123456"/>
		<sql:query dataSource="${dataSource}" var="booklist">
				select * from books;
		</sql:query>
		<c:set var="listcounts" value="${booklist.rowCount}"/>
		<fmt:formatNumber var="pagecount" type="number" value="${listcounts / pagesize +0.4}" maxFractionDigits="0"/>
		
		<c:choose>
			<c:when test="${(empty param.currentpage)||(param.currentpage<1)||(param.currentpage>pagecount)}">
				<c:set var="currentpage" value="${1}"/>
			</c:when>
			<c:otherwise>
				<c:set var="currentpage" value="${param.currentpage}"/>
			</c:otherwise>
		</c:choose>
		<c:forEach var="row" items="${booklist.rows}" begin="${(currentpage - 1) * pagesize}" end="${currentpage * pagesize - 1}">
		<table>
			<tr>
				<td>
				    <a href="../Images/${row.book_name}.jpg">
				    <img alt="${row.book_name}" src="../Images/${row.book_name}.jpg" width="150px" height="150px"></a>
				</td>
				<td>
					<ul style="list-style-type: none;">
						<li>
							<a href="${path}/Jsp/buy_now.jsp?ISBN=${row.ISBN}" style="text-decoration: none; color: blue; font-size: 25px;">${row.book_name}</a>
						</li>
						<li class="book_msg" style="font-size: 16px;">
							${row.author}（著）|&nbsp;ISBN:${row.ISBN}&nbsp;|&nbsp;出版社：${row.publisher}&nbsp;|&nbsp;出版时间：${row.pub_date}
						</li>
						<li style="font-size: 20px">
							售价：<font color="red">&yen;${row.price}</font> <span style="margin-left: 200px;">剩余库存：<font color="red">${row.amount}</font>本</span>
						</li>
						<li>
							<input id="${row.ISBN}" class="${user.id}" value="${row.amount}" type="hidden"/>
							<input name="${row.ISBN}" class="buy_now" data-path="${path}" style="float:right;" type="button" value="立即购买"/>
							<input name="${row.ISBN}" class="add_cart" data-path="${path}" style="float:right; margin-right:20px;" type="button" value="加入购物车"/>
						</li>
					</ul>
				</td>
			</tr>
		</table>
		<hr>
		</c:forEach>
	</div>
	
	<div id="bottom_body" style="position:absolute;bottom:0px;background:RGB(245,245,245);width:99%;height:100px;">
		<div class="page_num" style="margin-top:15px;">
			<c:if test="${currentpage > 1}">
				<a class="pages" href="${path}/Jsp/home.jsp?currentpage=1" >&nbsp;首页&nbsp;</a>
				<a href="${path}/Jsp/home.jsp?currentpage=${currentpage - 1}" >上一页</a>
			</c:if>
			<c:if test="${currentpage - 2 >= 1}">
				<a href="${path}/Jsp/home.jsp?currentpage=${currentpage - 2}" >&nbsp;&nbsp;${currentpage - 2}&nbsp;&nbsp;</a>
			</c:if>
			<c:if test="${currentpage > 1}">
				<a href="${path}/Jsp/home.jsp?currentpage=${currentpage - 1}" >&nbsp;&nbsp;${currentpage - 1}&nbsp;&nbsp;</a>
			</c:if>
			<span style="color:black;" >&nbsp;${currentpage}&nbsp;</span>
			<c:if test="${currentpage < pagecount}">
				<a href="${path}/Jsp/home.jsp?currentpage=${currentpage + 1}" >&nbsp;&nbsp;${currentpage + 1}&nbsp;&nbsp;</a>
			</c:if>
			<c:if test="${currentpage + 2 <= pagecount}">
				<a href="${path}/Jsp/home.jsp?currentpage=${currentpage + 2}" >&nbsp;&nbsp;${currentpage + 2}&nbsp;&nbsp;</a>
			</c:if>
			<c:if test="${currentpage < pagecount}">
				<a href="${path}/Jsp/home.jsp?currentpage=${currentpage + 1}" >下一页</a>
				<a href="${path}/Jsp/home.jsp?currentpage=${pagecount}" >&nbsp;末页&nbsp;</a>
			</c:if>
			共${pagecount}页
		</div>
		
		<div class="demo_info" style="position:absolute;bottom:0px;left:44%;">
			<span>当前版本&nbsp;&nbsp;Beta&nbsp;0.2.0&nbsp;&nbsp;&nbsp;</span>
			<a href="./about.jsp">关于</a>
		</div>
	</div>
</body>
</html>