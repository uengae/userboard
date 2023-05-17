<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	// controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(loginMemberId + " <- updateMemberForm loginMemeberId");
	
	String msg = null;
	if (request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	// model
		
	
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
				<h1>회원탈퇴</h1>
				<div>
				<%
					if(msg != null){
				%>
					<%=msg%>
				<%	
					}
				%>
				</div>
				<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp" method="post" id="submit">
						<table class="table">
							<thead class="table-secondary">
								<tr>
									<th width="30%">member_id</th>
									<td>
										<%=loginMemberId%>
									</td>
								</tr>
							</thead>
						<tr>
							<td colspan="2">
								비밀번호 입력 : <input type="password" name="password">
							</td>
						</tr>
					</table>
				</form>
				<form action="<%=request.getContextPath()%>/member/memberInformation.jsp" method="post" id="cancle"></form>
				<button class="btn btn-outline-primary" type="submit" form="submit">탈퇴</button>
				<button class="btn btn-outline-primary" type="submit" form="cancle">취소</button>
			</div>
		</div>
	</div>
	<div>
		<jsp:include page="/inc/copyRight.jsp"></jsp:include>
	</div>
</body>
</html>