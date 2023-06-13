package com.web.admin.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.web.admin.service.AdminService;
import com.web.member.model.vo.Member;


@WebServlet("/admin/searchMember")
public class MemberSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
 
    public MemberSearchServlet() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 클라이언트가 보낸 데이터를 기준으로 Member테이블에서 해당하는 데이터를 조회해서 보내줌
		String type=request.getParameter("searchType");
		String keyword=request.getParameter("searchKeyword");
		
		int cPage, numPerPage;
		try {
			cPage=Integer.parseInt(request.getParameter("cPage"));
		}catch(NumberFormatException e) {
			cPage=1;
		}
		try {
			numPerPage=Integer.parseInt(request.getParameter("numPerPage"));
		}catch(NumberFormatException e) {
			numPerPage=5;
		}
		
		List<Member> members = new AdminService().selectMemberByKeyword(type,keyword,cPage,numPerPage);
		
		request.setAttribute("members", members);
		
		String pageBar="";
		int totalData=new AdminService().selectMemberByKeywordCount(type, keyword);
		
		int totalPage=(int)Math.ceil((double)totalData/numPerPage);
		int pageBarSize=5;
		int pageNo=((cPage-1)/pageBarSize)*pageBarSize+1;
		int pageEnd=pageNo+pageBarSize-1;
		
		if(pageNo==1) {  // -> 1~5페이지까지 해당됨
			pageBar+="<span>[이전]</span>";
		}else {  // -> 그 이후부터는 이전페이지를 클릭 가능한 태그를 만들어서 이동할때의 페이지에 값을 넘겨줌
			pageBar+="<a href='"+request.getRequestURI()+"?searchType="+type // 현재페이지에서 이동
					+"&searchKeyword="+keyword //
					+"&cPage="+(pageNo-1)
					+"&numPerPage="+numPerPage+"'>[이전]</a>";
		}
		
		while(!(pageNo>pageEnd||pageNo>totalPage)) {
			if(pageNo==cPage) { 
				pageBar+="<span>"+pageNo+"</span>";
			}else {
						pageBar+="<a href='"+request.getRequestURI()+"?searchType="+type
						+"&searchKeyword="+keyword
						+"&cPage="+pageNo
						+"&numPerPage="+numPerPage+"'>"+pageNo+"</a>";
			}
			pageNo++;
		}
		
		if(pageNo>totalPage) {
			pageBar+="<span>[다음]</span>";  // 다음이 클릭될수없다
		}else {
					pageBar+="<a href='"+request.getRequestURI()+"?searchType="+type
					+"&searchKeyword="+keyword
					+"&cPage="+pageNo
					+"&numPerPage="+numPerPage+"'>[다음]</a>";
		}
		
		request.setAttribute("pageBar", pageBar);
		
		request.getRequestDispatcher("/views/admin/managemember.jsp").forward(request, response);
		
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
