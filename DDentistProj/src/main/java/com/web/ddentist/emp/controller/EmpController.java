package com.web.ddentist.emp.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.web.ddentist.security.AesEncryptionUtil;

@Controller
@RequestMapping("/hospital")
public class EmpController {

	@GetMapping("")
	public String desk() {
		return "redirect:/hospital/desk";
	}

	@GetMapping("/login")
	public String login(HttpServletRequest request, Model model) {

		if(request.getParameterMap().containsKey("error")) {
			model.addAttribute("errMsg", "아이디 또는 비밀번호가 틀렸습니다.");
		}

		Cookie[] cookies = request.getCookies();
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("rememberId")) {
					model.addAttribute("rememberId", AesEncryptionUtil.decrypt(cookie.getValue()));
				}
			}
		}

		return "emp/login";
	}
}
