package ntou.cs.WBSE;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FallingServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		String answer = request.getParameter("map");
		MaptoFalling map = new MaptoFalling();
		int c;
		if (answer == null) {
			c = 1;
			answer = "pipeline";
		} else {
			c = Integer.parseInt(answer);
		}
		if (c == 1) {
			map.setSpeed(0.0);
			map.setBackground("pipeline",0);
			map.setObstacle("garbage",0);
		} else if (c == 2) {
			map.setSpeed(1);
			map.setBackground("building",0);
			map.setObstacle("air-conditioner",0);
		} else if (c == 3) {
			map.setSpeed(3);
			map.setBackground("valley",0);
			map.setObstacle("tree",0);
		}
		System.out.println(map);
		request.setAttribute("answer", answer);
		request.setAttribute("map", map);
		RequestDispatcher view = request.getRequestDispatcher("GameStart.jsp");
		view.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	@Override
	public void init() throws ServletException {
		// TODO Auto-generated method stub
		super.init();
		System.out.println("map get");
	}
}
