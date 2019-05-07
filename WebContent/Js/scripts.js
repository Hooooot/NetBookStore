function input_check() {
    acc = document.getElementById("account_input")
    pswd = document.getElementById("password_input")
    ac = acc.value
    ps = pswd.value
    if (ac == '' || ac == null || ps == '' || ps == null) {
        alert("请输入账号和密码！")
        return false
    }
    return true
}

/* 搜索框默认值：时间简史 */
function search() {
    input = document.getElementById("search_input")
    str = input.value
    if (str == '' || str == null) {
        input.value = "时间简史"
    }
    return true
}

/* 检查两次输入的密码是否一致 */
function same_password() {
    var pswd = document.getElementById("password_inputs")
    var pswd_a = document.getElementById("password_inputs_again")
    var btn = document.getElementById("sign_up_submit")
    var tip = document.getElementById("pswd_tip")
    if(btn == null){
    	var btn = document.getElementById("reset_pswd_submit")
        if (pswd.value == pswd_a.value &&pswd.value !=''&& pswd_a.value!=null){
        	$("#reset_pswd_submit").removeClass("layui-btn-disabled");
        	btn.setAttribute("title","点击注册");
            btn.disabled = false
            tip.style.visibility = "hidden"
        } else {  
        	$("#reset_pswd_submit").addClass("layui-btn-disabled");
        	btn.setAttribute("title","密码输入需要一致");
            btn.disabled = true
            tip.style.visibility = "visible"
        }
    }else{
        if (pswd.value == pswd_a.value &&pswd.value !=''&& pswd_a.value!=null){
        	btn.style.background = "RGB(51,133,255)";
        	btn.setAttribute("title","点击注册");
            btn.disabled = false
            tip.style.visibility = "hidden"
        } else {  
        	btn.style.background = "dimgray";
        	btn.setAttribute("title","密码输入需要一致");
            btn.disabled = true
            tip.style.visibility = "visible"
        }
    }
    


}
/* 显示更新成功management.jsp */
function hn(obj){
	var o = document.getElementById(obj)
	o.style.visibility = "hidden";	
}
function update(obj){
	var o = document.getElementById(obj)
	o.style.visibility = "visible"
	ooo = obj
	window.setTimeout("hn(ooo)",3000)
	return true;
}


