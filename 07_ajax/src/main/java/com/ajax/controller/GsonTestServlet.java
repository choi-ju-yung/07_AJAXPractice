package com.ajax.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.web.admin.service.AdminService;
import com.web.member.model.vo.Member;

@WebServlet("/gsontest.do")
public class GsonTestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public GsonTestServlet() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		
		List<Member> list=new AdminService().selectMemberByKeyword("userId","a",1,30);
		Member m=list.get(0);
		
		//Gson 라이브러리를 이용해서 json 파싱하기
		//Gson클래스를 생성한다.
		Gson gson = new Gson();
		
		//파싱해주는 메소드를 제공 -> toJson(json으로 변경할 객체[,outputStream]);
		response.setContentType("application/json;charset=utf-8");
		/* gson.toJson(m,response.getWriter()); */  // 단일값 gson으로 파싱
		gson.toJson(list,response.getWriter());     // 다중값 gson으로 파싱
		//gson.fromJson(); -> vo 객체로 만들어줌 -> JSON형태로 전송된 데이터를...
		String data=request.getParameter("data");
		Member requestData = gson.fromJson(data,Member.class);  // json데이터를 -> member클래스로 변환
		System.out.println(requestData);
		
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
