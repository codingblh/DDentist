<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
body {
	font-size: inherit;
}

.cardbodyCss {
/* 	overflow: scroll; */
	height: 440px;
	font-size: 14px;
	overflow-x: hidden;
}

.cardbodyCss::-webkit-scrollbar,
#waitingList::-webkit-scrollbar,
.table-responsive::-webkit-scrollbar {
	width: 10px;
	height: 10px;
}

.cardbodyCss::-webkit-scrollbar-thumb,
#waitingList::-webkit-scrollbar-thumb,
.table-responsive::-webkit-scrollbar-thumb {
	background-color: #404b57;
	border-radius: 5px;
}

.cardbodyCss::-webkit-scrollbar-track,
#waitingList::-webkit-scrollbar-track,
.table-responsive::-webkit-scrollbar-track {
	background-color: rgba(0, 0, 0, 0);
}

.dropdown-item {
	cursor: pointer;
}

#ptDetailCard::-webkit-scrollbar,
.fc-scroller::-webkit-scrollbar {
	display: none;
}

td[data-toggle="dropdown"] {
	cursor: pointer;
}
/* 진료목록 헤더 */
.tableHead {
	position: sticky;
	top: -0.1px;
	background-color: whitesmoke;
}

/* 풀캘린더 적용 이후 */
.form-horizontal {
	height: 144px;
}

.fc-toolbar, .fc-toolbar.fc-header-toolbar{
	padding:0rem;
}
.fc .fc-toolbar.fc-header-toolbar{
	margin-bottom: 0em;
}

/************************
*******풀캘린더 css시작*******
************************/
/* 일요일 날짜 빨간색 */
.fc-day-sun a {
  color: red;
  text-decoration: none;
}

/* 토요일 날짜 파란색 */
.fc-day-sat a {
  color: blue;
  text-decoration: none;
}

/* 커스텀 버튼 css !important 사용보다 정확한 경로 설정  */
.fc-header-toolbar .fc-addEvent-button {
	background-color: #a0a0a0;
	border : 1px solid #a0a0a0;
}

/* 이벤트 범위 벗어나지 않게 */
.fc-event-main{
	overflow:hidden;
}

/* 모달 css */
#resvInfoModal .row .col div{
	border : 1px solid black;
}

.input-modal option:hover {
    box-shadow: 0 0 10px 100px #D2D2FF inset;
}

.error-modal{
	color : red;
	visibility: hidden;
}

.error {
	visibility : visible;
}

.select-inactivate {
	pointer-events : none;
	background-color : purple;
	background-color : rgba(0,0,0,0.2);
	text-decoration  :solid line-through red 3px;
}

/* 영업시간 외 */
.fc-businesshour {
	background-color : #c0c0c0;
	opacity : 0.7;
}

.non-compliance {
	text-decoration-line : line-through;
}

/* 경과 시간 버튼 css */
.resvEt{
	width : 66px;
	margin : 5px;
}
/* 경과 시간 버튼 선택 시 */
.selectResvEt{
    border-radius: 10px;
}
/* 경과버튼 비활성화 */
.nonSelected{
	opacity: 0.6;
 	cursor: not-allowed;
 	box-shadow : none;
}
/************************
*******풀캘린더 css끝*******
************************/
/****** Modal Css ******/
/* label Css */
.labelCss{
	border-left: 3px solid #ff3e3e;
    padding-left: 10px;
}
/* Modal-footer */
.modal-footer{
	border-top:none;
	font-family: 'Noto Sans KR', sans-serif;
    font-weight: 500;
    margin: auto;
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

.crossBtn{
	border-radius:30px;
	border:2px solid white;
	width:35px;
	height:35px;
	text-align:center;
	background:#404b57;
	color:white;
	padding:7px;
	margin-left:10px;

}

.crossBtn:hover{
	border:2px solid #FF5252;
	color:#FF5252 !important;
	animation: vibrate-1 0.3s linear infinite both;
}

.violetBtn:hover{
	background-color:#7c3dde !important;
}

.redBtn:hover{
	background-color:#e13636 !important;
}

/* Medical Alerts */
.medicalAlertFlow {
	animation: textLoop 10s linear infinite;
	padding-left: 0.5rem;
	padding-right: 0.5rem;
}

@keyframes textLoop {
	0% {
		-webkit-transform: translate3d(0, 0, 0);
		transform: translate3d(0, 0, 0);
	}
	100% {
		-webkit-transform: translate3d(-100%, 0, 0);
		transform: translate3d(-100%, 0, 0);
	}
}
/* chatCss */
#chatButton{
	padding-right:1.25rem;
}
.navbar-badge{
	top:5px;
}
</style>