/* 所有的+-按钮 */  // 多次复用。。。。
function incre_decre(isIncre, obj, price,totl){
	var amount = document.getElementById(obj)
	var oh = document.getElementById(obj+'h')  // 带h的obj
	if(oh != null){
		if(obj.indexOf("price") > -1){
			if(isIncre == '-'){	
				if(parseFloat(amount.value) < 0.1)
					return
				amount.value = (parseFloat(amount.value) - 0.1).toFixed(2)
				oh.value = amount.value
			}else{
				amount.value = (parseFloat(amount.value) + 0.1).toFixed(2)
				oh.value = amount.value
			}
		}else{
			if(isIncre == '-'){	
				if(parseInt(amount.value) < 1)
					return
				amount.value = parseInt(amount.value) - 1
				oh.value = amount.value
			}else{
				amount.value = parseInt(amount.value) + 1
				oh.value = amount.value
			}
		}
	}else{
		if(isIncre == '-'){
			if(parseInt(amount.value) < 1)
				return
			amount.value = parseInt(amount.value) - 1
		}else{
			amount.value = parseInt(amount.value) + 1
		}
		total = document.getElementById(totl)
		all = document.getElementById("all_total")
		old = parseFloat(total.innerText)
		total.innerText = (parseFloat(price) * parseInt(amount.value)).toFixed(2)
		dvalue = parseFloat(total.innerText) - old
		all.innerText = (parseFloat(all.innerText)  + dvalue).toFixed(2)
		var path = $("#all_total").data("path");
		if(typeof(path) == 'undefined'){
			path = $('.settlement_btn').data("path");
		}
		if(typeof(path) == 'undefined'){
			return;
		}

		$.post(path + "/UpdateCart",
				{
				"amount":$('#' + obj).val(),
				"cart_id":$('#' + obj).attr("name")
				},
				function(data){
					if($.trim(data) == 'true'){
						alert("更新成功！");
					}else {
						alert(data);
					}
				});
	}
}
/* 管理界面management.jsp */
function datachange(id){
	$('#'+id+"h").val($('#'+ id).val());
}
/* 购物车cart.jsp */
function changed(price, am, totl, ava){
	total = document.getElementById(totl)
	amount = document.getElementById(am)
	if(amount.value == ''){
		amount.value = 0;
	}
	all = document.getElementById("all_total")
	old = parseFloat(total.innerText)
	total.innerText = (parseFloat(price) * parseInt(amount.value)).toFixed(2)
	dvalue = parseFloat(total.innerText) - old
	all.innerText = (parseFloat(all.innerText)  + dvalue).toFixed(2)
	var path = $("#all_total").data("path");
	if(typeof(path) == 'undefined'){
		path = $('.settlement_btn').data("path");
	}
	if(typeof(path) == 'undefined'){
		return;
	}
	$.post(path + "/UpdateCart",
			{
				"amount":$('#' + am).val(),
				"cart_id":$('#' + am).attr("name")
			},
			function(data){
					if($.trim(data) == 'true'){
					alert("更新成功！");
				}else {
					alert(data);
				}
			});

}
/* 管理员导入书籍信息management.jsp */
function import_check(){
	var name = document.getElementById("book_name")
	var ISBN = document.getElementById("ISBN")
	var author = document.getElementById("author")
	var pub_date = document.getElementById("pub_date")
	var publisher = document.getElementById("publisher")
	var price = document.getElementById("price")	
	var amount = document.getElementById("amount")
	if(name.value == ''){
		alert("书名不能为空！")
		return false
	}
	if(ISBN.value == ''){
		alert("ISBN编号不能为空！")
		return false
	}
	if(author.value == ''){
		alert("作者不能为空！")
		return false
	}
	if(pub_date.value == ''){
		alert("出版时间不能为空！")
		return false
	}
	if(publisher.value == ''){
		alert("出版社不能为空！")
		return false
	}
	if(price.value == ''){
		price.value = 0.0
		return false
	}
	if(amount.value == ''){
		amount.value = 0
		return false
	}
	return true
}
/* 直接购买buynow.jsp */
function neworder(amount){
	var amount = document.getElementById(amount).value;
	var isbn = $('.neworder').data("isbn");
	var path = $('.neworder').data("path");
	$.post(path + "/NewOrder",
			{
				"amount":amount,
				"ISBN":isbn
			},function(data){
				alert(data);
			})
}


//  jquery.js--------------------------------------------------------------------------------------------------------


