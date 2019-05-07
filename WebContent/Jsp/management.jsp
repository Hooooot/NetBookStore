<%@page import="java_bean.AdminUserBean"%>
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
<link rel="icon" href="../Images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="../Images/favicon.ico"
	type="image/x-icon" />
<title>管理界面</title>
</head>

<body>
	<c:set var="path" value="${pageContext.request.scheme}${'://'}${pageContext.request.serverName}${':'}${pageContext.request.serverPort}${pageContext.request.contextPath}"/>
	<c:if test="${empty admin}">
		<jsp:forward page="admin_login.jsp"></jsp:forward>
	</c:if>
	<!-- 搜索框 -->
	<div id="top_body" style="height: 50px;">
		<div id="search">
			<form action="${path}/AdminSearch" method="post" onsubmit="return search()">
				<div id="search_input_pic_div">
					<img id="search_pic" src="../Images/search.jpg"/> 
					<input id="search_input" class="inpt" type="text" name="input_text" maxlength="255" autocomplete="off" placeholder="时间简史" />
				</div>
				<input id="search_button" type="submit" value="搜索"	name="submit_button" />
			</form>
		</div>
		<div id="login_register">
			<span>欢迎!&nbsp;&nbsp;&nbsp;<a class="log_out" data-path="${path }" href="javascrpit:void(0);">退出</a></span>
		</div>
	</div>
	
	<div id="main_body">
		<%
			if(session.getAttribute("insert_success") != null){
				if(session.getAttribute("insert_success").equals("true")){
		%>
				<script type="text/javascript">
					alert("添加成功！");                                            // 弹出错误信息
				</script> 
		<%		}else{
		%>
				<script type="text/javascript">
					alert("添加失败！");                                            // 弹出错误信息
				</script> 
		<%
		
				}
				session.removeAttribute("insert_success");
			}
		%>
		<div class="import_data">
			<form method="post" action="${path}/InsertData" onsubmit="return import_check()">
			    <ul style="list-style-type: none;">
					<li>
						<span>书名：<input id="book_name" name="book_name" type="text" maxlength="50"/></span>
						<span>ISBN：<input id="ISBN" name="ISBN" type="text" oninput="value=value.replace(/[^\d]/g,'').slice(0,13)"/></span>
						<span>作者：<input id="author" name="author" type="text"/></span>
					</li>
					<li>
						<span style="margin-left:80px;">出版日期：<input id="pub_date" name="pub_date" type="date"/></span>
						<span>价格：<input id="price" name="price" style="margin-left:20px;" type="text" maxlength="10" ></span>
					</li>
					<li>
						<span style="margin-left:-120px;">出版社：<input id="publisher" name="publisher" type="text"/></span>
						<span>数量：<input id="amount" name="amount" style="margin-left:20px;" type="text" maxlength="10" oninput="value=value.replace(/[^\d]|^[0]/g,'').slice(0,10)"/></span>
						<input class="btn_submit" style="margin:35px 0px 0px 108px;width: 100px;height: 28px;font-size:18px;"
						name="submit" type="submit" value="添加"/>
					</li>
				</ul>
			</form>
		</div>
		<div class="book_list">
			<c:set var="pagesize" value="${1}" scope="page"/>
			<sql:setDataSource  var="dataSource" driver="com.mysql.cj.jdbc.Driver"
				url="jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true" user="${admin.name}" password="${admin.password}"/>
			<sql:query dataSource="${dataSource}" var="changelist" scope="page">
				select * from books;
			</sql:query>
			<c:set var="listnum" value="${changelist.rowCount}" scope="page"/>
			<fmt:formatNumber var="managementpagecount" type="number" value="${listnum / pagesize +0.4}" maxFractionDigits="0" scope="page"/>
			
			<%-- managementpage为当前页码 --%>
			<c:choose>
				<c:when test="${(empty param.managementpage)||(param.managementpage<1)||(param.managementpage>managementpagecount)}">
					<c:set var="managementpage" value="${1}"/>
				</c:when>
				<c:otherwise>
					<c:set var="managementpage" value="${param.managementpage}"/>
				</c:otherwise>
			</c:choose>
			
		    <c:forEach var="row" items="${changelist.rows}" begin="${(managementpage - 1) * pagesize}" end="${managementpage * pagesize - 1}">
				<table>
					<tr>
						<td>
				   			<a href="../Images/${row.book_name}.jpg"><img alt="${row.book_name}" src="../Images/${row.book_name}.jpg" width="150px" height="150px"></a>
						</td>
						<td>
							<ul style="list-style-type: none;">
								<li>
									<a href="" style="text-decoration: none; color: blue; font-size: 25px;">${row.book_name}</a>
								</li>
								<li id="book_msg" style="font-size: 16px;">
									${row.author}（著）|&nbsp;ISBN:${row.ISBN}&nbsp;|&nbsp;出版社：${row.publisher}&nbsp;|&nbsp;出版时间：${row.pub_date}
								</li>
								<li style="font-size: 20px;">
									售价：￥
									<input class="incre_decre price_dec" type="button" onclick="incre_decre('-','price_${row.ISBN}')" value="-"/>
									<input id="price_${row.ISBN}" type="text" class="num" value="${row.price}" name="${cart_id }" onchange="datachange('price_${row.ISBN}')"
											oninput="value=value.replace(/[^\d^\.]/g,'').slice(0,17)" /> 
									<input class="incre_decre price_inc" type="button" onclick="incre_decre('+','price_${row.ISBN}')" value="+"/>
									<span style="margin-left: 120px;">
									剩余库存：	
										<input class="incre_decre amount_dec" type="button" onclick="incre_decre('-','amount_${row.ISBN}')" value="-"/>
										<input id="amount_${row.ISBN}" type="text" class="num" value="${row.amount}" onchange="datachange('amount_${row.ISBN}')"
											oninput="value=value.replace(/[^\d]/g,'').slice(0,17)"/>
										<input class="incre_decre amount_inc" type="button" onclick="incre_decre('+','amount_${row.ISBN}')" value="+"/>
									本</span>
								</li>
								<li>
									<form method="post" action="${path}/UpdateData" target="rfFrame" onsubmit="return update('success_${row.ISBN}h')">
										<input id="isbn_${row.ISBN}h" type="hidden" name="ISBN" value="${row.ISBN}"/>
										<input id="price_${row.ISBN}h" type="hidden" name="price" value="${row.price}" />
										<input id="amount_${row.ISBN}h" type="hidden" name="amount" value="${row.amount}"/>
										<input id="update_${row.ISBN}h" style="float:right; margin-top: 10px;" type="submit" value="更新书籍信息"/>
										<iframe id="rfFrame" name="rfFrame" src="about:blank" style="display:none;"></iframe> 
										<span id="success_${row.ISBN}h" style="float:right;margin-top:10px;visibility: hidden;"> <font color="red">更新成功！</font></span>
									</form>
								</li>
							</ul>
						</td>
					</tr>
				</table>
				<hr>
			</c:forEach>  
	    </div>
	</div>
	<div id="bottom_body">
		<div class="page_num">
			<c:if test="${managementpage > 1}">
				<a class="pages" href="${path}/Jsp/management.jsp?managementpage=1" >&nbsp;首页&nbsp;</a>
				<a href="${path}/Jsp/management.jsp?managementpage=${managementpage - 1}" >上一页</a>
			</c:if>
			<c:if test="${managementpage - 2 >= 1}">
				<a href="${path}/Jsp/management.jsp?managementpage=${managementpage - 2}" >&nbsp;&nbsp;${managementpage - 2}&nbsp;&nbsp;</a>
			</c:if>
			<c:if test="${managementpage > 1}">
				<a href="${path}/Jsp/management.jsp?managementpage=${managementpage - 1}" >&nbsp;&nbsp;${managementpage - 1}&nbsp;&nbsp;</a>
			</c:if>
			<span style="color:black;" >&nbsp;${managementpage}&nbsp;</span>
			<c:if test="${managementpage < managementpagecount}">
				<a href="${path}/Jsp/management.jsp?managementpage=${managementpage + 1}" >&nbsp;&nbsp;${managementpage + 1}&nbsp;&nbsp;</a>
			</c:if>
			<c:if test="${managementpage + 2 <= managementpagecount}">
				<a href="${path}/Jsp/management.jsp?managementpage=${managementpage + 2}" >&nbsp;&nbsp;${managementpage + 2}&nbsp;&nbsp;</a>
			</c:if>
			<c:if test="${managementpage < managementpagecount}">
				<a href="${path}/Jsp/management.jsp?managementpage=${managementpage + 1}" >下一页</a>
				<a href="${path}/Jsp/management.jsp?managementpage=${managementpagecount}" >&nbsp;末页&nbsp;</a>
			</c:if>
			共${managementpagecount}页
		</div>
	</div>

</body>
</html>