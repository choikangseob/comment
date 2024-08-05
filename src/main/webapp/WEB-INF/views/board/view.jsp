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
	<tr><td colspan=2 style='text-align:center'>의견<input type=hidden name="boardId" value="${sessionScope.userid}" id="userid"><input type=hidden id="writer"><input type =text id="id"><input type =text id="created"></td></tr>
	<tr><td colspan=2 ><textarea style="width:450px; height:100px;" id=comment name=comment></textarea></td></tr>
	<tr><td colspan=2><input type = button id="reply" value="댓글달기/수정"><input type = button id="delete" value="댓글삭제" id ="delete"></td></tr>
</table>
<table id=tbl>
	<thead>
		<tr><th style="display: none;"></th><th>댓글 작성자</th><th>내용</th><th>작성시간</th>
	</thead>
	<tbody></tbody>
</table>

<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
let near='';
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
		let commentid =$('#id').val();
	
	if('#id'==''){

        $.ajax({ url:"/comment" , type:"post" , data:{id: id,comment: comment, writer: writer}, dataType:"text",
        success:function(data){
        	console.log(data)
        	loadView();

        }
        })
        
	}else{
		if($('#writer').val()!='${sessionScope.userid}'){
			alert('작성자가 아닙니다')
			$('#comment').prop('readonly', true);
			return false;
		}
		$.ajax({
			url:"/commentupdate",type:"post",data:{id:commentid,comment:comment},dataType:"text",
			success:function(data){
				console.log(data)
				loadView();
			}
		})
		
	}
		
    })
.on('click','#delete',function(){
	let id = $('#id').val();
	
	$.ajax({
			url:"/commentdelete" , type:"post" , data:{id:id},dataType:"text",
			success:function(data){
				console.log(data)
				loadView();
			}
		
	})
	
})
.on('click','#tbl tbody tr',function(){
	let id = $(this).find('td:eq(0)').text();
	let writer = $(this).find('td:eq(1)').text();
	let content = $(this).find('td:eq(2)').text();
	let created = $(this).find('td:eq(3)').text();
	console.log("id",id)
	console.log("writer",writer);
	console.log("content",content);
	$('#id').val(id);
	$('#eeid').val(id);				//대댓글 아이디
	$('#replycomment').val(content); // 대댓글 내용
	$('#writer').val(writer);
	$('#comment').val(content);
	$('#created').val(created);
	near=$(this).closest('tr');
	//let str='<tr><td colspan=3><input type= button value="대댓글 등록" id="put"></td></tr>';
    //$('#tbl tbody').append(str);
    			let putreplyButton=this;
    			$.ajax({
    				url:"/getView1" ,type:"post",data:{id:$('#eid').val()},dataType:"json",
    				success:function(data){
    					console.log(data);
    					$(putreplyButton).closest('tr').after('<table id="tbl10"></table>');
    					$('#tbl10').empty();
    	    			let str1 = "";
    	    			for( let x of data){
    	    			str1 += '<tr><td style="display: none;">'+x['id']+'</td><td>'+x['writer']+'</td><td>'+x['content']+'</td><td>'+x['created']+'</td></tr>'
    	    			
    	    			}
    	    			//near.after(str1);
    	    			$('#tbl10').append(str1);
    	    			
    	    			
    		
    		}
    	})
    
    
    if($('#put').length==0){
	$('#tbl tbody').after('<input type= button value="대댓글 등록" id="put"><input type=hidden id="eid">')
    $('#eid').val($('#id').val());
    
    }else{
    $(this).prop('disabled', true);
    }
})
.on('click','#tbl10 tr',function(){
	let id = $(this).find('td:eq(0)').text();
	let writer = $(this).find('td:eq(1)').text();
	let content = $(this).find('td:eq(2)').text();
	let created = $(this).find('td:eq(3)').text();
	console.log("id::",id)
	console.log("writer::",writer);
	console.log("content::",content);
	$('#id').val(id);
	$('#eeid').val(id);				//대댓글 아이디
	$('#replycomment').val(content); // 대댓글 내용
	$('#writer').val(writer);
	$('#comment').val(content);
	$('#created').val(created);
})
.on('click','#put',function(){
	let str='<tr><td colspan=2><textarea style="width:450px; height:100px;" id="replycomment"></textarea></td><td><input type=hidden id="eeid"><input type =button value="등록" id="putreply"><input type=button value="수정" id="update10"><input type=button value="삭제" id="deletereply"></td></tr>';
    near.after(str);
	
})
.on('click','#putreply',function(){
	let val= $('#replycomment').val(); 
	let putreplyButton = this;
	$.ajax({
		url:"/putreply",type:"post",data:{id:$('#eid').val(),content:val,userid:$('#userid').val()},dataType:"text",
		success:function(data){
			console.log(data);

			$.ajax({
				url:"/getView1" ,type:"post",data:{id:$('#eid').val()},dataType:"json",
				success:function(data){
					console.log(data);
					$(putreplyButton).closest('tr').after('<table id="tbl10"></table>');
					$('#tbl10').empty();
	    			let str1 = "";
	    			for( let x of data){
	    			str1 += '<tr><td style="display: none;">'+x['id']+'</td><td>'+x['writer']+'</td><td>'+x['content']+'</td><td>'+x['created']+'</td></tr>'
	    			
	    			}
	    			//near.after(str1);
	    			$('#tbl10').append(str1);
	    			putreplyButton.closest('tr').remove();
	
		
		}
	})
			
		}
		
	})
	
})
.on('click','#update10',function(){
	$.ajax({
		url:"/commentupdate",type:"post",data:{id:$('#eeid').val(),comment:$('#replycomment').val()},dataType:"text",
		success:function(data){
			console.log(data)
			loadView();
		}
	})

})
.on('click','#deletereply',function(){
	let id = $('#eeid').val();
	let allRows = $('#tbl10 tr');
	$.ajax({
		url:"/commentdelete" , type:"post" , data:{id:id},dataType:"text",
		success:function(data){
			
			
			console.log(data)
			loadView();
		}
	
})
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
    			str += '<tr><td style="display: none;">'+x['id']+'</td><td>'+x['writer']+'</td><td>'+x['content']+'</td><td>'+x['created']+'</td></tr>'
    			
    			}$('#tbl tbody').append(str);
    			let putreplyButton=this;
    			$.ajax({
    				url:"/getView1" ,type:"post",data:{id:$('#eid').val()},dataType:"json",
    				success:function(data){
    					console.log(data);
    					$(putreplyButton).closest('tr').after('<table id="tbl10"></table>');
    					$('#tbl10').empty();
    	    			let str1 = "";
    	    			for( let x of data){
    	    			str1 += '<tr><td style="display: none;">'+x['id']+'</td><td>'+x['writer']+'</td><td>'+x['content']+'</td><td>'+x['created']+'</td></tr>'
    	    			
    	    			}
    	    			//near.after(str1);
    	    			$('#tbl10').append(str1);
    	    			
    	    			
    		
    		}
    	})
    		
    }
    	})
}
</script>
</body>

</html>