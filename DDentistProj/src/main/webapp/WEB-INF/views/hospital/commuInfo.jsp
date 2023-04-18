<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<style>
/* chatCss */
#chatButton{
	padding-right:1.25rem;
}
.navbar-badge{
	top:5px;
}
/* **************************** */
#communityBoardList {
	overflow-x: hidden;
}

#communityBoardList::-webkit-scrollbar {
	width: 10px;
	height: 10px;
}

#communityBoardList::-webkit-scrollbar-thumb {
	background-color: #404b57;
	border-radius: 5px;
}

#communityBoardList::-webkit-scrollbar-track {
	background-color: rgba(0, 0, 0, 0);
}

#communityCommentList {
	overflow-x: hidden;
}

#communityCommentList::-webkit-scrollbar {
	display: block;
	overflow: auto;
	width: 10px;
	height: 10px;
}

#communityCommentList::-webkit-scrollbar-thumb {
	background-color: #404b57;
	border-radius: 5px;
}

#communityCommentList::-webkit-scrollbar-track {
	background-color: rgba(0, 0, 0, 0);
}

.hasNottargetReplyNum{
	list-style: none;
}


.badgeStyle{
 	font-size: 100%;
 }

.violetBtn{
	background-color:#904aff;
	border:none;
	font-family: 'Noto Sans KR', sans-serif !important;
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
	font-family: 'Noto Sans KR', sans-serif !important;
	font-weight:500;
	color:white;
}

.redBtn:hover{
	background-color:#e13636 !important;
	border:none;
	color:white;
}
.selectCss, thead{
	font-family: 'Noto Sans KR', sans-serif !important;
	font-weight: 700;
}

.navbar-light .navbar-nav .nav-link {
	color: #f8f9fa;
	margin-left: 0.5rem;
	height: 38px;
	padding: 0.25rem;
	display: flex;
	align-items: center;
}
</style>

<!-- summernote -->
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
<script src="/resources/summernote/lang/summernote-ko-KR.js"></script>

