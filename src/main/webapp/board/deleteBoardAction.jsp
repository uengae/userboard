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
	if ("".equals(request.getParameter("password"))){
		msg = URLEncoder.encode("비밀번호를 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/deleteBoardForm.jsp?boardNo=" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	
	String password = request.getParameter("password");
	
	// model
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://43.201.156.144:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 비번 체크용 쿼리문
	PreparedStatement checkPwStmt = null;
	ResultSet checkPwRs = null;
	String checkPwSql = "SELECT COUNT(*) cnt FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	checkPwStmt = conn.prepareStatement(checkPwSql);
	checkPwStmt.setString(1, loginMemberId);
	checkPwStmt.setString(2, password);
	System.out.println(checkPwStmt + " <- deleteLocalNameAction checkPwStmt");
	checkPwRs = checkPwStmt.executeQuery();
	
	if (checkPwRs.next()) {
		if(checkPwRs.getInt("cnt") < 1){
			msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8");
			response.sendRedirect(request.getContextPath() + "/board/deleteBoardForm.jsp?boardNo=" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
			return;
		}
		
	}
	
	// 게시글 delete 처리 쿼리문
	PreparedStatement deleteBoardStmt = null;
	String deleteBoardSql = "DELETE FROM board WHERE board_no = ?";
	deleteBoardStmt = conn.prepareStatement(deleteBoardSql);
	deleteBoardStmt.setInt(1, boardNo);
	System.out.println(deleteBoardStmt + " <- deleteBoardAction stmt");
	int row = deleteBoardStmt.executeUpdate();
	
	msg = URLEncoder.encode("게시글을 삭제했습니다.", "utf-8");
	if(row < 1){
		msg = URLEncoder.encode("게시글 수정 실패", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/deleteBoardForm.jsp?boardNo" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	
	response.sendRedirect(request.getContextPath() + "/home.jsp?boardNo=" + boardNo + "&msg=" + msg + "&currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
%>