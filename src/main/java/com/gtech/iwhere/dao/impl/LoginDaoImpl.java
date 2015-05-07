package com.gtech.iwhere.dao.impl;

import org.mybatis.spring.SqlSessionTemplate;

import com.gtech.iwhere.dao.LoginDao;
import com.gtech.iwhere.dao.bean.UserBean;

public class LoginDaoImpl implements LoginDao{

	public SqlSessionTemplate sqlSession = null;

	public SqlSessionTemplate getSqlSession() {
		return sqlSession;
	}

	public void setSqlSession(SqlSessionTemplate sqlSession) {
		this.sqlSession = sqlSession;
	}
	/*
	 * 获取满足查询条件用户数量
	 * */
	@Override
	public Integer selectCountUser(UserBean bean) {
		// TODO Auto-generated method stub
		Integer userCount = sqlSession.selectOne("com.gtech.iwhere.dao.login.selectUser", bean);
		return userCount;
	}
}
