<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="org.json.simple.JSONObject"%>
<%
    //커넥션 선언
    Connection con = null;

    try {
        //드라이버 호출, 커넥션 연결
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql?autoReconnect=true&useSSL=false", "ID", "PASSWD");

    	  ResultSet rs = null;
        //DB에서 뽑아온 데이터(JSON) 을 담을 객체. 후에 responseObj에 담기는 값
        List barlist = new LinkedList();
 
	      //String query = "select team as TEAM, sum(score) as SCORE from test group by team";
              //특정 IP에서 입력한 데이터값만 추출하기 위한 쿼리
	      String query = "select team as TEAM, sum(score) as SCORE from test where
 ip='10.144.242.119' and team <> '' group by team order by SCORE desc";

	      PreparedStatement pstm = con.prepareStatement(query);
        rs = pstm.executeQuery(query);
        
        //ajax에 반환할 JSON 생성
        JSONObject responseObj = new JSONObject();
        JSONObject barObj = null;
        
	      DecimalFormat f1 = new DecimalFormat("");

    	  while (rs.next()) {
            	String TEAM = rs.getString("TEAM");
            	float SCORE = rs.getFloat("SCORE");
 	    	barObj = new JSONObject();
            	barObj.put("TEAM", TEAM);
            	barObj.put("SCORE", (int)SCORE);
            	barlist.add(barObj);
        } 

        responseObj.put("barlist", barlist);
        out.print(responseObj.toString());
 
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (con != null) {
            try {
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
 
    }
%>

