package com.gtech.iwhere.dao.bean;

public class UserBean {
	/* 用户ID */
	Long id = null;
	/* 登陆账号 */
	String loginname = "";
	/* 用户名 */
	String username = "";
	/* 密码 */
	String password = "";
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getLoginname() {
		return loginname;
	}
	public void setLoginname(String loginname) {
		this.loginname = loginname;
	}
}
