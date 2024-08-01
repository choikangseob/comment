<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form method="post" action="/doLogin">
아이디<input type=text name="a"><br><br>
비밀번호<input type=text name="b"><br><br>
<input type=submit value="로긴">
<input type=button id='btn' value="취소">
</form>
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
 .on('click','#btn',function(){
        document.location.href = "http://localhost:8081/";
    });

</script>
</body>
</html>