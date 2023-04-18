<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- bootstrap 5 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jquery 3.6.0 -->
<script src="C:/Users/PC-23/Desktop/SPRING/lib/jquery-3.6.0.js"></script>

<!-- icon setting = font awesome -->
<script src="https://kit.fontawesome.com/5f4aa574e8.js" crossorigin="anonymous"></script>

<!-- google font + Gothic font -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gothic+A1:wght@500&family=Noto+Sans+KR:wght@500;700&display=swap" rel="stylesheet">


<!-- Swiper Demo Css, JS setting -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>

<!-- favicon -->
<link rel="icon" type="image/png" sizes="16x16" href="C:/Users/PC-23/Desktop/images/logo/favicon.ico/favicon-16x16.png">

<title>제증명 발급</title>

<style>
    /* headImage Css 설정 */
    html,
    body {
        position: relative;
        height: 100%;
        min-width:1600px;
        background:white;
    }

    .boardHeadImage {
        width: 100%;
        height:150px;
        margin-left: auto;
        margin-right: auto;
    }

    .wrapper{
        position: relative;
        width: 100%;
        height: 100%;
        z-index: 1;
        display: flex;
        box-sizing: content-box;
    }

    .slide {
        text-align: center;
        font-size: 18px;
        background: #fff;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .slide img {
        display: block;
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
     /* Top navbar dropdown css효과 */

     .dropdown:hover .dropdown-menu{
        display:block;
        margin-top:0;
        border:none;
        opacity: 0.85;
    }

    .dropdown{
        margin-left: 3.5rem;
        font-size: 1.05rem;
        font-family: 'Noto Sans KR', sans-serif;
        font-weight: 700;
    }

    /* button css */
    .btn-group{
        display: flex;
        justify-content: center;
        align-items: center;
        width: 50%;
        margin :auto;
        margin-top:50px;
        margin-bottom:50px;
    }

    .categoryBtn{
        width: 200px;
        height: 60px;
        background-color: white;
        color:gray;
        border:1px solid gray;
        font-family: 'Noto Sans KR', sans-serif;
        padding-top:14px;
    }

    .categoryBtn:hover{
        background-color: #ccadff;
        border:1px solid #ccadff;
    }

    .insertBtn{
        background-color: #9d59f0;
        border:none;
        font-family: 'Noto Sans KR', sans-serif;
        font-weight: 500;
        margin-right:35px;
        float:right;
    }

    .reIssueBtn{
        background-color: #9d59f0;
        border:none;
        font-family: 'Noto Sans KR', sans-serif;
        font-weight: 700;
    }
    /* 태그 자체에 css */
    span{
        font-family: 'Noto Sans KR', sans-serif;
    }

    th{
        font-family: 'Noto Sans KR', sans-serif;
        text-align: center;
    }
    td{
        font-family: 'Gothic A1', sans-serif;
        text-align: center;
    }

    .nav-link:hover{
        color:#404b57 !important;
    }

    .listScroll::-webkit-scrollbar{
		 display: none;
	}
	.searchBtn{
		border:1px solid #904aff;
		color:#904aff;
	}
	.searchBtn:hover{
		border:1px solid #7c3dde;
		background:#7c3dde;
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
</style>

<script>
$(function(){
	$(document).on("click",".reIssueBtn",function(){
		console.log("reIssue에 왔다.");

		var docIssueNum = $(this).closest("tr").children().eq(0).text().trim();
		var docName = $(this).closest('tr').children().eq(2).text().trim();
		var ptNum=$("#ptNum").val();

		let paramData = {
				docIssueNum : docIssueNum,
				docName : docName,
				ptNum : ptNum
		}

		let paramString = Object.entries(paramData).map(e => e.join('=')).join('&');
		//entries: paramData=배열, docIssueNum 첫번째에 첫번째 데이터, 두번째에 두번째 데이터를 이어주고 파라미터로 보내준다

		location.href = '/ddit/document/reissuance?' + paramString;
	});

	$(".reIssueBtn").on("click",function(){
		console.log("reIssue에 왔다.");

		var docIssueNum = $(this).closest("tr").children().eq(0).text().trim();
		var docName = $(this).closest('tr').children().eq(2).text().trim();
		var ptNum=$("#ptNum").val();

		let paramData = {
				docIssueNum : docIssueNum,
				docName : docName,
				ptNum : ptNum
		}

		let paramString = Object.entries(paramData).map(e => e.join('=')).join('&');
		//entries: paramData=배열, docIssueNum 첫번째에 첫번째 데이터, 두번째에 두번째 데이터를 이어주고 파라미터로 보내준다

		location.href = '/ddit/document/reissuance?' + paramString;

	});

	$("#detailSearch").on("click",function(){
		let docStartDt=$("#docStartDt").val();
		let docFinalDt=$("#docFinalDt").val();
		let docNumList = [];
		$("input:checkbox[name='docNum']:checked").each(function(index,data){
			docNumList.push(data.value);
		});
		let ptNum=$("#ptNum").val();

		console.log("ptNum:"+ptNum);

		//파라미터 용도 : json데이터
		let data={
				"docNumList":docNumList,
				"docStartDt" : docStartDt,
				"docFinalDt" : docFinalDt,
				"ptNum" : ptNum
				};

		console.log("data : " + JSON.stringify(data));

		$.ajax({
			url: '/ddit/document/checkbox',
			contentType:"application/json;charset:utf-8",
			data:JSON.stringify(data),
			type: 'post',
			dataType: 'json',
			beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success: function(result){
				console.log("result : " + JSON.stringify(result));

				let str="";

				$.each(result,function(index,docVO) {
					str += "<tr>";
					str+="<th class='p-3'>"+docVO.docIssueNum+"</td><br>";
					str+="<th class='p-3'>"+docVO.ptNum+"</td><br>";
					str+="<th class='p-3'>"+docVO.docName+"</td><br>";
					str+="<th class='p-3'>"+docVO.docIssueReason+"</td><br>";
					str+="<th class='p-3'>"+dateFormat(new Date(docVO.docIssueDt))+"</td><br>";
					if(docVO.docName=="원외처방전") {
						str+="<th class='p-3'><input class='btn btn-primary violetBtn reIssueBtn' type='button' value='재발급불가' disabled/></td>"
					} else {
						str+="<th class='p-3'><input class='btn btn-primary violetBtn reIssueBtn' type='button' value='재발급'/></td>"
						str+="<input type='hidden' value='" + docVO.ptNum + "' id='ptNum' name='ptNum'/>";
					}
					str += "</tr>";
				});
	            $("#docSearchlist").html(str);

		},
		error:function(xhr){
			alert("xhr:"+xhr.status);
		}
		});
	});

});

//위에 new Date 함수
function dateFormat(mydate){
	   let month = (mydate.getMonth()+1);
	   month = month < 10 ? "0" + month : month;
	   let day = mydate.getDate();
	   day = day < 10 ? "0" + day : day;

	   return mydate.getFullYear() + "/" + month + "/" + day;
}
</script>

<sec:authentication var="patientVO" property="principal.ptVO"/>

<div class="boardHeadImage">
    <div class="wrapper">
        <div class="slide">
             <img src="/resources/images/layout/ptDocPageHeadImg.png" alt="headImage">
        </div>
    </div>
</div>

<!-- main section 시작 -->
<section class="container">
   <!-- 발급내역 조회 nav 시작 -->
   <div class="row" style="margin-left:7%; margin-top:50px; width:85%; height: 100px; border-top:1px solid gray; border-bottom:1px solid gray;">
      <div class="col-12">
      	<h4 style="margin-left:50px; margin-top: 20px; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">발급내역 조회</h4>
      </div>
      <div class="col-6">
        <h6 style="margin-left:50px;  font-family: 'Noto Sans KR', sans-serif; opacity: 0.5; font-size:14px;">home   >   제증명 발급   >   발급내역 조회</h6>
      </div>
   </div>
   <!-- 발급내역 조회 nav 끝 -->
   <div class="table-responsive">
      <div class="table-wrapper" style="margin-left:7%; width:85%;">
         <div class="card" style="border:none;">
		    <div class="card-body" style="font-family: 'Noto Sans KR', sans-serif; font-weight:700; margin-left:7%;">
			   <div class="row">
				 <div class="col-sm-4">
			    	<label for="docStartDt" style="font-size:1.2rem;">날짜</label>
			    	<br />
			    	<input type="date" id="docStartDt">&nbsp;&nbsp;~&nbsp;&nbsp;<input type="date" id="docFinalDt">
		    	 </div>
		    	<div class="col-sm-5">
					<label for="docNum1" style="font-size:1.2rem;">서류 종류</label>
					<br />
					<label><input type="checkbox" id="docNum1" name="docNum" value="1"> 진단서</label>
				    <label><input type="checkbox" id="docNum2" name="docNum" value="2"> 소견서</label>
				    <label><input type="checkbox" id="docNum3" name="docNum" value="3"> 치료확인서</label><br>
				    <label><input type="checkbox" id="docNum4" name="docNum" value="4"> 향후 치료비 추정서</label>
				    <label><input type="checkbox" id="docNum5" name="docNum" value="5"> CT판독소견서</label>
				    <label><input type="checkbox" id="docNum6" name="docNum" value="6"> 원외처방전</label>
				</div>
				<div class="col-sm-1"></div>
				<div class="col-sm-2">
					<button type="button" id="detailSearch" name="detailSearch" class="btn btn-block btn-outline-secondary searchBtn">상세 조회</button>
				</div>
			  </div>
		    </div>
	     </div>

         <table class="table table-hover" style="margin-bottom:0px;">
             <colgroup>
				<col width="13%">
				<col width="13%">
				<col width="13%">
				<col width="13%">
				<col width="13%">
				<col width="13%">
			</colgroup>
            <thead>
               <tr>
                 <th class="p-3">발급번호</th>
                 <th class="p-3">차트번호</th>
                 <th class="p-3">발급서류</th>
                 <th class="p-3">발급사유</th>
                 <th class="p-3">발급일시</th>
                 <th class="p-3">재발급</th>
                </tr>
             </thead>
           </table>

         <div style="overflow: scroll;overflow-x: hidden; height: 600px;" class="listScroll">
			<table class="table table" style="margin:0px;">
				<col width="13%">
				<col width="13%">
				<col width="13%">
				<col width="13%">
				<col width="13%">
				<col width="13%">
             <tbody id="docSearchlist" style= "font-family: 'Noto Sans KR', sans-serif; font-weight:500; text-align:center;">
	             <c:if test="${fn:length(docList)==0}">
	             	<tr>
	             		<td colspan="6">
	             			<h2 style="text-align: center; font-family: 'Noto Sans KR', sans-serif; font-weight:500;">발급받은 서류내역이 없습니다</h2>
	             		</td>
	             	</tr>
	             </c:if>
                <c:forEach var="documentVO" items="${docList}" varStatus="stat">
                  <tr>
                     <th class="p-3">${documentVO.docIssueNum}</th>
                     <th class="p-3">${documentVO.ptNum}</th>
                     <th class="p-3">
                     	${documentVO.docName}
                     	<input type="hidden" value="${documentVO.docName}" id="docName" name="docName" />
                     </th>
                     <th class="p-3">${documentVO.docIssueReason}</th>
                     <th class="p-3 "><fmt:formatDate value="${documentVO.docIssueDt}" pattern="yyyy/MM/dd"/></th>
                     <th class="p-3"><c:choose>
                     					<c:when test="${documentVO.docName=='원외처방전'}">
                     						<input class="btn btn-primary violetBtn reIssueBtn" type="button" value="재발급불가" disabled="disabled"/>
                    				 		<input type="hidden" value="${patientVO.ptNum}" id="ptNum" name="ptNum"/>
                    				 	</c:when>
                    				 	<c:when test="${documentVO.docName!='원외처방전'}">
                    				 		<input class="btn btn-primary violetBtn reIssueBtn" type="button" value="재발급"/>
                    				 		<input type="hidden" value="${patientVO.ptNum}" id="ptNum" name="ptNum"/>
                    				 	</c:when>
                    				 </c:choose>
                    </th>				 
                  </tr>
               </c:forEach>
             </tbody>
           </table>
         </div>
      </div>
   </div>
</section>
<!-- main section 끝 -->