<div class="content-wrapper" style="background-color: rgb(101, 125, 150); min-height: 873px;">
	<!-- main 검색창을 포함한 navbar 시작-->
	<nav class="navbar navbar-expand navbar-white navbar-light" style="background-color: #404b57;">
		<div class="input-group" style="width: 400px;">
			<input type="text" class="form-control" id="boardSearch" placeholder="게시글 검색" autocomplete="off" />
			<div class="input-group-append">
				<button type="button" id="boardSearchBtn" class="btn btn-outline-light" onclick="listReview();">검색</button>
			</div>
		</div>
		<ul class="navbar-nav ml-auto"></ul>
		<div class="menu">
			<ul class="navbar-nav mb-0">
			   <li class="nav-item"><a class="nav-link btn btn-outline-light active" href="/hospital/site/communityInfo" >커뮤니티 관리</a></li>
               <li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/bannerInfo" >배너 관리</a></li>
               <li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/doctorIntro" >의사 소개 관리</a></li>
               <li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/faqInfo" >자주 묻는 질문 관리</a></li>
			</ul>
		</div>
	</nav>

	<section class="content" style="margin-top: 1%;">
		<div class="row" style="height: 900px;">
			<!-- 게시글 목록 시작 -->
			<div class="col-md-4" style="height: 100%;">
				<div class="card card-info" style="height: 100%;">
					<div class="card-header" style="background-color: #404b57;">
						<div class="row">
							<div class="col-sm-5">
								<div class="card-title">
									<h4 class="m-0">커뮤니티 게시판</h4>
								</div>
							</div>
							<div class="col-sm-2"></div>
							<div class="col-sm-5">
								<select aria-label="Default select example" id="comType" name="comType" style="border:none;" class="custom-select rounded-10 selectCss">
									<option value=""<c:if test="${param.comType==''}">selected</c:if>>전체보기</option>
									<option value="따끈따끈 후기"<c:if test="${param.comType=='따끈따끈 후기'}">selected</c:if>>따끈따끈 후기</option>
									<option value="칭찬합니다"<c:if test="${param.comType=='칭찬합니다'}">selected</c:if>>칭찬합니다</option>
									<option value="불편사항 및 개선사항"<c:if test="${param.comType=='불편사항 및 개선사항'}">selected</c:if>>불편사항 및 개선사항</option>
								</select>
							</div>
						</div>
					</div>
					<div class="card-body p-2 text-right" style="height: 46px; min-height: 46px; max-height: 46px;">
						<input type="date" id="boardSDate" /> ~ <input type="date" id="boardEDate" />
						<button type="button" id="listBoardBtn" class="btn btn-primary btn-sm align-top ml-1 violetBtn"
								style="height: 30px; width:100px; box-sizing: border-box;">검색</button>
					</div>
					<!-- 게시판 목록 시작 -->
					<div id="communityBoardList" class="card-body boardDiv overflow-auto p-0">
						<table class="table table-hover text-center">
							<thead class="sticky-top bg-white">
								<tr>
									<th style="width: 15%;"></th>
									<th style="width: 25%;">작성일</th>
									<th style="width: 35%;">제목</th>
									<th style="width: 25%;">답변 여부</th>
								</tr>
							</thead>
							<!-- 생생후기 목록 Body 시작 -->
							<tbody id="reviewBoardListBody"></tbody>
							<!-- 생생후기 목록 Body 끝 -->
						</table>
					</div>
					<!-- 게시판 목록 끝 -->
				</div>
			</div>
			<!-- 게시글 목록 시작 -->
			<!-- 게시글 상세 시작 -->
			<div class="col-md-8" style="height: 100%;">
				<div class="card card-info">
					<div class="card-header" style="background-color: #404b57; height: 62px;">
						<div class="card-title">
							<h4 id="selectedBoardName" class="m-0">게시판</h4>
						</div>
					</div>
					<div id="reviewBoard" class="card-body boardDiv">
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label>제목</label>
									<div class="border p-2"style="min-height: 50px;  display: flex; align-items:center;">
										<strong><span id="comTitle"></span></strong>
									</div>
								</div>
								<div id="reviewBoardContent" style="min-height: 40%;">
									<table class="table text-center mb-0">
										<thead>
											<tr>
												<th style="width: 10%;">작성자 성명</th>
												<th style="width: 10%;">차트번호</th>
												<th style="width: 10%;">작성자 아이디</th>
												<th style="width: 10%;">작성일</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td id="ptNm"></td>
												<td id="ptNum"></td>
												<td id="ptId"></td>
												<td id="comDtStr"></td>
											</tr>
										</tbody>
									</table>
									<hr class="mt-0" />
									<div class="form-group">
									<label>내용</label>
									<div class="border p-2" id="comContent" style="min-height: 120px;"></div>
										</div>
								</div>
							</div>
							<hr />
							<div class="col-md-12">
								<form name="answerForm" action="/hospital/site/communityInfo/insertAnswer">
									<div class="form-group">
										<label for="replyContent">답변</label>
										<input type="hidden" id="comNum" name="comNum" value="" />
										<input type="hidden" id="empNum" name="_empNum" value="" />
										<input type="hidden" id="lvl" name="lvl" value="1" />
										<textarea class="form-control" id="replyContent" name="replyContent"></textarea>
									</div>
								</form>
								<div class="text-right">
									<button type="button" class="btn btn-success btnCss" onclick="saveAnswer();">답변 등록</button>
									<button type="button" class="btn btn-danger btnCss redBtn" id="deletePostBtn" onclick="deletePostAlert();">삭제</button>
								</div>
							</div>
							<hr />
						</div>
					</div>
					<div class="form-group" style="margin-left:20px;">
						<label for="replyContentList">댓글 리스트</label>
						<div hidden="hidden">
						<sec:authorize access="isAuthenticated()">
							<sec:authentication property="principal.empVO.authList" />
							<sec:authentication property="principal.empVO.authList" var="authList"/>
							<c:forEach var="employeeAuthrtVO" items="${authList}" varStatus="stat" >
								<c:set var="empAuthrt" value="${empAuthrt}${employeeAuthrtVO.empAuthrt}," />
							</c:forEach>
						</sec:authorize>
