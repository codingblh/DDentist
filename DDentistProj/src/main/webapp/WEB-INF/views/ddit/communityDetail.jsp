<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- summernote -->
<script src="/resources/summernote-0.8.18-dist/summernote-bs4.min.js"></script>
<script src="/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.js"></script>
<link href="/resources/summernote-0.8.18-dist/summernote-bs4.min.css" rel="stylesheet">

<style>
.listBtn, .modifyBtn, .deleteBtn{
        border-radius:20px;
        border:none;
        background-color: #904aff;
        color:white;
        font-family: 'Noto Sans KR', sans-serif;
        font-weight: 500;
}

li {
	 	list-style-type: none;
}
.badge{
 	font-size:                   100%;
 }
#replyWriteBtn{
	background-color:#904aff;
	border:none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
	color:white;
}

#replyWriteBtn:hover{
	background-color:#7c3dde !important;
	border:none;
	color:white;
}

#replyDeleteBtn{
	background-color:#FF5252;
	border:none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
	color:white;
}
#replyDeleteBtn:hover{
	background-color:#e13636 !important;
	border:none;
	color:white;
}
.violetBtn{
	background-color:#904aff;
	border:none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
	color:white;
}

.violetBtn:hover{
	background-color:#7c3dde !important;
	border:none;
	color:white;
}

.redBtn{
	background-color:#FF5252;
	border:none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
	color:white;
}

.redBtn:hover{
	background-color:#e13636 !important;
	border:none;
	color:white;
}
.hasNottargetReplyNum {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
}
.note-editor{
	padding:0px;
}
</style>

<script type="text/javascript">

// 게시글 수정
function updatePost(){
	location.href="/ddit/community/update?comNum=${commVO.comNum}&mode=update";
}

// 게시글 삭제
function deletePost(){
	var deleteChk = confirm("정말 삭제하시겠습니까?");
	if(deleteChk == true){
		location.href="/ddit/community/deletePost?comNum=${commVO.comNum}";
		alert("삭제가 완료되었습니다.")
	}else{
		alert("삭제가 취소되었습니다.");
	}
}

// 목록으로 돌아가기
function backToList(){
	window.location.href="/ddit/community"
}

// 댓글박스 등록버튼 - 댓글등록하기
function insertReply(){
	var a = $('#replyContent');  // 댓글박스 <textarea>

	const replyNum = document.getElementById("replyNum").value;
	const comNum = ${commVO.comNum}
	const ptNum = document.getElementById("ptNum").value;
	const replyContent = document.getElementById("replyContent").value; // 댓글 박스 <textarea> 내용
	const lvl = document.getElementById("lvl").value;

	let paramObject = {
			'replyNum' : replyNum,
			'comNum' : comNum,
			'ptNum' : ptNum,
			'replyContent' : replyContent,
			'lvl' : lvl

	};

	console.log("JSON.stringify(paramObject) : ", JSON.stringify(paramObject))

	$.ajax({
		url : '/ddit/community/insertReply?comNum=${commVO.comNum}',
		type: 'post',
		data : JSON.stringify(paramObject),
		contentType: 'application/json;charset=utf-8',// 보내는타입이 JSON일때 꼭 적어주어야함
		beforeSend: function(xhr){ // method='post'일때
			xhr.setRequestHeader('X-CSRF-TOKEN', '${_csrf.token}');
		},
		success : function(result){

			let str = fnMakeHtml(result, myId, myNumber);
			 $(".comment_list").html(str);  //초기화한번 해주기


			a.summernote('reset');
			//버튼 이벤트 rebind
			fn_bindReplyBtn();
		}
	});
}

