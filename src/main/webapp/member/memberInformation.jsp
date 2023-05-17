<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	// controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(loginMemberId + " <- memberInformation loginMemeberId");
	
	// model
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement memberInformationStmt = null;
	ResultSet memberInformationRs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String memberInformationSql = "SELECT member_id memberId, createdate, updatedate from member where member_id = ?";
	memberInformationStmt = conn.prepareStatement(memberInformationSql);
	memberInformationStmt.setString(1, loginMemberId);
	memberInformationRs = memberInformationStmt.executeQuery();
	
	Member m = new Member();
	if (memberInformationRs.next()){
		m.setMemberId(memberInformationRs.getString("memberId"));
		m.setCreatedate(memberInformationRs.getString("createdate"));
		m.setUpdatedate(memberInformationRs.getString("updatedate"));
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
			<h1>회원정보</h1>
			<table class="table">
				<tr>
					<th class="table-secondary" width="30%">member_id</th>
					<td>
						<%=m.getMemberId()%>
					</td>
				</tr>
				<tr>
					<th class="table-secondary" width="30%">createdate</th>
					<td>
						<%=m.getCreatedate()%>
					</td>
				</tr>
				<tr>
					<th class="table-secondary" width="30%">updatedate</th>
					<td>
						<%=m.getUpdatedate()%>
					</td>
				</tr>
				<tr>
					<th colspan="2">
						<a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/member/updateMemberForm.jsp">
							비밀번호 수정
						</a>
						<a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp">
							회원탈퇴
						</a>
					</th>
				</tr>
			</table>
			</div>
		</div>
	</div>
	<div>
		<jsp:include page="/inc/copyRight.jsp"></jsp:include>
	</div>
</body>
</html>