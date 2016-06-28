package ntou.cs.WBSE;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

@WebServlet("/FallingRank")
public class FallingRank extends HttpServlet {
	 
    public FallingRank() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");
		
		String num = request.getParameter("need");
		
		ServletContext sc = getServletContext();
    	String filePath = sc.getRealPath("/WEB-INF/rank.txt");
		RankFile rFile = new RankFile(filePath);
		ArrayList<Grade> glist;
		synchronized(rFile){
			rFile.openFile();
			glist = rFile.readGrades();
			rFile.closeFile();
		}
		
		
		HttpSession session = request.getSession();
		
		if(num.equals("0")){
			String loginID = new String(request.getParameter("loginID").getBytes("ISO-8859-1"), "UTF-8");
			String name = new String(request.getParameter("loginName").getBytes("ISO-8859-1"), "UTF-8");
			User user = new User(loginID, name);
			synchronized(session){
				if(session.getAttribute("user") == null){
					session.setAttribute("user", user);
					String result = "{\"result\":\"OK\"}";
					response.getWriter().println(result);
				}
				else{
					session.removeAttribute("user");
					session.setAttribute("user", user);
					String result = "{\"result\":\"OK\"}";
					response.getWriter().println(result);
				}
			}
			
		}
		
		else if(num.equals("1")){
			Gson gson = new Gson(); 
			String s = gson.toJson(glist);
			response.getWriter().println(s);
		}
		else{
			String id = new String(request.getParameter("id").getBytes("ISO-8859-1"), "UTF-8");
			String name = new String(request.getParameter("name").getBytes("ISO-8859-1"), "UTF-8");
			String score = new String(request.getParameter("score").getBytes("ISO-8859-1"), "UTF-8");
			if(id != null){
				Grade g = new Grade(new User(id, name), Integer.parseInt(score));
				synchronized(rFile){
					rFile.addGrade(g, glist);
				}
				String result = "{\"result\":\"OK\"}";
				response.getWriter().println(result);
			}
		}
		
	}
	

}
