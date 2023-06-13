package com.web.admin.dao;

import static com.web.common.JDBCTemplate.close;
import static com.web.member.dao.MemberDao.getMember;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import com.web.member.model.vo.Member;


public class AdminDao {
	
	private Properties sql=new Properties();
	
	
	public AdminDao(){ // 기본생성자로 만들어도되고, 초기화블록으로 만들어도됨
		String path=AdminDao.class.getResource("/sql/admin/adminsql.properties").getPath();
		try {
			sql.load(new FileReader(path));
		}catch(IOException e) {
			e.printStackTrace();
		}
	}

	
	   public List<Member> selectMemberAll(Connection conn, int cPage, int numPerpage) {
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      List<Member> result = new ArrayList();
		      try {
		         pstmt = conn.prepareStatement(sql.getProperty("selectMemberAll"));
		         pstmt.setInt(1, (cPage-1)*numPerpage+1);
		         pstmt.setInt(2, cPage*numPerpage);
		         
		         rs = pstmt.executeQuery();
		         while(rs.next()) {
		            result.add(getMember(rs));
		         }
		      } catch(SQLException e) {
		         e.printStackTrace();
		      } finally {
		         close(rs);
		         close(pstmt);
		      } return result;
		   }
		   
		   public int selectMemberCount(Connection conn) {
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      int result = 0;
		      try {
		         pstmt = conn.prepareStatement(sql.getProperty("selectMemberCount"));
		         rs = pstmt.executeQuery();
		         if(rs.next()) {
		            result = rs.getInt(1);
		         }
		      } catch(SQLException e) {
		         e.printStackTrace();
		      } finally {
		         close(rs);
		         close(pstmt);
		      } return result;
		   }

		   
			public List<Member> selectMemberByKeyword(Connection conn, String type, String keyword, int cPage, int numPerPage){
				PreparedStatement pstmt=null;
				ResultSet rs = null;
				String query=sql.getProperty("selectMemberByKeyword");
				query=query.replace("#COL",type);  // properties파일안의 ?에 문자열을 인식시키기위해서 사용
				List<Member> members = new ArrayList();
				try {
					pstmt=conn.prepareStatement(query);
					pstmt.setString(1,type.equals("gender")?keyword:"%"+keyword+"%");
					// type이 성별일때는 % 없이 처리가능하며, 나머지 속성같은경우에는 부분검색이므로 %가 들어감
					pstmt.setInt(2,(cPage-1)*numPerPage+1);
					pstmt.setInt(3, cPage*numPerPage);
					rs=pstmt.executeQuery();
					while(rs.next()) {
						members.add(getMember(rs));
					}
				}catch(SQLException e) {
					e.printStackTrace();
				}finally {
					close(rs);
					close(pstmt);
				}return members;
			}
			
			public int selectMemberByKeywordCount(Connection conn, String type, String keyword) {
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				int result=0;
				String query=sql.getProperty("selectMemberByKeywordCount").replace("#COL", type);
				
				try {
					pstmt=conn.prepareStatement(query);
					pstmt.setString(1,type.equals("gender")?keyword:"%"+keyword+"%");
					rs=pstmt.executeQuery();
					if(rs.next()) {
						result=rs.getInt(1);						
					}
					
				}catch(SQLException e) {
					e.printStackTrace();
				}finally {
					close(rs);
					close(pstmt);
				}return result;
			}
		   
		   
}