$(function(){
	var replyWriteBtn = $("#replyWriteBtn");
	var comment_list = $(".comment_list");
	var WriteReplyBtn = $("#WriteReplyBtn");

	fn_bindReplyBtn();

	// 답글쓰기버튼 클릭 시 summernote 띄우기
	comment_list.on("click", "#replyWriteBtn", function(){
// 		console.log("click...!!");
// 		console.log($(this).parents("div").find(".comment_inner_box"));
		$(this).parents("div").find(".comment_inner_box").css("display", "block");

		$(this).parents("div").find(".comment_inner_box").find('#reReplyBox').summernote({
// 		      width: 950,
			  height: 100,                 // 에디터 높이
		      minHeight: 100,             // 최소 높이
		      maxHeight: 200,             // 최대 높이
		      focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
		      lang: "ko-KR",					// 한글 설정
		      placeholder: '최대 2048자까지 쓸 수 있습니다',	//placeholder 설정
			  toolbar: [
						    // [groupName, [list of button]]
						    ['insert',['picture']],
						    ['fontname', []],
						    ['fontsize', []],
						    ['style', []],
						    ['color', []],
						    ['table', []],
						    ['para', []],
						    ['height', []],
						    ['view', []]
			  ],
			fontNames: [],
			fontSizes: ['8']
			});
	});

	comment_list.on("click", "#replyDeleteBtn", function(){
// 		console.log("deleteBtn 눌렸다!")
// 		console.log("댓글번호 ::::", $(this).parents(".hasNottargetReplyNum").find("#replyReplyNum").text());

		var replyNum = $(this).parents(".hasNottargetReplyNum").find("#replyReplyNum").text();
		var comNum = ${commVO.comNum}
		var	ptNum = $(this).parents(".hasNottargetReplyNum").find("#replyPtNum").text();
		var msg = confirm("댓글을 삭제합니다.");
		if(msg != true) { // 취소를 누를 경우
			return false; // 삭제 취소
		}

// 		console.log("환자번호 ::::", $(this).parents(".hasNottargetReplyNum").find("#replyPtNum").text());

		let paramObject = {
				'replyNum' : replyNum,
				'comNum' : comNum,
				'ptNum' : ptNum
		};

		$.ajax({
			url : '/ddit/community/deleteReply',
			data : JSON.stringify(paramObject), //삭제할 번호
			type : 'post',
			contentType: 'application/json;charset=utf-8',// 보내는타입이 JSON일때 꼭 적어주어야함
			beforeSend: function(xhr){ // method='post'일때
				xhr.setRequestHeader('X-CSRF-TOKEN', '${_csrf.token}');
			},
			success : function(result){
				alert("댓글이 삭제되었습니다.");
				// result = 댓글 리스트
				let str = fnMakeHtml(result, myId, myNumber);
				$(".comment_list").html(str);  //초기화한번 해주기
			}
		});
	});
});


function fn_bindReplyBtn(){

	var replyWriteBtn = $("#replyWriteBtn");
	var comment_list = $(".comment_list");
	var WriteReplyBtn = $("#WriteReplyBtn");

	// summernote안의 등록버튼 클릭 시 안의 값을 가져와서 댓글 등록하기
	comment_list.on("click", "#WriteReplyBtn", function(){
		console.log("123");
// 		debugger;

// 		var replyPtNum = $(this).parents(".hasNottargetReplyNum").find("#replyPtNum").text(); // 작성자 번호
// 		var replyPtID = $(this).parents(".hasNottargetReplyNum").find("#replyWriterID").text(); // 작성자ID
		var replyReplyNum = $(this).parents(".hasNottargetReplyNum").find("#replyReplyNum").text(); // 댓글번호
// 		var replyDate = $(this).parents(".hasNottargetReplyNum").find("#replyDate").text(); // 댓글 작성일
// 		console.log("replyDate : ", replyDate);
		var targetReplyNo = $(this).parents(".hasNottargetReplyNum").find("#targetReplyNo").text(); // 대상 댓글번호
		var replyLevel = $(this).parents(".hasNottargetReplyNum").find("#replyLevel").text(); // 댓글 레벨
		var upLevel = parseInt(replyLevel)+1;
		upLevel = upLevel.toString();
// 		console.log("upLevel : ", upLevel);
		var reReplyBox = $(this).parents(".hasNottargetReplyNum").find("#reReplyBox").val(); // 댓글 박스 <textarea> 내용
		const comNum = ${commVO.comNum}

		let paramObject = {
				'comNum' : comNum,
				'ptId' : myId,
				'ptNum' : myNumber,
				'targetReplyNum' : replyReplyNum,
				'lvl' : upLevel,
				'replyContent' : reReplyBox
		};

		console.log("JSON.stringify(paramObject) : ", JSON.stringify(paramObject));

		$.ajax({
			url : '/ddit/community/reReply?comNum=${commVO.comNum}',
			type: 'post',
			data : JSON.stringify(paramObject),
			contentType: 'application/json;charset=utf-8',
			beforeSend: function(xhr){
				xhr.setRequestHeader('X-CSRF-TOKEN', '${_csrf.token}');
			},
			success : function(result){

				let str = fnMakeHtml(result, myId, myNumber);

				$(".comment_list").html(str);  //초기화한번 해주기
			}
		});
	});
}

