<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<style>

h6 {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
	font-size: 14px;
	margin-left: 50px;
}

/* button css */
.resvBtn {
	border: none;
	display: flex;
	justify-content: center;
	align-items: center;
	margin: auto;
	margin-top: 50px;
	margin-bottom: 50px;
	width: 150px;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
}

.certificationBtn, .certChkBtn {
	background-color: #904aff;
	border: none;
	border-radius: 50px;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
}
</style>


<sec:authorize access="hasRole('ROLE_PT')">
	<sec:authentication var="ptInfo" property="principal.ptVO" />
	<script>
		window.onload = function () {
			document.authForm.action = '/ddit/resv/listPresv';
			document.authForm.ptNm.readOnly = true;
			document.authForm.ptRrno1.readOnly = true;
			document.querySelector('#certificationBtn').dataset.href = '/ddit/resv/sendMAuthNum';
		}
	</script>
</sec:authorize>
<!-- Head Image 시작 -->
<div class="boardHeadImage">
	<div class="wrapper">
		<div class="slide">
			<img src="/resources/images/layout/ddit/resvChkHeadImage.png" />
		</div>
	</div>
</div>
<!-- Head Image 끝 -->
<!-- main section 시작 -->
<section class="container">
	<!-- 내 예약조회 nav 시작 -->
	<div class="row" style="margin-left: 7%; margin-top: 50px; width: 85%; height: 100px; border-top: 1px solid gray; border-bottom: 1px solid gray;">
		<div class="col-12">
			<h4 style="margin-left: 50px; margin-top: 20px; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">내 예약조회</h4>
		</div>
		<div class="col-6">
			<h6 style="opacity: 0.5;">home > 예약 / 조회 > 내 예약조회</h6>
		</div>
	</div>
	<!-- 내 예약조회 nav 끝 -->
	<div style="margin-left: 7%; width: 85%; margin-top: 30px;">
		<form name="authForm" action="/ddit/resv/listNonPresv" method="post" onsubmit="return validation();">
			<div class="row mb-3" style="padding-bottom: 30px;">
				<div class="col-sm-2"></div>
				<label for="ptNm" class="col-sm-1 col-form-label"><span style="color: red;">*</span>이름</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="ptNm" name="ptNm" value="${ptInfo.ptNm}" onkeyup="ptNmCheck(this);" required />
				</div>
				<div class="col-sm-3"></div>
			</div>
			<div class="row mb-3" style="padding-bottom: 30px;">
				<div class="col-sm-1"></div>
				<label for="ptRrno1" class="col-sm-2 col-form-label" style="padding-left: 70px;">
					<span style="color: red;">*</span>주민등록번호
				</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="ptRrno1" name="ptRrno1" value="${fn:substring(ptInfo.ptRrno, 0, 6)}" maxlength="6" onkeyup="ptRrnoFrontCheck(this);" required />
				</div>
				<span style="width: 10px; text-align: center;">-</span>
				<div class="col-sm-2">
					<input type="password" class="form-control" id="ptRrno2" name="ptRrno2" maxlength="7" onkeyup="ptRrnoBackCheck(this);" required>
				</div>
				<div class="col-sm-2"></div>
			</div>
			<div class="row mb-3" style="padding-bottom: 30px;">
				<div class="col-sm-2"></div>
				<label for="ptPhone1" class="col-sm-1 col-form-label"><span style="color: red;">*</span> 연락처</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="ptPhone1" name="ptPhone1" maxlength="3" onkeyup="ptPhone1Check(this);" required>
				</div>
				<span style="width: 10px; text-align: center;">-</span>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="ptPhone2" name="ptPhone2" maxlength="4" onkeyup="ptPhone2Check(this);" required>
				</div>
				<span style="width: 10px; text-align: center;">-</span>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="ptPhone3" name="ptPhone3" maxlength="4" onkeyup="ptPhone3Check(this);" required>
				</div>
				<div class="col-sm-2">
					<input type="button" value="인증번호 받기" id="certificationBtn" class="btn btn-primary certificationBtn" data-href="/ddit/resv/sendNmAuthNum" />
				</div>
			</div>

			<div class="row mb-3 certificationText" style="display: none; padding-bottom: 30px;">
				<div class="col-sm-1"></div>
				<label for="certification" class="col-sm-2 col-form-label" style="padding-left: 90px;"><span style="color: red;">*</span> 인증번호</label>
				<div class="col-sm-4">
					<input type="text" class="form-control" id="certification" required>
				</div>
				<div class="col-sm-2">
					<input type="button" value="인증번호 확인" id="certChkBtn" class="btn btn-primary certChkBtn" />
				</div>
			</div>
			<sec:csrfInput />
			<!-- 인증번호 확인을 눌러서 일치하면 disabled가 사라지도록한다. -->
			<button type="submit" class="btn btn-primary btn-lg resvBtn" style="background-color: #404b57;" disabled>다음으로</button>
		</form>
	</div>


</section>
<!-- main section 끝 -->
<script>

// CSRF 토큰
csrfToken = $('#_csrfToken').val();

