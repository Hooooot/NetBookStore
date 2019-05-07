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
 * Servlet implementation class UpdateBalance
 */
@WebServlet("/UpdateBalance")
public class UpdateBalance extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateBalance() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();	
		UserBean user = (UserBean)request.getSession().getAttribute("user");
		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
		double money = 0;
		
		if(user == null) {
			response.sendRedirect(path + "/Jsp/login.jsp");
			return;
		}
		
		String state = request.getParameter("money");
		if(state.equals("其他")) {
			money = Double.parseDouble(request.getParameter("deposit"));
		}else {
			money = Double.parseDouble(state);
		}

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true", "member", "123456");
			
			PreparedStatement ps = connection.prepareStatement("UPDATE `book_store`.`users` SET `balance` = `balance` + ? WHERE (`user_id` = ?)");
			ps.setDouble(1, money);
			ps.setInt(2, user.getId());
			if(ps.executeUpdate() != 1) {
				out.println("<script language='javascript'>alert('充值失败！');window.location.href='" + path + "/Jsp/deposit.jsp';</script>");
			}else {
				user.setBalance(user.getBalance() + money);
				out.println("<script language='javascript'>alert('充值成功！');window.location.href='" + path + "/Jsp/deposit.jsp';</script>");
			}

			connection.close();
			ps.close();
			out.close();
			return;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

}
