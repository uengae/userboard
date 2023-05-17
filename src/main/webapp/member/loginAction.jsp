<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	// session 유효성 검사 -> 요청값 유효성 검사
	if(session.getAttribute("loginMemeberId") != null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	// 요청값 유효성 검사
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	// 디버깅
	
	
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	System.out.println(stmt);
	rs = stmt.executeQuery();
	if(rs.next()){ // 로그인 성공
		// 세션에 로그인 정보(memberId) 저장
		System.out.println(memberId + " <-- memberId");
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션 정보 " + session.getAttribute("loginMemberId"));
	} else { // 로그인 실패
		System.out.println("로그인 실패");
	}
	
	response.sendRedirect(request.getContextPath() + "/home.jsp");
%>