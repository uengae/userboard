<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	// session 유효성 검사
	if(session.getAttribute("loginMemberId") != null){
		// response는 클라이언트에서 실행되기 때문에 request.getContextPath()해줘야한다.
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link id="theme" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3">
				<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
			</div>
			<div class="col-md-9">
			<div>&nbsp;</div>
			<h1>회원 가입</h1>
			<div>
			<%
				if(msg != null){
			%>
				<%=msg%>
			<%	
				}
			%>
			</div>
			<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
				<table class="table">
					<tr>
						<th width="30%" class="table-secondary">아이디 입력</th>
						<td>
							<input type="text" name="memberId">
						</td>
					</tr>
					<tr>
						<th class="table-secondary">비밀번호 입력</th>
						<td>
							<input type="password" name="memberPw">
						</td>
					</tr>
					<tr>
						<th class="table-secondary">비밀번호 재입력</th>
						<td>
							<input type="password" name="memberPw2">
						</td>
					</tr>
				</table>
				<button class="btn btn-outline-primary" type="submit">회원가입</button>
			</form>
			</div>
		</div>
	</div>
	<div>
		<jsp:include page="/inc/copyRight.jsp"></jsp:include>
	</div>
</body>
</html>