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

import java_bean.UserBeanFD;

/**
 * Servlet implementation class SetNewPswd
 */
@WebServlet("/SetNewPswd")
public class SetNewPswd extends HttpServlet {
       
    /**
	 * 
	 */
	private static final long serialVersionUID = 1620069321013695338L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public SetNewPswd() {
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
		// TODO do this
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String pswd = request.getParameter("password");
		UserBeanFD fd = (UserBeanFD)request.getSession().getAttribute("fd");
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=utf-8",
					"member", "123456");
			PreparedStatement ps = con.prepareStatement("update users set user_pswd = ?,state = 0,times = 0 where user_id = ? limit 1");
			ps.setString(1, pswd);
			ps.setInt(2, fd.getId());
			if(ps.executeUpdate() == 1) {
				out.println("<script>alert('密码重置成功！');location.href='./Jsp/login.jsp';</script>");
			}else {
				out.println("<script>alert('未知异常，请联系管理员QQ：2446926687！');location.href='./Jsp/new_password.jsp';</script>");
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
