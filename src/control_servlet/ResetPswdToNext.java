package control_servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java_bean.UserBeanFD;

/**
 * Servlet implementation class ResetPswdToNext
 */
@WebServlet("/ResetPswdToNext")
public class ResetPswdToNext extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ResetPswdToNext() {
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
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String wd = request.getParameter("username");
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=utf-8",
					"member", "123456");
			PreparedStatement ps = con.prepareStatement("select user_id,question,answer,state,times,last_time from users where user_name = ? limit 1");
			ps.setString(1, wd);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				UserBeanFD fd = new UserBeanFD(rs.getInt(1),rs.getByte(2),rs.getString(3),rs.getByte(4),rs.getByte(5),rs.getTimestamp(6));
				if(fd.getState() == 2) {
					out.println("您的帐号已被永久封停！");
					return;
				}
				if(fd.getLast_time() == null) {
					request.getSession().setAttribute("fd", fd);
					out.println("true");
				}else if(fd.getLast_time().before(UserBeanFD.oneHourBeforeNow())) {
					request.getSession().setAttribute("fd", fd);
					out.println("true");
				}else {
					long t = new Date().getTime() - fd.getLast_time().getTime();
					t = t/1000/60;
					out.println("账号：" + wd + "&nbsp;&nbsp;&nbsp;已被冻结，目前剩余" +(60 - t) +"分钟！请稍后再试！");
				}
			}else {
				out.println("账号：" + wd + "&nbsp;&nbsp;&nbsp;s尚未被注册！");
			}
			out.close();
			rs.close();
			ps.close();
			con.close();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
