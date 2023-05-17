<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	response.setCharacterEncoding("utf-8");

	// controller
	if (request.getParameter("boardNo") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	int currentPage = 1;
	if (request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 5;
	if (request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	String msg = null;
	if (request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	if(session.getAttribute("loginMemberId") == null) {
		msg = URLEncoder.encode("로그인 해야합니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	// 2. 모델 계층
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 게시글 출력
	String deleteBoardSql = "SELECT member_id memberId FROM board WHERE board_no = ?";
	PreparedStatement deleteBoardStmt = conn.prepareStatement(deleteBoardSql);
	deleteBoardStmt.setInt(1, boardNo);
	ResultSet deleteBoardRs = deleteBoardStmt.executeQuery();
	
	Board deleteBoard = new Board();
	if(deleteBoardRs.next()){
		deleteBoard.setMemberId(deleteBoardRs.getString("memberId"));
	}
	
	// 사용자 체크
	if (!deleteBoard.getMemberId().equals(loginMemberId)){
		msg = URLEncoder.encode("다른 사용자 입니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 뷰 계층 -->
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3">
				<div>
					<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
				</div>
			</div>
	<!-- 게시글 -->
			<div class="col-md-9">
			<h3>게시글</h3>
				<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp" id="submit" method="post">
					<table class="table caption-top">
						<caption>
							<div class="container-fluid text-center">
								<div class="row">
									<div class="col-md-9">
							<%
									if(msg != null) {
							%>
										<%=msg%>
							<%
									}
							%>
									</div>
								</div>
							</div>
						</caption>
						<thead class="table-secondary">
							<tr>
								<th>member_id</th>
								<td><%=deleteBoard.getMemberId()%></td>
							</tr>
						</thead>
						<tr>
							<th>비밀번호 입력</th>
							<td>
								<input type="password" name="password">
							</td>
						</tr>
					</table>
					<input type="hidden" name="boardNo" value="<%=boardNo%>">
					<input type="hidden" name="currentPage" value="<%=currentPage%>">
					<input type="hidden" name="rowPerPage" value="<%=rowPerPage%>">
				</form>
				<form action="<%=request.getContextPath()%>/board/boardOne.jsp" id="cancle" method="post">
					<input type="hidden" name="boardNo" value="<%=boardNo%>">
					<input type="hidden" name="currentPage" value="<%=currentPage%>">
					<input type="hidden" name="rowPerPage" value="<%=rowPerPage%>">
				</form>
				<button class="btn btn-outline-primary" type="submit" form="submit">삭제</button> 
				<button class="btn btn-outline-primary" type="submit" form="cancle">취소</button> 
			</div>
		</div>
	</div>
</body>
</html>