<%-- 						<p>결과 : ${empAuthrt}</p> --%>
						</div>
					</div>
					<div id="communityCommentList" class="card-body boardDiv overflow-auto p-0" style="height:400px; padding: 0px;">
						<div class="row" style="margin:15px;">
							<div class="col-md-12">
								<div class="form-group">
									<!--  댓글 리스트 출력하는 곳 시작 -->
									<ul class="comment_list" style="margin-left: 7%; width: 85%;">

										<!--  댓글 리스트 시작 -->
										<c:forEach items="${getReplyList}" var="replyData" varStatus="">
											<li class="hasNottargetReplyNum"
												style="margin-left:${(replyData.lvl-1)*5}%">
												<div class="comment_box">
													<div class="comment_nick_box">
														<div class="comment_nick_info">
															<div class="row">
																<h6 class="col-3"
																	style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;"
																	hidden="hidden">
																	작성자 : <font id="replyPtNum">${replyData.ptNum}</font>
																</h6>
																<h6 class="col-3"
																	style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;">
																	작성자ID : <font id="replyWriterID">${replyData.ptId}</font>
																</h6>
																<h6 class="col-6"
																	style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px;">
																	작성일시 : <font id="replyDate">${replyData.replyDt}</font>
																</h6>
																<h6 class="col-6"
																	style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px;"
																	hidden="hidden">
																	댓글 넘버 : <font id="replyReplyNum">${replyData.replyNum}</font>
																</h6>
																<h6 class="col-6"
																	style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px;"
																	hidden="hidden">
																	대상댓글 : <font id="targetReplyNo">${replyData.targetReplyNum}</font>
																</h6>
																<h6 class="col-6"
																	style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px;"
																	hidden="hidden">
																	댓글 레벨 : <font id="replyLevel">${replyData.lvl}</font>
																</h6>
															</div>

														</div>
														<div class="comment_text_box">
															<p class="comment_text_view">${replyData.replyContent}</p>
														</div>
														<div class="comment_info_box">
															<!-- 로그인 했다면 -->
															<sec:authorize access="isAuthenticated()">
																<sec:authorize access="hasAnyRole('ROLE_EMP','ROLE_ADMIN')">
																	<sec:authentication var="empVO" property="principal.empVO" />
																		<!--  toggleClass -->
<!-- 																		<button class="comment_info_button" id="replyWriteBtn">답글쓰기</button> -->
																		<!-- 로그인 했다면 -->
																		<c:if test="${empVO.empID==replyData.empId}">
																			<button class="comment_info_button" id="replyDeleteBtn">삭제</button>
																		</c:if>
																</sec:authorize>
															</sec:authorize>
															<div class="comment_inner_box" style="display: none;">
																<!--  댓글 박스 -->
																<textarea class="form-control comment_inbox_text"
																	id="reReplyBox" name="reReplyBox"></textarea>
																<button type="button" class="button btn_register is_active"
																	id="WriteReplyBtn"
																	style="float: right; margin-right: 3%; margin-top: 10px;">등록</button>
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
								</div>
								<!--  댓글 리스트 출력하는 곳 끝 -->
							</div>
						</div>
					</div>
					<!-- 로그인 했다면 -->
					<sec:authorize access="isAuthenticated()">
						<sec:authorize access="hasRole('ROLE_EMP')">
<%-- 							<sec:authentication var="ptInfo" property="principal.ptVO" /> --%>
								<!--  toggleClass -->
<!-- 								<button class="comment_info_button" id="replyWriteBtn">답글쓰기</button> -->
								<!-- 로그인 했다면 -->
<%-- 								<c:if test="${ptInfo.ptId==replyData.ptId}"> --%>
<!-- 									<button class="comment_info_button" id="replyDeleteBtn">삭제</button> -->
<%-- 								</c:if> --%>
						</sec:authorize>
					</sec:authorize>
				</div>
			</div><!-- col-md-8 end -->
			<!-- 생생 후기 게시글 상세 끝 -->
		</div>
		<!-- 게시글 상세 끝 -->
	</section>
</div>

<script>
//CSRF 토큰
csrfToken = $('#_csrfToken').val();

const offsetTime = new Date().getTimezoneOffset() * 60000;

let today = new Date(new Date().getTime() - offsetTime).toISOString().split('T')[0];
let beforeOneMonth = new Date(today);
beforeOneMonth.setDate(beforeOneMonth.getDate() - 30);
beforeOneMonth = beforeOneMonth.toISOString().split('T')[0];

document.querySelector('#boardEDate').value = today;
document.querySelector('#boardSDate').value = beforeOneMonth;
document.querySelector('#boardEDate').min = beforeOneMonth;
document.querySelector('#boardSDate').max = today;
document.querySelector('#boardEDate').max = today;

// //시작날짜를 변경하면 조건에 맞추어 종료날짜가 변경됨
$('#boardSDate').on('change', function(e){
	const boardSDate = $('#boardSDate');
	const boardEDate = $('#boardEDate');

	if(boardSDate.val() > boardEDate.val()){  // 시작날짜가 종료날짜보다 크면 종료날짜를 시작날짤
		boardEDate.val(boardSDate.val());
	}
	boardEDate.attr('min', boardSDate.val());
});