<div class="content-wrapper" style="background-color: #657D96;">
	<!-- main 검색창을 포함한 navbar 시작-->
	<nav class="navbar navbar-expand navbar-white navbar-light"
		style="background-color: #404b57;">

		<div class="dropdown">
			<!-- 환자 검색 시작 -->
			<input type="text" class="form-control" id="ptSearch"
				placeholder="환자 검색" onkeyup="searchPatient(this);"
				style="width: 400px; display:inline-block;" autocomplete="off" />
			<ul id="ptSearchDropdown" class="dropdown-menu"></ul>
			<!-- 환자 검색 끝 -->

			<!-- 환자 검색 시작 초기화 버튼 -->
			<i class="fa-solid fa-xmark crossBtn" style="cursor: pointer;" onclick="reset();"></i>
		</div>
		<ul class="navbar-nav ml-auto"></ul>
	</nav>
	<!-- main 검색창을 포함한 navbar 끝 -->
	<section class="content" style="margin-top: 1%;">
		<!-- 상단 row 시작 -->
		<div class="row" style="height: 60%;">
			<!-- 좌측 상단 -->
			<div class="col-md-6" style="padding-right: 0px;">
				<div class="card card-info">
					<div class="card-header border-0" style="background-color: #404b57;">
						<div class="d-flex justify-content-between align-items-center">
							<h2 class="card-title">환자 정보</h2>
							<div>
								<button type="button" class="btn btn-info btnCss violetBtn"
									style="background-color: #904aff; border:none;"
									onclick="resetForm();">신환등록</button>
								<button type="button" class="btn btn-warning btnCss redBtn"
									style="color: white; border: none; background-color: #ff5252;"
									onclick="deletePatientAlert();">환자삭제</button>
								<button type="button" class="btn btn-success"
									style="border: none; font-family: 'Noto Sans KR', sans-serif; font-weight: 500;"
									onclick="inputTestPtData();">시연용</button>
							</div>
						</div>
					</div>
					<form name="patientForm" action="/hospital/desk/insertPatient">
						<div class="card-body" style="height: 440px;">
							<div class="form-group row">
								<label for="ptNum" class="col-sm-2 col-form-label">차트번호</label>
								<input type="text" class="col-sm-2 form-control" name="ptNum"
									readonly />
								<div class="col-sm-2 pr-0">
									<input type="text" class="form-control" name="ptGen" readonly />
								</div>
								<label for="ptZip" class="col-sm-2 col-form-label">우편번호</label>
								<div class="col-sm-2">
									<input type="text" class="form-control" name="ptZip" readonly />
								</div>
								<div class="col-sm-2">
									<button type="button" class="btn btn-success btn-block btnCss violetBtn"
										style="background-color: #904aff; border: none; height: 100%;"
										onclick="openHomeSearch();">주소검색</button>
								</div>
							</div>
							<div class="form-group row">
								<label for="name" class="col-sm-2 col-form-label">이름</label> <input
									type="text" class="col-sm-4 form-control" name="ptNm" /> <label
									for="ptAddr" class="col-sm-2 col-form-label">주소</label>
								<div class="col-sm-4">
									<input type="text" class="form-control" name="ptAddr" readonly />
								</div>
							</div>
							<div class="form-group row">
								<label for="ptBir" class="col-sm-2 col-form-label">생년월일</label>
								<input type="text" class="col-sm-4 form-control" name="ptBrdt"
									readonly /> <label for="ptAddrDet"
									class="col-sm-2 col-form-label">상세주소</label>
								<div class="col-sm-4">
									<input type="text" class="form-control" name="ptAddrDet" />
								</div>
							</div>
							<div class="form-group row">
								<label for="ptRrn" class="col-sm-2 col-form-label">주민등록번호</label>
								<div class="col-sm-4">
									<div class="row">
										<div class="col-sm-5 p-0">
											<input type="text" class="form-control" name="ptRrno1" maxlength="6" />
										</div>
										<div class="col-sm-2 p-0 text-center">
											<span class="align-middle">-</span>
										</div>
										<div class="col-sm-5 p-0">
											<input type="text" class="form-control" name="ptRrno2" maxlength="7" />
										</div>
									</div>
								</div>
								<label for="dentist" class="col-sm-2 col-form-label">의사/체어</label>
								<div class="col-sm-4">
									<div class="row">
										<div class="col-sm-6">
											<select id="regDoc" class="custom-select rounded-10">
												<c:forEach var="emp" items="${requestScope.empList}">
													<option value="${emp.empNum}">${emp.empNm}</option>
												</c:forEach>
											</select>
										</div>
										<div class="col-sm-6">
											<select id="chairNum" class="custom-select rounded-10">
												<c:forEach var="chair" items="${requestScope.chairList}">
													<option value="${chair.chairSn}">${chair.chairNm}</option>
												</c:forEach>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label for="ptPhone" class="col-sm-2 col-form-label">연락처</label>
								<div class="col-sm-4">
									<div class="row">
										<input type="text" class="col-sm-3 form-control"
											name="ptPhone1" maxlength="3">
										<div class="col-sm-1 p-0 text-center">
											<span class="align-middle">-</span>
										</div>
										<input type="text" class="col-sm-3 form-control"
											name="ptPhone2" maxlength="4">
										<div class="col-sm-1 p-0 text-center">
											<span class="align-middle">-</span>
										</div>
										<input type="text" class="col-sm-4 form-control"
											name="ptPhone3" maxlength="4">
									</div>
								</div>
								<div class="col-sm-2"></div>
								<div class="col-sm-4">
									<div class="form-check">
										<input type="checkbox" id="prvcPvsnAgreYn" name="prvcPvsnAgreYn" value="Y" />
										<label for="prvcPvsnAgreYn" class="form-check-label">개인정보제공 동의</label>
									</div>
									<div class="form-check">
										<input type="checkbox" id="smsRcptnAgreYn" name="smsRcptnAgreYn" value="Y" />
										<label for="smsRcptnAgreYn" class="form-check-label">문자수신동의</label>
									</div>
								</div>
							</div>

							<!-- medical alert(기저질환) -->
							<div class="form-group row">
								<div class="input-group">
									<label for="disNM" class="col-sm-2 col-form-label">기저질환</label>
									<div class="col-sm-5 p-0">
										<div class="row">
											<div class="col-sm-3 pr-0">
												<button type="button"
													class="btn btn-danger btnCss btn-block redBtn" id="openQuesBtn"
													onclick="selectQue();"
													style="background-color: #ff5252; height: 100%; border:none;" disabled>수정</button>
											</div>
											<div class="col-sm-9">
												<div class="w-100 h-100 d-flex align-items-center overflow-hidden text-nowrap">
													<div class="medicalAlertFlow"></div>
													<div class="medicalAlertFlow"></div>
													<div class="medicalAlertFlow"></div>
													<div class="medicalAlertFlow"></div>
												</div>
											</div>
										</div>
									</div>
									<div class="offset-sm-1 col-sm-4">
										<div class="form-check">
											<input type="checkbox" id="ptPregYn" name="ptPregYn" value="Y">
											<label for="ptPregYn" class="form-check-label">임신중</label>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="d-flex justify-content-end align-items-center">
									<button type="button" class="btn btn-success btnCss violetBtn"
										style="background-color: #904aff; border: none; width: 10%;"
										onclick="insertPatient();">저장</button>
									<button type="button" class="btn btn-success btnCss ml-1 violetBtn"
										style="background-color: #904aff; border: none; width: 10%;"
										onclick="insertRegist();">접수</button>
								</div>
							</div>

						</div>

					</form>
				</div>
			</div>

			<!-- 오른쪽 상단 -->
			<div class="col-md-6">
				<div class="card card-primary">
					<div class="card-header border-0" style="background-color: #404b57;">
						<div class="d-flex justify-content-between align-items-center">
							<h2 class="card-title">예약 현황</h2>
							<div>
								<button type="button" class="btn btn-info btnCss violetBtn" style="background-color: #904aff; border: #904aff;" id="newResv">예약</button>
							</div>
						</div>
					</div>
					<div class="card-body cardbodyCss">
						<div id="deskCalendar"></div>

						<!-- 미완성 -->
						<div style="display: none;">
							<label for="calendar_view">예약 현황</label>
							<div class="input-group">
								<select class="filter" id="type_filter" multiple="multiple">
									<option value="카테고리1">카테고리1</option>
								</select>
							</div>
							<label for="calendar_view">의사 목록</label> <label
								class="checkbox-inline"
								style="display: inline-block; width: 100px;"> <input
								class="" id="allCheck" type="checkbox" value="all" checked>전체선택
							</label>
							<div class="input-group" id='doctor'></div>
						</div>
						<!-- 미완성 -->

					</div>
				</div>
			</div>
		</div>

		<!-- 예약 추가 모달 시작 -->
		<div class="modal fade" id="resvAddModal" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="addModal" aria-hidden="true">
		  <div class="modal-dialog modal-lg">
		    <div class="modal-content" style="border-radius: 30px;">
		      <div class="modal-header" style="border-bottom: 0px;margin-left: 5%;width: 90%;">
		        <h5 class="modal-title" id="addModal" style="border-left:3px solid #FF5252; padding-left:10px;">Modal title</h5>
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		        </button>
		      </div>
		      <div class="modal-body">
		        <div class="content">
		        	<form id="addForm">
			        	<div class="d-flex justify-content-around">
			        		<div class="col-md-5 card card-outline card-danger">
			        			<label for="ptNm">이름</label>
								<div class="dropdown">
									<div class="input-group">
										<div class="input-group-text"><i class="fa-solid fa-person fa-xl"></i></div>
				        				<input type="text" class="form-control input-reg-modal" onkeyup="resvSearchPatient(this);" id="ptNm" />
				        				<ul id="resvPtSearchDropdown" class="dropdown-menu">
										</ul>
									</div>
			        			</div>
		
			     				<div class="error-modal" id="errPtNm">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;이름형식이 일치하지 않습니다.</div>
			        			<label for="ptPhone">휴대전화</label>
			        			<div class="input-group">
									<div class="input-group-text"><i class="fa-solid fa-phone"></i></div>
				        			<input type="text" class="form-control input-reg-modal" onkeyup="checkPhone(this);" id="ptPhone" />
			        			</div>
			        			<div class="error-modal" id="errPtPhone">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;'-' 없이 숫자만 입력</div>
			        			<div class="d-flex justify-content-between">
				        			<label for="resvCc">호소 증상(c.c)</label>
				        			<div><span id="resvCc_lenght">0</span> / 300</div>
				        		</div>
			        			<div class="input-group">
									<div class="input-group-text"><i class="fa-regular fa-circle-question"></i></div>
				        			<textarea class="form-control input-modal" id="resvCc" rows="9" maxlength="300" onkeyup="resvCc_checkByte(this);" placeholder="증상을 입력해주세요"></textarea>
			        			</div>
			        		</div>
			        		<div class="col-xl-5 card card-outline card-danger">
			        			<label for="resvDate">진료 날짜</label>
			        			<div class="input-group">
									<div class="input-group-text"><i class="fa fa-calendar"></i></div>
									<input type="date" class="form-control input-modal datepicker" id="resvDate" />
								</div>
								<div class="error-modal" id="errResvDate">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;선택 불가능한 날짜입니다.</div>
			        			<label>진료 시작 시간</label>
			        			<div class="input-group">
									<div class="input-group-text"><i class="fa-regular fa-clock"></i></div>
									<select class="slier form-control input-modal" id="resvStartTime" onfocus="this.size=4;" onblur='this.size=1;' onchange='this.size=1; this.blur();'>
										<option>option 1</option>
										<option>option 2</option>
									</select>
								</div>
								<br />
								<label>경과 시간</label>
			        			<div class="input-group">
									<button type="button" class="btn-info resvEt" value="30">30분</button>
									<button type="button" class="btn-info resvEt" value="60">60분</button>
									<button type="button" class="btn-info resvEt" value="90">90분</button>
									<button type="button" class="btn-info resvEt" value="120">120분</button>
								</div>
								<br />
			        			<label>의사 선택</label>
			        			<div class="input-group">
									<div class="input-group-text"><i class="fa-solid fa-user-doctor"></i></div>
									<select class="slier form-control input-modal"  id="empNum" onfocus="this.size=4;" onblur='this.size=1;' onchange='this.size=1; this.blur();'>
										<option>option 1</option>
										<option>option 2</option>
									</select>
								</div>
			        		</div>
			        	</div>
		        	</form>
		        </div>
		      </div>
		      <div class="modal-footer" style="border-top: none; margin: auto;">
			      <button type="button" class="btn btn-danger redBtn" id="save-event" style="width: 150px; border: none; font-family: 'Noto Sans KR', sans-serif; font-weight: 500;">저장</button>
			      <button type="button" class="btn btn-outline-secondary" style="width: 150px; border: none; font-family: 'Noto Sans KR', sans-serif; font-weight: 500;" data-dismiss="modal">닫기</button>
			      <button type="button" class="btn btn-success" style="width: 150px; border: none; font-family: 'Noto Sans KR', sans-serif; font-weight: 500;" onclick="inputTestResvData();">시연용</button>
		      </div>
		    </div>
		  </div>
		</div>
		<!-- 예약 추가 모달 끝 -->
		
		
		<!-- 예약정보 모달 -->
		<div class="modal fade" id="resvInfoModal" tabindex="-1" aria-labelledby="infoModal" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title" id="infoModal">Modal title</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" id="infoModalClose">
		          			<span aria-hidden="true">&times;</span>
		        		</button>
		      		</div>
			     	<div class="modal-body">
			      		<div class="row">
			      			<div class="col-sm-12 card">
		      					<div class="card-body">
					      			<div class="text-center"><h5>환자 정보</h5></div>
					      			<hr />
					      			<div class="row">
						        		<div class="col-3">
						        			<label>이름</label>
						        		</div>
						        		<div class="col-9 resv-info" id="ptNumDiv"></div>
					        		</div>
						      		<div class="row">
							       		<div class="col-3">
							       			<label>전화번호</label>
							       		</div>
							       		<div class="col-9 resv-info" id="ptPhoneDiv"></div>
							       	</div>
						      		<div class="row">
						       			<div class="col-3">
							       			<label>호소 증상</label>
							       		</div>
							       		<div class="col-9 resv-info" id="resvCcDiv"></div>
							       	</div>
							 	</div>
				      		</div>
				      	</div>
			          	<br>
			        	<div class="row">
			        		<div class="col-sm-12 card">
								<div class="card-body">
				        			<div class="text-center"><h4>예약 정보</h4></div>
				        			<hr />
					        		<div class="row">
						        		<div class="col-sm-3">
						        			<label>의사</label>
						        		</div>
						        		<div class="col-sm-9 resv-info" id="empNumDiv"></div>
						        	</div>
					        		<div class="row">
						        		<div class="col-sm-3">
						        			<label>일시</label>
						        		</div>
						        		<div class="col-sm-4 resv-info" id="resvDateDiv"></div>
						        		<div class="col-sm-5 resv-info" id="resvTimeDiv"></div>
						        	</div>
						        	<div class="row">
						        		<div class="col-sm-3">
						        			<label>구분</label>
						        		</div>
						        		<div class="col-sm-5 resv-info" id="resvStatusDiv"></div>
						        	</div>
				        		</div>
					        </div>
				      	</div>
				 	</div>
			      	<div class="modal-footer">
					    <button type="button" class="btn btn-default" data-dismiss="modal" id='modalClose'>닫기</button>
					    <!-- 예약중일경우  -->
					    <button type="button" class="btn btn-primary" id="implResv" value="IMPL_RESV">예약 이행</button>
					    <button type="button" class="btn btn-danger" id="cancelResv" value='CANCEL_RESV'>예약 취소</button>
						<!-- 예약 이행중일 경우  -->
					    <button type="button" class="btn btn-warning" id="inResv" value='IN_RESV'>예약 이행 취소</button>
			  		</div>
		  	 	</div>
			</div>
		</div>
		<!-- 에약 정보 모달 끝 -->

		<!-- 상단 row 끝 -->



		<!-- 하단 row 시작 -->
		<div class="row">
			<!-- 하단 좌측  C.C & 메모 시작 -->
			<div class="col-md-2 pr-0">
				<div class="card card-info">
					<div class="card-header" style="background-color: #404b57;">
						<h3 class="card-title">C.C</h3>
					</div>
					<form class="form-horizontal">
						<div class="card-body" style="border-bottom: 20px;">
							<div class="form-group row">
								<textarea id="regCc" class="form-control" rows="3"
									placeholder="C.C"></textarea>
							</div>
						</div>
					</form>
				</div>

				<div class="card card-info">
					<div class="card-header" style="background-color: #404b57;">
						<h3 class="card-title">메모</h3>
					</div>
					<form class="form-horizontal">
						<div class="card-body" style="border-bottom: 20px;">
							<div class="form-group row">
								<textarea class="form-control" rows="3" id="ptMemo"
									placeholder="메모"></textarea>
							</div>
						</div>
					</form>
				</div>
				<!-- 하단 좌측  C.C & 메모 끝 -->
			</div>

			<!-- tab을 포함한 card(가족,진료,수납) 시작 -->
			<div class="col-sm-4 pr-0">
				<div class="card card-primary card-tabs">
					<div class="card-header p-0 pt-1"
						style="background-color: #404b57;">
						<ul class="nav nav-tabs" role="tablist" id="ptDetailTabList">
							<li class="nav-item" role="presentation"><a
								class="nav-link active" data-toggle="pill" href="#familyList"
								role="tab">가족</a></li>
							<li class="nav-item" role="presentation"><a class="nav-link"
								data-toggle="tab" href="#checkupList" role="tab">진료</a></li>
							<li class="nav-item"><a class="nav-link" data-toggle="tab"
								href="#rcvmtList" role="tab">수납</a></li>
						</ul>
					</div>
					<div class="card-body table-responsive p-0" style="height: 350px;">
						<div class="tab-content w-100">
							<div class="tab-pane fade-show active" id="familyList"
								role="tabpanel">
								<div class="row w-100 m-0">
									<div class="col-sm-12 p-0">
										<table class="table table-bordered table-hover text-center">
											<thead class="tableHead" style="z-index: 20;">
												<tr>
													<th style="width: 20%;">순번</th>
													<th style="width: 25%;">이름</th>
													<th style="width: 35%;">차트번호</th>
													<th style="width: 20%;">관계</th>
												</tr>
											</thead>
											<tbody id="familyListBody"></tbody>
										</table>
									</div>
								</div>
								<div class="p-3 d-flex justify-content-end position-absolute"
									style="z-index: 20; bottom: 0;">
									<button type="button" class="btn btn-secondary rounded-pill"
										style="opacity: 70%;" onclick="openfamilyModal();">+</button>
								</div>
							</div>
							<div class="tab-pane fade" id="checkupList" role="tabpanel">
								<div class="row w-100 m-0">
									<div class="col-sm-12 p-0">
										<table class="table table-bordered table-hover text-center">
											<thead class="tableHead">
												<tr>
													<th style="width: 50%;">진료번호</th>
													<th style="width: 25%;">진료일</th>
													<th style="width: 25%;">진료의사</th>
												</tr>
											</thead>
											<tbody id="checkupListBody"></tbody>
										</table>
									</div>
								</div>
							</div>
							<div class="tab-pane fade" id="rcvmtList" role="tabpanel">
								<div class="row w-100 m-0">
									<div class="col-sm-12 p-0">
										<table class="table table-bordered table-hover text-center">
											<thead class="tableHead">
												<tr>
													<th style="width: 40%;">수납번호</th>
													<th style="width: 20%;">수납일</th>
													<th style="width: 20%;">진료비</th>
													<th style="width: 20%;">미수금</th>
												</tr>
											</thead>
											<tbody id="rcvmtListBody"></tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- tab을 포함한 card 끝 -->
			<!-- 진료목록 시작 -->
			<div class="col-sm-6">
				<div class="card">
					<div class="card-header" style="background-color: #404b57;">
						<h3 class="card-title" style="color: white;">접수 목록</h3>
					</div>

					<div class="card-body table-responsive p-0"
						style="height: 350px; border-bottom: 20px;" id="waitingList">
						<div id="example2_wrapper"
							class="dataTables_wrapper dt-bootstrap4" style="width: 1600px;">
							<table class="table table-bordered table-hover text-center" style="width: 1600px;">
								<thead class="tableHead" style="z-index: 20;">
									<tr>
										<th style="width: 5%;"></th>
										<th style="width: 5%;">순번</th>
										<th style="width: 8%;">상태</th>
										<th style="width: 8%;">차트번호</th>
										<th style="width: 9%;">이름</th>
										<th style="width: 10%;">대기시간</th>
										<th style="width: 10%;">접수시간</th>
										<th style="width: 10%;">체어</th>
										<th style="width: 10%;">의사</th>
										<th style="width: 25%;">C.C</th>
									</tr>
								</thead>
								<tbody id="registList">
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- 진료목록 끝 -->
		</div>
		<!-- 하단 row 끝 -->
	</section>
