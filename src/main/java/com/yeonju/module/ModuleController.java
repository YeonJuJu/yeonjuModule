package com.yeonju.module;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ModuleController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	

	/*
	 * @Method Name : slider
	 * @Description : 무한 슬라이드
	 * @param		: Model model
	 * @return		: String
	 */
	@RequestMapping(value = "/slider.do", method = RequestMethod.GET)
	public String slider(Model model) {
		return "module/slider";
	}
	
	/*
	 * @Method Name : movableDiv
	 * @Description : 움직이는 div
	 * @param		: Model model
	 * @return		: String
	 */
	@RequestMapping(value = "/movableDiv.do", method = RequestMethod.GET)
	public String movableDiv(Model model) {
		return "module/movableDiv";
	}
}
