<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	String msg = request.getParameter("msg");
	
	// 취소했을때 이전 페이지로 돌아가기위함
	int currentPage = 1;
	if (request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + " <-insertBoardForm currentPage");
	int rowPerPage = 5;
	if (request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	System.out.println(rowPerPage + " <-insertBoardForm rowPerPage");
	
	//model
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// localName 출력용 쿼리
	PreparedStatement localNameStmt = null;
	ResultSet localNameRs= null;
	String localNameSql = "SELECT local_name localName FROM local";
	localNameStmt = conn.prepareStatement(localNameSql);
	System.out.println(localNameStmt + " <- insertBoardForm localNameStmt");
	localNameRs = localNameStmt.executeQuery();
	
	ArrayList<Local> localNameList = new ArrayList<Local>();
	while (localNameRs.next()){
		Local l = new Local();
		l.setLocalName(localNameRs.getString("localName"));
		localNameList.add(l);
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
			<div>
				<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
			</div>
			<hr>
			</div>
			<div class="col-md-9">
			<h3>게시글 작성</h3>
			<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" id="submit" method="post">
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
						<th>제목 입력</th>
						<td>
							<select name="localName">
								<option value="">지역 선택</option>
					<%
								for(Local s : localNameList) {
					%>
								<option value="<%=s.getLocalName()%>"><%=s.getLocalName()%></option>
					<%
								}
					%>
							</select>
							<input type="text" name="boardTitle" size="50">
						</td>
					</tr>
					<tr>
						<th>내용 입력</th>
						<td>
							<textarea rows="5" cols="70" name="boardContent"></textarea>
						</td>
					</tr>
				</table>
			</form>
			<form action="<%=request.getContextPath()%>/home.jsp" id="cancle" method="post">
				<input type="hidden" name="currentPage" value="<%=currentPage%>">
				<input type="hidden" name="rowPerPage" value="<%=rowPerPage%>">
			</form>
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