listReview();


// 기간선택 옆의 검색 버튼 클릭 시 게시판 검색 수행
$('#listBoardBtn').on('click', function(){
	$('#boardSearchBtn').click();
});

// 게시글 타입 선택 시 게시판 검색 수행
$("#comType").on("change", function(){
	$('#boardSearchBtn').click();
});

// 커뮤니티 게시판 목록 조회
function listReview(){

	const keyword = document.querySelector('#boardSearch').value; // 검색키워드
	const boardSDate = document.querySelector('#boardSDate').value; // 시작날짜
	const boardEDate = document.querySelector('#boardEDate').value; // 종료날짜
	let comType = document.querySelector("#comType").value; // 게시글 옵션 선택
	
	console.log("검색 키워드 :", keyword);
	console.log("검색 날짜(시작) :", boardSDate);
	console.log("검색 날짜(끝) :", boardEDate);
	console.log("검색 게시글 :", comType);

	let parameterData = {

			keyword : keyword,
			boardSDate : boardSDate,
			boardEDate : boardEDate,
			comType : comType
	}

	let parameterString = Object.entries(parameterData).map(e => e.join('=')).join('&');

	fetch('/hospital/site/communityInfo/listReview?' + parameterString)
		.then(res => { // fetch로 요청을 보내서 응답이오면 실행되는 구문
			if(!res.ok) throw new Error(); //에러가있으면 .catch()로 이동
			return res.json(); //res.ok 가 200이면 받아온 Controller에서 vo나 객체를 반환해주면 데이터를 javascript객체로 만들어줌
		})
		.then(reviewList => { //위에서 성공을 해야 이쪽으로 넘어옴

			let code = '';
			console.log("reviewList.length : ", reviewList.length);
			if(reviewList.length === 0 ){
				code += '<tr><td colspan="4">검색 결과가 존재하지 않습니다.</td></tr>';
				document.querySelector('#reviewBoardListBody').innerHTML = code;
			}else{
				// 커뮤니티 게시판 목록
				reviewList.forEach(function(review){

					code += '<tr class="reviewRow">';
					code += '<td>' + review.comNum + '</td>'; // 게시글 번호
					code += '<td>' + review.comDtStr + '</td>';  // 게시글 작성일
					code += '<td>' + review.comTitle + '</td>'; // 게시글 제목
					code += '<td class="d-none" id="titleHeader">' + review.comType + '</td>'; // 게시글 제목
					if(review.ansCount >= 1){
					code += '<td style="color:red;">';
						code += '답변 완료</td>';
					}
					if(review.ansCount == 0){
					code += '<td style="color:blue;">';
						code += '답변 미완료</td>';
					}
					code += '</tr>';
				});
				document.querySelector('#reviewBoardListBody').innerHTML = code;
			}
				document.querySelector('#selectedBoardName').innerText = comType;

		})
		.catch(() => {
			simpleJustErrorAlert();
		});
}

//답변 등록 클릭 시 실행
function saveAnswer(){

	let formData = new FormData(document.answerForm);
// 	console.log("formData ::: ", formData);

	if(formData.get('comNum') == '') {
		simpleErrorAlert('게시글을 선택해주세요.');
		return false;
	}

	if(formData.get('replyContent') == ''){
		simpleErrorAlert('내용을 입력해주세요.');
		return false;
	}

	const actionPath = document.answerForm.action;

	let str = "";
	let code = '';
	fetch(actionPath, {
		method: 'post',
		headers: {
			'X-CSRF-TOKEN' : csrfToken
		},
		body: formData
	})
		.then(res => {
			simpleSuccessAlert('답변을 등록하였습니다.');
// 			console.log("res.ok { 답변등록 결과는????}:::", res.ok);
			if(!res.ok) throw new Error();
			return res.json();
		})
		.then(getReplyVO => {
// 			console.log("getReplyVO.length : ", getReplyVO)

			//써머노트 초기화
			$("#replyContent").summernote('reset');

			str = replyList(getReplyVO);
			$(".comment_list").html(str);
			listReview();
		})
		.catch(() => {
			simpleJustErrorAlert();
		});
}

