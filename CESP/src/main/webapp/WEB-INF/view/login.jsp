<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- DW6 -->
<head>
<!-- Copyright 2005 Macromedia, Inc. All rights reserved. -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EnterSafe PKI 管理工具</title>
<link rel="stylesheet" href="image/emx_nav_left.css" type="text/css" />
<!-- Codebase="/../Debug/FtCom11.dll#Version=1,0,8,1231\" -->
<!-- FtCom11Attribute -->
<OBJECT classid="clsid:F97C817C-0E0F-4BFB-B8DB-36438A1DE479"
	id="Com11Attribute" name="Com11Attribute"></OBJECT>
<!-- FtCom11Token -->
<OBJECT classid="clsid:B40AD154-5022-47C3-935D-0926951B64B0"
	id="Com11Token" name="Com11Token"></OBJECT>
<!-- FtCom11Slot -->
<OBJECT classid="clsid:A22FB3C3-8D22-4A52-8F0F-6855BBBAE5A0"
	id="Com11Slot" name="Com11Slot"></OBJECT>
<!-- FtCom11If -->
<OBJECT classid="clsid:A5F1473C-3BAF-4098-885A-9DD332433FD5"
	id="Com11If" name="Com11If"></OBJECT>

<script type="text/javascript">

var time = 3000;
var numofitems = 7;
var g_data;
String.prototype.Trim = function()
{
	return this.replace(/(^\s*)|(\s*$)/g, "");
}

//menu constructor
function menu(allitems,thisitem,startstate){ 
  callname= "gl"+thisitem;
  divname="subglobal"+thisitem;  
  this.numberofmenuitems = allitems;
  this.caller = document.getElementById(callname);
  this.thediv = document.getElementById(divname);
//  this.thediv.style.visibility = startstate;
}

//menu methods
function ehandler(event,theobj){
  for (var i=1; i<= theobj.numberofmenuitems; i++){
    var shutdiv =eval( "menuitem"+i+".thediv");
    shutdiv.style.visibility="hidden";
  }
  theobj.thediv.style.visibility="visible";
}
function closesubnav(event){
/*
  if ((event.clientY <48)||(event.clientY > 107)){
    for (var i=1; i<= numofitems; i++){
      var shutdiv =eval('menuitem'+i+'.thediv');
      shutdiv.style.visibility='hidden';
    }
  }
*/
}

/*
 * 当卡插入时
*/
function WhenKeyInsert(slotID)
{
	alert(slotID+"号卡被插入");
	document.getElementById("currentSlotID").value = slotID;
	//pageDetailCtrl_div层
	if( null == document.getElementById('isLogin_'+slotID) )
	{
		document.getElementById("pageDetailCtrl_div").innerHTML += "<input type='hidden' id='isLogin_" + slotID + "' name='isLogin_" + slotID + "' value='0' >";
	}
	if( null == document.getElementById('maxPINLen_'+slotID) )
	{
		document.getElementById("pageDetailCtrl_div").innerHTML += "<input type='hidden' id='maxPINLen_" + slotID + "' name='maxPINLen_" + slotID + "' value='0' >";
	}
	if( null == document.getElementById('minPINLen_'+slotID) )
	{
		document.getElementById("pageDetailCtrl_div").innerHTML += "<input type='hidden' id='minPINLen_" + slotID + "' name='minPINLen_" + slotID + "' value='0' >";
	}
	//userStatus_div层
	if( null == document.getElementById('loginStatus_'+slotID) )
	{
		document.getElementById("userStatus_div").innerHTML += "<input id='loginStatus_" + slotID + "' name='loginStatus_" + slotID + "' value='' readonly='1'>";
	}
	else
	{
		document.getElementById("userStatus_div").style.display = '';
		document.getElementById('loginStatus_'+slotID).style.display = '';
		document.getElementById("loginStatus_"+slotID).value = 0;
	}
	showSlotList(0);
}
/*
 * 当卡拔出时
*/
function WhenKeyRemove(slotID)
{
	alert(slotID+"号卡被拔出！");
	document.getElementById("login_div").style.display = "none";
	
	document.getElementById('isLogin_'+slotID).value = 0;
	document.getElementById('maxPINLen_'+slotID).value = 0;
	document.getElementById('minPINLen_'+slotID).value = 0;
	document.getElementById('loginStatus_'+slotID).value = '';
	document.getElementById('loginStatus_'+slotID).style.display = 'none';
	
	showSlotList(0);
}
/*
 * 初始化：设置卡插拔事件相应的JS函数名称
*/
function Init()
{
	//判断浏览器类型
	if(navigator.userAgent.indexOf("MSIE")>0)
	{
		//login_div层PIN码检查
		document.getElementById('PIN').attachEvent("onpropertychange", CheckPINLength);
	}
	else if(navigator.userAgent.indexOf("Firefox")>0)
	{
		//login_div层PIN码检查
		document.getElementById('PIN').addEventListener("input", CheckPINLength, false);
	}
	Com11If.WhenKeyRemove = "WhenKeyRemove";
	Com11If.WhenKeyInsert = "WhenKeyInsert";
}

