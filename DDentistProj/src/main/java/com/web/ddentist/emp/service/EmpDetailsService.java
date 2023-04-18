package com.web.ddentist.emp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.web.ddentist.mapper.AccessLogMapper;
import com.web.ddentist.mapper.EmpMapper;
import com.web.ddentist.vo.AccessLogVO;
import com.web.ddentist.vo.EmployeeVO;

public class EmpDetailsService implements UserDetailsService {
	
	@Autowired
	private EmpMapper empMapper;
	@Autowired
	private AccessLogMapper acsLogMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		EmployeeVO empVO = new EmployeeVO();
		empVO.setEmpId(username);
		empVO = empMapper.login(empVO);
		
		AccessLogVO acsLogVO = new AccessLogVO();
		acsLogVO.setLogId(username);
		acsLogVO.setAcntType("EMPLOYEE");
		
		acsLogMapper.insertLog(acsLogVO);
		
		return empVO == null ? null : new EmpDetails(empVO);
	}

}