// 게시글 - 삭제 시 답변 삭제 알림창
function deletePostAlert(){

	var comNum = document.querySelector('#comNum').value;
	if(comNum == ''){
		simpleErrorAlert('게시글을 선택해주세요.');
		return false;
	}

	Swal.fire({
		title: '게시글을 삭제처리 하시겠습니까?',
		text: '삭제 여부를 변경합니다.',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result=> {
		if(result.isConfirmed){
			deletePost(); // 삭제처리
		}
	});
}


function deletePost(){

	var comNum = document.querySelector('#comNum').value;
// 	console.log("삭제할 게시글 번호 :  ",comNum);

	fetch('/hospital/site/communityInfo/deleteProcessYn?comNum='+ comNum)
		.then(res => {
			simpleSuccessAlert('게시글을 삭제처리 하였습니다.');
			console.log("삭제 결과 res(1또는0) :::", res.status);
			$("#comNum").val('');
			$("#comTitle").text('');
			$("#ptNm").text('');
			$("#ptNum").text('');
			$("#ptId").text('');
			$("#comDtStr").text('');
			$("#comContent").html('');

			listReview();
		})
		.catch(() => {
			simpleJustErrorAlert();
		})
}


// 게시글 - 삭제 시 작성된 댓글도 함께 삭제
function deletePost(){
	var comNum = document.querySelector('#comNum').value;

	let str = '';
	let code = '';
	fetch('/hospital/site/communityInfo/deleteProcessYn?comNum='+ comNum)
		.then(res => {
			simpleSuccessAlert('게시글을 삭제처리 하였습니다.');
// 			console.log("삭제 결과 res(1또는0) :::", res.status);
			$("#comNum").val('');
			$("#comTitle").text('삭제된 게시글입니다.');
			$("#ptNm").text('');
			$("#ptNum").text('');
			$("#ptId").text('');
			$("#comDtStr").text('');
			$("#comContent").html('삭제된 게시글입니다.');

			str += '<div id="communityCommentList" class="card-body boardDiv overflow-auto p-0" style="height:400px; padding: 0px;">';
			str += '	<div class="row" style="margin:15px;">';
			str += '	<div class="col-md-12">';
			str += '		<div class="form-group">';
			str += '			<ul class="comment_list" style="margin-left: 4%; width: 85%;"><li class="hasNottargetReplyNum" style="margin-left: 0px;">해당 게시글에 댓글이 없습니다.</li></ul>';
			str += '		</div>';
			str += '	</div>';
			str += '	</div>';
			str += '</div>';
			$(".comment_list").html(str);  //초기화한번 해주기comment_list.
			listReview();
		})
		.catch(() => {
			simpleJustErrorAlert();
		})
}

// 댓글 리스트 출력하기
function replyList(data){

	let str = "";

	let empAuthrt = "${empAuthrt}";
	//ROLE_ADMIN,ROLE_EMP,
// 	console.log("empAuthrt : " + empAuthrt);

	//댓글이 있을 때만 실행
	if(data.length>0){
		$.each(data, function(i, replyVO){
// 			console.log("댓글리스트 replyVO ::: ", replyVO);
			if(replyVO.replyNum === 0){
				return false;
			}

			str += "<li class='hasNottargetReplyNum' style='margin-left:" + (replyVO.lvl-1)*5 +"%'>";
			str += "<div class='comment_box'>";
			str += "<div class='comment_nick_box'>";
			str += "<div class='comment_nick_info'>";
			str += "<div class='row'>";
			str += '<h6 class="col-3" id="replyWriter" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px; display: inline-block;" hidden="hidden">작성자 : <font id="replyPtNum">' + replyVO.ptNum + '</font></h6>';
			str += '<h6 class="col-3" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px; display: inline-block;">작성자 : ';
			if(replyVO.ptId !== null){
				str += replyVO.ptId+'(' + replyVO.ptNm+')';
			}
			if(replyVO.empId 	 !== null){
				str += '<span class="badge rounded-pill bg-info text-dark badgeStyle">관리자</span>';
			}
			str += '</h6>';
			str += '<h6 class="col-6" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px;">작성일시 : <font id="replyDate">' + replyVO.replyDtStr + '</font></h6>';
			str += '<h6 class="col-6" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px;" hidden="hidden">댓글 넘버 : <font id="replyReplyNum">'  + replyVO.replyNum + '</font></h6>';
		    str += '<h6 class="col-6" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px;" hidden="hidden">대상댓글 : <font id="targetReplyNo">' + replyVO.targetReplyNum + '</font></h6>';
		    str += '<h6 class="col-6" style="font-family: \'Noto Sans KR\', sans-serif; font-size: 14px;" hidden="hidden">댓글 레벨 : <font id="replyLevel">' + replyVO.lvl + '</font></h6>';
			str += "</div>";
			str += "</div>";
			str += "<div class='comment_text_box'>";
			str += "<p class='comment_text_view'>" + replyVO.replyContent + "</p>";
			str += "</div>";
			str += "<div class='comment_info_box'>";

			//empAuthrt : ROLE_ADMIN,ROLE_EMP,
			//indexOf : 찾는 문자열이 없으면 -1을 리턴합니다
			if(empAuthrt.indexOf("ROLE_ADMIN")>=0 || empAuthrt.indexOf("ROLE_EMP")>=0){
				str += '<button class="btn btn-secondary btn-sm comment_info_button" id="replyDeleteBtn">삭제</button>';
			}
			str += '<div class="comment_inner_box" style="display:none;">';
			str += '<textarea class="form-control comment_inbox_text" id="reReplyBox" name="reReplyBox"></textarea>';
			str += '<button type="button" class="button btn_register is_active" id="WriteReplyBtn" style="float:right; margin-right:12%; margin-top:10px;">등록</button>';
			str += '</div>';
			str += '<br />';
			str += "</div>";
			str += "</div>";
			str += "<hr style='width: 100%;' />";
			str += "</div>";
			str += "</li>";
		});
	}else{
		str += "<div class='hasNottargetReplyNum' style='margin-left: 0px;'>해당 게시글에 댓글이 없습니다.</div>";
	}

	return str;
}


// 후기게시글 목록을 선택하면 우측 폼에 내용이 채워진다.
$(document).on("click", ".reviewRow", function(){

	const comNum =  $(this).children()[0].textContent;
	let str = "";

	fetch('/hospital/site/communityInfo/selectReview?comNum='+ comNum)
		.then(res =>  {
// 			console.log("res :::", res);
			if(!res.ok) throw new Error();
			return res.json();
		})
		.then(review => {
// 			console.log("review ::: ", review);
			$("#selectedBoardName").text(review.comType);
			$("#comNum").val(review.comNum);
			$("#comTitle").text(review.comTitle);
			$("#ptNm").text(review.ptNm);
			$("#ptNum").text(review.ptNum);
			$("#ptId").text(review.ptId);
			$("#comDtStr").text(review.comUpdatedDtStr);
			$("#comContent").html(review.comContent);

// 			console.log("review.replyList.length : " + review.replyList.length);

			str = replyList(review.replyList);

			$(".comment_list").html(str);  //초기화한번 해주기comment_list.
		}).catch(() => {
			simpleJustErrorAlert();
		});
});

// 댓글 삭제
var comment_list = $(".comment_list");

comment_list.on("click", "#replyDeleteBtn", function(){

	var replyNum = $(this).parents(".hasNottargetReplyNum").find("#replyReplyNum").text();
	var comNum = $("#comNum").val();

	let paramobjet = {
			'replyNum' : replyNum,
			'comNum'   : comNum
	}

	let parameterString = Object.entries(paramobjet).map(e => e.join('=')).join('&');

	fetch('/hospital/site/communityInfo/empAuthDeleteReply?' + parameterString)
		.then(res => {
			if(!res.ok) throw new Error();
			console.log("댓글삭제결과 : ", res.ok);
			return res.json();
		})
		.then(reviewVO => {
			simpleSuccessAlert('댓글을 삭제하였습니다.');
			listReview();
// 			console.log("reviewVO{댓글 삭제 후 상세정보 출력} ::: ", reviewVO);
			$("#comNum").val(reviewVO.comNum);
			$("#comTitle").text(reviewVO.comTitle);
			$("#ptNm").text(reviewVO.ptNm);
			$("#ptNum").text(reviewVO.ptNum);
			$("#ptId").text(reviewVO.ptId);
			$("#comDtStr").text(reviewVO.comUpdatedDtStr);
			$("#comContent").html(reviewVO.comContent);

// 			console.log("reviewVO.replyList.length : " + reviewVO.replyList.length);

			str = replyList(reviewVO.replyList);

			$(".comment_list").html(str);  //초기화한번 해주기comment_list.

		}).catch(() => {
			simpleJustErrorAlert();
		});
});

//서머노트 초기화
$(function(){

	$('#replyContent').summernote({
		  height: 100,                 // 에디터 높이
	      minHeight: 100,             // 최소 높이
	      maxHeight: 200,             // 최대 높이
	      focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
	      lang: "ko-KR",					// 한글 설정
	      placeholder: '진심어린 답변을 작성부탁드립니다.',	//placeholder 설정
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

<script src="/resources/js/alertModule.js"></script>