/*
 * 检查PIN码长度
*/
function CheckPINLength(v)
{
	var elementID = event.srcElement.id;

	var currentSlotID = document.getElementById("currentSlotID").value;
	var maxPINLen = document.getElementById("maxPINLen_" + currentSlotID).value;
	var minPINLen = document.getElementById("minPINLen_" + currentSlotID).value;

	var val = document.getElementById(elementID).value;
	//login_div层PIN码检查
	if( "PIN" == elementID )
	{
		if( val.length <= maxPINLen && val.length >= minPINLen )
		{
			document.getElementById("login").disabled = 0;
		}
		else
		{
			document.getElementById("login").disabled = 1;
		}
	}
	//modifyUPIN_div层PIN码检查
	else if( "old_uPIN" == elementID || "new_uPIN" == elementID || "verify_uPIN" == elementID )
	{
		if( val.length <= maxPINLen && val.length >= minPINLen )
		{
			document.getElementById("modifyUPIN").disabled = 0;
		}
		else
		{
			document.getElementById("modifyUPIN").disabled = 1;
		}
	}
	//modifyOPIN_div层PIN码检查
	else if( "old_oPIN" == elementID || "new_oPIN" == elementID || "verify_oPIN" == elementID )
	{
		if( val.length <= maxPINLen && val.length >= minPINLen )
		{
			document.getElementById("modifyOPIN").disabled = 0;
		}
		else
		{
			document.getElementById("modifyOPIN").disabled = 1;
		}
	}
	//unblockToken_div层PIN码检查
	else if( "oPIN" == elementID || "set_uPIN" == elementID || "verifyset_uPIN" == elementID )
	{
		if( val.length <= maxPINLen && val.length >= minPINLen )
		{
			document.getElementById("unblockToken").disabled = 0;
		}
		else
		{
			document.getElementById("unblockToken").disabled = 1;
		}
	}
	//initToken_div层PIN码检查
	else if( "os_PIN" == elementID || "new_uPIN_" == elementID || "verify_uPIN_" == elementID )
	{
		if( val.length <= maxPINLen && val.length >= minPINLen )
		{
			document.getElementById("initToken").disabled = 0;
		}
		else
		{
			document.getElementById("initToken").disabled = 1;
		}
	}
}

/*
 * 检查Token名称长度
*/
function CheckTNLength(v)
{
	var elementID = event.srcElement.id;

	var val = document.getElementById(elementID).value;
	//initToken_div层TN检查
	if( "label" == elementID )
	{
		if( val.length <= 32 && 0 != val.Trim().length )
		{
			document.getElementById("initToken").disabled = 0;
		}
		else
		{
			document.getElementById("initToken").disabled = 1;
		}
	}
	//modifyTN_div层TN检查
	else if( "new_TN" == elementID )
	{
		if( val.length <= 32 && 0 != val.Trim().length )
		{
			document.getElementById("modifyTN").disabled = 0;
		}
		else
		{
			document.getElementById("modifyTN").disabled = 1;
		}
	}
}

