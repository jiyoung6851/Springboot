<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">

<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/css/list.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/header/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/footer/footer.css">

</head>
<jsp:include page="../header.jsp"/>

<!--
	boardno int COMMENT '구독이력번호',
	authorid varchar(25) COMMENT '글쓴이 id',
	title varchar(20) COMMENT '제목',
	content varchar(20) COMMENT '내용',
	boardgb varchar(2) COMMENT '사용자구분',
	adate datetime COMMENT '등록 일자',
	boardhit int comment '조회 수',
	PRIMARY KEY (boardno, authorid)
-->
<body>
	<form method="get" id="searchForm">
		<select name="type">
			<option value="" <c:out value="${pageMaker.cri.type == null ? 'selected':''}"/> >전체</option>
			<option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected':''}"/> >제목</option>
			<option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected':''}"/> >내용</option>
			<option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected':''}"/> >작성자</option>
			<option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected':''}"/> >제목 or 내용</option>
			<option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected':''}"/> >제목 or 작성자</option>
			<option value="TCW" <c:out value="${pageMaker.cri.type eq 'TCW' ? 'selected':''}"/> >제목 or 내용 or 작성자</option>
		</select>
		<!-- 	Criteria 를 이용해서 키워드 값을 넘김 -->
		<input type="text" name="keyword" value="${pageMaker.cri.keyword}">
		<!-- <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}"> -->
		 <!-- 전체검색중 5페이지에서 22 키워드로 검색시 안나올때 처리 -->
		<input type="hidden" name="pageNum" value="1">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
		<button>Search</button>
		<button><a href="write_view">글작성</a></button>
	</form>
	<table width="1000">
<!-- 		list : 모델객체에서 보낸 이름 -->
		<c:forEach items="${list}" var="dto">
			<tr>
				<td>${dto.boardNo}</td>
				<td>${dto.boardName}</td>
<%-- 				<td>${dto.boardTitle}</td> --%>
				<td>
<!-- 			content_view : 컨트롤러단 호출 -->
					<!-- <a href="content_view?boardNo=${dto.boardNo}">${dto.boardTitle}</a> -->
					<a class="move_link" href="${dto.boardNo}">${dto.boardTitle}</a>
				</td>
				<td>${dto.boardDate}</td>
				<td>${dto.boardHit}</td>
			</tr>
		</c:forEach>
<!--		<tr>-->
<!--			<td colspan="5">-->
<!-- 			write_view : 컨트롤러단 호출 -->
<!--				<button><a href="write_view">글작성</a></button>-->
<!--			</td>-->
<!--		</tr>-->
	</table>k


	<h3>${pageMaker}</h3>
	<div class="div_page">
		<ul>
			<c:if test="${pageMaker.prev}">
				<!-- <li>[Previous]</li> -->
				<li class="paginate_button">
					<a href="${pageMaker.startpage - 1}">
						[Previous]
					</a>
				</li>
			</c:if>
			<c:forEach var="num" begin="${pageMaker.startpage}" end="${pageMaker.endpage}">
				<!-- <li>[${num}]</li> -->
				<!-- <li ${pageMaker.cri.pageNum == num ? "style='color: red'" : ""}> -->
					<!-- 				현재 페이지는 배경색 노란색으로 표시 -->
				<li class="paginate_button" ${pageMaker.cri.pageNum == num ? "style='background-color: yellow'" : ""}>
					<!-- [${num}] -->
					<a href="${num}">
						[${num}]
					</a>
				</li>
			</c:forEach>
			<c:if test="${pageMaker.next}">
				<!-- <li>[Next]</li> -->
				<li class="paginate_button">
					<a href="${pageMaker.endpage + 1}">
						[Next]
					</a>
				</li>
			</c:if>
		</ul>
	</div>

	<!-- <form id="actionForm" method="get" action="listWithPaging"> -->
	<!-- <form id="actionForm" method="get" action="list"> -->
	<form id="actionForm" method="get">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
		<!-- 페이징 검색시 페이지번호를 클릭할때 필요한 파라미터 -->
		<input type="hidden" name="type" value="${pageMaker.cri.type}">
		<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
	</form>
</body>
<jsp:include page="../footer.jsp"/>

</html>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.js"></script>
<script>
	var actionForm = $("#actionForm");

	//	페이지번호 처리
	// $(".paginate_button").on("click", function (e){
	$(".paginate_button a").on("click", function (e){
		//기본 동작 막음: 페이지 링크를 통해서 이동
		e.preventDefault();
		console.log("click~!!!");
		console.log("@# href=>"+$(this).attr("href"));

		// 게시글 클릭후 뒤로가기 누른후 다른 페이지 클릭할때 &boardNo=번호 계속 누적되는거 방지
		var bno = actionForm.find("input[name='boardNo']").val();
		if(bno != ""){
			actionForm.find("input[name='boardNo']").remove();
		}

		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		// actionForm.submit();
		actionForm.attr("action","list").submit();
	});//end of paginate_button clcik

	// 	게시글 처리
	$(".move_link").on("click", function(e){
		e.preventDefault();

		console.log("@# move_link click~!!!");
		console.log("@# href=>"+$(this).attr("href"));

		var targetBno = $(this).attr("href");
	
		// 게시글 클릭후 뒤로가기 누른후 다른 게시글 클릭할때 &boardNo=번호 계속 누적되는거 방지
		var bno = actionForm.find("input[name='boardNo']").val();
		if(bno != ""){
			actionForm.find("input[name='boardNo']").remove();
		}

		// "content_view?boardNo=${dto.boardNo}" 를 actionForm 로 처리
		actionForm.append("<input type='hidden' name='boardNo' value='"+targetBno+"'>");
		// actionForm.submit();
		// 컨트롤러에 content_view 로 찾아감
		actionForm.attr("action","content_view").submit();
	});//end of move_link click

	var searchForm = $("#searchForm");

	// 	Search 버튼 클릭
	// $("#searchForm").on("click", function(){
	$("#searchForm button").on("click", function(){
		// alert("검색");

		// 아래는 검색종류까지 할때 참고
		// if(!searchForm.find("option:selected").val()){
		// 	alert("검색종류를 선택하세요.");
		// 	return false;
		// }

		if(searchForm.find("option:selected").val() != "" && !searchForm.find("input[name='keyword']").val()){
			alert("키워드를 입력하세요.");
			return false;
		}
		searchForm.attr("action","list").submit();
	});//end of searchForm click

	// 	type 콤보박스 변경
	$("#searchForm select").on("change", function(){
		// 전체일때
		if(searchForm.find("option:selected").val() == ""){
			// 키워드를 널값으로 변경
			searchForm.find("input[name='keyword']").val("");
		}
	});//end of searchForm select change
</script>











