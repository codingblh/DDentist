package com.web.ddentist.ddit.pcheckup.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.web.ddentist.ddit.pcheckup.service.PcheckupService;
import com.web.ddentist.patient.service.PatientDetails;
import com.web.ddentist.vo.CheckupVO;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@PreAuthorize("hasRole('ROLE_PT')")
@Controller
@RequestMapping("/ddit/checkup")
public class PcheckupController {
	
	@Autowired
	PcheckupService pcheckupService;
	
	/**
	 * 로그인 한 환자의 진료 내역 정보 페이지
	 * @param model 기본 오늘부터 일주일 전까지의 기간의 진료내역List 정보
	 * @return 
	 */
	@GetMapping("")
	public String home(Model model) {
		//환자 정보 
		PatientDetails ptInfo = (PatientDetails)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String ptNum = ptInfo.getPtVO().getPtNum();
		 	
		Map<String, String> map = new HashMap<>();
		map.put("ptNum", ptNum);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar c = Calendar.getInstance();
		c.add(c.DATE, +1);
		String today = sdf.format(c.getTime());
		c.add(c.DATE, -7);
		String stDate = sdf.format(c.getTime());
		
		map.put("eDate", today);
		map.put("sDate", stDate);
		List<CheckupVO> checkupList = this.pcheckupService.pCheckupList(map);
		
		model.addAttribute("checkupList", checkupList);
		
		return "ddit/checkupList";
	}
	
	/**
	 * 진료내역 상세정보 페이지 이동
	 * @param model
	 * @param checkupVO 선택한 진료내역의 PK checkNum
	 * @return 해당 진료내역의 처치List, 영상List, 처방약품 List
	 */
	@GetMapping("/detail")
	public String detail(Model model,
			@ModelAttribute CheckupVO checkupVO) {
		checkupVO = this.pcheckupService.detailCheckup(checkupVO);
		model.addAttribute("checkupVO", checkupVO);
		return "ddit/checkupDetail";
	}
	
	/**
	 * 검색 날짜 변경시 해당 기간의 진료내역
	 * @param map 시작 날짜, 끝 날짜
	 * @return 날짜에 해당하는 CheckupVO List 반환
	 */
	@ResponseBody
	@GetMapping("/searchCheckup")
	public List<CheckupVO> searchCheckup(@RequestParam Map<String, String> map){
		PatientDetails ptInfo = (PatientDetails)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String ptNum = ptInfo.getPtVO().getPtNum();
		map.put("ptNum", ptNum);	
		return this.pcheckupService.pCheckupList(map);
	}
	
	
}