/*
 * 获取槽列表
*/
function showSlotList(flag)
{
	//pageCtrl_div层 
	document.getElementById("pageCtrl_div").innerHTML = "";
	document.getElementById("pageCtrl_div").innerHTML += "<input type='text' id='validSlotCount' name='validSlotCount' value='0' >";
	document.getElementById("pageCtrl_div").innerHTML += "<input type='text' id='currentSlotID' name='currentSlotID' value='0' >";

	//查询所有已插入卡的槽列表
	var currentSlotID = 0;				//当前操作的智能卡ID
	var slotList = Com11If.GetSlotList();
	if( null != slotList )
	{
		//修改槽列表显示信息
		document.getElementById("slotLinks_div").style.display = "";
		document.getElementById("slotlabel").innerHTML = "已插入卡的槽列表";
		//将获取到的槽列表转换成数组，存储到全局变量g_slotIDs中
		var slotIDs = new VBArray( slotList ).toArray();
		var slotCount = slotIDs.length;	//已插入的智能卡数量
		var slotID = 0;
		//画槽信息隐藏域
		for( var i=0; i<slotCount; i++ )
		{
			slotID = slotIDs[i];
			//pageCtrl_div层 type='text' 
			document.getElementById("pageCtrl_div").innerHTML += "<input type='text' id='validSlotID_" + i + "' name='validSlotID_" + i + "' value='0' >";
			//pageDetailCtrl_div层
			if( null == document.getElementById('isLogin_'+slotID) )
			{
				document.getElementById("pageDetailCtrl_div").innerHTML += "<input type='type' id='isLogin_" + slotID + "' name='isLogin_" + slotID + "' value='0' >";
			}
			else if( 1 == flag )
			{
				document.getElementById("isLogin_"+slotID).value = 0;
			}
			if( null == document.getElementById('maxPINLen_'+slotID) )
			{
				document.getElementById("pageDetailCtrl_div").innerHTML += "<input type='text' id='maxPINLen_" + slotID + "' name='maxPINLen_" + slotID + "' value='0' >";
			}
			else if( 1 == flag )
			{
				document.getElementById("maxPINLen_"+slotID).value = 0;
			}
			if( null == document.getElementById('minPINLen_'+slotID) )
			{
				document.getElementById("pageDetailCtrl_div").innerHTML += "<input type='text' id='minPINLen_" + slotID + "' name='minPINLen_" + slotID + "' value='0' >";
			}
			else if( 1 == flag )
			{
				document.getElementById("minPINLen_"+slotID).value = 0;
			}
			//userStatus_div层
			if( null == document.getElementById('loginStatus_'+slotID) )
			{
				document.getElementById("userStatus_div").innerHTML += "<input id='loginStatus_" + slotID + "' name='loginStatus_" + slotID + "' value='' readonly='1'>";
			}
			else if( 1 == flag )
			{
				document.getElementById("loginStatus_"+slotID).value = 0;
			}
		}

		//将槽列表信息存入隐藏域
		document.getElementById("validSlotCount").value = slotCount;
		
		if( slotCount > 0 )
		{
			//遍历卡的当前状态，选第一个已插入的卡为当前卡
			for( var i=0; i<slotCount; i++ )
			{
				slotID = slotIDs[i];
				
				if( 0 == i )
				{
					currentSlotID = slotID;
				}

				//将槽列表信息存入隐藏域
				var tokenInfo = Com11If.GetTokenInfo(slotID);
				if( tokenInfo )
				{
					document.getElementById("validSlotID_" + i ).value = slotID;
					document.getElementById("maxPINLen_" + slotID).value = tokenInfo.GetMaxPinLen();
					document.getElementById("minPINLen_" + slotID).value = tokenInfo.GetMinPinLen();
				}
				
				//获取槽信息
				var slotInfo = Com11If.GetSlotInfo(slotID);
				if( slotInfo )
				{
					if( 1 == document.getElementById('isLogin_'+slotID).value )
					{
						document.getElementById("loginStatus_" + slotID).value = slotInfo.GetSlotDescription().replace(/[ ]/g,"") + "  槽已登录";
					}
					else
					{
						document.getElementById("loginStatus_" + slotID).value = slotInfo.GetSlotDescription().replace(/[ ]/g,"") + "  槽未登录";
					}
					
					//初始化槽列表
					document.getElementById("slotLinks_div").innerHTML += "<a id='slotDesc_"+slotID+"' style='display:none;' href='#' onclick='showTokenInfo("+slotID+")' ></a>";
					document.getElementById("slotLinks_div").innerHTML += "<a id='slotData_"+slotID+"' style='display:none;' href='#' onclick='showObjectList("+slotID+")'></a>";
					document.getElementById("slotDesc_"+slotID).style.display = "";
					document.getElementById("slotDesc_"+slotID).innerHTML = slotInfo.GetSlotDescription();
					document.getElementById("slotData_"+slotID).style.display = "";
					document.getElementById("slotData_"+slotID).innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;Data";

					//初始化槽下拉列表
					var slotDescription = slotInfo.GetSlotDescription();
					//初始化“用户登录”的槽下拉列表
					var login_objectItem = new Option(slotDescription, slotID);
					document.getElementById("login_slotSel").options.add(login_objectItem);
					
					document.getElementById("slotLinks_div").style.display = "";
				}
			}
			document.getElementById("currentSlotID").value = currentSlotID;
		}
		
	}
}

