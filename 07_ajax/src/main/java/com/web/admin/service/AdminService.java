package com.web.admin.service;
import static com.web.common.JDBCTemplate.*;

import java.sql.Connection;
import java.util.List;

import com.web.admin.dao.AdminDao;
import com.web.member.model.vo.Member;


public class AdminService {
	
	private AdminDao dao = new AdminDao();
	
	public List<Member> selectMemberAll(int cPage, int numPerpage) {
		Connection conn=getConnection();
		List<Member> m = dao.selectMemberAll(conn,cPage,numPerpage);
		close(conn);
		return m;
	}
	
	public int selectMemberCount() {
		Connection conn=getConnection();
		int result = dao.selectMemberCount(conn);
		close(conn);
		return result;
	}
	
	public List<Member> selectMemberByKeyword(String type, String keyword,int cPage, int numPerPage){
		Connection conn=getConnection();
		List<Member> members=dao.selectMemberByKeyword(conn,type,keyword,cPage,numPerPage);
		close(conn);
		return members;
	}
	
	public int selectMemberByKeywordCount(String type, String keyword) {
		Connection conn = getConnection();
		int count=dao.selectMemberByKeywordCount(conn, type, keyword);
		close(conn);
		return count;
	}
	
}