</div>

<!-- 가족관계 추가 모달 -->
<div class="modal fade" id="familyModal" data-backdrop="static"
	data-keyboard="false">
	<div class="modal-dialog modal-lg modal-dialog-centered">
		<div class="modal-content" style="border-radius: 30px;">
			<div class="modal-header" style="border-bottom: 2px solid #FF5252; width: 90%; margin-left: 5%;">
				<h5 class="modal-title" id="familyModalLabel">가족관계 추가</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form name="familyPatientForm" action="/hospital/desk/insertFamily">
					<div class="row">
						<div class="col-sm-6 px-4">
							<div class="form-group mb-3 dropdown">
								<label class="form-label" style="border-left: 3px solid #FF5252; padding-left: 10px;">환자 검색</label> <input type="text"
									id="famPtSearch" class="form-control"
									onkeyup="searchFamPatient(this);" />
								<ul id="famPtSearchDropdown" class="dropdown-menu">
								</ul>
							</div>
							<div class="form-group row m-0">
								<label
									class="form-label col-sm-4 d-flex justify-content-center align-items-center m-0">차트번호</label>
								<input type="text" name="famPtNum"
									class="form-control-plaintext col-sm-8" readonly />
							</div>
							<div class="form-group row m-0">
								<label
									class="form-label col-sm-4 d-flex justify-content-center align-items-center m-0">환자
									명</label> <input type="text" name="famPtNm"
									class="form-control-plaintext col-sm-8" readonly />
							</div>
							<div class="form-group row m-0">
								<label
									class="form-label col-sm-4 d-flex justify-content-center align-items-center m-0">생년월일</label>
								<input type="text" name="famPtBrdt"
									class="form-control-plaintext col-sm-8" readonly />
							</div>
						</div>
						<div class="col-sm-6 px-4">
							<label class="form-label" style="border-left: 3px solid #FF5252; padding-left: 10px;">관계 선택</label> <select
								class="custom-select" name="famRel">
								<c:forEach var="fam" items="${requestScope.familyCodeList}">
									<option value="${fam.commCdNm}">${fam.commCdCnt}</option>
								</c:forEach>
							</select>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger redBtn"
					onclick="insertFamily();" style="background-color:#FF5252; width:120px; border:none;">저장</button>
				<button type="button" class="btn btn-outline-secondary" data-dismiss="modal"
					onclick="resetFamilyModal();" style="width:120px; border:none;">닫기</button>
			</div>
		</div>
	</div>
