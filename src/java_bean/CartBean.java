package java_bean;

import java.io.Serializable;

public class CartBean implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -378474564040877512L;
	private int cartId;
	private String isbn;
	private String book_name;
	private int userId;
	private int amount;
	private double book_price;
	private double total_price;
	
	public CartBean() {
	}

	/*
	 * 购物车ID、书籍ISBN编号、书名、用户ID、书籍数量、书籍单价，总价自动生成
	 */
	public CartBean(int cartId, String isbn,String book_name, int userId, int amount, double book_price) {
		this.cartId = cartId;
		this.isbn = isbn;
		this.book_name = book_name;
		this.userId = userId;
		this.amount = amount;
		this.book_price = book_price;
		this.total_price = book_price * amount;
	}
	
	/*
	 * 购物车ID、书籍ISBN编号、书名、用户ID、书籍数量、书籍单价、书籍总价，全部都有
	 */
	public CartBean(int cartId, String isbn_s,String book_name, int userId, int amount, double book_price, double total_price) {
		this.cartId = cartId;
		this.isbn = isbn_s;
		this.book_name = book_name;
		this.userId = userId;
		this.amount = amount;
		this.book_price = book_price;
		this.total_price = total_price;
	}

	public int getCartId() {
		return cartId;
	}

	public void setCartId(int cartId) {
		this.cartId = cartId;
	}

	public String getIsbn() {
		return isbn;
	}

	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}

	public String getBook_name() {
		return book_name;
	}

	public void setBook_name(String book_name) {
		this.book_name = book_name;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public double getBook_price() {
		return book_price;
	}

	public void setBook_price(double book_price) {
		this.book_price = book_price;
	}

	public double getTotal_price() {
		return total_price;
	}

	public void setTotal_price(double total_price) {
		this.total_price = total_price;
	}
	
	
}
