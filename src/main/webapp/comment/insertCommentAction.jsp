<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	// 1. 컨트롤러 계층
	if (request.getParameter("boardNo") == null
			|| request.getParameter("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String loginMemberId = request.getParameter("loginMemberId");
	String commentContent = request.getParameter("commentContent");
	
	System.out.println(boardNo + " <- insertCommentAction boardNo");
	System.out.println(loginMemberId + " <- insertCommentAction loginMemberId");
	System.out.println(commentContent + " <- insertCommentAction commentContent");

	// 2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String insertCommentSql = "INSERT INTO COMMENT(board_no, comment_content, member_id, createdate, updatedate) value(?, ?, ?, NOW(), NOW())";
	PreparedStatement insertCommentStmt = conn.prepareStatement(insertCommentSql);
	insertCommentStmt.setInt(1, boardNo);
	insertCommentStmt.setString(2, commentContent);
	insertCommentStmt.setString(3, loginMemberId);
	System.out.println(insertCommentStmt + " <- insertCommentAction insertCommentStmt");
	int row = insertCommentStmt.executeUpdate();
	System.out.println(row + " <- insertCommentAction row");
	
	String msg = URLEncoder.encode("댓글이 작성되었습니다.", "utf-8");
	
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo + "&msg=" + msg);
%>