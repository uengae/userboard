<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// subMenuList board 안에 있는 데이터
	String subMenuSql = "SELECT '전체' localName, count(local_name) cnt FROM board UNION All SELECT local_name, COUNT(*) cnt FROM board GROUP BY local_name";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	
	// subMenuList <-- 모델데이터
	ArrayList<HashMap<String, Object>> subMenuList
					= new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	
	// subMenuList local 안에 있는 데이터
	String localNameSql = "SELECT local_name localName FROM local WHERE local_name NOT IN (SELECT DISTINCT local_name FROM board)";
	PreparedStatement localNameStmt = conn.prepareStatement(localNameSql);
	ResultSet localNameRs = localNameStmt.executeQuery();
	
	// subMenuList <-- 모델데이터
	ArrayList<HashMap<String, Object>> localNameList
					= new ArrayList<HashMap<String, Object>>();
	while(localNameRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", localNameRs.getString("localName"));
		m.put("cnt", 0);
		// 데이터 뽑아서 subMenuList에 넣으면 값이 나온다
		subMenuList.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link id="theme" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
<!-- 서브메뉴(세로) subMenuList 모델 출력 -->
	<div class="dropdown">
		<button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
			지역 카테고리
		</button>
				<ul class="dropdown-menu">
			<%
				for(HashMap<String, Object> m : subMenuList) {
			%>
					<li>
					<a class="dropdown-item" href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
						<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
					</a>
					</li>
			<%		
				}
			%>
		</ul>
	</div>
</body>
</html>