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
<script src="../Js/VerifyCode.js"></script>
<script src="../Layui/layui.js"></script>
<script src="../Js/scripts.js"></script>
<script>
layui.use(["layer","form"],function(){
	var layer = layui.layer;
	var $ = jQuery = layui.jquery;
	var form =layui.form;
	var verifyCode = new GVerify("verifycode_container");
	
	form.on("submit(newaccount)", function(data){
		var input = verifyCode.validate($(".code").val())
		if(!input){
			layer.alert("验证码错误！");
			return false;
		}
	    if ($("#account_inputs").val() == '') {
	        layer.alert("请输入账号！")
	        return false;
	    }
	    $.post("../SignUpCheck",
	    		data.field,
	    		function(data){
	    	if($.trim(data) == 'true'){
	    		alert("注册成功！")
	    		location.href='./login.jsp';
	    	}else{
	    		layer.alert(data);
	    	}
	    });
	    return true;
	})
});
</script>
<title>注册账号</title>
</head>
<body>
	<div class="sign_box">
		<div class="layui-form">
			<img src="../Images/come_on.gif" height="300px" width="300px">
			<div id="pswd_tip" style="height:25px;visibility: hidden;margin: 10px 10px;">
			    <img src="../Images/error.png" style="float:left;height:25px;width:25px;">
			    <span style="font-size:16px;margin-top:10px;">&nbsp;&nbsp;密码两次输入不一致或密码为空！</span> 
			</div>
			<div style="border:1px solid #cccccc;height: 38px">
			    <img src="../Images/user.png" class="input_pic">
			    <input id="account_inputs" class="login_input" type="text" name="account"
			    	oninput="value=value.replace(/[^0-9^_^a-z^A-Z\^]/g,'').slice(0,18)" placeholder="请输入名称（只允许英文字符、数字、_）"/>
			</div>
			<div style="border:1px solid #cccccc; height: 38px;margin-top:15px;">
			    <img src="../Images/password.png" class="input_pic">
			    <input id="password_inputs" class="login_input" type="password" name="password" 
			    	oninput="value=value.replace(/[^\d^_^a-z^A-Z\^]/g,'').slice(0,18)" placeholder="请输入密码（只允许英文字符、数字、_）" onblur="same_password()"/>
			</div>
			<div style="border:1px solid #cccccc; height: 38px;margin-top:15px;">
			    <img src="../Images/password.png" class="input_pic">
			    <input id="password_inputs_again" class="login_input" type="password" name="password_a" 
			        placeholder="请再次输入密码（密码长度最多18位）" onblur="same_password()"/>
			</div>
			<div style="font-size:14px;margin-top:15px;">
				<select class="question" name = "question" lay-verify="required" >
			        <option value="">请选择密保问题</option>
			        <option value="1">您父亲的姓名？</option>
			        <option value="2">您母亲的姓名？</option>
			        <option value="3">您的生日是什么时候？</option>
			        <option value="4">您毕业于哪所小学？</option>
			        <option value="5">您高中班主任的名字？</option>
			        <option value="6">您的宠物叫什么？</option>
			    </select>
			    <input class="layui-input answer" style="margin-top:15px;" lay-verify="required" name="answer" autocomplete="off" placeholder="请输入答案"/>
			</div>
			<div style="font-size:14px;margin:15px 0px;">
				<input class="layui-input code" style="width:150px;display:inline-block;float:left;" lay-verify="required" type="text" placeholder="请输入验证码"/>
				<div id="verifycode_container" style="width:120px;height:40px;display:inline-block;margin-left:30px;"></div>
			</div>
			<div style="height:20px;">
				<a style="color:blue;font-size: 12px;float:right;" href="./login.jsp">已有账号？立即登录&gt;&gt;&gt;</a>
			</div>
			<input id="sign_up_submit" class="btn_submit" style="background:dimgray;" lay-submit="" title="密码输入需要一致" lay-filter="newaccount" type="submit" value="注册" disabled="disabled" />
		</div>
	</div>
</body>
</html>