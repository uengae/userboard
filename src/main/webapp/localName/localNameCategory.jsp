<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	// admin이 아닐 시 수정 불가
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	if (!"admin".equals(loginMemberId)){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
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
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String localNameSql = "SELECT DISTINCT local_name localName FROM board";
	PreparedStatement localNameStmt = conn.prepareStatement(localNameSql);
	ResultSet localNameRs = localNameStmt.executeQuery();
	
	ArrayList<Local> localNameList = new ArrayList<Local>();
	while(localNameRs.next()){
	Local local = new Local();
	local.setLocalName(localNameRs.getString("localname"));
	localNameList.add(local);
	}

	String newLocalNameSql = "SELECT local_name localName FROM local WHERE local_name NOT IN (SELECT DISTINCT local_name localName FROM board)";
	PreparedStatement newLocalNameStmt = conn.prepareStatement(newLocalNameSql);
	ResultSet newLocalNameRs = newLocalNameStmt.executeQuery();
	
	while(newLocalNameRs.next()){
	Local local = new Local();
	local.setLocalName("new! " + newLocalNameRs.getString("localname"));
	localNameList.add(local);
	}
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
		<h3>지역 카테고리 수정</h3>
		<table class="table table-hover">
					<thead class="table-secondary">
					<tr>
						<th>local_name</th>
						<th>수정</th>
						<th>삭제</th>
					</tr>
					</thead>
				<%
					for(Local l : localNameList) {
				%>
					<tr>
						<td><%=l.getLocalName()%></td>
						<td>
							<a class="btn" href="<%=request.getContextPath()%>/localName/updateLocalNameForm.jsp?localName=<%=l.getLocalName()%>">
								수정
							</a>
						</td>
						<td>
							<a class="btn" href="<%=request.getContextPath()%>/localName/deleteLocalNameForm.jsp?localName=<%=l.getLocalName()%>">
								삭제
							</a>
						</td>
					</tr>
				<%
					}
				%>		
					<tr>
						<td colspan="3">
							<a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/localName/insertLocalNameForm.jsp">
								지역 추가
							</a>
						</td>
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