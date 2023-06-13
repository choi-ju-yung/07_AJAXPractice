<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>jqueryajax</title>
<script src="http://code.jquery.com/jquery-3.7.0.min.js"></script>
</head>
<body>
	<h2>jquery가 제공하는 함수 이용하기</h2>
	<ol>
		<li>$.ajax({}) : 요청에 대한 상세설정을 할 때, header,요청내용 설정</li>
		<li>$.get("",(data)=>{}) : 기본 get방식요청 처리할 때 사용 - 간편함수</li>
		<li>$.post("",{},(data)=>{}) : 기본 post방식요청 처리할 때 사용</li>
		<!-- 데이터만 보낼때는 간편하게 get이나 post함수 사용함 -->
	</ol>

	<h2>$.ajax()함수 활용하기</h2>
	<p>
		매개변수로 요청에 대한 설정을 한 객체를 전달한다.<br> 매개변수 객체의 key값은 $.ajax()함수에서 정해놓음<br>

		밑에 속성중에 앞 뒤에 []친 것은 선택이고, [] 없는것을 필수적으로 필요한 것들이다 url : 요청주소를 설정 ->
		string<br> [type : 요청방식(get,post) -> string * default : get방식임 ]<br>
		[data : 서버에 요청할때 전송할 데이터 -> Object({key:value,...}) ]<br>
		[dataType : 응답데이터 타입에 대한 설정 -> string(json,html,text...) ]<br>
		success : 응답이 완료되고 실행되는 callback함수 * status가 200일때(성공) 실행하는 함수 ->
		(data)=>{}<br> [error : 응답이 완료되고 실행되는 callback함수 * status가 200이
		아닐때 실행하는 함수 -> (r,m,e)=>{} ]<br> [complete : 응답이 성공, 실패되도 무조건
		실행되는 함수 -> ()=>{} ]<br>
	</p>

	<button id="btn">기본 $.ajax 이용하기</button>
	<button id="btnGet">기본 $.get이용하기</button>
	<button id="btnPost">기본 $.post이용하기</button>


	<div id="container"></div>
	<script>
		$("#btnGet").click(e=>{
			$.get("<%=request.getContextPath()%>/jquery/ajax.do?name=최주영&age=27"
					,data=>{
						console.log(data);
						$("<h4>").text(data).css("color","lime").appendTo($("#container"));
					});
		})
	
		
		
		$("#btnPost").click(e=>{
			$.post("<%=request.getContextPath()%>/jquery/ajax.do",
					{name:"김재훈",age:29},
					
					data=>{
					$("<h1>").text(data).css("color","cornflowerblue").appendTo($("#container"));
			});
		})
		
		
		
		
		$("#btn").click(e=>{
			$.ajax({
				 url:"<%=request.getContextPath()%>/jquery/ajax.do",
				 type:"get",
				 data:{name:"유병승",age:19},  // get방식일때 알아서 키값들을 잘라서 해석해줌
				 success:(data)=>{ // responseText 속성에 저장된 값을 data에 저장함
					/* console.log(data); */
					$("<h3>").text(data).css("color","magenta").appendTo($("#container"));
					// 데이터를 갖고와서 프런트에서 태그 만들어줌 (CSR)	
				 },error:(r,m)=>{ // 첫번재 매개변수 : 속성들,  두번째매개변수 : success or error  세번째매개변수:암것도없음
					 if(e.status==404)alert("요청한 페이지가 없습니다.");
				 },
				 complete:()=>{
					 alert("서버와 통신끝!");
				 }
				 
			});
		});
	</script>

	<h2>서버에 저장되어있는 문자파일 가져오기</h2>
	<button id="btnFile">text.txt가져오기</button>
	<div id="result2"></div>
	<script>
		$("#btnFile").click(e=>{
			$.get("<%=request.getContextPath()%>/test/test.txt",
						data=>{
							const arr=data.split("\n");
							console.log(arr);
							
							arr.forEach(e=>{
								$("#result2").append($("<p>").text(e));	
							});
							const person=arr[arr.length-1];
							console.log(person);
							const persons=person.split("\\n");
							console.log(persons);
							const table=$("<table>");
							persons.forEach(e=>{
								const tr=$("<tr>");
								const p=e.split(",");
								p.forEach(d=>{
									tr.append($("<td>").text(d).css("border","1px solid black"));
								});
								table.append(tr);
							});
							$("#result2").append(table);
						});
				
							
			
			
			<%-- $.ajax({
				url:"<%=request.getContextPath()%>/test/test.txt",
				dataType:"text",
				success:data=>{
					console.log(data);
					const arr=data.split("\n");
					console.log(arr);
					
					arr.forEach(e=>{
						$("#result2").append($("<p>").text(e));	
					});
					const person=arr[arr.length-1];
					console.log(person);
					const persons=person.split("\\n");
					console.log(persons);
					const table=$("<table>");
					persons.forEach(e=>{
						const tr=$("<tr>");
						const p=e.split(",");
						p.forEach(d=>{
							tr.append($("<td>").text(d).css("border","1px solid black"));
						});
						table.append(tr);
					});
					$("#result2").append(table);
				}
			}) --%>
		}); 
		
	</script>

	<h2>서버에서 전송하는 csv방식의 데이터처리하기</h2>
	<p>문자열을 데이터별로 구분할수있게 만들어놓은것! , \n $등으로 구분할 수 있는 문자열 예)
		유병승,19,남,경기도시흥시$최솔,29,경기도안양시$</p>
	<button id="btncsv">csv데이터 가져오기</button>
	<div id="csvcontainer"></div>
	<script>
		$("#btncsv").click(e=>{
			$.ajax({
				url:"<%=request.getContextPath()%>/ajax/csvdata.do",
				dataType:"text",
				success:data=>{
					/* console.log(data); */
					const actors=data.split("\n");
					console.log(actors);
					
					const table=$("<table>");
					const header="<tr><th>이름</th><th>전화번호</th><th>프로필</th></tr>";
					table.html(header);
					actors.forEach(e=>{
						const tr=$("<tr>");
						const actor=e.split(",");
						const name=$("<td>").text(actor[0]);
						const phone=$("<td>").text(actor[1]);
						const profile=$("<td>").append($("<img>").attr({
							"src":"<%=request.getContextPath()%>/images/"+actor[2],
							"width":100,
							"height":100
						}));
						
						
						tr.append(name).append(phone).append(profile);
						table.append(tr);
					});
					$("#csvcontainer").html(table);
				}
			})
		})
	</script>



	<h2>html 페이지를 받아서 처리하기</h2>
	<button id="btnhtml">html페이지 받아오기</button>
	<div id="htmlcontainer"></div>
	<script>
		$("#btnhtml").click(e=>{  // e=> 랑 function(e) 랑 동일함
			$.ajax({
				url:"<%=request.getContextPath()%>/ajax/htmlTest.do",  
				dataType:"html",
					success:function(data){
						console.log(data);   // 리턴받은 데이터는 htmlresponse.jsp안의 코드들이다
						$("#htmlcontainer").html(data); // html코드를 받아오는것은 좋은 코드가 아님
					}
			});
		});
	</script>



	<h2>xml 파일을 가져와 처리하기</h2>  
	<button id="xmlbtn">xml파일 가져오기</button>
	<div id="xmlcontainer"></div>
	<script>  // ajax로 데이터를 가져오는 방법
		$("#xmlbtn").click(e=>{
			$.get("<%=request.getContextPath()%>/test/books.xml",
					function(data){ // data-> documnet 타입으로 나옴
						/* console.log($(data)); */
						const root=$(data).find(":root"); // 해당 xml파일에서 최상위부분에 있는 데이터 나옴
						console.log(root);
						
						const books=root.children(); // 해당 책들이 나옴
						console.log(books);
						
						const table=$("<table>");
						const header="<tr><th>구분</th><th>제목</th><th>작가</th></tr>";
						table.html(header);
						
						books.each(function(i,e){ // 모든 책들 값 출력
							const tr=$("<tr>");
						
							const subject=$("<td>").text($(e).find("submit").text());
							const title=$("<td>").text($(e).find("title").text());
							const writer=$("<td>").text($(e).find("writer").text());
							tr.append(subject).append(title).append(writer);
							table.append(tr);
							
						}); 
						$("#xmlcontainer").html(table); 
						// html 속성 : 해당 값의 텍스트를 바꿔줌
						// append 속성 : 해당 값을 계속 붙여서 추가해줌
					}
			);
		})	
	</script>
	
	<h2>서버에서 보낸 데이터 활용하기</h2>
	<input type="search" id="userId" list="data">
	<button id="searchMember">아이디검색</button>
	<datalist id="data"></datalist><!-- datalist 부분 공부하기 -->
	<div id="memberList"></div>
	
	<script>
		$("#userId").keyup(e=>{  // 첫번째인수 : 주소   두번재 인수 : 요청 성공하면 실행될 콜백함수
			$.get("<%=request.getContextPath()%>/searchId.do?id="+$(e.target).val(),
					function(data){
				$("#data").html('');
				const userIds=data.split(",");
				/* console.log(userIds); */
				
				userIds.forEach(e=>{
					const option=$("<option>").attr("value",e).text(e);
					$("#data").append(option);
				})
			});
		});
		
		
		
		$("#searchMember").click(e=>{  // 전체회원 조회해서 출력하기 (해당 화면에서 태그만들어서 출력)
			$.get("<%=request.getContextPath()%>/memberAll.do",
					function(data){
					
						const members=data.split("\n"); // 공백으로 분리해서 배열로 만들어줌
						// document.createElement("table");  ==  $("<table>");
						
						const table=$("<table>");
						const header=$("<tr>");
						const headerdata=["아이디","이름","나이","성별","이메일","전화번호","주소","취미","가입일"];
						headerdata.forEach(e=>{
							const th=$("<th>").text(e);
							header.append(th);
						});
						table.append(header);
						
						members.forEach(e=>{
							const member=e.split("$");
							const tr=$("<tr>");
							member.forEach(m=>{
								tr.append($("<td>").text(m));
							});
							table.append(tr);
						});
						$("#memberList").html(table);
					});
					
					/* $("#memberList").html(data); */  // 새로운 jsp 파일에서 태그만든 데이터 자체를 출력
				});
		
		
				const object={}  // 자바스크립트의 객체 표현식 사용 = json  
		
	</script>

</body>
</html>