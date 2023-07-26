<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//controller
	if (session.getAttribute("loginMemberId") == null
			|| request.getParameter("boardNo") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	// 입력 실패 했을때 이전페이지와 같은 값을 주기위함
	int currentPage = 1;
	if (request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// System.out.println(currentPage + " <-insertBoardForm currentPage");
	
	int rowPerPage = 5;
	if (request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	// System.out.println(rowPerPage + " <-insertBoardForm rowPerPage");
	
	String msg = null;
	
	// 입력값 없을때 분기
	if ("".equals(request.getParameter("boardTitle"))){
		msg = URLEncoder.encode("제목을 입력해 주세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?boardNo=" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	
	if ("".equals(request.getParameter("boardContent"))){
		msg = URLEncoder.encode("내용을 입력해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?boardNo=" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	// model
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://43.201.156.144:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 게시글 update 처리 쿼리문
	PreparedStatement updateBoardStmt = null;
	String updateBoardSql = "UPDATE board SET local_name = ?, board_title = ?, board_content = ?, updatedate = NOW() WHERE board_no = ?";
	updateBoardStmt = conn.prepareStatement(updateBoardSql);
	updateBoardStmt.setString(1, localName);
	updateBoardStmt.setString(2, boardTitle);
	updateBoardStmt.setString(3, boardContent);
	updateBoardStmt.setInt(4, boardNo);
	System.out.println(updateBoardStmt + " <- updateBoardAction stmt");
	//executeUpdate()는 결과값이 int이기 때문에 resurtset 말고 인트 변수에 저장하면 된다.
	int row = updateBoardStmt.executeUpdate();
	
	msg = URLEncoder.encode("게시글을 수정했습니다.", "utf-8");
	if(row < 1){
		msg = URLEncoder.encode("게시글 수정 실패", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?boardNo" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
%>