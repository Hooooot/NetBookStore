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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>${param.context}_搜索结果：</title>
</head>
<body>
	
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	
	<!-- 搜索框 -->
	<div id="top_body" style="height: 150px;">
		<div id="search">
			<form action="${path}/Search" method="post" onsubmit="return search()">
				<div id="search_input_pic_div">
					<img id="search_pic" src="../Images/search.jpg"/> 
					<input id="search_input" class="inpt" type="text" name="input_text" maxlength="255" value="${param.context}" autocomplete="off" placeholder="时间简史" />
				</div>
				<input id="search_button" type="submit" value="搜索"	name="submit_button" />
			</form>
		</div>

		<!-- 登录弹出框 -->
		<div class="login_pop_box">
			<div class="top_title">
				<span style="float:left;margin-top:5px;margin-left:10px;font-size:18px;color:dimgray;">账号登录</span>
				<img class="close_img" style="float:right;margin-top:5px;margin-right:5px;width:24px;height:24px;" src="../Images/white.svg">
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
						<a href="" style="float:left;color:blue;">忘记密码？</a>
						<a href="${path}/Jsp/sign_up.jsp" style="float:right;color:blue;">没有账号？立即注册&gt;&gt;</a> 
					</li>
					<li style="line-height:50px;"> 
						<input class="pop_login_btn" type="button" data-path="${path}" value="登录"/>
					</li>
				</ul>
			</div>
		</div>
		<div class="full_mask"></div>

		<div id="login_register" >
			<c:choose>
				<c:when test="${empty user}">
					<a class="loginpop" href="javascript:;">登录</a>&nbsp;|&nbsp; 
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
	</div>
	<div style="width:200px;margin:0px auto;margin-top:-20px;margin-bottom:20px">
		<b style="font-size:20px;color:red;">搜索结果为：</b>
	</div>
	<div id="main_body">
		<c:set var="pagesize" value="${2}" scope="page"/>    <!-- ///////////////////////////// -->
		<c:if test="${empty searchBookList}">
			<script type="text/javascript">
				alert("发生错误！");
				window.location.href = "${path}/Jsp/home.jsp";
			</script>
		</c:if>
		<c:choose>
			
			<c:when test="${(empty param.currentpage)||(param.currentpage<1)||(param.currentpage>searchpagecount)}">
				
				<c:set var="searchlistcounts" value="${searchBookList.size()}" scope="session"/>
				<fmt:formatNumber var="searchpagecount" type="number" value="${searchlistcounts / pagesize +0.3}" maxFractionDigits="0" scope="session"/>
				<c:set var="currentpage" value="${1}"/>
			</c:when>
			<c:otherwise>
				<c:set var="currentpage" value="${param.currentpage}"/>
			</c:otherwise>
		</c:choose>
		
		<c:forEach var="row" items="${searchBookList}" begin="${(currentpage - 1) * pagesize}" end="${currentpage * pagesize - 1}">
		<table>
			<tr>
				<td>
				    <a href="../Images/${row.book_name}.jpg">
				    <img alt="${row.book_name}" src="../Images/${row.book_name}.jpg" width="150px" height="150px"></a>
				</td>
				<td>
					<ul style="list-style-type: none;">
						<li>
							<a href="" style="text-decoration: none; color: blue; font-size: 25px;">${row.book_name}</a>
						</li>
						<li class="book_msg" style="font-size: 16px;">
							${row.author}（著）|&nbsp;ISBN:${row.ISBN}&nbsp;|&nbsp;出版社：${row.publisher}&nbsp;|&nbsp;出版时间：${row.pub_date}
						</li>
						<li style="font-size: 20px">
							售价：<font color="red">&yen;${row.price}</font> <span style="margin-left: 200px;">剩余库存：<font color="red">${row.amount}</font>本</span>
						</li>
						<li>
							<input id="${row.ISBN}" class="${user.id}" value="${row.amount}" type="hidden"/>
							<input name="${row.ISBN}" class="buy_now" style="float:right;" type="button" value="立即购买"/>
							<input name="${row.ISBN}" class="add_cart" style="float:right; margin-right:20px;" type="button" value="加入购物车"/>
						</li>
					</ul>
				</td>
			</tr>
		</table>
		<hr>
		</c:forEach>

		</div>
		<div id="bottom_body">
			<div class="page_num">
				<c:if test="${currentpage > 1}">
					<a class="pages" href="${path}/Jsp/search.jsp?currentpage=1" >&nbsp;首页&nbsp;</a>
					<a href="${path}/Jsp/search.jsp?currentpage=${currentpage - 1}" >上一页</a>
				</c:if>
				<c:if test="${currentpage - 2 >= 1}">
					<a href="${path}/Jsp/search.jsp?currentpage=${currentpage - 2}" >&nbsp;&nbsp;${currentpage - 2}&nbsp;&nbsp;</a>
				</c:if>
				<c:if test="${currentpage > 1}">
					<a href="${path}/Jsp/search.jsp?currentpage=${currentpage - 1}" >&nbsp;&nbsp;${currentpage - 1}&nbsp;&nbsp;</a>
				</c:if>
				<span style="color:black;" >&nbsp;${currentpage}&nbsp;</span>
				<c:if test="${currentpage < searchpagecount}">
					<a href="${path}/Jsp/search.jsp?currentpage=${currentpage + 1}" >&nbsp;&nbsp;${currentpage + 1}&nbsp;&nbsp;</a>
				</c:if>
				<c:if test="${currentpage + 2 <= searchpagecount}">
					<a href="${path}/Jsp/search.jsp?currentpage=${currentpage + 2}" >&nbsp;&nbsp;${currentpage + 2}&nbsp;&nbsp;</a>
				</c:if>
				<c:if test="${currentpage < searchpagecount}">
					<a href="${path}/Jsp/search.jsp?currentpage=${currentpage + 1}" >下一页</a>
					<a href="h${path}/Jsp/search.jsp?currentpage=${searchpagecount}" >&nbsp;末页&nbsp;</a>
				</c:if>
				共${searchpagecount}页
			</div>
		</div>
</body>
</html>