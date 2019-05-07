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


/**
 * Servlet implementation class UpdateCart
 */
@WebServlet("/UpdateCart")
public class UpdateCart extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateCart() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		int cart_id = Integer.parseInt(request.getParameter("cart_id"));
		int amount = Integer.parseInt(request.getParameter("amount"));

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true",
					"member", "123456");
			PreparedStatement ps = connection.prepareStatement("select book_price from book_store.shopping_cart where cart_id=?");
			ps.setInt(1, cart_id);
			ResultSet rs = ps.executeQuery();
			double book_price;
			if (rs.next()) {
				book_price = rs.getDouble("book_price");
			}else {
				book_price = 0;
				out.println("购物车内无此商品！");
				return;
			}
			ps.close();
			ps = connection.prepareStatement("update book_store.shopping_cart set amount=?,total_price=? where cart_id=?");
			ps.setInt(1, amount);
			ps.setDouble(2, amount * book_price);
			ps.setInt(3, cart_id);
			if (ps.executeUpdate() == 1) {
				out.println("true");
			}else {
				out.println("未知错误！");
			}
			ps.close();
			out.close();
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
