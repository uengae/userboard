<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String loginMemberId = (String)session.getAttribute("loginMemberId");
%>
	<div class="text-center">
	<a href="<%=request.getContextPath()%>/home.jsp">
		<button class="btn btn-lg btn-primary" type="button">홈으로</button>
	</a>
	</div>
	<hr>

<!--
	로그인전 : 회원가입
	로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId)
-->

<%
	if(session.getAttribute("loginMemberId") == null){ // 로그인전
%>
		<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post" id="login">
			<table>
				<tr>
					<td>아이디</td>
				</tr>
				<tr>
					<td>
						<input type="text" name="memberId">
					</td>
				</tr>
				<tr>
					<td>패스워드</td>
				</tr>
				<tr>
					<td>
						<input type="password" name="memberPw">
					</td>
				</tr>
			</table>
		</form>
		<form action="<%=request.getContextPath()%>/member/insertMemberForm.jsp" method="post" id="insertMember"></form>
		<div><br></div>
		<button class="btn btn-outline-primary" type="submit" form="login">로그인</button>
		<button class="btn btn-outline-primary" type="submit" form="insertMember">회원가입</button>
<%
	} else { //로그인 후
%>
		<table>
			<tr>
				<th colspan="2">
					<%=loginMemberId%>님 어서오세요.
				</th>
			</tr>
		<%
			if ("admin".equals(loginMemberId)){
		%>
			<tr>
				<th colspan="2">
					<a class="btn btn-outline-secondary btn-sm" href="<%=request.getContextPath()%>/localName/localNameCategory.jsp">
						지역 카테고리 수정
					</a>
				</th>
			</tr>
		<%
			}
		%>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/member/memberInformation.jsp">
						<button class="btn btn-outline-primary btn-sm" type="button">회원정보</button>
					</a>
				</td>
				<td>
					<a href="<%=request.getContextPath()%>/member/logoutAction.jsp">
						<button class="btn btn-outline-primary btn-sm" type="button">로그아웃</button>
					</a>
				</td>
			</tr>
		</table>
<%
	}
%>
	<hr>
	<div>
		<jsp:include page="/inc/categoryList.jsp"></jsp:include>
	</div>
	