<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// controller
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(loginMemberId + " <- deleteMemberAction loginMemeberId");
	
	
	String pw = request.getParameter("password");
	System.out.println(pw + " <- deleteMemberAction pw");
	
	if ("".equals(request.getParameter("password"))){
		String msg = URLEncoder.encode("비밀번호를 입력 후 탈퇴를 눌러주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/deleteMemberForm.jsp?msg=" + msg);
		return;
	}
	
	// model
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	PreparedStatement deleteMemberStmt = null;
	int deleteMemberRow = 0;
	
	String deleteMemberSql = "DELETE FROM member WHERE member_id = ? AND member_Pw = PASSWORD(?)";
	deleteMemberStmt = conn.prepareStatement(deleteMemberSql);
	deleteMemberStmt.setString(1, loginMemberId);
	deleteMemberStmt.setString(2, pw);
	System.out.println(deleteMemberStmt + " <- deleteMemberAction deleteMemberStmt");
	deleteMemberRow = deleteMemberStmt.executeUpdate();
	System.out.println(deleteMemberRow + " <- deleteMemberAction deleteMemberRow");
	
	if (deleteMemberRow > 0){
		// 삭제해도 로그아웃 안하면 session에는 아이디가 로그인 상태로 있음
		response.sendRedirect(request.getContextPath() + "/member/logoutAction.jsp");
	} else {
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/deleteMemberForm.jsp?msg=" + msg);
	}
%>