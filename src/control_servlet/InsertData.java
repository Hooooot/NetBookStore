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
 * Servlet implementation class InsertData
 */
@WebServlet("/InsertData")
public class InsertData extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InsertData() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		AdminUserBean admin = (AdminUserBean)request.getSession().getAttribute("admin");
		String name = request.getParameter("book_name");
		String isbn = request.getParameter("ISBN");
		String author = request.getParameter("author");
		String pub_date = request.getParameter("pub_date");
		String price = request.getParameter("price");
		String publisher = request.getParameter("publisher");
		String amount = request.getParameter("amount");
		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true", admin.getName(), admin.getPassword());
			PreparedStatement ps = connection.prepareStatement("insert into books values(?,?,?,?,?,?,?)");
			ps.setString(1, isbn);
			ps.setString(2, name);
			ps.setString(3, author);
			ps.setString(4, pub_date);
			ps.setDouble(5, Double.parseDouble(price));
			ps.setString(6, publisher);
			ps.setInt(7, Integer.parseInt(amount));
			if(ps.executeUpdate() == 1) {
				request.getSession().setAttribute("insert_success", "true");
				response.sendRedirect(path + "/Jsp/management.jsp");
			}else{
				request.getSession().setAttribute("insert_success", "false");
				response.sendRedirect(path + "/Jsp/management.jsp");
			}		
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

}
