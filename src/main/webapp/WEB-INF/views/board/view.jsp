<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
table {margin:auto,border-collapse:collapsed;}
td:nth-child(1){
	text-align:right;
}
td{
	border:1px solid black;
}
</style>
<body>
<table>
<tr><td>제목</td><td><input type=text name=title value="${board.title}"readonly></td></tr>
<tr><td>작성자</td><td><input type=text name=writer value="${board.writer}" readonly></td></tr>
<tr><td>게시글</td><td><textarea name=content  rows=20 cols=50 readonly>${board.content}</textarea></td></tr>
<tr><td>작성시각</td><td>${board.created}</td></tr>
<tr><td>수정시각</td><td>${board.updated}</td></tr>
<tr><td colspan=2 style='text-align:center'>
<a href ="/">목록으로 돌아가기</a>&nbsp;&nbsp;&nbsp;
<c:if test="${sessionScope.userid == board.writer}">
<a href ="/update?id=${board.id}">수정하기</a>&nbsp;&nbsp;&nbsp;
<a href ="/delete?id=${board.id}">삭제하기</a>
</c:if>
</td></tr>
</table>
<table>
	<tr><td colspan=2 style='text-align:center'>의견<input type=hidden name="boardId" value="${sessionScope.userid}" id="userid"><input type=text id="writer"></td></tr>
	<tr><td colspan=2 ><textarea style="width:450px; height:100px;" id=comment name=comment></textarea></td></tr>
	<tr><td colspan=2><input type = button id="reply" value="댓글달기"><input type = button id="delete" value="댓글삭제"></td></tr>
</table>
<table id=tbl>
	<thead>
		<tr><th>댓글 작성자</th><th>내용</th><th>작성시간</th>
	</thead>
	<tbody></tbody>
</table>

<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
.ready(function(){
		loadView()
})
 .on('click','#reply',function(){
		let id = "${board.id}";
		let comment =$('#comment').val();
		let writer = $("#userid").val();
	console.log("[id]",id);
	console.log("[comment]",comment);
	console.log("[writer]",writer);

        $.ajax({ url:"/comment" , type:"post" , data:{id: id,comment: comment, writer: writer}, dataType:"text",
        success:function(data){
        	console.log(data)

        }
        })
    })
.on('click','#tbl tbody tr',function(){

	let writer = $(this).find('td:eq(0)').text();
	let content = $(this).find('td:eq(1)').text();
	
	if($('#writer').val()!='${sessionScope.userid}'){
		alert('작성자가 아닙니다')
		$('#comment').prop('readonly', true);
	}else{
		$('#writer').val(writer);
		$('#comment').val(content);
	}
	
})
    function loadView(){
    	let id = "${board.id}";
    	$.ajax({
    		url:"/getView" , type : "post" , data:{id:id} , dataType:"json",
    		success:function(data){
    			console.log(data)
    			$('#tbl tbody').empty();
    			let str = "";
    			for( let x of data){
    			str += '<tr><td>'+x['writer']+'</td><td>'+x['content']+'</td><td>'+x['created']+'</td></tr>'
    			
    			}$('#tbl tbody').append(str);
    		}
    	})
    }
</script>
</body>

</html>