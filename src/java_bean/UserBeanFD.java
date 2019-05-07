package java_bean;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

public class UserBeanFD extends UserBean {
	/**
	 * 
	 */
	private static final long serialVersionUID = -2916501222366460396L;
	
	/**	
	 * enum questions{
	   *     您父亲的姓名(1),
	   *     您母亲的姓名(2),
	   *     您的生日是什么时候(3),
	   *     您毕业于哪所小学(4),
	   *     您高中班主任的名字(5),
	   *     您的宠物叫什么(6)
	}*/
	private byte question;
	private String answer;
	/**
	 * enum states{
	 *	normal(0),
	 *	frozen(1),
	 *	banned(2)
	}*/
	private byte state;
	/**
	 * 输入错误的次数
	 */
	private byte times;
	private Timestamp last_time;
	
	/**
	 * 
	 */
	public UserBeanFD() {
		super();
	}
	
	/**
	 * @param id
	 * @param name
	 * @param password
	 * @param balance
	 */
	public UserBeanFD(int id, String name, String password, double balance) {
		super(id, name, password, balance);
	}
	
	/**
	 * @param question
	 * @param answer
	 * @param state
	 * @param times
	 * @param last_time
	 */
	public UserBeanFD(byte question, String answer, byte state, byte times, Timestamp last_time) {
		super();
		this.question = question;
		this.answer = answer;
		this.state = state;
		this.times = times;
		this.last_time = last_time;
	}
	
	/**
	 * @param id
	 * @param question
	 * @param answer
	 * @param state
	 * @param times
	 * @param last_time
	 */
	public UserBeanFD(int id, byte question, String answer, byte state, byte times, Timestamp last_time) {
		super();
		super.setId(id);
		this.question = question;
		this.answer = answer;
		this.state = state;
		this.times = times;
		this.last_time = last_time;
	}
	
	/**
	 * @param id
	 * @param name
	 * @param password
	 * @param balance
	 * @param question
	 * @param answer
	 * @param state
	 * @param times
	 * @param last_time
	 */
	public UserBeanFD(int id, String name, String password, double balance,byte question, String answer, byte state, byte times, Timestamp last_time) {
		super(id,name,password,balance);
		this.question = question;
		this.answer = answer;
		this.state = state;
		this.times = times;
		this.last_time = last_time;
	}

	public int getQuestion() {
		return question;
	}
	public void setQuestion(byte question) {
		this.question = question;
	}
	public String getAnswer() {
		return answer;
	}
	public void setAnswer(String answer) {
		this.answer = answer;
	}
	public int getState() {
		return state;
	}
	public void setState(byte state) {
		this.state = state;
	}
	public int getTimes() {
		return times;
	}
	public void setTimes(byte times) {
		this.times = times;
	}
	public Timestamp getLast_time() {
		return last_time;
	}
	public void setLast_time(Timestamp last_time) {
		this.last_time = last_time;
	}
	public static Date oneHourBeforeNow() {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, calendar.get(Calendar.HOUR_OF_DAY) - 1);
		return calendar.getTime();
	}
}
