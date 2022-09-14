<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<script>
function fn_login2(){
	document.frm.action = "/member/registerIntCast";
	document.frm.submit();
}
function fn_login3(){
	document.frm.action = "/member/registerParamCorrect";
	document.frm.submit();
}
</script>
<title>로그인</title>
<link rel="stylesheet" href="/resources/css/bootstrap.min.css" />
</head>
<body>
<jsp:include page="../shopping/menu.jsp" />
<div class="jumbotron">
		<!-- container : 이 안에 내용있다 -->
		<div class="container">
			<h1 class="display-3">로그인</h1>
		</div>
</div>
<div class="container" align="center">
	<div class="col-md-4 col-md-offset-4">
		<h3 class="form-signin-heading">Please sign in</h3>
		<c:if test="${error==1}">
			<div class="alert alert-danger">
				아이디와 비밀번호를 확인해 주세요
			</div>
		</c:if>
		<form class="form-signin" action="/member/processLoginMember" method="post">
<!-- 		<form name="frm" class="form-signin" action="/member/register" method="get"> -->
			<div class="form-group">
				<label for="inputUserName" class="sr-only">User Name</label>
				<input type="text" class="form-control" placeholder="id" name="id" required autofocus />
			</div>
<!-- 			<div class="form-group"> -->
<!-- 				<label for="inputBir" class="sr-only">birth</label> -->
<!-- 				<input type="text" class="form-control" placeholder="bir" name="bir" required autofocus /> -->
<!-- 			</div> -->
			<div class="form-group">
				<label for="inputPassword" class="sr-only">Password</label>
				<input type="password" class="form-control" placeholder="Password" name="password" required />
			</div>
<!-- 			<div class="form-group"> -->
<!-- 				<label for="coin" class="sr-only">Password</label> -->
<!-- 				<input type="text" class="form-control" placeholder="coin" name="coin" required /> -->
<!-- 			</div> -->
			<button type="submit" class="btn btn btn-lg btn-success btn-block">로그인</button>
<!-- 			<button type="button" class="btn btn btn-lg btn-secondary btn-block" onclick="fn_login2()">로그인2</button> -->
<!-- 			<button type="button" class="btn btn btn-lg btn-secondary btn-block" onclick="fn_login3()">로그인3</button> -->
		</form>
<!-- 		<p><a href="/member/regitster/a001">개똥이</a></p> -->
<!-- 		<p><a href="/member/regitster/b001">메뚜기</a></p> -->
<!-- 		<p><a href="/member/regitster/c001">우영우</a></p> -->
	</div>
</div>
<jsp:include page="../shopping/footer.jsp" />
</body>
</html>