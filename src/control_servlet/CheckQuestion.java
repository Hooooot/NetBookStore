package control_servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java_bean.UserBeanFD;

/**
 * Servlet implementation class CheckQuestion
 */
@WebServlet("/CheckQuestion")
public class CheckQuestion extends HttpServlet {
       
    /**
	 * 
	 */
	private static final long serialVersionUID = 1988996406555669147L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public CheckQuestion() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/plain;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		request.getRequestDispatcher("WEB-INF/Jsp/new_password.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		byte qu = Byte.parseByte(request.getParameter("question"));
		String an = request.getParameter("answer");
		UserBeanFD fd = (UserBeanFD)request.getSession().getAttribute("fd");
		
		if(fd.getTimes() >= 3 || fd.getState() == 1) {
			if(fd.getLast_time().before(UserBeanFD.oneHourBeforeNow())) {
				// 如果冻结时间已经过了，那么就先暂时清空次数，恢复帐号状态
				fd.setTimes((byte)0);
				fd.setState((byte)0);
			}else {
				long t = new Date().getTime() - fd.getLast_time().getTime();
				t = t/1000/60;
				out.println("由于您错误次数过多，您的帐号已被冻结一小时！\n目前剩余" +(60 - t) +"分钟");
				return;
			}
		}
		if(qu == fd.getQuestion()&&an.equals(fd.getAnswer())) {
			request.getSession().setAttribute("checkok", "true");
			out.println("true");
		}else {
			
			fd.setTimes((byte) (fd.getTimes() + 1));
			if(fd.getTimes() >= 3) {
				//  如果输入错误超过三次，那么就写入数据库，并且输出提示
				out.println("输入错误！由于您连续输入错误三次，您的帐号已被冻结！");
				fd.setState((byte) 1);
				fd.setLast_time(new Timestamp(new Date().getTime()));
				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
					Connection con = DriverManager.getConnection(
							"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=utf-8",
							"member", "123456");
					PreparedStatement ps = con.prepareStatement("update users set times = 3, State = 1, last_time = now() where user_id = ? limit 1");
					ps.setInt(1, fd.getId());
					if(ps.executeUpdate() != 1) {
						out.println("发生异常！");
					}
					out.close();
					ps.close();
					con.close();
				}catch (ClassNotFoundException e) {
					e.printStackTrace();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}else {
				// 否则输出提示
				out.println("输入错误！请重试！您还有" + (3-fd.getTimes()) +"次机会");
			}
		}
	}
	

}
