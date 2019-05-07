package control_servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java_bean.BookBean;

/**
 * Servlet implementation class Search
 */
@WebServlet("/Search")
public class Search extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Search() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String context = request.getParameter("input_text");
		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
		
		if(context == null) {
			return;
		}
		ArrayList<BookBean> bookList = new ArrayList<>();
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true",
					"member", "123456");
			
			StringBuilder sbContext = new StringBuilder(context.replaceAll(" +", "%"));
			sbContext.insert(0, '%');
			sbContext.append('%');
			
			PreparedStatement psBook = connection.prepareStatement("select * from (select *,concat(ISBN,book_name,author) as ct from book_store.books) as tb where ct like ?");
			psBook.setString(1, sbContext.toString());
			ResultSet rs = psBook.executeQuery();
			if (rs.next()) {
				 //存在记录 rs就要向上移一条记录 因为rs.next会滚动一条记录了
				 rs.previous();
			}else {
				out.println("<script language='javascript'>alert('搜索结果为空！');"
							+ "window.location.href='" + path + "/Jsp/home.jsp';</script>");
				return;
			}
			while(rs.next()) {
				BookBean book = new BookBean(rs.getString(1),rs.getString(2),rs.getString(3),rs.getDate(4),
						rs.getDouble(5),rs.getString(6),rs.getInt(7));
				bookList.add(book);
			}
			request.getSession().setAttribute("searchBookList", bookList);
			String res = java.net.URLEncoder.encode(context,   "utf-8"); 
			response.sendRedirect(path + "/Jsp/search.jsp?context=" + res);
			
			out.close();
			connection.close();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
