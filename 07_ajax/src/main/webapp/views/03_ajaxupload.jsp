<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ajax파일 업로드시키기</title>
<script src="http://code.jquery.com/jquery-3.7.0.min.js"></script>
</head>
<body>
	<h2>ajax를 이용해서 파일업로드하기</h2>
	<input type="file" id="upFile" multiple>   <!-- file 타입에는 files 속성이 있다 -->
	<button id="uploadBtn">업로드파일</button>
	<script>
	
		$("#uploadBtn").click(e=>{
			//js가 제공하는 formData 클래스를 이용함
			const form = new FormData(); // form 태그 만든것과 동일함
			// append로 서버에 전송할 데이터를 넣을 수 있음
			// key:value 형식으로 저장
			const fileInput = $("#upFile");
			console.log(fileInput);
			
			$.each(fileInput[0].files,(i,f)=>{ // i=> 인덱스번호  
				form.append("upfile"+i,f);
			});
			
			form.append("name","유병승");
			
			$.ajax({
				url:"<%=request.getContextPath()%>/fileUpload",
				data:form,  // data로 파일을 넘김
				type:"post",
				processData:false, // 멀티파트폼으로 보내기위해서 설정
				contentType:false, // 멀티파트폼으로 보내기위해서 설정
				success:data=>{
					alert("업로드가 완료되었습니다.");
				},error:(r,m)=>{
					alert("업로드 실패했습니다.");
				},complete:()=>{
					$("#upFile").val('');  // 업로드가 성공하든 실패하든, 다 비워줘야함
				}
			});
		});
	</script>
	
	
	<h2>업로드 이미지 미리보기 기능</h2>
	<img src="https://th.bing.com/th/id/OIP.vvmpWt0qBu3LeBgZuUfmGAHaFt?w=223&h=180&c=7&r=0&o=5&pid=1.7"
	width="100" height="100" id="profile">
	<input type="file" style="display:none" id="profileInput" accept="image/*">
	
	<input type="file" id="upfiles" multiple accept="images/*">
	<div id="uploadpreview"></div>
	
	<script>
		$("#profile").click(e=>{
			$("#profileInput").click();
		});
		
		
		$("#upfiles").change(e=>{
			$("#uploadpreview").html('');
			const files=e.target.files;
			$.each(files,(i,f)=>{
				const reader=new FileReader(); // 1
				
				reader.onload=e=>{ // 3
					const img=$("<img>").attr({
						src:e.target.result,
						"width":"100",
						"height":"100"
					});
					$("#uploadpreview").append(img);
				}
				reader.readAsDataURL(f); // 2
			});
		});
		
		
		$("#profileInput").change(e=>{
			const reader=new FileReader();
			reader.onload=e=>{
				   //e.targer.result 속성에 변경된 file이 나옴
				   $("#profile").attr("src",e.target.result);
			}			
			reader.readAsDataURL(e.target.files[0]);
		});
		
		
	</script>
	<style>
		#profile{
			border-radius:100px;
			border:3px solid yellow;
		}
	</style>
</body>
</html>