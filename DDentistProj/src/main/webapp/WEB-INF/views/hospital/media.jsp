<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
/* chatCss */
#chatButton{
	padding-right:1.25rem;
}
.navbar-badge{
	top:5px;
}
/* **************************** */
td[data-toggle="dropdown"]{
	cursor: pointer;
}
/* 진료목록 헤더 */
.tableHead {
	position: sticky;
	top: -0.1px;
	background-color: whitesmoke;

}
td {
	text-align: center;
}
.ptInfo{
	vertical-align: bottom;
}
#uploadFileStart, #startCanvas, #imgDelete{
	float: right;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
	margin:0px 5px;
}

.imgSelectDiv{
	border: 2px solid red;
/* 	border: 1.5px solid black; */
/* 	transform: scale(1.2); */
}

input:focus { outline: none; }

/* Button css */
.redBtn{
	width:100px;
	background-color:#FF5252;
	border:none;
}

.redBtn:hover{
	background-color:#e13636 !important;
}

.fileBtn{
	border-left: 3px solid #FF5252;
	padding-left: 10px;
	background-color:white;
	color:#3e3e3e;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
}
/* 검색 초기화 버튼 */
@keyframes vibrate-1 {
  0% {
    -webkit-transform: translate(0);
            transform: translate(0);
  }
  20% {
    -webkit-transform: translate(-2px, 2px);
            transform: translate(-2px, 2px);
  }
  40% {
    -webkit-transform: translate(-2px, -2px);
            transform: translate(-2px, -2px);
  }
  60% {
    -webkit-transform: translate(2px, 2px);
            transform: translate(2px, 2px);
  }
  80% {
    -webkit-transform: translate(2px, -2px);
            transform: translate(2px, -2px);
  }
  100% {
    -webkit-transform: translate(0);
            transform: translate(0);
  }
}

.crossBtn {
    border-radius: 30px;
    border: 2px solid white;
    width: 35px;
    height: 35px;
    text-align: center;
    background: #404b57;
    color: white;
    padding: 7px;
    margin-left: 10px;
    cursor:pointer;
}

.crossBtn:hover {
    border: 2px solid #FF5252;
    color: #FF5252 !important;
    animation: vibrate-1 0.3s linear infinite both;
}
/***************************************************** */
.imgBtn{
	background-color: #904aff;
	border: #904aff;
	font-family: 'Noto Sans KR', sans-serif;
    font-weight: 700;
}

.imgBtn:hover{
    background-color: #7c3dde;
}

.violetBtn:hover{
	background-color:#7c3dde !important;
}
#imgDelete:hover{
	background-color:#e13636 !important;
}

</style>


