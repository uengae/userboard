<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%
	Person kyj = new Person();
	kyj.setBirth(1995);
	System.out.println(kyj.getAge());
%>
