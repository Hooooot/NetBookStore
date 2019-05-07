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
import java_bean.CartBean;
import java_bean.UserBean;

/**
 * Servlet implementation class CartToOrder
 */
@WebServlet("/CartToOrder")
public class CartToOrder extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private Connection connection = null;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CartToOrder() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/plain;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		UserBean user = (UserBean) request.getSession().getAttribute("user");
		String cart_ids[] = (String[]) request.getParameterValues("cart_ids[]");
		if (user == null) {
			out.println("您尚未登录！");
			return;
		}
		
		// System.currentTimeMillis();  // 13位

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/book_store?serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true",
					"member", "123456");
			ArrayList<CartBean> cartList = getCartList(cart_ids);
			if(cartList == null) {
				out.println("GG");
			}
			PreparedStatement userPS = connection.prepareStatement("select balance from book_store.users where user_id=?");
			userPS.setInt(1, user.getId());
			ResultSet userRS = userPS.executeQuery();
			while(userRS.next()) {
				user.setBalance(userRS.getDouble(1));
			}
			userPS.close();
			String state = "已支付";
			PreparedStatement ordersPS = null;
			boolean amountEnough = true;
			for(CartBean cat : cartList) {
				
				PreparedStatement bookPS = connection.prepareStatement("select amount from book_store.books where ISBN=?");
				bookPS.setString(1, cat.getIsbn());
				ResultSet bookrs = bookPS.executeQuery();
				int availableAmount = 0;
				if(bookrs.next()) {
					availableAmount = bookrs.getInt(1);
					if(availableAmount < cat.getAmount()) {
						amountEnough = false;
						continue;
					}
				}
				
				if(user.getBalance() < cat.getTotal_price()) {
					state = "未支付";
				}else {
					user.setBalance(user.getBalance() - cat.getTotal_price());
				}
				
				bookPS = connection.prepareStatement("UPDATE `book_store`.`books` SET `amount` = ? WHERE (`ISBN` = ?)");
				bookPS.setInt(1, availableAmount - cat.getAmount());
				bookPS.setString(2, cat.getIsbn());
				if(bookPS.executeUpdate() != 1) {
					out.println("更新失败！");
					return;
				}
				
				ordersPS = connection.prepareStatement("insert into book_store.orders values(?,?, ?, ?, ?, ?, ?, now(),?)");
				ordersPS.setString(1, System.currentTimeMillis() + "" + user.getId() + "" + (int)(Math.random() * 99)); // 最多25位订单ID
				ordersPS.setInt(2, user.getId());
				ordersPS.setString(3, cat.getIsbn());
				ordersPS.setString(4, cat.getBook_name());
				ordersPS.setDouble(5, cat.getBook_price());
				ordersPS.setInt(6, cat.getAmount());
				ordersPS.setDouble(7, cat.getTotal_price());
				ordersPS.setString(8, state);
				if(ordersPS.executeUpdate() != 1) {
					out.println("订单生成出错！");
					return;
				}
				PreparedStatement cartPS = connection.prepareStatement("delete from book_store.shopping_cart where cart_id=?");
				cartPS.setInt(1, cat.getCartId());
				if(cartPS.executeUpdate() != 1) {
					out.println("从购物车删除失败！");
					return;
				}
			}
			userPS = connection.prepareStatement("UPDATE `book_store`.`users` SET `balance` = ? WHERE (`user_id` = ?)");
			userPS.setDouble(1, user.getBalance());
			userPS.setInt(2, user.getId());
			if(userPS.executeUpdate() != 1) {
				// 扣款出问题了
				out.println("扣款失败！");
				return;
			}
			userPS.close();
			if(!amountEnough) {
				out.println("部分商品库存不足，无法为其生成订单！");
			}
			if(state.equals("未支付")) {
				out.println("由于您余额不足，部分订单未支付！请充值后前往订单页继续支付！");
			}else {
				out.println("订单已提交！");
			}

			connection.close();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	protected ArrayList<CartBean> getCartList(String[] cart_ids)  {
		ArrayList<CartBean> cartList = new ArrayList<CartBean>(); 
		try {
			if (cart_ids == null) {
				return null;
			}
			PreparedStatement ps = null;
			for (String s : cart_ids) {
				if (s != null) {
					int cart_id = Integer.parseInt(s);
					ps = connection.prepareStatement("select * from book_store.shopping_cart where cart_id=?");
					ps.setInt(1, cart_id);
					ResultSet rs = ps.executeQuery();
					while(rs.next()) {
						cartList.add(new CartBean(rs.getInt(1),rs.getString(2),rs.getString(3),
								rs.getInt(4),rs.getInt(5),rs.getDouble(6),rs.getDouble(7)));
					}
				}
			}
			ps.close();

		}catch(SQLException e) {
			e.printStackTrace();
		}
		return cartList;
	}

}
