package java_bean;

import java.io.Serializable;

public class UserBean implements Serializable{

	private int id;
	private String name;
	private String password;
	private double balance;
	/**
	 * 
	 */
	private static final long serialVersionUID = -1942926165934694569L;
	
	public UserBean() {
	}
	
	/*
	  * 用户ID、用户名、用户密码、用户剩余金额
	 */
	public UserBean(int id, String name, String password, double balance) {
		this.id = id;
		this.name = name;
		this.password = password;
		this.balance = balance;
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
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

	public double getBalance() {
		return balance;
	}

	public void setBalance(double balance) {
		this.balance = balance;
	}
}
