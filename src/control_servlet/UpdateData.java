package control_servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java_bean.AdminUserBean;

/**
 * Servlet implementation class UpdateData
 */
@WebServlet("/UpdateData")
public class UpdateData extends HttpServlet {
	
       
    /**
	 * 
	 */
	private static final long serialVersionUID = 6120396996066490039L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateData() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		AdminUserBean admin = (AdminUserBean)request.getSession().getAttribute("admin");
		String isbn = request.getParameter("ISBN");
		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
		
		double price = Double.parseDouble(request.getParameter("price"));		
		int amount = Integer.parseInt(request.getParameter("amount"));
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true", admin.getName(), admin.getPassword());
			PreparedStatement ps = connection.prepareStatement("update book_store.books set price = ?, amount = ? where ISBN = ?");
			ps.setDouble(1, price);
			ps.setInt(2, amount);
			ps.setString(3, isbn);
			if(ps.executeUpdate() != 1) {
				response.sendRedirect(path + "/Jsp/management.jsp");
			}
			connection.close();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

}
