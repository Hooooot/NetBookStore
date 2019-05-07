package control_servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java_bean.AdminUserBean;

/**
 * Servlet implementation class AdminLoginCheck
 */
@WebServlet("/AdminLoginCheck")
public class AdminLoginCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminLoginCheck() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true", account, password);
			AdminUserBean adminUserBean = new AdminUserBean();
			adminUserBean.setName(account);
			adminUserBean.setPassword(password);
			request.getSession().setAttribute("admin", adminUserBean);
			connection.close();
			response.sendRedirect(path + "/Jsp/management.jsp");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			if(e.getMessage().contains("Access denied for user")) {
				request.getSession().setAttribute("login", "block");
				response.sendRedirect(path + "/Jsp/admin_login.jsp");
			}
			
		}catch (Exception e) {

			e.printStackTrace();
		}
		
	}
}
