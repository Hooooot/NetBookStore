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
 * Servlet implementation class AddToCart
 */
@WebServlet("/AddToCart")
public class AddToCart extends HttpServlet {
       
    /**
	 * 
	 */
	private static final long serialVersionUID = 942193026817075594L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public AddToCart() {
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
		if(user == null) {
			response.sendRedirect(path + "/Jsp/login.jsp");
			return;
		}
		
		String isbn = request.getParameter("ISBN");
		double price;
		String book_name;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true", "member", "123456");
			
			PreparedStatement ps = connection.prepareStatement("select * from book_store.shopping_cart where ISBN = ? and user_id = ?");
			ps.setString(1, isbn);
			ps.setInt(2, user.getId());
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				ps =  connection.prepareStatement("update book_store.shopping_cart set amount = ?, total_price = ? where ISBN = ? and user_id = ?");
				price = rs.getDouble("book_price");
				ps.setInt(1, rs.getInt("amount") + 1);
				ps.setDouble(2, price * (rs.getInt("amount") + 1));
				ps.setString(3, isbn);
				ps.setInt(4, user.getId());
				if(ps.executeUpdate() == 1) {
					out.println("true");
				}else {
					out.println("由于未知错误，添加失败！");
				}
				connection.close();
				ps.close();
				rs.close();
				return;
			}
			rs.close();
			ps.close();
			ps = connection.prepareStatement("select * from books where ISBN = ?");
			ps.setString(1, isbn);
			rs = ps.executeQuery();
			if(!rs.next()) {
				out.println("此书可能已被下架，添加失败！");
				out.close();
				connection.close();
				ps.close();
				rs.close();
				return;
			}
			price = rs.getDouble("price");
			book_name = rs.getString("book_name");
			rs.close();
			ps.close();
			ps = connection.prepareStatement("insert into book_store.shopping_cart values(default,?, ?, ?,default,?,?);");
			ps.setString(1, isbn);
			ps.setString(2, book_name);
			ps.setInt(3, user.getId());
			ps.setDouble(4, price);
			ps.setDouble(5, price);
			if(ps.executeUpdate()==1) {
				out.println("true");
			}else {
				out.println("未知错误！");
			}
			connection.close();
			ps.close();
			rs.close();
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


