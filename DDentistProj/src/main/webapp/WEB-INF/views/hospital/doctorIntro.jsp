<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<style>
	/* chatCss */
	#chatButton{
		padding-right:1.25rem;
	}
	.navbar-badge{
		top:5px;
	}
	/* **************************** */
	.overflow-auto::-webkit-scrollbar{
		display: none;
	}

	.empSelect:hover {
		background-color: #E6E6FA !important;
		cursor: pointer;
	}

	.empOver {
		background-color: #E6E6FA !important;
	}

	.empOver2 {
		background-color: #E6E6FA !important;
	}

	.navbar-light .navbar-nav .nav-link {
		color: #f8f9fa;
		margin-left: 0.5rem;
		height: 38px;
		padding: 0.25rem;
		display: flex;
		align-items: center;
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
</style>

<script type="text/javascript">

$(function(){

	$("#selectImage").attr("src", "/resources/images/employee/s_cb8450a3-35e9-44e1-9598-730c60f5cb54_user.png");

	let empNum = ""; //저장 버튼을 누를 때마다 계속 data에 들어와서 전역변수로 선언

	//클릭한 값을 상세정보에 띄운다
	$("#doctorList").on("click", ".empSelect",function(){ //비동기로 처리된 건 바깥에서 값을 가져와야하기 때문에 이렇게 함..

		empNum = $(this).children().eq(0).children().eq(1).val(); //empSelect에서 내가 클릭한 자식의 0번째(td)의 자식인(input type="hidden")의 값을 가져옴
		console.log("::::::::::::::::::::::::: " + empNum);

		let data={"empNum":empNum};

		console.log("---------->:"+empNum);

		$("#empNumHidden").val(empNum);

		$.ajax({
			url:"/hospital/site/doctorIntro/doctorSelect",
			contentType:"application/json;charset:utf-8",
			data:JSON.stringify(data),
			type:"post",
			dataType:"json",
			beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
		        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success:function(result) {

				console.log("결과:"+JSON.stringify(result));
				console.log("result.thumbnail : " + result.thumbnail);

				$("#introNmEn").val(result.introNmEn);
				$("#introSpecialty").val(result.introSpecialty);
				$("#introEducation").val(result.introEducation);
				$("#introContent").val(result.introContent);
// 				$("#selectImage").val(result.thumbnail);
				if(result.thumbnail == ""||result.thumbnail == null) {
					$("#selectImage").attr("src",'/resources/images/employee/s_cb8450a3-35e9-44e1-9598-730c60f5cb54_user.png');
				} else {
					$("#selectImage").attr("src",result.thumbnail);
				}
			}
		});
	});

	//save 시작
		$("#save").on("click",function(){

			if(empNum == ""){
				simpleErrorAlert("의사를 선택해주세요");
			}
			console.log("save버튼 눌림");
			let introNmEn=$("#introNmEn").val();	//영문명
			let introSpecialty=$("#introSpecialty").val();	//전문분야
			let introContent=$("#introContent").val(); //의사 소개
			let introEducation=$("#introEducation").val();	//학력 및 경력
			let selectImage = $("#selectImage").attr("src");

			if(selectImage==null || selectImage ==''){
				console.log("selectImage가 null이다!!!!!!!!!!!!!!!!!!")
				return false;
			}else{
				console.log("selectImage >>>>>> "+ selectImage);
			}
			console.log("introNmEn ::: " , introNmEn);
			console.log("introSpecialty ::: " , introSpecialty);
			console.log("introContent ::: " , introContent);
			console.log("introEducation ::: " , introEducation);
			console.log("empNum : " + empNum);
			console.log("selectImage : " + selectImage);


			let frm = document.querySelector("#doctorMainForm");
			let formData = new FormData(frm);

			formData.append("introContent", introContent);
			formData.append("introEducation", introEducation);

			console.log("formData ::::: ", formData);

			$.ajax({
				url:"/hospital/site/doctorIntro/doctorSave",
				processData : false,
				contentType : false,
				data: formData,
				type:"post",
				dataType:"json",
				beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
			        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
				},
				success:function(result) {
					simpleSuccessAlert("저장 완료");
					//결과:{"introNum":6,"empNum":"230313006","introContent":"의사 소개","introSpecialty":"전문분야","introNmEn":"asdf"
						//,"introEducation":"학력 및 경력"
						//,"thumbnail":"/resources/images/doctorIntro/2023/03/23/s_586c0d12-1f64-4e12-9654-b787c2764bfb_사진2.jpg"
						//,"nodata":null,"uploadFile":null,"file":null}
					console.log("결과:"+JSON.stringify(result));
					//result.thumbnail : /resources/images/doctorIntro/2023/03/23/s_586c0d12-1f64-4e12-9654-b787c2764bfb_사진2.jpg
					console.log("result.thumbnail : " + result.thumbnail);

					$("#introNmEn").val(result.introNmEn);
					$("#introSpecialty").val(result.introSpecialty);
					$("#introEducation").val(result.introEducation);
					$("#introContent").val(result.introContent);
					$("#selectImage").val(result.thumbnail); //selectImage에  value값이 없음
// 					if(result.thumbnail == "" || result.thumbnail == null) {
// 						$("#selectImage").attr("src",'/resources/images/employee/s_cb8450a3-35e9-44e1-9598-730c60f5cb54_user.png');
// 						//굳이 바꿀 필요가 없기 때문에 save에서는 attr을 쓰지 않음
// 					} else {
// 						$("#selectImage").attr("src",result.thumbnail);
// 					}
				}
			});	//ajax 끝

		});	//save 끝

		//이미지 미리보기 시작
		$("#uploadFile").on("change", handleImgFileSelect);

		function handleImgFileSelect(event){  //change된 event가 따라온다.
			let files = event.target.files; //파일이 1개든 여러개든 파일을 가져온다.
			let fileArr = Array.prototype.slice.call(files); //배열형태로 저장한다.
			fileArr.forEach(function(f){
				if(!f.type.match("image.*")){
					simpleErrorAlert("이미지만 가능합니다.");
					return;
				}

				let reader = new FileReader();
				reader.onload = function(event){
					$("#selectImage").attr("src",event.target.result);
				}
				reader.readAsDataURL(f);
			});
		}
		//이미지 미리보기 끝

	//의사 검색
	$("#list").on("click",function(){

	let keyword=$("#keyword").val();

	$.ajax({
		url: "/hospital/site/doctorIntro/doctorSearch?keyword="+keyword,
		contentType:"application/json;charset=utf-8",
		type:"get",
		dataType:"json",
		success:function(result){
			let str="";

			if(result.length == 0){
				str +="<tr><td colspan='3' style='text-align:center;'>해당하는 의사가 없습니다.</td></tr>";
				$("#doctorList").html(str);
				return;
			}

			$.each(result,function(index,EmployeeVO) {
				console.log("dasdf>>>>>>>>"+(EmployeeVO.empNum).length);
				str += "<tr class='empSelect'>";
				str += "<td>";
				str +="<input type='text' class='empNum' name='empNum' value='" + EmployeeVO.empNum +"' style='border: none;text-align:center;outline: none;' readonly='readonly' />";
				str +="<input type='hidden' class='empNum' name='empNum' value='" + EmployeeVO.empNum + "' />";
				str += "</td>";
				str += "<td>";
				str += EmployeeVO.empNm;
				str += "</td>";
				str += "</tr>";
			});

            $("#doctorList").html(str);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});
});

//	$(".empSelect").hover(function(){ //검색하면 새로 리스트를 만들어주는거라 각각 따로 해줘야 한다
	$("#doctorList").on("mouseover", ".empSelect", function(){ //마우스 올렸을 때
		var empNum = $(this).find(".empNum");
		empNum.addClass("empOver");
	});

	$("#doctorList").on("mouseout", ".empSelect", function(){ //마우스 내렸을 때
		var empNum = $(this).find(".empNum");
		empNum.removeClass("empOver");
	});

	$("#doctorList").on("click", ".empSelect",function(){
	//마우스 올렸을 때  js처리 시작, input type text때문에 다른 색깔은 안 됨
	$("#doctorList .empSelect").removeClass("empOver2");
	$(".empNum").removeClass("empOver2");

	$(this).addClass("empOver2");
	var empNum = $(this).find(".empNum");
	empNum.addClass("empOver2");
	//마우스 올렸을 때  jsp처리 끝
	});

// 	$(".empSelect").hover(function(){
// 		var empNum = $(this).find(".empNum");
// 		$(this).css("background-color","#E6E6FA");
// 		empNum.css("background-color","#E6E6FA");
// 	},function(){
// 		var empNum = $(this).children().eq(0).children();
// 		$(this).css("background-color","white");
// 		empNum.css("background-color","white");
// 	});

// 	$(".empSelect").on("click",function(){
// 		console.log("누름");
// 		$(".empSelect").addClass("tdCss");

// 		$(".empSelect").css("background-color","white");
// 		$(this).css("background-color","#E6E6FA").addClass;

// 	});


});

</script>


<div class="content-wrapper" style="background-color: rgb(101, 125, 150); min-height: 873px;">
	<nav class="navbar navbar-expand navbar-white navbar-light" style="background-color: #404b57;">
	<div class="input-group" style="width:65%;">
		<div class="dropdown">
			<!-------------------- 검색대 -------------------->
			<input type="text" class="form-control" id="keyword" name="keyword" placeholder="의사 검색" style="width: 400px;">
			<ul id="ptSearchDropdown" class="dropdown-menu">
			</ul>
			<!-------------------- 검색대 -------------------->
		</div>
		<div class="input-group-append">
			<button type="button" class="btn btn-outline-light" id="list" name="list">검색</button>
<!-- 		<button type="button" class="btn btn-md btn-default" id="list" name="list" ><i class="fas fa-fw fa-search"></i></button> -->
		</div>
	</div>
	<ul class="navbar-nav ml-auto"></ul>
		<div class="menu">
			<ul class="navbar-nav mb-0">
				<li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/communityInfo">커뮤니티 관리</a></li>
            	<li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/bannerInfo">배너 관리</a></li>
            	<li class="nav-item"><a class="nav-link btn btn-outline-light active" href="/hospital/site/doctorIntro">의사 소개 관리</a></li>
            	<li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/faqInfo">자주 묻는 질문 관리</a></li>
			</ul>
		</div>
	</nav>

	<section class="content" style="margin-top: 1%;">
	<div class="row">
		<div class="col-md-4">
				<div class="card card-info" style="height:800px;">

					<div class="card-header" style="background-color: #404b57; border: none;">
						<div class="d-flex justify-content-between align-items-center">
							<h2 class="card-title">의사 목록</h2>
						</div>
					</div>

					<div class="card-body overflow-auto">
						<form action="/hospital/site/doctorSelect" method="post">
						<table class="table table-bordered">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<thead style="text-align:center; font-family: 'Noto Sans KR', sans-serif; font-weight:700;">
							<tr>
								<th class="p-3">직원번호</th>
								<th class="p-3">의사명</th>
							</tr>
							</thead>
							<tbody style="font-family: 'Noto Sans KR', sans-serif; font-weight:500; text-align:center;" id="doctorList">
								<c:forEach items="${doctorList}" var="list">
		                   		 	<tr class="empSelect">
			                   		 	<td>
				                   		 	<input type="text" class="empNum" name="empNum" value="${list.empNum}" style="border: none;  text-align:center; outline: none;" readonly />
				                   		 	<input type="hidden" class="empNum" name="empNum" value="${list.empNum}" />
			                   		 	</td>
			                   		 	<td>${list.empNm}</td>
		                   		 	</tr>
		                   		</c:forEach>
							</tbody>
						</table>
					</form>
				</div>
			</div>
		</div>

		<div class="col-md-4">
		<form action="/hospital/site/doctorIntro/doctorSave" method="post" id="doctorMainForm" name="doctorMainForm" enctype="multipart/form-data">
			<input type="hidden" name="empNum" id="empNumHidden"/>
				<div class="card card-info" style="height:800px;">
					<div class="card-header" style="background-color: #404b57; border: none;">
						<div class="d-flex justify-content-between align-items-center">
							<h2 class="card-title">프로필</h2>
						</div>
					</div>
					<div class="card-body">
						<!-- 파일 업로드 시작 -->
							<div class="col-md-12 bg-register-image" style="margin-top: 2%;text-align: center;" >
								<img class="profile-user-img img-circle" src=""
									id="selectImage" name="selectImage" style="height: 300px; width: 300px; margin-bottom: 4%;border: 1px;">
								<input type="file" class="d-none" id="input_imgs" name="file" />
							</div>
							<div class="imgs_wrap"></div>
							<div class="col-md-8" style="margin: 0 auto;text-align: center;">
								<div class="input-group">
									<div class="custom-file">
										<label class="custom-file-label" id="input_imgs" for="uploadFile" style="text-align: left;">이미지를 선택해주세요</label>
										<input type="file" class="custom-file-input" id="uploadFile" name="uploadFile">
									</div>
								</div>
							</div>
						<!-- 파일 업로드 끝 -->
					<div class="form-group" style="margin-top: 8%;">
						<label>영문명</label>
						<div class="input-group">
							<div class="input-group-prepend"></div>
							<input type="text" class="form-control" id="introNmEn" name="introNmEn">
						</div>
					</div>
					<br/>
					<div class="form-group">
						<label>전문분야</label>
						<div class="input-group">
							<div class="input-group-prepend"></div>
							<input type="text" class="form-control" id="introSpecialty" name="introSpecialty">
						</div>
					</div>
						<button type="button" class="btn btn-secondary btnCss violetBtn" id="save" style="float:right; margin-top: 8%">저장</button>
					</div>
				</div>
		</form>
		</div>

		<div class="col-md-4">
			<div class="card card-info" style="height:385px;">
				<div class="card-header" style="background-color: #404b57; border: none;">
					<div class="d-flex justify-content-between align-items-center">
						<h2 class="card-title">의사 소개</h2>
					</div>
				</div>
				<div class="card-body">
					<div class="form-group">
						<div class="ability">
							<div class="input-group-prepend"></div>
							<textarea name="introContent" class="form-control" id="introContent" style="resize: none;height: 300px;"></textarea>
						</div>
					</div>
				</div>
			</div>

			<div class="card card-info" style="height:400px;">
				<div class="card-header" style="background-color: #404b57; border: none;">
					<div class="d-flex justify-content-between align-items-center">
						<h2 class="card-title">학력 및 경력</h2>
					</div>
				</div>
				<div class="card-body">
					<div class="form-group">
						<div class="career">
							<div class="input-group-prepend"></div>
							<textarea name="introEducation" class="form-control" id="introEducation" style="resize: none;height: 310px;"></textarea>
						</div>
					</div>
				</div>
			</div>
		</div>


	</div>
	</section>
</div>

<script src="/resources/js/alertModule.js"></script>