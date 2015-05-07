package com.gtech.iwhere.controller.action;

import com.gtech.iwhere.dao.bean.UserBean;
import com.gtech.iwhere.service.LoginService;

public class LoginAction{
	/* 登陆账号 */
	private String loginname = "";
	/* 密码 */
	private String password = "";
	/* 登陆服务*/
	private LoginService loginService = null;
	/*
	 * 用户登陆
	 * */
	public String execute(){
		// 创建查询条件对象
		UserBean userBean = new UserBean();
		loginname = "lfq";
		password = "7712101";
		userBean.setLoginname(loginname);
		userBean.setPassword(password);
		// 判断用户是否存在
		boolean userExsit = loginService.login(userBean);
		if (userExsit){
			return "SUCCESS";
		} else {
			return "FAILURE";
		}
	}
	
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public LoginService getLoginService() {
		return loginService;
	}

	public void setLoginService(LoginService loginService) {
		this.loginService = loginService;
	}
}
