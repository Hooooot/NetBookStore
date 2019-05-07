package control_servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java_bean.BookBean;
import java_bean.UserBean;

/**
 * Servlet implementation class NewOrder
 */
@WebServlet("/NewOrder")
public class NewOrder extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NewOrder() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/plain;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		UserBean user = (UserBean) request.getSession().getAttribute("user");
		String am = request.getParameter("amount");
		int amount = 0;
		BookBean book = null;
		if(am == null) {
			out.println("参数异常！");
			return;
		}
		amount = Integer.parseInt(am);
		String ISBN = request.getParameter("ISBN");
		if (user == null) {
			out.println("您尚未登录！");
			return;
		}
		
		// System.currentTimeMillis();  // 13位

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true",
					"member", "123456");
			
			PreparedStatement userPS = connection.prepareStatement("select balance from book_store.users where user_id=?");
			userPS.setInt(1, user.getId());
			ResultSet userRS = userPS.executeQuery();
			while(userRS.next()) {
				user.setBalance(userRS.getDouble(1));
			}
			userPS.close();
			
			PreparedStatement bookPS = connection.prepareStatement("select * from book_store.books where ISBN=?");
			bookPS.setString(1, ISBN);
			ResultSet bookRS = bookPS.executeQuery();
			if(bookRS.next()) {
				book = new BookBean(bookRS.getString(1), bookRS.getString(2), bookRS.getString(3), 
						bookRS.getDate(4), bookRS.getDouble(5), bookRS.getString(6), bookRS.getInt(7));
			}
			if(book == null) {
				out.println("库存中无此本图书！");
				return;
			}
			String state = "已支付";
			PreparedStatement ordersPS = null;
			if(amount>book.getAmount()) {
				out.println("库存不足！无法生成订单！");
				return;
			}
			
			if(user.getBalance() < book.getPrice() * amount) {
				state = "未支付";
			}else {
				user.setBalance(user.getBalance() - book.getPrice() * amount);
			}

			bookPS = connection.prepareStatement("UPDATE `book_store`.`books` SET `amount` = ? WHERE (`ISBN` = ?)");
			bookPS.setInt(1, book.getAmount()-amount);
			bookPS.setString(2, book.getISBN());
			if(bookPS.executeUpdate() != 1) {
				out.println("更新库存失败！");
				return;
			}
				
			ordersPS = connection.prepareStatement("insert into book_store.orders values(?,?, ?, ?, ?, ?, ?, now(),?)");
			ordersPS.setString(1, System.currentTimeMillis() + "" + user.getId() + "" + (int)(Math.random() * 99)); // 最多25位订单ID
			ordersPS.setInt(2, user.getId());
			ordersPS.setString(3, book.getISBN());
			ordersPS.setString(4, book.getBook_name());
			ordersPS.setDouble(5, book.getPrice());
			ordersPS.setInt(6, amount);
			ordersPS.setDouble(7, book.getPrice() * amount);
			ordersPS.setString(8, state);
			if(ordersPS.executeUpdate() != 1) {
				out.println("订单生成出错！");
				return;
			}
			userPS = connection.prepareStatement("UPDATE `book_store`.`users` SET `balance` = ? WHERE (`user_id` = ?)");
			userPS.setDouble(1, user.getBalance());
			userPS.setInt(2, user.getId());
			if(userPS.executeUpdate() != 1) {
				// 扣款出问题了
				out.println("扣款失败！");
				return;
			}
			userPS.close();
			if(state.equals("未支付")) {
				out.println("由于您余额不足，部分订单未支付！请充值后前往订单页继续支付！");
			}else {
				out.println("订单已提交！");
			}
			connection.close();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
}
