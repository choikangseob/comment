package com.himedia.mc;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	@Autowired signupDAO signupdao;
	@Autowired boardDAO bdao;
	@Autowired commentDAO commentdao;

	@PostMapping("/list")
	@ResponseBody
	public String doList(HttpServletRequest req) {
		int start=0;
		ArrayList<boardDTO> arBoard= bdao.getList(start);
		System.out.println("arBoard size"+arBoard.size());
		JSONArray ja = new JSONArray();
		for(boardDTO bdto : arBoard) {
			JSONObject jo =new JSONObject();
			jo.put("id", bdto.getId());
			jo.put("title", bdto.getTitle());
			jo.put("content", bdto.getContent());
			jo.put("author", bdto.getWriter());
			jo.put("created", bdto.getCreated());
			jo.put("updated", bdto.getUpdated());
			ja.put(jo);
		}
		return ja.toString();
	}
	
	@PostMapping("/listBoard")
	@ResponseBody
	public String listBoard(HttpServletRequest req,Model model) {
		int id = Integer.parseInt(req.getParameter("id"));
		boardDTO a = bdao.getView(id); 
		
		return a.getContent();
	}
	


	@GetMapping("/crud")
	public String crud() {
		return "ajax/crud";
	}
	@PostMapping("/addText")
	@ResponseBody
	public String addText(HttpServletRequest req) {
		HttpSession s = req.getSession();
		String title = req.getParameter("title");
		String writer =(String) s.getAttribute("userid");
		if(writer==null||writer.equals("")) return "redirect:/";
		String content = req.getParameter("content");
		System.out.println("title"+title+"writer"+writer+"content"+content);
		bdao.addtext(title, writer, content);
		return "ok";
	}
	@GetMapping("/")
	public String home(HttpServletRequest req,Model model) {
		HttpSession s = req.getSession();	
		String linkstr = "";
		String newpost="";
		String s2= (String) s.getAttribute("userid");
		if(s2==null||s2.equals("")) {
			linkstr = "<a href='/login'>로그인</a>&nbsp;&nbsp;&nbsp;"+
					  "<a href='/signup'>회원가입</a>";
			newpost="";
		} else {
			linkstr = "사용자 ["+s2+"]&nbsp;&nbsp;&nbsp;"+
					"<a href = 'logout'>로그아웃</a>";
			newpost = "<a href='/write'>새글작성</a>";
		}
		model.addAttribute("linkstr",linkstr);
		model.addAttribute("newpost",newpost);
		String pageno = req.getParameter("p");
		int nowpage=1;
		if(pageno==null||pageno.equals("")) nowpage=1;
		else nowpage = Integer.parseInt(pageno);
		int total =bdao.getCount();
		int pagesize=20;
		int start=(nowpage-1)*pagesize;
		System.out.println("start:"+start);
		int lastpage =(int)Math.ceil((double)total/pagesize);
		System.out.println("lastpage"+lastpage);
		String movestr = "<a href='/?p=1'>처음</a>&nbsp;&nbsp;";
		if(nowpage!=1) {
			movestr+="<a href='/?p="+(nowpage-1)+"'>이전</a>&nbsp;&nbsp;";	
		}
		if(nowpage!=lastpage) {
			movestr+="<a href='/?p="+(nowpage+1)+"'>다음</a>&nbsp;&nbsp;";	
		}
		movestr+="<a href='/?p="+lastpage+"'>마지막</a>";
		System.out.println("movestr ["+movestr+"]");
		
		model.addAttribute("movestr",movestr);
		ArrayList<boardDTO> arBoard= bdao.getList(start);
		System.out.println("size"+arBoard.size());
		model.addAttribute("arBoard",arBoard);
		return "home";			
		}
	@GetMapping("/login")
	public String home1() {
	return "login";
	}
	@PostMapping("/doLogin")
	public String doLogin(HttpServletRequest req,Model model) {
		String userid = req.getParameter("a");
		String passwd = req.getParameter("b");
		int n =signupdao.logMember(userid,passwd);
		if(n==1 ) {
			HttpSession s = req.getSession();
			s.setAttribute("userid",userid);
			System.out.println("userid"+userid);
			return "redirect:/";
		}else {
			return "redirect:/login";
		}
	}
	@GetMapping("/signup")
	public String signup() {
		return "signup";
	}
	@PostMapping("/dosignup")
	public String dosignup (HttpServletRequest req, Model model) {
		String userid = req.getParameter("userid");
		String passwd = req.getParameter("password");
		String realname = req.getParameter("name");
		String birthday = req.getParameter("birthday");
		String gender = req.getParameter("gender");
		String mobile = req.getParameter("mobile");
		String [] favorite = req.getParameterValues("favorite");
		String str="";
		if(favorite!=null) {
		for(int i= 0;i<favorite.length;i++) {
			str +=favorite[i];
		}
		}
		signupdao.getMember(userid,passwd,realname,birthday,gender,mobile,str);
		if(favorite!=null && favorite.length==0||userid.equals("")||passwd.equals("")||realname.equals("")||birthday.equals("")||gender.equals("")||mobile.equals("")) {
		return "/signup";
		}
		return "login";
	}
	@GetMapping("/logout")
	public String logout (HttpServletRequest req) {
		HttpSession s =req.getSession();
		s.invalidate();
		return "redirect:/";
	}
	@GetMapping("/board")
	public String showBoard(HttpServletRequest req) {
		HttpSession s =req.getSession();
		String userid=(String)s.getAttribute("userid");
		if(userid==null||userid.equals("")) {
			return "login";
		}
		return "board";
	}
	@PostMapping("/updateBoard")
	@ResponseBody
	public String updateBoard(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		String title =req.getParameter("title");
		String content =req.getParameter("content"); 
		
		bdao.updateBoard(id,title,content);
		return "ok";
	}
	
	@PostMapping("/deleteBoard")
	@ResponseBody
	public String deleteBoard(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		bdao.deleteBoard(id);
		return "ok";
	}
	
	@GetMapping("/write")
	public String write(HttpServletRequest req, Model model) {
		HttpSession s = req.getSession();
		String userid= (String) s.getAttribute("userid");
		model.addAttribute("userid",userid);
		return "board/write";
	}
	@PostMapping("/save")
	public String save(HttpServletRequest req, Model model) {
		String title=req.getParameter("title");
		String writer = req.getParameter("writer");
		String content = req.getParameter("content");
		bdao.insert(title, writer, content);
		return "redirect:/";
	}
	@GetMapping("/view")
	public String view(HttpServletRequest req, Model model) {
		int id = Integer.parseInt(req.getParameter("id"));
		boardDTO bdto =bdao.getView(id);
		bdao.addHit(id);
		model.addAttribute("board",bdto);
		
		return "board/view";
	}

	@GetMapping("/delete")
	public String delete(HttpServletRequest req) {
		HttpSession s =req.getSession();
		String userid =(String)s.getAttribute("userid");
		if(userid==null||userid.equals("")) {
			return "redirect:/";
		}
		int id = Integer.parseInt(req.getParameter("id"));
		boardDTO bdto =bdao.getView(id);
		if(userid.equals(bdto.getWriter())) {
			bdao.delete(id,userid);
		}
		
		
		return "redirect:/";
	}
	@GetMapping("/update")
	public String update(HttpServletRequest req, Model model) {
		HttpSession s =req.getSession();
		String userid =(String)s.getAttribute("userid");
		if(userid==null||userid.equals("")) {
			return "redirect:/";
		}
		int id = Integer.parseInt(req.getParameter("id"));
		s.setAttribute("id",id);
		boardDTO bdto =bdao.getView(id);
		if(userid.equals(bdto.getWriter())) {
			model.addAttribute("board",bdto);
			return "board/update";
		}else {
			return "redirect:/";
		}
		
	}
	@PostMapping("/modify")
	public String modify(HttpServletRequest req, Model model) {
		int id = Integer.parseInt(req.getParameter("id"));
		String title = req.getParameter("title");
		String content= req.getParameter("content");
		bdao.update(id, title, content);
		return "redirect:/";
	}
	@PostMapping("/comment")
	@ResponseBody
	public String comment(HttpServletRequest req, Model model) {

		int id= Integer.parseInt(req.getParameter("id"));//아이디 뽑아오는거
		String content = req.getParameter("comment");
		String writer = req.getParameter("writer");
		System.out.println("id"+id);
		System.out.println("content"+content);
		System.out.println("writer"+writer);
		commentdao.insert(id,content , writer);
		return "board/view";
	}
	@PostMapping("/commentupdate")
	@ResponseBody
	public String commentupdate(HttpServletRequest req, Model model) {
		int id= Integer.parseInt(req.getParameter("id"));
		String content = req.getParameter("comment");
		
		commentdao.update(id,content);
		return "board/view";
	}
	@PostMapping("/commentdelete")
	@ResponseBody
	public String commentdelete(HttpServletRequest req, Model model) {
		int id= Integer.parseInt(req.getParameter("id"));
			
		commentdao.delete(id);
		return "board/view";
	}
	@PostMapping("/getView")
	@ResponseBody
	public String selecttype(HttpServletRequest req, Model model) {
		
		int id= Integer.parseInt(req.getParameter("id"));
		ArrayList<commentDTO> ar = commentdao.getView(id);
	
		JSONArray ja = new JSONArray();
		for(commentDTO cdto : ar) {
			JSONObject jo =new JSONObject();
			jo.put("id",cdto.getId());
			jo.put("par_id",cdto.getPar_id());
			jo.put("content",cdto.getContent());
			jo.put("writer",cdto.getUserid());
			jo.put("created",cdto.getCreated());
			jo.put("updated",cdto.getUpdated());
			
			ja.put(jo);
			
	}
		return ja.toString();
	}
	@PostMapping("/putreply")
	@ResponseBody
	public String putreply(HttpServletRequest req, Model model) {
		
		int par_id= Integer.parseInt(req.getParameter("id"));//아이디 뽑아오는거
		String content = req.getParameter("content");
		String userid = req.getParameter("userid");
		System.out.println("par_id"+par_id);
		System.out.println("content"+content);
		System.out.println("writer"+userid);
		commentdao.insert1(par_id,content,userid);
		return "board/view";
	}
	@PostMapping("/getView1")
	@ResponseBody
	public String getView1(HttpServletRequest req, Model model) {
		
		int id= Integer.parseInt(req.getParameter("id"));
		System.out.println("id1:"+id);
		ArrayList<commentDTO> ar = commentdao.getView1(id);
	
		JSONArray ja = new JSONArray();
		for(commentDTO cdto : ar) {
			JSONObject jo =new JSONObject();
			jo.put("id",cdto.getId());
			jo.put("par_id",cdto.getPar_id());
			jo.put("content",cdto.getContent());
			jo.put("writer",cdto.getUserid());
			jo.put("created",cdto.getCreated());
			jo.put("updated",cdto.getUpdated());
			
			ja.put(jo);
			
	}
		return ja.toString();
	}
}

