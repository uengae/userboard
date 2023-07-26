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
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
		return;
	}
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	// 2. 모델 계층
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://43.201.156.144:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 게시글 출력
	String updateBoardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board where board_no = ?";
	PreparedStatement updateBoardStmt = conn.prepareStatement(updateBoardSql);
	updateBoardStmt.setInt(1, boardNo);
	ResultSet updateBoardRs = updateBoardStmt.executeQuery();
	
	Board updateBoard = new Board();
	if(updateBoardRs.next()){
		updateBoard.setLocalName(updateBoardRs.getString("localName"));
		updateBoard.setBoardTitle(updateBoardRs.getString("boardTitle"));
		updateBoard.setBoardContent(updateBoardRs.getString("boardContent"));
		updateBoard.setMemberId(updateBoardRs.getString("memberId"));
	}
	
	// 사용자 체크
	if (!updateBoard.getMemberId().equals(loginMemberId)){
		msg = URLEncoder.encode("다른 사용자 입니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage +"&rowPerPage=" +rowPerPage);
		return;
	}
	
	// localName 출력용 쿼리
	PreparedStatement localNameStmt = null;
	ResultSet localNameRs= null;
	String localNameSql = "SELECT local_name localName FROM local WHERE local_name != ?";
	localNameStmt = conn.prepareStatement(localNameSql);
	localNameStmt.setString(1, updateBoard.getLocalName());
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
			<div>&nbsp;</div>
			<h3>게시글</h3>
				<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" id="submit" method="post">
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
								<th>local_name</th>
								<td>
									<select name="localName">
										<option value="<%=updateBoard.getLocalName()%>"><%=updateBoard.getLocalName()%></option>
							<%
										for(Local s : localNameList) {
							%>
										<option value="<%=s.getLocalName()%>"><%=s.getLocalName()%></option>
							<%
										}
							%>
									</select>
								</td>
								<th>board_title</th>
								<td>
									<input type="text" name="boardTitle" value="<%=updateBoard.getBoardTitle()%>">
								</td>
								<th>member_id</th>
								<td><%=updateBoard.getMemberId()%></td>
							</tr>
						</thead>
						<tr>
							<th>board_contens</th>
							<td colspan="5">
								<textarea rows="5" cols="70" name="boardContent"><%=updateBoard.getBoardContent()%></textarea>
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
				<button class="btn btn-outline-primary" type="submit" form="submit">수정</button> 
				<button class="btn btn-outline-primary" type="submit" form="cancle">취소</button> 
			</div>
		</div>
	</div>
</body>
</html>