function fnMakeHtml(data, myId, myNumber){
	var str = "";

	// data = 댓글리스트
	$.each(data, function(index, replyVO){
// 		console.log("replyVO.replyDt :::: ", replyVO.replyDt)
		str += "<li class='hasNottargetReplyNum' style='margin-left:" + (replyVO.lvl-1)*5 +"%'>";
		str += "<div class='comment_box'>";
		str += "<div class='comment_nick_box'>";
		str += "<div class='comment_nick_info'>";
		str += "<div class='row'>";
		str += '<h6 class="col-3" id="replyWriter" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px; display: inline-block;" hidden="hidden">작성자 : <font id="replyPtNum">' + replyVO.ptNum + '</font></h6>';
		str += '<h6 class="col-3" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px; display: inline-block;">작성자 : ';
		if(replyVO.empNum != null){
			str += '<span class="badge rounded-pill bg-info text-white badgeStyle">관리자</span></h6>';
		}
		if(replyVO.ptId != null){
			str += '<font id="ptId">' + replyVO.ptId + '</font></h6>';
		}

		str += '<h6 class="col-6" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px;">작성일자 : <font id="replyDate">' + replyVO.replyDtStr + '</font></h6>';
		str += '<h6 class="col-6" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px;" hidden="hidden">댓글 넘버 : <font id="replyReplyNum">'  + replyVO.replyNum + '</font></h6>';
	    str += '<h6 class="col-6" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px;" hidden="hidden">대상댓글 : <font id="targetReplyNo">' + replyVO.targetReplyNum + '</font></h6>';
	    str += '<h6 class="col-6" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px;" hidden="hidden">댓글 레벨 : <font id="replyLevel">' + replyVO.lvl + '</font></h6>';
		str += "</div>";
		str += "</div>";
		str += "<div class='comment_text_box'>";
		str += "<p class='comment_text_view'>" + replyVO.replyContent + "</p>";
		str += "</div>";
		str += "<div class='comment_info_box'>";
		str += '<button class="btn btn-secondary btn-sm comment_info_button" id="replyWriteBtn">답글</button>&nbsp';
		if(myId === replyVO.ptId) {
			str += '<button class="btn btn-light btn-sm comment_info_button" id="replyDeleteBtn">삭제</button>';
		}
		str += '<div class="comment_inner_box" style="display:none;margin-top: 10px;">';
		str += '<textarea class="form-control comment_inbox_text" id="reReplyBox" name="reReplyBox"></textarea>';
		str += '<button type="button" class="btn btn-primary btn-sm btn_register is_active" id="WriteReplyBtn" style="float:right; margin-top:10px; margin-bottom: 10px;">등록</button>';
		str += '</div>';
		str += '<br />';
		str += "</div>";
		str += "</div>";
		str += "<hr style='width: 100%;' />";
		str += "</div>";
		str += "</li>";
	});

	return str;

}
</script>


<!-- Head Image 시작 -->
<div class="boardHeadImage">
	<div class="wrapper">
		<div class="slide">
			<img src="/resources/images/layout/ddit/communityHeadImage2.png" />
		</div>
	</div>
