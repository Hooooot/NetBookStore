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

import java_bean.UserBean;

/**
 * Servlet implementation class Pay
 */
@WebServlet("/Pay")
public class Pay extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Pay() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
		
		String orderId = request.getParameter("orderid");
		UserBean user = (UserBean) request.getSession().getAttribute("user");
		if(request.getParameter("userid") == null || user==null) {
			out.println("<script language='javascript'>alert('请先登录！');"
					+ "window.location.href='" + path + "/Jsp/order.jsp';</script>");
		}
		int user_id =  Integer.parseInt(request.getParameter("userid"));
		if(user.getId() != user_id) {
			out.println("<script language='javascript'>alert('用户账号异常！');"
					+ "window.location.href='" + path + "/Jsp/order.jsp';</script>");
			return;
		}
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true",
					"member", "123456");
			PreparedStatement ps = connection.prepareStatement("select total_price,state,user_id from book_store.orders where order_id=? ");
			ps.setString(1, orderId);
			ResultSet rs = ps.executeQuery();
			double price = 0.0;
			if(rs.next()) {
				if(rs.getInt("user_id") != user_id) {
					out.println("<script language='javascript'>alert('用户账号异常！');"
							+ "window.location.href='" + path + "/Jsp/order.jsp';</script>");
					return;
				}
				if(!rs.getString("state").equals("未支付")) {
					out.println("<script language='javascript'>alert('订单状态异常！');"
							+ "window.location.href='" + path + "/Jsp/order.jsp';</script>");
					return;
				}
				price = rs.getDouble("total_price");
			}
			if(price > user.getBalance()) {
				out.println("<script language='javascript'>alert('账号余额不足！');"
						+ "window.location.href='" + path + "/Jsp/order.jsp';</script>");
				return;
			}
			ps = connection.prepareStatement("UPDATE `book_store`.`users` SET `balance` = ? WHERE (`user_id` = ?)");
			ps.setDouble(1, user.getBalance() - price);
			ps.setInt(2, user_id);
			if(ps.executeUpdate() == 1) {
				user.setBalance(user.getBalance() - price);
				ps = connection.prepareStatement("UPDATE `book_store`.`orders` SET `state` = ? WHERE (`order_id` = ?)");
				ps.setString(1, "已支付");
				ps.setString(2, orderId);
				if(ps.executeUpdate() == 1) {
					out.println("<script language='javascript'>alert('支付成功！');"
							+ "window.location.href='" + path + "/Jsp/order.jsp';</script>");
				}
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
