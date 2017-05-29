<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>股权买卖管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$.ajax({ 
				type: "post", 
				url : "${ctx}/equity/equitySell/getMoney", 
				dataType:'json',
				data: {}, 
				success: function(json){
					if(json != null){
						$("#buyMoney").val(json.tradingMoney);
						$("#equitySellId").val(json.id);
						$("#tdNum").val(parseInt(json.tradingNum)-parseInt(json.buyNum));
						$("#bNum").html("可购买数量："+(parseInt(json.tradingNum)-parseInt(json.buyNum)));
					}else {
						alert("暂无股票可以购买！");
						$("#buyNum").attr("readOnly",true);
					}
					
				}
			}); 
			$("#inputForm").validate({
				
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
		
		function changeNum(){
			var tdNum = $("#tdNum").val();
			var buyNum = $("#buyNum").val();
			if(parseInt(tdNum) < parseInt(buyNum)){
				alert("购买数量超过"+tdNum+",请重新填写");
				$("#buyNum").val("");
				return false;
			}
		}

	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		
		<li class="active"><a href="${ctx}/equity/equityBuy/form?id=${equityTrading.id}">股票买入<shiro:hasPermission name="equity:equityBuy:edit"></shiro:hasPermission><shiro:lacksPermission name="equity:equityBuy:edit">查看</shiro:lacksPermission></a></li>
	<li><a href="${ctx}/equity/equityBuy/">股票买入记录</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="equityBuy" action="${ctx}/equity/equityBuy/save" method="post" class="form-horizontal">
	<input name="tdNum" id="tdNum" value="" type="hidden">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<form:input path="equitySellId" htmlEscape="false" maxlength="100" class="input-xlarge" id="equitySellId" type="hidden"/>
		<div class="control-group">
			<label class="control-label">购买数量：</label>
			<div class="controls">
				<form:input path="buyNum" htmlEscape="false" maxlength="100" class="input-xlarge required " onchange="changeNum()" id="buyNum"/>
				<span class="help-inline"><font color="red">*</font> </span>
				<span id="bNum" style="color:red"></span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">购买金额：</label>
			<div class="controls">
				<form:input path="buyMoney" htmlEscape="false" maxlength="100" class="input-xlarge required" id="buyMoney" readOnly="true" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge " style="width:270px"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="equity:equityBuy:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>