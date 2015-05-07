package com.gtech.iwhere.service.impl;

import com.gtech.iwhere.dao.LoginDao;
import com.gtech.iwhere.dao.bean.UserBean;
import com.gtech.iwhere.service.LoginService;

public class LoginServiceImpl implements LoginService{
	
	private LoginDao loginDao = null; 
	
	@Override
	public boolean login(UserBean userBean) {
		// TODO Auto-generated method stub
		int count = loginDao.selectCountUser(userBean);
		if (count == 0){
			return false;
		} else {
			return true;
		}
	}

	public LoginDao getLoginDao() {
		return loginDao;
	}

	public void setLoginDao(LoginDao loginDao) {
		this.loginDao = loginDao;
	}

}