$('document').ready(function(){
	/* 购物车删除图书 */
	$('.cart_del').click(function(){
		var path = $('.cart_del').data("path");
		if(confirm("确定要删除此图书？")){
			$.post(
					path + "/CartDel", 
				{
					"id":$(this).attr('id')
				},
				function(data){
					if($.trim(data) == 'true'){
						alert("删除成功！");
						location.reload();
					}else{
						alert(data);
						window.location.replace(path + "/Jsp/home.jsp");
					}
				})
			
		}
	})
	
	/* 加入到购物车homejsp */
	$('.add_cart').click(function(){
		var ISBN = $(this).attr('name');
		var user_id = $('#'+ISBN).attr('class');
		var available_amount = $('#'+ISBN).val();
		user_id = $.trim(user_id);
		var path = $('.add_cart').data("path")
		if(user_id == null || user_id == ""){
			alert("您尚未登录，请先登录！");
			return;
		}
		if(available_amount<=0){
			alert("库存不足，无法添加！");
			return;
		}
		$.post(path + "/AddToCart",
				{
					"ISBN":ISBN
				},
				function(data){
					if($.trim(data) == 'true'){
						alert("添加成功！");
					}else if($.trim(data) == ''){
						alert("未知错误，添加失败！");
					}else{
						alert(data);
					}
					
				})
		
		})
	/* 退出登录 */
	$('.log_out').click(function(){
		var path = $('.log_out').data("path");
		$.get(
				path + "/LogOut",
				function(data){
					if($.trim(data) == 'true'){
						alert("您已退出登录！");
					}
					location.reload();
		})
	})
	
	/* 多选 */
	$('.choose_all').click(function(){
		if($('.choose_all').prop('checked')){
			$('.choose_one').prop('checked',true);
		}else{
			$('.choose_one').prop('checked',false);
		}
	})

	$('.choose_one').click(function(){
		if($('.choose_one:checked').size() == $('.choose_all').val()){
			$('.choose_all').prop('checked',true)
		}else{
			$('.choose_all').prop('checked',false)
		}
	})
	/* 返回首页cart.jsp */
	$('.rtn_home').click(function(){
		var path = $('.rtn_home').data("path");
		window.location.replace(path + "/Jsp/home.jsp");
	})

	$('.del_choose').click(function(){
		var path=$('.del_choose').data("path");
		var cart_ids=new Array();
		if($('.choose_one:checked').length <= 0){
			alert("请选择书籍！");
			return;
		}
		$('.choose_one:checked').each(function(){
			cart_ids.push($(this).attr("name"));
		})
		$.post(path+"/CartDel",
				{cart_ids:cart_ids},
				function(data){
					if($.trim(data) == 'true'){
						alert("删除成功！");
					}else {
						alert(data);
					}
					location.reload();
		})
	})

/*    $(".loginpop").click(function(){
    	
        $(".mask").css('display','block'); 
        $(".signbox").css('display','block');  
    });*/
	
/*	 购买信息弹出框关闭cart.jsp 
    $(".close").click(function(){  
        $(".mask").css('display','none'); 
        $(".signbox").css('display','none');  
    });*/
    
     /* 关闭悬浮窗  */
    $(".close").click(function(){  
        $(".mask").css('display','none'); 
        $(".settlement_page").css('display','none');
    });
    /* 所有弹出框的close按钮hover事件 */
    $(".close").hover(function(){  
    	$(".close").attr("src","../Images/black.svg")
    },function(){
    	$(".close").attr("src","../Images/white.svg")
    });
    
    
    /* 用户信息悬浮窗 */
    $(".user_nm").hover(function(){
    	$(".user_panel").slideDown("fast");
    },
    function(){
    	$(".user_panel").slideUp(1);
    })
    /* 用户信息悬浮窗 */
    $(".user_panel").hover(function(){
    	$(".user_panel").slideDown(0);
    },
      function(){
    	$(".user_panel").slideUp("fast");
    })

    /* 购买信息弹出框内容cart.jsp */
    $(".settlement").click(function(){
		if($('.choose_one:checked').length <= 0){
			alert("请选择书籍！");
			return;
		}
        var total_price = 0;
        var total_book = '';
        $(".mask").css('display','block');
        $(".settlement_page").css('display','block'); 
		$('.choose_one:checked').each(function(){
			ISBN = $('.' + $(this).attr("name")).val();
			total_book = total_book + $('.' + $(this).attr("name")).attr("name")  + "："+ $('#amount_' + ISBN).val() + "本<br>";
			total_price += parseFloat($('#single_total_' +ISBN).text());
		})
		$('.context_book').html(total_book);
		$('.context_price').html(total_price.toFixed(2) + '元');
    });
    
    /* 提交订单cart.jsp */
    $('.settlement_btn').click(function(){
    	var cart_ids=new Array();
    	var path = $('.settlement_btn').data("path");
    	$('.choose_one:checked').each(function(){
    		cart_ids.push($(this).attr("name"));
    	})
    	$.post(path + "/CartToOrder",
    			{cart_ids:cart_ids},
    			function(data){
    				alert(data);
    				location.reload();
    	})
    })

    
	/* 删除购物车内的商品 */
	$('.del_choose_order').click(function(){
		var order_ids=new Array();
		var path = $('.del_choose_order').data("path");
		if($('.choose_one:checked').length <= 0){
			alert("请选择书籍！");
			return;
		}
		$('.choose_one:checked').each(function(){
			order_ids.push($(this).attr("name"));
		})
		$.post(path + "/OrderDel",
				{order_ids:order_ids},
				function(data){
					if($.trim(data) == 'true'){
						alert("删除成功！");
					}else {
						alert(data);
					}
					location.reload();
		})
	})
	
	/* 其他数额金钱输入框控制deposit.jsp */
	$('.money').click(function(){
		if($('.money:checked').val() == "其他"){
			$('.deposit_text').prop("disabled",false);
		}else{
			$('.deposit_text').prop("disabled",true);
		}
    })
    
	/* 显示二维码弹窗deposit.jsp */
 	$('.showQRcode').click(function(){
 		if(($('.deposit_text').val() == ''|| $('.deposit_text').val() == 'undefined') && $('.money:checked').val() == '其他'){
 			alert("请先填写数额");
 		}else{
 			$('.QRcode').css('display','block');
 			$('.full_mask').css('display','block');
 		}
 	})
 	
 	/* 弹出框关闭deposit.jsp */
 	$('.deposit_close').click(function(){
 	 	$('.QRcode').css('display','none');
 	 	$('.deposit_close').css('display','none');
 	})
 	/* 立即购买home.jsp */
 	$('.buy_now').click(function(){
 		var path = $('.buy_now').data("path");
 		var ISBN = $('.buy_now').attr("name");
 		window.location.href=path + "/Jsp/buy_now.jsp?ISBN=" + ISBN;
 	})
 	/* 购物车物品数量+ */
 	$('.incre').click(function(){
 		var ISBN = $('.incre').data("isbn")
 		var price = $('.incre').data("price")
 		var available = $('.incre').data("available")
 		var totalprice = parseFloat($('#single_total_'+ISBN).text());
 		var amount = parseInt($('#amount_'+ISBN).val());
 		if(amount < available){
 			$('#amount_'+ISBN).val(amount + 1);
 			totalprice = totalprice + parseFloat(price);
 		}
 		else{
 			alert("已达到库存最大值！无法继续添加！")
 		}
 		$('#single_total_'+ISBN).text(totalprice.toFixed(2));	
 		
 	})
 	/* 购物车物品数量- */
 	 $('.decre').click(function(){
 		var ISBN = $('.decre').data("isbn")
 		var price = $('.decre').data("price")
 		var totalprice = parseFloat($('#single_total_'+ISBN).text());
 		var amount = parseInt($('#amount_'+ISBN).val());
 		if(amount < 1){
 			$('#amount_'+ISBN).val(0);
 			totalprice = 0;
 		}else{
 			$('#amount_'+ISBN).val(amount - 1);
 			totalprice = totalprice - parseFloat(price);
 		}
 		$('#single_total_'+ISBN).text(totalprice.toFixed(2));
 	})
 	/* 登录弹出框显示 */
	$(".loginpop").click(function(){
	    $(".full_mask").css('display','block'); 
	 	$(".login_pop_box").css('display','block');  
	});
    
    /* 登录弹出框关闭 */
	$(".close_img").click(function(){  
	 	$(".full_mask").css('display','none'); 
	 	$(".login_pop_box").css('display','none');  
	});
	/* 登录弹出框登录按钮 */
	$('.pop_login_btn').click(function(){
		var path = $('.pop_login_btn').data("path");
		var account = $('.pop_account_ipt').val();
		var pswd = $('.pop_pswd_ipt').val();
		if(account == '' || pswd == ''){
			alert("账号和密码不能为空！")
			return;
		}
		$.post(path + "/LoginCheck",
				{
					"account":account,
					"password":pswd,
					"isNewWay":"true"
				},
				function(result){
					if($.trim(result) == "true"){
						location.reload();
					}else{
						alert(result);
					}
				})
	})
	
});