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
	String updateLocalName = request.getParameter("updateLocalName");
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
			response.sendRedirect(request.getContextPath() + "/localName/updateLocalNameForm.jsp?localName=" + localName + "&msg=" + msg);
			return;
		}
		
	}
	
	// localName 중복 확인
	PreparedStatement checkLocalNameStmt = null;
	ResultSet checkLocalNameRs = null;
	String checkLocalNameSql = "SELECT COUNT(*) cnt FROM local WHERE local_name = ?";
	checkLocalNameStmt = conn.prepareStatement(checkLocalNameSql);
	checkLocalNameStmt.setString(1, updateLocalName);
	System.out.println(checkLocalNameStmt + " <- updateLocalNameAction checkLocalNameStmt");
	checkLocalNameRs = checkLocalNameStmt.executeQuery();
	
	if (checkLocalNameRs.next()) {
		if(checkLocalNameRs.getInt("cnt") > 0){
			msg = URLEncoder.encode("이미 있는 local_name입니다.", "utf-8");
			localName = URLEncoder.encode(localName, "utf-8");
			response.sendRedirect(request.getContextPath() + "/localName/updateLocalNameForm.jsp?localName=" + localName + "&msg=" + msg);
			return;
		}
		
	}
	
	// 수정 쿼리 실행문
	PreparedStatement updateLocalNameActionStmt = null;
	int updateLocalNameActionRow = 0;
	String updateLocalNameActionSql = "UPDATE local SET local_name = ?, updatedate = now() WHERE local_name = ?";
	updateLocalNameActionStmt = conn.prepareStatement(updateLocalNameActionSql);
	updateLocalNameActionStmt.setString(1, updateLocalName);
	updateLocalNameActionStmt.setString(2, localName);
	System.out.println(updateLocalNameActionStmt + " <- updateLocalNameAction updateLocalNameActionStmt");
	updateLocalNameActionRow = updateLocalNameActionStmt.executeUpdate();
	System.out.println(updateLocalNameActionRow + " <- updateLocalNameAction updateLocalNameActionRow");
	
	if (updateLocalNameActionRow == 1){
		msg = URLEncoder.encode("수정이 완료 됐습니다.", "utf-8");
		updateLocalName = URLEncoder.encode(updateLocalName, "utf-8");
		response.sendRedirect(request.getContextPath() + "/localName/updateLocalNameForm.jsp?localName=" + updateLocalName + "&msg=" + msg);
	} else {
		msg = URLEncoder.encode("수정에 실패 햇습니다.", "utf-8");
		localName = URLEncoder.encode(localName, "utf-8");
		response.sendRedirect(request.getContextPath() + "/localName/updateLocalNameForm.jsp?localName=" + localName + "&msg=" + msg);
	}
%>