<div class="content-wrapper" style="background-color: #657D96; height: 900px;">
	<!-- main 검색창을 포함한 navbar 시작-->
	<nav class="navbar navbar-expand navbar-white navbar-light" style="background-color: #404b57;">

		<div class="input-group" style="width: 400px;">
			<input type="text" class="form-control" id="ptSearch" onkeyup="searchPt(this);" placeholder="환자 검색" autocomplete="off">
			<div class="input-group-append">
				<button type="button" id="ptSearchBtn" class="btn btn-outline-light" onclick="searchCheck();" >검색</button>
			</div>
		</div>

	</nav>
	<!-- main 검색창을 포함한 navbar 끝 -->
	<section class="content" style="margin-top: 1%;">
		<div class="row">
         <div class="col-lg-7">
            <!-------------------- 진료 기록 시작-------------------->
            <div class="card card-info menuDiv">
               <div class="card-header" style="background-color: #404b57;">
                  <h3 class="card-title" style="color: white;">진료 기록</h3>
               </div>

               <div class="card-body table-responsive p-0"
                  style="border-bottom: 20px; overflow-x: hidden;" id="tabCard">
                  <div id="example2_wrapper"
                     class="dataTables_wrapper dt-bootstrap4">
                     <div class="row">
                        <div class="col-sm-12">
                           	<div class="card-body py-2 text-right" style="max-height: 45px;">
								<input type="date" id="checkUpSDate" /> ~ <input type="date" id="checkUpEDate" />
							</div>
							<!-- table-striped -->
							<div style="height: 806px; overflow:auto;">
	                           <table
	                              class="table table-bordered table-hover dataTable dtr-inline tablehover "
	                              aria-describedby="example2_info" style="table-layout: fixed;">
	                              <thead class="tableHead text-center" style="font-family: 'Noto Sans KR', sans-serif; font-weight: 500;">
	                                 <tr>
	                                    <th style="width: 12%;">진료번호</th>
	                                    <th style="width: 9%;">진료일</th>
	                                    <th style="width: 6%;">이름</th>
	                                    <th style="width: 9%;">차트번호</th>
	                                    <th style="width: 9%;">생년월일</th>
	                                    <th style="width: 6%;">의사</th>
	                                 </tr>
	                              </thead>
	                              <tbody id="chartInfo">
	                              	<!-- 진료 정보 출력 -->
	                              </tbody>
	                           </table>
	                       </div>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
            <!-------------------- 진료 기록 끝-------------------->
         </div>
         <div class="col-lg-5">
	        <!-------------------- 환자 정보 시작  -------------------->
            <div class="card card-info" style="width:auto; height: 400px;">
               <div class="card-header" style="background-color: #404b57;">
                  <h3 class="card-title" style="color: white;">환자 정보</h3>
               </div>

               <div class="card-body table-responsive p-0"
                  style="height: 800px; border-bottom: 20px; overflow-x: hidden; font-family: 'Noto Sans KR', sans-serif; font-weight: 500;"
                  id="tabCard">
                  <div id="example2_wrapper"
                     class="dataTables_wrapper dt-bootstrap4">
                     <div class="row">
                        <div class="col-sm-12">
                           <!-- 환자 정보 시작 -->
                           <table class="table align-middle" id="ptInfo">
                           		<tr>
                           			<td style="width:200px; font-weight:700;">환자이름</td>
                           			<td><div id="ptNm"></div></td>
                           		</tr>
                           		<tr>
                           			<td style="font-weight:700;">차트번호</td>
                           			<td><div id="ptNum"></div></td>
                           		</tr>
                           		<tr>
                           			<td style="font-weight:700;">생년월일</td>
                           			<td><div id="ptBrdt"></div></td>
                           		</tr>
                           		<tr>
                           			<td style="font-weight:700;">성별</td>
                           			<td>
                           				<div class="form-check">
	                           				<input class="form-check-input" type="checkbox" name="gender" id="M" disabled />
	                           				<label class="form-check-label" for="M">&nbsp;남&nbsp;성&nbsp;</label>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input class="form-check-input" type="checkbox" name="gender" id="W" disabled />
											<label class="form-check-label" for="F">&nbsp;여&nbsp;성&nbsp;</label>
										</div>
                           			</td>
                           		</tr>
                           		<tr>
                           			<td colspan="2" style="font-weight:700;">환자 메모</td>
                           		</tr>
                           		<tr>
                           			<td colspan="2" rowspan="2" ><div id="ptMemo"></div></td>
                           		</tr>
                           </table>
                           <!-- 환자 정보 끝 -->
                        </div>
                     </div>
                  </div>
               </div>
            </div>
	        <!-------------------- 환자 정보 완료 -------------------->

	        <!-------------------- 썸네일 시작  -------------------->
	            <div class="card card-info" style="width:auto;height: 481px; ">
	               <div class="card-header" style="background-color: #404b57;">
	                  <h3 class="card-title" style="color: white;">영상 정보</h3>
	                 	<!-- 업로드 시작 버튼 시작-->
						<button type="button" class="btn btn-danger btn-sm" id="imgDelete" style="background-color:#FF5252; border:none;">영상 삭제</button>
						<!-- 사진 canvas 버튼 -->
	                 	<button type="button" class="btn btn-success btn-sm" id="startCanvas" style="border:none;">영상 편집</button>
						<button type="button" class="btn btn-primary btn-sm violetBtn" data-toggle="modal" data-target="#staticBackdrop" id="uploadFileStart" style="background-color:#904aff; border:none;" >영상 업로드</button>
	                 	<!-- 업로드 시작 버튼 끝-->
	               </div>

	               <div class="card-body table-responsive p-0"
	                  style="height: 850px; border-bottom: 20px; overflow-x: hidden;"
	                  id="tabCard">
	                  <div id="example2_wrapper"
	                     class="dataTables_wrapper dt-bootstrap4">
	                     <div class="row">
							<div class="col-sm-12">
								<!-- 영상 출력 시작 -->
								<div id="imgUpload" >
								  <!-- 이미지 로딩 -->
								</div>
								<!-- 영상 출력 끝 -->
	                        </div>
	                     </div>
	                  </div>
	               </div>
	            </div>
	        <!-------------------- 썸네일 완료 -------------------->
         </div>
      </div>
	</section>
