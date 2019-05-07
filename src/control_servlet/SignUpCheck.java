package control_servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.*;

/**
 * Servlet implementation class SignUpCheck
 */
@WebServlet("/SignUpCheck")
public class SignUpCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SignUpCheck() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		byte question = Byte.parseByte(request.getParameter("question"));
		String answer = request.getParameter("answer");
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true", "member", "123456");
			PreparedStatement ps = connection.prepareStatement("select user_id from users where user_name = ? limit 1");
			ps.setString(1, account);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				out.println("此账号已被注册！");
				return;
			}
			
			PreparedStatement pstmt = connection.prepareStatement("insert into users(user_name,user_pswd,question,answer) value(?,?,?,?)");
			pstmt.setString(1, account);
			pstmt.setString(2, password);
			pstmt.setByte(3, question);
			pstmt.setString(4, answer);
			int result = pstmt.executeUpdate();
			if(result == 1) {
				out.println("true");
			}else {
				out.println("注册失败！");
			}
			pstmt.close();
			connection.close();	
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}catch (SQLIntegrityConstraintViolationException e) {
			e.printStackTrace();
		}catch (SQLException e) {
			e.printStackTrace();
		}
	
		
		
	}

}
