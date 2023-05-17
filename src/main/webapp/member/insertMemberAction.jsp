<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	// session 유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		// response는 클라이언트에서 실행되기 때문에 request.getContextPath()해줘야한다.
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	String msg = null;
	// 요청값 유효성 검사
	if("".equals(request.getParameter("memberId"))
			|| "".equals(request.getParameter("memberPw"))
			|| "".equals(request.getParameter("memberPw2"))) {
		msg = URLEncoder.encode("아이디 혹은 비밀번호를 입력하세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg=" + msg);
		return;
	}
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberPw2 = request.getParameter("memberPw2");
	
	// 디버깅
	System.out.println(memberId + ", " + memberPw + ", " + memberPw2 + " <- insertMemberAction id, pw, pw2");
	
	// model
	// 비밀번호 일치하는 지 검사
	if(!memberPw.equals(memberPw2)) {
		msg = URLEncoder.encode("비밀번호가 동일하지 않습니다.", "utf-8"); 
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg=" + msg);
		return;
	}
	
	// 파라미터값 클래스에 맞춰서 입력
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
	String sql = "SELECT member_id from member where member_id = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	rs = stmt.executeQuery();
	
	if(rs.next()){
		System.out.println("id 중복 <- insertMemberAction");
		msg = URLEncoder.encode("중복된 ID입니다.", "utf-8");
		response.sendRedirect(request.getContextPath
				() + "/member/insertMemberForm.jsp?msg=" + msg);
		return;
	}
	
	PreparedStatement stmt2 = null;
	// 입력되는 값은 id와 pw이다. pw는 암호화해서 넣어야하기 때문에 PASSWORD() 안에 넣어줘야한다.
	String sql2 = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, paramMember.getMemberId());
	stmt2.setString(2, paramMember.getMemberPw());
	System.out.println(stmt2 + " <- insertMemberAction stmt");
	//executeUpdate()는 결과값이 int이기 때문에 resurtset 말고 인트 변수에 저장하면 된다.
	int row = stmt2.executeUpdate();
	
	if(row == 1){ // 회원가입 성공
		System.out.println(row + " <- insertMemberAction row");
		System.out.println("회원가입 성공");
	} else { // 회원가입 실패
		System.out.println(row + " <- insertMemberAction row");
		System.out.println("회원가입 실패");
	}
	response.sendRedirect(request.getContextPath() + "/home.jsp");

%>