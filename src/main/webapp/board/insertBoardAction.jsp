<%@page import="java.awt.geom.CubicCurve2D"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//controller
	String msg = null;
	
	if (session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	String loginMemeberId = (String)session.getAttribute("loginMemberId");
	
	// 입력 실패 했을때 이전페이지와 같은 값을 주기위함
	int currentPage = 1;
	if (request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// System.out.println(currentPage + " <-insertBoardForm currentPage");
	
	int rowPerPage = 5;
	if (request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	// System.out.println(rowPerPage + " <-insertBoardForm rowPerPage");
	
	// 입력값 없을때 분기
	if ("".equals(request.getParameter("localName"))){
		msg = URLEncoder.encode("지역을 선택해 주세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	if ("".equals(request.getParameter("boardTitle"))){
		msg = URLEncoder.encode("제목을 입력해 주세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	if ("".equals(request.getParameter("boardContent"))){
		msg = URLEncoder.encode("내용을 입력해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	//model
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	PreparedStatement insertBoardStmt = null;
	// 입력되는 값은 id와 pw이다. pw는 암호화해서 넣어야하기 때문에 PASSWORD() 안에 넣어줘야한다.
	String insertBoardSql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) VALUES(?, ?, ?, ?, NOW(), NOW())";
	insertBoardStmt = conn.prepareStatement(insertBoardSql);
	insertBoardStmt.setString(1, localName);
	insertBoardStmt.setString(2, boardTitle);
	insertBoardStmt.setString(3, boardContent);
	insertBoardStmt.setString(4, loginMemeberId);
	System.out.println(insertBoardStmt + " <- insertBoardAction stmt");
	//executeUpdate()는 결과값이 int이기 때문에 resurtset 말고 인트 변수에 저장하면 된다.
	int row = insertBoardStmt.executeUpdate();
	
	if(row < 1){
		msg = URLEncoder.encode("게시글 작성 실패", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?currentPage=" + currentPage + "&rowPerPage=" + rowPerPage + "&msg=" + msg);
		return;
	}
	
	response.sendRedirect(request.getContextPath() + "/home.jsp");
%>