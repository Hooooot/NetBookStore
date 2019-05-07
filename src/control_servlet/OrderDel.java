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
 * Servlet implementation class OrderDel
 */
@WebServlet("/OrderDel")
public class OrderDel extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrderDel() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/plain;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		UserBean user = (UserBean) request.getSession().getAttribute("user");
		String order_ids[] = (String[]) request.getParameterValues("order_ids[]");
		if (user == null) {
			out.println("您尚未登录！");
			return;
		}

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true",
					"member", "123456");

			if (order_ids != null) {
				PreparedStatement ps = null;
				for (String s : order_ids) {
					ps = connection.prepareStatement("delete from book_store.orders where order_id=? ");
					ps.setString(1, s);
					if (ps.executeUpdate() != 1) {
						out.println("false");
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