</div>

<!-- 이미지 업로드 모달 시작 -->
<div class="modal" tabindex="-1" id="staticBackdrop">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius: 30px;">
      <div class="modal-header" style="width: 80%; margin-left: 11%; border-bottom: 2px solid #FF5252;">
        <h5 class="modal-title">업로드</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" style="padding: 40px 40px;">
       	<input type="file" class="btn-min btn-sm fileBtn" id="uploadFileSelect" multiple />
       	<hr />
       	<div>
       		<div style="border-left: 3px solid #FF5252;padding-left: 10px; margin-bottom:10px;">
       			영상구분
       		</div>
       		<input class="medType" type="radio" name="medType" value="X-RAY" id="X-RAY" checked />
		  	<label for="X-RAY">X-RAY
		  	</label>
	       	<input class="medType" type="radio" name="medType" value="CT" id="CT" />
		  	<label for="CT">CT
		  	</label>
		  	<div id="loadingImg"></div>
		</div>
      </div>
      <div class="modal-footer" style="margin: auto; border-top:0px;">
        <button type="button" class="btn btn-danger redBtn" id="uploadFile">업로드</button>
        <button type="button" class="btn btn-outline-secondary" data-dismiss="modal" id="closeModal" style="border:none; width:100px;">닫기</button>
      </div>
    </div>
  </div>
</div>
<!-- 이미지 업로드 모달 끝 -->




<script>
// 시작 세팅
// 오늘 날짜와 한달 전 날짜 입력
var today = new Date();
$("#checkUpEDate").val(formatDate(today));
var sdate = today.setDate(today.getDate() - 7);
$("#checkUpSDate").val(formatDate(sdate));

function LoadingWithMask(gif) {
    //화면의 높이와 너비를 구합니다.
    var maskHeight = $(document).height();
    var maskWidth  = window.document.body.clientWidth;

    //화면에 출력할 마스크를 설정해줍니다.
    var mask       = "<div id='mask' style='position:absolute; z-index:9000; background-color:#000000; display:none; left:0; top:0;'></div>";
    var loadingImg = '';

    loadingImg += " <img src='"+ gif + "' style='margin: auto; display: flex; justify-content: center; opacity :1; '/>";

    //화면에 레이어 추가
    $('body')
        .append(mask)

    //마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채웁니다.
    $('#mask').css({
            'width' : maskWidth,
            'height': maskHeight,
            'opacity' : '0.3'
    });

    //마스크 표시
    $('#mask').append(loadingImg);
    $('#mask').show();

}

// 파일 업로드
function fileUpLoad(chkNum, medType){
	var ptNum = $("#ptNum").text();

	var form = $('#uploadFileSelect')[0].files;
	var formData = new FormData();

	[...form].forEach(function(file){
		formData.append('image', file);
	});

	formData.append('chkNum', chkNum);
	formData.append('ptNum', ptNum);
	formData.append('medType', medType);

	$.ajax({
	   url:"/hospital/media/uploadFile",
	   type:"POST",
	   processData:false,
	   contentType:false,
	   data:formData,
	   beforeSend: function(xhr) {
           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
       },
	   success:function(data){
// 			console.log("data : " + data);
			if(data >= 1) {
				simpleSuccessAlert("이미지가 업로드되었습니다.");
				$("#closeModal").click();
				$('#imgUpload').empty();
				let loadingSpinner = '';
				loadingSpinner += '<div class="text-center my-4">';
				loadingSpinner += '<img src="/resources/images/layout/hospital/loading_dotted.gif" alt="로딩 이미지" />'
				loadingSpinner += '</div>';
				$('#uploadFileSelect').val('');
				$('#imgUpload').html(loadingSpinner);
				setTimeout(() => {mediaInfo(chkNum)}, 5000);

			} else if (data == 0) {
				simpleJustErrorAlert();
			};
	   },
	   error: function(err){
// 		   console.log(err.status);
		   simpleJustErrorAlert();
	   }
	});
}

