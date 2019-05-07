package control_servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java_bean.AdminUserBean;
import java_bean.UserBean;

/**
 * Servlet implementation class LogOut
 */
@WebServlet("/LogOut")
public class LogOut extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogOut() {
        super();
    }

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/html;charset=UTF-8");
		req.setCharacterEncoding("UTF-8");
		PrintWriter out = resp.getWriter();
		UserBean user = (UserBean) req.getSession().getAttribute("user");
		AdminUserBean admin = (AdminUserBean) req.getSession().getAttribute("admin");
		if(admin != null) {
			req.getSession().removeAttribute("admin");
		}
		if(user != null) {
			req.getSession().removeAttribute("user");
		}
		out.println("true");
	}

}