</div>

<!-- 기저질환 모달 시작 -->
<div class="modal fade" id="queModal" data-backdrop="static"
	data-keyboard="false" tabindex="-1">
	<div class="modal-dialog modal-lg">
		<div class="modal-content" style="border-radius:30px;">
			<div class="modal-header" style="border-bottom: 2px solid #ff3e3e; width: 90%; margin-left: 5%;">
				<h5 class="modal-title" id="queModalLabel">문진표</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:40px 40px;">
				<form name="questionnaireForm" action="/hospital/desk/insertQue">
					<input type="hidden" name="ptNum" />
					<div class="row g-2">
						<div class="form-group col-sm-6">
							<label class="form-label labelCss">내원 이유</label> <input type="text"
								class="form-control" name="queReason" />
						</div>
						<div class="form-group col-sm-6">
							<label class="form-label labelCss">희망 치료 내용</label> <input type="text"
								class="form-control" name="queWant" />
						</div>
					</div>
					<div class="form-group">
						<label class="form-label labelCss">복용 약</label> <input type="text"
							class="form-control" name="quePharm" />
					</div>
					<div>
						<div class="row">
							<div class="form-group col-sm-4">
								<label class="form-label">1.항혈전제 복용</label> <input
									type="checkbox" name="uConList[0].conNm" value="항혈전제 복용" /> <input
									type="text" class="uConditionType" name="uConList[0].conDet"
									disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">2.위장장애</label> <input type="checkbox"
									name="uConList[1].conNm" value="위장장애" /> <input type="text"
									class="uConditionType" name="uConList[1].conDet" disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">3.고혈압</label> <input type="checkbox"
									name="uConList[2].conNm" value="고혈압" /> <input type="text"
									class="uConditionType" name="uConList[2].conDet" disabled />
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-4">
								<label class="form-label">4.당뇨병</label> <input type="checkbox"
									name="uConList[3].conNm" value="당뇨병" /> <input type="text"
									class="uConditionType" name="uConList[3].conDet" disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">5.간염</label> <input type="checkbox"
									name="uConList[4].conNm" value="간염" /> <input type="text"
									class="uConditionType" name="uConList[4].conDet" disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">6.결핵</label> <input type="checkbox"
									name="uConList[5].conNm" value="결핵" /> <input type="text"
									class="uConditionType" name="uConList[5].conDet" disabled />
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-4">
								<label class="form-label">7.페니실린 알러지</label> <input
									type="checkbox" name="uConList[6].conNm" value="페니실린 알러지" /> <input
									type="text" class="uConditionType" name="uConList[6].conDet"
									disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">8.감염성</label> <input type="checkbox"
									name="uConList[7].conNm" value="감염성" /> <input type="text"
									class="uConditionType" name="uConList[7].conDet" disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">9.내심막염</label> <input type="checkbox"
									name="uConList[8].conNm" value="내심막염" /> <input type="text"
									class="uConditionType" name="uConList[8].conDet" disabled />
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-4">
								<label class="form-label">10.뇌혈관질환</label> <input
									type="checkbox" name="uConList[9].conNm" value="뇌혈관질환" /> <input
									type="text" class="uConditionType" name="uConList[9].conDet"
									disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">11.심장질환</label> <input type="checkbox"
									name="uConList[10].conNm" value="심장질환" /> <input type="text"
									class="uConditionType" name="uConList[10].conDet" disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">12.만성 신부전(혈액투석)</label> <input
									type="checkbox" name="uConList[11].conNm" value="만성 신부전(혈액투석)" />
								<input type="text" class="uConditionType"
									name="uConList[11].conDet" disabled />
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-4">
								<label class="form-label">13.만성간경화</label> <input
									type="checkbox" name="uConList[12].conNm" value="만성간경화" /> <input
									type="text" class="uConditionType" name="uConList[12].conDet"
									disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">14.천식</label> <input type="checkbox"
									name="uConList[13].conNm" value="천식" /> <input type="text"
									class="uConditionType" name="uConList[13].conDet" disabled />
							</div>
							<div class="form-group col-sm-4">
								<label class="form-label">15.기타</label> <input type="checkbox"
									name="uConList[14].conNm" value="기타" /> <input type="text"
									class="uConditionType" name="uConList[14].conDet" disabled />
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-success" onclick="insertQue();"
						style="width: 150px; background: #ff3e3e; border: none;">저장</button>
				<button type="button" class="btn btn-outline-secondary" data-dismiss="modal" style="width: 150px; border: none;">닫기</button>
				<button type="button" class="btn btn-success" style="border: none;" onclick="inputTestQueData();">시연용</button>
			</div>
		</div>
	</div>
