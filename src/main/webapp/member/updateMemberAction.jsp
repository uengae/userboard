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
	System.out.println(loginMemberId + " <- updateMemberAction loginMemeberId");
	
	
	String currentPassword = request.getParameter("currentPassword");
	String newPassword = request.getParameter("newPassword");
	String newPasswordCheck = request.getParameter("newPasswordCheck");
	System.out.println(currentPassword + " <- updateMemberAction currentPassword");
	System.out.println(newPassword + " <- updateMemberAction newPassword");
	System.out.println(newPasswordCheck + " <- updateMemberAction newPasswordCheck");
	
	if ("".equals(request.getParameter("currentPassword"))){
		String msg = URLEncoder.encode("비밀번호를 입력 후 수정을 눌러주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	} else if ("".equals(request.getParameter("newPassword"))){
		String msg = URLEncoder.encode("새로운 비밀번호를 입력 후 수정을 눌러주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	}
	
	if (currentPassword.equals(newPassword)) {
		String msg = URLEncoder.encode("현재 비밀번호와 다른 비밀번호를 입력 후 수정을 눌러주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	}
	
	if (!newPasswordCheck.equals(newPassword)){
		String msg = URLEncoder.encode("새로운 비밀번호가 틀렸습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	}
	
	// model
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement updateMemberStmt = null;
	int updateMemberRow = 0;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String updateMemberSql = "UPDATE member set member_pw = PASSWORD(?), updatedate = now() where member_id = ? AND member_pw = PASSWORD(?)";
	updateMemberStmt = conn.prepareStatement(updateMemberSql);
	updateMemberStmt.setString(1, newPassword);
	updateMemberStmt.setString(2, loginMemberId);
	updateMemberStmt.setString(3, currentPassword);
	updateMemberRow = updateMemberStmt.executeUpdate();
	System.out.println(updateMemberRow + " <- updateMemberAction updateMemberRow");
	
	if (updateMemberRow == 1){
		String msg = URLEncoder.encode("수정이 완료되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
	} else {
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
	}
%>