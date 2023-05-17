<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	response.setCharacterEncoding("utf-8");
	// 1. 요청값 처리
	if (request.getParameter("boardNo") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	String msg = null;
	if (request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	int currentPage = 1;
	if (request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 5;
	if (request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	// 댓글 작성 체크용 변수
	boolean login = false;
	String loginMemberId = null;
	if(session.getAttribute("loginMemberId") != null) {
		login = true;
		loginMemberId = (String)session.getAttribute("loginMemberId");
	}
	
	// commentNo값을 요청값으로 받으면 수정 모드
	boolean commentUpdate = false;
	int commentNo = 0;
	if(request.getParameter("commentNo") != null){
		commentUpdate = true;
		commentNo = Integer.parseInt(request.getParameter("commentNo"));
	}
	
	// 페이징 변수
	int currentCommentPage = 1;
	if (request.getParameter("currentCommentPage") != null){
		currentCommentPage = Integer.parseInt(request.getParameter("currentCommentPage"));
	}
	
	int commentRowPerPage = 5;
	if (request.getParameter("commentRowPerPage") != null){
		commentRowPerPage = Integer.parseInt(request.getParameter("commentRowPerPage"));
	}
	
	int pagePerPage = 10;
	int beginRow = (currentCommentPage - 1) * commentRowPerPage;
	int endRow = beginRow + commentRowPerPage;
	int beginPage = ((currentCommentPage - 1) / 10) * 10 + 1;
	int endPage = beginPage + pagePerPage -1;
	
	int totalCnt = 0;
	int totalPageCnt = 0;
	
	// 2. 모델 계층
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 1) 게시글 출력
	String boardOneSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board where board_no = ?";
	PreparedStatement boardOneStmt = conn.prepareStatement(boardOneSql);
	boardOneStmt.setInt(1, boardNo);
	ResultSet boardOneRs = boardOneStmt.executeQuery();
	
	Board boardOne = new Board();
	if(boardOneRs.next()){
		boardOne.setLocalName(boardOneRs.getString("localName"));
		boardOne.setBoardTitle(boardOneRs.getString("boardTitle"));
		boardOne.setBoardContent(boardOneRs.getString("boardContent"));
		boardOne.setMemberId(boardOneRs.getString("memberId"));
		boardOne.setCreatedate(boardOneRs.getString("createdate"));
		boardOne.setUpdatedate(boardOneRs.getString("updatedate"));
	}
	
	// 2) 댓글 출력
	String commentSql = "SELECT board_no boardNo, comment_no commentNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? ORDER BY createdate DESC LIMIT ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, commentRowPerPage);
	ResultSet commentRs = commentStmt.executeQuery();
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while (commentRs.next()){
		Comment c = new Comment();
		c.setBoardNo(commentRs.getInt("boardNo"));
		c.setCommentNo(commentRs.getInt("commentNo"));
		c.setCommentContent(commentRs.getString("commentContent"));
		c.setMemberId(commentRs.getString("memberId"));
		c.setCreatedate(commentRs.getString("createdate"));
		c.setUpdatedate(commentRs.getString("updatedate"));
		commentList.add(c);
	}
	
	// 3) 수정 댓글 값 가져오기
	// commentNo 값이 있을때만 실행
	Comment updateComment = new Comment();
	if (request.getParameter("commentNo") != null){ 
		String updateCommentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? AND comment_no = ?";
		PreparedStatement updateCommentStmt = conn.prepareStatement(updateCommentSql);
		updateCommentStmt.setInt(1, boardNo);
		updateCommentStmt.setInt(2, commentNo);
		ResultSet updateCommentRs = updateCommentStmt.executeQuery();
		
		if (updateCommentRs.next()){
			updateComment.setCommentNo(updateCommentRs.getInt("commentNo"));
			updateComment.setCommentContent(updateCommentRs.getString("commentContent"));
		}
	}
	
	// 게시판 페이징
	PreparedStatement commentCntStmt = null;
	ResultSet commentCntRs = null;
	String commentCntSql = "SELECT COUNT(*) FROM comment WHERE board_no = ?";
	commentCntStmt = conn.prepareStatement(commentCntSql);
	commentCntStmt.setInt(1, boardNo);
	commentCntRs = commentCntStmt.executeQuery();
	
	if(commentCntRs.next()){
		totalCnt = commentCntRs.getInt("COUNT(*)");
		totalPageCnt = (int)Math.ceil((double)totalCnt / commentRowPerPage); 
	}
	
	if(endRow > totalCnt) {
		endRow = totalCnt;
	}
	
	if (endPage > totalPageCnt){
		endPage = totalPageCnt;
	}
	
	//System.out.println(totalCnt + " <-boardOne totalCnt");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link id="theme" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
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
				<table class="table caption-top">
					<caption>
						<div class="container-fluid text-center">
							<div class="row">
								<div class="col-md-2">
								<a class="btn btn-sm btn-outline-primary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage%>&rowPerPage=<%=rowPerPage%>">
									목록
								</a>
								</div>
								<div class="col-md-7">
						<%
								if(msg != null) {
						%>
									<%=msg%>
						<%
								}
						%>
								</div>
								<div class="col-md-3">
									<a class="btn btn-sm btn-outline-primary" href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage%>&rowPerPage=<%=rowPerPage%>">
										수정
									</a>
									<a class="btn btn-sm btn-outline-primary" href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage%>&rowPerPage=<%=rowPerPage%>">
										삭제
									</a>
								</div>
							</div>
						</div>
					</caption>
					<thead class="table-secondary">
						<tr>
							<th>local_name</th>
							<td><%=boardOne.getLocalName()%></td>
							<th>board_title</th>
							<td><%=boardOne.getBoardTitle()%></td>
							<th>member_id</th>
							<td><%=boardOne.getMemberId()%></td>
						</tr>
					</thead>
					<tr>
						<th>board_content</th>
						<td colspan="5"><%=boardOne.getBoardContent()%></td>
					</tr>
					<tr>
						<th>createdate</th>
						<td colspan="2"><%=boardOne.getCreatedate()%></td>
						<th>updatedate</th>
						<td colspan="2"><%=boardOne.getUpdatedate()%></td>
					</tr>
				</table>
				<hr>
				<!-- 댓글 -->
				<h3>댓글창</h3>
				<table class="table text-center">
					<thead class="table-secondary">
						<tr>
							<th>작성자</th>
							<th>댓글내용</th>
							<th>작성날짜</th>
							<th>수정날짜</th>
							<th>수정</th>
							<th>삭제</th>
						</tr>
					</thead>
					<!-- for문 써서 만듬 -->
				<%
					for (Comment c : commentList) {
				%>
					<tr>
						<td><%=c.getMemberId()%></td>
						<td><%=c.getCommentContent()%></td>
						<td><%=c.getCreatedate()%></td>
						<td><%=c.getUpdatedate()%></td>
						<td>
							<a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>">
								수정
							</a>
						</td>
						<td>
							<a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/comment/deleteCommentAction.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>">
								삭제
							</a>
						</td>
					</tr>
				<%
					}
				%>
				</table>
				<table class="table text-center">
				<!-- 페이징 -->
		<%
					int prePage = beginPage - pagePerPage;
					if (prePage < 1){
						prePage = 1;
					}
		
					int nextPage = beginPage + pagePerPage;
					if (nextPage > totalPageCnt){
						nextPage = totalPageCnt;
					}
					
		
					if (currentCommentPage > 1){
		%>
						<td>
							<a class="btn btn-sm" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentCommentPage=<%=prePage%>&commentRowPerPage=<%=commentRowPerPage%>">
								이전
							</a>
						</td>
		<%
					}
					for(int i = beginPage; i <= endPage; i++){
						String highlightcurrentCommentPage = null;
						if (currentCommentPage ==  i) {
							highlightcurrentCommentPage = "table-danger";
						}
		%>
						<td class="<%=highlightcurrentCommentPage%>">
							<a class="btn btn-sm" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentCommentPage=<%=i%>&commentRowPerPage=<%=commentRowPerPage%>">
								<%=i%>
							</a>
						</td>
		<%
						int blankPage = endPage;
						while (i == endPage && blankPage % 10 != 0){
		%>
							<td>&nbsp;</td>
		<%
							blankPage ++;
						}
					}
					if (currentCommentPage < totalPageCnt){
		%>
						<td>
							<a class="btn btn-sm" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentCommentPage=<%=nextPage%>&commentRowPerPage=<%=commentRowPerPage%>">
								다음
							</a>
						</td>
		<%
					}
		%>
				</table>
				<!-- 댓글 작성 -->
				<hr>
		<%
				// insert 값을 디폴트 값으로 가지고 수정상태들어가면 update로 바꿔서 다른 폼 사용
				String formId = null;
		%>
					<div class="table-responsive">
						<table class="table text-center align-middle">
							<tr>
								<th>댓글작성</th>
								<%
									if(login == false){
								%>
										<td>
											<textarea cols="60" rows="3" readonly="readonly">로그인해주세요</textarea>
										</td>
								<%
									} else if (commentUpdate == true){
										formId = "update";
								%>
									<form action="<%=request.getContextPath()%>/comment/updateCommentAction.jsp" method="post" id="update">
										<input type="hidden" name="boardNo" value="<%=boardNo%>">
										<input type="hidden" name="commentNo" value="<%=updateComment.getCommentNo()%>">
										<input type="hidden" name="loginMemberId" value="<%=loginMemberId%>">
										<td>
											<textarea cols="60" rows="3" name="commentContent"><%=updateComment.getCommentContent()%></textarea>
										</td>
									</form>
								<%
									} else {
										formId = "insert";
								%>										
									<form action="<%=request.getContextPath()%>/comment/insertCommentAction.jsp" method="post" id="insert">
										<input type="hidden" name="boardNo" value="<%=boardNo%>">
										<input type="hidden" name="loginMemberId" value="<%=loginMemberId%>">
										<td>
											<textarea cols="60" rows="3" name="commentContent"></textarea>
										</td>
									</form>
								<%
									}
								%>
								<td>
									<button class="btn btn-secondary" type="submit" form="<%=formId%>">댓글 입력</button>
								</td>
							</tr>
						</table>
					</div>
			</div>
		</div>
	</div>
	<div>
		<jsp:include page="/inc/copyRight.jsp"></jsp:include>
	</div>
</body>
</html>