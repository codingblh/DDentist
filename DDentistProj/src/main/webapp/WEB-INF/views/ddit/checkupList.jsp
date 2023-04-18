<%@page import="com.web.ddentist.vo.CheckupVO"%>
<%@page import="com.web.ddentist.vo.TxVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
.detailBtn {
	background-color: #9d59f0;
	border: none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
	border-radius: 30px;
}

#searchBtn {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
	background-color: #9d59f0;
	border: none;
	margin-left: 10px;
}
/* 태그 자체에 css */
span {
	font-family: 'Noto Sans KR', sans-serif;
}

label, input, th {
	font-family: 'Noto Sans KR', sans-serif;
	text-align: center;
}

td {
	font-family: 'Gothic A1', sans-serif;
	text-align: center;
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
}
</style>
<!-- Head Image 시작 -->
<div class="boardHeadImage">
	<div class="wrapper">
		<div class="slide">
			<img src="/resources/images/layout/ddit/checkupListHeadImg.png" />
		</div>
	</div>
</div>
<!-- Head Image 끝 -->

<!-- main section 시작 -->
<section class="container">
	<!-- 진료내역 조회 nav 시작 -->
	<div class="row" style="margin-left: 7%; margin-top: 50px; width: 85%; height: 100px; border-top: 1px solid gray; border-bottom: 1px solid gray;">
		<div class="col-12">
			<h4 style="margin-left: 50px; margin-top: 20px; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">진료내역 조회</h4>
		</div>
		<div class="col-6">
			<h6 style="margin-left: 50px; font-family: 'Noto Sans KR', sans-serif; opacity: 0.5; font-size: 14px;">home > 예약 / 조회 > 진료내역 조회</h6>
		</div>
	</div>
	<!-- 진료내역 조회 nav 끝 -->
	<div class="table-responsive">
		<div class="table-wrapper" style="margin-left: 7%; width: 85%;">
			<div class="row" style="margin: 20px;">
				<div class="col-sm-5"></div>
				<div class="col-sm-7" style="text-align: right;">
					<label class="col-form-label" for="startDate">시작일</label>
					<input type="date" id="startDate" />
					<span> ~ </span>
					<label class="col-form-label" for="lastDate">종료일</label>
					<input type="date" id="lastDate"/>
					<input type="button" class="col-sm-3 btn btn-primary violetBtn" onclick="searchCheckup();"
							id="searchBtn" value="검색" style="width: 20%;" />
				</div>
			</div>
			<table class="table table-hover">
				<thead style="border-top: 1px solid #c2c2c2;">
					<tr>
						<th class="p-3">순번</th>
						<th class="p-3">진료일</th>
						<th class="p-3">치아번호</th>
						<th class="p-3">호소증상</th>
						<th class="p-3">영상여부</th>
						<th class="p-3">상세내역</th>
					</tr>
				</thead>
				<tbody id="checkupListStart">
					<!-- 진료 기록 불러오기 -->


					<c:forEach items="${checkupList}" var="checkupVO" varStatus="stat">
						<tr>
							<th class="p-3">${stat.index + 1}</th>
							<td class="p-3">
								<fmt:formatDate value="${checkupVO.chkDt}" var="dateValue" pattern="yyyy-MM-dd"/>
								${dateValue}
							</td>
							<td class="p-3">
							<c:set value="${checkupVO}" var="chkVO" ></c:set>
								<%
									CheckupVO chkVO = (CheckupVO)pageContext.getAttribute( "chkVO" );
									String toothNumStr = "";
									int comma = 0;
									for(TxVO tooths : chkVO.getTxList() ){
										int index = 0;
										if(comma++ != 0) {
											toothNumStr += ", ";
										}
										String[] toothNum = tooths.getTxToothNum().split(", ");
										for(String tooth : toothNum){
											index++;
											if(toothNum.length == index){
												toothNumStr += "#" + tooth;
											} else {
												toothNumStr += "#" + tooth + ", ";
											}
										}
									}

								%>
								<%= toothNumStr %>
							</td>
							<td class="p-3">
								<c:if test="${checkupVO.regCc == null}">
									호소증상이 없습니다.
								</c:if>
								<c:if test="${checkupVO.regCc != null}">
									${checkupVO.regCc}
								</c:if>
							</td>
							<td class="p-3">${checkupVO.mediaWhether}</td>
							<td class="p-3 ">
								<input class="btn btn-primary detailBtn" id="${checkupVO.chkNum}"
										type="button" value="상세보기" />
							</td>
						</tr>
					</c:forEach>


				</tbody>
			</table>

		</div>
	</div>
</section>
<!-- main section 끝 -->

<script>

// 상세보기 페이지 이동
$(document).on("click", ".detailBtn", function(){
	console.log(this.id);

	location.href="/ddit/checkup/detail?chkNum=" + this.id;
});


// 진료기록 기간 검색
function searchCheckup(){
	var sDate = $("#startDate").val();
	var eDate = new Date($("#lastDate").val());
	var eDateNext = formatDate(eDate.setDate(eDate.getDate() + 1));

	$.ajax({
		url:"/ddit/checkup/searchCheckup?eDate="+eDateNext+"&sDate="+sDate,
		type:"get",
		dataType:"json",
		success:function(res){
			console.log(res);
			var checkupList = "";
			if(res == null || res.length == 0){
				checkupList = '<th class="p-3" colspan = "5">진료기록이 없습니다.</th>';
			} else {
				$.each(res, function(idx, v){
					checkupList += '<tr>';
					checkupList += '	<th class="p-3">' + (idx + 1) + '</th>';
					checkupList += '	<td class="p-3">' + formatDate(v.chkDt) + '</td>';
					checkupList += '	<td class="p-3">';

					if(v.txList != null){
						$.each(v.txList, function(i, txVO){
							if(i != 0){
								checkupList += ", ";
							}
							checkupList += txVO.txToothNum.split(", ").map(num => '#' + num).join(", ");
						});
					};

					checkupList += '	</td>';
					checkupList += '	<td class="p-3">';
					if(v.regCc == null){
						checkupList += '호소증상이 없습니다.';
					} else {
						checkupList += 	v.regCc
					}
					checkupList += '	 </td>';
					checkupList += '	<td class="p-3">' + v.mediaWhether + '</td>';
					checkupList += '	<td class="p-3 ">';
					checkupList += '		<input class="btn btn-primary detailBtn" id="' + v.chkNum + '"';
					checkupList += '				type="button" value="상세보기" />';
					checkupList += '	</td>';
					checkupList += '</tr>';
				});
			}
			$("#checkupListStart").html(checkupList);
		}, error: function(err){
			console.log(err.status);
			simpleJustErrorAlert();
		}
	});
}

// 오늘날짜와 일주일 전 날짜 입력
var today = new Date();
$("#lastDate").val(formatDate(today));
var sdate = today.setDate(today.getDate() - 7);
$("#startDate").val(formatDate(sdate));

//yyyy-mm-dd 포멧
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