<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<style>
/* Top navbar dropdown css효과 */
.dropdown:hover .dropdown-menu {
	display: block;
	margin-top: 0;
	border: none;
	opacity: 0.85;
}

.dropdown {
	margin-left: 3.5rem;
	font-size: 1.05rem;
	font-family: 'Noto Sans KR', sans-serif;
}

i {
	cursor: pointer;
}

/* 글씨체 css */
label {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
}

textarea, input, select {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
}

.nav-link:hover {
	color: #404b57 !important;
}
</style>
<!-- Top navbar 시작 -->
<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <a class="navbar-brand" href="/ddit" style="margin-left:21%;">
            <img src="/resources/images/layout/ddit/logo/ptPage_logo.png" alt="Logo">
            <img src="/resources/images/layout/ddit/logo/Topnavbar_logo2.png" alt="Logo">
        </a>
        <!-- 이 버튼 태그가 없으면 오른쪽 끝으로 ul,li가 날아가버림, 화면을 줄이면 버튼이나타남 -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="true" aria-label="Toggle navigation">
            <i class="nav-icon fa-solid fa-bars"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav" style="margin-left:1%;">
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link text-secondary" aria-expanded="false">
                        병원 소개
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/ddit/greeting">대표원장 인사말</a></li>
                        <li><a class="dropdown-item" href="/ddit/pdoctorIntro">의료진 소개</a></li>
                        <li><a class="dropdown-item" href="/ddit/info">이용 안내</a></li>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link text-secondary" type="button" aria-expanded="false" href="/ddit/process">
                        진료 안내
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link text-secondary" aria-expanded="false">
                        예약 / 조회
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/ddit/resv/select">온라인 예약</a></li>
                        <li><a class="dropdown-item" href="/ddit/resv/list">내 예약 조회</a></li>
                        <li><a class="dropdown-item" href="/ddit/checkup">진료내역 조회</a></li>
                        <li><a class="dropdown-item" href="/ddit/receipt">결제내역 조회</a></li>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link text-secondary" aria-expanded="false">
                        제증명 발급
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/ddit/document">발급내역 조회</a></li>
                        <li><a class="dropdown-item" href="/ddit/document/pdocumentLocker">내 서류보관함</a></li>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link text-secondary" aria-expanded="false">
                        커뮤니티/고객센터
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/ddit/notice">공지사항</a></li>
                        <li><a class="dropdown-item" href="/ddit/faq">자주 묻는 질문</a></li>
                        <li><a class="dropdown-item" href="/ddit/inquiry">문의 게시판</a></li>
                        <li><a class="dropdown-item" href="/ddit/community">커뮤니티</a></li>
                    </ul>
                </li>
            </ul>
            <!-- 로그인 안했을 시 -->
			<sec:authorize access="isAnonymous()">
	            <ul class="navbar-nav" style="margin-left:9%;">
	                <li class="nav-item">
	                    <a href="/login"><i class="fa-solid fa-user fa-lg"></i></a>
	                </li>
	                <li class="nav-item" style="margin-left:15px;">
	                    <span style="font-family: 'Noto Sans KR', sans-serif;">로그인 해주세요.</span>
	                </li>
	            </ul>
			</sec:authorize>
            <!-- 로그인 했을 시 -->
			<sec:authorize access="hasRole('ROLE_PT')">
				<sec:authentication var="ptInfo" property="principal.ptVO"></sec:authentication>
				<ul class="navbar-nav" style="margin-left: 10%;">
					<li class="nav-item">
						<form name="logoutForm" action="/ddit/logout" method="post">
							<sec:csrfInput/>
						</form>
						<a href="javascript:void(0);" onclick="javascript:document.logoutForm.submit();">
							<i class="fa-solid fa-right-from-bracket fa-lg"></i>
						</a>
						<a href="/ddit/mypage" style="margin-left: 15px;">
							<i class="fa-solid fa-user fa-lg"></i>
						</a>
					</li>
					<li class="nav-item" style="margin-left: 15px;">
						<span style="font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">${ptInfo.ptNm}님 환영합니다.</span>
					</li>
				</ul>
			</sec:authorize>
        </div>
    </div>
</nav>
<!-- Top navbar 끝 -->
<input type="hidden" id="_csrfToken" value="${_csrf.token}" />