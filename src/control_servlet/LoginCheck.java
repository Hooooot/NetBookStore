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
 * Servlet implementation class LoginCheck
 */
@WebServlet("/LoginCheck")
public class LoginCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginCheck() {
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
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
		String isNewWay = request.getParameter("isNewWay"); // 是否使用悬浮窗登录
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=utf-8",
					"member", "123456");
			PreparedStatement pstmt = connection.prepareStatement("select * from users where user_name = ? and user_pswd = ? limit 1");
			pstmt.setString(1, account);
			pstmt.setString(2, password);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()) {
				UserBean user = new UserBean(); 
				user.setName(account);
				user.setPassword(password);
				user.setId(rs.getInt("user_id"));
				user.setBalance(rs.getDouble("balance"));
				request.getSession().setAttribute("user", user);
				if(isNewWay == null) {
					response.sendRedirect(path + "/Jsp/home.jsp");
				}else {
					out.println("true");
				}
			}else {
				if(isNewWay == null) {
					request.getSession().setAttribute("login", "visible");
					response.sendRedirect(path + "/Jsp/login.jsp");
				}else {
					out.printf("密码或用户名错误！");
				}
			}
			rs.close();
			out.close();
			pstmt.close();
			connection.close();	
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	
		
	}

}
