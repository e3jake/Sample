<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="org.json.JSONObject"%>
<%!
String getClientIP(HttpServletRequest request) {
  String ip = request.getHeader("X-FORWARDED-FOR");
  if (ip == null || ip.length() == 0) {
    ip= request.getHeader("Proxy-Client-IP");
  }
  if (ip == null || ip.length() == 0) {
    ip= request.getHeader("WL-Proxy-Client-IP");
  }
  if (ip == null || ip.length() == 0) {
    ip= request.getRemoteAddr() ;
  }
  return ip;
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<head>
<body>

<%
    request.setCharacterEncoding("utf-8");
    String team=request.getParameter("TEAM");
    String score=request.getParameter("SCORE");
    String ip=getClientIP(request);

    //out.println("team: "+team+" score: "+score+" ip: "+ip);

    //커넥션 선언

    Connection con = null;
    int n=0;

    try {
        //드라이버 호출, 커넥션 연결
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql?autoReconnect=true&use
SSL=false", "ID", "PASSWD");
        String query = "insert into test(team, score, ip) values(?,?,?)";
    	PreparedStatement pstmt = con.prepareStatement(query);

        pstmt=con.prepareStatement(query);
	pstmt.setString(1,team);
	pstmt.setString(2,score);
        pstmt.setString(3,ip);
	n=pstmt.executeUpdate();

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

<script type="text/javascript">
    if(<%=n%> > 0){
        document.writeln('successs ...');
        location.href="/insert.html";
    }else {
	alert("fail ...");
    }
</script>
</body>
</html>
