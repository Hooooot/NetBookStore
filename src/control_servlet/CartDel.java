package control_servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java_bean.UserBean;

/**
 * Servlet implementation class CartDel
 */
@WebServlet("/CartDel")
public class CartDel extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -593107295946231272L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CartDel() {
		super();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/plain;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		UserBean user = (UserBean) request.getSession().getAttribute("user");
		String cart = request.getParameter("id");
		String cart_ids[] = (String[]) request.getParameterValues("cart_ids[]");
		if (user == null) {
			out.println("您尚未登录！");
			return;
		}

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true",
					"member", "123456");

			if (cart != null) {
				int cart_Id = Integer.parseInt(cart);

				PreparedStatement ps = connection
						.prepareStatement("delete from book_store.shopping_cart where cart_id=?");
				ps.setInt(1, cart_Id);
				if (ps.executeUpdate() == 1) {
					out.println("true");
				}
				ps.close();
			} else if (cart_ids != null) {
				PreparedStatement ps = null;
				for (String s : cart_ids) {
					if (s != null) {
						int cart_id = Integer.parseInt(s);
						ps = connection.prepareStatement("delete from book_store.shopping_cart where cart_id=? ");
						ps.setInt(1, cart_id);
						if (ps.executeUpdate() != 1) {
							out.println("false");
						}
					}
				}
				ps.close();
				out.println("true");
			}
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
