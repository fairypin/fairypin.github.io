package com.gtech.iwhere.dao;

import com.gtech.iwhere.dao.bean.UserBean;

public interface LoginDao {
	public Integer selectCountUser(UserBean bean);
}
