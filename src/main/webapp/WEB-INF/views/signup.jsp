<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
</head>
<body>
<form method="post" action="/dosignup">
<table>
<tr><td>유저아이디</td><td><input type="text" name="userid"></td></tr>
<tr><td>비밀번호</td><td><input type="text" name="password"></td></tr>
<tr><td>비밀번호 확인</td><td><input type="text" name="cpassword"></td></tr>
<tr><td>실명</td><td><input type="text" name="name"></td></tr>
<tr><td>생년월일</td><td><input type="date" name="birthday"></td></tr>
<tr><td>성별</td><td><input type="radio" name="gender" value="남성">남성<input type="radio" name="gender" value="여성">여성</td></tr>
<tr><td>모바일</td><td><input type="text" name="mobile"></td></tr>
<tr><td>지역</td><td><select name="region">
    <option value="덕양구">덕양구</option>
    <option value="일산동구">일산동구</option>
    <option value="일산서구">일산서구</option>
</select></td></tr>
<tr><td>관심분야</td><td>
    <input type="checkbox" name="favorite" value="Java"> Java
    <input type="checkbox" name="favorite" value="Js"> Js
    <input type="checkbox" name="favorite" value="Python"> Python<br>
    <input type="checkbox" name="favorite" value="Mysql"> Mysql
    <input type="checkbox" name="favorite" value="Oracle"> Oracle
    <input type="checkbox" name="favorite" value="React"> React<br>
    <input type="checkbox" name="favorite" value="Spring"> Spring
    <input type="checkbox" name="favorite" value="View"> View
    <input type="checkbox" name="favorite" value="Django"> Django
</td></tr>
<tr><td colspan="2"><input type="submit" value="가입" id="btn"> <input type="button" value="취소"id="btn1"></td></tr>
</table>
</form>
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
 .on('click','#btn1',function(){
        document.location.href = "http://localhost:8081/";
    });
</script>
</body>
</html>