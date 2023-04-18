package com.web.ddentist.hospital.manage.empInfo.service;

import java.util.List;

import com.web.ddentist.vo.DrugVO;
import com.web.ddentist.vo.PurchaseVO;


public interface IDrugService {

	//발주 약품 검색
	List<DrugVO> showMd(String keyword);

	//발주 추가
	public int purchase(PurchaseVO purchaseVO);

	//발주 중인 목록 가져오기
	public PurchaseVO selectPurchase(PurchaseVO purchaseVO);

	/**
	 * 
	 * 발주 중인 목록 가져오기(N건)
	 * 
	 * @param 
	 * @return List<PurchaseVO>
	 */
	public List<PurchaseVO> showPurchasing();
	
	/**
	 * 발주 중인 발주 건 취소
	 * 
	 * @param purchaseVO 취소하고자 하는 발주 건의 발주 번호
	 * @return 성공 : "SUCCESS", 실패 : "FAILED"
	 */
	public String cancelPurchase(PurchaseVO purchaseVO);
	
	/**
	 * 
	 * 재고 수량 일괄 변경 및 발주 완료 목록 정렬 후 반환
	 * 
	 * @param purchaseVO
	 * @return List<PurchaseVO>
	 */
	public List<PurchaseVO> updateCount(PurchaseVO purchaseVO);

	/**
	 * 
	 * 발주 완료 목록 초기 데이터 넣어주기(N건)
	 * 
	 * @param 
	 * @return List<PurchaseVO>
	 */
	public List<PurchaseVO> showPurchased();

	/**
	 * 
	 * 재고 수량 일괄 변경 및 발주 중 목록 가져오기
	 * 
	 * @param purchaseVO
	 * @return List<PurchaseVO>
	 */
	List<PurchaseVO> reupdateCount(PurchaseVO purchaseVO);

//	<!-- 발주 기간 목록 가져오기 -->
//	<select id="purchasePeriod" parameterType="purchaseVO" resultType="PurchaseVO">
	List<PurchaseVO> purchasePeriod(PurchaseVO purchseVO);

}
