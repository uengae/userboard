<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
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
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://43.201.156.144:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement updateMemberStmt = null;
	ResultSet updateMemberRs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String updateMemberSql = "SELECT member_id memberId, createdate, updatedate from member where member_id = ?";
	updateMemberStmt = conn.prepareStatement(updateMemberSql);
	updateMemberStmt.setString(1, loginMemberId);
	updateMemberRs = updateMemberStmt.executeQuery();
	
	Member m = new Member();
	if (updateMemberRs.next()){
		m.setMemberId(updateMemberRs.getString("memberId"));
		m.setCreatedate(updateMemberRs.getString("createdate"));
		m.setUpdatedate(updateMemberRs.getString("updatedate"));
	}
	
	// view
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
			<h1>비밀번호 수정</h1>
			<div>
			<%
				if(msg != null){
			%>
				<%=msg%>
			<%	
				}
			%>
			</div>
			<form action="<%=request.getContextPath()%>/member/updateMemberAction.jsp" method="post" id="submit">
				<table class="table">
					<thead class="table-secondary">
						<tr>
							<th width="30%">member_id</th>
							<td>
								<%=m.getMemberId()%>
							</td>
						</tr>
					</thead>
					<tr>
						<td colspan="2">
							현재 비밀번호 입력 : <input type="password" name="currentPassword">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							새로운 비밀번호 입력 : <input type="password" name="newPassword">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							새로운 비밀번호 확인 : <input type="password" name="newPasswordCheck">
						</td>
					</tr>
				</table>
			</form>
			<form action="<%=request.getContextPath()%>/member/memberInformation.jsp" method="post" id="cancle"></form>
			<button class="btn btn-outline-primary" type="submit" form="submit">수정</button>
			<button class="btn btn-outline-primary" type="submit" form="cancle">취소</button>
			</div>
		</div>
	</div>
	<div>
		<jsp:include page="/inc/copyRight.jsp"></jsp:include>
	</div>
</body>
</html>