//用户登录模块
/*
 * 点击用户登录的“槽列表”
*/
function LoginSelectSlot()
{
	var currentSlotID = document.getElementById("login_slotSel").value;
	document.getElementById("currentSlotID").value = currentSlotID;
	document.getElementById("login").disabled = 1;
	
	//判断选择的卡是否已经登录
	if( 1 == document.getElementById("isLogin_" + currentSlotID).value )
	{
		document.getElementById("PIN").disabled = 1;
	}
	else
	{
		document.getElementById("PIN").disabled = 0;
		document.getElementById("PIN").focus();
	}
}
/*
 * 点击“用户登录”
*/
function Login()
{
	//清空表单元素
	document.getElementById("PIN").value = "";
	document.getElementById("PIN").disabled = 1;
	document.getElementById("login").disabled = 1;
	
	//检查卡是否插入
	if( 0 == document.getElementById("validSlotCount").value )
	{
		alert("请插入卡！");
		return ;
	}

	if( "" == document.getElementById("login_div").style.display )
	{
		document.getElementById("login_div").style.display = "none";
	}
	else
	{
		document.getElementById("login_div").style.display = "";
		/*
		//遍历卡的登录状态
		var validSlotCount = document.getElementById("validSlotCount").value;
		for( var i=0; i<validSlotCount; i++ )
		{
			var slotID = document.getElementById("validSlotID_" + i).value;
			if( 0 == document.getElementById("isLogin_"+slotID).value )
			{
				document.getElementById("PIN").disabled = 0;
				document.getElementById("PIN").focus();
				break;
			}
			else
			{
				document.getElementById("PIN").disabled = 1;
				break;
			}
		}
		*/
		var slotID = document.getElementById("login_slotSel").value;
		if( 0 == document.getElementById("isLogin_"+slotID).value )
		{
			document.getElementById("PIN").disabled = 0;
			document.getElementById("PIN").focus();
		}
	}
}

/*
 * 用户登录
*/
function onLogin()
{
	//检查是否输入PIN码
	var PIN = document.getElementById("PIN").value;
	if( "" ==  PIN)
	{
		alert("请输入PIN码！");
		document.getElementById("PIN").focus();
	}
	else
	{
		//登录
		var slotID = document.getElementById("login_slotSel").value;
		document.getElementById("currentSlotID").value = slotID;
		var desc = document.getElementById("loginStatus_" + slotID).value;
		var ret = Com11If.Login( slotID, PIN );
		if( false == ret )
		{
			var count = Com11If.GetPINTryCounter( slotID, 1);
			if( 0 == count)
			{
				alert("卡已经死锁！");
			}
			else if(0xFFFF == count)
			{
			    alert("Token异常！请重新插拔后重试！");
			}
			else
				alert("登录失败，你还有 "+count+"次机会！");
			document.getElementById("PIN").value = "";
			document.getElementById("PIN").focus();
			document.getElementById("isLogin_" + slotID).value = 0;
			//修改用户状态显示
			document.getElementById("loginStatus_" + slotID).value = desc.substring(0, desc.indexOf("槽")) + "槽未登录";
		}
		else
		{
			alert("登录成功！");
			document.getElementById("isLogin_" + slotID).value = 1;
			//修改用户状态显示（已登录）
			document.getElementById("login_div").style.display = "none";
			document.getElementById("loginStatus_" + slotID).value = desc.substring(0, desc.indexOf("槽")) + "槽已登录";
			//showObjectList(slotID);
		}
	}
}

</script>
</head>
<body onload="javascript:Init(); showSlotList(1);"
	onmousemove="closesubnav(event);">
	<!-- pagecell1_div层 -->
	<div id="pagecell1_div">

		<!-- pageName_div层 -->
		<div id="pageName_div"></div>
		<!-- end pageName_div -->
		<!-- pageNav_div层 -->
		<!-- 页面状态控制层   重要-->
		<div id="pageCtrl_div"></div>
		<!-- end pageCtrl_div -->
		<div id="pageDetailCtrl_div"></div>
		<!-- end pageDetailCtrl_div -->
		<div id="pageNav_div">
			<h5 id="slotlabel"></h5>
			<!-- slotLinks_div层   重要-->
			<div id="slotLinks_div" class="slotLinks" style="display: none;">

			</div>
			<!-- end slotLinks_div -->
			<div id="optionLinks_div">
				<a href="#">用户状态</a>
				<div id="userStatus_div" style="display:"></div>
				<!-- end userStatus_div -->
				
				<!-- 用户登录层 -->
			    <a href="#" id="in" onclick="Login()">用户登录</a>
				<input type="text" id="islogin_1" disabled style="display:none" >
				<input type="text" id="islogin_2" disabled style="display:none" >
		    	<div id="login_div" style="display:none">
				  请选择：
				  <select id="login_slotSel" name="login_slotSel" style="width:153px " onchange="LoginSelectSlot()" >
				  </select><br><!-- onpropertychange= "CheckPINLength(this.value)" -->
			  	  PIN: <input type="password" size=14 id="PIN" disabled /><br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  <input type="button" id="login" onclick="onLogin()" value="确定" disabled />
			  	</div><!-- end login_div -->
			</div>
			<!-- end pageNav_div -->
		</div>
		<!--end pagecell1-->
</body>
</html>
