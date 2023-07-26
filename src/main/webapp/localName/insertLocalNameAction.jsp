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

	// admin만 접근 가능하게 셋팅
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	if (!"admin".equals(loginMemberId)){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	String localName = request.getParameter("localName");
	String password = request.getParameter("password");
	System.out.println(password + " <- insertLocalNameAction password");
	
	// model
	String msg = null;
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://43.201.156.144:3306/userboard";
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
			response.sendRedirect(request.getContextPath() + "/localName/insertLocalNameForm.jsp?msg=" + msg);
			return;
		}
		
	}
	
	// localName 중복 확인
	PreparedStatement checkLocalNameStmt = null;
	ResultSet checkLocalNameRs = null;
	String checkLocalNameSql = "SELECT COUNT(*) cnt FROM local WHERE local_name = ?";
	checkLocalNameStmt = conn.prepareStatement(checkLocalNameSql);
	checkLocalNameStmt.setString(1, localName);
	System.out.println(checkLocalNameStmt + " <- updateLocalNameAction checkLocalNameStmt");
	checkLocalNameRs = checkLocalNameStmt.executeQuery();
	
	if (checkLocalNameRs.next()) {
		if(checkLocalNameRs.getInt("cnt") > 0){
			msg = URLEncoder.encode("이미 있는 local_name입니다.", "utf-8");
			localName = URLEncoder.encode(localName, "utf-8");
			response.sendRedirect(request.getContextPath() + "/localName/insertLocalNameForm.jsp?localName=" + localName + "&msg=" + msg);
			return;
		}
		
	}
	
	// 입력 쿼리 실행문
	PreparedStatement insertLocalNameActionStmt = null;
	int insertLocalNameActionRow = 0;
	String insertLocalNameActionSql = "INSERT INTO local SET local_name = ?, createdate = now(), updatedate = now()";
	insertLocalNameActionStmt = conn.prepareStatement(insertLocalNameActionSql);
	insertLocalNameActionStmt.setString(1, localName);
	System.out.println(insertLocalNameActionStmt + " <- insertLocalNameAction insertLocalNameActionStmt");
	insertLocalNameActionRow = insertLocalNameActionStmt.executeUpdate();
	System.out.println(insertLocalNameActionRow + " <- insertLocalNameAction insertLocalNameActionRow");
	
	if (insertLocalNameActionRow == 1){
		msg = URLEncoder.encode("입력이 완료 됐습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/localName/insertLocalNameForm.jsp?msg=" + msg);
	} else {
		msg = URLEncoder.encode("입력에 실패 햇습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/localName/insertLocalNameForm.jsp?msg=" + msg);
	}
%>