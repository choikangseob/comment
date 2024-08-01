<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>어서오세요</title>
</head>
<style>
table {margin:auto,border-collapse:collapsed;}
td:nth-child(1){
	text-align:right;
}
td{
	border:1px solid black;
}
th{
color:white; background-color:black;
}
</style>
<body>
<form method='get' action='/logout'>
<table>

<tr>
	<td style="text-align:right;border:none;">${linkstr}</td>

<tr>
	<td style="text-align:center;font-size:36px;border::none;">안녕하세요. 최강섭의 홈페이지 입니다</td>
</tr>
</table>
</form>
<table>
<tr><td colsapn=4 style='text-align:right;border:none;'>${newpost}</td></tr>
<tr><th>번호</th><th>제목</th><th>작성자</th><th>작성시각</th></tr>
<c:forEach items="${arBoard}" var="board">
	<tr><td>${board.id}</td><td><a href='/view?id=${board.id}'>${board.title}</a></td><td>${board.writer}</td>
	<td>${board.created}</td></tr>
</c:forEach>
<tr><td colspan=4 style='text-align:center;'>${movestr}</td></tr>
</table>
</body>
</html>