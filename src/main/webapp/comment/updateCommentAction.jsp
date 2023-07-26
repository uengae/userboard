<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");

	System.out.println(" <- updateCommentAction -> ");
	//1. 컨트롤러 계층
	if (request.getParameter("boardNo") == null
			|| request.getParameter("commentNo") == null
			|| request.getParameter("loginMemberId") == null
			|| request.getParameter("commentContent") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String loginMemberId = request.getParameter("loginMemberId");
	String commentContent = request.getParameter("commentContent");
	/* System.out.println(boardNo + " <- updateCommentAction boardNo");
	System.out.println(commentNo + " <- updateCommentAction commentNo");
	System.out.println(loginMemberId + " <- updateCommentAction loginMemberId");
	System.out.println(commentContent + " <- updateCommentAction commentContent"); */
	

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
	// System.out.println(checkIdStmt + " <- updateCommentAction checkIdStmt");
	checkIdRs = checkIdStmt.executeQuery();
	
	if (checkIdRs.next()) {
		if(checkIdRs.getInt("cnt") < 1){
			msg = URLEncoder.encode("다른 댓글을 수정할 수 없습니다.", "utf-8");
			response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
			return;
		}
		
	}
	
	// comment 수정 쿼리 실행문
	String updateCommentSql = "UPDATE comment SET comment_content = ?, updatedate = now() WHERE board_no = ? AND comment_no = ? AND member_id = ?";
	PreparedStatement updateCommentStmt = conn.prepareStatement(updateCommentSql);
	updateCommentStmt.setString(1, commentContent);
	updateCommentStmt.setInt(2, boardNo);
	updateCommentStmt.setInt(3, commentNo);
	updateCommentStmt.setString(4, loginMemberId);
	// System.out.println(updateCommentStmt + " <- updateCommentAction updateCommentStmt");
	int row = updateCommentStmt.executeUpdate();
	System.out.println(row + " <- updateCommentAction row");
	
	
	msg = URLEncoder.encode("댓글이 수정되었습니다.", "utf-8");
	if (row < 1){
		msg= URLEncoder.encode("댓글 수정에 실패했습니다.", "utf-8");
	}
	
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
%>