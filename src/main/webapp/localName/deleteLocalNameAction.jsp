<%@page import="org.mariadb.jdbc.ServerPreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	response.setCharacterEncoding("utf-8");
	// controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	String localName = request.getParameter("localName");
	String password = request.getParameter("password");

	// model
	String msg = null;
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 비밀번호 일치 쿼리 실행문
	PreparedStatement checkPwStmt = null;
	ResultSet checkPwRs = null;
	String checkPwSql = "SELECT COUNT(*) cnt FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	checkPwStmt = conn.prepareStatement(checkPwSql);
	checkPwStmt.setString(1, loginMemberId);
	checkPwStmt.setString(2, password);
	System.out.println(checkPwStmt + " <- updateLocalNameAction checkPwStmt");
	checkPwRs = checkPwStmt.executeQuery();
	
	if (checkPwRs.next()) {
		if(checkPwRs.getInt("cnt") < 1){
			msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8");
			localName = URLEncoder.encode(localName, "utf-8");
			response.sendRedirect(request.getContextPath() + "/localName/deleteLocalNameForm.jsp?localName=" + localName + "&msg=" + msg);
			return;
		}
		
	}
	
	// localName board 게시글 있는지 확인
	PreparedStatement checkLocalNameStmt = null;
	ResultSet checkLocalNameRs = null;
	String checkLocalNameSql = "SELECT local_name localName FROM local WHERE local_name NOT IN (SELECT DISTINCT local_name FROM board)";
	checkLocalNameStmt = conn.prepareStatement(checkLocalNameSql);
	System.out.println(checkLocalNameStmt + " <- updateLocalNameAction checkLocalNameStmt");
	checkLocalNameRs = checkLocalNameStmt.executeQuery();
	
	if (checkLocalNameRs.next()) {
		if(!localName.equals(checkLocalNameRs.getString("localName"))){
			msg = URLEncoder.encode("board에 게시글이 있습니다.", "utf-8");
			localName = URLEncoder.encode(localName, "utf-8");
			response.sendRedirect(request.getContextPath() + "/localName/deleteLocalNameForm.jsp?localName=" + localName + "&msg=" + msg);
			return;
		}
		
	}
	
	// 삭제 쿼리 실행문
	PreparedStatement deleteLocalNameActionStmt = null;
	int deleteLocalNameActionRow = 0;
	String deleteLocalNameActionSql = "DELETE FROM local WHERE local_name = ?";
	deleteLocalNameActionStmt = conn.prepareStatement(deleteLocalNameActionSql);
	deleteLocalNameActionStmt.setString(1, localName);
	System.out.println(deleteLocalNameActionStmt + " <- deleteLocalNameAction deleteLocalNameActionStmt");
	deleteLocalNameActionRow = deleteLocalNameActionStmt.executeUpdate();
	System.out.println(deleteLocalNameActionRow + " <- deleteLocalNameAction deleteLocalNameActionRow");
	
	if (deleteLocalNameActionRow == 1){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	} else {
		msg = URLEncoder.encode("삭제에 실패 했습니다.", "utf-8");
		localName = URLEncoder.encode(localName, "utf-8");
		response.sendRedirect(request.getContextPath() + "/localName/deleteLocalNameForm.jsp?localName=" + localName + "&msg=" + msg);
	}
%>