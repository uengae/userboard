<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	response.setCharacterEncoding("utf-8");
	// 1. 요청분석(컨트롤러 계층)
	String msg = null;
	if (request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	// 1) session jsp내장(기본) 객체
	// 2) request / response jsp내장(기본) 객체
	
	// 페이징 변수
	int currentPage = 1;
	if (request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 5;
	if (request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	int pagePerPage = 10;
	int beginRow = (currentPage - 1) * rowPerPage;
	int endRow = beginRow + rowPerPage;
	int beginPage = ((currentPage - 1) / 10) * 10 + 1;
	int endPage = beginPage + pagePerPage -1;
	
	int totalCnt = 0;
	int totalPageCnt = 0;
	
	// localName값이 null로 넘어와도 전체, 전체로 넘어와도 전체 이기때문에 디폴트 값을 전체 로 두었다.
	String localName = "전체";
	if(request.getParameter("localName") != null){
		localName = request.getParameter("localName");
	}

	// 2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://43.201.156.144:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 게시글 출력 쿼리 실행문
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	// localName에 따른 쿼리문 분기
	String boardSql = null;
	
	if (localName.equals("전체")) {
		boardSql = "SELECT local_name localName, board_title boardTitle, board_no boardNo, member_id memberId, createdate FROM board ORDER BY board_no DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1, beginRow);
		boardStmt.setInt(2, rowPerPage);
		// 쿼리 디버깅
		System.out.println(boardStmt + " <- home boardStmt");
		boardRs = boardStmt.executeQuery();
	} else {
		boardSql = "SELECT local_name localName, board_title boardTitle, board_no boardNo, member_id memberId, createdate FROM board WHERE local_name = ? ORDER BY board_no DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, localName);
		boardStmt.setInt(2, beginRow);
		boardStmt.setInt(3, rowPerPage);
		// 쿼리 디버깅
		System.out.println(boardStmt + " <- home boardStmt");
		boardRs = boardStmt.executeQuery();
	}
	
	// boardList <-- 모델 데이터
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(boardRs.next()){
		Board b = new Board();
		b.setBoardNo(boardRs.getInt("boardNo"));
		b.setLocalName(boardRs.getString("localName"));
		b.setBoardTitle(boardRs.getString("boardTitle"));
		b.setMemberId(boardRs.getString("memberId"));
		b.setCreatedate(boardRs.getString("createdate"));
		boardList.add(b);
	}
	// 디버깅
	System.out.println(boardList.size() + " <- home boardList.size()");

	// 게시판 페이징
	PreparedStatement localCntStmt = null;
	ResultSet localCntRs = null;
	String localCntSql = "SELECT COUNT(*) FROM board";
	localCntStmt = conn.prepareStatement(localCntSql);
	localCntRs = localCntStmt.executeQuery();
	
	if(localCntRs.next()){
		totalCnt = localCntRs.getInt("COUNT(*)");
		totalPageCnt = (int)Math.ceil((double)totalCnt / rowPerPage); 
	}
	
	if(endRow > totalCnt) {
		endRow = totalCnt;
	}
	
	if (endPage > totalPageCnt){
		endPage = totalPageCnt;
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
	<%
	// 3. 뷰 계층
		// request.getRequestDispatcher(request.getContextPath() + "/inc/copyRight.jsp").include(request, response);
		// 이코드를 액션태그로 변경하면 아래와 같다.
	%>
	<!-- 메인메뉴 -->
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3">
			<div>
				<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
			</div>
			<hr>
			</div>
	<!--[시작]boardList-------------------------------------------------------------->
			<div class="col-md-9">
			<div>&nbsp;</div>
			<h1>게시판</h1>
			<div>
				<table class="table table-hover caption-top">
					<thead class="table-secondary">
					<tr>
						<th width="20%">local_name</th>
						<th width="40%">board_title</th>
						<th width="20%">member_id</th>
						<th width="30%">createdate</th>
					</tr>
					</thead>
					<caption>
					<div class="container-fluid">
						<div class="row">
							<div class="dropdown col-md-9">
								<button class="btn btn-sm btn-outline-dark dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
									<%=rowPerPage%>개씩
								</button>
								<ul class="dropdown-menu">
									<li><a class="dropdown-item" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage%>&rowPerPage=5">5개</a></li>
									<li><a class="dropdown-item" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage%>&rowPerPage=10">10개</a></li>
									<li><a class="dropdown-item" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage%>&rowPerPage=15">15개</a></li>
									<li><a class="dropdown-item" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage%>&rowPerPage=20">20개</a></li>
								</ul>
							</div>
							<div class="col-md-3">
						<%
								if(session.getAttribute("loginMemberId") != null){
						%>
								<a class="btn btn-sm btn-outline-dark" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp?currentPage=<%=currentPage%>&rowPerPage=<%=rowPerPage%>">
									게시글 쓰기
								</a>
						<%
								}
						%>
							</div>
						</div>
					</div>
					</caption>
				<%
					for(Board b : boardList) {
				%>
					<tr>
						<td><%=b.getLocalName()%></td>
						<td>
							<a class="btn" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>&currentPage=<%=currentPage%>&rowPerPage=<%=rowPerPage%>">
								<%=b.getBoardTitle()%>
							</a>
						</td>
						<td>
							<%=b.getMemberId()%>
						</td>
						<td>
							<%=b.getCreatedate().substring(0, 10)%>
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
						
			
						if (currentPage > 1){
			%>
							<td>
								<a class="btn btn-sm" href="<%=request.getContextPath()%>/home.jsp?localName=<%=localName%>&currentPage=<%=prePage%>&rowPerPage=<%=rowPerPage%>">
									이전
								</a>
							</td>
			<%
						}
						for(int i = beginPage; i <= endPage; i++){
							String highlightCurrentPage = null;
							if (currentPage ==  i) {
								highlightCurrentPage = "table-danger";
							}
			%>
							<td class="<%=highlightCurrentPage%>">
								<a class="btn btn-sm" href="<%=request.getContextPath()%>/home.jsp?localName=<%=localName%>&currentPage=<%=i%>&rowPerPage=<%=rowPerPage%>">
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
						if (currentPage < totalPageCnt){
			%>
							<td>
								<a class="btn btn-sm" href="<%=request.getContextPath()%>/home.jsp?localName=<%=localName%>&currentPage=<%=nextPage%>&rowPerPage=<%=rowPerPage%>">
									다음
								</a>
							</td>
			<%
						}
			%>
				</table>
		</div>
	</div>
	<!--[끝]boardList-------------------------------------------------------------->
	<div>
		<jsp:include page="/inc/copyRight.jsp"></jsp:include>
	</div>
</body>
</html>