// 캔버스 창 띄우기
var CanvasWindow;
$('#startCanvas').on("click", function(){
	var class_cnt = document.getElementsByClassName('imgSelect').length;
	if(class_cnt == 0){
		simpleErrorAlert("이미지를 선택해주세요");
		return false;
	};

	CanvasWindow = window.open(
			url = "/hospital/media/canvas" ,
			 'canvas', 'top=100, left=50, width=1200, height=1200, toolbar=no, menubar=no, location=no, status=no, scrollbars=no, resizable=no');
});

// 사진 클릭시 카드 이벤트
$(document).on('click','img', function(){
	var imgCardDiv = $(this).parent();

	// 처음 클릭
	if(!imgCardDiv.hasClass('imgSelectDiv')){
		imgCardDiv.find(".imgSelectDiv").each(function(){
			$(this).removeClass('imgSelectDiv');
		});
		imgCardDiv.addClass('imgSelectDiv');
	} else { // 두번째 클릭
		imgCardDiv.removeClass('imgSelectDiv');
	};

	// 처음 클릭
	if(!$(this).hasClass('imgSelect')){
		$(this).find(".imgSelect").each(function(){
			$(this).removeClass('imgSelect');
		});
		$(this).addClass('imgSelect');
	} else { // 두번째 클릭
		$(this).removeClass('imgSelect');
	};
});
// 이미지 업로드 끝

// 원본 보기 버튼 클릭시 이벤트
var openWindow;
$(document).on('click','.imgBtn', function(){

	if(!$(this).hasClass('imgBtnSeleted')){
		$(this).parents().find(".imgBtnSeleted").each(function(){
			$(this).removeClass('imgBtnSeleted');
		});
		$(this).addClass('imgBtnSeleted');
		var imgSrc = $(this).prop('name');
		openWindow = window.open(imgSrc, 'thumbnail', 'top=50, left=50, width=700, height=600, toolbar=no, menubar=no, location=no, status=no, scrollbars=no, resizable=no');
	} else { // 두번째 클릭
		$(this).removeClass('imgBtnSeleted');
		openWindow.close();
	}
});

// 입력 날짜보다 하루 다음 날짜 반환
function nextDay(day){
	var inputDay = new Date(day);
	var nextDate = formatDate(inputDay.setDate(inputDay.getDate() + 1));
	return nextDate;
}

// 진료기록 가져오기
function checkUpInfo(data){
// 	console.log('환자 data : ' + JSON.stringify(data));
	$.ajax({
		url:'/hospital/media/ptInfo',
		type:'post',
		data:JSON.stringify(data),
		dataType:'json',
		beforeSend: function(xhr) {
           xhr.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
        },
		success: function(res){
			$('#chartInfo').html('');
			$('#imgUpload').html('');
			var chartUpInfo = '';
			// console.log('환자 정보 불러오기 성공 : ' + JSON.stringify(res));
			$.each(res, function(i, v){
				var brdt = v.ptBrdt.trim();
				var brday = brdt.substr(0,4) + "." + brdt.substr(4,2) + "." + brdt.substr(6);

					chartUpInfo += "<tr id=" + v.chkNum + ">";
					chartUpInfo += "<td style='width: 12%;'>" + v.chkNum + "</td>";
					chartUpInfo += "<td style='width: 9%;'>" + formatDate(v.chkDt) + "</td>";
					chartUpInfo += "<td style='width: 6%;' data-memo='" + v.ptMemo + "'>" + v.ptNm + "</td>";
					chartUpInfo += "<td style='width: 9%;'>" + v.ptNum + "</td>";
					chartUpInfo += "<td style='width: 9%;' data-gender='" + v.ptGen + "'>" + brday + "</td>";
					chartUpInfo += "<td style='width: 6%;'>" + v.empNm + "</td>";
					chartUpInfo += "</tr>";
			});
			if(chartUpInfo == ''){
				chartUpInfo += "<tr>";
				chartUpInfo += "<td colspan='6' style='pointer-events: none;'>진료기록이 존재하지 않습니다.</td>";
				chartUpInfo += "</tr>";
			}
			$('#chartInfo').html(chartUpInfo);
		},
		error: function(err){
// 			console.log(err.status);
			simpleJustErrorAlert();
		}
	});
};

