package java_bean;

import java.io.Serializable;
import java.sql.*;

public class BookBean implements Serializable{

	private String ISBN;
	private String book_name;
	private String author;
	private Date pub_date;
	private double price;
	private String publisher;
	private int amount;

	/**
	 * 
	 */
	private static final long serialVersionUID = -6563098497576830247L;
	
	public BookBean() {
	}
	
	

	/**
	 * @param iSBN
	 * @param book_name
	 * @param author
	 * @param pub_date
	 * @param price
	 * @param publisher
	 * @param amount
	 */
	public BookBean(String iSBN, String book_name, String author, Date pub_date, double price, String publisher,
			int amount) {
		super();
		ISBN = iSBN;
		this.book_name = book_name;
		this.author = author;
		this.pub_date = pub_date;
		this.price = price;
		this.publisher = publisher;
		this.amount = amount;
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

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public Date getPub_date() {
		return pub_date;
	}

	public void setPub_date(Date pub_date) {
		this.pub_date = pub_date;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}
	
	

	
/*	static public void main(String arg[]) {
		String context = " 45d       +    879d";
		StringBuilder sbContext = new StringBuilder(context.replaceAll(" +", "%"));
		sbContext.insert(0, '%');
		sbContext.append('%');
		System.out.println(sbContext);
	}*/
}
