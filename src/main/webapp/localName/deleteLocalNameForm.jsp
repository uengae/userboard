<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	response.setCharacterEncoding("utf-8");
	// controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	if (!"admin".equals(loginMemberId)){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	String localName = request.getParameter("localName");
	System.out.println(localName + " <- updateLocalName localName");
	String msg = request.getParameter("msg");
	// model
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 웹에 출력할 local 데이터 가져오기
	PreparedStatement updateLocalNameStmt = null;
	ResultSet updateLocalNameRs = null;
	String updateLocalNameSql = "SELECT local_name localName, createdate, updatedate FROM local WHERE local_name = ?";
	updateLocalNameStmt = conn.prepareStatement(updateLocalNameSql);
	updateLocalNameStmt.setString(1, localName);
	System.out.println(updateLocalNameStmt + " <- updateLocalName stmt");
	updateLocalNameRs = updateLocalNameStmt.executeQuery();
	
	Local l = new Local();
	if(updateLocalNameRs.next()){
		l.setLocalName(updateLocalNameRs.getString("localName"));
		l.setCreatedate(updateLocalNameRs.getString("createdate"));
		l.setUpdatedate(updateLocalNameRs.getString("updatedate"));
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
	<div>
		<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
	</div>
	<h1>local_name 삭제</h1>
	<div>
	<%
		if(msg != null){
	%>
		<%=msg%>
	<%	
		}
	%>
	</div>
	<form action="<%=request.getContextPath()%>/localName/deleteLocalNameAction.jsp" method="post" id="submit">
		<table class="table table-striped">
			<tr>
				<th>local_name</th>
				<td>
					<input type="hidden" value="<%=l.getLocalName()%>" name="localName" >
					<%=l.getLocalName()%>
				</td>
			</tr>
			<tr>
				<th>createdate</th>
				<td>
					<%=l.getCreatedate()%>
				</td>
			</tr>
			<tr>
				<th>updatedate</th>
				<td>
					<%=l.getUpdatedate()%>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					비밀번호 입력 : <input type="password" name="password">
				</td>
			</tr>
		</table>
	</form>
	<form action="<%=request.getContextPath()%>/localName/localNameCategory.jsp" id="cancle"></form>
	<button type="submit" form="submit">삭제</button>
	<button type="submit" form="cancle">취소</button>
	<div>
		<jsp:include page="/inc/copyRight.jsp"></jsp:include>
	</div>
</body>
</html>