// 날짜 변경 시
$(document).on('change', '#checkUpEDate, #checkUpSDate', function(){
	// 날짜 변경 시 끝 날짜가 시작 날짜보다 앞 날짜 선택 불가능
	var checkEDate = $("#checkUpEDate").val();
	var checkSDate = $("#checkUpSDate").val();

	$("#checkUpEDate").attr("min", formatDate(checkSDate));
	if(checkEDate < checkSDate){
		$("#checkUpEDate").val(formatDate(checkSDate));
	}

	var ptNm = $("#ptSearch").val();
	data = {
		'ptNm':ptNm,
		'sdate':checkSDate,
		'edate':nextDay(checkEDate)
	}

	// console.log("checkEDate : " + checkEDate);
	checkUpInfo(data);

	var id = $(".selected").attr('id');
	if(id == null ){
		// console.log('없음');
		return false;
	}
	mediaInfo(id);
});

function searchCheck() {
	var ptNm = $("#ptSearch").val();
	var checkUpEDate = $("#checkUpEDate").val();
	var checkUpSDate = $("#checkUpSDate").val();

	var data = {
		'ptNm':ptNm,
		'sdate':checkUpSDate,
		'edate':nextDay(checkUpEDate)
	};

	checkUpInfo(data);
	$("#uploadFileSelect").val('');
};

// 이름 받기
function searchPt(target){
	if (window.event.keyCode == 13) {
		// console.log(target.value);
		var ptNm = target.value;
		var checkUpEDate = $("#checkUpEDate").val();
		var checkUpSDate = $("#checkUpSDate").val();

		var data = {
			'ptNm':ptNm,
			'sdate':checkUpSDate,
			'edate':nextDay(checkUpEDate)
		}
		checkUpInfo(data);
		$("#uploadFileSelect").val('');
	}
}

//========================================= 진료기록 선택 이후 이벤트 시작 ===================================
// 진료기록 선택 css class;
$(document).on('click', '#chartInfo tr', function(){
	$("input[id='" + 'M' + "']").prop('checked',false);
	$("input[id='" + 'W' + "']").prop('checked',false);
	
	var selectTd = $(this).find('td');
	
	if($(this).hasClass('selected')){ // 이미 선택된 항목
		$(this).removeClass('selected');
		$(this).css('background-color','');

		// 환자 정보 지우기
		$("#ptNm").text('');
		$("#ptNum").text('');
		$("#ptBrdt").text('');
		$("#ptMemo").text('');

		// 이미지 썸네일 지우기
		$("#imgUpload").html('');
	} else { // 새로 선택된 항목
		// 이전 선택 제거
		$(".selected").css('background-color','');
		$(".selected").removeClass('selected');

		$(this).addClass('selected');
		$(this).css('background-color','#E2E2E2');
		// 클릭한 진료기록에 대한 환자 정보 입력
		$("#ptNm").text(selectTd.eq(2).text());
		$("#ptNum").text(selectTd.eq(3).text());
		$("#ptBrdt").text(selectTd.eq(4).text());
		$("#ptMemo").text(selectTd.eq(2).data('memo'));
		$("input[id='" + selectTd.eq(4).data('gender') + "']").prop('checked',true);
		
		// 클릭한 진료기록에 대한 ct/ x-ray 사진의 썸네일 정보 가져오기
		var chkNum = this.id;
	    mediaInfo(chkNum);
	}
});