</div>
<!-- Head Image 끝 -->
<!-- main section 시작 -->
<section class="container">
	<!-- 커뮤니티 게시판 nav 시작 -->
	<div class="row" style="margin-left: 7%; margin-top: 50px; width: 85%; height: 100px; border-bottom: 1px solid gray;">
		<div class="col-12">
			<h4 style="margin-left: 50px; margin-top: 20px; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">${commVO.comTitle}</h4>
		</div>
		<div class="col-12">
			<div class="row">
				<h6 class="col-6" style="margin-left: 50px; font-family: 'Noto Sans KR', sans-serif; font-size: 14px;">
				 <!-- 원하는 날짜형식으로 출력하기 위해 fmt태그 사용 -->
                작성일자 : <fmt:formatDate value="${commVO.comDt}"  pattern="yyyy-MM-dd HH:mm"/>
				<c:if test="${commVO.comDt != commVO.comUpdatedDt}">
                (<fmt:formatDate value="${commVO.comUpdatedDt}"  pattern="yyyy-MM-dd HH:mm"/> 수정됨)
                </c:if>
                </h6>
				<h6 class="col-2" style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;">작성자: ${commVO.ptId}</h6>
				<h6 class="col-3" style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;">조회수: ${commVO.comInqCnt}</h6>
			</div>
		</div>
	</div>
	<!-- 커뮤니티 게시판 nav 끝 -->
	<div style="margin-left: 7%; margin-top: 50px; margin-bottom: 100px; width: 85%; height: auto;">
		<h5 style="margin-left: 50px; margin-right: 50px; font-family: 'Noto Sans KR', sans-serif;">
			${commVO.comContent}
		</h5>
	</div>
	<hr style="margin-left: 7%; width: 85%;" />

