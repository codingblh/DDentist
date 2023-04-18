package com.web.ddentist.vo;

import java.util.List;

import lombok.Data;

@Data
public class EmployeeVO {
	
	private String empNum;
	private String empNm;
	private String jbgdCd;
	private String deptCd;
	private String doctLn;
	private int hdofYn;
	private String empPhone;
	private String empBrdt;
	private String empZip;
	private String empAddr;
	private String empDaddr;
	private String empJncmpYmd;
	private String empRtrmYmd;
	private String empId;
	private String empPw;
	private String empImg;
	
	private List<EmployeeAuthrtVO> authList;
	
	private int resvCount;
	
	public EmployeeVO (){
		this.hdofYn = 1;
	}
}
