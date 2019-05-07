package java_bean;
import java.sql.*;
import java.io.Serializable;

public class OrderBean implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -5956744341237437652L;
	
	private String order_id;
	private int user_id;
	private String ISBN;
	private String book_name;
	private double book_price;
	private int amount;
	private double total_price;
	private Timestamp create_time;
	private String state;
	
	public OrderBean() {
	}

	public OrderBean(String order_id, int user_id, String iSBN, String book_name, double book_price, int amount,
			double total_price, Timestamp create_time, String state) {
		super();
		this.order_id = order_id;
		this.user_id = user_id;
		ISBN = iSBN;
		this.book_name = book_name;
		this.book_price = book_price;
		this.amount = amount;
		this.total_price = total_price;
		this.create_time = create_time;
		this.state = state;
	}
	
	public String getOrder_id() {
		return order_id;
	}
	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}
	public int getUser_id() {
		return user_id;
	}
	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}
	public String getISBN() {
		return ISBN;
	}
	public void setISBN(String iSBN) {
		ISBN = iSBN;
	}
	public String getBook_name() {
		return book_name;
	}
	public void setBook_name(String book_name) {
		this.book_name = book_name;
	}
	public double getBook_price() {
		return book_price;
	}
	public void setBook_price(double book_price) {
		this.book_price = book_price;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public double getTotal_price() {
		return total_price;
	}
	public void setTotal_price(double total_price) {
		this.total_price = total_price;
	}
	public Timestamp getCreate_time() {
		return create_time;
	}
	public void setCreate_time(Timestamp create_time) {
		this.create_time = create_time;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
}