<!-- 	댓글부분 시작 -->
	<h5	style="margin-top: 20px; margin-left: 10%; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">댓글</h5>
	<hr style="margin-left: 7%; width: 85%;" />
	<ul class="comment_list" style="margin-left: 7%; width: 85%;" >
		<c:if test="${getReplyList.size() == 0}">
			<li><p class="textCss">해당 게시물에 댓글이 존재하지않습니다.</p></li>
		</c:if>
		<!--  댓글 리스트 시작 -->
		<c:forEach items="${getReplyList}" var="replyData" varStatus="">
				<li class="hasNottargetReplyNum" style="margin-left:${(replyData.lvl-1)*5}%">
						<div class="comment_box" >
							<div class="comment_nick_box">
								<div class="comment_nick_info">
									<div class="row">
										<h6 class="col-3"
											style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;" hidden="hidden">작성자
											: <font id="replyPtNum">${replyData.ptNum}</font></h6>
										<h6 class="col-3"
											style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;">작성자
											:
											<c:choose>
												<c:when test="${replyData.empNum!=null}">
													<span class="badge rounded-pill bg-info text-white badgeStyle">관리자</span>
												</c:when>
												<c:otherwise>
													<font id="ptId">${replyData.ptId}</font></h6>
												</c:otherwise>
											</c:choose>
										<h6 class="col-6"
											style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px;">작성일자
											: <font id="replyDate">${replyData.replyDtStr}</font></h6>
										<h6 class="col-6"
											style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px;" hidden="hidden">댓글 넘버
											: <font id="replyReplyNum">${replyData.replyNum}</font></h6>
										<h6 class="col-6"
											style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px;" hidden="hidden">대상댓글
											: <font id="targetReplyNo">${replyData.targetReplyNum}</font></h6>
										<h6 class="col-6"
											style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px;" hidden="hidden">댓글 레벨
											: <font id="replyLevel">${replyData.lvl}</font></h6>
									</div>

								</div>
								<div class="comment_text_box">
									<p class="comment_text_view">
										${replyData.replyContent}
									</p>
								</div>
								<div class="comment_info_box">
									<!-- 로그인 했다면 -->
									<sec:authorize access="hasRole('ROLE_PT')">
										<sec:authentication var="ptInfo" property="principal.ptVO" />
											<sec:authorize access="isAuthenticated()">
												<!--  toggleClass -->
												<button class="btn btn-primary violetBtn btn-sm comment_info_button" id="replyWriteBtn">답글</button>
												<!-- 로그인 했다면 -->
												<c:if test="${ptInfo.ptId==replyData.ptId}">
													<button class="btn btn-danger redBtn btn-sm comment_info_button" id="replyDeleteBtn" >삭제</button>
												</c:if>
											</sec:authorize>
									</sec:authorize>
									<div class="comment_inner_box" style="display:none; margin-top: 10px; ">
										<!--  댓글 박스 -->
										<textarea class="form-control comment_inbox_text" id="reReplyBox" name="reReplyBox"></textarea>
										<button type="button" class="btn btn-primary violetBtn btn-sm btn_register is_active" id="WriteReplyBtn" style="float:right; margin-top:10px; margin-bottom: 10px;">등록</button>
									</div>
									<br />
								</div>
							</div>
								<hr style="width: 100%;" />
						</div>
				</li>
		</c:forEach>
		<!-- 댓글 리스트 끝 -->

	</ul>
	<!--  댓글 등록 박스 -->
	<div class="CommentWriter">
		<form id="replyFrm" action="" method="post">
			<div class="row" style="margin-left:10%;">
				<sec:authorize access="hasRole('ROLE_PT')">
			   		<sec:authentication var="ptInfo" property="principal.ptVO" />
					<!-- 로그인 했다면 -->
					<sec:authorize access="isAuthenticated()">
						<h6	style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;">작성자 : <span id="loginId">${ptInfo.ptId}</span></h6>
						<input type="hidden" id="replyNum" value="0"/>
						<input type="hidden" id="myId" value="${ptInfo.ptId}"/>
						<input type="hidden" id="myNumber" value="${ptInfo.ptNum}"/>
						<input type="hidden" id="ptNum" value="${ptInfo.ptNum}"/>
						<input type="hidden" id="targetReplyNum" value=""/>
						<input type="hidden" id="lvl" value="1"/>
					</sec:authorize>
				</sec:authorize>
				<!-- 로그인 안 했다면 -->
				<sec:authorize access="isAnonymous()">
					<h6	style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;">작성자 : </h6>
				</sec:authorize>

				<!--  댓글 박스 -->
				<textarea class="form-control comment_inbox_text" id="replyContent" name="replyContent"></textarea>

				<div class="comment_attach">
					<div class="register_box">
					<!-- 로그인 했다면 -->
					<sec:authorize access="hasRole('ROLE_PT')">
						<sec:authentication var="ptInfo" property="principal.ptVO" />
							<sec:authorize access="isAuthenticated()">
									<button type="button" class="btn btn-primary violetBtn btn_register is_active" style="float:right; margin-right:10%; margin-top:10px;" onclick="insertReply()">등록</button>
							</sec:authorize>
						</sec:authorize>
					<!-- 로그인 안 했다면 -->
					<sec:authorize access="isAnonymous()">
						<button type="button" class="btn btn-primary violetBtn btn_register is_active" style="float:right; margin-right:10%; margin-top:10px;" onclick="javascript:alert('회원만 등록이 가능합니다.')">등록</button>
					</sec:authorize>
					</div>
				</div>
			</div>
		</form>
	</div>
	<!-- 	댓글부분 끝 -->
	<br />

	<hr style="margin-left: 7%; width: 85%;" />
	<div style="margin-left: 7%; margin-right: 7%;">
		<input type="button" class="btn btn-primary violetBtn listBtn" value="목록으로" style="margin-left: 50px;" onclick="backToList()"/>
		<!-- 로그인 했을 때만 화면에 보임 -->
		<sec:authorize access="isAuthenticated()">
			<sec:authentication property="principal.ptVO" var="ptVO"/>
			<c:if test="${ptVO.ptId==commVO.ptId}">
				<input type="button" class="btn btn-danger redBtn deleteBtn" value="게시물 삭제" style="float: right; margin-left: 10px; margin-right: 50px; background-color: #ff3e3e;"  onclick="deletePost()" />
				<input type="button" class="btn btn-primary violetBtn modifyBtn" value="게시물 수정" style="float: right;" onclick="updatePost()"/>
			</c:if>
		</sec:authorize>
	</div>
	<br />
</section>

<script>

let myId = document.getElementById("myId").value; // 로그인한 회원ID
let myNumber =  document.getElementById("myNumber").value; // 로그인한 회원 차트번호

//서머노트 초기화
$(function(){

	$('#replyContent').summernote({
	      width: 1060,
		  height: 100,                 // 에디터 높이
	      minHeight: 100,             // 최소 높이
	      maxHeight: 200,             // 최대 높이
	      focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
	      lang: "ko-KR",					// 한글 설정
	      placeholder: '댓글을 남겨보세요',	//placeholder 설정
		  toolbar: [
					    // [groupName, [list of button]]
					    ['insert',['picture']],
					    ['fontname', []],
					    ['fontsize', []],
					    ['style', []],
					    ['color', []],
					    ['table', []],
					    ['para', []],
					    ['height', []],
					    ['view', []]
		  ],
		fontNames: [],
		fontSizes: ['8']
		});
});

</script>