</div>
<!-- 기저질환 모달 끝 -->

<script>

// 환자 정보 시연용 버튼
function inputTestPtData(){

	let testForm = document.patientForm;
	testForm.ptNm.value = '이상모';
	testForm.ptRrno1.value = '960401';
	testForm.ptPhone1.value = '010';
	testForm.ptPhone2.value = '2754';
	testForm.ptPhone3.value = '4771';
	testForm.ptZip.value = '34908';
	testForm.ptAddr.value = '대전 중구 계룡로 846';
	testForm.ptAddrDet.value = '405호';

	testForm.prvcPvsnAgreYn.checked = true;
	testForm.smsRcptnAgreYn.checked = true;

}

// 문진표 시연용 버튼
function inputTestQueData(){

	let testForm = document.questionnaireForm;
	testForm.queReason.value = '치아 통증';
	testForm.queWant.value = '충치 치료';
	$('input[name="uConList[2].conNm"]').get(0).checked = true;
	$('input[name="uConList[2].conDet"]').get(0).disabled = false;
	$('input[name="uConList[2].conDet"]').get(0).value = '100/160';
	$('input[name="uConList[3].conNm"]').get(0).checked = true;
	$('input[name="uConList[3].conDet"]').get(0).disabled = false;
	$('input[name="uConList[4].conNm"]').get(0).checked = true;
	$('input[name="uConList[4].conDet"]').get(0).disabled = false;
	$('input[name="uConList[4].conDet"]').get(0).value = 'B형 간염';

}

