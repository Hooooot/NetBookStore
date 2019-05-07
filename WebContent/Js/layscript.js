layui.use(["layer","form","laypage","element"],function(){
	var layer = layui.layer;
	var $ = jQuery = layui.jquery;
	var form =layui.form;
	
	form.on("submit(get_question)",function(data){
		$.post("../CheckQuestion",
			  {
			      "question":$(".question").val(),
			      "answer":$(".answer").val()
			  },
				function(data){
					if($.trim(data) == "true"){
						location.replace("./new_password.jsp")
					}else{
						layer.alert(data);
					}
				})
		return true;
	});
});

