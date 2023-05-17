<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setCharacterEncoding("utf-8");
	
	//controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	// admin만 접근 가능하게 셋팅
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	if (!"admin".equals(loginMemberId)){
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
			<div>
				<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
			</div>
			<hr>
			</div>
			<div class="col-md-9">
			<h3>local_name 추가</h3>
			<form action="<%=request.getContextPath()%>/localName/insertLocalNameAction.jsp" id="submit" method="post">
				<table class="table caption-top">
					<caption>
						<div>
						<%
							if(msg != null){
						%>
							<%=msg%>
						<%	
							}
						%>
						</div>
					</caption>
					<tr>
						<th width="30%" class="table-secondary">local_name</th>
						<td>
							<input type="text" name="localName">
						</td>
					</tr>
					<tr>
						<th class="table-secondary">비밀번호 입력	</th>
						<td>
							<input type="password" name="password">
						</td>
					</tr>
				</table>
			</form>
			<form action="<%=request.getContextPath()%>/localName/localNameCategory.jsp" id="cancle" method="post"></form>
			<button class="btn btn-outline-primary" type="submit" form="submit">추가</button>
			<button class="btn btn-outline-primary" type="submit" form="cancle">취소</button>
			</div>
		</div>
	</div>
	<div>
		<jsp:include page="/inc/copyRight.jsp"></jsp:include>
	</div>
</body>
</html>