// 검색창옆 crossBtn을 누르면 창이 초기화된다.
function reset(){
	var ptSearch = document.querySelector("#ptSearch");

	ptSearch.value = null;
}

// 다음 주소찾기 API
function openHomeSearch() {
    new daum.Postcode({
        // 선택 완료 시 데이터를 폼에 담아준다.
        oncomplete : function(data) {
            document.patientForm.ptZip.value = data.zonecode; // 우편번호
            document.patientForm.ptAddr.value = data.address; // 주소
            document.patientForm.ptAddrDet.value = data.buildingName; // 건물주소
        }
    }).open();
}

//풀캘린더 js 시작 -------------------
$(document).ready(function(){
	deskCalendar.render();
	$("#deskCalendar .fc-addEvent-button").css('visibility', 'hidden');
});

// 예약 버튼 클릭시 숨겨진 예약 버튼 클릭... 작업하기 귀차나욤..
$(document).on("click", "#newResv", function(){
	$(".fc-addEvent-button").click();
});

//풀캘린더 js 끝 -------------------

</script>
<!-- 풀캘린더 js 시작 -->
<script src='/resources/fullcalendar-6.1.5/packages/core/index.global.js'></script>
<script src='/resources/fullcalendar-6.1.5/packages/daygrid/index.global.js'></script>
<script src='/resources/fullcalendar-6.1.5/packages/timegrid/index.global.js'></script>
<script src='/resources/fullcalendar-6.1.5/packages/list/index.global.js'></script>
<script src='/resources/fullcalendar-6.1.5/packages/moment/moment.js'></script>
<!-- custom -->
<script src='/resources/fullcalendar-6.1.5/js/deskCalendar.js'></script>
<script src='/resources/fullcalendar-6.1.5/js/addResv.js'></script>
<script src='/resources/fullcalendar-6.1.5/js/setting.js'></script>
<!-- 풀캘린더 js 끝 -->

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>

<script src="/resources/js/searchModule.js"></script>
<script src="/resources/js/deskPatientDetail.js"></script>
<script src="/resources/js/deskPatient.js"></script>
<script src="/resources/js/deskRegist.js"></script>
<script src="/resources/js/alertModule.js"></script>