// 진료기록에 대한 썸네일 가져오기
function mediaInfo(chkNum){
	var mediaEDate = $("#checkUpSDate").val();
	var mediaSDate = $("#checkUpEDate").val();

	var data = {
    	'chkNum': chkNum,
    	'sDate': mediaSDate,
    	'eDate': nextDay(mediaEDate)
    };

	$.ajax({
		url:"/hospital/media/mediaInfo",
		type:"post",
		data:JSON.stringify(data),
		dataType:"json",
		beforeSend: function(xhr) {
           xhr.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
        },
		success: function(result){
			var mediaInfo = '';
			mediaInfo += '<div class="p-2 d-flex flex-wrap">';
			$.each(result, function(i, v){

				mediaInfo += '<div class="mx-1 my-2 text-center">';
				mediaInfo += '	<button type="button" id="/resources/upload' + v.medThumbPath + '" class="btn btn-primary btn-sm btn-block imgBtn" name="/resources/upload' + v.medSavePath + '">원본보기</button>';
				mediaInfo += '	<div class="mt-2 d-flex justify-content-center align-items-center bg-black mediaImgBox" style="width: 100px; height: 100px;">';
				mediaInfo += '		<img src="/resources/upload' + v.medThumbPath + '" alt="' + v.medSavePath + '" id="' + v.medNum + '" style="max-height: 100%; max-width: 100%;" />';
				mediaInfo += '	</div>';
				mediaInfo += '</div>';

				/*
				mediaInfo +='<div class="card" style="width: 9rem;height:7rem; margin:15px; float:left">';	// 사진 크기 조절
				mediaInfo +='  <img src="/resources/upload' + v.medThumbPath + '" class="card-img-top" alt="' + v.medSavePath + '" id="' + v.medNum + '"/>';
				mediaInfo +='  <button class="btn-secondary imgBtn" name="/resources/upload' + v.medSavePath + '" id="/resources/upload' + v.medThumbPath + '" >원본 보기</button>';
				mediaInfo +='</div>';
				*/
			});
			mediaInfo += '</div>';
			$("#imgUpload").html(mediaInfo);
		},
		error: function(err){
			console.log(err.status);
			simpleJustErrorAlert();
		},
	});
}

// 사진 업로드 클릭시 진료 아아디 받기
var chkNum = '';
$("#uploadFileStart").on('click', function(){
	chkNum = '';
	var bUpload = false;
	$("#chartInfo tr").each(function(){
		if($(this).hasClass('selected')){
			bUpload = !bUpload;
			chkNum = this.id;
		};
	});

	if(!bUpload) {
		simpleErrorAlert('진료 기록을 선택해주세요.');
		return false;
	}
});

// 이미지 업로드
$("#uploadFile").on("click", function(){
	var imgSrc = $("#uploadFileSelect").val();
	var imgType = $("input[type=radio][name='medType']:checked").val();
// 	console.log(imgType);

	if(imgSrc == null || imgSrc == ''){
		simpleErrorAlert("이미지를 선택해주세요.")
		return false;
	}
	if(imgType == null || imgType == null){
		simpleErrorAlert("영상 타입을 선택해주세요.");
		return false;
	}

	fileUpLoad(chkNum, imgType);
});

// 삭제 버튼 클릭 시
$(document).on("click", "#imgDelete", function(){
	var class_cnt = document.getElementsByClassName('imgSelect').length;

	if(class_cnt == 0) {
		simpleErrorAlert("이미지를 선택해주세요.");
		return false;
	}

	var imgSrcArray = [];
	var imgNumArray = [];
	var chkNum = $(".selected").attr('id');

	$(".imgSelect").each(function(i, v){
		imgNumArray[i] = v.id;
		imgSrcArray[i] = v.src;
	});

	Swal.fire({
		title: '이미지를 삭제하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){
			imgDelete(imgSrcArray, imgNumArray, chkNum);
		}
	});

});


// 이미지 삭제 함수
function imgDelete(imgSrcArray, dataArray, chkNum){
// 	console.log('삭제하러 옴')
	$.ajax({
	   url:"/hospital/media/imgDelete",
	   type:"POST",
	   data:JSON.stringify({
		   'imgSrcArray':imgSrcArray,
		   'imgNumArray':dataArray
	   }),
	   beforeSend: function(xhr) {
		   xhr.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
       },
	   success:function(data){
// 			console.log("data : " + data);
			if(data >= 1) {
				simpleSuccessAlert("이미지가 삭제되었습니다.");
				mediaInfo(chkNum)
			} else if (data == 0) {
				simpleJustErrorAlert();
			};
	   },
	   error: function(err){
// 		   console.log(err.status);
		   simpleJustErrorAlert();
	   }
	});
}

// yyyy-mm-dd 포멧
function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2)
        month = '0' + month;
    if (day.length < 2)
        day = '0' + day;

    return [year, month, day].join('-');
}


</script>
<script src="/resources/js/searchModule.js"></script>
<script src="/resources/js/alertModule.js"></script>