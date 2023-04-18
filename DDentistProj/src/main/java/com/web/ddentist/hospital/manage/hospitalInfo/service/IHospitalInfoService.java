package com.web.ddentist.hospital.manage.hospitalInfo.service;

import java.util.List;
import java.util.Map;

import com.web.ddentist.vo.ChairVO;
import com.web.ddentist.vo.CommonCodeVO;
import com.web.ddentist.vo.DepartmentVO;
import com.web.ddentist.vo.HospitalInfoVO;

public interface IHospitalInfoService {
	
	/**
	 * @return 병원기초 정보가 담긴 vo
	 */
	public HospitalInfoVO getHospitalInfo();
	
	/**
	 * @param commGrCd
	 * @return 병원 구분 목록
	 */
	public List<CommonCodeVO> getCommon(String commGrCd);
	
	/**
	 * @return 부서 목록
	 */
	public List<DepartmentVO> deptList();

	/**
	 * @return 체어목록
	 */
	public List<ChairVO> chairList();
	
	
	/**
	 * 체어수정
	 * 
	 * @param param 체어명, 부서코드, 체어 순번
	 * @return 성공 : 1, 실패 : 0
	 */
	public int updateChair(List<ChairVO> param);
	
	/**
	 *  체어 등록
	 * @param vo 체어명, 부서코드
	 * @return 성공 : 1, 실패 : 0
	 */
	public int createChair(List<ChairVO> vo);
	
	/**
	 * 체어 삭제
	 * 
	 * @param param 체어 순번
	 * @return 성공 : 1, 실패 : 0
	 */
	public int deleteChair(List<ChairVO> param);
	
	// 병원정보 수정
	/**
	 * @param hosVO  병원기초 정보가 담긴 vo
	 * @return 성공 : 1, 실패 : 0
	 */
	public int updatePost(HospitalInfoVO hosVO);
}
