package java_bean;

import java.io.Serializable;

public class AdminUserBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5545992636919335669L;
	
	private String name;
	private String password;
	
	public AdminUserBean() {
	}
	
	/*
	 * 管理员用户名、管理员用户密码
	 */
	public AdminUserBean(String name, String password) {
		this.name = name;
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

}
