<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");

	 System.out.println(" <- deleteCommentAction -> ");
	
	//1. 컨트롤러 계층
	if (request.getParameter("boardNo") == null
			|| request.getParameter("commentNo") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
/* 	System.out.println(boardNo + " <- deleteCommentAction boardNo");
	System.out.println(commentNo + " <- deleteCommentAction commentNo");
	System.out.println(loginMemberId + " <- deleteCommentAction loginMemberId");*/
	

	// 2. 모델 계층
	String msg = null;
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://43.201.156.144:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// memberId 일치 쿼리 실행문
	PreparedStatement checkIdStmt = null;
	ResultSet checkIdRs = null;
	String checkIdSql = "SELECT COUNT(*) cnt FROM comment WHERE board_no = ? AND comment_no = ? AND member_id = ? ";
	checkIdStmt = conn.prepareStatement(checkIdSql);
	checkIdStmt.setInt(1, boardNo);
	checkIdStmt.setInt(2, commentNo);
	checkIdStmt.setString(3, loginMemberId);
	// System.out.println(checkIdStmt + " <- deleteCommentAction checkIdStmt");
	checkIdRs = checkIdStmt.executeQuery();
	
	if (checkIdRs.next()) {
		System.out.println(checkIdRs.getInt("cnt") + " <- deleteCommentAction cnt");
		if(checkIdRs.getInt("cnt") < 1){
			msg = URLEncoder.encode("다른 댓글을 삭제할 수 없습니다.", "utf-8");
			response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
			return;
		}
		
	}
	
	// comment 수정 쿼리 실행문
	String deleteCommentSql = "DELETE FROM comment WHERE board_no = ? AND comment_no = ? AND member_id = ?";
	PreparedStatement deleteCommentStmt = conn.prepareStatement(deleteCommentSql);
	deleteCommentStmt.setInt(1, boardNo);
	deleteCommentStmt.setInt(2, commentNo);
	deleteCommentStmt.setString(3, loginMemberId);
	// System.out.println(deleteCommentStmt + " <- deleteCommentAction deleteCommentStmt");
	int row = deleteCommentStmt.executeUpdate();
	System.out.println(row + " <- deleteCommentAction row");
	
	// row 값에 따른 분기
	msg = URLEncoder.encode("댓글이 삭제되었습니다.", "utf-8");
	if (row < 1){
		msg= URLEncoder.encode("댓글 삭제에 실패했습니다.", "utf-8");
	}
	
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
%>