//인증번호 받기 버튼 클릭시
$("#certificationBtn").on("click",function(){
	
	const ptNm = $('#ptNm').val();
	if(!ptNm.match(/^[가-힣]{2,5}$/g)){
		alert('이름을 확인해주세요.');
		return false;
	}
	
	const ptRrno = $('#ptRrno1').val() + $('#ptRrno2').val();
	if(!ptRrno.match(/^[\d]{13}$/g)){
		alert('주민등록번호를 확인해주세요.');
		return false;
	}
	
	const ptPhone1 = $('#ptPhone1').val();
	const ptPhone2 = $('#ptPhone2').val();
	const ptPhone3 = $('#ptPhone3').val();
	if(ptPhone1 == '' || ptPhone2 == '' || ptPhone3 == ''){
		alert('연락처를 입력해주세요.');
		return false;
	}
	
	const ptPhone = ptPhone1 + ptPhone2 + ptPhone3;
	if(!ptPhone.match(/^[\d]{9,11}$/g)){
		alert('연락처를 확인해주세요.');
		return false;
	}
	
	const authHref = $(this).data('href');
	
	fetch(authHref, {
		method: 'post',
		headers: {
			'X-CSRF-TOKEN' : csrfToken,
			'Content-Type' : 'application/json;charset=utf-8'
		},
		body: JSON.stringify({
			ptNm : ptNm,
			ptRrno : ptRrno,
			ptPhone : ptPhone
		})
	})
		.then(res => {
			if(!res.ok) throw new Error();
			return res.text();
		})
		.then(text => {
			if(text == 'FAILED') throw new Error();
			if(text == 'NONE'){
				alert('일치하는 정보가 없습니다.');
				return false;
			}
			
			alert('인증번호가 발송되었습니다.');
			$(".certificationText").show();
		})
		.catch(() => {
			alert('잠시 후 다시 시도해주세요.');
		});
	
});

// 인증번호 확인 버튼 클릭 후 일치하면..
$("#certChkBtn").on("click",function(){
	
	const authNum = $('#certification').val();
	
	fetch('/ddit/resv/checkAuthNum', {
		method: 'post',
		headers: {
			'X-CSRF-TOKEN' : csrfToken,
			'Content-Type' : 'application/json;charset=utf-8'
		},
		body: JSON.stringify({
			authNum : authNum
		})
	})
		.then(res => {
			if(!res.ok) throw new Error();
			return res.text();
		})
		.then(text => {
			regCheck($('#certification'), text != 'FAILED');
			if(text == 'FAILED') {
				alert('인증번호가 틀립니다.');
				return false;
			}
			
			alert('인증되었습니다.');
			$('#certChkBtn').prop('disabled', true);
			$('#certification').prop('disabled', true);
			$(".resvBtn").removeAttr("disabled");
			$(".resvBtn").css("background-color","#904aff");
		})
		.catch(() => {
			alert('잠시 후 다시 시도해주세요.');
		});
	
});

// 폼 유효성 검사
function validation(){
	
	const authForm = document.authForm;
	if(!authForm.ptNm.value.match(/^[가-힣]{2,5}$/g)){
		alert('이름을 확인해주세요.');
		return false;
	}
	const ptRrno = authForm.ptRrno1.value + authForm.ptRrno2.value;
	if(!ptRrno.match(/^[\d]{13}$/g)){
		alert('주민등록번호를 확인해주세요.');
		return false;
	}
	
	const ptPhone = authForm.ptPhone1.value + authForm.ptPhone2.value + authForm.ptPhone3.value;
	if(!ptPhone.match(/^[\d]{9,11}$/g)){
		alert('연락처를 확인해주세요.');
		return false;
	}
	
	return true;
}

//조건 일치시 체크, 불일치시 경고 색상표시
function regCheck(target, result){
	if(result){	// 일치
		target.removeClass("is-invalid");
		target.addClass("is-valid");
	} else {	// 불일치
		target.addClass("is-invalid");
		target.removeClass("is-valid");
	}
};

// 이름 체크
function ptNmCheck(info){
	const ptNm = $("#ptNm");
	const result = info.value.match(/^[가-힣]{2,5}$/g);
	regCheck(ptNm, result);
};
// 주민등록번호 앞자리 체크
function ptRrnoFrontCheck(info){
	const ptRrno1 = $("#ptRrno1");
	const result = info.value.match(/^[\d]{6}$/g);
	regCheck(ptRrno1, result);
}
// 주민등록번호 뒷자리 체크
function ptRrnoBackCheck(info){
	const ptRrno2 = $("#ptRrno2");
	const result = info.value.match(/^[\d]{7}$/g);
	regCheck(ptRrno2, result);
}
// 전화번호 앞자리 체크
function ptPhone1Check(info){
	const ptPhone1 = $("#ptPhone1");
	const result = info.value.match(/^0[\d]{1,2}$/g);
	regCheck(ptPhone1, result);
}
//전화번호 가운데 체크
function ptPhone2Check(info){
	const ptPhone2 = $("#ptPhone2");
	const result = info.value.match(/^[\d]{3,4}$/g);
	regCheck(ptPhone2, result);
}
//전화번호 뒷자리 체크
function ptPhone3Check(info){
	const ptPhone3 = $("#ptPhone3");
	const result = info.value.match(/^[\d]{4}$/g);
	regCheck(ptPhone3, result);
}

</script>